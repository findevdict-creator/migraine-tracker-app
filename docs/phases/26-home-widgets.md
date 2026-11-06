# Phase 26: Home-screen widgets

Branch: `26-feat-home-widgets`, cut from `25-feat-voice-log`.
Requirement IDs: FR-16.

## What was done

- **Snapshot** (`WidgetSnapshot`, pure): built from today's stored risk
  day, the hourly 24 h pressure change the notification planner already
  uses, and whether an attack is running. The current pressure point is
  the first forecast hour that has not passed. The trend is falling or
  rising at 2 hPa or more over 24 h (`AppThresholds.widgetPressureSteadyHpa`)
  and steady inside that band. `render` turns it into the strings the
  native widgets show, in the device language, so native code never
  formats or translates anything.
- **Gateway** (`HomeWidgetGateway`, `home_widget` package): saves the
  strings into shared storage (Android shared preferences, the iOS app
  group) and asks both platforms to redraw. Other platforms and tests get
  a no-op gateway.
- **When it updates**: after home's risk refresh, after each background
  refresh and push wake-up, and when an attack starts or ends. Native
  widgets also redraw every 30 minutes from the last saved strings
  (`AppThresholds.widgetRefresh`). A failure only logs; the widget is
  never worth a failed refresh.
- **Start-attack button**: opens
  `migrainetracker://widget/start-attack`. The app starts an attack and
  opens it, or opens the running attack if there is one, both from a
  cold start and while running. Any other widget tap just opens the app.
- **Android** (`RiskWidgetProvider.kt`, `res/layout/risk_widget.xml`):
  a 3x2 resizable widget with the level in its risk colour, the top
  factor, the pressure line, the update time and the button. Colours
  mirror the risk tokens in light and dark (`res/values*/widget.xml`).
- **iOS** (`ios/RiskWidget/RiskWidget.swift`): a WidgetKit extension in
  small and medium sizes, reading the app group and linking the button
  to the same URL; `CFBundleURLTypes` registers the scheme. The Xcode
  target and the app group capability are a manual step (below).
- **Config**: `AppHomeWidgets` holds the provider name, widget kind, app
  group, start link and storage keys; the native files mirror them and
  are listed under "Native mirrors" in `docs/CONFIGURATION.md`.
- **Wording**: level and factor names reuse the existing labels; no
  forecast language ("predict", "see it coming") anywhere on the widget.

## Tests

- `widget_snapshot_test.dart`: the trend band edges, building from risk,
  forecast and attack state, every key rendered with nothing stored,
  steady and rising wording, and the start link round trip and foreign
  links.
- `home_widget_flow_test.dart` with a recording gateway: opening the app
  publishes, the button starts and opens an attack and the widget flips
  to "Open attack", a cold start with an attack running opens it without
  starting another, a plain tap only opens the app, and a failing gateway
  does not throw.
- Full suite: 374 tests.

## Acceptance criteria

- [x] Widget data comes from local stores, no network call.
- [x] Start-attack button opens the attack screen with a new attack, or
      the running one.
- [x] Android widget provider and layout; iOS WidgetKit source.
- [ ] iOS Widget Extension target and app group added in Xcode (M,
      `docs/CONFIGURATION.md` item 8).
- [ ] Checked on a real device of each platform (parity row 26).

## Manual checks

- Android: long-press the home screen, add "Migraine Tracker". It shows
  today's level and pressure line; tap the button with the app closed:
  the attack screen opens with a new attack. Go back, tap again: the same
  attack opens. End it: the widget button reads "Start attack" again.
- iOS (after the Xcode step): add the widget in small and medium sizes
  and repeat the same checks. Switch to dark mode: colours follow.
- Change the phone language to one the app supports later: the widget
  text follows after the next refresh.

## Risk and rollback

Native files are additive. Reverting the branch removes the widget; the
data the app stores is unchanged. The Android build is checked in CI;
the iOS extension only builds once the target exists in Xcode, so CI
does not cover it yet.
