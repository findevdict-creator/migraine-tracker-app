# Phase 12: Barometer

Branch: `12-feat-barometer`, cut from `11-feat-weather-feed`.
Requirement IDs: FR-7 (live sensor reading and gauge, 24 h on-device
trend, stamp at attack start, calibration offset against the station
series, "from nearest station" fallback).

## What was done

- **Schema version 2**: new `barometer_readings` table (`at` primary key,
  raw `hpa`), migration step `createTable`, schema dump
  `drift_schemas/drift_schema_v2.json` and generated verifier. The migration
  test now covers 1 to 2.
- **Sensor source** (`features/barometer/data/barometer_sources.dart`):
  `sensors_plus` barometer stream at UI interval. No sensor, no plugin or no
  services binding all yield an empty stream, never an error.
- **Sampler** (`liveReadingProvider`): while watched (the home screen does),
  exposes the newest reading and stores one sample per
  `AppThresholds.barometerSampleInterval` (10 min), pruning samples older
  than `barometerRetention` (48 h). Sampling happens while the app is open;
  there is no background service for the sensor.
- **Calibration** (`PressureCalibration.from`): pairs the last sensor sample
  of each hour with the station hour from the weather store, median of
  `station - sensor` over `barometerCalibrationWindow` (24 h), only once
  `barometerCalibrationMinPairs` (3) exist. Applied to the gauge and the
  trend, not to the stored samples.
- **Gauge screen** (`/barometer`, reached from the environment screen):
  half-ring gauge over `barometerGaugeMinHpa..MaxHpa`, calibrated value,
  origin line ("From this device's sensor" or "From the nearest station"),
  calibration card, 24 h sparkline with sample count, note about stamping.
  Falls back to the station value of the current hour when the sensor is
  silent for longer than `barometerStampMaxAge`.
- **Attack stamp** (`SensorPressureStamp`, now the default
  `pressureStampSourceProvider`): raw sensor value (live, else the newest
  stored sample within 15 min) and the station pressure for the hour, both
  nullable, written to `attacks.pressure_sensor_hpa` and
  `attacks.pressure_station_hpa` at attack start.
- Test harness: `pumpApp` and `pumpLocalized` take a `barometer:` source and
  default to none, so the platform channel is never touched under test.

## Tests

- `pressure_calibration_test.dart`: median offset, minimum pairs, last
  sample per hour, hours without station data, display value precedence.
- `barometer_sampler_test.dart`: one sample per interval and pruning, no
  sensor leaves the live value null, attack start stamps sensor and
  station, recent stored sample used and stale one ignored, station
  fallback, calibration after three pairs.
- `barometer_screen_test.dart`: live value updates with readings, station
  fallback without a sensor.
- `test/core/db`: table count and the 1 to 2 migration.
- Full suite: 180 tests.

## Acceptance criteria

- [x] Gauge screen.
- [x] Attack records carry sensor and station pressure.
- [ ] Verified on a phone with a barometer (parity row).

## Manual checks

- Phone with a barometer: open the gauge, watch the value move when the
  phone is lifted a few floors; start an attack and check both pressures in
  the JSON export.
- Phone without one: the gauge says "From the nearest station".

## What M must fill in

Nothing.

## Risk and rollback

Schema bump is additive. Reverting drops the gauge and returns the attack
stamp to the empty implementation; existing attack columns stay.
