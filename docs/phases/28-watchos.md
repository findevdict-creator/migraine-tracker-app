# Phase 28: watchOS

Branch: `28-feat-watchos`, cut from `27-feat-wear-os`.
Requirement IDs: FR-16 (watchOS).

## What was done

- **Swift message package** (`ios/RiskWatch/WatchProtocolKit`):
  - It is the Swift twin of `packages/watch_protocol`, with the same
    state, commands, queue, view, labels and wire framing.
  - It uses only Foundation, with 64-bit number handling, because `Int`
    is 32 bits on some Apple Watch models.
  - `WatchStorage` keeps the last state and the unsent commands in the
    app group, so the complication can read them.
- **Shared fixtures** (`packages/watch_protocol/test/fixtures/`):
  - A state and a command batch in JSON.
  - The Dart tests and the Swift tests both decode them and re-encode
    them to the same JSON. A change on either side that breaks the other
    fails CI.
- **Watch app** (`ios/RiskWatch/App`, SwiftUI, watchOS 10):
  - It looks and behaves like the Wear OS app. It shows the level in its
    colour, the top factor and the pressure, and a start button.
  - While an attack runs, it shows "Since 09:12", an intensity picker
    from 0 to 10 and an end button.
  - Taps show at once and are saved on the watch. They are sent as the
    application context, so a closed iPhone app finds them on open, and
    as a message when the iPhone is reachable.
  - It resends every 30 seconds while open, and when the iPhone becomes
    reachable, until the phone acknowledges each command.
  - It reads the state the iPhone left on activation.
- **Complication** (`ios/RiskWatch/Complication`, WidgetKit):
  - Circular and corner faces show a three-step gauge in the level
    colour.
  - Rectangular shows the level and the pressure line. Inline shows the
    level label.
  - It reloads when a new phone state arrives and every 30 minutes.
- **Phone side**: no new code. The phase 27 watch link and command
  handler use `watch_connectivity`, which speaks WatchConnectivity on
  iOS.
- **Build**:
  - `ios/RiskWatch/project.yml` is an XcodeGen spec for the watch app
    and its complication.
  - A new "watchOS app" CI job on macOS runs the Swift tests, generates
    the project and builds it for the watchOS simulator without signing.
  - The generated project is not committed.

## Adding the watch app to Runner (M, in Xcode)

To ship, the watch app must live inside the iPhone app. Do this once in
Xcode, and keep `project.yml` as the reference for the settings.

1. Open `ios/Runner.xcworkspace`.
2. Choose File, New, Target, watchOS App. Name it `RiskWatch` and pick
   "Watch App for Existing iOS App" with Runner as the companion. Delete
   the generated Swift files.
3. Add the files in `ios/RiskWatch/App` to the target.
4. Set the target's build settings:
   - `INFOPLIST_FILE`: `RiskWatch/App/Info.plist`
   - `CODE_SIGN_ENTITLEMENTS`: `RiskWatch/App/RiskWatch.entitlements`
   - Bundle id: `app.migrainetracker.migraineTracker.watchkitapp`
5. Add the local package `ios/RiskWatch/WatchProtocolKit` with File, Add
   Package Dependencies, Add Local. Link it to the watch target.
6. Choose File, New, Target, Widget Extension for watchOS. Name it
   `RiskComplication` and embed it in `RiskWatch`.
   - Replace its sources with `ios/RiskWatch/Complication`.
   - Set its Info.plist and entitlements to the files there.
   - Link `WatchProtocolKit`.
   - Bundle id: `...watchkitapp.complication`.
7. Enable App Groups on both targets with
   `group.app.migrainetracker.migraineTracker`, the same group as the
   home widget.

## Tests

- Dart, in `packages/watch_protocol/test/fixtures_test.dart`. Both
  fixtures decode and re-encode exactly. The package now has 16 tests.
- Swift, in `WatchProtocolKitTests`, with 7 tests:
  - Both fixtures decode and re-encode to equal dictionaries.
  - The wire refuses foreign, malformed and newer payloads.
  - Malformed commands are dropped and intensity is clamped.
  - The view applies pending commands, acknowledgements, stop and label
    fallbacks.
  - Storage round trip and the queue cap.
  - These run only in CI, because there is no Swift toolchain in the
    development container.
- Phone suite unchanged: 378 tests.

## Acceptance criteria

- [x] watchOS app with start, stop, intensity and an offline queue.
- [x] Complication.
- [x] Built in CI on a macOS runner.
- [ ] Watch targets added to `Runner.xcodeproj` (M, steps above).
- [ ] Checked on a real Apple Watch paired with an iPhone (parity
      row 28).

## Manual checks

1. After the Xcode step, run Runner on an iPhone with a paired watch.
   The watch app installs alongside it.
2. Open the iPhone app once. The watch shows today's level. Add the
   complication to a face, and it shows the gauge.
3. On the watch, start an attack, set the intensity and end it. The
   iPhone shows the attack with the watch times.
4. Turn on airplane mode on the iPhone and repeat. The waiting note
   shows. Turn airplane mode off and open the iPhone app. The attack
   appears once.

## Risk and rollback

Everything is new files under `ios/RiskWatch`, plus the fixtures and a
CI job. Reverting the branch removes them. The iPhone app builds the
same with or without them until the Runner targets are added.
