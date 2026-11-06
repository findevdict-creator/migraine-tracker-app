import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/settings.dart';

part 'settings_dao.g.dart';

/// Typed access to the key-value settings table. Values are JSON so any
/// JSON-encodable type round-trips.
@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.attachedDatabase);

  Future<T?> read<T>(String key) async {
    final row = await (select(
      settings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    if (row == null) return null;
    return jsonDecode(row.value) as T?;
  }

  Stream<T?> watch<T>(String key) =>
      (select(settings)..where((s) => s.key.equals(key)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : jsonDecode(row.value) as T?);

  Future<void> write(String key, Object? value) =>
      into(settings).insertOnConflictUpdate(
        SettingsCompanion.insert(
          key: key,
          value: jsonEncode(value),
          updatedAt: DateTime.now().toUtc(),
        ),
      );

  Future<int> remove(String key) =>
      (delete(settings)..where((s) => s.key.equals(key))).go();

  Future<Map<String, Object?>> all() async {
    final rows = await select(settings).get();
    return {for (final r in rows) r.key: jsonDecode(r.value)};
  }
}
