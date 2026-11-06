/**
 * Runs against the Firestore emulator (FIRESTORE_EMULATOR_HOST is set by
 * `firebase emulators:exec`). Proves the cache path with the real admin SDK.
 */
import { initializeApp } from "firebase-admin/app";
import { getFirestore, type Timestamp } from "firebase-admin/firestore";

import { getCellWeather } from "../src/weather/cache";
import { cellFor } from "../src/weather/cell";

import { fixture } from "./support/openMeteoFixture";

const app = initializeApp({ projectId: "migraine-tracker-rules-test" }, "emu-test");
const db = getFirestore(app);

describe("weather cache on the emulator", () => {
  it("writes the cell document once and serves it while fresh", async () => {
    const { forecast, airQuality } = fixture();
    let calls = 0;
    const fetcher = (url: string): Promise<unknown> => {
      calls++;
      return Promise.resolve(url.includes("air-quality") ? airQuality : forecast);
    };
    const cell = cellFor(48.8566, 2.3522);
    const t0 = new Date("2026-11-06T09:00:00Z");
    const a = await getCellWeather(db, cell, { fetcher, now: () => t0 });
    const b = await getCellWeather(db, cell, {
      fetcher,
      now: () => new Date(t0.getTime() + 60_000),
    });
    expect(a.cached).toBe(false);
    expect(b.cached).toBe(true);
    expect(calls).toBe(2);
    const snap = await db.collection("weather_cells").doc(cell.key).get();
    expect(snap.exists).toBe(true);
    const expiresAt = snap.get("expiresAt") as Timestamp;
    expect(expiresAt.toDate().getTime()).toBe(t0.getTime() + 48 * 3_600_000);
    expect(JSON.stringify(snap.get("payload")).length).toBeLessThan(5 * 1024);
  });
});
