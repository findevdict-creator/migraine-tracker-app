import type { Firestore } from "firebase-admin/firestore";

import { config } from "../config";

import type { Entitlement, EntitlementStore } from "./entitlements";

/** [EntitlementStore] over the Admin SDK: `entitlements/{uid}`. */
export function firestoreEntitlementStore(db: Firestore): EntitlementStore {
  const col = db.collection(config.collections.entitlements);
  return {
    async get(uid): Promise<Entitlement | null> {
      const snap = await col.doc(uid).get();
      if (!snap.exists) return null;
      const d = snap.data() as Record<string, unknown>;
      return {
        expiresAt: typeof d.expiresAt === "number" ? d.expiresAt : null,
        productId: typeof d.productId === "string" ? d.productId : "",
        store: typeof d.store === "string" ? d.store : "",
        environment: typeof d.environment === "string" ? d.environment : "",
        eventAt: typeof d.eventAt === "number" ? d.eventAt : 0,
      };
    },
    async set(uid, e): Promise<void> {
      await col.doc(uid).set(e);
    },
    async delete(uid): Promise<void> {
      await col.doc(uid).delete();
    },
  };
}
