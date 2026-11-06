# Phase 08: Cycle tracking

Branch: `08-feat-cycle-tracking`, cut from `07-feat-medication-log`.
Requirement IDs: FR-4 (period logging, derived cycle phase, hidden until
enabled in settings). Privacy NFR: off by default, nothing shown or stored
until the user opts in.

## What was done

- **Settings toggle.** `CycleTrackingToggle` writes
  `SettingsKeys.cycleTrackingEnabled`. The whole feature is also behind
  `AppFeatureFlags.cycleTrackingAvailable` in the central config; when the
  flag is off the route and the home icon disappear and the provider
  always reports off.
- **Period logging.** A "Period started this day" chip on the cycle screen
  (today) and on every check-in day (so back-fill works). Starts are kept
  as a sorted JSON list under `SettingsKeys.cyclePeriodStarts`. The cycle
  screen lists them with remove.
- **Derived cycle day and phase.** `CycleCalculator` (pure): cycle length is
  the average of the last `cycleLengthSampleSize` intervals clamped to
  `minCycleLengthDays`..`maxCycleLengthDays`, or `defaultCycleLengthDays`
  until two starts exist (all in `AppThresholds`). Day counts from the
  latest start on or before the date and wraps past the cycle length.
  Phase: menstrual (days 1 to 5), ovulation (a three-day window around
  length minus 14), follicular before, luteal after. Labels are plain
  descriptions, not findings.
- **Stored per day.** `CycleLog` restamps the `cycleDay` column of every
  existing check-in whenever a start is added or removed or tracking is
  toggled (off clears them), and the check-in editor stamps `cycleDay` on
  each save. Phase 16 reads it as a factor without recomputing.
- Cycle screen at `/cycle` (loop icon on the home app bar), showing today's
  day, phase and the cycle length in use.

## Tests

- `test/features/cycle/cycle_calculator_test.dart`: default length,
  averaging and clamping, recent-sample window, day 1 on the start, day
  counting from the latest start, wrap past the length, phase windows for
  28- and 35-day cycles.
- `test/features/cycle/cycle_flow_test.dart` (widget): nothing shown on the
  check-in while off; enable, log a start, see day and phase on the cycle
  screen and the check-in and the stamped `cycleDay`; restamping of
  existing check-ins when an earlier start is added and when tracking is
  turned off; removing a start.

## Deviations from the plan

- Period starts are a settings value rather than a new table, so the
  schema stays at version 1. The requirements data model has no periods
  table; `cycleDay` on `checkins` is the per-day store it asks for.
- The toggle is on the cycle screen now and will also appear on the
  settings screen in phase 09.

## How to verify

```bash
flutter test test/features/cycle
```

Home > loop icon > turn on "Track my cycle" > tap "Period started this
day". Open the check-in: the cycle row appears.

## What M must fill in

Nothing.
