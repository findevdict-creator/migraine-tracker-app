# Phase 15: Onboarding

Branch: `15-feat-onboarding`, cut from `14-feat-health-sync`.
Requirement IDs: FR-26 (first-run flow asking location, health permissions
and reminder time, landing on the populated environment screen; the
explainer of what the level can and cannot do).

## What was done

- **Gate** (`onboardingStateProvider`): null while the
  `onboarding.completed` flag is read, then true or false. The app shows a
  splash until the flag is known; the router's `redirect` sends every route
  to `/onboarding` while false and sends `/onboarding` to the environment
  screen once true, through a `refreshListenable`.
- **Flow** (`OnboardingScreen`, four pages, no swiping, Skip on every page
  but the last):
  1. Welcome with the level explainer.
  2. Location: "Use my location" (asks the while-using prompt and starts
     the first weather fetch at once) or "Choose a city"; status line.
  3. Health: one switch per type with its reason, the same consent path as
     the Health data screen; a note when no store exists.
  4. Reminder: the check-in time, default from
     `AppThresholds.defaultCheckinReminder`; Finish.
  Finish and Skip both mark the flag, go home and push the environment
  screen so back lands on home.
- **Explainer** (`LevelExplainer`): what the level does (compares today
  with the days before past attacks, learns from the log, helps decide to
  go easier) and does not do (not a forecast of an attack, not a medical
  opinion, never leaves the phone), plus the wellness disclaimer. Also a
  standalone route `/explainer` from Settings; phase 18 links it from the
  risk card.
- **Test harness**: `pumpApp(onboarded: false)` shows the flow; the default
  seeds the flag as done so every other test starts on home.
- **Integration test** (`integration_test/onboarding_flow_test.dart`):
  real device, real prompt, real cache function, asserts the populated
  environment screen within 60 s. Not run in the PR workflow (needs an
  emulator); command in the file header.

## Tests

- `onboarding_flow_test.dart`: new install through all four pages lands on
  the environment screen with the pressure shown and the stopwatch under
  60 s, Skip goes to the environment screen with home underneath, an
  onboarded install never sees the flow, the explainer opens from
  Settings.
- Full suite: 206 tests.

## Acceptance criteria

- [x] Integration test timing a new install to a populated environment
      screen under 60 s (widget-level with fakes in CI; device test in
      `integration_test/`).
- [ ] Device run of the integration test on Android and iOS (parity row).

## Manual checks

- Fresh install: the flow appears once; after Finish the environment
  screen has pressure data; relaunch goes straight to home.
- Skip on page 1: environment screen with the empty note; back goes home.

## What M must fill in

Nothing.

## Risk and rollback

No schema change. Removing the redirect block in `router.dart` disables
the flow; the flag is harmless.
