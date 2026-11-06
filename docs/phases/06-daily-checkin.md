# Phase 06: Daily check-in

Branch: `06-feat-daily-checkin`, cut from `05-feat-attack-log`.
Requirement IDs: FR-2 (three-tap daily check-in, optional second row,
7-day back-fill), FR-13 groundwork (source column per field for health
sync), FR-17 groundwork (reminder time; the notification itself ships in
phase 21).

## What was done

- **Three taps.** `CheckinScreen` shows sleep quality, stress and neck
  tension as rows of 1 to 5 chips. One tap per row completes the day; the
  screen says so and the home card flips to "Done for today". Tapping the
  selected chip again clears it. Every tap is saved at once.
- **Optional second row** behind "Add more": caffeine (0 to 5+ cups),
  hydration, alcohol (0 to 5+ drinks), bright light, screen time. Shown
  expanded automatically when the day already has optional values.
- **7-day back-fill.** A date strip lists today and the previous
  `AppThresholds.checkinBackfillDays - 1` days (never a future date), with a
  check on completed days. Picking one edits that day without touching
  today. Route `/checkin/:date`.
- **Source per field.** `CheckinEntity` keeps `values` and `sources` maps;
  the mapper writes one column per field plus a `sources` JSON object
  (`typed`, `healthkit`, `health_connect`). Typed values are what the
  user tapped; phase 14 fills other sources without overwriting typed ones.
- **Reminder time setting.** Alarm icon in the app bar opens a time picker.
  Stored as `HH:mm` under `SettingsKeys.checkinReminderTime`; default is
  `AppThresholds.defaultCheckinReminder` (20:00) in the central config.
  Phase 21 schedules the notification from this value.
- `SettingsKeys` (one place for key-value names) and `SettingsRepository`
  in `lib/core/settings/`; `todayKeyProvider` from the injectable clock.
- Home screen gains the `CheckinCard` under the start-attack button.
- `CheckinDao.watchRange` for the date strip.
- Test support gains `scrollToKey` for lazy-list screens.

## Tests

- `test/features/checkin/checkin_repository_test.dart`: mapper round-trip
  including sources and cycle day, missing source defaults to typed, upsert
  keeps `createdAt`, inclusive ranges, completeness and value bounds.
- `test/features/checkin/checkin_controller_test.dart`: back-fill window,
  taps saved as typed and cleared by re-tap, back-filled day isolated from
  today, reminder default from config, persisted and re-read, malformed
  values ignored.
- `test/features/checkin/checkin_flow_test.dart` (widget): three taps
  complete the day and update the home card; optional row hidden until
  asked for; date strip has no future day and edits an earlier day;
  reminder time picker stores the value.

## Deviations from the plan

- Reminder time lives on the check-in screen's app bar until the settings
  screen skeleton arrives in phase 09, which will link to the same setting.
- Caffeine and alcohol are 0 to 5 counts rather than 1 to 5 scales, since
  "none" is the most useful answer for both.

## How to verify

```bash
flutter test test/features/checkin
```

On the home screen tap the check-in card, tap one number in each of the
three rows, press Done. The card reads "Done for today". Open it again and
pick an earlier day from the strip.

## What M must fill in

Nothing.
