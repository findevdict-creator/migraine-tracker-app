import type { BatchResponse, MulticastMessage } from "firebase-admin/messaging";

import { config } from "../config";

/** The one messaging call the sender needs (real `Messaging` or a fake). */
export interface WakeupSender {
  sendEachForMulticast(message: MulticastMessage): Promise<BatchResponse>;
}

/** Firestore surface for listing and deleting tokens (real or fake). */
export interface TokenLister {
  collection(name: string): {
    get(): Promise<{ docs: { id: string; ref: { delete(): Promise<unknown> } }[] }>;
  };
}

export interface WakeupResult {
  tokens: number;
  sent: number;
  removed: number;
  failed: number;
}

/** FCM error codes that mean the token is dead and should be dropped. */
const DEAD_TOKEN_CODES: ReadonlySet<string> = new Set([
  "messaging/registration-token-not-registered",
  "messaging/invalid-registration-token",
  "messaging/invalid-argument",
]);

/**
 * The silent message. No notification block, so nothing is shown: Android
 * delivers it to the background handler with high priority; iOS gets a
 * background push (`content-available`) at priority 5, which the system
 * throttles by its own budget (see docs/phases/22-push-wakeup.md).
 */
export function wakeupMessage(tokens: string[], now: number): MulticastMessage {
  return {
    tokens,
    data: { type: config.push.wakeupType, sentAt: String(now) },
    android: { priority: "high" },
    apns: {
      headers: { "apns-push-type": "background", "apns-priority": "5" },
      payload: { aps: { "content-available": 1 } },
    },
  };
}

/** Splits into FCM-sized batches. */
export function batches<T>(items: T[], size: number = config.push.batchSize): T[][] {
  const out: T[][] = [];
  for (let i = 0; i < items.length; i += size) out.push(items.slice(i, i + size));
  return out;
}

/**
 * Sends one wake-up to every registered token and deletes the tokens FCM
 * reports as dead. Other failures are counted and left for the next run.
 */
export async function sendWakeups(
  db: TokenLister,
  sender: WakeupSender,
  now: number,
): Promise<WakeupResult> {
  const snapshot = await db.collection(config.collections.pushTokens).get();
  const result: WakeupResult = { tokens: snapshot.docs.length, sent: 0, removed: 0, failed: 0 };
  for (const batch of batches(snapshot.docs)) {
    const response = await sender.sendEachForMulticast(
      wakeupMessage(
        batch.map((d) => d.id),
        now,
      ),
    );
    for (const [i, doc] of batch.entries()) {
      const r = response.responses[i];
      if (r?.success) {
        result.sent++;
      } else if (r?.error && DEAD_TOKEN_CODES.has(r.error.code)) {
        await doc.ref.delete();
        result.removed++;
      } else {
        result.failed++;
      }
    }
  }
  return result;
}
