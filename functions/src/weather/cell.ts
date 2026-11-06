import { HttpsError } from "firebase-functions/v2/https";

import { config } from "../config";

/** A rounded 0.1-degree cell, the only location the server ever sees. */
export interface Cell {
  readonly lat: number;
  readonly lon: number;
  /** Document id, for example `51.5,-0.1`. */
  readonly key: string;
}

/** Rounds coordinates to the configured cell size and builds the key. */
export function cellFor(lat: number, lon: number): Cell {
  if (
    !Number.isFinite(lat) ||
    !Number.isFinite(lon) ||
    lat < -90 ||
    lat > 90 ||
    lon < -180 ||
    lon > 180
  ) {
    throw new HttpsError("invalid-argument", "lat and lon must be valid coordinates");
  }
  const step = config.weather.cellDegrees;
  const decimals = Math.max(0, Math.round(-Math.log10(step)));
  const round = (v: number): number => Number((Math.round(v / step) * step).toFixed(decimals));
  const rLat = round(lat);
  // -180 and 180 are the same meridian; normalise so one cell key exists.
  const rLon = round(lon) === -180 ? 180 : round(lon);
  return { lat: rLat, lon: rLon, key: `${rLat.toFixed(decimals)},${rLon.toFixed(decimals)}` };
}

/** Parses the callable payload, which may come from an untrusted client. */
export function parseCellRequest(data: unknown): Cell {
  if (typeof data !== "object" || data === null) {
    throw new HttpsError("invalid-argument", "expected { lat, lon }");
  }
  const { lat, lon } = data as { lat?: unknown; lon?: unknown };
  if (typeof lat !== "number" || typeof lon !== "number") {
    throw new HttpsError("invalid-argument", "lat and lon must be numbers");
  }
  return cellFor(lat, lon);
}
