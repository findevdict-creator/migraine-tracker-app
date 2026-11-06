import { config } from "../config";

import type { Cell } from "./cell";
import type { DayPayload, WeatherPayload } from "./payload";

/** Shape of the two Open-Meteo responses we read. Everything optional. */
export interface OpenMeteoForecast {
  hourly?: {
    time: string[];
    pressure_msl?: (number | null)[];
    surface_pressure?: (number | null)[];
    temperature_2m?: (number | null)[];
    relative_humidity_2m?: (number | null)[];
    precipitation?: (number | null)[];
    wind_speed_10m?: (number | null)[];
    cloud_cover?: (number | null)[];
    weather_code?: (number | null)[];
    uv_index?: (number | null)[];
  };
  daily?: {
    time: string[];
    sunrise?: (string | null)[];
    sunset?: (string | null)[];
    daylight_duration?: (number | null)[];
    uv_index_max?: (number | null)[];
  };
}

export interface OpenMeteoAirQuality {
  hourly?: {
    time: string[];
    us_aqi?: (number | null)[];
    european_aqi?: (number | null)[];
    pm2_5?: (number | null)[];
    pm10?: (number | null)[];
    ozone?: (number | null)[];
    alder_pollen?: (number | null)[];
    birch_pollen?: (number | null)[];
    grass_pollen?: (number | null)[];
    mugwort_pollen?: (number | null)[];
    olive_pollen?: (number | null)[];
    ragweed_pollen?: (number | null)[];
  };
}

export type Fetcher = (url: string) => Promise<unknown>;

/** Open-Meteo request URLs for a cell. The commercial host is used when a key is set. */
export function openMeteoUrls(
  cell: Cell,
  apiKey: string | undefined,
): { forecast: string; airQuality: string } {
  const key = apiKey?.trim();
  const forecastBase = key
    ? config.weather.forecastUrl.replace("https://api.", "https://customer-api.")
    : config.weather.forecastUrl;
  const aqBase = key
    ? config.weather.airQualityUrl.replace(
        "https://air-quality-api.",
        "https://customer-air-quality-api.",
      )
    : config.weather.airQualityUrl;
  const common = new URLSearchParams({
    latitude: String(cell.lat),
    longitude: String(cell.lon),
    timezone: "UTC",
    past_days: String(config.weather.pastDays),
    forecast_days: String(config.weather.forecastDays),
  });
  if (key) common.set("apikey", key);
  const forecast = new URLSearchParams(common);
  forecast.set(
    "hourly",
    [
      "pressure_msl",
      "surface_pressure",
      "temperature_2m",
      "relative_humidity_2m",
      "precipitation",
      "wind_speed_10m",
      "cloud_cover",
      "weather_code",
      "uv_index",
    ].join(","),
  );
  forecast.set("daily", ["sunrise", "sunset", "daylight_duration", "uv_index_max"].join(","));
  const airQuality = new URLSearchParams(common);
  airQuality.set(
    "hourly",
    [
      "us_aqi",
      "european_aqi",
      "pm2_5",
      "pm10",
      "ozone",
      "alder_pollen",
      "birch_pollen",
      "grass_pollen",
      "mugwort_pollen",
      "olive_pollen",
      "ragweed_pollen",
    ].join(","),
  );
  return {
    forecast: `${forecastBase}?${forecast.toString()}`,
    airQuality: `${aqBase}?${airQuality.toString()}`,
  };
}

/** Default fetcher: global fetch, JSON body, throws on non-2xx. */
export const fetchJson: Fetcher = async (url) => {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`upstream ${String(res.status)} for ${new URL(url).host}`);
  return res.json();
};

const tenths = (v: number | null | undefined): number | null =>
  v == null ? null : Math.round(v * 10);
const whole = (v: number | null | undefined): number | null => (v == null ? null : Math.round(v));
const noSeconds = (v: string | null | undefined): string | null =>
  v == null ? null : v.slice(0, 16);

function series(
  values: (number | null)[] | undefined,
  from: number,
  count: number,
  map: (v: number | null | undefined) => number | null,
): (number | null)[] {
  const out: (number | null)[] = [];
  for (let i = from; i < from + count; i++) {
    out.push(map(values?.[i]));
  }
  return out;
}

/**
 * Delta encoding: the first non-null value is absolute, every later value
 * is the difference from the previous non-null value. Keeps slowly moving
 * series (pressure, temperature) to one or two characters per hour.
 */
export function deltaEncode(values: (number | null)[]): (number | null)[] {
  let previous: number | null = null;
  return values.map((v) => {
    if (v === null) return null;
    const out = previous === null ? v : v - previous;
    previous = v;
    return out;
  });
}

/** Inverse of `deltaEncode`; the app has the same function in Dart. */
export function deltaDecode(values: (number | null)[]): (number | null)[] {
  let previous: number | null = null;
  return values.map((v) => {
    if (v === null) return null;
    const out = previous === null ? v : previous + v;
    previous = out;
    return out;
  });
}

/** Index of the first hour at or after `now` (UTC hour), or 0. */
function forecastStartIndex(times: string[], now: Date): number {
  const nowHour = new Date(now);
  nowHour.setUTCMinutes(0, 0, 0);
  const idx = times.findIndex((t) => new Date(`${t}:00Z`).getTime() >= nowHour.getTime());
  return idx < 0 ? Math.max(0, times.length - 1) : idx;
}

