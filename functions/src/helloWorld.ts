import { onCall } from "firebase-functions/v2/https";

import { config } from "./config";

/** Body of the hello-world response, kept separate so it can be unit tested. */
export function helloPayload(now: Date = new Date()): { ok: true; region: string; time: string } {
  return { ok: true, region: config.region, time: now.toISOString() };
}

/**
 * Smoke-test function: proves the deploy pipeline, the region and App Check
 * enforcement (callable functions verify the App Check token for us).
 * Removed in the release-prep phase.
 */
export const helloWorld = onCall({ region: config.region, enforceAppCheck: true }, () =>
  helloPayload(),
);
