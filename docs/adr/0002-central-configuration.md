# ADR 0002: One configuration file

Date: 2026-11-06. Status: accepted.

## Context

M asked that every configurable parameter (theme, environment variables,
logos, app name, endpoints, flags) live in one place so the whole app
updates by changing one file.

## Decision

`lib/config/app_config.dart` is the single configuration file. It holds:

- `AppFlavor` and `AppConfig` (the resolved flavor, provided through Riverpod
  as `appConfigProvider`).
- `AppIdentity`: product name, per-flavor display name, bundle ids, deep link
  scheme, support and legal links, wellness disclaimer.
- `AppEnv`: every secret and environment value, read with
  `String.fromEnvironment` from `env/<flavor>.json`.
- `AppEndpoints`: external URLs and Cloud Function names.
- `AppFeatureFlags`: per-flavor and per-feature flags.
- `AppThresholds`: every number from the requirements doc that tunes behaviour.
- `AppThemeTokens`: colours, spacing, radii, tap targets, animation durations.
- `AppAssets`: asset paths.
- `AppLocales`: supported locales.

Rules:

- No file under `lib/` outside `config/` may hard-code any of these values.
  `lib/core/theme/` builds themes from the tokens; features read thresholds
  from `AppThresholds`.
- Secrets never appear in the file. `env/dev.json` is committed with
  placeholders; `env/staging.json` and `env/prod.json` are git-ignored and
  created from the `.example` files.
- Native identifiers that cannot be read from Dart (Android `applicationId`
  and flavor labels, iOS bundle id and display name) mirror `AppIdentity` and
  are listed in `docs/CONFIGURATION.md` so a rename touches a known set of
  files.

## Consequences

- A rebrand, a new Firebase project or a threshold change is one Dart edit
  plus, for identifiers, the two native files named in the configuration doc.
- Tests assert the config values the requirements doc fixes
  (`test/config/app_config_test.dart`), so an accidental change fails CI.
