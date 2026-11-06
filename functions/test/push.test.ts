import type { BatchResponse, MulticastMessage } from "firebase-admin/messaging";

import { config } from "../src/config";
import { parseTokenRequest, storeToken } from "../src/push/tokens";
import { batches, sendWakeups, wakeupMessage } from "../src/push/wakeup";

import { FakeFirestore } from "./support/fakeFirestore";

describe("parseTokenRequest", () => {
  it("accepts a token and a platform", () => {
    expect(parseTokenRequest({ token: "abc:DEF-123_x", platform: "ios" })).toEqual({
      token: "abc:DEF-123_x",
      platform: "ios",
    });
  });

  it.each([
    [null],
    ["string"],
    [{}],
    [{ token: "", platform: "ios" }],
    [{ token: "a".repeat(4097), platform: "ios" }],
    [{ token: "has space", platform: "ios" }],
    [{ token: "abc", platform: "web" }],
    [{ token: 1, platform: "android" }],
  ])("rejects %p", (data) => {
    expect(() => parseTokenRequest(data)).toThrow(/invalid|expected|must|unexpected/);
  });
});

describe("storeToken", () => {
  it("creates the document with a TTL and keeps registeredAt on re-registration", async () => {
    const db = new FakeFirestore();
    const t0 = Date.UTC(2026, 10, 6, 9);
    const first = await storeToken(db, { token: "tok", platform: "android" }, t0);
    expect(first.registeredAt).toBe(t0);
    expect(first.expiresAt.getTime()).toBe(t0 + config.push.tokenTtlMs);
    const stored = db.docs.get("push_tokens/tok");
    expect(stored?.platform).toBe("android");

    const t1 = t0 + 7 * 24 * 3_600_000;
    const second = await storeToken(db, { token: "tok", platform: "android" }, t1);
    expect(second.registeredAt).toBe(t0);
    expect(second.lastSeenAt).toBe(t1);
    expect(second.expiresAt.getTime()).toBe(t1 + config.push.tokenTtlMs);
  });
});

describe("wakeupMessage", () => {
  it("is silent on both platforms", () => {
    const m = wakeupMessage(["a", "b"], 42);
    expect(m.tokens).toEqual(["a", "b"]);
    expect(m.notification).toBeUndefined();
    expect(m.data).toEqual({ type: "wakeup", sentAt: "42" });
    expect(m.android?.priority).toBe("high");
    expect(m.apns?.headers?.["apns-push-type"]).toBe("background");
    expect(m.apns?.payload?.aps["content-available"]).toBe(1);
  });
});

describe("batches", () => {
  it("splits at the FCM limit", () => {
    const items = Array.from({ length: 1201 }, (_, i) => i);
    const out = batches(items);
    expect(out.map((b) => b.length)).toEqual([500, 500, 201]);
    expect(batches([], 3)).toEqual([]);
  });
});

describe("sendWakeups", () => {
  const seedTokens = (db: FakeFirestore, n: number): void => {
    for (let i = 0; i < n; i++) db.docs.set(`push_tokens/t${String(i)}`, { platform: "android" });
  };

  interface FakeSender {
    calls: MulticastMessage[];
    sendEachForMulticast(message: MulticastMessage): Promise<BatchResponse>;
  }

  const fakeSender = (outcome: (token: string) => string | null): FakeSender => {
    const calls: MulticastMessage[] = [];
    return {
      calls,
      sendEachForMulticast(message: MulticastMessage): Promise<BatchResponse> {
        calls.push(message);
        const responses = message.tokens.map((t) => {
          const code = outcome(t);
          return code === null
            ? { success: true, messageId: `m-${t}` }
            : { success: false, error: { code, message: code } };
        });
        return Promise.resolve({
          responses: responses as BatchResponse["responses"],
          successCount: responses.filter((r) => r.success).length,
          failureCount: responses.filter((r) => !r.success).length,
        });
      },
    };
  };

  it("sends one message per batch and drops dead tokens only", async () => {
    const db = new FakeFirestore();
    seedTokens(db, 502);
    const sender = fakeSender((t) => {
      if (t === "t1") return "messaging/registration-token-not-registered";
      if (t === "t2") return "messaging/invalid-argument";
      if (t === "t3") return "messaging/internal-error";
      return null;
    });
    const result = await sendWakeups(db, sender, 7);
    expect(sender.calls.length).toBe(2);
    expect(sender.calls.map((c) => c.tokens.length)).toEqual([500, 2]);
    expect(result).toEqual({ tokens: 502, sent: 499, removed: 2, failed: 1 });
    expect(db.docs.has("push_tokens/t1")).toBe(false);
    expect(db.docs.has("push_tokens/t2")).toBe(false);
    expect(db.docs.has("push_tokens/t3")).toBe(true);
    expect(db.deletes).toBe(2);
  });

  it("does nothing without tokens", async () => {
    const db = new FakeFirestore();
    const sender = fakeSender(() => null);
    expect(await sendWakeups(db, sender, 1)).toEqual({ tokens: 0, sent: 0, removed: 0, failed: 0 });
    expect(sender.calls).toEqual([]);
  });
});
