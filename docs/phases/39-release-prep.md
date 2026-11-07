# Phase 39: Release prep

Branch: `39-feat-release-prep`, cut from `38-feat-accessibility-pass`.
Plan row: store assets, iOS privacy manifest, Play data safety form and
health declaration, fastlane lanes, release workflow on tags, version
1.0.0, crash-free threshold, budget alerts verified, feature-parity
checklist signed off.

## What was done

### Version 1.0.0

`pubspec.yaml` and `wear/pubspec.yaml` are `1.0.0+1`, the functions
package is `1.0.0`, and `CHANGELOG.md` has a `## [1.0.0]` section with an
empty `[Unreleased]` above it. The date is added when M tags.

### Release values in one place

A new `AppRelease` section in `app_config.dart` holds the tag prefix, the
Play tracks for the phone and the watch, the staged rollout steps (5%,
20%, 50%, 100%), the crash-free users target (99.5%) and the minimum days
per step, the Wear OS version code offset, and the monthly budget and its
alert shares. Fastlane (Ruby), Gradle (Kotlin) and the shell scripts
cannot import Dart, so they keep copies; `test/config/release_config_test.dart`
fails if a copy drifts, and also checks the bundle ids in the store files,
that phone and watch share a version with a changelog section, that the
launcher icon comes from `AppAssets` and the seed colour, and that the
privacy manifest is in the iOS bundle.

### Signing

- `android/app/build.gradle.kts` signs release builds with the upload key
  from `android/key.properties`, or from the `ANDROID_KEYSTORE_*` and
  `ANDROID_KEY_*` environment variables in CI. Without either it falls
  back to the debug key, which Play refuses, so a misconfigured build
  cannot be published.
- The Wear OS app uses the same key and adds `wearVersionCodeOffset`
  (100,000,000) to its version code, because Play needs every bundle of
  one package name to have a distinct code.
- iOS uses fastlane match (`ios/fastlane/Matchfile`) for the app, the
  widget and the two watch targets, with manual signing in
  `ios/ExportOptions.plist`.
- `.gitignore` now covers key stores, `key.properties`, `.p8` keys,
  provisioning profiles and build outputs.

### Icons and store graphics

`tool/store_assets/render.mjs` renders, with headless Chromium, the
launcher icon (full bleed and adaptive foreground), the Play 512 icon, the
App Store 1024 icon and the Play feature graphic (1024 × 500) from
`assets/brand/logo_mark.svg`, `AppIdentity.name` and
`AppThemeTokens.seed`. `flutter_launcher_icons` (configured in
`pubspec.yaml` from `AppAssets.launcherIcon` and the seed colour) then
wrote the Android mipmaps and adaptive icon and the iOS icon set. Swapping
the logo file and re-running both updates every icon.

### Privacy

- `ios/Runner/PrivacyInfo.xcprivacy`: no tracking; collected types are
  email, user id, health (share link only), purchase history, coarse
  location, device id, crash data and other diagnostics (the opt-in audit
  counts); required-reason APIs are UserDefaults (CA92.1, 1C8F.1 for the
  widget's app group) and file timestamps (C617.1). It is added to the
  Runner target's resources.
- `docs/store/play-data-safety.md` and `docs/store/app-store-privacy.md`
  answer the two store forms with the same facts, and say why on-phone
  data (attacks, check-ins, health data, the encrypted backup) is not
  "collected".
- `docs/store/play-health-declaration.md` is final for 1.0.0.
- `docs/store/listing.md` has the name, subtitle, short and full
  description, keywords, category, content rating and the screenshot
  list, written to the same copy rules as the app (no "predict",
  "diagnose" or "cure").

### Fastlane and the release workflow

- `Gemfile` pins fastlane. `android/fastlane` has `internal` (phone and
  watch bundles to internal testing), `promote` (internal to production
  at 5%) and `rollout to:<step>` (raise production to one of the
  configured steps). `ios/fastlane` has `certificates` (match, read-only)
  and `beta` (TestFlight with the changelog as the test notes), both
  using an App Store Connect API key.
- `.github/workflows/release.yml` runs on `v*` tags: it checks the tag
  against the version and changelog (`tool/check_release_tag.sh`), runs
  analyze and tests, then in the `production` environment builds the
  signed, obfuscated Play and Wear OS bundles and the ipa, uploads them
  to internal testing and TestFlight, keeps the debug symbols as
  artifacts, and drafts a GitHub release with the notes
  (`tool/release_notes.sh`). Each job first lists any missing secret by
  name.
- The nightly workflow gained an optional Firebase Test Lab robo run of a
  staging build on a Pixel 6, which starts once M adds the key.

### Crash-free gate and budgets

The rollout runbook (`docs/release/README.md`) gates each step on 99.5%
crash-free users from Play's Android vitals and App Store Connect, with
Crashlytics velocity and regression alerts for new crash clusters.
Crashlytics itself cannot compute the crash-free share for this app
because that needs Google Analytics, which the app leaves out on purpose.
`tool/check_budgets.sh` verifies with `gcloud` that each Firebase project
has a budget of `monthlyBudgetUsd` with alerts at the configured shares.

### Parity sign-off

`docs/parity-checklist.md` has row 39 (release builds install, icons,
privacy report) and a sign-off table for Android, iOS, the clinician copy
review and M's release approval. The sign-off itself needs real devices
and is M's step before tagging.

## What M must fill in

All of it is in CONFIGURATION item 17 and the runbook
`docs/release/README.md`: upload key, store apps and forms, first manual
Play upload, match repo, App Store Connect API key, Play service account,
GitHub Environments and secrets, budgets, final artwork, screenshots,
sign-off, then `git tag v1.0.0`.

## Checks

- `flutter analyze --fatal-infos`, format, copy lint, string lint,
  pseudo-locale check: clean.
- `flutter test`: all pass, including the 7 new release config tests.
- `ruby -c` on both Fastfiles; the workflow YAML parses.
- Not run here: real signing, store uploads, Test Lab and `gcloud`
  budget checks, which need M's accounts. No Android SDK or Xcode in this
  environment, so the release builds themselves run first in CI on the
  tag.
