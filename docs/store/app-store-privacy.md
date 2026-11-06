# App Store Connect: App Privacy

Answers for App Store Connect > App Privacy, for version 1.0.0. They
match `ios/Runner/PrivacyInfo.xcprivacy`; change both together.

**Do you or your third-party partners collect data from this app?** Yes.

**Tracking:** No data is used to track. There is no advertising SDK and no
cross-app or cross-site linking. `NSPrivacyTracking` is false.

## Data linked to the person

These are only collected for people who create an account or buy Premium.

| Data type | Purpose | Notes |
| --------- | ------- | ----- |
| Contact info: Email address | App functionality | Optional account |
| Identifiers: User ID | App functionality | Firebase user id |
| Health and fitness: Health | App functionality | The report summary behind a share link the person creates |
| Purchases: Purchase history | App functionality | Premium, through RevenueCat |

## Data not linked to the person

| Data type | Purpose | Notes |
| --------- | ------- | ----- |
| Location: Coarse location | App functionality | Rounded weather cell |
| Identifiers: Device ID | App functionality | Push token for weather wake-ups |
| Diagnostics: Crash data | App functionality | Opt-in |
| Diagnostics: Other diagnostic data | Analytics | Opt-in anonymous monthly accuracy counts |

## Not collected

Everything logged in the app (attacks, check-ins, medications, HealthKit
data, the risk level and insights) stays on the phone. The encrypted
backup is end-to-end encrypted, which Apple does not count as collection.

## HealthKit

- The HealthKit capability description and the purpose strings are in
  `ios/Runner/Info.plist`.
- Review notes: HealthKit data is read only after the person turns each
  type on in Health data, is stored on the phone, and is never sent to a
  server or used for advertising.
