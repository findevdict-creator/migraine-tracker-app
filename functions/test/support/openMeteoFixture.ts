import type { OpenMeteoAirQuality, OpenMeteoForecast } from "../../src/weather/openMeteo";

/** Builds full-size synthetic responses: 14 days hourly and daily. */
export function fixture(
  start = "2026-10-30T00:00",
  days = 14,
  withPollen = true,
): { forecast: OpenMeteoForecast; airQuality: OpenMeteoAirQuality } {
  const hours = days * 24;
  const startMs = new Date(`${start}:00Z`).getTime();
  const time: string[] = [];
  const dayTime: string[] = [];
  for (let i = 0; i < hours; i++) {
    time.push(new Date(startMs + i * 3_600_000).toISOString().slice(0, 16));
  }
  for (let d = 0; d < days; d++) {
    dayTime.push(new Date(startMs + d * 86_400_000).toISOString().slice(0, 10));
  }
  const wave = (i: number, base: number, amp: number, period: number): number =>
    Number((base + amp * Math.sin((2 * Math.PI * i) / period)).toFixed(2));
  const seq = (f: (i: number) => number | null): (number | null)[] =>
    Array.from({ length: hours }, (_, i) => f(i));
  return {
    forecast: {
      hourly: {
        time,
        pressure_msl: seq((i) => wave(i, 1013.2, 12, 72)),
        surface_pressure: seq((i) => wave(i, 1001.4, 12, 72)),
        temperature_2m: seq((i) => wave(i, 12.3, 6, 24)),
        relative_humidity_2m: seq((i) => Math.round(wave(i, 70, 20, 24))),
        precipitation: seq((i) => (i % 7 === 0 ? 1.2 : 0)),
        wind_speed_10m: seq((i) => wave(i, 14.5, 8, 36)),
        cloud_cover: seq((i) => Math.round(wave(i, 55, 40, 30))),
        weather_code: seq((i) => (i % 5 === 0 ? 61 : 3)),
        uv_index: seq((i) => Math.max(0, wave(i, 2.5, 3, 24))),
      },
      daily: {
        time: dayTime,
        sunrise: dayTime.map((d) => `${d}T07:12`),
        sunset: dayTime.map((d) => `${d}T16:28`),
        daylight_duration: dayTime.map(() => 33_360),
        uv_index_max: dayTime.map((_, i) => 3 + (i % 3)),
      },
    },
    airQuality: {
      hourly: {
        time,
        us_aqi: seq((i) => Math.round(wave(i, 45, 20, 48))),
        european_aqi: seq((i) => Math.round(wave(i, 30, 15, 48))),
        pm2_5: seq((i) => wave(i, 8.4, 4, 48)),
        pm10: seq((i) => wave(i, 15.1, 6, 48)),
        ozone: seq((i) => wave(i, 60, 20, 24)),
        ...(withPollen
          ? {
              alder_pollen: seq(() => 12),
              birch_pollen: seq((i) => 30 + (i % 10)),
              grass_pollen: seq(() => 5.5),
              mugwort_pollen: seq(() => 0),
              olive_pollen: seq(() => null),
              ragweed_pollen: seq(() => 2),
            }
          : {}),
      },
    },
  };
}
