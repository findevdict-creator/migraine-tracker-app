# iOS versus Android feature parity

Ticked when the feature is verified on a real device of each platform. Every
feature PR adds its row.

| # | Feature | Android | iOS | Notes |
| - | ------- | ------- | --- | ----- |
| 01 | App boots to the home screen in all three flavors | [ ] | [ ] | iOS schemes to be created in Xcode |
| 02 | Encrypted database opens and survives restart | [ ] | [ ] | key in Keystore / Keychain |
| 03 | Attack theme and 200% text scale on the theme gallery | [ ] | [ ] | |
| 04 | Dev build talks to the Firebase emulator; App Check debug provider | [ ] | [ ] | |
| 05 | Start, fill and end an attack; finish later and continue; head map taps | [ ] | [ ] | VoiceOver / TalkBack read region names |
| 06 | Three-tap check-in, back-fill strip, reminder time picker | [ ] | [ ] | |
| 07 | Log a dose standalone and inside an attack; relief question; overuse note link opens browser | [ ] | [ ] | |
| 08 | Cycle toggle, period start chip on check-in, cycle screen | [ ] | [ ] | |
| 09 | Share sheet opens for JSON and CSV export; delete everything empties the app | [ ] | [ ] | |
| 10 | Weather cache function (server only; checked on-device in 11) | n/a | n/a | |
| 11 | Approximate-location prompt, environment screen fills, airplane mode shows age, typed city, background refresh runs | [ ] | [ ] | iOS: BGTaskScheduler simulate command in the phase doc |
| 12 | Gauge moves with the sensor; attack export shows both pressures; station fallback on a phone without a barometer | [ ] | [ ] | |
| 13 | Factors card shows local sunrise and sunset; About the data links open the browser | [ ] | [ ] | |
| 14 | Health prompts per type, history prompt (Android), sleep pre-filled with icon, headache written back | [ ] | [ ] | iOS needs the HealthKit capability in Xcode |
| 15 | Fresh install flow, location prompt, populated environment screen under 60 s (`integration_test/onboarding_flow_test.dart`) | [ ] | [ ] | |
| 16 | Risk model package (pure Dart, no device behaviour) | n/a | n/a | |
| 17 | Weights re-learned after an attack ends; risk rows stored on open | [ ] | [ ] | |
| 18 | Risk card shows the level in airplane mode; badge flips at ten attacks | [ ] | [ ] | |
| 19 | Meter segments tappable on the card; marks move after learning | [ ] | [ ] | |
| 20 | Insights lists match the drivers seen over the past weeks | [ ] | [ ] | |
| 21 | Attack-over notification carries End attack; every type can be turned off | [ ] | [ ] | |
| 22 | A test wake-up push refreshes the forecast with the app closed | [ ] | [ ] | |
| 23 | Share PDF opens the share sheet with a readable PDF; spreadsheets open with one row per attack and per day | [ ] | [ ] | |
| 24 | MIDAS and HIT-6 forms score and save; three-month reminder arrives; chart after two rounds | [ ] | [ ] | HIT-6 licence to confirm before release |
| 25 | Voice sentence fills the confirm form and saves; works in airplane mode with the offline speech pack | [ ] | [ ] | Android needs the on-device recognition pack |
| 26 | Widget shows today's level, pressure trend and update time; start button opens a new attack (or the running one) from a cold start; widget updates after an attack starts and ends | [ ] | [ ] | iOS needs the Xcode widget target and app group (CONFIGURATION item 8) |
| 27 | Watch start, intensity and end show on the phone at the watch times; taps made with the phone away arrive once when it is back; tile shows today's level | [ ] | n/a | Wear OS only; watchOS is row 28 |
| 28 | Watch start, intensity and end show on the iPhone at the watch times; taps made with the iPhone away arrive once when it is back; complication shows today's level | n/a | [ ] | watchOS only; needs the Runner targets (CONFIGURATION item 10) |
| 29 | Routine card appears on a high day and after a neck-tension check-in; "Not today" hides it until tomorrow; breathing timer runs and respects reduce motion | [ ] | [ ] | Content needs clinician review before release |
| 30 | Pick a change, answer the daily question, see the comparison with sample sizes and caveat; stop and finish keep the result in the past list | [ ] | [ ] | |
| 31 | Running attack shows "Typically X to Y h" with the sample size after five finished attacks; nothing before; updates with intensity and medication | [ ] | [ ] | |
| 32 | Account screen: sign in with Apple (iOS), Google and email; signed-out app fully usable; delete account explains the 24-hour purge and keeps phone data | [ ] | [ ] | Needs sign-in methods turned on in Firebase |
| 33 | Back up with a passphrase, restore on a reinstall and on a second phone; wrong passphrase changes nothing; mitmproxy with a user CA is refused | [ ] | [ ] | Pentest checklist in docs/security |
| 34 | Create a 7 and a 30 day link from Doctor report; the page matches the PDF; Stop sharing makes the page say it is no longer shared; an expired link says so | [ ] | [ ] | Needs Hosting deployed |
| 35 | Sandbox purchase of the monthly and the yearly plan; locks lift at once; Restore purchases on a reinstall; Premium follows the account to a second phone; a share link is refused by the server after the sandbox subscription lapses; free features open with no lock | [ ] | [ ] | Needs RevenueCat, store products and the webhook (CONFIGURATION item 15) |
| 36 | After ten attacks the audit page appears from Settings; counts match a hand count; turning sharing on after the 3rd writes one anonymous `audit_counts` document per month with only the six fields | [ ] | [ ] | Staging Firebase with App Check |
