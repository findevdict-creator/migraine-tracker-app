import { readFileSync } from "node:fs";
import { resolve } from "node:path";

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { doc, getDoc, setDoc } from "firebase/firestore";

let env: RulesTestEnvironment;

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: "aurawell-rules-test",
    firestore: {
      rules: readFileSync(resolve(__dirname, "../../firestore.rules"), "utf8"),
      host: "127.0.0.1",
      port: 8080,
    },
  });
});

afterAll(async () => {
  await env.cleanup();
});

beforeEach(async () => {
  await env.clearFirestore();
});

describe("firestore.rules", () => {
  it("denies everything by default", async () => {
    const db = env.unauthenticatedContext().firestore();
    await assertFails(getDoc(doc(db, "anything/x")));
    await assertFails(setDoc(doc(db, "anything/x"), { a: 1 }));
  });

  it("weather cells are readable by anyone and writable by nobody", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), "weather_cells/51.5,-0.1"), { hours: [] });
    });
    const anon = env.unauthenticatedContext().firestore();
    await assertSucceeds(getDoc(doc(anon, "weather_cells/51.5,-0.1")));
    await assertFails(setDoc(doc(anon, "weather_cells/51.5,-0.1"), { hours: [] }));
    const user = env.authenticatedContext("alice").firestore();
    await assertFails(setDoc(doc(user, "weather_cells/51.5,-0.1"), { hours: [] }));
  });

  it("push tokens are closed to clients", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), "push_tokens/t1"), { platform: "android" });
    });
    const anon = env.unauthenticatedContext().firestore();
    const user = env.authenticatedContext("alice").firestore();
    await assertFails(getDoc(doc(anon, "push_tokens/t1")));
    await assertFails(getDoc(doc(user, "push_tokens/t1")));
    await assertFails(setDoc(doc(user, "push_tokens/t2"), { platform: "ios" }));
  });

  it("account deletion records are closed to clients, even the owner", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), "account_deletions/alice"), { requestedAt: 1 });
    });
    const alice = env.authenticatedContext("alice").firestore();
    await assertFails(getDoc(doc(alice, "account_deletions/alice")));
    await assertFails(setDoc(doc(alice, "account_deletions/alice"), { requestedAt: 2 }));
  });

  it("entitlements are readable by their owner and written only by the webhook", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), "entitlements/alice"), { expiresAt: 1, eventAt: 1 });
    });
    const alice = env.authenticatedContext("alice").firestore();
    const bob = env.authenticatedContext("bob").firestore();
    await assertSucceeds(getDoc(doc(alice, "entitlements/alice")));
    await assertFails(getDoc(doc(bob, "entitlements/alice")));
    await assertFails(setDoc(doc(alice, "entitlements/alice"), { expiresAt: null, eventAt: 2 }));
    await assertFails(setDoc(doc(alice, "entitlements/carol"), { expiresAt: null, eventAt: 2 }));
  });

  it("users read and write only their own document", async () => {
    const alice = env.authenticatedContext("alice").firestore();
    const bob = env.authenticatedContext("bob").firestore();
    await assertSucceeds(
      setDoc(doc(alice, "users/alice"), { createdAt: 1, backupPath: null, subscription: null }),
    );
    await assertFails(setDoc(doc(alice, "users/alice"), { createdAt: 1, email: "x" }));
    await assertSucceeds(getDoc(doc(alice, "users/alice")));
    await assertFails(getDoc(doc(bob, "users/alice")));
    await assertFails(setDoc(doc(bob, "users/alice"), { createdAt: 2 }));
  });

  it("share snapshots are never readable directly", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), "share_snapshots/tok"), { report: {} });
    });
    const alice = env.authenticatedContext("alice").firestore();
    await assertFails(getDoc(doc(alice, "share_snapshots/tok")));
    await assertFails(getDoc(doc(env.unauthenticatedContext().firestore(), "share_snapshots/tok")));
  });

  it("audit counts are closed to clients: only the function writes them", async () => {
    const alice = env.authenticatedContext("alice").firestore();
    const counts = { attacks: 3, hits: 2, misses: 1, highDays: 4, falseAlarms: 2 };
    await assertFails(setDoc(doc(alice, "audit_counts/a1"), counts));
    await assertFails(
      setDoc(doc(env.unauthenticatedContext().firestore(), "audit_counts/a2"), counts),
    );
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), "audit_counts/a3"), counts);
    });
    await assertFails(getDoc(doc(alice, "audit_counts/a3")));
  });
});
