# Phase 17: Personal re-weighting

Branch: `17-feat-personal-reweighting`, cut from `16-feat-risk-model-core`.
Requirement IDs: FR-9 (learning). Still no UI; phase 18 shows the result.

## What was done

- **Learner** (`packages/risk_model`, `Learner.learn`): for each factor,
  `lift = P(attack follows | exposed) / P(attack follows)` over the
  person's history, with one pseudo-observation at the base rate so a
  factor never seen keeps lift 1. `personal = clamp(population × lift,
  0, 1)`. An exposure on day D counts as followed by an attack when one
  starts on D or the next day (`riskAttackWindowDays` = 2, the 24 to
  48 h before an attack). `confidence = n / (n + shrinkage) × min(1,
  attacks / attacksBeforeModelIsTuned)` with n the number of exposure
  days, so a weight only moves as evidence accumulates (shrunk by sample
  size). Thresholds: the 60th and 85th percentiles of the person's own
  loads once 30 days of data exist and the two sit at least 5 apart,
  else population. The result also carries every history day re-scored.
- **Inputs builder** (`DayInputsBuilder.build(from, to)`): one record
  per local date from the local stores. Weather hours give the most
  negative 24 h pressure change seen at any hour of the day, the mean
  humidity, the mean temperature against the day before and the UV max;
  environment days give AQI, pollen (highest type) and UV max; check-ins
  give the eight answers and the stamped cycle day; health sleep samples
  give minutes asleep (attributed to the date the sleep ended); period
  starts give the cycle day and length when cycle tracking is on. Days
  with nothing at all are left out.
- **Engine** (`RiskEngine`): `relearn()` reads up to two years of
  inputs and every attack start date, runs the learner, stores the
  weights in `factor_weights`, the thresholds and the run time in
  settings, every history day in `risk_days`, then scores the days
  ahead. `scoreUpcoming()` scores today plus `riskForecastDays` (3)
  days with the current weights and thresholds and stores them (days
  without data are skipped). Population rules apply until the first run.
- **Hooks**: ending an attack re-learns (best effort; a failure is
  logged and the next attack tries again). Home watches
  `riskRefreshProvider`, which scores the days ahead once the weather
  refresh has finished; the resume hook invalidates both.
- **Providers**: `riskDayProvider(date)`, `riskRangeProvider((from, to))`,
  `riskWeightsProvider`, `attackCountProvider` for phases 18 to 20.
- **Config**: `AppThresholds.riskAttackWindowDays`, `riskWeightShrinkage`,
  `riskModeratePercentile`, `riskHighPercentile`, `riskThresholdMinDays`,
  `riskThresholdMinGap`, `riskHistoryDays`, `riskForecastDays`; settings
  keys `risk.thresholds`, `risk.lastLearnedAt`.
- **Benchmark** (`packages/risk_model/test/learning_test.dart`): two
  years (730 days) of full inputs with about 90 attacks learns and
  re-scores in well under a second (tens of milliseconds locally); the
  test fails above 1 s and runs in the CI packages step.

## Tests

- Package: learner on an empty history, a stress-driven history (stress
  gains weight, independent caffeine stays near population, confidence
  grows), attacks outside the history ignored, the attack-count cap, a
  factor never followed by an attack dropping towards zero, thresholds
  (population while short, fitted percentiles, flat distribution fall
  back, interpolation), parameter assertions, the benchmark. 65 tests,
  100 % coverage.
- App: inputs builder (weather derivations with exact values, the other
  sources, cycle precedence), engine (population before a run, relearn
  storing weights, thresholds, run time and history, scoreUpcoming
  storing today and three days ahead and feeding the live providers,
  attack end re-learning, a failing run swallowed), repository round
  trips including unknown factor ids. Full suite: 218 tests.

## Acceptance criteria

- [x] Per-user weights from the 24 to 48 h before each attack, shrunk by
      sample size.
- [x] `factor_weight` recomputed after each attack.
- [x] Low, Moderate and High thresholds on the person's own load
      distribution.
- [x] `risk_day` stored daily.
- [x] Benchmark test in CI: recomputation under 1 s for two years of
      fixture data.

## Manual checks

- Log and end an attack: `factor_weights` rows appear (Settings > Dev
  tools database view in dev builds); the next check-in day's `risk_days`
  row updates when the app is reopened.
