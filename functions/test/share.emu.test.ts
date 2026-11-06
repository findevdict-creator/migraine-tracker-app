/**
 * Runs against the Firestore emulator. Proves a link end to end on the real
 * Admin SDK: create, open, revoke, and expiry with the sweep.
 */
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

import { firestoreShareStore } from "../src/share/firestoreStore";
import { createShare, readShare, revokeShare, sweepExpired } from "../src/share/share";

const app = initializeApp({ projectId: "migraine-tracker-rules-test" }, "share-emu-test");
const store = firestoreShareStore(getFirestore(app));
const DAY = 24 * 60 * 60 * 1000;
const T0 = Date.UTC(2026, 10, 6, 9);
const doc = { v: 1, title: "Migraine report", blocks: [{ type: "heading", text: "Overview" }] };

describe("share links on the emulator", () => {
  it("create, open and revoke", async () => {
    const { token, expiresAt } = await createShare(store, "alice", { days: 30, document: doc }, T0);
    expect(expiresAt).toBe(T0 + 30 * DAY);
    const opened = await readShare(store, token, T0 + DAY);
    expect(opened).toEqual({ status: 200, body: { document: doc, expiresAt } });
    await revokeShare(store, "alice", token);
    expect(await readShare(store, token, T0 + DAY)).toEqual({ status: 404 });
  });

  it("expires after its lifetime and the sweep clears the rest", async () => {
    const a = await createShare(store, "bob", { days: 7, document: doc }, T0);
    const b = await createShare(store, "bob", { days: 7, document: doc }, T0);
    const c = await createShare(store, "bob", { days: 30, document: doc }, T0);
    expect(await readShare(store, a.token, T0 + 7 * DAY)).toEqual({ status: 410 });
    expect(await sweepExpired(store, T0 + 8 * DAY)).toBeGreaterThanOrEqual(1);
    expect(await store.get(b.token)).toBeNull();
    expect((await readShare(store, c.token, T0 + 8 * DAY)).status).toBe(200);
  });
});
