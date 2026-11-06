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
    projectId: "migraine-tracker-rules-test",
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

  it("audit counts accept only integer counts from the signed-in user", async () => {
    const alice = env.authenticatedContext("alice").firestore();
    const good = {
      uid: "alice",
      month: "2026-11",
      attacks: 3,
      highDays: 4,
      hits: 2,
      misses: 1,
      falseAlarms: 2,
      createdAt: 1,
    };
    await assertSucceeds(setDoc(doc(alice, "audit_counts/a1"), good));
    await assertFails(setDoc(doc(alice, "audit_counts/a2"), { ...good, uid: "bob" }));
    await assertFails(setDoc(doc(alice, "audit_counts/a3"), { ...good, dates: ["2026-11-01"] }));
    await assertFails(setDoc(doc(alice, "audit_counts/a4"), { ...good, attacks: "3" }));
    await assertFails(getDoc(doc(alice, "audit_counts/a1")));
    await assertFails(
      setDoc(doc(env.unauthenticatedContext().firestore(), "audit_counts/a5"), good),
    );
  });
});
