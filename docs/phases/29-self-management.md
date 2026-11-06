# Phase 29: Self-management routines

Branch: `29-feat-self-management`, cut from `28-feat-watchos`.
Requirement IDs: FR-22.

## What was done

- **Six routines**, each with a title, a short summary and numbered
  steps. The wording lives in the ARB, so it is translated with
  everything else.
  - Gentle neck and shoulder stretches, with a clear "stop if anything
    hurts" line.
  - Paced breathing.
  - Low light and quiet.
  - Drink some water.
  - Keep caffeine steady.
  - Steady sleep.
- **Illustrations**: one SVG per routine in `assets/routines/`, named by
  routine code (`AppAssets.routineIllustration`). The current files are
  simple placeholders in the brand colour. M swaps the files and keeps
  the names. They are marked decorative for screen readers, because the
  title beside them says the same.
- **Paced breathing timer** on the breathing routine:
  - A circle grows for 4 seconds in and shrinks for 6 seconds out, over
    six rounds. It shows "Round 2 of 6", has a Stop button and ends with
    a closing line.
  - The words are a live region for screen readers.
  - With reduce motion, from the system or the app setting, the circle
    stays still and only the words change.
  - The timing is in `AppThresholds.breathingIn`, `breathingOut` and
    `breathingRounds`.
- **Suggestions on home** (`RoutineSuggester`, pure):
  - Stretches after a check-in with neck tension at 4 or more.
  - Breathing after a check-in with stress at 4 or more.
  - Breathing, low light and water on a high day.
  - Check-in reasons come first, each routine shows once, and at most
    two show. Each comes with its reason, for example "Your check-in
    shows neck tension".
  - The card sits under the risk card and only appears when there is
    something to suggest.
  - "Not today" hides the shown routines until the next day. The setting
    is stored per date, so a new day starts clean. "All routines" opens
    the list.
  - The trigger value and the count are in
    `AppThresholds.routineCheckinTrigger` and `routineSuggestionsMax`.
- **Screens**:
  - `/routines` lists every routine. It opens from settings and from the
    card.
  - `/routines/:code` shows one routine.
  - Both end with the wellness disclaimer line.
- **Clinician review**: `docs/content/routines-review.md` lists every
  routine string, with what the reviewer should check and a record table.
  It is marked "not reviewed". `docs/CONFIGURATION.md` has it as fill-in
  item 11.

## Tests

- `routine_suggester_test.dart`:
  - The calm-day case.
  - The neck-tension and stress trigger edge.
  - High-day suggestions and the order.
  - Dedupe, the cap, and dismissed routines.
  - Dismissal storage and the day rollover.
  - Every routine has content and an illustration path.
- `routines_flow_test.dart`:
  - No card on a calm day.
  - A tense-neck check-in shows stretches with its reason. Tapping it
    opens the routine with the disclaimer. "Not today" hides the card
    and stores the dismissal.
  - Settings opens the list with all six routines.
  - The breathing timer advances, stops, and finishes six rounds.
- Full suite: 388 tests.

## Acceptance criteria

- [x] Routines screen and suggestion cards.
- [x] Suggested on high days and after high neck-tension or stress
      check-ins, with a dismissal for the day and the disclaimer line.
- [x] Content flagged for clinician review before release.
- [ ] Clinician review done (M, `docs/content/routines-review.md`).
- [ ] Final illustrations (M).

## Manual checks

1. Save a check-in with neck tension 5. Home shows "Something that may
   help today" with the stretches. Tap it, and the steps open.
2. Tap "Not today". The card goes away and stays away until tomorrow.
3. Open settings, then Self-care routines, then Paced breathing. Tap
   Start. Follow one round, then tap Stop.
4. Turn on reduce motion in the system settings and start again. The
   circle stays still and the words change.

## Risk and rollback

This phase adds a feature folder, assets, one settings key and one
dependency, `flutter_svg`. Reverting the branch removes them. A stored
dismissal is ignored by older builds.
