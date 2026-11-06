import { readFileSync } from "node:fs";
import { join } from "node:path";

import { config } from "../src/config";
import {
  applyEvent,
  authMatches,
  hasPremium,
  isUid,
  parseEvent,
  type Entitlement,
  type EntitlementStore,
} from "../src/premium/entitlements";

const DAY = 24 * 60 * 60 * 1000;
const T0 = Date.UTC(2026, 10, 6, 9);

class MemoryEntitlements implements EntitlementStore {
  readonly docs = new Map<string, Entitlement>();
  get(uid: string): Promise<Entitlement | null> {
    return Promise.resolve(this.docs.get(uid) ?? null);
  }
  set(uid: string, e: Entitlement): Promise<void> {
    this.docs.set(uid, e);
    return Promise.resolve();
  }
  delete(uid: string): Promise<void> {
    this.docs.delete(uid);
    return Promise.resolve();
  }
}

function body(event: Record<string, unknown>): unknown {
  return {
    api_version: "1.0",
    event: {
      app_user_id: "alice",
      original_app_user_id: "$RCAnonymousID:1234",
      aliases: ["$RCAnonymousID:1234", "alice"],
      entitlement_ids: [config.premium.entitlementId],
      product_id: "premium_monthly",
      store: "APP_STORE",
      environment: "PRODUCTION",
      event_timestamp_ms: T0,
      expiration_at_ms: T0 + 30 * DAY,
      ...event,
    },
  };
}

async function apply(store: EntitlementStore, event: Record<string, unknown>): Promise<string> {
  return applyEvent(store, parseEvent(body(event)));
}

describe("RevenueCat events", () => {
  it("only Firebase uids are kept, never anonymous ids", () => {
    const e = parseEvent(body({ type: "INITIAL_PURCHASE" }));
    expect(e.appUserIds).toEqual(["alice"]);
    expect(isUid("$RCAnonymousID:1234")).toBe(false);
    expect(isUid("../alice")).toBe(false);
  });

  it("rejects bodies that are not events", () => {
    for (const bad of [null, {}, { event: null }, { event: { type: "RENEWAL" } }, "x"]) {
      expect(() => parseEvent(bad)).toThrow();
    }
  });

  it("a purchase turns Premium on until its expiry", async () => {
    const store = new MemoryEntitlements();
    expect(await apply(store, { type: "INITIAL_PURCHASE" })).toBe("updated");
    expect(await hasPremium(store, "alice", T0 + DAY)).toBe(true);
    expect(await hasPremium(store, "alice", T0 + 30 * DAY)).toBe(false);
    expect(await hasPremium(store, "bob", T0)).toBe(false);
    // Only the expiry and where it was bought are kept.
    expect(Object.keys(store.docs.get("alice") ?? {}).sort()).toEqual([
      "environment",
      "eventAt",
      "expiresAt",
      "productId",
      "store",
    ]);
  });

  it("a renewal extends, a cancellation keeps the paid period, an expiry ends it", async () => {
    const store = new MemoryEntitlements();
    await apply(store, { type: "INITIAL_PURCHASE" });
    await apply(store, {
      type: "RENEWAL",
      event_timestamp_ms: T0 + 30 * DAY,
      expiration_at_ms: T0 + 60 * DAY,
    });
    expect(await hasPremium(store, "alice", T0 + 45 * DAY)).toBe(true);
    await apply(store, {
      type: "CANCELLATION",
      event_timestamp_ms: T0 + 40 * DAY,
      expiration_at_ms: T0 + 60 * DAY,
    });
    expect(await hasPremium(store, "alice", T0 + 59 * DAY)).toBe(true);
    await apply(store, {
      type: "EXPIRATION",
      event_timestamp_ms: T0 + 60 * DAY,
      expiration_at_ms: T0 + 60 * DAY,
    });
    expect(await hasPremium(store, "alice", T0 + 60 * DAY)).toBe(false);
  });

  it("an older event delivered late does not undo a newer one", async () => {
    const store = new MemoryEntitlements();
    // Refunded on day 5: RevenueCat moves the expiry to the refund time.
    await apply(store, {
      type: "CANCELLATION",
      event_timestamp_ms: T0 + 5 * DAY,
      expiration_at_ms: T0 + 5 * DAY,
    });
    // The original purchase event arrives afterwards.
    expect(await apply(store, { type: "INITIAL_PURCHASE" })).toBe("stale");
    expect(await hasPremium(store, "alice", T0 + 10 * DAY)).toBe(false);
  });

  it("a lifetime purchase never ends", async () => {
    const store = new MemoryEntitlements();
    await apply(store, { type: "NON_RENEWING_PURCHASE", expiration_at_ms: null });
    expect(await hasPremium(store, "alice", T0 + 3650 * DAY)).toBe(true);
  });

  it("ignores test events, other entitlements and anonymous buyers", async () => {
    const store = new MemoryEntitlements();
    expect(await apply(store, { type: "TEST" })).toBe("ignored");
    expect(await apply(store, { type: "INITIAL_PURCHASE", entitlement_ids: ["other"] })).toBe(
      "ignored",
    );
    expect(
      await apply(store, {
        type: "INITIAL_PURCHASE",
        app_user_id: "$RCAnonymousID:9",
        aliases: [],
      }),
    ).toBe("ignored");
    expect(store.docs.size).toBe(0);
  });

  it("accepts sandbox purchases, which App Review makes against production builds", async () => {
    const store = new MemoryEntitlements();
    expect(config.premium.acceptSandbox).toBe(true);
    expect(await apply(store, { type: "INITIAL_PURCHASE", environment: "SANDBOX" })).toBe(
      "updated",
    );
  });

  it("a transfer moves Premium to the other account", async () => {
    const store = new MemoryEntitlements();
    await apply(store, { type: "INITIAL_PURCHASE" });
    await apply(store, {
      type: "TRANSFER",
      event_timestamp_ms: T0 + DAY,
      transferred_from: ["alice"],
      transferred_to: ["bob"],
    });
    expect(await hasPremium(store, "alice", T0 + 2 * DAY)).toBe(false);
    expect(await hasPremium(store, "bob", T0 + 2 * DAY)).toBe(true);
  });
});

describe("webhook authorization", () => {
  it("matches only the configured secret", () => {
    expect(authMatches("Bearer s3cret", "Bearer s3cret")).toBe(true);
    expect(authMatches("Bearer s3cre", "Bearer s3cret")).toBe(false);
    expect(authMatches(undefined, "Bearer s3cret")).toBe(false);
    // An unset secret never lets anything in.
    expect(authMatches("", "")).toBe(false);
    expect(authMatches("anything", " ")).toBe(false);
  });
});

describe("server enforcement", () => {
  it("creating a share link checks Premium after the input and before storing", () => {
    const src = readFileSync(join(__dirname, "..", "src", "share", "index.ts"), "utf8");
    const parse = src.indexOf("parseCreate(request.data)");
    const check = src.indexOf("await requirePremium(uid)");
    const create = src.indexOf("return createShare(");
    expect(parse).toBeGreaterThan(0);
    expect(check).toBeGreaterThan(parse);
    expect(create).toBeGreaterThan(check);
  });

  it("revoking and viewing never need Premium", () => {
    const src = readFileSync(join(__dirname, "..", "src", "share", "index.ts"), "utf8");
    expect(src.match(/requirePremium/g)).toHaveLength(2); // the import and createShareLink
  });
});
