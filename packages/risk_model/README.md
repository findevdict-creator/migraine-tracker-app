# risk_model

The on-device daily risk model (FR-9), as a pure Dart package so it can be
tested exhaustively and run from the command line.

- One module per factor under `lib/src/factors/` turns a day's inputs into
  an exposure from 0 to 1, or null when there is no data.
- `WeightTable` holds the population weight, the personal weight and a
  confidence per factor; the effective weight moves from population to
  personal as confidence grows (phase 17 fills it).
- `DailyLoad.compute` combines contributions into a 0 to 100 load with a
  level from `LevelThresholds` and the contributions sorted strongest
  first. Deterministic: same inputs, same numbers, one decimal.
- `modelVersion` is stored on every result; bump it whenever a fixture
  output changes and explain the delta in the PR.

Score a fixture:

```sh
dart run risk_model:score test/fixtures/users/steady.json
```

Coverage must stay at 100% of lines: `tool/check_coverage.sh`.
