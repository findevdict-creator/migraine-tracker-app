# Configuration

Everything configurable is in **`lib/config/app_config.dart`**. This page
lists what each section controls, what M must fill in before a staging or
production build, and the few native files that mirror a value.

## Sections of `app_config.dart`

| Section | Controls | Change when |
| ------- | -------- | ----------- |
| `AppIdentity` | product name, per-flavor display names, bundle id (and the iOS bundle id, which has no underscores), deep-link scheme, support email, privacy and terms URLs, wellness disclaimer | rebranding, new domain |
| `AppEnv` | Firebase options, functions region and base URL, emulator host, Google sign-in client ids, RevenueCat keys (all from `env/*.json`) | never edited directly; fill the env files |
| `AppEndpoints` | Open-Meteo URLs, Cloud Function names | a function is renamed or a provider changes |
| `AppAccounts` | sign-in methods offered (Apple, Google, email), minimum password length, the purge deadline shown to the user (must match `purgeWithinMs` in `functions/src/config.ts`) | changing sign-in options or the deletion promise |
| `AppFeatureFlags` | dev tools, emulator use, crash-reporting availability, per-feature availability | hiding a feature, enabling dev screens |
| `AppIdentity.clinicianGuidanceUrl` | page behind the medication-overuse notes | M publishes or changes it |
| `AppThresholds` | overuse notes (10, 15 days), learning threshold (10 attacks), refresh cadences, forecast window, location rounding, weather retention and stale age, barometer sampling, calibration and gauge range, factor bands (AQI, UV, pollen), health import window and sleep bands, back-fill days, risk learning (attack window, shrinkage, threshold percentiles, history and forecast days, confidence bands, insight lift cut-offs), notification times (risk-rising evening and morning hours, default attack length, medication reminder), dedupe retention and lead time, push token refresh window, default report period, questionnaire reminder interval and hour, chart length, voice listen length, pause and on-device-only switch, widget refresh period and steady-pressure band, routine suggestion trigger and count, paced breathing timing, experiment length and small-sample threshold, attack duration estimate (minimum attacks, intensity band, rounding step) | product decisions |
| `AppDataSources` | every outside data source shown on "About the data": name, coverage, licence, link | a source is added or replaced |
| `AppBackgroundTasks` | identifiers of background jobs (weather refresh), the push wake-up message type | mirrored in `ios/Runner/Info.plist` and `AppDelegate.swift`; the message type must match `config.push.wakeupType` in the functions |
| `AppNotificationChannels` | notification channel ids (alerts, reminders, attack), the iOS category and end-attack action ids, the Android small icon | renaming a channel (Android keeps the old one until reinstall), swapping the icon |
| `AppThemeTokens` | seed colour, risk colours, load meter factor palette, attack theme palette, semantic colours, font family, spacing, radii, tap targets, text scale ceiling, animation durations | design changes |
| `AppAssets` | logo, logo mark, launcher icon, head map, routine illustrations (`assets/routines/<code>.svg`) | replacing artwork (keep the paths, swap the files) |
| `AppHomeWidgets` | Android widget provider class, iOS widget kind and app group, the start-attack link, the keys the widget reads | renaming the native widget or the app group (mirrored natively, see below) |
| `AppWatch` (= `WatchConfig` in `packages/watch_protocol/lib/src/watch_config.dart`) | tile freshness, resend interval, tile channel, the keys the watch stores and the tile reads; the on/off switch is `AppFeatureFlags.watchAvailable` | watch behaviour. The values live in the shared package because the Wear OS app cannot import the phone's config; `app_config.dart` re-exports them |
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
| `APP_FLAVOR` | `dev`, `staging` or `prod`; read by isolates that have no entry point (the push wake-up handler) |
| `FIREBASE_STORAGE_BUCKET` | Firebase console, Storage |
| `FIREBASE_IOS_BUNDLE_ID` | must equal the iOS bundle id of the flavor |
| `FUNCTIONS_REGION` | region chosen when deploying `functions/` |
| `FUNCTIONS_BASE_URL` | leave empty to derive from project id and region |
| `FIREBASE_EMULATOR_HOST` | `10.0.2.2` for the Android emulator, `localhost` for iOS simulator |
| `GOOGLE_SERVER_CLIENT_ID`, `GOOGLE_IOS_CLIENT_ID` | Google sign-in OAuth client ids (phase 32): the web client id for Android, the iOS client id for iOS |
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
6. Push wake-ups (phase 22): enable the Cloud Messaging API on staging
   and prod, upload an APNs key for each iOS app, add the Push
   Notifications capability in Xcode, and enable the Firestore TTL policy
   on `push_tokens.expiresAt`.
7. Questionnaires (phase 24): confirm the HIT-6 licence with
   QualityMetric before a commercial release; MIDAS needs attribution
   only.
8. Home-screen widget on iOS (phase 26): in Xcode add a Widget
   Extension target named `RiskWidget` (deployment target iOS 15), delete
   the generated Swift files and add `ios/RiskWidget/RiskWidget.swift`,
   set its Info.plist to `ios/RiskWidget/Info.plist` and its
   `CODE_SIGN_ENTITLEMENTS` to `ios/RiskWidget/RiskWidget.entitlements`.
   On the Runner target set `CODE_SIGN_ENTITLEMENTS` to
   `Runner/Runner.entitlements`. Enable the App Groups capability on both
   targets with `group.app.migrainetracker.migraineTracker` (register
   the group in the Apple Developer portal first). Android needs nothing.
