import { type Firestore, Timestamp } from "firebase-admin/firestore";

import { config } from "../config";

import type { ShareDoc, ShareStore } from "./share";

/** [ShareStore] over the Admin SDK. */
export function firestoreShareStore(db: Firestore): ShareStore {
  const col = db.collection(config.collections.shareSnapshots);
  return {
    async get(token): Promise<ShareDoc | null> {
      const snap = await col.doc(token).get();
      if (!snap.exists) return null;
      const data = snap.data() as Record<string, unknown>;
      const expiresAt = data.expiresAt;
      return {
        uid: data.uid as string,
        document: data.document as Record<string, unknown>,
        createdAt: data.createdAt as number,
        expiresAt: expiresAt instanceof Timestamp ? expiresAt.toDate() : (expiresAt as Date),
      };
    },
    async set(token, doc): Promise<void> {
      await col.doc(token).set(doc);
    },
    async delete(token): Promise<void> {
      await col.doc(token).delete();
    },
    async expired(now, limit): Promise<string[]> {
      const snap = await col.where("expiresAt", "<=", now).limit(limit).get();
      return snap.docs.map((d) => d.id);
    },
  };
}
