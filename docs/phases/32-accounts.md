# Phase 32: Optional accounts

Branch: `32-feat-accounts`, cut from `31-feat-duration-estimate`.
Requirement IDs: FR-23 (account part). Backup follows in phase 33.

## What was done

### In the app

- **Account screen** at `/account`, opened from settings. It sits behind
  `AppFeatureFlags.accountsAvailable`.
- **Signed out is a complete state.** The screen opens with "An account
  is optional. Everything in the app works without one, and your
  entries stay on this phone." No other screen asks for an account.
- **Three ways to sign in**, each switchable in `AppAccounts`:
  - Continue with Apple, shown on iOS and macOS only.
  - Continue with Google.
  - Email and password, with sign in, create account and "Forgot
    password?".
- **The form is checked on the phone first.** A malformed email or a
  password shorter than `AppAccounts.minPasswordLength` is explained
  before anything is sent.
- **Errors in plain words**: wrong password, email already used, no
  connection, and "sign in again" when Firebase asks for a recent
  sign-in. A cancelled Apple or Google sheet shows nothing.
- **Signed in** shows "Signed in as me@example.com", or "Signed in with
  Apple" when Apple hides the email. A note says the entries still live
  on the phone and signing out deletes nothing.
- **Delete account**:
  - A dialog explains that the account goes, that the backup and any
    share links leave the servers within 24 hours, and that everything
    on the phone stays.
  - It confirms identity: email accounts type their password, Google
    and Apple ask again through their own sheet.
  - For Apple, the app revokes its Apple token before deleting, as
    Apple requires.
  - The 24 comes from `AppAccounts.purgeWithinHours`.
- **No Firebase project, no account.** Without Firebase values the app
  uses a stand-in that stays signed out. The screen then says accounts
  are not set up in this build and offers nothing to tap. Every test in
  the suite runs this way, which shows that the whole app works signed
  out.

### On the server (`functions/src/account/`)

- **`accountCreated`**, an Auth trigger, creates `users/{uid}` with
  `createdAt` on sign-up. The app writes nothing to Firestore for this.
- **`accountDeleted`**, an Auth trigger, purges at once:
  - the `users/{uid}` document,
  - every file under `backups/{uid}/` in Cloud Storage,
  - share snapshots and audit counts whose `uid` field is the account.

  It first writes a tombstone to `account_deletions/{uid}` and clears it
  only when the purge has finished.
- **`accountPurgeSweep`**, scheduled every hour, finishes any purge that
  still has a tombstone. A tombstone older than 24 hours, or a purge
  that fails again, logs "account purge behind schedule" for alerting.
- **Guard rails**:
  - The purge refuses an account id with characters that could widen
    the storage prefix, such as `../bob`.
  - A look-alike folder such as `backups/alice2/` is not touched when
    `alice` is deleted.
- **Rules**: `account_deletions` is closed to every client, so a
  client can neither hide nor fake a deletion. `users/{uid}` was
  already owner-only.

## Configuration

| Where | Setting | Value |
| --- | --- | --- |
| `lib/config/app_config.dart` | `AppAccounts.appleEnabled`, `googleEnabled`, `emailEnabled` | true |
| | `AppAccounts.minPasswordLength` | 8 |
| | `AppAccounts.purgeWithinHours` | 24 |
| | `AppFeatureFlags.accountsAvailable` | true |
| | `AppEnv.googleServerClientId`, `googleIosClientId` | from `env/*.json` |
| `functions/src/config.ts` | `purgeWithinMs` | 24 h, must match `purgeWithinHours` |
| | `account.sweepSchedule`, `sweepEveryMs` | every hour |
| | `collections.accountDeletions` | `account_deletions` |

## Tests

- `test/features/account/account_screen_test.dart`:
  - Without Firebase the screen says accounts are optional and not set
    up, with nothing to tap.
  - Creating an email account checks the email and password on the
    phone first, then shows "Signed in as".
  - A wrong password is explained, and a reset link can be asked for.
  - Cancelling Google says nothing.
  - Apple is offered on iOS and not on Android.
  - Sign out returns to the signed-out screen.
  - Deleting an email account asks for the password, explains the
    24-hour purge, and "Keep account" changes nothing.
  - A Google account is deleted without a password.
  - Firebase error codes map to the right messages, plus the form
    checks and the stand-in gateway.
- `functions/test/account.test.ts`:
  - Sign-up creates the users document.
  - Deletion removes the metadata, backup, share snapshots and audit
    counts, and leaves another account and a look-alike folder alone.
  - The purge is safe to run twice and refuses odd ids.
  - **Deletion purges within 24 hours**: the sweep runs at least four
    times inside the deadline, and its schedule string matches its
    interval. A purge that fails at deletion time is finished by a
    later sweep well before 24 hours. A tombstone past the deadline is
    flagged for alerting.
- `functions/test/firestore.rules.test.ts`: deletion records are closed
  to clients, even the owner. This runs on the emulator in CI.
- Full app suite: 417 tests. Functions: 36 tests.

## Acceptance criteria

- [x] Optional Firebase Auth with Apple, Google and email.
- [x] `users` collection document created on sign-up.
- [x] Account deletion triggers a purge function.
- [x] App fully usable signed out.
- [x] Sign-in screen.
- [x] Test that deletion purges within 24 hours.
- [ ] Sign-in methods turned on in the Firebase console (M, see below).

## Manual checks

These need a Firebase project with the sign-in methods turned on.

1. Open settings, then Account. Create an email account. The screen
   shows "Signed in as". The Firebase console shows the user and a
   `users/{uid}` document.
2. Sign out, then sign in with Google, and on an iPhone with Apple.
3. Delete the account. The dialog mentions 24 hours. The user and the
   `users` document are gone from the console, and the app's entries
   are still there.
4. Without Firebase values (the dev env file as committed), the Account
   screen says accounts are not set up and nothing else changes.

## Risk and rollback

- The app gains `firebase_auth` and `google_sign_in`, an Apple
  entitlement, and one screen. Nothing else reads the account, so
  turning `accountsAvailable` off hides it completely.
- The functions gain three triggers. Reverting removes them. A
  tombstone left behind is harmless.
- **Signed builds need the "Sign in with Apple" capability** on the
  App ID, because the entitlement is now in `Runner.entitlements`. CI
  builds unsigned, so it is not affected.

## What M must fill in

Item 12 in `docs/CONFIGURATION.md`:

- Turn on Apple, Google and Email/Password in Firebase Authentication.
- Copy the Google client ids into the env files.
- Add the Android SHA fingerprints, and the reversed iOS client id as an
  iOS URL type.
- Turn on Sign in with Apple for the App ID.
- Create an alert on "account purge behind schedule".
