# Phase 40: Branding

Branch: `40-feat-branding`, cut from `39-feat-release-prep`.
Not in the original plan: M chose the name **Aurawell** and the domain
**aurawell.app** before the first store upload, and chose to change the
bundle id at the same time (a one-way door once an app is in a store, so
it had to happen now).

## What was done

### Name, domain and ids in the central config

`AppIdentity` in `lib/config/app_config.dart` now reads:

| Field | Value |
| ----- | ----- |
| `name` / `shortName` | `Aurawell` |
| `wordmark` | `aurawell` (lowercase, next to the logo mark) |
| `displayName(dev)` | `Aurawell (dev)`; staging `Aurawell (beta)` |
| `bundleId` / `iosBundleId` | `app.aurawell.mobile` (no underscore, so both platforms share it) |
| `deepLinkScheme` | `aurawell` |
| support / privacy / terms / website | `support@aurawell.app`, `https://aurawell.app/...` |
| `AppTasks.weatherRefresh` | `app.aurawell.weatherRefresh` |

The native mirrors changed with it: Gradle namespace, application id and
`app_name` resValues (phone and Wear OS), the Kotlin package directories
(`app/aurawell/mobile`, `app/aurawell/wear`), the iOS bundle ids in the
Xcode project, ExportOptions, fastlane Appfiles and Matchfile, the watch
`project.yml`, the app group `group.app.aurawell.mobile` in every
entitlements file, the URL scheme in `Info.plist` and the widget Swift
code, the BGTask identifier, and the Wear tile channel
`app.aurawell/wear_tile`. `test/config/release_config_test.dart` still
checks that the copies match the config.

Suggested Firebase project ids became `aurawell-dev`, `-staging`, `-prod`
(`.firebaserc`, env files, docs), the rules emulator project
`aurawell-rules-test`, the export format tag `aurawell-export` and the
report file prefix `aurawell-report`. None of these existed outside the
repo yet, so nothing had to migrate.

### Translations

`appTitle` is `Aurawell` in all seven ARB files (a product name is not
translated); the pseudo locale was regenerated.

### Logo

`assets/brand/logo_mark.svg` is a rounded head profile facing right with
a small rising arc above the forehead (the aura), white on the theme seed
colour `#5B5BD6`, in a rounded square. `assets/brand/logo.svg` adds the
lowercase `aurawell` wordmark in the seed colour. `tool/store_assets`
renders the launcher icons and store graphics from the mark and reads the
wordmark from the config for the Play feature graphic;
`dart run flutter_launcher_icons` then writes the platform icon sets.
The iOS `Contents.json` is kept as committed (the tool rewrites it in a
one-line form with the same entries).

### Hotfix rule

M decided that every fix goes through the stack, with no branch cut from
`main`. CONTRIBUTING.md and the release runbook say so.

## What M must do

- Register `aurawell.app` and point `support@`, `/privacy`, `/terms` and
  `/talk-to-your-clinician` somewhere before the store listing goes live.
- Create the Firebase projects and register the Android and iOS apps with
  the new ids (`app.aurawell.mobile`, `.dev`, `.staging`).
- Create the store apps with the new package name and bundle id.

## Parity checklist

Row 40 covers the launcher name and icon, the deep link scheme and the
name on shared reports.
