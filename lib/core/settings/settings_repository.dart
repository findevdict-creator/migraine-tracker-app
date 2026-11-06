import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(appDatabaseProvider)),
);

/// Typed access to the settings table for features.
class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Future<T?> read<T>(String key) => _db.settingsDao.read<T>(key);

  Stream<T?> watch<T>(String key) => _db.settingsDao.watch<T>(key);

  Future<void> write(String key, Object? value) =>
      _db.settingsDao.write(key, value);

  Future<void> remove(String key) => _db.settingsDao.remove(key);
}
