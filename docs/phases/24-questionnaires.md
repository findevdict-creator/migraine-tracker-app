# Phase 24: Questionnaires

Branch: `24-feat-questionnaires`, cut from `23-feat-doctor-report`.
Requirement IDs: FR-20.

## What was done

- **Scoring** (`questionnaire.dart`, pure): MIDAS sums the five day-count
  items over the last three months (each 0 to 90) and records the two
  unscored items (headache days, average pain 0 to 10); grades I to IV
  at 0-5, 6-10, 11-20 and 21 and over. HIT-6 stores each answer as its
  published points (never 6, rarely 8, sometimes 10, very often 11,
  always 13), sums to 36-78, and bands at 49, 55 and 59 (little or no,
  some, substantial, severe impact). The tables live in the domain
  file, not in `app_config.dart`, because changing them changes stored
  results.
- **Storage**: the `questionnaires` table from phase 02 (id, type, date,
  answers JSON, score) through `DriftQuestionnaireRepository`. No
  schema change.
- **Screens**: `/questionnaires` (Settings > Questionnaires) shows one
  card per instrument with the latest score and band, the next due date
  or "Due now", and a score-history chart over the band thresholds once
  two rounds exist (the chart's content is read out as one semantics
  label). `/questionnaires/:kind` is the form: number fields for MIDAS
  (save stays off until the five scored items are in range), five
  choice chips per HIT-6 question. Saving shows the score, the band and
  a note that it is a starting point for a conversation with a
  clinician, then returns to the list.
- **Reminder**: a new `questionnaire` notification type (on by
  default, switchable on the notification screen) fires at
  `questionnaireReminderHour` on the day
  `AppThresholds.questionnaireReminder` (90 days) after the latest round
  of either instrument; an overdue round fires right away. Nothing is
  planned before the first round. Saving a round reschedules.
- **Report**: the phase 23 report gains a "Questionnaires" section
  (date, instrument, score, band) for rounds completed in the period,
  behind an "Include questionnaire scores" switch on the report screen
  (on by default).
- **Config**: `questionnaireReminderHour` (10) and
  `questionnaireChartPoints` (8) next to the existing
  `questionnaireReminder`.
- **Copy**: question wording follows the published instruments in plain
  English. Before release, M should confirm the licence terms: MIDAS is
  free to use with attribution; HIT-6 is copyrighted by QualityMetric /
  QualityMetric Inc. and needs a licence for use in a commercial app.

## Tests

- `questionnaire_scoring_test.dart`: worked MIDAS examples (0, 4, 2, 6,
  3 days is 15, grade III), every grade boundary, missing items, the
  90-day cap; HIT-6 minimum, maximum, all "sometimes" (60, severe), a
  mixed example (49), every band boundary, invalid points; the due date
  across both instruments.
- `questionnaire_repository_test.dart`: round trip, ordering, range
  query, replace on the same id.
- `questionnaire_screens_test.dart`: HIT-6 end to end (score 60, severe,
  next round shown, stored); MIDAS save gate and score 15; the chart
  with three rounds and its semantics label.
- `notification_planner_test.dart`: no reminder before the first round,
  the due-day hour, an overdue round, switched off.
- Report: questionnaires limited to the range; the PDF without the
  section is smaller; the report screen passes the switch through.
- Two older tests now scroll before tapping (the settings list and the
  notification list are longer and lazy).
- Full suite: 326 tests.

## Acceptance criteria

- [x] Questionnaire screens for MIDAS and HIT-6.
- [x] Scoring tests against the published scoring rules and bands.
- [x] Three-month reminder, scores charted over time, optional section in
      the report.
- [ ] External beta build (needs the staging Firebase project and store
      accounts; see CONFIGURATION, "What M must fill in").

## Manual checks

- Settings > Questionnaires: fill in HIT-6 with every answer "Sometimes";
  the result reads 60, severe impact, and the card shows the next round
  in about three months.
- Fill in MIDAS twice on different days (or change the clock): the chart
  appears with two points.
- Doctor report with the switch on: the PDF ends with the questionnaire
  table.
