import { createHash, timingSafeEqual } from "node:crypto";

import { config } from "../config";

/** What the server keeps per account: when Premium ends, nothing else about the purchase. */
export interface Entitlement {
  /** End of the paid period in ms; null for a purchase that never ends. */
  expiresAt: number | null;
  productId: string;
  store: string;
  environment: string;
  /** RevenueCat's event time, so a late, older event never overwrites a newer one. */
  eventAt: number;
}

export interface EntitlementStore {
  get(uid: string): Promise<Entitlement | null>;
  set(uid: string, e: Entitlement): Promise<void>;
  delete(uid: string): Promise<void>;
}

/** The fields of a RevenueCat webhook event this server reads. */
export interface RevenueCatEvent {
  type: string;
  appUserIds: string[];
  entitlementIds: string[];
  productId: string;
  store: string;
  environment: string;
  expiresAt: number | null;
  eventAt: number;
  transferredFrom: string[];
  transferredTo: string[];
}

const UID = /^[A-Za-z0-9_-]{1,128}$/;

/** A Firebase uid. RevenueCat's anonymous ids ($RCAnonymousID:...) never match. */
export function isUid(value: unknown): value is string {
  return typeof value === "string" && UID.test(value);
}

function strings(value: unknown): string[] {
  return Array.isArray(value) ? value.filter((v): v is string => typeof v === "string") : [];
}

function text(value: unknown): string {
  return typeof value === "string" ? value : "";
}

/** Reads a webhook body; throws on anything that is not a RevenueCat event. */
export function parseEvent(body: unknown): RevenueCatEvent {
  const event =
    typeof body === "object" && body !== null ? (body as { event?: unknown }).event : undefined;
  if (typeof event !== "object" || event === null) throw new Error("not a RevenueCat event");
  const e = event as Record<string, unknown>;
  if (typeof e.type !== "string" || typeof e.event_timestamp_ms !== "number") {
    throw new Error("event without type or time");
  }
  const ids = [text(e.app_user_id), text(e.original_app_user_id), ...strings(e.aliases)];
  const entitlementIds = strings(e.entitlement_ids);
  if (typeof e.entitlement_id === "string") entitlementIds.push(e.entitlement_id);
  return {
    type: e.type,
    appUserIds: [...new Set(ids.filter(isUid))],
    entitlementIds,
    productId: text(e.product_id),
    store: text(e.store),
    environment: text(e.environment),
    expiresAt: typeof e.expiration_at_ms === "number" ? e.expiration_at_ms : null,
    eventAt: e.event_timestamp_ms,
    transferredFrom: strings(e.transferred_from).filter(isUid),
    transferredTo: strings(e.transferred_to).filter(isUid),
  };
}

export type ApplyResult = "ignored" | "stale" | "updated";

/**
 * Records one event. Every event that carries the entitlement stores its
 * expiry, so purchases, renewals, cancellations (still paid until the
 * expiry), refunds and expirations all follow the same rule. A transfer
 * moves the record between accounts.
 */
export async function applyEvent(
  store: EntitlementStore,
  e: RevenueCatEvent,
): Promise<ApplyResult> {
  if (e.type === "TEST") return "ignored";
  if (e.environment === "SANDBOX" && !config.premium.acceptSandbox) return "ignored";
  if (e.type === "TRANSFER") {
    let moved: Entitlement | null = null;
    for (const uid of e.transferredFrom) {
      moved ??= await store.get(uid);
      await store.delete(uid);
    }
    if (moved === null) return "ignored";
    for (const uid of e.transferredTo) await store.set(uid, { ...moved, eventAt: e.eventAt });
    return "updated";
  }
  if (!e.entitlementIds.includes(config.premium.entitlementId) || e.appUserIds.length === 0) {
    return "ignored";
  }
  let result: ApplyResult = "stale";
  for (const uid of e.appUserIds) {
    const current = await store.get(uid);
    if (current !== null && current.eventAt > e.eventAt) continue;
    await store.set(uid, {
      expiresAt: e.expiresAt,
      productId: e.productId,
      store: e.store,
      environment: e.environment,
      eventAt: e.eventAt,
    });
    result = "updated";
  }
  return result;
}

export async function hasPremium(
  store: EntitlementStore,
  uid: string,
  now: number,
): Promise<boolean> {
  const e = await store.get(uid);
  return e !== null && (e.expiresAt === null || e.expiresAt > now);
}

/** Constant-time check of the Authorization header against the configured secret. */
export function authMatches(header: string | undefined, secret: string): boolean {
  if (!header || secret.trim().length === 0) return false;
  const digest = (v: string): Buffer => createHash("sha256").update(v).digest();
  return timingSafeEqual(digest(header.trim()), digest(secret.trim()));
}
