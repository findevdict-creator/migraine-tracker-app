# Configuration

Everything configurable is in **`lib/config/app_config.dart`**. This page
lists what each section controls, what M must fill in before a staging or
production build, and the few native files that mirror a value.

## Sections of `app_config.dart`

| Section | Controls | Change when |
| ------- | -------- | ----------- |
| `AppIdentity` | product name, per-flavor display names, bundle id, deep-link scheme, support email, privacy and terms URLs, wellness disclaimer | rebranding, new domain |
| `AppEnv` | Firebase options, functions region and base URL, emulator host, RevenueCat keys (all from `env/*.json`) | never edited directly; fill the env files |
| `AppEndpoints` | Open-Meteo URLs, Cloud Function names | a function is renamed or a provider changes |
| `AppFeatureFlags` | dev tools, emulator use, crash-reporting availability, per-feature availability | hiding a feature, enabling dev screens |
| `AppIdentity.clinicianGuidanceUrl` | page behind the medication-overuse notes | M publishes or changes it |
| `AppThresholds` | overuse notes (10, 15 days), learning threshold (10 attacks), refresh cadences, forecast window, location rounding, weather retention and stale age, barometer sampling, calibration and gauge range, factor bands (AQI, UV, pollen), health import window and sleep bands, back-fill days, risk learning (attack window, shrinkage, threshold percentiles, history and forecast days, confidence bands, insight lift cut-offs) | product decisions |
| `AppDataSources` | every outside data source shown on "About the data": name, coverage, licence, link | a source is added or replaced |
| `AppBackgroundTasks` | identifiers of background jobs (weather refresh) | mirrored in `ios/Runner/Info.plist` and `AppDelegate.swift`; change all three together |
| `AppThemeTokens` | seed colour, risk colours, load meter factor palette, attack theme palette, semantic colours, font family, spacing, radii, tap targets, text scale ceiling, animation durations | design changes |
| `AppAssets` | logo, logo mark, launcher icon, head map, routine illustrations | replacing artwork (keep the paths, swap the files) |
| `AppLocales` | supported locales, fallback | adding a language |

## The risk model

The population rules (ramps, steps and weights per factor) and the
default level thresholds live in `packages/risk_model/lib/src/factors/`
and `thresholds.dart`, not in `app_config.dart`, because changing them
changes stored results: every change needs a `modelVersion` bump and a
refreeze of the fixtures (`dart run risk_model:score --write-expected
test/fixtures/users/*.json`). The app-facing knobs (learning threshold,
look-back window, display colours) stay in `app_config.dart`.

## Environment files

Build with `--dart-define-from-file=env/<flavor>.json`.

| File | Committed | Purpose |
| ---- | --------- | ------- |
| `env/dev.json` | yes, placeholders only | dev builds use the Firebase emulator, no real keys needed |
| `env/staging.json` | no (git-ignored) | copy from `env/staging.json.example` and fill in |
| `env/prod.json` | no (git-ignored) | copy from `env/prod.json.example` and fill in |

Keys and where to find the values:

| Key | Source |
| --- | ------ |
| `FIREBASE_PROJECT_ID` | Firebase console, project settings |
| `FIREBASE_API_KEY` | Firebase console, project settings, Web API key |
| `FIREBASE_APP_ID_ANDROID`, `FIREBASE_APP_ID_IOS` | Firebase console, Your apps |
| `FIREBASE_MESSAGING_SENDER_ID` | Firebase console, Cloud Messaging (project number) |
| `FIREBASE_STORAGE_BUCKET` | Firebase console, Storage |
| `FIREBASE_IOS_BUNDLE_ID` | must equal the iOS bundle id of the flavor |
| `FUNCTIONS_REGION` | region chosen when deploying `functions/` |
| `FUNCTIONS_BASE_URL` | leave empty to derive from project id and region |
| `FIREBASE_EMULATOR_HOST` | `10.0.2.2` for the Android emulator, `localhost` for iOS simulator |
| `REVENUECAT_API_KEY_ANDROID`, `REVENUECAT_API_KEY_IOS` | RevenueCat project API keys (phase 35) |

CI secrets (set in the GitHub Environments `staging` and `production`, never
in the repo): signing keys, Firebase service accounts, the Open-Meteo
commercial key (used only by the cache function), RevenueCat keys.

## What M must fill in

1. Create three Firebase projects (`migraine-tracker-dev`, `-staging`,
   `-prod`) on the Blaze plan with budget alerts at $10 and $25.
2. Copy the example env files and fill the Firebase values for staging and
   prod. Dev needs nothing beyond the emulator.
3. Replace the placeholder artwork under `assets/brand/` (keep the file
   names).
4. Set the real support email, privacy and terms URLs in `AppIdentity`.
5. Xcode: enable the HealthKit capability on the Runner target (phase 14)
   and confirm Background Modes shows fetch and processing (phase 11).
6. Repository settings on GitHub: protect `main` (require PR, require the
   `pr` workflow jobs, require conversation resolution, block force pushes
   and deletions, merge commits only, delete head branches on merge).

## Server-side configuration

`functions/src/config.ts` is the single configuration file for the Cloud
Functions: region, cache freshness and TTL, cell size, Open-Meteo URLs and
secret names, share-link lifetimes, purge deadline, collection and storage
names. Values shared with the app (region, function names, cell size) must
match `lib/config/app_config.dart`.

Secrets for functions live in Secret Manager (`firebase functions:secrets:set
OPEN_METEO_API_KEY`), never in the repo.

## Native mirrors of config values

These cannot be read from Dart at build time, so they mirror `AppIdentity`:

| Value | Dart | Native |
| ----- | ---- | ------ |
| Application id and flavor suffixes | `AppIdentity.bundleId`, `bundleIdFor` | `android/app/build.gradle.kts` (`applicationId`, `productFlavors`), iOS target bundle id per scheme |
| Display name per flavor | `AppIdentity.displayName` | `android/app/build.gradle.kts` (`resValue app_name`), `ios/Runner/Info.plist` (`CFBundleDisplayName`) |
| Background task identifier | `AppBackgroundTasks.weatherRefresh` | `ios/Runner/Info.plist` (`BGTaskSchedulerPermittedIdentifiers`), `ios/Runner/AppDelegate.swift` (`registerPeriodicTask`) |
| Health purpose texts | reasons shown on the Health data screen (ARB) | `ios/Runner/Info.plist` (`NSHealthShareUsageDescription`, `NSHealthUpdateUsageDescription`), `AndroidManifest.xml` health permissions, `docs/store/play-health-declaration.md` |
| Location purpose text | wording in `AppIdentity` privacy copy | `ios/Runner/Info.plist` (`NSLocationWhenInUseUsageDescription`), `AndroidManifest.xml` (`ACCESS_COARSE_LOCATION`) |
| Launcher icon | `AppAssets.launcherIcon` | `android/app/src/main/res/mipmap-*`, `ios/Runner/Assets.xcassets/AppIcon.appiconset` (generated with `flutter_launcher_icons` in the release-prep phase) |
