/**
 * The compact weather payload stored per cell and returned to the app.
 * Numbers are integers in small units so the JSON stays under 5 KB:
 * pressure in tenths of hPa, temperature in tenths of a degree,
 * precipitation in tenths of a millimetre, UV in tenths, wind in km/h,
 * humidity and cloud cover in percent.
 */
export interface WeatherPayload {
  /** Payload format version. */
  readonly v: 1;
  readonly cell: string;
  /** ISO-8601 UTC time the upstream data was fetched. */
  readonly fetchedAt: string;
  /** ISO-8601 UTC hour of `p[0]`. */
  readonly hourStart: string;
  /**
   * Mean-sea-level pressure per hour, tenths of hPa, past days then the
   * forecast window, delta-encoded (see `deltaEncode`).
   */
  readonly p: (number | null)[];
  /** The forecast window: starts at `fxStart` and has one entry per hour. */
  readonly fxStart: string;
  readonly fx: {
    /** Delta-encoded tenths of hPa. */
    readonly sp: (number | null)[];
    /** Delta-encoded tenths of a degree. */
    readonly t: (number | null)[];
    readonly h: (number | null)[];
    readonly pr: (number | null)[];
    readonly w: (number | null)[];
    readonly c: (number | null)[];
    readonly wc: (number | null)[];
    readonly uv: (number | null)[];
  };
  /** One entry per calendar day (UTC) covering the hours in `p`. */
  readonly days: DayPayload[];
  /** Attribution the app must show. */
  readonly source: "open-meteo";
}

export interface DayPayload {
  /** `yyyy-MM-dd` (UTC). */
  readonly d: string;
  readonly aqiUs: number | null;
  readonly aqiEu: number | null;
  /** Tenths of µg/m³. */
  readonly pm25: number | null;
  readonly pm10: number | null;
  readonly o3: number | null;
  /** Tenths. */
  readonly uvMax: number | null;
  /** Daylight minutes. */
  readonly dl: number | null;
  /** ISO-8601 UTC without seconds, e.g. `2026-11-06T07:12`. */
  readonly sr: string | null;
  readonly ss: string | null;
  /** Grains/m³ per type, only where the region has pollen data. */
  readonly pollen?: Readonly<Record<string, number | null>>;
}

/** The hard limit from the requirements doc. */
export const MAX_PAYLOAD_BYTES = 5 * 1024;

export function payloadBytes(payload: WeatherPayload): number {
  return Buffer.byteLength(JSON.stringify(payload), "utf8");
}
