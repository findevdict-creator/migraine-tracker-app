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
