import {
  backupPrefix,
  createUserDoc,
  onAccountDeleted,
  purgeAccount,
  sweepDeletions,
  type AccountStore,
  type BackupBucket,
  type PurgeDeps,
} from "../src/account/purge";
import { config } from "../src/config";

const HOUR = 60 * 60 * 1000;
const C = config.collections;

/** In-memory collections and bucket, with switches to make them fail. */
class Memory implements AccountStore, BackupBucket {
  readonly docs = new Map<string, Record<string, unknown>>();
  readonly files = new Set<string>();
  failBucket = false;

  setDoc(collection: string, id: string, data: Record<string, unknown>): Promise<void> {
    this.docs.set(`${collection}/${id}`, { ...data });
    return Promise.resolve();
  }
  deleteDoc(collection: string, id: string): Promise<void> {
    this.docs.delete(`${collection}/${id}`);
    return Promise.resolve();
  }
  listDocs(collection: string): Promise<{ id: string; data: Record<string, unknown> }[]> {
    const prefix = `${collection}/`;
    return Promise.resolve(
      [...this.docs.entries()]
        .filter(([path]) => path.startsWith(prefix))
        .map(([path, data]) => ({ id: path.slice(prefix.length), data })),
    );
  }
  deleteWhere(collection: string, field: string, value: string): Promise<number> {
    let n = 0;
    for (const [path, data] of [...this.docs.entries()]) {
      if (path.startsWith(`${collection}/`) && data[field] === value) {
        this.docs.delete(path);
        n++;
      }
    }
    return Promise.resolve(n);
  }
  deleteFiles(prefix: string): Promise<void> {
    if (this.failBucket) return Promise.reject(new Error("storage unavailable"));
    for (const f of [...this.files]) if (f.startsWith(prefix)) this.files.delete(f);
    return Promise.resolve();
  }
}

function setup(start = Date.UTC(2026, 10, 6, 9)): {
  mem: Memory;
  deps: PurgeDeps;
  clock: { t: number };
} {
  const mem = new Memory();
  const clock = { t: start };
  return { mem, clock, deps: { store: mem, bucket: mem, now: () => clock.t } };
}

/** One account with data everywhere, plus a neighbour who must be left alone. */
function seed(mem: Memory): void {
  for (const uid of ["alice", "bob"]) {
    mem.docs.set(`${C.users}/${uid}`, { createdAt: 1 });
    mem.docs.set(`${C.shareSnapshots}/tok-${uid}`, { uid, report: "{}" });
    mem.files.add(`${backupPrefix(uid)}snapshot.bin`);
  }
  // Audit counts are anonymous: no uid, so they are nobody's to purge.
  mem.docs.set(`${C.auditCounts}/anon1`, { month: "2026-10", attacks: 3 });
  // A folder whose name starts with "alice" but is someone else's.
  mem.files.add(`${config.storage.backupsPrefix}/alice2/snapshot.bin`);
}

function aliceLeft(mem: Memory): string[] {
  return [
    ...[...mem.docs.entries()]
      .filter(([path, data]) => path.endsWith("/alice") || data.uid === "alice")
      .map(([path]) => path),
    ...[...mem.files].filter((f) => f.startsWith(backupPrefix("alice"))),
  ];
}

describe("account purge", () => {
  it("creates the users document on sign-up", async () => {
    const { mem, deps } = setup();
    await createUserDoc("alice", deps);
    expect(mem.docs.get(`${C.users}/alice`)).toEqual({ createdAt: deps.now() });
  });

  it("deletes the account's metadata, backup and share snapshots, and nothing else", async () => {
    const { mem, deps } = setup();
    seed(mem);
    await onAccountDeleted("alice", deps);
    expect(aliceLeft(mem)).toEqual([]);
    expect(mem.docs.has(`${C.accountDeletions}/alice`)).toBe(false);
    // Bob and the look-alike folder are untouched.
    expect(mem.docs.has(`${C.users}/bob`)).toBe(true);
    expect(mem.docs.has(`${C.shareSnapshots}/tok-bob`)).toBe(true);
    expect(mem.docs.has(`${C.auditCounts}/anon1`)).toBe(true);
    expect(mem.files.has(`${backupPrefix("bob")}snapshot.bin`)).toBe(true);
    expect(mem.files.has(`${config.storage.backupsPrefix}/alice2/snapshot.bin`)).toBe(true);
  });

  it("is safe to run twice", async () => {
    const { mem, deps } = setup();
    seed(mem);
    await purgeAccount("alice", deps);
    await expect(purgeAccount("alice", deps)).resolves.toBeUndefined();
  });

  it("refuses an id that could widen the storage prefix", async () => {
    const { deps } = setup();
    await expect(purgeAccount("../bob", deps)).rejects.toThrow("unexpected account id");
    await expect(purgeAccount("", deps)).rejects.toThrow();
  });
});

describe("deletion purges within 24 hours", () => {
  it("runs the sweep often enough to retry several times before the deadline", () => {
    expect(config.account.sweepSchedule).toBe(
      `every ${String(config.account.sweepEveryMs / HOUR)} hours`,
    );
    expect(config.account.sweepEveryMs * 4).toBeLessThanOrEqual(config.purgeWithinMs);
  });

  it("a purge that fails at deletion time is finished by the next scheduled sweep", async () => {
    const { mem, deps, clock } = setup();
    seed(mem);
    const deletedAt = clock.t;
    mem.failBucket = true;
    await expect(onAccountDeleted("alice", deps)).rejects.toThrow("storage unavailable");
    // The tombstone survives the failure.
    expect(mem.docs.get(`${C.accountDeletions}/alice`)).toEqual({ requestedAt: deletedAt });

    // Still failing at the first sweep: reported, kept for the next one.
    clock.t += config.account.sweepEveryMs;
    const first = await sweepDeletions(deps);
    expect(first).toEqual({ purged: [], failed: ["alice"], overdue: [] });

    // Storage recovers; the following sweep finishes the job.
    mem.failBucket = false;
    clock.t += config.account.sweepEveryMs;
    const second = await sweepDeletions(deps);
    expect(second.purged).toEqual(["alice"]);
    expect(aliceLeft(mem)).toEqual([]);
    expect(mem.docs.has(`${C.accountDeletions}/alice`)).toBe(false);
    expect(clock.t - deletedAt).toBeLessThan(config.purgeWithinMs);
  });

  it("flags a tombstone older than the deadline so alerting fires", async () => {
    const { mem, deps, clock } = setup();
    mem.docs.set(`${C.accountDeletions}/alice`, { requestedAt: clock.t });
    clock.t += config.purgeWithinMs + 1;
    const result = await sweepDeletions(deps);
    expect(result.overdue).toEqual(["alice"]);
    expect(result.purged).toEqual(["alice"]);
  });
});
