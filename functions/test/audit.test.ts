import { readFileSync } from "node:fs";
import { join } from "node:path";

import { parseAuditPayload, previousMonth, recordAudit, type AuditDoc } from "../src/audit/audit";

const good = { attacks: 3, hits: 2, misses: 1, highDays: 4, falseAlarms: 2, modelVersion: "1.0.0" };

describe("audit payload", () => {
  it("accepts exactly the five counts and the model version", () => {
    expect(parseAuditPayload(good)).toEqual(good);
  });

  it("refuses any extra field, so a date, place or id can never slip in", () => {
    for (const extra of [
      { uid: "alice" },
      { month: "2026-10" },
      { dates: ["2026-10-02"] },
      { lat: 51.5 },
      { cell: "u10h" },
    ]) {
      expect(() => parseAuditPayload({ ...good, ...extra })).toThrow("exactly");
    }
    const missing: Record<string, unknown> = { ...good };
    delete missing.modelVersion;
    expect(() => parseAuditPayload(missing)).toThrow("exactly");
  });

  it("refuses counts that are not whole numbers in range or do not add up", () => {
    expect(() => parseAuditPayload({ ...good, attacks: "3" })).toThrow("whole number");
    expect(() => parseAuditPayload({ ...good, hits: 1.5, misses: 1.5 })).toThrow("whole number");
    expect(() => parseAuditPayload({ ...good, misses: -1, hits: 4 })).toThrow("whole number");
    expect(() => parseAuditPayload({ ...good, highDays: 32, falseAlarms: 0 })).toThrow("0 to 31");
    expect(() => parseAuditPayload({ ...good, misses: 2 })).toThrow("add up");
    expect(() => parseAuditPayload({ ...good, falseAlarms: 5 })).toThrow("exceed");
    expect(() =>
      parseAuditPayload({ ...good, attacks: 0, hits: 0, misses: 0, highDays: 0, falseAlarms: 0 }),
    ).toThrow("nothing");
    expect(() => parseAuditPayload({ ...good, modelVersion: "<script>" })).toThrow("1.2.3");
    expect(() => parseAuditPayload(null)).toThrow("object");
    expect(() => parseAuditPayload([good])).toThrow("object");
  });
});

describe("recording", () => {
  it("stamps the previous UTC month from the server clock and nothing else", async () => {
    const stored: AuditDoc[] = [];
    const now = Date.UTC(2026, 10, 3, 8);
    await recordAudit({ add: (d) => Promise.resolve(void stored.push(d)) }, good, now);
    expect(stored).toEqual([{ ...good, month: "2026-10", receivedAt: now }]);
    expect(Object.keys(stored[0] ?? {}).sort()).toEqual([
      "attacks",
      "falseAlarms",
      "highDays",
      "hits",
      "misses",
      "modelVersion",
      "month",
      "receivedAt",
    ]);
  });

  it("works out the previous month across a year boundary", () => {
    expect(previousMonth(Date.UTC(2027, 0, 5))).toBe("2026-12");
    expect(previousMonth(Date.UTC(2026, 2, 31, 23, 59))).toBe("2026-02");
  });

  it("the function stores no uid", () => {
    const src = readFileSync(join(__dirname, "..", "src", "audit", "index.ts"), "utf8");
    expect(src).not.toMatch(/auth\.uid|request\.auth|rawRequest/);
    expect(src).toContain("enforceAppCheck: true");
  });
});
