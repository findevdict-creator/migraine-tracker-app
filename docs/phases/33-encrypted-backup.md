# Phase 33: End-to-end encrypted backup

Branch: `33-feat-encrypted-backup`, cut from `32-feat-accounts`.
Requirement IDs: FR-23 (backup part).

## What was done

- **Backup screen** at `/backup`, opened from settings. It sits behind
  `AppFeatureFlags.backupAvailable`.
  - Signed out, it says backup needs an account and everything else
    works without one, with a button to the account screen.
  - Signed in, it shows "Last backup: 6 Nov 2026, 9:30 AM" or "No
    backup yet", a passphrase field, a repeat field, and buttons to
    back up, restore and delete the backup.
  - A card warns that a forgotten passphrase means nobody can open the
    backup, not even us.
- **Encrypted on the phone** (`BackupEnvelope`):
  - The key comes from the passphrase through Argon2id, with a random
    16-byte salt. The costs are the OWASP minimum: 19 MiB, 2 passes, 1
    lane. They are written into each file, so raising them later still
    opens old backups.
  - The gzipped JSON export is encrypted with AES-256-GCM and a random
    nonce.
  - The header, which holds the costs, salt, nonce, schema version and
    time, is authenticated as associated data. Changing any byte fails.
  - Opening a file refuses costs above `AppBackup.argonMaxMemoryKiB` and
    `argonMaxIterations` before deriving anything, so a crafted file
    cannot exhaust memory.
  - Key derivation runs on a background isolate.
- **Upload with certificate pinning**:
  - The app talks to Cloud Storage over its REST API with its own HTTP
    client. That client trusts only the four Google roots in
    `assets/certs/google_trust_roots.pem`, not the phone's store.
  - A proxy certificate or a certificate from any other authority fails
    the handshake. The screen then says the connection could not be
    verified, and nothing is sent.
  - The Firebase ID token proves the account, and the App Check token is
    added when available.
  - The dev flavor talks to the Storage emulator over plain HTTP.
- **One object per account**, `backups/{uid}/latest.bin`. Each backup
  replaces the last. `storage.rules` already allowed only the owner,
  only this content type, and only files under 50 MB.
- **Restore on a fresh install or another phone.** Sign in with the
  same account, type the passphrase, confirm, and the phone's data is
  replaced.
  - Nothing is touched until the file has decrypted and parsed.
  - The import runs in one transaction.
  - A file from a newer app version is refused before the passphrase is
    tried.
- **Plain messages** for a wrong passphrase, a damaged file, a newer
  app, no connection, a failed pinning check and an expired sign-in.
- **Account deletion** removes the backup within 24 hours, through
  phase 32's purge.

## Configuration

All in `lib/config/app_config.dart`:

| Setting | Value |
| --- | --- |
| `AppBackup.argonMemoryKiB`, `argonIterations`, `argonParallelism` | 19456, 2, 1 |
| `AppBackup.argonMaxMemoryKiB`, `argonMaxIterations` | 256 MiB, 10 |
| `AppBackup.saltBytes` | 16 |
| `AppBackup.minPassphraseLength` | 12 |
| `AppBackup.folder`, `objectName` | `backups`, `latest.bin` |
| `AppBackup.maxBytes` | 50 MB, mirrors `storage.rules` |
| `AppBackup.storageHost`, `emulatorStoragePort`, `requestTimeout` | `firebasestorage.googleapis.com`, 9199, 60 s |
| `AppAssets.backupTrustRoots` | `assets/certs/google_trust_roots.pem` |
| `AppFeatureFlags.backupAvailable` | true |

The storage bucket comes from `FIREBASE_STORAGE_BUCKET` in the env files.

## Tests

- `test/features/backup/backup_restore_test.dart`, the **restore from a
  fresh install** test:
  - Phone A logs an attack with a private note and a dose, then backs
    up. A new, empty database restores. Every table matches exactly.
  - A second phone sees the first phone's backup time and opens it.
  - A wrong passphrase leaves the phone's entries as they were.
  - No backup yet, and signed out, give plain errors.
  - A newer file is refused without deriving a key.
  - Server failures map to plain problems.
  - The stored bytes contain neither the note, the medication name nor
    table names. Only the header is readable.
  - Every backup has a fresh salt and nonce.
  - One changed byte in the header or ciphertext fails.
  - A crafted header asking for 4 GiB is refused without deriving.
  - Other files and newer formats are recognised.
  - The real Argon2id costs round-trip.
  - The pinned roots parse.
- `test/features/backup/backup_screen_test.dart`:
  - Signed out, it explains and links to the account screen.
  - Backing up checks the length and the repeat, then stores the file.
  - Restore asks first, refuses a wrong passphrase without changes, then
    replaces the data.
  - Delete asks first, then removes the file.
- `test/network/backup_pinning_live_test.dart`, **run by CI only**:
  - The pinned client completes a handshake with the real Cloud Storage
    host.
  - It fails the handshake with example.com, which uses another
    authority.

  It is tagged `network` and skipped in normal runs. The container's
  proxy re-signs TLS, so it cannot pass there, which is the point of
  pinning.
- Full suite: 434 tests.

## Penetration checklist

`docs/security/backup-pentest-checklist.md` lists 19 checks for this
path, how to run each and which test covers it, plus the known limits.
It is marked "not run".

## Acceptance criteria

- [x] Argon2id passphrase-derived key.
- [x] Encrypted snapshot to Cloud Storage.
- [x] Restore on a fresh install.
- [x] Multi-device: a second phone on the same account restores.
- [x] Certificate pinning.
- [x] Restore-from-fresh-install test in CI.
- [x] Penetration checklist for the backup path.
- [ ] Penetration checklist run (M or a tester).

## Manual checks

These need a Firebase project with Storage and a signed-in account.

1. Open settings, then Encrypted backup. Type a passphrase twice and
   tap Back up now. The status shows the time.
2. In the Firebase console, download `backups/{uid}/latest.bin`. It is
   not readable.
3. On a second phone, or after reinstalling, sign in with the same
   account. Open the backup screen, type the passphrase, tap Restore,
   and confirm. The entries appear.
4. With mitmproxy and a user CA installed, back up again. The screen
   says the connection could not be verified.

## Risk and rollback

- New dependency: `cryptography`, pure Dart. No Firebase Storage plugin
  is added, because the REST client is what makes pinning possible.
- **The pinned roots expire in 2036**, and Google could move to a new
  root before then. The live CI test fails if the host stops chaining
  to the bundled roots. Refresh the file then.
- Reverting removes the screen. Stored backups stay until the account
  is deleted.

## What M must fill in

- Set `FIREBASE_STORAGE_BUCKET` in the staging and prod env files.
- Run the penetration checklist before the first public release.
