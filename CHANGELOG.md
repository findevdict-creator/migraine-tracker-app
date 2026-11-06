# Changelog

All notable changes to this project are documented here. The format follows
Keep a Changelog and entries are generated from Conventional Commit types at
release time.

## [Unreleased]

### Added
- Environment factors: daily air quality, particulates, ozone, pollen
  (Europe only), UV, daylight and sun times on the environment screen,
  hidden where the region has no data; "About the data" screen listing
  every source from the central config (13).
- Barometer: live sensor gauge, 24 h on-device trend, calibration offset
  against the station series, sensor and station pressure stamped at
  attack start, "from nearest station" fallback; schema version 2 (12).
- Weather feed: while-using location rounded to a 0.1-degree cell before any
  call, typed-city fallback, local weather store, 3, 6, 12 and 24 h pressure
  deltas, weather attached to every attack and check-in at save time,
  foreground refresh every 3 h and daily background refresh, environment
  screen with the 72 h pressure view and forecast age (11).
- Weather cache function: per-cell Open-Meteo forecast and air-quality
  cache in Firestore with a 3 h freshness window, 48 h TTL and a compact
  sub-5 KB payload; unit, load and emulator tests (10).
- Export and delete: JSON and CSV export of every table through the share
  sheet, re-importable JSON, delete everything with confirmation, settings
  screen skeleton (09).
- Cycle tracking: opt-in toggle, period start logging, derived cycle day
  and phase stored per check-in day (08).
- Medication log: acute and preventive doses with suggestions, dose, time
  and relief at 2 h, inside an attack and standalone, acute-day counter per
  month with the gentle notes at 10 and 15 days (07).
- Daily check-in: three-tap screen, optional second row, 7-day back-fill
  strip, per-field source column, reminder time setting, home card (06).
- Attack log: one-tap start, attack screen in the attack theme, head map,
  symptom chips with per-tap times, phases on one record, end and finish
  later, every edit persisted at once (05).
- Firebase setup: options from the central config per flavor, App Check,
  opt-in Crashlytics, emulator suite, security rules with emulator tests,
  TypeScript Cloud Functions project with lint, Jest and CI (04).
- Design system: light, dark and attack themes from the config tokens,
  semantic colours, type scale with 200% clamp, reduce-motion helpers, core
  widgets, theme gallery and golden tests (03).
- Local database: 12 Drift tables, SQLCipher encryption with the key in
  the platform keystore, DAOs, schema dump and migration test (02).
- Project scaffold: Flutter app with dev, staging and prod flavors, central
  configuration file, lint and format rules, git hooks, CI workflows and the
  contribution conventions (01).
