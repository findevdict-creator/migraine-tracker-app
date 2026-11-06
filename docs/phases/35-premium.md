# Phase 35: Premium

Branch: `35-feat-premium`, cut from `34-feat-share-link`.
Requirement IDs: FR-27.

## What was done

### What is free and what is Premium

FR-27 splits the app in two, and `AppPremium.features` in
`lib/config/app_config.dart` is the only list of what Premium covers:

| Always free, never time-limited | Premium |
| ------------------------------- | ------- |
| Logging attacks, check-ins and doses | Clinician share link (phase 34) |
| Weather feed, pressure and the always-shown factors (AQI, UV, daylight, sunrise and sunset) | Experiments (phase 30) |
| Risk level, trigger load and insights | Extended environment factors: particulates, ozone and pollen (`AppPremium.extendedFactorKeys`) |
| Medication log and overuse notes | Backup across phones (phase 33) |
| Doctor report as PDF and CSV, questionnaires, routines, widgets, watch apps | |

The gate is `PremiumState.allows(feature)`. Its only input is the store's
answer. There is no trial clock, no install date and no usage counter,
so nothing free can run out.

### Store connection

- `purchases_flutter` (RevenueCat) covers both stores with one SDK.
  `RevenueCatGateway` wraps it behind the `PurchasesGateway` interface.
  - It reads the entitlement `AppPremium.entitlementId`.
  - It lists the packages of the current offering, or of
    `AppPremium.offeringId` when set. Prices always come from the store.
  - It buys, restores and maps store errors to plain messages.
- The keys come from `REVENUECAT_API_KEY_ANDROID` and
  `REVENUECAT_API_KEY_IOS`. Without a key the app uses a stand-in.
  - The dev flavor then unlocks everything, so emulator builds can open
    every screen.
  - Staging and prod keep Premium features locked, and the paywall
    says purchases are not set up.
- Purchases follow the account. `PremiumIdentitySync`, at the app root,
  calls `Purchases.logIn(uid)` on sign-in and `logOut` on sign-out. A
  subscription bought on one phone opens Premium on any phone signed in
  to the same account. Restore purchases covers people without an
  account.

### In the app

- **Settings > Premium** (`/premium`) is the paywall. It shows:
  - the four Premium features;
  - a card listing what stays free;
  - the store's monthly and yearly prices, with yearly as the primary
    button;
  - Restore purchases;
  - the auto-renewal terms the stores require, with Terms and Privacy
    links.
  - Signed out, it suggests signing in first when using more than one
    phone. Subscribed, it shows the renewal or end date and Manage
    subscription. That opens the store's page, or the store's
    subscriptions screen when no page is given.
- **Locks** take the place of a Premium feature's controls, explain the
  feature and open the paywall. What people already have stays usable:
  - Experiments: the picker gives way to the lock. A running experiment
    finishes and past results stay.
  - Share link: the sheet on Doctor report shows the lock instead of
    Create link. Existing links keep working until they end, and Stop
    sharing always works.
  - Backup: Back up now gives way to the lock. Restore and delete stay
    for an existing backup.
  - Environment factors: particulates, ozone and pollen give way to one
    line with a See Premium button. The other rows stay.
- A change from the store applies at once, through RevenueCat's customer
  updates. Examples are a purchase on another phone, a renewal or an
  expiry.

### Server

- **`revenueCatWebhook`** (HTTPS, POST only) receives RevenueCat events.
  - It checks the Authorization header against the secret
    `REVENUECAT_WEBHOOK_AUTH` in constant time.
  - It writes `entitlements/{uid}`: the expiry, the product, the store,
    the environment and the event time. Nothing else is kept.
  - Every event for the entitlement stores its expiry, so purchases,
    renewals, cancellations, refunds and expirations follow one rule.
  - An older event delivered late never overwrites a newer one.
  - A transfer moves the record to the other account.
  - Anonymous RevenueCat ids are ignored, since only Firebase uids can
    be checked.
  - Sandbox events are accepted, because App Review and TestFlight buy
    in the sandbox against production builds.
- **`createShareLink`** now refuses with `permission-denied` unless the
  account has Premium. The app shows "Share links need Premium". The
  check runs after the input is validated and before anything is
  stored. Revoking and viewing never need Premium. The check is off on
  the emulator and when `premium.enforceOnServer` is false.
- **Rules**: an owner may read their own `entitlements/{uid}`. Only the
  webhook writes it.
