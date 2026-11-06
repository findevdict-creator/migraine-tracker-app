import { getFirestore } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import { logger } from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";
import { onSchedule } from "firebase-functions/v2/scheduler";

import { config } from "../config";

import { parseTokenRequest, storeToken } from "./tokens";
import { sendWakeups } from "./wakeup";

/**
 * `registerPushToken({ token, platform })`. App Check enforced; no account
 * needed, since a token identifies a device install, not a person.
 */
export const registerPushToken = onCall<unknown, Promise<{ expiresAt: number }>>(
  {
    region: config.region,
    enforceAppCheck: true,
    memory: "256MiB",
    maxInstances: 10,
  },
  async (request) => {
    const doc = await storeToken(getFirestore(), parseTokenRequest(request.data), Date.now());
    return { expiresAt: doc.expiresAt.getTime() };
  },
);

/**
 * Sends a silent wake-up to every registered device on a schedule. The
 * app's handler refreshes the forecast and re-plans its local alerts.
 */
export const pushWakeup = onSchedule(
  {
    schedule: config.push.schedule,
    region: config.region,
    memory: "256MiB",
    timeoutSeconds: 300,
    retryCount: 1,
  },
  async () => {
    const result = await sendWakeups(getFirestore(), getMessaging(), Date.now());
    logger.info("pushWakeup", result);
  },
);
