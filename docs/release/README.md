# Release runbook

How a version gets from `main` to the stores. The pieces were built in
phase 39; the values (tracks, rollout steps, crash-free target, budgets)
are in `AppRelease` in `lib/config/app_config.dart`.

## One-time setup (M)

### 1. Upload key for Android

Create the upload keystore once and keep it out of the repo (it is
gitignored). Losing it means asking Google to reset the upload key.

```sh
keytool -genkeypair -v -keystore ~/keys/migraine-upload.jks \
  -alias upload -keyalg RSA -keysize 4096 -validity 10000
```

For local release builds, create `android/key.properties`:

```properties
storeFile=/absolute/path/to/migraine-upload.jks
storePassword=...
keyAlias=upload
keyPassword=...
```

Both the phone and the Wear OS app read it. Without it a release build
falls back to the debug key, which Play refuses, so nothing is published
by accident. Turn on Play App Signing when creating the app: Google holds
the app signing key and this one is only the upload key.

### 2. Store accounts and apps

- Google Play Console: create the app with the package name
  `AppIdentity.bundleId`, then fill in App content with
  [play-data-safety.md](../store/play-data-safety.md),
  [play-health-declaration.md](../store/play-health-declaration.md), the
  content rating questionnaire and the listing in
  [listing.md](../store/listing.md). Add a Wear OS form factor so the
  `wear:internal` track exists.
- App Store Connect: create the app with `AppIdentity.iosBundleId`, fill
  in App Privacy with [app-store-privacy.md](../store/app-store-privacy.md)
  and the listing. Register the widget and watch bundle ids
  (`.RiskWidget`, `.watchkitapp`, `.watchkitapp.complication`) with the
  app group and HealthKit capabilities.

### 3. First Play upload by hand

Play only accepts API uploads after the first bundle of a package is
uploaded in the console. Build once locally and upload both to Internal
testing:

```sh
flutter build appbundle --release --flavor prod -t lib/main_prod.dart \
  --dart-define-from-file=env/prod.json
(cd wear && flutter build appbundle --release --flavor prod)
```

### 4. Play service account

In Google Cloud, create a service account, give it access in Play Console
> Users and permissions (Release manager for this app), and download a
JSON key. That key is the `PLAY_SERVICE_ACCOUNT_JSON` secret.

### 5. iOS signing with fastlane match

Create an empty private repository for certificates, then once on a Mac:

```sh
bundle install
cd ios
MATCH_GIT_URL=https://github.com/<org>/<certs-repo>.git \
  bundle exec fastlane match appstore
```

match asks for a passphrase (the `MATCH_PASSWORD` secret) and creates the
distribution certificate and the four App Store profiles listed in
`ios/fastlane/Matchfile`. CI only reads them (`readonly`). Then create an
App Store Connect API key (Users and Access > Integrations, App Manager
role) for the `ASC_*` secrets, and put the Team ID in `APPLE_TEAM_ID`.

### 6. Secrets

GitHub > Settings > Environments: create `production` (add yourself as a
required reviewer, so every release waits for your click, and limit it to
tags matching `v*`) and `staging`. Add the secrets below to the
environment named in the last column. Never commit any of them.

| Secret | What it is | Environment |
| ------ | ---------- | ----------- |
| `ENV_PROD_JSON` | Full contents of `env/prod.json` with real values (CONFIGURATION "Environment files") | production |
| `GOOGLE_SERVICES_PROD_JSON` | `google-services.json` from the prod Firebase project | production |
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 migraine-upload.jks` | production |
| `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` | From step 1 | production |
| `PLAY_SERVICE_ACCOUNT_JSON` | From step 4 | production |
| `APPLE_TEAM_ID` | 10-character Team ID | production |
| `ASC_KEY_ID`, `ASC_ISSUER_ID` | From the App Store Connect API key | production |
| `ASC_KEY_P8` | `base64 -w0 AuthKey_XXXX.p8` | production |
| `MATCH_GIT_URL`, `MATCH_PASSWORD` | From step 5 | production |
| `MATCH_GIT_BASIC_AUTHORIZATION` | `echo -n user:token \| base64` for a token that can read the certificates repo | production |
| `GCP_TEST_LAB_KEY` (optional) | Service account JSON with the Firebase Test Lab Admin role on the staging project; turns on the nightly robo test | staging |
| `ENV_STAGING_JSON`, `GOOGLE_SERVICES_STAGING_JSON` (optional) | Staging versions of the two files, for the nightly Test Lab build | staging |

The release workflow checks for the required secrets first and stops with
the names of any that are missing.

### 7. Budget alerts

In Google Cloud > Billing > Budgets and alerts, create a budget per
Firebase project (staging and prod) of `AppRelease.monthlyBudgetUsd`
dollars with alerts at the `budgetAlertShares` (40% and 100%), emailed to
billing admins. Verify with:

```sh
BILLING_ACCOUNT=XXXXXX-XXXXXX-XXXXXX tool/check_budgets.sh \
  migraine-tracker-staging migraine-tracker-prod
