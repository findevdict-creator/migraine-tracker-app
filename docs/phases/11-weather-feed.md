# Phase 11: Weather feed

Branch: `11-feat-weather-feed`, cut from `10-feat-weather-cache-function`.
Requirement IDs: FR-6 on the device (location rounding, typed-city
fallback, local weather store, pressure deltas, weather attached to every
attack and check-in, foreground and background refresh, environment
screen), privacy NFR (nothing more precise than a 0.1-degree cell leaves
the device), offline NFR (cached data shown with its age).

## What was done

- **Location cell** (`features/weather/domain/location_cell.dart`):
  `LocationCell.from(lat, lon)` rounds to `AppThresholds.locationRoundingDegrees`
  with the same rule as the function's `cellFor` (half away from zero,
  `-180` folded onto `180`), so both sides agree on the key. `LocationMode`
  (gps, manual, none) and `ManualLocation` (typed city, stored rounded).
- **Location source** (`weather_sources.dart`): `geolocator` at low accuracy,
  while-using only, 15 s limit, last-known fallback. Never throws: no
  plugin, no permission or no fix all yield "no location".
- **Weather source**: `cloud_functions` call to
  `AppEndpoints.weatherCacheFunction` in `AppEnv.functionsRegion`, emulator
  in dev. Without Firebase configured the source fails and the app keeps
  showing the cache.
- **Payload decoder** (`weather_payload.dart`): `deltaDecode` mirrors the
  function's encoder; `WeatherPayload.decode` turns format `v: 1` into
  `WeatherHourEntity` rows (pressure for the whole window, other fields for
  the forecast window) and `EnvironmentDayEntity` rows (phase 13 shows them).
- **Store** (`DriftWeatherRepository`): upsert keeps existing pins, hours
  per cell and window, newest `fetchedAt`, pin and prune, environment days.
- **Sync** (`WeatherSync.refresh`): resolves the location (manual city wins,
  then GPS, then the last cell so cached data stays visible), writes
  `weather.lastCell`, returns early inside `weatherForegroundRefresh` (3 h)
  unless forced, decodes, upserts, prunes hours older than
  `weatherRetentionDays` (14) except pinned ones. A failed fetch keeps the
  cache and reports the error.
- **Refresh triggers**: `weatherRefreshProvider` runs when the home screen
  opens, `WeatherRefreshOnResume` invalidates it on app resume, the
  environment screen has a manual refresh. Background: `workmanager`
  periodic task `AppBackgroundTasks.weatherRefresh` every
  `weatherBackgroundRefresh` (24 h), network required, scheduled from
  `bootstrap` on Android and iOS only and never fatal. iOS also needs the
  identifier in `Info.plist` (`BGTaskSchedulerPermittedIdentifiers`,
  `UIBackgroundModes`) and the `AppDelegate` registration, both added.
- **Pressure deltas** (`PressureDeltas.from`): 3, 6, 12 and 24 h changes in
  hPa against the current UTC hour, null where either end is missing.
- **Weather attached at save time**: `AttackEntity.weather` and
  `CheckinEntity.weather` (the existing `weather` JSON columns). `AttackStarter`
  stamps the hour snapshot plus deltas and pins the hour; `CheckinEditor`
  stamps once on the first value of the day so the snapshot reflects when
  the check-in was made. Null when nothing is cached.
- **Environment screen** (`/environment`): current pressure, the four
  deltas, the 72 h chart (`PressureChart`, 48 h back solid, 24 h ahead
  dashed, now marker), "Updated X ago", stale note past `weatherStaleAfter`
  (6 h), offline note when the last refresh failed, location row with
  "Use my location" and "Choose a city" (Open-Meteo geocoding, only the
  typed name is sent, debounced), privacy note and Open-Meteo attribution.
- **Home card** (`EnvironmentCard`): pressure and trend word, opens the
  screen; empty text when nothing is cached.
- Settings keys: `location.mode`, `location.manual`, `weather.lastCell`.
- Android: `INTERNET` and `ACCESS_COARSE_LOCATION`. iOS:
  `NSLocationWhenInUseUsageDescription`.

## Tests

- `location_cell_test.dart`: 0.1-degree rounding, key format, `-180`
  folding, clamping, parse round-trip, manual location JSON.
- `weather_payload_test.dart`: delta decoding against values produced by
  the TS encoder, hours and days from a fixture that mirrors
  `compactPayload`, unknown version rejected.
- `pressure_deltas_test.dart`: window maths, missing ends, no current hour,
  local time input.
- `weather_sync_test.dart`: only the rounded cell is sent, fresh skip,
  force, failure keeps cache, prune keeps pins, re-fetch keeps pins,
  manual city over GPS, no location, last cell reuse.
- `weather_snapshot_test.dart`: snapshot content, attack start attaches and
  pins, no cache leaves null, check-in stamped once.
- `environment_screen_test.dart`: populated on first open from the home
  card, airplane mode (source throws) shows the cached hour with "Updated
  4 h ago" and the offline note, empty state, typed-city flow with a fake
  geocoder, failed search message.
- Full suite: 167 tests.

## Acceptance criteria

- [x] Environment screen populated on first open.
- [x] Airplane-mode test shows cached data with its age.
- [x] Nothing more precise than the rounded cell is sent (asserted in the
      sync test).
- [ ] Background refresh observed on a device (needs a phone; see parity).

## Manual checks

- Android: grant "approximate" location only; the screen fills. Deny:
  choose a city instead. Toggle airplane mode and reopen: age shown.
- iOS: same, plus a BGTaskScheduler run via the Xcode debugger command
  `e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"app.migrainetracker.weatherRefresh"]`.

## What M must fill in

Nothing new. The weather call needs the Firebase project from phase 04 and
the deployed function from phase 10; without them the app shows the empty
state and the offline note.

## Risk and rollback

The weather field on attacks and check-ins is nullable; older rows stay
valid. Disabling the feed means removing the home card and the route; the
tables stay.