/** Daily aggregate of an hourly series: max or mean over each UTC day. */
function daily(
  times: string[],
  values: (number | null)[] | undefined,
  mode: "max" | "mean",
): Map<string, number | null> {
  const buckets = new Map<string, number[]>();
  times.forEach((t, i) => {
    const day = t.slice(0, 10);
    const v = values?.[i];
    if (!buckets.has(day)) buckets.set(day, []);
    if (v != null) buckets.get(day)?.push(v);
  });
  const out = new Map<string, number | null>();
  for (const [day, vs] of buckets) {
    if (vs.length === 0) {
      out.set(day, null);
    } else if (mode === "max") {
      out.set(day, Math.max(...vs));
    } else {
      out.set(day, vs.reduce((a, b) => a + b, 0) / vs.length);
    }
  }
  return out;
}

/**
 * Turns the two upstream responses into the compact payload. Pressure keeps
 * the whole past window plus the forecast window; everything else hourly is
 * limited to the forecast window.
 */
export function compactPayload(
  cell: Cell,
  forecast: OpenMeteoForecast,
  airQuality: OpenMeteoAirQuality,
  now: Date,
  forecastWindowHours = 72,
): WeatherPayload {
  const h = forecast.hourly ?? { time: [] };
  const times = h.time;
  const fxStart = forecastStartIndex(times, now);
  const pressureCount = Math.min(times.length, fxStart + forecastWindowHours);
  const fxCount = Math.min(forecastWindowHours, Math.max(0, times.length - fxStart));

  const aq = airQuality.hourly ?? { time: [] };
  const aqiUs = daily(aq.time, aq.us_aqi, "max");
  const aqiEu = daily(aq.time, aq.european_aqi, "max");
  const pm25 = daily(aq.time, aq.pm2_5, "mean");
  const pm10 = daily(aq.time, aq.pm10, "mean");
  const o3 = daily(aq.time, aq.ozone, "mean");
  const pollenTypes: [string, (number | null)[] | undefined][] = [
    ["alder", aq.alder_pollen],
    ["birch", aq.birch_pollen],
    ["grass", aq.grass_pollen],
    ["mugwort", aq.mugwort_pollen],
    ["olive", aq.olive_pollen],
    ["ragweed", aq.ragweed_pollen],
  ];
  const pollenDaily = pollenTypes.map(([name, v]) => [name, daily(aq.time, v, "max")] as const);

  const d = forecast.daily ?? { time: [] };
  const lastHour = times[Math.max(0, pressureCount - 1)];
  const lastDay = lastHour ? lastHour.slice(0, 10) : undefined;
  const days: DayPayload[] = d.time.flatMap((day, i) => {
    if (lastDay !== undefined && day > lastDay) return [];
    const pollen: Record<string, number | null> = {};
    let hasPollen = false;
    for (const [name, byDay] of pollenDaily) {
      const v = byDay.get(day);
      if (v != null) {
        hasPollen = true;
        pollen[name] = whole(v);
      }
    }
    const entry: DayPayload = {
      d: day,
      aqiUs: whole(aqiUs.get(day)),
      aqiEu: whole(aqiEu.get(day)),
      pm25: tenths(pm25.get(day)),
      pm10: tenths(pm10.get(day)),
      o3: tenths(o3.get(day)),
      uvMax: tenths(d.uv_index_max?.[i]),
      dl: d.daylight_duration?.[i] == null ? null : Math.round((d.daylight_duration[i] ?? 0) / 60),
      sr: noSeconds(d.sunrise?.[i]),
      ss: noSeconds(d.sunset?.[i]),
    };
    return [hasPollen ? { ...entry, pollen } : entry];
  });

  return {
    v: 1,
    cell: cell.key,
    fetchedAt: now.toISOString(),
    hourStart: times[0] ? `${times[0]}:00Z` : now.toISOString(),
    p: deltaEncode(series(h.pressure_msl, 0, pressureCount, tenths)),
    fxStart: times[fxStart] ? `${times[fxStart]}:00Z` : now.toISOString(),
    fx: {
      sp: deltaEncode(series(h.surface_pressure, fxStart, fxCount, tenths)),
      t: deltaEncode(series(h.temperature_2m, fxStart, fxCount, tenths)),
      h: series(h.relative_humidity_2m, fxStart, fxCount, whole),
      pr: series(h.precipitation, fxStart, fxCount, tenths),
      w: series(h.wind_speed_10m, fxStart, fxCount, whole),
      c: series(h.cloud_cover, fxStart, fxCount, whole),
      wc: series(h.weather_code, fxStart, fxCount, whole),
      uv: series(h.uv_index, fxStart, fxCount, tenths),
    },
    days,
    source: "open-meteo",
  };
}

/** Fetches both upstream series for a cell and compacts them. */
export async function fetchCellWeather(
  cell: Cell,
  deps: { fetcher?: Fetcher; apiKey?: string; now?: Date },
): Promise<WeatherPayload> {
  const fetcher = deps.fetcher ?? fetchJson;
  const now = deps.now ?? new Date();
  const urls = openMeteoUrls(cell, deps.apiKey);
  const [forecast, airQuality] = await Promise.all([
    fetcher(urls.forecast) as Promise<OpenMeteoForecast>,
    fetcher(urls.airQuality).catch(() => ({})) as Promise<OpenMeteoAirQuality>,
  ]);
  return compactPayload(cell, forecast, airQuality, now);
}
