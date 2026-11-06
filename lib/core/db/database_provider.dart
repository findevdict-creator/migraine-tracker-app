import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_key_store.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' show Database;

/// The key store used to open the database. Overridden in tests.
final databaseKeyStoreProvider = Provider<DatabaseKeyStore>(
  (_) => SecureDatabaseKeyStore(),
);

/// The single [AppDatabase] instance for the app's lifetime.
///
/// Opens the SQLCipher-encrypted file in the application support directory
/// (never in a backed-up or user-visible location) on a background isolate.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final keyStore = ref.watch(databaseKeyStoreProvider);
  final db = AppDatabase(openEncryptedDatabase(keyStore));
  ref.onDispose(db.close);
  return db;
});

/// Builds the lazy executor for the encrypted on-device file.
QueryExecutor openEncryptedDatabase(
  DatabaseKeyStore keyStore, {
  Future<Directory> Function()? directory,
}) {
  return LazyDatabase(() async {
    final dir = await (directory ?? getApplicationSupportDirectory)();
    final file = File(p.join(dir.path, AppStorage.databaseFileName));
    final key = await keyStore.readOrCreate();
    return NativeDatabase.createInBackground(
      file,
      setup: (raw) => applyEncryptionKey(raw, key),
    );
  });
}

/// Applies the SQLCipher key and the pragmas every connection needs.
///
/// Exposed so tests can open a file database with the same setup.
void applyEncryptionKey(Database raw, String hexKey) {
  // Raw 256-bit key, so no KDF cost on open and no passphrase in memory.
  raw
    ..execute('PRAGMA key = "x\'$hexKey\'"')
    ..execute('PRAGMA cipher_memory_security = ON')
    // Fails fast on the wrong key instead of at the first query.
    ..execute('SELECT count(*) FROM sqlite_master');
}
