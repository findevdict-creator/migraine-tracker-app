# Phase 20: Insights

Branch: `20-feat-trigger-insights`, cut from `19-feat-trigger-load-meter`.
Requirement IDs: FR-11.

## What was done

- **Buckets** (`FactorInsight.from`, pure): each factor's learned weight
  over its population weight is the lift (1 = the usual rate). Below
  `AppThresholds.minExposuresForInsight` (5) exposure days the factor is
  "not enough data" whatever the ratio; from 5 days it is a trigger at
  or above `insightTriggerLift` (1.25), a protector at or below
  `insightProtectorLift` (0.8), and "no clear effect" between.
  `factorInsights` sorts by bucket, then by strength of effect.
- **Screen** (`/insights`, `InsightsScreen`): four cards with the same
  layout: "More attacks followed", "Fewer attacks followed" (same card,
  same row, same ratio text, so protectors are as prominent as
  triggers), "No clear effect", "Not enough data yet". Every row carries
  its sample sizes ("12 exposure days, 7 followed by an attack") and the
  ratio ("2.0× your usual rate"); rows under the floor show "4 of 5
  exposure days logged". Counts per bucket in the header. A note before
  the first learning run. Disclaimer at the end.
- **Method page** (`/insights/method`): what an exposure day is, what
  "followed" means (the 24 to 48 h window), how the ratio is formed, the
  sample floor, and that none of it is a cause.
- **Entry points**: Settings > "Your factors"; the risk screen's "Your
  factors" button.
- **Config**: `insightTriggerLift`, `insightProtectorLift` next to
  `minExposuresForInsight` in `AppThresholds`.

## Tests

- `factor_insight_test.dart`: the 5-exposure boundary (4 days with a
  strong ratio is not enough, 5 is sorted), the lift boundaries on both
  sides, a zero population weight, sort order, no weights at all.
- `insights_screen_test.dart`: all fourteen under "not enough" before a
  run; learned weights fill the buckets with sample sizes and ratios and
  the same row shape for triggers and protectors; the method page; the
  link from the risk screen.
- Full suite: 246 tests.

## Acceptance criteria

- [x] Insights screen.
- [x] Bucket unit tests at the 5-exposure boundary.

## Manual checks

- After ten or more attacks, open Settings > Your factors: the lists
  match the drivers seen on the risk screen over the past weeks.
