# Phase 10: Weather cache function

Branch: `10-feat-weather-cache-function`, cut from `09-feat-export-delete`.
Requirement IDs: FR-6 server side (forecast and air-quality series per
0.1-degree cell), cost NFR (calls scale with cells, not users; payload
under 5 KB), privacy NFR (the server only ever sees a rounded cell).

## What was done

- **`weatherCache` callable** (`functions/src/weather/index.ts`), App Check
  enforced, no sign-in needed. Input `{ lat, lon }`; the function rounds to
  the cell again (`cellFor`), so a client cannot sneak a precise location
  into the cache key.
- **Cache** (`getCellWeather`): reads `weather_cells/{cell}`; serves the
  stored payload while younger than `config.weather.freshForMs` (3 h),
  otherwise fetches Open-Meteo once and stores `{ payload, fetchedAt,
  expiresAt }` with `expiresAt` 48 h out for the Firestore TTL policy.
- **Open-Meteo client** (`openMeteo.ts`): forecast (hourly pressure, surface
  pressure, temperature, humidity, precipitation, wind, cloud, weather
  code, UV; daily sunrise, sunset, daylight, UV max) and air quality
  (US and EU AQI, PM2.5, PM10, ozone, six pollen types), `timezone=UTC`,
  `past_days` and `forecast_days` from config. With a key the customer
  hosts are used. Air-quality failure degrades to nulls rather than
  failing the call.
- **Compact payload** (`payload.ts`): integers in small units (tenths of
  hPa, tenths of a degree, percent), pressure for the past 7 days plus the
  72 h forecast window, other hourly series only for the 72 h window,
  daily aggregates (max AQI, mean PM and ozone, max pollen, only present
  where the region has data). Pressure and temperature are delta-encoded.
  Full-size synthetic data with pollen is 4.7 KB; the test asserts under
  5 KB. Format version `v: 1`.
- **Secret**: `OPEN_METEO_API_KEY` from Secret Manager via `defineSecret`.
  Placeholder values (`unset`, `none`, `-`, empty) mean the free tier.
- Jest configs: unit tests ignore `*.emu.test.ts`; the emulator config
  runs `*.rules.test.ts` and `*.emu.test.ts` under `emulators:exec` in CI.

## Tests

- `functions/test/cell.test.ts`: rounding, stable keys, `-180` folding,
  bad input rejected.
- `functions/test/openMeteo.test.ts`: URLs (free and customer hosts, UTC,
  windows), payload under 5 KB with full-size data, window lengths and
  delta decoding, daily aggregation and pollen presence, missing series,
  air-quality failure tolerated, delta round trip with nulls.
- `functions/test/cache.test.ts`: miss then hit, TTL field, refetch after
  3 h, and the **load test**: 1 000 users over 10 cells cause exactly 20
  upstream calls (two endpoints per cell) and 10 writes.
- `functions/test/weatherCache.emu.test.ts`: the same path against the real
  Firestore emulator with the admin SDK, including the stored document's
  `expiresAt` and size.

## Deviations from the plan

- The load proof is a deterministic test with a fake fetcher instead of a
  traffic replay; the cache logic is the thing under test and the test
  states the scaling property directly.
- Concurrent first requests for one cell can each fetch once (no lock);
  bounded by cells, acceptable at this scale.

## How to verify

```bash
cd functions && npm ci && npm run lint && npm run typecheck && npm test
cd functions && npm run test:rules      # Java 21 for the emulators
```

Deploy to staging after the secret exists:

```bash
firebase functions:secrets:set OPEN_METEO_API_KEY --project staging   # value: unset
cd functions && npm run build && npm run deploy:staging
```

## What M must fill in

- Create the `OPEN_METEO_API_KEY` secret in each project (value `unset`
  until a commercial key exists; then the real key).
- Enable the Firestore TTL policy once per project:
  `gcloud firestore fields ttls update expiresAt --collection-group=weather_cells --project=<id>`.
