/** Unit tests: pure logic, no emulator. */
module.exports = {
  testEnvironment: "node",
  roots: ["<rootDir>/test"],
  testMatch: ["**/*.test.ts"],
  testPathIgnorePatterns: ["\\.rules\\.test\\.ts$"],
  collectCoverageFrom: ["src/**/*.ts", "!src/index.ts"],
  coverageThreshold: { global: { lines: 80 } },
  transform: { "^.+\\.ts$": ["ts-jest", { tsconfig: "tsconfig.test.json" }] },
};
