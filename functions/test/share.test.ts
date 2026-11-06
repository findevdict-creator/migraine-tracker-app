import { readFileSync } from "node:fs";
import { join } from "node:path";

import { config } from "../src/config";
import {
  createShare,
  isToken,
  newToken,
  parseCreate,
  readShare,
  revokeShare,
  sweepExpired,
  type ShareDoc,
  type ShareStore,
} from "../src/share/share";

const DAY = 24 * 60 * 60 * 1000;
const T0 = Date.UTC(2026, 10, 6, 9);
const doc = { v: 1, title: "Migraine report", blocks: [{ type: "text", text: "3 attacks" }] };

class MemoryShares implements ShareStore {
  readonly docs = new Map<string, ShareDoc>();
  get(token: string): Promise<ShareDoc | null> {
    return Promise.resolve(this.docs.get(token) ?? null);
  }
  set(token: string, d: ShareDoc): Promise<void> {
    this.docs.set(token, d);
    return Promise.resolve();
  }
  delete(token: string): Promise<void> {
    this.docs.delete(token);
    return Promise.resolve();
  }
  expired(now: Date, limit: number): Promise<string[]> {
    return Promise.resolve(
      [...this.docs.entries()]
        .filter(([, d]) => d.expiresAt.getTime() <= now.getTime())
        .slice(0, limit)
        .map(([t]) => t),
    );
  }
}

describe("share link tokens", () => {
  it("are 128 random bits in URL-safe base64", () => {
    let asked = 0;
    const token = newToken((n) => {
      asked = n;
      return Buffer.alloc(n, 0xff);
    });
    expect(asked).toBe(16);
    expect(token).toHaveLength(22);
    expect(isToken(token)).toBe(true);
    expect(token).not.toMatch(/[+/=]/);
  });

  it("do not repeat", () => {
    const seen = new Set(Array.from({ length: 1000 }, () => newToken()));
    expect(seen.size).toBe(1000);
  });

  it("reject anything else", () => {
    for (const bad of ["", "short", "a".repeat(23), "../../users/alice00000", 42, null]) {
      expect(isToken(bad)).toBe(false);
    }
  });
});

describe("creating a link", () => {
  it("accepts only 7 or 30 days and a report document", () => {
    expect(parseCreate({ days: 7, document: doc }).days).toBe(7);
    expect(parseCreate({ days: 30, document: doc }).days).toBe(30);
    for (const days of [0, 1, 14, 365, "7"]) {
      expect(() => parseCreate({ days, document: doc })).toThrow("allowed lifetimes");
    }
    expect(() => parseCreate({ days: 7, document: [] })).toThrow("object");
    expect(() => parseCreate({ days: 7, document: { v: 2, blocks: [] } })).toThrow("unsupported");
    expect(() => parseCreate(null)).toThrow();
  });

  it("refuses a snapshot over the size cap", () => {
    const big = {
      v: 1,
      blocks: [{ type: "text", text: "x".repeat(config.shareLink.maxDocumentBytes) }],
    };
    expect(() => parseCreate({ days: 7, document: big })).toThrow("too large");
  });

  it("stores the snapshot with its owner and expiry", async () => {
    const store = new MemoryShares();
    const { token, expiresAt } = await createShare(store, "alice", { days: 7, document: doc }, T0);
    expect(expiresAt).toBe(T0 + 7 * DAY);
    const stored = store.docs.get(token);
    expect(stored).toEqual({
      uid: "alice",
      document: doc,
      createdAt: T0,
      expiresAt: new Date(T0 + 7 * DAY),
    });
    // Only the snapshot is kept: no raw log fields.
    expect(Object.keys(stored ?? {}).sort()).toEqual(["createdAt", "document", "expiresAt", "uid"]);
  });
});

describe("opening a link", () => {
  it("serves the snapshot until it expires, then deletes it", async () => {
    const store = new MemoryShares();
    const { token } = await createShare(store, "alice", { days: 7, document: doc }, T0);
    expect(await readShare(store, token, T0 + 7 * DAY - 1)).toEqual({
      status: 200,
      body: { document: doc, expiresAt: T0 + 7 * DAY },
    });
    expect(await readShare(store, token, T0 + 7 * DAY)).toEqual({ status: 410 });
    expect(store.docs.has(token)).toBe(false);
    expect(await readShare(store, token, T0 + 7 * DAY)).toEqual({ status: 404 });
  });

  it("answers 404 for unknown and malformed tokens", async () => {
    const store = new MemoryShares();
    expect(await readShare(store, newToken(), T0)).toEqual({ status: 404 });
    expect(await readShare(store, "../users/alice", T0)).toEqual({ status: 404 });
  });
});

describe("revoking a link", () => {
  it("deletes it at once, only for its owner, and is safe to repeat", async () => {
    const store = new MemoryShares();
    const { token } = await createShare(store, "alice", { days: 30, document: doc }, T0);
    await expect(revokeShare(store, "mallory", token)).rejects.toThrow("not your link");
    expect(store.docs.has(token)).toBe(true);
    await revokeShare(store, "alice", token);
    expect(await readShare(store, token, T0)).toEqual({ status: 404 });
    await expect(revokeShare(store, "alice", token)).resolves.toBeUndefined();
    await expect(revokeShare(store, "alice", "nope")).rejects.toThrow("bad token");
  });
});

describe("the sweep", () => {
  it("removes only expired snapshots, across batches", async () => {
    const store = new MemoryShares();
    const n = config.shareLink.sweepBatch + 5;
    for (let i = 0; i < n; i++) await createShare(store, "alice", { days: 7, document: doc }, T0);
    const { token: live } = await createShare(store, "alice", { days: 30, document: doc }, T0);
    expect(await sweepExpired(store, T0 + 8 * DAY)).toBe(n);
    expect([...store.docs.keys()]).toEqual([live]);
  });
});

describe("hosting", () => {
  const root = join(__dirname, "..", "..");

  it("routes the page and the API through Hosting", () => {
    const firebase = JSON.parse(readFileSync(join(root, "firebase.json"), "utf8")) as {
      hosting: {
        rewrites: { source: string; function?: { functionId: string }; destination?: string }[];
      };
    };
    const rewrites = firebase.hosting.rewrites;
    const api = rewrites.find((r) => r.source === "/api/share/**");
    expect(api?.function?.functionId).toBe("shareLinkView");
    expect(rewrites).toContainEqual({ source: "/s/**", destination: "/share.html" });
  });

  it("the share page never parses report text as HTML", () => {
    const js = readFileSync(join(root, "hosting", "share.js"), "utf8");
    expect(js).not.toMatch(/innerHTML|outerHTML|insertAdjacentHTML|document\.write|eval\(/);
    expect(js).toContain("textContent");
  });
});
