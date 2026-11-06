# Phase 38: Accessibility pass

Branch: `38-feat-accessibility-pass`, cut from `37-feat-localization`.
Requirement IDs: accessibility NFR (WCAG 2.2 AA, VoiceOver and TalkBack,
dynamic type to 200%, reduce motion).

## What was done

### A scanner on every screen

`test/a11y/accessibility_scan_test.dart` opens 22 screens on a 360 × 720
phone, in light and dark. On each it scrolls to the end, and at every
scroll position it runs Flutter's built-in checks:

- text contrast (WCAG 1.4.3: 4.5:1, or 3:1 for large text);
- every control has a label (WCAG 4.1.2);
- tap targets at least 48 × 48 dp (Android) and 44 × 44 pt (iOS).

It writes `build/a11y/report.md`, which CI uploads as the
`accessibility-report` artifact. This run's copy is in
[38-accessibility-scan.md](38-accessibility-scan.md): all 22 screens pass
in both themes. A further test hands the checks a deliberately bad screen
(a small unlabelled button and pale text) and expects every check to fail,
which shows the scanner actually catches problems.

The theme-token contrast test from phase 3 (`test/core/theme/contrast_test.dart`)
still covers the colour pairs the scanner cannot see, such as risk badges
in every state.

The walk itself moved to `test/support/screen_walk.dart` and is shared
with the phase 37 language checks. Two screens were added to it: check-in
and the MIDAS form.

### Screen readers on the attack and check-in screens

`test/a11y/screen_reader_test.dart` goes through the screens stop by stop,
the way VoiceOver and TalkBack do (`simulatedAccessibilityTraversal`).

Attack screen:
- Every stop that does something has a label.
- The order runs top to bottom: intensity, head map, symptoms, phases,
  End attack.
- Head regions announce as buttons and say whether they are selected.

The intensity slider was fixed. It used to be read as three separate
stops: the label, the slider as "50%", and the big number. It is now one
stop that says "Pain intensity", then the value on the scale's own terms
("7"), then both end labels as the hint, and swiping up or down changes
it. The test performs that swipe and checks the value moves to 1. The
same fix applies to the 1 to 5 check-in sliders.

Check-in: every question and answer chip has a label.

### Dynamic type at 200%

The app follows the phone's text size up to `AppThemeTokens.maxTextScale`
(200%).

- `test/a11y/large_text_test.dart` walks all 22 screens at 200% and checks
  the scale actually reaches them.
- `screen_reader_test.dart` scrolls the whole attack screen at 200%.

That found one problem. At 200%, the attack screen's "Finish later"
action overflowed the app bar. Above `AppThemeTokens.appBarTextActionMaxScale`
(1.3) it now becomes an icon button whose tooltip, "Finish later", is
what screen readers announce.

The language walk also found that the check-in scale end labels ("Calm" /
"Very stressed" and the like, longer once translated) could push each
other off screen. Each now takes half the
width and wraps.

### Reduce motion

Before this phase the app's own reduce-motion preference lived in memory
only and nothing in Settings set it.

- **Saved switch:** Settings > Reduce motion is now a saved switch
  (`SettingsKeys.reduceMotion`). It sits alongside the phone's own setting:
  either one turns motion down.
- **One flag:** the app root folds the switch into
  `MediaQuery.disableAnimations`, so every widget below reads a single
  flag.
- **Page transitions:** `ReducedMotionPageTransitionsBuilder` wraps the
  platform transitions (predictive back on Android, the iOS slide) and
  cuts straight to the new screen under reduce motion.
- **Onboarding:** the pager jumps between pages instead of sliding.
- **Breathing timer:** the paced breathing circle already held still
  under reduce motion (phase 29).

## Per-screen checklist

| Screen | Labels | Contrast (light, dark) | Tap targets | 200% text | Screen reader order | Reduce motion |
| ------ | ------ | ---------------------- | ----------- | --------- | ------------------- | ------------- |
| Home | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Attack | ✓ | theme test (attack theme) | ✓ | ✓ (fixed) | ✓ test | transitions |
| Check-in | ✓ | ✓ ✓ | ✓ | ✓ (fixed) | ✓ test | transitions |
| Environment | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Risk | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Insights and method | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Settings | ✓ | ✓ ✓ | ✓ | ✓ | scanner | switch lives here |
| Medications | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Notifications | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Routines | ✓ | ✓ ✓ | ✓ | ✓ | scanner | breathing circle still |
| Questionnaires and MIDAS form | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Doctor report | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Experiments | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Account, backup, shared links | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Premium, audit, units | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Barometer, about the data | ✓ | ✓ ✓ | ✓ | ✓ | scanner | transitions |
| Onboarding | goldens and flow tests | ✓ (theme test) | ✓ | not walked | manual | pager jumps |

"Scanner" means labels and targets are checked automatically. The order a
screen reader reads in is checked by test only for attack and check-in,
and by hand for the rest (Manual checks).

## Configuration

| Value | Default | Meaning |
| ----- | ------- | ------- |
| `AppThemeTokens.maxTextScale` | 2 | largest text scale the app follows |
| `AppThemeTokens.appBarTextActionMaxScale` | 1.3 | above it, worded app bar actions become icons |
| `AppThemeTokens.minTapTarget`, `attackTapTarget` | 48, 56 | tap target sizes |
| `SettingsKeys.reduceMotion` | off | the app's reduce-motion switch |

## Tests

- `test/a11y/accessibility_scan_test.dart`: 22 screens × 2 themes × 4
  checks, plus the bad-screen self-check.
- `test/a11y/screen_reader_test.dart`: attack traversal, labels, order,
  slider value and swipe, head region flags; check-in labels; attack
  screen at 200%.
- `test/a11y/large_text_test.dart`: all screens at 200%.
- `test/a11y/reduce_motion_test.dart`: the switch is saved and turns
  animations off; the phone setting alone does too; the transition
  builder returns the page untouched under reduce motion and the
  platform transition otherwise.
- Goldens for the core widget gallery updated: the slider's end labels
  now split the width.
- Full suite: 508 app tests.

## Acceptance criteria

- [x] Per-screen accessibility checklist completed (above).
- [x] Scanner report attached ([38-accessibility-scan.md](38-accessibility-scan.md) and the CI artifact).
- [ ] VoiceOver and TalkBack walk on real devices (Manual checks).

## Manual checks

1. **TalkBack (Android):** start an attack from Home. Swipe through: the
   title, Finish later, Started at, Pain intensity (swipe up raises it
   and announces the number), each head region ("Left temple, button,
   not selected"), the symptoms, the phases, notes, End attack. Double-tap
   End attack.
2. **VoiceOver (iPhone):** do the same, using the rotor to adjust the
   slider.
3. **Check-in with a screen reader:** each question reads its label and
   each answer reads its meaning, not just a number.
4. **Largest text:** in display settings pick the largest size. Nothing
   on Home, the attack screen or the check-in is cut off. Finish later is
   a clock icon.
5. **Reduce motion:** turn it on in Settings. Moving between screens cuts
   instead of sliding, and onboarding (after Delete everything) jumps
   between pages. Turn it off again, then turn on the phone's own
   setting: same behaviour.

## What M must fill in

Nothing to configure. Before release, run the manual TalkBack and
VoiceOver walk on real devices. Ideally ask a screen-reader user to try
logging an attack, since automated checks cannot judge whether the
wording makes sense when heard.

## Risk and rollback

- The slider semantics change is contained in `AppIntensitySlider`.
  Reverting the file restores the old reading.
- Reduce motion only removes animation. Turning the switch off restores
  every transition.
