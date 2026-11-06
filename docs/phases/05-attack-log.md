# Phase 05: Attack log

Branch: `05-feat-attack-log`, cut from `04-feat-firebase-setup`.
Requirement IDs: FR-1 (one-tap attack log, attack mode), reliability NFR
(nothing entered mid-attack is lost), accessibility NFR (56 pt targets,
screen-reader labels on every control).

## What was done

- **One tap from home.** `StartAttackButton` on the home screen creates a
  running attack and opens it. If an attack is already running the same tap
  reopens it ("Continue attack"), so a second tap never creates a duplicate.
- **Attack screen in the attack theme.** `AttackScreen` wraps itself in
  `AppTheme.attack()`: true-black background, 56 pt targets, no motion.
  Sections: start time, 0 to 10 intensity slider, head map, symptom chips,
  phase chips, notes, then **End attack**. **Finish later** in the app bar
  keeps the attack running, flags it, and returns home.
- **Head map** (`HeadMap`) is drawn with a `CustomPainter` (outline, ears,
  neck, nine region guides, filled when selected). Each region is a
  `Semantics` button with a localized label and at least a 48 dp hit area;
  no image asset is needed.
- **Symptom chips with per-tap timestamps.** Aura, neck tension, light,
  sound, smell sensitivity, nausea. Tapping adds a `SymptomTap` with the
  current time; tapping again removes it. Stored as JSON on the attack row.
- **Phases as columns on one record.** Prodrome, aura, attack, postdrome are
  keys in the attack's `phases` map with the time each was marked. Starting
  an attack stamps the `attack` phase. There is never a second row per phase.
- **Every edit is persisted immediately.** `AttackEditor` (Riverpod
  `AsyncNotifier` family keyed by attack id) writes each change through
  `AttackRepository.save`, which is one transaction. A crash or swipe-away
  mid-attack keeps everything entered so far.
- **Domain layer.** `AttackEntity`, `HeadLocation`, `Symptom`, `AttackPhase`,
  `SymptomTap`; `AttackRepository` interface with a Drift implementation and
  a mapper that tolerates unknown codes from older builds.
- **Pressure stamp seam.** `PressureStampSource` is injected into
  `AttackStarter`; the default `NoPressureStamp` leaves both pressure columns
  null. Phase 12 (barometer) supplies the real source without touching this
  feature.
- `clockProvider` and `idGeneratorProvider` in `lib/core/util/clock.dart`
  so every feature's timestamps and ids are deterministic in tests.
- Route `/attack/:id` registered in `AppRoutes`.
- Test support now runs widget tests in an `UncontrolledProviderScope`
  whose container is disposed in the test tear-down, and each test gets its
  own in-memory database by default.

## Tests

- `test/features/attack_log/data/attack_repository_test.dart`: mapper
  round-trip of every column, unknown codes are dropped, insert then update
  keeps `createdAt`, running versus completed, `watchRunning` emissions,
  delete.
- `test/features/attack_log/presentation/attack_log_controller_test.dart`:
  starter creates a stamped running attack, returns the running one instead
  of a second, uses an injected pressure source; editor persists every edit,
  symptom taps carry their time and toggle off, phases stay on one record,
  `end` is idempotent and clears `finishLater`, blank notes become null.
- `test/features/attack_log/presentation/attack_flow_test.dart` (widget):
  one tap opens the attack screen in the attack theme (true black); slider,
  head map, symptoms with a 15 minute gap, and a phase all persist; end
  attack stores the duration and notes and returns home; finish later keeps
  it running and the home button continues it; head map regions are
  announced as selectable buttons.

## Deviations from the plan

- Symptoms and head locations are tracked by stable enum codes (not display
  strings) so localization in phase 37 cannot change stored data.
- The attack screen is a lazy list; tests scroll fields into view rather
  than assuming a fixed screen height.

## How to verify

```bash
flutter test test/features/attack_log
flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=env/dev.json
```

On the home screen tap **Start attack**, set intensity, tap a head region
and a few symptoms, press back or kill the app, reopen: the home button
reads **Continue attack** and everything is still there.

## What M must fill in

Nothing new. The barometer phase will provide the pressure stamp.
