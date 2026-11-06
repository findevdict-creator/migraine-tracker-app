import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions";
import { defineSecret } from "firebase-functions/params";
import { HttpsError, onRequest } from "firebase-functions/v2/https";

import { config } from "../config";

import { applyEvent, authMatches, hasPremium, parseEvent } from "./entitlements";
import { firestoreEntitlementStore } from "./firestoreStore";

/** The Authorization value configured on the RevenueCat webhook. */
const webhookAuth = defineSecret(config.premium.webhookAuthSecret);

/**
 * RevenueCat webhook. Keeps `entitlements/{uid}` in step with the stores,
 * so Premium-only calls can be checked on the server. Purchases are tied to
 * the Firebase uid by the app (`Purchases.logIn`).
 */
export const revenueCatWebhook = onRequest(
  { region: config.region, secrets: [webhookAuth], memory: "256MiB", maxInstances: 5 },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).end();
      return;
    }
    if (!authMatches(req.get("authorization"), webhookAuth.value())) {
      res.status(401).end();
      return;
    }
    let event;
    try {
      event = parseEvent(req.body);
    } catch {
      res.status(400).end();
      return;
    }
    // A failure here returns 500, so RevenueCat retries the event.
    const result = await applyEvent(firestoreEntitlementStore(getFirestore()), event);
    logger.info("revenuecat event", { type: event.type, result });
    res.status(200).json({ result });
  },
);

/** Throws `permission-denied` unless the account has Premium (or the check is off). */
export async function requirePremium(uid: string): Promise<void> {
  if (!config.premium.enforceOnServer || process.env.FUNCTIONS_EMULATOR === "true") return;
  if (await hasPremium(firestoreEntitlementStore(getFirestore()), uid, Date.now())) return;
  throw new HttpsError("permission-denied", "premium required");
}
