import { getFirestore } from "firebase-admin/firestore";
import { defineSecret } from "firebase-functions/params";
import { onCall } from "firebase-functions/v2/https";

import { config } from "../config";

import { getCellWeather } from "./cache";
import { parseCellRequest } from "./cell";
import type { WeatherPayload } from "./payload";

/**
 * Commercial Open-Meteo key. Left unset (placeholder value) while the app
 * runs on the free tier; see docs/phases/10-weather-cache-function.md.
 */
const openMeteoKey = defineSecret(config.weather.apiKeySecret);

/** Placeholder values that mean "no key". */
const UNSET = new Set(["", "unset", "none", "-"]);

/**
 * `weatherCache({ lat, lon })` -> compact payload for the 0.1-degree cell.
 * App Check enforced; no auth needed, since the cache holds no user data.
 */
export const weatherCache = onCall<unknown, Promise<WeatherPayload & { cached: boolean }>>(
  {
    region: config.region,
    enforceAppCheck: true,
    secrets: [openMeteoKey],
    memory: "256MiB",
    maxInstances: 20,
  },
  async (request) => {
    const cell = parseCellRequest(request.data);
    const key = openMeteoKey.value().trim();
    const deps = UNSET.has(key.toLowerCase()) ? {} : { apiKey: key };
    const result = await getCellWeather(getFirestore(), cell, deps);
    return { ...result.payload, cached: result.cached };
  },
);
