# Changelog

All notable changes to this project are documented here. The format follows
Keep a Changelog and entries are generated from Conventional Commit types at
release time.

## [Unreleased]

### Added

- Accuracy self-audit: after ten attacks, Settings > How the risk level has done shows how many attacks followed a High day, how many High days passed without one, and the trend by month, scored against a frozen record of the level shown each day so relearning cannot flatter it. Optional, off by default: share the five monthly counts and the model version anonymously, with no dates, places or account (36).

- Premium: store subscriptions through RevenueCat unlock the clinician share link, experiments, extended environment factors (particulates, ozone, pollen) and backup across phones. Logging, the weather feed, the risk level, insights, the medication log and the doctor report stay free with no time limit. Purchases follow the account, and the server checks Premium before creating a share link (35).

- Clinician share link: from Doctor report, create a 7 or 30 day read-only web link that shows the same report as the PDF; stop sharing at any time from Settings > Shared links. The server keeps only the report snapshot under a random 128-bit token and deletes it on expiry (34).

- End-to-end encrypted backup: Settings > Encrypted backup locks the whole database on the phone with an Argon2id key from a passphrase (AES-256-GCM), uploads it over a certificate-pinned connection, and restores it on a fresh install or a second phone (33).

- Optional account: sign in with Apple, Google or email from Settings > Account; the app stays fully usable signed out. Deleting the account purges its server data (backup, share links, audit counts) within 24 hours, with an hourly retry sweep (32).

- Attack duration estimate: while an attack runs, a card shows how long similar attacks usually last as a range, with how many past attacks it is based on, after five completed attacks (31).

- Experiments: try one change for two weeks with a daily "did you stick with it" question, then compare attacks per week, intensity and duration with the two weeks before, with sample sizes and a plain caveat (30).

- Self-care routines: stretches, paced breathing with a guided timer, low light, water, caffeine and sleep, suggested on home on high days and after high neck-tension or stress check-ins, with "Not today" (29).

- Apple Watch companion: start and end an attack and set the intensity from the watch, with taps saved until the iPhone is near, and a watch-face complication with today's level (28).

- Wear OS companion: start and end an attack and set the intensity from the watch, with taps saved on the watch until the phone is near, and a tile with today's level (27).

- Home-screen widgets on Android and iOS: today's level, the top factor, the pressure trend and a one-tap start-attack button that opens the attack (or the running one) in the app (26).

- Voice log: on-device speech on the attack screen fills intensity, symptoms, head locations and the person's own medications, shown on a confirmation form before anything is saved (25).

- Questionnaires: MIDAS and HIT-6 with the published scoring and bands, a score-history chart, a three-month reminder and an optional section in the doctor report (24).

- Doctor report: on-device PDF and two CSV files for a chosen period (attack calendar, monthly counts, duration, factors with sample sizes, medication days, pressure correlation, symptoms), shared through the OS share sheet from Settings > Doctor report (23).
- Push wake-up: a scheduled silent push refreshes the forecast and
  re-plans the local alerts between opens; tokens registered without an
  account (22).
- Notifications: risk rising, pressure drop, "is your attack over?" with
  an end-attack action, check-in and medication reminders, each with its
  own switch, planned on the phone and deduplicated by event key (21).
- Insights: every factor sorted into more-attacks-followed, fewer,
  no clear effect and not enough data, with sample sizes and ratios,
  plus a method page (20).
- Load meter: stacked 0 to 100 bar with one named, tappable segment per
  factor and Moderate/High marks that follow the learned thresholds, on
  the home card and the risk screen, with goldens (19).
- Risk card: today's level with the top three drivers in plain words,
  confidence label, still-learning badge and the next three days on
  home; a risk screen with every driver's points, the explainer link
  and the disclaimer; home scrolls (18).
- Personal re-weighting: learner with per-factor lift, shrinkage and
  own-distribution thresholds; inputs built from weather, environment,
  check-ins, health sleep and cycle; weights re-learned after each attack
  and today plus three days scored and stored on open (17).
- Risk model core: pure Dart package `packages/risk_model` with 14
  factor modules, population weights, deterministic 0 to 100 daily load
  with drivers, levels, model version, five fixture users with frozen
  outputs, scoring CLI and a 100 % coverage gate in CI (16).
- Onboarding: first-run flow with the level explainer, location, health
  consent and reminder time, landing on the populated environment screen;
  explainer reachable from Settings; device integration test for the 60 s
  target (15).
- Health sync: per-type consent for sleep, resting heart rate, HRV, steps
  and menstrual flow with plain-language reasons, Health Connect history
  permission, sleep pre-fill on the check-in with a source icon, period
  starts from flow, headache events written back on opt-in, Play health
  declaration draft (14).
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
