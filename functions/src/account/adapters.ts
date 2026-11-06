import type { Firestore } from "firebase-admin/firestore";
import type { getStorage } from "firebase-admin/storage";

import { config } from "../config";

import type { AccountStore, BackupBucket } from "./purge";

type Bucket = ReturnType<ReturnType<typeof getStorage>["bucket"]>;

/** [AccountStore] over the Admin SDK. */
export function firestoreAccountStore(db: Firestore): AccountStore {
  return {
    async setDoc(collection, id, data): Promise<void> {
      await db.collection(collection).doc(id).set(data);
    },
    async deleteDoc(collection, id): Promise<void> {
      await db.collection(collection).doc(id).delete();
    },
    async listDocs(collection): Promise<{ id: string; data: Record<string, unknown> }[]> {
      const snap = await db.collection(collection).get();
      return snap.docs.map((d) => ({ id: d.id, data: d.data() }));
    },
    async deleteWhere(collection, field, value): Promise<number> {
      let total = 0;
      for (;;) {
        const snap = await db
          .collection(collection)
          .where(field, "==", value)
          .limit(config.account.batchSize)
          .get();
        if (snap.empty) return total;
        const batch = db.batch();
        snap.docs.forEach((d) => batch.delete(d.ref));
        await batch.commit();
        total += snap.size;
      }
    },
  };
}

/** [BackupBucket] over Cloud Storage. */
export function storageBackupBucket(bucket: Bucket): BackupBucket {
  return {
    async deleteFiles(prefix): Promise<void> {
      await bucket.deleteFiles({ prefix, force: true });
    },
  };
}
