# Phase 04: Firebase setup

Branch: `04-feat-firebase-setup`, cut from `03-feat-design-system`.
Requirement IDs: backend decision (Firebase on Blaze), observability and
privacy NFRs (opt-in crash reporting, budget alerts), groundwork for FR-21,
FR-23 and the weather cache.

## What was done

- **FlutterFire from the central config.** `AppFirebaseOptions` builds
  `FirebaseOptions` from `AppEnv` (filled by `env/<flavor>.json`), so each
  flavor talks to its own project and no `google-services.json` or
  `GoogleService-Info.plist` is committed. With empty values the app runs
  fully offline and `firebaseStatusProvider` reports `notConfigured`.
- `initializeFirebase()` in `bootstrap()`: Firebase core, App Check (debug
  providers in dev and staging, Play Integrity and App Attest in prod) and
  Crashlytics with collection **off** until the user opts in
  (`setCrashReportingEnabled`). No field values are ever logged.
- `firebase.json` with the emulator suite (auth, functions, firestore,
  storage, hosting, UI), `.firebaserc` aliases `dev`, `staging`, `prod`.
- `firestore.rules` and `storage.rules`, deny by default, one block per
  collection: `weather_cells` read-only, `users` owner-only with an
  allowed-key list on create and update, `share_snapshots` never direct,
  `audit_counts` create-only with integer counts and no dates or locations,
  backups under `backups/{uid}` owner-only, opaque content type, 50 MB cap.
- `functions/` TypeScript project (Node 22, strict `tsconfig`, ESLint with
  typescript-eslint strict and import ordering, Prettier, Jest with
  coverage threshold). `src/config.ts` is the server-side single
  configuration file (region, TTLs, cell size, collection names, secret
  names). `helloWorld` is a callable with App Check enforced, to prove the
  deploy pipeline; it is removed in release prep.
- Rules tests with `@firebase/rules-unit-testing` against the emulators
  (`npm run test:rules`), run in CI through `npx firebase-tools emulators:exec`
  with the emulator jars cached. The test caught and fixed a gap: `users`
  updates could add arbitrary fields.
- Hosting placeholder page for the share-link domain.
- CI `functions` job now runs lint, format check, typecheck, unit tests and
  the rules tests.

## Budget alerts (M to set, documented here)

Google Cloud console > Billing > Budgets and alerts, one budget per
project (`migraine-tracker-staging`, `migraine-tracker-prod`): amount $25,
thresholds at 40% ($10) and 100% ($25), email to the owner. Firestore
usage is also capped by the local-first design (compact weather payloads
under 5 KB, 3 h cache).

## Tests

- `test/core/firebase/firebase_bootstrap_test.dart`: no options without env
  values, `initializeFirebase` returns `notConfigured` without touching
  plugins, crash toggle is a no-op without Firebase.
- `functions/test/helloWorld.test.ts`: payload shape.
- `functions/test/firestore.rules.test.ts`, `storage.rules.test.ts`: deny by
  default and every collection's allow rules, positive and negative.

## Deviations from the plan

- No `flutterfire configure` output is committed; options come from the
  env files so the one-file configuration rule holds for Firebase too.
- `helloWorld` is a callable (`onCall`) rather than an HTTPS request
  function because App Check enforcement is built into callables.
- The rules tests run on the emulator in CI (not only locally), so the
  emulator jars are cached in the workflow.

## How to verify

```bash
flutter test test/core/firebase
cd functions && npm ci && npm run lint && npm run typecheck && npm test
cd functions && npm run test:rules      # needs Java 21 for the emulators
```

Deploy (after M creates the projects and fills `env/staging.json`):

```bash
cd functions && npm run build && npm run deploy:staging
```

## What M must fill in

Three Blaze projects, the env files, budget alerts as above, and the App
Check debug tokens for dev devices (Firebase console > App Check).
