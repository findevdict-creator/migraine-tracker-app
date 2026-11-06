import { getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

import { config } from "../config";

import { recordAudit } from "./audit";

/**
 * `auditCounts({...})`: last month's opt-in accuracy counts. Needs App Check
 * but no account, and stores nothing that links the counts to a person: no
 * uid, no IP, an auto id.
 */
export const auditCounts = onCall<unknown, Promise<{ recorded: true }>>(
  { region: config.region, enforceAppCheck: true, memory: "256MiB", maxInstances: 5 },
  async (request) => {
    const col = getFirestore().collection(config.collections.auditCounts);
    try {
      await recordAudit(
        {
          add: async (doc) => {
            await col.add(doc);
          },
        },
        request.data,
        Date.now(),
      );
    } catch (e) {
      if (e instanceof HttpsError) throw e;
      throw new HttpsError("invalid-argument", e instanceof Error ? e.message : "bad payload");
    }
    return { recorded: true };
  },
);
