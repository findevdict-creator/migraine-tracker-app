# Phase 18: Risk card

Branch: `18-feat-risk-card`, cut from `17-feat-personal-reweighting`.
Requirement IDs: FR-9 (UI).

## What was done

- **Home card** (`RiskCard`, key `risk-card`, first card under the
  attack button): today's level as the large badge, the top three
  drivers in plain words (`risk-driver-<i>`), the confidence label
  (`risk-confidence`: low / medium / high from the mean weight
  confidence, bands in `AppThresholds.riskConfidenceBands`), the
  learning badge and the next three days as outlined chips
  (`risk-day-<i>`, "Tomorrow · Low", weekday after that). Empty state
  (`risk-empty`) until a day has been scored. Everything is read from
  `risk_days`, so the card shows offline and on a failed weather fetch.
- **Learning badge** (`LearningBadge`): "Still learning: n of 10 attacks
  logged" (`risk-learning`) until `AppThresholds.attacksBeforeModelIsTuned`
  attacks exist, then "Tuned to your log" (`risk-tuned`).
- **Risk screen** (`/risk`, `RiskScreen`): one section per scored day
  with the level, load out of 100, every driver with its points, the
  confidence and when it was computed; the learning badge; a link to the
  explainer (`risk-explainer`); the wellness disclaimer
  (`risk-disclaimer`). Without data it offers today's check-in
  (`risk-open-checkin`).
- **Plain words** (`risk_text.dart`): `factorLabel` for the fourteen
  factors (`riskFactor*` copy keys), `confidenceLabel`, `dayLabel`.
- **Home** is now a scrolling list (`home-list`) with the empty-state
  line at the bottom (`home-empty`), so four cards fit on small phones.
- **Shared type**: `RiskLevel` in `core/widgets/risk_level_badge.dart`
  is now the package's enum (re-exported), so the badge, the theme
  gallery and the stored rows use one type.
- **Copy lint**: `tool/copy_lint.dart` already fails CI on "predict",
  "diagnos", "see it coming" and "cure" (step "Copy lint" in the PR
  workflow); the new copy passes it.

## Tests

- `risk_card_test.dart` (weather source failing, so offline): empty
  state with the learning badge; stored level, drivers, confidence and
  next-day chips; confidence label from learned weights; badge turns to
  "tuned" at ten attacks; tap opens the screen with points, disclaimer
  and explainer link; empty screen offers the check-in.
- `risk_text_test.dart`: every factor has words free of "predict",
  confidence bands, day labels.
- Full suite: 227 tests.

## Acceptance criteria

- [x] Home screen shows the level offline (card reads the local store;
      test runs with a failing weather source).
- [x] Copy lint in CI.

## Manual checks

- Airplane mode after a day with a check-in: the card still shows the
  level and drivers; tap opens the screen.
- Under ten attacks the badge reads "Still learning"; log the tenth and
  end it: "Tuned to your log".
