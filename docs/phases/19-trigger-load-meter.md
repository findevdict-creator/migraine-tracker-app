# Phase 19: Load meter

Branch: `19-feat-trigger-load-meter`, cut from `18-feat-risk-card`.
Requirement IDs: FR-10.

## What was done

- **`LoadMeter`** (`lib/features/risk/presentation/load_meter.dart`): a
  stacked bar from 0 to 100. Each factor with points is one named
  segment (`load-segment-<i>`); shares are the factor's points scaled so
  they add up to the day's load (`loadSegments`). Two marks
  (`load-mark-moderate`, `load-mark-high`) sit where Moderate and High
  start and are read from the thresholds in use, so they move as the
  model re-weights. A line under the bar names both values
  (`load-thresholds`). The legend (`load-legend-<i>`, 48 px rows) lists
  every segment with its name and points. Segments and legend rows are
  tappable; the card and the screen show "Stress: 45 points" in a snack
  bar (`load-segment-detail`). A segment inside the home card claims the
  tap at once so the card's own tap does not open the screen instead.
  Semantics label reads the load and every segment.
- **Colours**: `AppThemeTokens.factorPalette`, fourteen colours in
  `Factor` order; the name is always beside the colour.
- **Thresholds, live**: `riskThresholdsProvider` watches the
  `risk.thresholds` setting (population until the first learning run).
- **Placement**: compact meter (no title, no legend) in the home risk
  card under the badge (`risk-card-meter`); full meter with legend in
  each day's section on the risk screen.

## Tests

- `load_meter_test.dart`: shares sum to the load in proportion to
  points; empty cases; tapping a segment on the card and a legend row on
  the screen names the factor and points; the threshold line; the marks
  move when the learned thresholds change in settings.
- `load_meter_golden_test.dart`: light, dark and attack themes at 100 %
  and 200 % text scale, each with a stacked day on population
  thresholds, a single factor on learned thresholds, the compact form
  and the empty state (`test/features/risk/goldens/ci/`). Regenerate only
  in the PR that changes the widget, with before and after attached.
- Full suite: 237 tests.

## Acceptance criteria

- [x] Load meter widget with golden tests.

## Manual checks

- Home card: tap a segment, the snack bar names it; tap elsewhere on the
  card, the screen opens.
- After a learning run with 30 or more days, the marks sit at the
  person's own thresholds (visible on the line under the bar).
