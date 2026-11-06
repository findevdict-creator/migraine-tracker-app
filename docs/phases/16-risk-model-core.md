# Phase 16: Risk model core

Branch: `16-feat-risk-model-core`, cut from `15-feat-onboarding`.
Requirement IDs: FR-9 (engine). No UI in this phase; the app does not yet
depend on the package. Phase 17 wires it in and learns the weights,
phase 18 shows the result.

## What was done

- **Package** `packages/risk_model`: pure Dart, no Flutter, no I/O. Same
  lint base as the app plus `public_member_api_docs`. The root analyzer
  excludes `packages/**`; CI analyses and tests each package in the
  "Pure Dart packages" step and runs `tool/check_coverage.sh`, which fails
  under 100 % line coverage of `lib/`.
- **Inputs** (`DayInputs`): one record per day, every field optional:
  pressure change over 24 h, humidity, temperature swing, US AQI, pollen,
  UV, the eight check-in answers, measured sleep minutes, cycle day and
  length. JSON in and out for fixtures and storage.
- **Factors** (`Factor`, 14 stable ids): pressure_drop, humidity,
  temperature_swing, air_quality, pollen, bright_light, screen_time,
  poor_sleep, stress, neck_tension, caffeine, alcohol, dehydration,
  cycle_phase.
- **Modules** (`lib/src/factors/factors.dart`, one class per factor): each
  maps a day to an exposure from 0 to 1, or null without data, with a
  population weight. Rules are linear ramps on the continuous inputs
  (pressure −2 to −6 hPa, humidity 65 to 85 %, swing 3 to 8 °C, AQI 50 to
  150, pollen 20 to 100, UV 3 to 8, sleep 420 to 300 min) and steps on
  the 1 to 5 answers (4 is half, 5 is full; for sleep and hydration 2 is
  half, 1 is full). Bright light and poor sleep take the stronger of the
  measured value and the answer. Cycle phase is full on the two days
  before and the first two days of bleeding, half on day 3.
- **Weights** (`FactorWeight`, `WeightTable`): population weight,
  personal weight, confidence and the two counts phase 17 updates.
  `effective = population × (1 − confidence) + personal × confidence`, so
  a fresh install runs on population rules and a tuned one on its own.
- **Load** (`DailyLoad.compute`): `points = 100 × exposure × weight` per
  factor with data; `load = 100 × (1 − Π(1 − points/100))` (noisy-or:
  one factor alone gives its own points, several stack, never over 100,
  order-independent). Contributions sorted strongest first with ties in
  factor order; `drivers(count: 3)` are the top non-zero ones. Also mean
  confidence and coverage (share of the 14 factors with data). Load and
  points to one decimal, details to three, so storage is deterministic.
- **Levels** (`LevelThresholds`, `RiskLevel`): Low under 35, Moderate
  from 35, High from 60 as population defaults; phase 17 fits them per
  person.
- **Model version** (`modelVersion = '1.0.0'`): stored on every result;
  bump it whenever a fixture output changes.
- **Fixtures** (`test/fixtures/users/*.json`): five synthetic users
  (steady, stormy, stressed, sparse, personalised) from a seeded
  generator (`tool/make_fixtures.dart`) with frozen expected outputs.
  `fixtures_test.dart` replays them exactly.
- **CLI** `dart run risk_model:score <fixture.json>` prints the results;
  `--write-expected` refreezes a fixture.

## Tests

- Module boundaries for all 14 factors, ramps and scales, the registry
  (one module per factor in order, null on an empty day, 1 on the worst
  day, 0 on the calm day).
- Load: empty day, single factor equals its points, half exposure, noisy
  or combination, worst day below 100, order independence, tie order,
  drivers, personal weights and confidence, custom thresholds, JSON
  round trips.
- Weights and thresholds: blending, fall-backs, round trips, assertion.
- CLI: usage, scoring, writing expected outputs.
- 54 tests, 100 % line coverage (257/257).

## Acceptance criteria

- [x] Package at 100 % line coverage with a fixture test CI blocks on.
- [x] A CLI that scores a fixture.

## Manual checks

- `cd packages/risk_model && dart run risk_model:score test/fixtures/users/stormy.json`
  prints 60 days with loads and drivers.