- **Account deletion** now also deletes `entitlements/{uid}`. The store
  subscription itself is cancelled in the store. The delete dialog
  now says so.
- **Open-Meteo**: the commercial key path from phase 10 now reads its
  customer hosts from `functions/src/config.ts`. Selling Premium makes
  the app commercial, so the weather function logs a warning while
  Premium is on and `OPEN_METEO_API_KEY` is unset.

### Backup is gated in the app only

Storage rules could check `entitlements/{uid}` through a cross-service
rule. That would add a Firestore read to every upload, and the Storage
service agent would need extra permission in each project. The backup is
encrypted with the person's own key and costs very little to store, so
the gate stays in the app. `storage.rules` is unchanged. If that changes,
add `firestore.get(/databases/(default)/documents/entitlements/$(uid))`
to the write rule and a matching test in `storage.rules.test.ts`.

## Tests

- `premium_state_test.dart`:
  - without Premium every listed feature is closed; with it, all open;
  - premium switched off, or a dev build without a store, opens all;
  - Premium covers exactly the four FR-27 features, and the
    always-shown factors are not extended;
  - store errors map to paywall messages.
- `premium_flow_test.dart`:
  - **the free tier is never time-limited**: ten years after the test's
    start date, with no subscription, check-in, medications,
    environment, risk, insights, report and questionnaires all open
    with no lock and no paywall;
  - paywall prices, buying the yearly plan, Premium turning on, and
    experiments opening;
  - locks on experiments, backup and the share link, each opening the
    paywall;
  - a lapse from the store locks at once;
  - restore with nothing found, a cancelled purchase with no message,
    and a pending purchase;
  - sign-in and sign-out linking the store customer;
  - no store key: staging locked with a note, dev unlocked.
- `environment_factors_test.dart`: without Premium the extended rows
  give way to one line that opens the paywall.
- `functions/test/premium.test.ts`, 12 tests:
  - event parsing, and anonymous ids dropped;
  - purchase, renewal, cancellation and expiry;
  - a late older event;
  - lifetime purchases, transfers and sandbox events;
  - test events and other entitlements ignored;
  - webhook authorization, including an unset secret letting nothing in;
  - the share function checking Premium after validation and before
    storing, and only there.
- `firestore.rules.test.ts`: entitlements readable by the owner only,
  never writable by a client.
- Full suites: 460 app tests and 60 functions tests (rules tests run separately on the emulators in CI).

## Acceptance criteria

- [ ] Sandbox purchases on both stores. This needs the store products
  and RevenueCat (CONFIGURATION item 15). Steps are under Manual checks.
- [x] Test that the free tier is never time-limited.

## Manual checks

Use a staging build with the RevenueCat keys set.

1. **iOS sandbox.** Sign in with a sandbox Apple account under
   Settings > App Store > Sandbox Account. Open Settings > Premium and
   buy the monthly plan. The locks lift at once. Sandbox renewals come
   every few minutes; let one expire and watch the locks return.
2. **Android test purchase.** Add the tester's Google account as a
   licence tester in Play Console. Install from the internal testing
   track and buy the yearly plan.
3. **Restore.** Reinstall, open Settings > Premium and tap Restore
   purchases. Premium comes back.
4. **Across phones.** Sign in to the same account on a second phone.
   Premium is on there without buying again.
5. **Server check.** After a sandbox subscription lapses, open the share
   sheet on a build with the lock removed, or call `createShareLink`
   directly. The server answers `permission-denied`. In the RevenueCat
   dashboard, the webhook shows 200 responses.
6. **Free features.** With no subscription, log an attack, a check-in
   and a dose, and open the environment screen, insights and the doctor
   report. Nothing is locked.

## What M must fill in

CONFIGURATION item 15:

- the store products;
- the RevenueCat project, entitlement `premium` and current offering;
- the public SDK keys in the env files;
- the webhook URL and the `REVENUECAT_WEBHOOK_AUTH` secret;
- the Open-Meteo commercial key;
- the In-App Purchase capability in Xcode.

Pricing is set in the stores. FR-27 targets about $2.99 a month and
$19.99 a year.

## Risk and rollback

- To make everything free, set `AppFeatureFlags.premiumAvailable` to
  false and `premium.enforceOnServer` to false in
  `functions/src/config.ts`.
- To free one feature, remove it from `AppPremium.features`. For the
  share link, also turn off the server check.
- If RevenueCat cannot be reached, the app reads as not subscribed. Free
  features are never affected, and existing share links and backups
  stay usable.
