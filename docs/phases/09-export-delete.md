# Phase 09: Export and delete

Branch: `09-feat-export-delete`, cut from `08-feat-cycle-tracking`.
Requirement IDs: FR-23 local part (JSON and CSV export of every table
through the share sheet; delete everything in one tap with confirmation),
settings screen skeleton. Privacy NFR: the user can take their data out
and wipe it without an account.

## What was done

- **Export service** (`ExportService`) walks `allTables`, so a table added
  in a later phase is exported without touching this code. Rows are raw
  column values: dates as ISO-8601 text (how the database stores them),
  JSON columns as JSON text. The envelope (`DataExport`) carries a format
  name, format version, schema version and timestamp.
- **JSON export** is one file; **import** replaces everything in one
  transaction and skips unknown tables and columns so an older export
  still loads. The import is used by the test suite to prove the round
  trip; a user-facing import arrives with backup (phase 33).
- **CSV export** writes one RFC 4180 file per non-empty table with a
  small writer (and a matching parser used only by tests). Files are named
  `<shortName>-export-<UTC stamp>-<table>.csv`.
- **Share sheet** via `share_plus`, behind `shareFilesProvider` so tests
  stub it. Files go to the temporary directory.
- **Delete everything.** Settings > Delete everything shows a dialog with
  the record count, then wipes every table in one transaction. The
  database encryption key is kept so the app keeps working; the row
  counts afterwards are all zero.
- **Settings screen skeleton** at `/settings` (gear on the home app bar):
  Daily (check-in reminder time, cycle toggle), Your data (export JSON,
  export CSV, delete everything), About (display name, wellness
  disclaimer, privacy policy, terms, support email from `AppIdentity`).
  Later phases add their sections here.
- First internal beta: the CI `android` and `ios` jobs already produce
  debug builds for every PR; the release workflow (phase 39) will sign
  and upload.

## Tests

- `test/features/export/export_service_test.dart`: every table covered;
  JSON round trip is byte-for-byte equal and restores foreign keys and
  settings; unknown tables and columns skipped; foreign JSON refused; CSV
  per non-empty table, quoting survives a parse; file naming.
- `test/features/export/csv_test.dart`: quoting rules, null versus empty.
- `test/features/settings/settings_flow_test.dart` (widget): JSON export
  shares one file, CSV export shares one file per non-empty table, delete
  asks first (cancel keeps data, confirm empties every table), reminder
  and cycle settings reachable.

## Deviations from the plan

- Import is a service method exercised by tests, not a settings entry;
  the user-facing restore is part of encrypted backup (phase 33).

## How to verify

```bash
flutter test test/features/export test/features/settings
```

Home > gear > Export as JSON opens the share sheet. Delete everything
shows the count and empties the app.

## What M must fill in

Nothing. The privacy policy and terms URLs come from `AppIdentity`.
