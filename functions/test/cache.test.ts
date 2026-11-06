import { getCellWeather } from "../src/weather/cache";
import { cellFor } from "../src/weather/cell";

import { FakeFirestore } from "./support/fakeFirestore";
import { fixture } from "./support/openMeteoFixture";

describe("getCellWeather", () => {
  const { forecast, airQuality } = fixture();
  let upstreamCalls = 0;
  const fetcher = (url: string): Promise<unknown> => {
    upstreamCalls++;
    return Promise.resolve(url.includes("air-quality") ? airQuality : forecast);
  };

  beforeEach(() => {
    upstreamCalls = 0;
  });

  it("fetches on a miss, stores with a TTL, then serves from cache while fresh", async () => {
    const db = new FakeFirestore();
    const t0 = new Date("2026-11-06T09:00:00Z");
    const first = await getCellWeather(db.asFirestore(), cellFor(51.5, -0.1), {
      fetcher,
      now: () => t0,
    });
    expect(first.cached).toBe(false);
    expect(upstreamCalls).toBe(2);
    const stored = db.docs.get("weather_cells/51.5,-0.1");
    expect(stored?.fetchedAt).toBe(t0.getTime());
    expect((stored?.expiresAt as Date).getTime()).toBe(t0.getTime() + 48 * 3_600_000);

    const t1 = new Date(t0.getTime() + 2 * 3_600_000);
    const second = await getCellWeather(db.asFirestore(), cellFor(51.52, -0.08), {
      fetcher,
      now: () => t1,
    });
    expect(second.cached).toBe(true);
    expect(second.payload).toEqual(first.payload);
    expect(upstreamCalls).toBe(2);
  });

  it("refetches once the cache is older than 3 h", async () => {
    const db = new FakeFirestore();
    const t0 = new Date("2026-11-06T09:00:00Z");
    await getCellWeather(db.asFirestore(), cellFor(51.5, -0.1), { fetcher, now: () => t0 });
    const t1 = new Date(t0.getTime() + 3 * 3_600_000 + 1);
    const result = await getCellWeather(db.asFirestore(), cellFor(51.5, -0.1), {
      fetcher,
      now: () => t1,
    });
    expect(result.cached).toBe(false);
    expect(upstreamCalls).toBe(4);
    expect(db.docs.get("weather_cells/51.5,-0.1")?.fetchedAt).toBe(t1.getTime());
  });

  it("load: upstream calls scale with cells, not users", async () => {
    const db = new FakeFirestore();
    const t0 = new Date("2026-11-06T09:00:00Z");
    const users = 1000;
    const cells = 10;
    for (let u = 0; u < users; u++) {
      // Users are spread over ten cells; jitter inside the cell must not matter.
      const lat = 40 + (u % cells) * 0.1 + (u % 5) * 0.01;
      const lon = -3 + (u % 3) * 0.02;
      const t = new Date(t0.getTime() + u * 1000);
      await getCellWeather(db.asFirestore(), cellFor(lat, lon), { fetcher, now: () => t });
    }
    const distinctCells = new Set([...db.docs.keys()]).size;
    expect(distinctCells).toBe(cells);
    expect(upstreamCalls).toBe(cells * 2);
    expect(db.writes).toBe(cells);
    expect(db.reads).toBe(users);
  });
});
