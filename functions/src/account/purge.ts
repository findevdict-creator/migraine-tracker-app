import { config } from "../config";

/** The storage the purge needs, so tests can run it in memory. */
export interface AccountStore {
  setDoc(collection: string, id: string, data: Record<string, unknown>): Promise<void>;
  deleteDoc(collection: string, id: string): Promise<void>;
  listDocs(collection: string): Promise<{ id: string; data: Record<string, unknown> }[]>;
  /** Deletes every document whose `field` equals `value`; returns how many. */
  deleteWhere(collection: string, field: string, value: string): Promise<number>;
}

/** The backup bucket: deletes every object under a prefix. */
export interface BackupBucket {
  deleteFiles(prefix: string): Promise<void>;
}

export interface PurgeDeps {
  store: AccountStore;
  bucket: BackupBucket;
  now: () => number;
}

/** Collections keyed by account id. */
const BY_ID = [config.collections.users, config.collections.entitlements] as const;

/** Collections whose documents carry the owner in a `uid` field. */
const BY_OWNER = [config.collections.shareSnapshots, config.collections.auditCounts] as const;

/** The backup folder of one account, with the trailing slash. */
export function backupPrefix(uid: string): string {
  return `${config.storage.backupsPrefix}/${uid}/`;
}

/** Creates the account's metadata document on sign-up. */
export async function createUserDoc(uid: string, deps: PurgeDeps): Promise<void> {
  await deps.store.setDoc(config.collections.users, uid, { createdAt: deps.now() });
}

/**
 * Leaves a tombstone first, so a purge that fails half way is finished by
 * the sweep, then purges at once.
 */
export async function onAccountDeleted(uid: string, deps: PurgeDeps): Promise<void> {
  await deps.store.setDoc(config.collections.accountDeletions, uid, {
    requestedAt: deps.now(),
  });
  await purgeAccount(uid, deps);
  await deps.store.deleteDoc(config.collections.accountDeletions, uid);
}

/** Removes everything the server holds for `uid`. Safe to run twice. */
export async function purgeAccount(uid: string, deps: PurgeDeps): Promise<void> {
  if (!/^[A-Za-z0-9_-]{1,128}$/.test(uid)) {
    // Never let an odd id widen the storage prefix.
    throw new Error("unexpected account id");
  }
  for (const collection of BY_ID) {
    await deps.store.deleteDoc(collection, uid);
  }
  for (const collection of BY_OWNER) {
    await deps.store.deleteWhere(collection, "uid", uid);
  }
  await deps.bucket.deleteFiles(backupPrefix(uid));
}

export interface SweepResult {
  purged: string[];
  failed: string[];
  /** Tombstones older than the deadline when the sweep found them. */
  overdue: string[];
}

/** Finishes every purge that has a tombstone. Runs on a schedule. */
export async function sweepDeletions(deps: PurgeDeps): Promise<SweepResult> {
  const result: SweepResult = { purged: [], failed: [], overdue: [] };
  const tombstones = await deps.store.listDocs(config.collections.accountDeletions);
  for (const { id, data } of tombstones) {
    const requestedAt = typeof data.requestedAt === "number" ? data.requestedAt : 0;
    if (deps.now() - requestedAt > config.purgeWithinMs) result.overdue.push(id);
    try {
      await purgeAccount(id, deps);
      await deps.store.deleteDoc(config.collections.accountDeletions, id);
      result.purged.push(id);
    } catch {
      result.failed.push(id);
    }
  }
  return result;
}
