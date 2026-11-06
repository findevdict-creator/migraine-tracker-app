import { HttpsError } from "firebase-functions/v2/https";

import { config } from "../config";

export type Platform = "android" | "ios";

export interface TokenRequest {
  token: string;
  platform: Platform;
}

/** What is stored per token. No user id: tokens are registered without an account. */
export interface TokenDoc {
  token: string;
  platform: Platform;
  registeredAt: number;
  lastSeenAt: number;
  /** Firestore TTL field. */
  expiresAt: Date;
}

const PLATFORMS: ReadonlySet<string> = new Set(["android", "ios"]);
const MAX_TOKEN_LENGTH = 4096;

/** Validates `{ token, platform }`; throws `invalid-argument` otherwise. */
export function parseTokenRequest(data: unknown): TokenRequest {
  if (typeof data !== "object" || data === null) {
    throw new HttpsError("invalid-argument", "expected { token, platform }");
  }
  const { token, platform } = data as Record<string, unknown>;
  if (typeof token !== "string" || token.length === 0 || token.length > MAX_TOKEN_LENGTH) {
    throw new HttpsError("invalid-argument", "token must be a non-empty string");
  }
  if (!/^[A-Za-z0-9_:-]+$/.test(token)) {
    throw new HttpsError("invalid-argument", "token has unexpected characters");
  }
  if (typeof platform !== "string" || !PLATFORMS.has(platform)) {
    throw new HttpsError("invalid-argument", "platform must be android or ios");
  }
  return { token, platform: platform as Platform };
}

/** Minimal Firestore surface the token store needs (real or fake). */
export interface TokenStore {
  collection(name: string): {
    doc(id: string): {
      get(): Promise<{ exists: boolean; data(): Record<string, unknown> | undefined }>;
      set(data: Record<string, unknown>): Promise<unknown>;
    };
  };
}

/**
 * Upserts the token. `registeredAt` survives re-registration so the age of
 * a device can be read; `lastSeenAt` and the TTL move forward each time.
 */
export async function storeToken(
  db: TokenStore,
  req: TokenRequest,
  now: number,
): Promise<TokenDoc> {
  const ref = db.collection(config.collections.pushTokens).doc(req.token);
  const existing = (await ref.get()).data();
  const previous = existing?.registeredAt;
  const registeredAt = typeof previous === "number" ? previous : now;
  const doc: TokenDoc = {
    token: req.token,
    platform: req.platform,
    registeredAt,
    lastSeenAt: now,
    expiresAt: new Date(now + config.push.tokenTtlMs),
  };
  await ref.set({ ...doc });
  return doc;
}
