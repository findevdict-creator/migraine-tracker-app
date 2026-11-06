import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { logger } from "firebase-functions";
import * as v1 from "firebase-functions/v1";
import { onSchedule } from "firebase-functions/v2/scheduler";

import { config } from "../config";

import { firestoreAccountStore, storageBackupBucket } from "./adapters";
import { createUserDoc, onAccountDeleted, sweepDeletions, type PurgeDeps } from "./purge";

function deps(): PurgeDeps {
  return {
    store: firestoreAccountStore(getFirestore()),
    bucket: storageBackupBucket(getStorage().bucket()),
    now: Date.now,
  };
}

/** Creates `users/{uid}` when someone signs up. */
export const accountCreated = v1
  .region(config.region)
  .auth.user()
  .onCreate(async (user) => {
    await createUserDoc(user.uid, deps());
  });

/**
 * Purges the server data of a deleted account: its metadata, backup,
 * share snapshots and entitlement. A failure leaves a tombstone for the
 * sweep below. Audit counts carry no uid, so none are tied to the account.
 */
export const accountDeleted = v1
  .region(config.region)
  .auth.user()
  .onDelete(async (user) => {
    try {
      await onAccountDeleted(user.uid, deps());
    } catch (error) {
      logger.error("account purge failed; the sweep will retry", { error: String(error) });
    }
  });

/** Retries unfinished purges well inside the 24-hour promise. */
export const accountPurgeSweep = onSchedule(
  {
    schedule: config.account.sweepSchedule,
    region: config.region,
    memory: "256MiB",
    timeoutSeconds: 300,
    retryCount: 1,
  },
  async () => {
    const result = await sweepDeletions(deps());
    if (result.overdue.length > 0 || result.failed.length > 0) {
      // Alerting watches this line (docs/phases/32-accounts.md).
      logger.error("account purge behind schedule", {
        overdue: result.overdue.length,
        failed: result.failed.length,
      });
    } else {
      logger.info("account purge sweep", { purged: result.purged.length });
    }
  },
);
