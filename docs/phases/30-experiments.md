# Phase 30: Experiments

Branch: `30-feat-experiments`, cut from `29-feat-self-management`.
Requirement IDs: FR-12.

## What was done

- **One change at a time.** The person picks one of six changes:
  - Cut back on caffeine.
  - Go to bed at the same time every night.
  - Drink more water.
  - Stretch your neck every day.
  - Less screen time in the evening.
  - Skip alcohol.

  While one runs, the picker is hidden. The repository also refuses a
  second active experiment, so the rule holds outside the screen too.
- **Daily question.** "Did you stick with it today?" with Yes and No.
  Answering again the same day replaces the answer. The screen shows
  "Day 5 of 14" and "Kept to it on 4 of 5 days".
- **Comparison** (`ExperimentComparison`, pure):
  - The 14 days before the start against the experiment days so far.
  - Three rows for each period: attacks per week, average intensity
    and median duration.
  - Each period shows how many attacks its numbers come from.
  - Below `AppThresholds.experimentMinAttacks` attacks in either
    period, a "numbers can swing a lot" line appears.
  - A caveat line is always shown. It says two weeks is short and
    weather, seasons and stress change on their own.
  - An attack still running counts towards attacks per week but not
    towards the median duration, because it has no end yet.
- **Finish or stop.**
  - After 14 days the daily question goes away and "Finish and save the
    result" appears. The experiment is saved as finished.
  - "Stop experiment" ends it early and saves it as stopped, with the
    numbers so far.
  - Either way the comparison is frozen and stored with the experiment,
    so later edits to old attacks do not change a past result.
- **Past experiments** are listed under the picker with the date they
  ended and a one-line summary of attacks per week before and during.
- **Screen**: `/experiments`, opened from settings. It sits behind
  `AppFeatureFlags.experimentsAvailable`.
- **Storage**: the `experiments` table and its data access object
  already existed from phase 2. This phase adds the repository on top.

## Configuration

All in `lib/config/app_config.dart`:

| Setting | Value | What it does |
| --- | --- | --- |
| `AppThresholds.experimentWindowDays` | 14 | Length of the experiment and of the "before" period |
| `AppThresholds.experimentMinAttacks` | 3 | Below this many attacks in a period, the small-sample line shows. The line's text reads the same number. |
| `AppFeatureFlags.experimentsAvailable` | true | Shows the settings entry |

## Tests

- `experiment_comparison_test.dart`:
  - Rates, average intensity and median duration for both periods.
  - Attacks outside both windows are ignored, and a running attack has
    no duration.
  - Mid-experiment, "during" covers only the days so far.
  - An even count takes the middle two for the median.
  - The small-sample flag below the threshold in either period.
  - A result survives storage as JSON.
  - The day counter, the due date and the adherence count.
- `experiments_screen_test.dart`:
  - Pick a change, answer today, see the comparison with its caveats,
    then stop. The past list shows it as stopped.
  - After two weeks the screen offers to finish, and the result is
    stored as finished with the full 14 days.
  - Only one experiment can be active.
- Full suite: 397 tests.

## Acceptance criteria

- [x] One experiment at a time, picked from a list of changes.
- [x] Daily adherence question.
- [x] Before and during comparison with sample sizes and a plain caveat.
- [x] Finished and stopped experiments keep their result.

## Manual checks

1. Open settings, then Experiments. Pick "Drink more water". The screen
   shows "Day 1 of 14" and the daily question.
2. Tap Yes. The line reads "Kept to it on 1 of 1 days".
3. Scroll down. The comparison shows both periods, the attack counts
   and the caveat.
4. Tap "Stop experiment". The picker comes back and the experiment is
   listed under "Past experiments" as stopped.

## Risk and rollback

This phase adds a feature folder, one route and one settings entry. The
table already existed, so there is no migration. Reverting the branch
removes the screen and leaves any stored rows unused.

## What M must fill in

Nothing. The list of changes and the caveat wording are product copy in
`lib/core/l10n/arb/app_en.arb` and can be edited there.
