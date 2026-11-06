# Phase 22: Push wake-up

Branch: `22-feat-push-wakeup`, cut from `21-feat-notifications`.
Requirement IDs: FR-14 (delivery between opens), NFR on offline-first.

## What was done

The local alerts of phase 21 are planned from the cached forecast. A phone
that is not opened for a day keeps planning from stale data. This phase
gives the server a way to nudge every installed app on a schedule so it
refreshes the forecast and re-plans, without the server knowing anything
about the person.

- **Scheduled function** `pushWakeup` (`functions/src/push/wakeup.ts`):
  every six hours (`config.push.schedule`) it reads `push_tokens`, sends
  one silent FCM message per token in batches of 500 and deletes the
  tokens FCM reports as dead. The message carries no notification block,
  only `data.type = "wakeup"`: Android high priority; iOS
  `content-available` at priority 5 with the `background` push type.
- **Token registration** `registerPushToken({ token, platform })`
  (`functions/src/push/tokens.ts`): App Check enforced, no account. The
  document is the token itself with the platform, `registeredAt` (kept
  across re-registrations), `lastSeenAt` and a 60-day `expiresAt` for the
  Firestore TTL policy. Rules close the collection to clients.
- **Client registration** (`PushRegistrar`): on start the app reads its
  FCM token and registers it when it is new or the last registration is
  older than seven days (`AppThresholds.pushTokenRefresh`), so a live
  device never expires on the server. Token rotations re-register at
  once. A failed call stores nothing and retries on the next start.
- **Client handler** (`PushWakeup.run`): refresh the forecast for the
  current cell even when the cache is fresh, score the days ahead,
  re-plan the local notifications. The same code runs for a foreground
  message and, through `pushWakeupBackgroundHandler` (a separate isolate
  that builds its own container, flavor from the env file's
  `APP_FLAVOR`), for a message that arrives with the app closed.
- **Availability**: `AppFeatureFlags.pushWakeupAvailable`, Firebase
  configured, and a phone. Otherwise every provider is a no-op and the
  app relies on the daily background refresh and foreground opens.
- **Native**: `remote-notification` added to iOS `UIBackgroundModes`.
  Android needs nothing beyond the Firebase Messaging plugin.
- **Config**: `config.push` (schedule, token TTL, batch size, message
  type) and `collections.pushTokens` on the server;
  `AppEndpoints.registerPushTokenFunction`,
  `AppBackgroundTasks.pushWakeupType`, `AppThresholds.pushTokenRefresh`,
  `AppFeatureFlags.pushWakeupAvailable`, `AppEnv.flavorName` in the app.

## iOS background behaviour

iOS treats a `content-available` push as a hint, not a command. What to
expect, and what the device test in the manual checks records:

- Delivery is throttled by a per-app budget that iOS adjusts to how often
  the person opens the app and whether the handler finishes quickly. A few
  wake-ups a day is typical for an app opened daily; an app not opened for
  a week may receive none.
- No background push is delivered while the app is force-quit from the
  app switcher, in Low Power Mode, or when Background App Refresh is off
  for the app.
- The handler has about 30 seconds. `PushWakeup.run` does one function
  call and local work and returns well inside that.
- The daily WorkManager/BGTaskScheduler refresh (phase 11) and the refresh
  on every open remain the floor; the push only raises the ceiling.

The device test (manual checks below) fills in the observed delivery
count for the project's own notes; the function's schedule is tuned from
it (`config.push.schedule`).

## Tests

- `functions/test/push.test.ts`: request validation (shape, length,
  character set, platform); the stored document, TTL and preserved
  `registeredAt`; the silent message shape on both platforms; batching at
  500; a run that sends, removes dead tokens, keeps transient failures;
  an empty run.
- `functions/test/firestore.rules.test.ts`: `push_tokens` closed to
  anonymous and signed-in clients.
- `push_registration_test.dart`: register once then not while fresh;
  re-register on a new token and after the refresh window; no token
  sends nothing; a failed call stores nothing and retries; `start`
  registers, follows rotation, runs a foreground wake-up for the wake-up
  type only, and stops on dispose.
- `push_wakeup_test.dart`: a wake-up fetches even when the cache is
  fresh, stores risk and re-plans; no cell; a failing fetch.
- Full suite: 286 app tests, 29 function tests.

## Acceptance criteria

- [x] Function on a schedule.
- [ ] iOS throttled-background behaviour documented from a device test
      (expected behaviour written above; the observed count needs a real
      iPhone and the prod Firebase project, see manual checks).

## Manual checks

- Firebase console > Cloud Messaging > send a test message to the
  device's token with the data key `type=wakeup` and no notification
  text: the app's log shows the refresh and the re-plan.
- iPhone, built with the prod env, opened once a day for three days:
  note how many of the twelve scheduled wake-ups ran (Console.app, filter
  on the bundle id). Record the count in this file.
- Turn Background App Refresh off for the app: no wake-ups run.

## What M must fill in

- Firebase console > Project settings > Cloud Messaging: enable the
  Firebase Cloud Messaging API (v1) for staging and prod.
- Apple Developer: create an APNs authentication key (.p8) and upload it
  under Cloud Messaging > Apple app configuration for each iOS app.
- Xcode: add the Push Notifications capability to the Runner target and
  confirm Background Modes shows Remote notifications.
- Firestore: enable the TTL policy on `push_tokens.expiresAt` (console >
  Firestore > TTL) for staging and prod, once each.
- Deploy: `npm run deploy:staging` creates the Cloud Scheduler job; the
  first deploy may ask to enable the Cloud Scheduler API.