9. Wear OS release (phase 27): sign the watch app with the same upload
   key as the phone app and upload it to the same Play listing as a Wear
   OS release; the data layer only pairs apps with the same package name
   and signing key.
10. Apple Watch app (phase 28): add the watch app and its complication
    to `ios/Runner.xcodeproj` as described in `docs/phases/28-watchos.md`
    ("Adding the watch app to Runner"), so it ships inside the iPhone
    app. CI builds the watch app on its own from `ios/RiskWatch/project.yml`
    until then.
11. Self-care routines (phase 29): have a clinician review the routine
    wording in `docs/content/routines-review.md` before the first public
    release, and replace the placeholder illustrations in
    `assets/routines/` (keep the file names).
12. Accounts (phase 32), in the Firebase console for each project:
    - Authentication > Sign-in method: turn on Apple, Google and
      Email/Password.
    - Google: copy the web client id into `GOOGLE_SERVER_CLIENT_ID` and
      the iOS client id into `GOOGLE_IOS_CLIENT_ID`. Add the Android
      signing SHA-1 and SHA-256 fingerprints to the Android app. On iOS,
      add the reversed iOS client id as a URL type in
      `ios/Runner/Info.plist`.
    - Apple: turn on "Sign in with Apple" for the App ID in the Apple
      developer portal. The entitlement is already in
      `ios/Runner/Runner.entitlements`.
    - Logging: create an alert on the log line "account purge behind
      schedule" from `accountPurgeSweep`.
13. Repository settings on GitHub: protect `main` (require PR, require the
   `pr` workflow jobs, require conversation resolution, block force pushes
   and deletions, merge commits only, delete head branches on merge).

## Server-side configuration

`functions/src/config.ts` is the single configuration file for the Cloud
Functions: region, cache freshness and TTL, cell size, Open-Meteo URLs and
secret names, the push wake-up schedule, token TTL and batch size,
share-link lifetimes, purge deadline and sweep schedule, collection and storage names. Values shared with the app (region, function names, cell size) must
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
| Notification permissions and receivers | `AppNotificationChannels` | `AndroidManifest.xml` (`POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, the `flutterlocalnotifications` receivers), `android/app/build.gradle.kts` (core library desugaring), `ios/Runner/AppDelegate.swift` (notification centre delegate) |
| Health purpose texts | reasons shown on the Health data screen (ARB) | `ios/Runner/Info.plist` (`NSHealthShareUsageDescription`, `NSHealthUpdateUsageDescription`), `AndroidManifest.xml` health permissions, `docs/store/play-health-declaration.md` |
| Microphone and speech purpose texts | voice logging (phase 25) | `ios/Runner/Info.plist` (`NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription`), `AndroidManifest.xml` (`RECORD_AUDIO`, `RecognitionService` query) |
| Location purpose text | wording in `AppIdentity` privacy copy | `ios/Runner/Info.plist` (`NSLocationWhenInUseUsageDescription`), `AndroidManifest.xml` (`ACCESS_COARSE_LOCATION`) |
| Home-screen widget | `AppHomeWidgets` (provider, kind, app group, keys, start link), `AppThresholds.widgetRefresh`, `AppThemeTokens` risk colours | `android/app/src/main/kotlin/.../RiskWidgetProvider.kt` (keys, start link), `res/xml/risk_widget_info.xml` (`updatePeriodMillis`), `res/values/widget.xml` and `values-night/widget.xml` (colours, fallback strings), `AndroidManifest.xml` (receiver, `LAUNCH` intent filter); `ios/RiskWidget/RiskWidget.swift` (kind, app group, keys, colours, start link, 30-minute timeline), `ios/RiskWidget/RiskWidget.entitlements` and `ios/Runner/Runner.entitlements` (app group) |
| Wear OS app | `AppIdentity.bundleId`, flavors, `AppWatch` | `wear/android/app/build.gradle.kts` (`applicationId` and flavor suffixes must equal the phone's, or the data layer will not connect), `wear/android/.../RiskTileService.kt` (tile keys, freshness), `wear/android/.../MainActivity.kt` (tile channel) |
| Apple Watch app | `AppIdentity.iosBundleId`, `AppHomeWidgets.iosAppGroup`, `AppWatch` | `ios/RiskWatch/WatchProtocolKit/Sources/WatchProtocolKit/WatchConfig.swift` (app group, resend interval, complication refresh, storage keys), `ios/RiskWatch/project.yml` (watch bundle ids), `ios/RiskWatch/App/Info.plist` (`WKCompanionAppBundleIdentifier`), the two `.entitlements` files (app group). The message format is checked against `packages/watch_protocol/test/fixtures/` by the Swift tests |
| Deep-link scheme | `AppIdentity.deepLinkScheme` | `ios/Runner/Info.plist` (`CFBundleURLTypes`), `AndroidManifest.xml` widget intent filter |
| Launcher icon | `AppAssets.launcherIcon` | `android/app/src/main/res/mipmap-*`, `ios/Runner/Assets.xcassets/AppIcon.appiconset` (generated with `flutter_launcher_icons` in the release-prep phase) |
