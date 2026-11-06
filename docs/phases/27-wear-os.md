# Phase 27: Wear OS

Branch: `27-feat-wear-os`, cut from `26-feat-home-widgets`.
Requirement IDs: FR-16 (Wear OS).

## What was done

- **Shared message package** (`packages/watch_protocol`, pure Dart, used
  by both apps):
  - `WatchState`, phone to watch: the level, top factor, pressure and
    update lines already in the phone's language, the level colour for
    dark screens, the brand colour, the running attack, every button
    label, and the ids of the commands the phone has applied.
  - `WatchCommand`, watch to phone: start, stop or intensity, with a
    unique id and the time it was made on the watch.
  - `CommandQueue` keeps the watch's commands until they are
    acknowledged. `CommandLedger` makes the phone apply each id once.
    `WatchView` shows the phone's state with pending taps applied on top.
  - The JSON travels as one string under one key, because the Wear OS
    data layer carries flat maps only.
  - `WatchConfig` holds the watch settings both apps read. The phone's
    `app_config.dart` re-exports it as `AppWatch`.
- **Phone side** (`lib/features/watch/`):
  - It sends the state through `watch_connectivity` as the application
    context, so the watch gets it even when its app is closed.
  - It sends at the same moments as the home widget: on open, after
    background refreshes and push wake-ups, and when an attack starts or
    ends. A widget failure and a watch failure never block each other.
  - It applies watch commands from live messages, from context updates,
    and from the context the watch left while the phone app was closed.
  - A start uses the watch's time, and an end too, never before the
    start. A time ahead of the phone's clock is clamped to now.
  - Intensity sets the running attack. A stop with nothing running is
    acknowledged and ignored.
  - After applying, it sends a fresh state that carries the
    acknowledgements.
- **Wear OS app** (`wear/`, a separate Flutter project in the repo):
  - One scrolling column for round screens. It shows the level in its
    colour, the top factor and pressure lines, and a start button.
  - While an attack runs, it shows "Since 09:12", an intensity picker
    from 0 to 10 and an end button.
  - Taps show at once, are saved on the watch and are sent to the phone.
    They are resent every 30 seconds while the app is open, and again on
    the next open, until the phone acknowledges them. A note says when
    taps are waiting.
  - It never goes online.
  - The same application id and flavors as the phone app, which the data
    layer requires. `minSdk` 30 (Wear OS 3). It does not run without the
    phone (`standalone` false).
- **Tile** (`RiskTileService.kt`, Wear Tiles 1.4 with ProtoLayout):
  - It shows the level in its colour, the top factor and the pressure
    line, read from the strings the app stored. Tapping it opens the app.
  - It redraws when a new phone state arrives and every 30 minutes.
- **CI**: a new "Wear OS app" job formats, analyses, tests and builds
  the dev debug APK. The "Pure Dart packages" step already picks up
  `watch_protocol`.

## Tests

- `packages/watch_protocol/test/watch_protocol_test.dart` has 14 tests.
  - The wire wrap and refusal of foreign, malformed or newer payloads.
  - Command and state round trips, and malformed entries.
  - Queue cap and acknowledgement, and ledger dedupe and the ack window.
  - The view with pending, acknowledged and stop commands.
- `test/features/watch/watch_flow_test.dart` runs the phone app with a
  fake watch link.
  - Opening the app sends the state and labels.
  - Start and intensity land at the watch time.
  - A resent batch applies once and a stop ends at the watch time, with
    acks sent back.
  - Taps left while the phone app was closed are applied on open.
  - A future watch time is clamped, and a stop with nothing running is
    ignored.
- `wear/test/wear_app_test.dart` runs the watch UI with fakes.
  - The fallback before any phone state.
  - The level and the tile update.
  - Start, intensity and end offline, with the queue resent and cleared
    by acks.
  - The queue is resent on start.
  - An older state or a foreign payload is ignored.
- Phone suite: 378 tests. Wear suite: 6 tests.

## Acceptance criteria

- [x] The Wear OS app is in the same repo, and CI builds it.
- [x] Start, stop and intensity from the watch, synced through the phone
      when it is reachable and queued when it is not.
- [x] A risk tile.
- [ ] Checked on a real watch paired with a phone (parity row 27).

## Manual checks

1. Install the phone app with the dev flavor:
   `flutter run --flavor dev -t lib/main_dev.dart`.
2. Install the watch app with the dev flavor:
   `cd wear && flutter run --flavor dev`.
3. Open the phone app once. The watch shows today's level, and the tile
   ("Migraine level") shows the same.
4. On the watch, tap Start and raise the intensity. The phone's home
   shows the running attack with that intensity.
5. Tap End on the watch. The attack ends on the phone at that minute.
6. Turn off the phone's Bluetooth, then start and end an attack on the
   watch. The waiting note shows. Turn Bluetooth back on and open both
   apps. The attack appears once, with the watch times, and the note goes
   away.

## Risk and rollback

The watch app and the shared package are new folders. On the phone, the
watch code only runs when a watch is paired, and
`AppFeatureFlags.watchAvailable` turns it off. Reverting the branch
removes all of it, and stored attacks are unchanged.

The tile's Kotlin code compiles only in CI, because there is no Android
SDK in the development container.

The watch uses Flutter's template launcher icon until the release-prep
phase generates the real icons.
