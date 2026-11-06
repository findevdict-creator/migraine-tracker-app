# Migraine Tracker

A cross-platform (Android and iOS) migraine tracker built in Flutter: a
30-second attack-mode log, an automatic weather and pressure feed, and an
explainable Low / Moderate / High daily risk level that shows its drivers,
its confidence and its own hit rate. Local-first, no account required.

Requirements, research and the implementation plan live in the project
docs; this repository follows the plan's 39 numbered branches.

## Quick start

```bash
# Flutter version is pinned in .fvmrc (use fvm, or install that version)
flutter pub get
flutter gen-l10n
flutter run -t lib/main_dev.dart --flavor dev --dart-define-from-file=env/dev.json
```

Checks that CI runs, in order:

```bash
dart format --set-exit-if-changed lib test tool
flutter analyze --fatal-infos
dart run tool/copy_lint.dart
dart run tool/string_lint.dart
flutter test
```

## One place to configure everything

`lib/config/app_config.dart` holds every configurable value: app name and
identifiers, flavor behaviour, colours and type tokens, asset paths, API
endpoints and function names, feature flags, thresholds and supported
locales. Change it there and the whole app follows. Secrets are never in that
file; they arrive through `env/<flavor>.json` with `--dart-define-from-file`.
See [docs/CONFIGURATION.md](docs/CONFIGURATION.md) for the full list and what
must be filled in before a staging or production build.

## Flavors

| Flavor  | Entry point             | Firebase       | Purpose                 |
| ------- | ----------------------- | -------------- | ----------------------- |
| dev     | `lib/main_dev.dart`     | emulator suite | local development       |
| staging | `lib/main_staging.dart` | staging project| internal and external beta |
| prod    | `lib/main_prod.dart`    | prod project   | store builds            |

Android flavors are defined in `android/app/build.gradle.kts`. On iOS the
three flavors are Xcode schemes (`dev`, `staging`, `prod`) that must be
created once in Xcode; until then `flutter build ios -t lib/main_<flavor>.dart`
builds the default scheme with the flavor chosen by the entry point.

## Repository layout

```
lib/
  config/app_config.dart   the single configuration file
  main_*.dart              flavor entry points
  app/                     app widget, router, bootstrap
  core/                    db, theme, l10n, network, platform, widgets
  features/<feature>/      data/ domain/ presentation/ per feature
packages/                  pure Dart packages (risk_model, report_renderer)
functions/                 TypeScript Cloud Functions
test/                      mirrors lib/
docs/adr/                  architecture decision records
docs/phases/               what each numbered branch delivered
tool/                      lint scripts and git hooks
```

## Contributing

Branching, commit and review rules are in [CONTRIBUTING.md](CONTRIBUTING.md).
