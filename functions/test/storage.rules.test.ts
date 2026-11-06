import { readFileSync } from "node:fs";
import { resolve } from "node:path";

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { getBytes, ref, uploadBytes } from "firebase/storage";

let env: RulesTestEnvironment;

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: "migraine-tracker-rules-test",
    storage: {
      rules: readFileSync(resolve(__dirname, "../../storage.rules"), "utf8"),
      host: "127.0.0.1",
      port: 9199,
    },
  });
});

afterAll(async () => {
  await env.cleanup();
});

describe("storage.rules", () => {
  const blob = new Uint8Array([1, 2, 3]);
  const meta = { contentType: "application/octet-stream" };

  it("owner can write and read their backup, nobody else can", async () => {
    const alice = env.authenticatedContext("alice").storage();
    const bob = env.authenticatedContext("bob").storage();
    await assertSucceeds(uploadBytes(ref(alice, "backups/alice/db.enc"), blob, meta));
    await assertSucceeds(getBytes(ref(alice, "backups/alice/db.enc")));
    await assertFails(getBytes(ref(bob, "backups/alice/db.enc")));
    await assertFails(uploadBytes(ref(bob, "backups/alice/db.enc"), blob, meta));
    await assertFails(
      uploadBytes(ref(env.unauthenticatedContext().storage(), "backups/alice/x"), blob, meta),
    );
  });

  it("rejects non-opaque content types and other paths", async () => {
    const alice = env.authenticatedContext("alice").storage();
    await assertFails(
      uploadBytes(ref(alice, "backups/alice/db.json"), blob, { contentType: "application/json" }),
    );
    await assertFails(uploadBytes(ref(alice, "other/alice/x"), blob, meta));
  });
});
