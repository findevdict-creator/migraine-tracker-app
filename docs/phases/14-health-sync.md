# Phase 14: Health sync

Branch: `14-feat-health-sync`, cut from `13-feat-environment-factors`.
Requirement IDs: FR-15, FR-17 (health package for sleep, resting heart
rate, HRV, steps and menstrual flow; per-type consent with plain-language
reasons; Health Connect history permission; headache events written to the
store on opt-in; check-in pre-fill with source icons). Privacy NFR: raw
samples never leave the device.

## What was done

- **Domain** (`features/health/domain/`): `HealthType` (codes match the
  `health_samples.type` column), `HealthStore`, `FlowLevel`,
  `HealthSampleEntity`, `HealthConsent` (stored as a map under
  `health.consent`), `sleepQualityFromMinutes` using
  `AppThresholds.sleepQualityMinuteBands`.
- **Source** (`PackageHealthSource`): the `health` package. Sleep asleep,
  resting HR, HRV (SDNN on Apple Health, RMSSD on Health Connect), steps,
  menstrual flow. `requestRead` asks only for the switched-on types;
  `requestHistory` asks Health Connect for the 30-day history permission
  the first time any type is enabled; `writeHeadache` writes mild,
  moderate, severe or unspecified from the attack intensity. Phones only:
  elsewhere `NoHealthSource`.
- **Sync** (`HealthSync`): `setConsent` asks the store, stores consent and
  imports; switching off deletes that type's samples. `sync()` imports from
  the latest stored sample end (or `healthImportDays` back), stamps
  `health.lastImport`, then derives: sleep minutes of the night (noon to
  noon) map to sleep quality on each check-in of the back-fill window with
  the store as source, never over a typed value; a bleeding day after a
  non-bleeding day becomes a period start through `CycleLog.addPeriodStart`
  (idempotent, only while cycle tracking is on). `exportAttack` runs from
  `AttackEditor.end()` when the write-back switch is on.
- **Health data screen** (`/health`, from Settings): availability note,
  one switch per type with its reason, write-back switch, "Import now" with
  the last import age and the result line. A denied request leaves the
  switch off and shows a snack bar.
- **Check-in**: a heart icon with a tooltip next to a field whose source is
  Apple Health or Health Connect.
- **Platform**: Android read permissions per type, history permission,
  the rationale intent filter and the permission-usage alias, Health
  Connect package query; iOS `NSHealthShareUsageDescription` and
  `NSHealthUpdateUsageDescription`.
- **Store text**: `docs/store/play-health-declaration.md` drafts the Play
  Health Connect declaration.
- Config: `AppFeatureFlags.healthSyncAvailable`,
  `AppThresholds.healthImportDays`, `sleepQualityMinuteBands`.

## Tests

- `health_entities_test.dart`: sleep bands, consent JSON, codes.
- `health_sync_test.dart`: consent asks and imports 30 days, denied leaves
  consent off, incremental import since the last end with duplicates
  ignored, sleep pre-fill with source and typed values untouched, period
  starts from flow (idempotent), switching off deletes, a failing store
  keeps data and reports, headache written only when opted in and once per
  attack, refused write stays off.
- `health_settings_screen_test.dart`: every switch with its reason,
  turning sleep on asks the store and shows the import age, denied store,
  source icon on the check-in, disabled switches without a store.
- Full suite: 202 tests.

## Acceptance criteria

- [x] Health settings screen.
- [x] Imported samples visible in the check-in (sleep pre-fill with icon).
- [x] Play health declaration text drafted in the repo.

## Manual checks

- Android with Health Connect: turn on Sleep, accept the prompt and the
  history prompt; the check-in shows last night's sleep with the icon.
- iOS: same with Apple Health; end an attack with write-back on and find
  the headache in the Health app.

## What M must fill in

- iOS: enable the HealthKit capability on the Runner target in Xcode (it
  adds `com.apple.developer.healthkit` to the entitlements file and the
  App ID). Without it, every Apple Health call returns "not granted".
- Play Console: paste `docs/store/play-health-declaration.md` into the
  Health apps declaration at submission (phase 39).

## Risk and rollback

No schema change. `AppFeatureFlags.healthSyncAvailable = false` hides the
route and the settings row; consent stays stored but nothing is read.
