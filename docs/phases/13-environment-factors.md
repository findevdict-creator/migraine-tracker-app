# Phase 13: Environment factors

Branch: `13-feat-environment-factors`, cut from `12-feat-barometer`.
Requirement IDs: FR-8 (air quality, pollen with the Europe-only label, UV,
daylight, sunrise and sunset into `environment_day`; factors hidden where
no regional data; "About the data" attribution screen).

## What was done

- **Storage** was already in place since phase 11: the cache payload's
  `days` rows land in `environment_days` (US and EU AQI, PM2.5, PM10,
  ozone, pollen per type, UV max, daylight minutes, sunrise, sunset).
- **Bands** (`features/weather/domain/factor_bands.dart`): `FactorBand.of`
  maps a value to low, moderate, high or very high from the inclusive upper
  bounds in `AppThresholds.aqiUsBands`, `aqiEuBands`, `uvBands` and
  `pollenBands`.
- **Today's factors card** (`EnvironmentFactorsCard`, on the environment
  screen): one row per factor with its band; a row is omitted when the
  value is null, so regions without air-quality or pollen data show only
  what exists. Pollen is labelled "Europe only". The whole card shows a
  short note when the day has no data at all or there is no location.
  Times are rendered in local time with the Material formatter.
- **About the data** (`/about-data`, from the card, the Open-Meteo
  attribution line and Settings > About): lists
  `AppDataSources.entries` from the central config (name, coverage,
  licence, link), what leaves the phone, and the limits of model data.
  Adding a source is one entry in `app_config.dart`.

## Tests

- `factor_bands_test.dart`: inclusive bounds for each factor.
- `environment_factors_test.dart`: every row for a full day, sparse day
  hides missing rows, empty note without a location, About the data lists
  every configured source.
- `scrollToKey` in the test harness now scrolls up as well as down.
- Full suite: 186 tests.

## Acceptance criteria

- [x] Daily factors on the environment screen.
- [x] Attribution screen.

## Manual checks

- Choose a city outside Europe (for example Denver): the pollen row is
  absent and the card still shows AQI and UV.
- Tap "Weather data by Open-Meteo": the About screen opens; tapping a
  source opens the browser.

## What M must fill in

Nothing. If a data source is added or replaced, update
`AppDataSources.entries`.

## Risk and rollback

Presentation only; no schema change.
