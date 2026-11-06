import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';

import 'generated/schema.dart';

/// Migration test. Every schema version ever shipped is dumped into
/// `drift_schemas/` (`dart run drift_dev schema dump`) and regenerated into
/// `generated/` (`dart run drift_dev schema generate`). This test opens each
/// old version, runs the migration and checks the result matches the current
/// schema exactly.
void main() {
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('current schema matches the dump for version '
      '${AppDatabase.currentSchemaVersion}', () async {
    final connection = await verifier.startAt(AppDatabase.currentSchemaVersion);
    final db = AppDatabase(connection);
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);
    await db.close();
  });

  for (var from = 1; from < AppDatabase.currentSchemaVersion; from++) {
    test('migrates from version $from to the current schema', () async {
      final connection = await verifier.startAt(from);
      final db = AppDatabase(connection);
      await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);
      await db.close();
    });
  }
}
