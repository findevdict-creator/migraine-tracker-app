import { randomBytes } from "node:crypto";

import { HttpsError } from "firebase-functions/v2/https";

import { config } from "../config";

const DAY_MS = 24 * 60 * 60 * 1000;
const TOKEN = /^[A-Za-z0-9_-]{22}$/;

/** What the server keeps per link: the report snapshot, never the raw log. */
export interface ShareDoc {
  uid: string;
  document: Record<string, unknown>;
  createdAt: number;
  /** Firestore TTL field. */
  expiresAt: Date;
}

export interface ShareStore {
  get(token: string): Promise<ShareDoc | null>;
  set(token: string, doc: ShareDoc): Promise<void>;
  delete(token: string): Promise<void>;
  expired(now: Date, limit: number): Promise<string[]>;
}

export interface CreateRequest {
  days: number;
  document: Record<string, unknown>;
}

/** A fresh 128-bit token in URL-safe base64. */
export function newToken(random: (n: number) => Buffer = randomBytes): string {
  return random(config.shareLink.tokenBytes).toString("base64url");
}

export function isToken(value: unknown): value is string {
  return typeof value === "string" && TOKEN.test(value);
}

/** Validates `{ days, document }`; throws `invalid-argument` otherwise. */
export function parseCreate(data: unknown): CreateRequest {
  if (typeof data !== "object" || data === null) {
    throw new HttpsError("invalid-argument", "expected { days, document }");
  }
  const { days, document } = data as Record<string, unknown>;
  if (
    typeof days !== "number" ||
    !(config.shareLink.allowedDays as readonly number[]).includes(days)
  ) {
    throw new HttpsError("invalid-argument", "days must be one of the allowed lifetimes");
  }
  if (typeof document !== "object" || document === null || Array.isArray(document)) {
    throw new HttpsError("invalid-argument", "document must be an object");
  }
  const doc = document as Record<string, unknown>;
  if (doc.v !== config.shareLink.documentVersion || !Array.isArray(doc.blocks)) {
    throw new HttpsError("invalid-argument", "unsupported report document");
  }
  if (Buffer.byteLength(JSON.stringify(doc), "utf8") > config.shareLink.maxDocumentBytes) {
    throw new HttpsError("invalid-argument", "report document is too large");
  }
  return { days, document: doc };
}

export async function createShare(
  store: ShareStore,
  uid: string,
  req: CreateRequest,
  now: number,
  random?: (n: number) => Buffer,
): Promise<{ token: string; expiresAt: number }> {
  const token = newToken(random);
  const expiresAt = new Date(now + req.days * DAY_MS);
  await store.set(token, { uid, document: req.document, createdAt: now, expiresAt });
  return { token, expiresAt: expiresAt.getTime() };
}

/** Deletes the snapshot; only its owner may. Revoking twice is fine. */
export async function revokeShare(store: ShareStore, uid: string, token: unknown): Promise<void> {
  if (!isToken(token)) throw new HttpsError("invalid-argument", "bad token");
  const doc = await store.get(token);
  if (doc === null) return;
  if (doc.uid !== uid) throw new HttpsError("permission-denied", "not your link");
  await store.delete(token);
}

export type ShareResponse =
  | { status: 200; body: { document: Record<string, unknown>; expiresAt: number } }
  | { status: 404 | 410 };

/** What the share page gets for a token. Expired snapshots are deleted on sight. */
export async function readShare(
  store: ShareStore,
  token: string,
  now: number,
): Promise<ShareResponse> {
  if (!isToken(token)) return { status: 404 };
  const doc = await store.get(token);
  if (doc === null) return { status: 404 };
  if (doc.expiresAt.getTime() <= now) {
    await store.delete(token);
    return { status: 410 };
  }
  return { status: 200, body: { document: doc.document, expiresAt: doc.expiresAt.getTime() } };
}

/** Deletes every expired snapshot, in batches. */
export async function sweepExpired(store: ShareStore, now: number): Promise<number> {
  let total = 0;
  for (;;) {
    const tokens = await store.expired(new Date(now), config.shareLink.sweepBatch);
    for (const t of tokens) await store.delete(t);
    total += tokens.length;
    if (tokens.length < config.shareLink.sweepBatch) return total;
  }
}
