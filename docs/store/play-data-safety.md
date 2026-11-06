# Google Play: Data safety form

Answers for Play Console > App content > Data safety, for version 1.0.0.
Keep in step with `ios/Runner/PrivacyInfo.xcprivacy` and
[app-store-privacy.md](app-store-privacy.md). If a feature changes what
leaves the phone, update all three in the same pull request.

## Overview questions

| Question | Answer |
| -------- | ------ |
| Does your app collect or share any of the required user data types? | Yes |
| Is all of the user data collected by your app encrypted in transit? | Yes (HTTPS to Firebase, Open-Meteo through our function, RevenueCat) |
| Do you provide a way for users to request that their data is deleted? | Yes: in the app (Settings > Account > Delete account, and Settings > Delete everything) and at `AppIdentity.privacyPolicyUrl` |
| Has your app been independently validated against a security standard? | No (the backup pentest checklist in `docs/security/` is internal) |

Data that never leaves the phone is not "collected" under Play's
definition. That covers the attack log, check-ins, medications, Health
Connect data, the risk level, insights and exports the person saves
themselves.

## Data types

"Shared" is No for every row: no data goes to third parties beyond the
service providers that process it for us (Firebase, RevenueCat), which
Play does not count as sharing.

| Category: type | Collected | Optional | Purpose | When |
| -------------- | --------- | -------- | ------- | ---- |
| Personal info: Email address | Yes | Yes | Account management | Only if the person creates an email account (Apple or Google sign-in pass an email to Firebase Auth too) |
| Personal info: User IDs | Yes | Yes | Account management, App functionality | Firebase user id, with an account |
| Health and fitness: Health info | Yes | Yes | App functionality | Only the report summary behind a share link the person creates; deleted when it expires or they stop sharing |
| Financial info: Purchase history | Yes | Yes | App functionality | Premium purchases, through RevenueCat |
| Location: Approximate location | Yes | No (weather needs it) | App functionality | The weather cell (about 11 km, `AppThresholds` rounding) sent to fetch the forecast; not stored against a person |
| App activity: Other actions | Yes | Yes | Analytics | The opt-in anonymous monthly accuracy counts (five numbers and the model version, no id) |
| App info and performance: Crash logs | Yes | Yes | App functionality | Opt-in crash reports (Crashlytics) |
| App info and performance: Diagnostics | No | | | |
| Device or other IDs | Yes | No | App functionality | Push token for weather wake-ups, stored without an account |
| Files and docs | No | | | The encrypted backup is end-to-end encrypted with the person's passphrase, so we cannot read it. Play still asks for it: answer "Files and docs: Yes, optional, App functionality" if the reviewer disagrees |

## Health apps declaration

See [play-health-declaration.md](play-health-declaration.md). Category:
Health and fitness, symptom tracking. The app is not a medical device.

## Notes for the reviewer field

The app works fully without an account. Weather is fetched for a rounded
location cell through our own function, so Open-Meteo never sees the
phone. Backups are encrypted on the phone before upload.
