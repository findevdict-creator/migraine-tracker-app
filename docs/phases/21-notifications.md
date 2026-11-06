# Phase 21: Notifications

Branch: `21-feat-notifications`, cut from `20-feat-trigger-insights`.
Requirement IDs: FR-14.

## What was done

- **Five types, each with its own switch** (`NotificationType`): risk
  rising, pressure drop, "is your attack over?", daily check-in and
  preventive medication. All but medication are on by default. Switches
  live under Settings > Notifications (`/notifications`) with the pressure
  threshold slider (2 to 12 hPa per 24 h) and the medication time.
  Turning a type on asks the OS for permission; a refusal shows a hint.
- **Planner** (`NotificationPlanner`, pure): turns the local stores into
  dated notifications with event keys.
  - Risk rising: a stored day whose level is above the previous day's
    (a missing previous day counts as low) gets `risk:<date>:evening` at
    20:00 the day before and `risk:<date>:morning` at 08:00.
  - Pressure drop: the first cached forecast hour of each day whose
    24 h change is at or below minus the threshold gets `pressure:<date>`,
    delivered a minute from now.
  - Attack over: the running attack gets `attackOver:<id>` at its start
    plus the typical duration (median of completed attacks once five
    exist, else four hours), or a minute from now when already past. The
    notification carries an "End attack" action.
  - Check-in and medication: one per day over the forecast window at the
    set times (`checkin:<date>`, `medication:<date>`); days that already
    have a check-in are skipped.
- **Dedupe**: delivered keys are kept for a week in settings
  (`notifications.sent`). A key recorded at or before now was delivered
  and is never scheduled again; a key recorded for later was only
  pending and is re-planned (so a changed forecast moves it).
- **Scheduler** (`NotificationScheduler`): reads the switches and the
  stores, plans, dedupes, cancels every pending notification and hands
  the fresh plan to the gateway with rendered copy. Runs after each risk
  refresh (home watches `notificationRefreshProvider`), after an attack
  starts (not awaited, so the attack screen opens at once) and after any
  switch changes. Calls queue behind each other so two refreshes never
  interleave.
- **Gateway** (`LocalNotificationGateway` over
  `flutter_local_notifications`): three channels (alerts, reminders,
  attack), the iOS category with the end-attack action, inexact
  scheduling in the device time zone. Desktop and tests get a no-op
  gateway; tests record calls.
- **Actions** (`NotificationActions`): the end-attack action ends the
  attack named in the payload, re-learns the weights and reschedules.
  A plain tap opens the app. Responses from a closed app are replayed
  on start (`NotificationResponses` in the widget tree).
- **Native**: `POST_NOTIFICATIONS` and `RECEIVE_BOOT_COMPLETED` with the
  plugin's receivers on Android (notifications survive a reboot), core
  library desugaring in Gradle, the notification centre delegate in
  `AppDelegate.swift`.
- **Config**: `AppThresholds.riskRisingEveningHour`,
  `riskRisingMorningHour`, `defaultAttackDuration`,
  `notificationDedupeRetention`, `notificationLeadTime`,
  `defaultMedicationReminder`; `AppNotificationChannels` for the channel
  ids, the action id and the Android icon.

## Tests

- `notification_planner_test.dart`: every type and switch; the evening
  slot dropped once past; a missing previous day; the threshold boundary
  (a fall equal to the threshold counts); one alert per day; attack past
  its typical length; check-in days skipped; the plan sorted; dedupe at
  the boundary (recorded exactly at now is delivered, later is pending);
  prune keeps a week; stable ids.
- `notification_scheduler_test.dart`: defaults, settings round-trip, a
  full plan from the stores with rendered copy and the sent record,
  delivered keys not re-scheduled and pruned, every switch off gives an
  empty plan, the median duration, concurrent reschedules queue.
- `notification_actions_test.dart`: end-attack ends the running attack
  and reschedules; taps, unknown ids and ended attacks do nothing.
- `notification_settings_screen_test.dart`: five switches with their
  defaults, permission asked and persisted, the denied hint, the
  threshold slider, the medication time picker.
- Full suite: 277 tests.

## Acceptance criteria

- [x] All five types schedulable and individually off.
- [x] Dedupe unit tests.

## Manual checks

- Turn on "Is your attack over?", start an attack, set the phone clock
  four hours ahead: the notification appears with an "End attack"
  action; pressing it ends the attack without opening the app.
- Turn every type off: no notification arrives over a day.
- Reboot the phone: pending reminders still fire.

## What M must fill in

- Nothing. The channels and copy are in config and the ARB.
