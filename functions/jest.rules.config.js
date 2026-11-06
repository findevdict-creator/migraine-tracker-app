/** Security-rules tests: need the Firestore and Storage emulators. */
module.exports = {
  testEnvironment: "node",
  roots: ["<rootDir>/test"],
  testMatch: ["**/*.rules.test.ts", "**/*.emu.test.ts"],
  testTimeout: 20000,
  // One worker: every suite shares the emulator project, and the rules
  // suites wipe it before each test (clearFirestore), which would delete
  // documents another suite just wrote if they ran side by side.
  maxWorkers: 1,
  transform: { "^.+\\.ts$": ["ts-jest", { tsconfig: "tsconfig.test.json" }] },
};
