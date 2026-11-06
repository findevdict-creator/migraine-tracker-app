# Phase 01: Project scaffold

Branch: `01-feat-project-scaffold`, cut from the initial commit on `main`.
Requirement IDs: none directly; sets up FR-24 (one codebase, both platforms)
and FR-25 (all copy in translation files).

## What was done

- Flutter 3.47.9 app (`migraine_tracker`, org `app.migrainetracker`) for
  Android and iOS. Android `minSdk` raised to 28 per the requirements doc.
- Three flavors: `dev`, `staging`, `prod`. Entry points `lib/main_dev.dart`,
  `lib/main_staging.dart`, `lib/main_prod.dart` (plus `lib/main.dart` running
  dev for a bare `flutter run`). Android product flavors with application id
  suffixes and per-flavor labels.
- **Central configuration** in `lib/config/app_config.dart` (ADR 0002):
  identity, environment values from `env/*.json`, endpoints, feature flags,
  thresholds, theme tokens, assets and locales in one file. `env/dev.json`
  committed with placeholders; staging and prod examples committed, filled
  files ignored.
- App shell: `bootstrap()` creates the `AppConfig` and provides it through
  Riverpod; `MigraineTrackerApp` wires go_router, the Material 3 themes built
  from the tokens and the localizations; an empty home screen.
- Localization: `l10n.yaml`, `lib/core/l10n/arb/app_en.arb`, generated
  `AppLocalizations` committed under `lib/core/l10n/generated/`, and a
  `context.l10n` extension.
- Lint and format: `very_good_analysis` base set, `riverpod_lint` as a native
  analyzer plugin, warnings fatal in CI. Two custom lints in `tool/`:
  `copy_lint.dart` (fails on "predict", "diagnos", "see it coming", "cure" in
  ARB files) and `string_lint.dart` (fails on string literals passed to
  `Text`, `Tooltip` or `SnackBar` outside `l10n/` and `config/`).
- Git hooks via `lefthook.yml`: format, analyze, copy lint, gitleaks and the
  Conventional Commits check (`tool/check_commit_msg.sh`).
- CI: `.github/workflows/pr.yml` (branch-name and commit checks, format,
  codegen diff, analyze, both custom lints, tests with coverage, pure Dart
  packages, Android debug APK, iOS build without signing, Cloud Functions
  lint/types/tests once `functions/` exists) and `nightly.yml` (outdated
  dependencies, secrets scan, benchmarks). Dependabot for pub, npm and
  actions. `release.yml` arrives in the release-prep phase.
- Conventions: PR template, CODEOWNERS, CONTRIBUTING, README, CHANGELOG,
  ADR 0001 (stack) and ADR 0002 (central configuration), parity checklist.
- Tests: app boots to the home screen in every flavor, prod hides the debug
  banner, the theme uses the configured seed colour, config values match the
  requirements doc, copy lint passes and fails as designed.

## Deviations from the plan

- Feature folders are created by the phase that owns them instead of as
  empty placeholders, to keep the tree free of empty directories.
- `custom_lint` is not used: current `riverpod_lint` runs through the Dart
  analyzer's native plugin system and cannot coexist with `custom_lint`.
- The hard-coded string lint is a script in `tool/` (regex over `lib/`),
  not an analyzer plugin.
- The iOS flavor schemes must be created once in Xcode; they cannot be
  generated from Linux. Builds use `-t lib/main_<flavor>.dart` until then.
- Branch protection on `main` must be set by M in the repository settings
  (listed in `docs/CONFIGURATION.md`).

## How to verify

```bash
flutter pub get && flutter gen-l10n
flutter analyze --fatal-infos
dart run tool/copy_lint.dart && dart run tool/string_lint.dart
flutter test
flutter run -t lib/main_dev.dart --flavor dev --dart-define-from-file=env/dev.json
```

## What M must fill in

See `docs/CONFIGURATION.md`: Firebase projects and env files, brand assets,
support links, and the `main` branch protection settings.
