# Phase 02: Local database

Branch: `02-feat-local-database`, cut from `01-feat-project-scaffold`.
Requirement IDs: data model and security NFR from the requirements doc;
FR-23 (delete everything) groundwork.

## What was done

- Drift schema for the 12 tables of the data model, one file each under
  `lib/core/db/tables/`: attacks, checkins, medication_events,
  weather_hours, environment_days, health_samples, factor_weights,
  risk_days, experiments, questionnaires, share_links, settings.
  JSON text columns with converters for list and map fields; dates as
  ISO-8601 text; foreign keys on.
- `AppDatabase` (`lib/core/db/app_database.dart`) with the migration
  strategy, `deleteEverything()` in one transaction and `rowCounts()`.
- One DAO per table group under `lib/core/db/daos/` with the queries the
  next phases need (running attack, ranges, upserts, pinning weather hours,
  pruning, duplicate-safe health imports, one active experiment, latest
  questionnaire, JSON settings).
- SQLCipher at rest (ADR 0003): `package:sqlite3` built with the
  `sqlcipher` source through hooks, raw 256-bit key generated on first open
  and kept in the platform keystore (`DatabaseKeyStore`,
  `SecureDatabaseKeyStore`, `InMemoryDatabaseKeyStore`).
- `appDatabaseProvider` opens the file in the application support
  directory on a background isolate; `databaseKeyStoreProvider` is the
  test seam.
- Schema dump `drift_schemas/drift_schema_v1.json` and generated verifier
  under `test/core/db/generated/`, with a migration test that will run every
  old version forward once version 2 exists.
- Central config gained `AppStorage` (database file name, keystore entry).

## Tests

- `test/core/db/app_database_test.dart`: 12 tables exist, dates stored as
  ISO text, foreign keys enforced, delete everything.
- `test/core/db/daos_test.dart`: one group per DAO, including JSON
  round-trips with per-tap timestamps, half-open and inclusive ranges,
  attack deletion unlinking medication, pinned weather surviving prune,
  duplicate health samples ignored, single active experiment.
- `test/core/db/encryption_test.dart`: key format and persistence, the file
  on disk has no SQLite header and cannot be opened without the key, reopen
  with the same key works, wrong key fails.
- `test/core/db/migration_test.dart`: current schema matches the dump.

## Deviations from the plan

- `sqlcipher_flutter_libs` and `sqlite3_flutter_libs` are end-of-life; the
  SQLCipher build now comes from `package:sqlite3` hooks (one line in
  `pubspec.yaml`).
- Repository interfaces (domain-level) are introduced per feature from
  phase 05 on top of these DAOs, so each feature owns its own mapping.

## How to verify

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/core/db
```

To change the schema: edit the table, bump `AppDatabase.currentSchemaVersion`,
add the step in `migration.onUpgrade`, run
`dart run drift_dev schema dump lib/core/db/app_database.dart drift_schemas/`
and `dart run drift_dev schema generate --data-classes --companions
drift_schemas/ test/core/db/generated/`, then run the migration test.
