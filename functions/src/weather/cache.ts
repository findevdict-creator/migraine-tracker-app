import type { Firestore } from "firebase-admin/firestore";

import { config } from "../config";

import type { Cell } from "./cell";
import { fetchCellWeather, type Fetcher } from "./openMeteo";
import type { WeatherPayload } from "./payload";

/** Stored document: the payload plus the fields the TTL policy and freshness check use. */
export interface WeatherCellDoc {
  payload: WeatherPayload;
  /** Epoch millis; served while younger than `freshForMs`. */
  fetchedAt: number;
  /** Firestore TTL field (a Timestamp when written by admin). */
  expiresAt: Date;
}

export interface CacheDeps {
  fetcher?: Fetcher;
  apiKey?: string;
  now?: () => Date;
}

export interface CacheResult {
  payload: WeatherPayload;
  /** True when the response came from Firestore without an upstream call. */
  cached: boolean;
}

/**
 * Serves the cell's cached series when under `freshForMs` old, otherwise
 * fetches once from Open-Meteo and stores it with a 48 h TTL. Concurrent
 * misses for the same cell may fetch more than once; that is bounded by the
 * number of cells, not users.
 */
export async function getCellWeather(
  db: Firestore,
  cell: Cell,
  deps: CacheDeps = {},
): Promise<CacheResult> {
  const now = (deps.now ?? ((): Date => new Date()))();
  const ref = db.collection(config.collections.weatherCells).doc(cell.key);
  const snap = await ref.get();
  if (snap.exists) {
    const data = snap.data() as Partial<WeatherCellDoc>;
    if (
      typeof data.fetchedAt === "number" &&
      now.getTime() - data.fetchedAt < config.weather.freshForMs &&
      data.payload
    ) {
      return { payload: data.payload, cached: true };
    }
  }
  const fetchDeps: Parameters<typeof fetchCellWeather>[1] = { now };
  if (deps.fetcher) fetchDeps.fetcher = deps.fetcher;
  if (deps.apiKey !== undefined) fetchDeps.apiKey = deps.apiKey;
  const payload = await fetchCellWeather(cell, fetchDeps);
  const doc: WeatherCellDoc = {
    payload,
    fetchedAt: now.getTime(),
    expiresAt: new Date(now.getTime() + config.weather.ttlMs),
  };
  await ref.set(doc);
  return { payload, cached: false };
}
