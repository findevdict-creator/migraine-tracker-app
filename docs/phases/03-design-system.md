# Phase 03: Design system

Branch: `03-feat-design-system`, cut from `02-feat-local-database`.
Requirement IDs: accessibility NFR (WCAG 2.2 AA, dynamic type to 200%,
reduce-motion, photophobia-friendly attack theme), FR-1 (56 pt targets).

## What was done

- Three Material 3 themes built from `AppThemeTokens` in the central config
  (`lib/core/theme/app_theme.dart`): light, dark and the attack theme
  (true-black background, muted text, one warm accent, 56 pt targets, no
  elevation tint). An `AttackThemeMarker` extension lets widgets detect the
  attack theme and size themselves without a flag being threaded through.
- `AppColors` theme extension for the semantic colours Material lacks (risk
  low/moderate/high with their on-colour, success, warning, danger, info,
  attack accent and muted) and `context.colors`, `context.appColors`,
  `context.textStyles`, `context.isAttackTheme` shortcuts.
- Type scale (`app_typography.dart`) with sizes from the config and a
  `clampedScaler` applied in the app builder so the platform text scale is
  honoured up to 200% and capped there.
- Reduce-motion (`app_motion.dart`): `AppMotion.short/medium` return zero
  durations when the OS flag or the in-app preference is on.
- Core widgets under `lib/core/widgets/`: `AppButton` (48 dp, 56 pt in the
  attack theme or with `large`), `AppChoiceChip`, `AppIntensitySlider`,
  `AppCard`, `SectionHeader`, `RiskLevelBadge` (label always present, colour
  never the only signal) and the `RiskLevel` enum.
- Theme gallery screen (`features/dev_tools`) routed at `/dev/theme` and
  linked from the home app bar only when `showDevTools` is on.
- Colour tokens tuned so every risk colour meets 4.5:1 against its on-colour
  and against the light, dark and attack surfaces; attack text is 7:1 or
  better.

## Tests

- `test/core/theme/contrast_test.dart`: WCAG 2.2 contrast ratios for every
  token pair; attack theme uses 56 pt targets; standard themes use 48 dp.
- `test/core/widgets/widgets_test.dart`: button and chip sizes per theme,
  slider snapping, badge labels, card taps.
- `test/core/widgets/goldens_test.dart` (alchemist): the gallery in each
  theme at 100% and 200% text scale plus a side-by-side of the core widgets;
  goldens under `test/core/widgets/goldens/ci/`. `flutter_test_config.dart`
  uses the CI (Ahem font) configuration everywhere so goldens match across
  machines.

## Deviations from the plan

- The head map and load meter goldens come with their own phases (05, 19).
- The reduce-motion preference is a Riverpod notifier now; the settings
  toggle that persists it arrives with the settings screen (09).

## How to verify

```bash
flutter test test/core/theme test/core/widgets
flutter run -t lib/main_dev.dart --flavor dev --dart-define-from-file=env/dev.json
# tap the palette icon on the home screen
```