```

Each project prints `ok` or `MISSING`.

## Each release

1. Merge the release branch into `main` (for 1.0.0: the phase PRs #1 to
   #39, in order).
2. Bump `version:` in `pubspec.yaml` and `wear/pubspec.yaml` (same name,
   build number +1) and move the `[Unreleased]` notes in `CHANGELOG.md`
   under a `## [x.y.z]` heading with the date. A PR, as always.
3. Run the parity checklist for the new rows on real devices and tick it.
4. Tag `main` and push the tag:

   ```sh
   git tag v1.0.0 && git push origin v1.0.0
   ```

5. The `release` workflow then:
   - checks the tag matches the version and the changelog
     (`tool/check_release_tag.sh`), analyses and runs the tests;
   - builds the signed, obfuscated Play bundle (prod flavor) and the
     Wear OS bundle, and uploads both to the `internal` and
     `wear:internal` tracks;
   - builds the signed ipa and uploads it to TestFlight with the
     changelog section as the "What to test" note;
   - creates a draft GitHub release with the notes and the bundles.
     Debug symbols are attached to the workflow run (`android-release`,
     `ios-release`). The Dart code is obfuscated, so upload them to
     Crashlytics or stack traces stay unreadable:
     `firebase crashlytics:symbols:upload --app=<Firebase app id> build/symbols/android`
     (and `build/symbols/ios` with the iOS app id).
6. Test the internal and TestFlight builds. Then promote:
   - Play: `bundle exec fastlane android promote` (5% of production).
   - App Store: submit the TestFlight build for review in App Store
     Connect and choose "Phased release for automatic updates".
7. Publish the draft GitHub release.

## Staged rollout and the crash-free gate

Raise the Play rollout one step at a time through
`AppRelease.productionRollout` (5%, 20%, 50%, 100%), each after at least
`minDaysPerRolloutStep` days, and only when crash-free users for the new
version are at least `crashFreeUsersTarget` (99.5%):

- Play Console > Android vitals > Crashes and ANRs: filter by the new
  version code; the user-perceived crash rate must be at most 0.5%.
- App Store Connect > the app > Analytics > Metrics (or Xcode >
  Organizer > Crashes) for the iOS phased release. Pause the phased
  release there if the rate is above target.
- Crashlytics shows the stack traces. It cannot show a crash-free share
  for this app, because that needs Google Analytics, which the app leaves
  out for privacy. Turn on Crashlytics velocity alerts (Crashlytics >
  Settings > Alerts) and regression alerts so a new crash cluster emails
  you within the hour.

```sh
bundle exec fastlane android rollout to:0.2
```

If the rate is above target, halt the rollout in Play Console (Production
> Halt rollout), fix, and ship a new build number through the same path.

## Nightly Test Lab run

With `GCP_TEST_LAB_KEY` and the staging secrets set, the nightly workflow
also builds a staging APK and runs a Firebase Test Lab robo test on a
Pixel 6 (API 33) with performance metrics. Results are in the Test Lab
console of the staging project.

## Sign-off

Before tagging 1.0.0, fill in the sign-off table at the end of
[parity-checklist.md](../parity-checklist.md): every row ticked on both
platforms (or marked n/a), and the open items in CONFIGURATION "What M must
fill in" done.
