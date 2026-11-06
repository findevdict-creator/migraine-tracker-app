/** Security-rules tests: need the Firestore and Storage emulators. */
module.exports = {
  testEnvironment: "node",
  roots: ["<rootDir>/test"],
  testMatch: ["**/*.rules.test.ts", "**/*.emu.test.ts"],
  testTimeout: 20000,
  transform: { "^.+\\.ts$": ["ts-jest", { tsconfig: "tsconfig.test.json" }] },
};
