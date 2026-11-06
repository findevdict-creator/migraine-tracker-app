import { cellFor } from "../src/weather/cell";
import {
  compactPayload,
  deltaDecode,
  deltaEncode,
  fetchCellWeather,
  openMeteoUrls,
} from "../src/weather/openMeteo";
import { MAX_PAYLOAD_BYTES, payloadBytes } from "../src/weather/payload";

import { fixture } from "./support/openMeteoFixture";

const cell = cellFor(51.5, -0.1);
const now = new Date("2026-11-06T09:30:00Z");

describe("openMeteoUrls", () => {
  it("asks for the configured windows in UTC, free host without a key", () => {
    const { forecast, airQuality } = openMeteoUrls(cell, undefined);
    expect(forecast).toContain("https://api.open-meteo.com/v1/forecast?");
    expect(forecast).toContain("latitude=51.5");
    expect(forecast).toContain("timezone=UTC");
    expect(forecast).toContain("past_days=7");
    expect(forecast).toContain("forecast_days=7");
    expect(forecast).toContain("pressure_msl");
    expect(forecast).not.toContain("apikey");
    expect(airQuality).toContain("https://air-quality-api.open-meteo.com/");
    expect(airQuality).toContain("grass_pollen");
  });

  it("switches to the customer hosts when a key is set", () => {
    const { forecast, airQuality } = openMeteoUrls(cell, "abc");
    expect(forecast).toContain("https://customer-api.open-meteo.com/");
    expect(forecast).toContain("apikey=abc");
    expect(airQuality).toContain("https://customer-air-quality-api.open-meteo.com/");
  });
});

describe("compactPayload", () => {
  const { forecast, airQuality } = fixture();
  const payload = compactPayload(cell, forecast, airQuality, now);

  it("stays under the 5 KB limit with full-size data", () => {
    expect(payloadBytes(payload)).toBeLessThan(MAX_PAYLOAD_BYTES);
  });

  it("keeps pressure for the past window plus 72 h and other series for 72 h", () => {
    // 7 past days (168 h) + hours from day start to 09:00 (9) + 72 h forecast
    expect(payload.hourStart).toBe("2026-10-30T00:00:00Z");
    expect(payload.fxStart).toBe("2026-11-06T09:00:00Z");
    expect(payload.p).toHaveLength(168 + 9 + 72);
    expect(payload.fx.t).toHaveLength(72);
    expect(payload.fx.wc).toHaveLength(72);
    expect(payload.p[0]).toBe(10132);
    expect(deltaDecode(payload.p)[1]).toBe(
      Math.round((forecast.hourly?.pressure_msl?.[1] ?? 0) * 10),
    );
    expect(payload.fx.h.every((v) => v === null || Number.isInteger(v))).toBe(true);
  });

  it("aggregates air quality per day and keeps pollen only where present", () => {
    // Past 7 days plus the 72 h window ending on 2026-11-09.
    expect(payload.days).toHaveLength(11);
    expect(payload.days.at(-1)?.d).toBe("2026-11-09");
    const day = payload.days[7];
    expect(day?.d).toBe("2026-11-06");
    const dayHours = airQuality.hourly?.us_aqi?.slice(168, 192) ?? [];
    expect(day?.aqiUs).toBe(Math.max(...dayHours.map((v) => v ?? 0)));
    expect(day?.pm25).toBeGreaterThan(0);
    expect(day?.dl).toBe(556);
    expect(day?.sr).toBe("2026-11-06T07:12");
    expect(day?.pollen).toMatchObject({ alder: 12, grass: 6 });
    expect(day?.pollen).not.toHaveProperty("olive");

    const noPollen = compactPayload(cell, forecast, fixture(undefined, 14, false).airQuality, now);
    expect(noPollen.days[0]?.pollen).toBeUndefined();
  });

  it("copes with missing series", () => {
    const sparse = compactPayload(cell, { hourly: { time: forecast.hourly?.time ?? [] } }, {}, now);
    expect(sparse.p.every((v) => v === null)).toBe(true);
    expect(sparse.days).toEqual([]);
    expect(payloadBytes(sparse)).toBeLessThan(MAX_PAYLOAD_BYTES);
  });
});

describe("fetchCellWeather", () => {
  it("fetches both endpoints and tolerates an air-quality failure", async () => {
    const { forecast } = fixture();
    const urls: string[] = [];
    const fetcher = (url: string): Promise<unknown> => {
      urls.push(url);
      if (url.includes("air-quality")) return Promise.reject(new Error("boom"));
      return Promise.resolve(forecast);
    };
    const payload = await fetchCellWeather(cell, { fetcher, now });
    expect(urls).toHaveLength(2);
    expect(payload.p.length).toBeGreaterThan(0);
    expect(payload.days.every((d) => d.aqiUs === null)).toBe(true);
    expect(payload.source).toBe("open-meteo");
  });
});

describe("deltaEncode", () => {
  it("round-trips with nulls preserved", () => {
    const input = [10132, 10130, null, 10135, 10135, null, null, 9990];
    const encoded = deltaEncode(input);
    expect(encoded).toEqual([10132, -2, null, 5, 0, null, null, -145]);
    expect(deltaDecode(encoded)).toEqual(input);
  });
});
