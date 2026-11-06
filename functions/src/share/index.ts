import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions";
import { HttpsError, onCall, onRequest } from "firebase-functions/v2/https";
import { onSchedule } from "firebase-functions/v2/scheduler";

import { config } from "../config";

import { firestoreShareStore } from "./firestoreStore";
import { createShare, parseCreate, readShare, revokeShare, sweepExpired } from "./share";

function uidOf(auth: { uid: string } | undefined): string {
  if (!auth) throw new HttpsError("unauthenticated", "sign in to share a report");
  return auth.uid;
}

/** `createShareLink({ days, document })` from a signed-in app. */
export const createShareLink = onCall<unknown, Promise<{ token: string; expiresAt: number }>>(
  { region: config.region, enforceAppCheck: true, memory: "256MiB", maxInstances: 10 },
  async (request) => {
    const uid = uidOf(request.auth);
    return createShare(
      firestoreShareStore(getFirestore()),
      uid,
      parseCreate(request.data),
      Date.now(),
    );
  },
);

/** `revokeShareLink({ token })`: deletes the snapshot at once. */
export const revokeShareLink = onCall<unknown, Promise<{ revoked: true }>>(
  { region: config.region, enforceAppCheck: true, memory: "256MiB", maxInstances: 10 },
  async (request) => {
    const uid = uidOf(request.auth);
    const token = (request.data as Record<string, unknown> | null)?.token;
    await revokeShare(firestoreShareStore(getFirestore()), uid, token);
    return { revoked: true };
  },
);

/**
 * `GET /api/share/{token}` through the Hosting rewrite. Returns the report
 * snapshot as JSON for the static share page. Never cached or indexed.
 */
export const shareLinkView = onRequest(
  { region: config.region, memory: "256MiB", maxInstances: 20 },
  async (req, res) => {
    res.set("Cache-Control", "no-store");
    res.set("X-Robots-Tag", "noindex, nofollow");
    res.set("Referrer-Policy", "no-referrer");
    res.set("X-Content-Type-Options", "nosniff");
    if (req.method !== "GET") {
      res.status(405).end();
      return;
    }
    const token = req.path.split("/").filter(Boolean).pop() ?? "";
    const result = await readShare(firestoreShareStore(getFirestore()), token, Date.now());
    if (result.status === 200) {
      res.status(200).json(result.body);
    } else {
      res.status(result.status).json({ error: result.status === 410 ? "expired" : "not_found" });
    }
  },
);

/** Removes expired snapshots in case the TTL policy lags. */
export const shareLinkSweep = onSchedule(
  {
    schedule: config.shareLink.sweepSchedule,
    region: config.region,
    memory: "256MiB",
    timeoutSeconds: 300,
    retryCount: 1,
  },
  async () => {
    const removed = await sweepExpired(firestoreShareStore(getFirestore()), Date.now());
    logger.info("share link sweep", { removed });
  },
);
