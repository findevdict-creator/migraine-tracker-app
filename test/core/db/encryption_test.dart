import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_key_store.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('mt_db'));
  tearDown(() => dir.deleteSync(recursive: true));

  group('SQLCipher', () {
    test('key store generates a 256-bit hex key once', () async {
      final store = InMemoryDatabaseKeyStore();
      final key = await store.readOrCreate();
      expect(key, hasLength(64));
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(key), isTrue);
      expect(await store.readOrCreate(), key);
      await store.delete();
      expect(await store.readOrCreate(), isNot(key));
    });

    test('database file is unreadable without the key', () async {
      final store = InMemoryDatabaseKeyStore();
      final db = AppDatabase(
        openEncryptedDatabase(store, directory: () async => dir),
      );
      await db.settingsDao.write('units', 'hPa');
      await db.close();

      final file = File('${dir.path}/migraine_tracker.db');
      expect(file.existsSync(), isTrue);
      final header = file.openSync().readSync(16);
      // A plain SQLite file starts with "SQLite format 3"; an encrypted one
      // does not.
      expect(String.fromCharCodes(header), isNot(startsWith('SQLite format')));

      expect(
        () => sqlite3.open(file.path).select('SELECT count(*) FROM settings'),
        throwsA(isA<SqliteException>()),
      );
    });

    test('database reopens with the same key', () async {
      final store = InMemoryDatabaseKeyStore();
      final first = AppDatabase(
        openEncryptedDatabase(store, directory: () async => dir),
      );
      await first.settingsDao.write('units', 'hPa');
      await first.close();

      final second = AppDatabase(
        openEncryptedDatabase(store, directory: () async => dir),
      );
      expect(await second.settingsDao.read<String>('units'), 'hPa');
      await second.close();

      final wrongKey = AppDatabase(
        NativeDatabase(
          File('${dir.path}/migraine_tracker.db'),
          setup: (raw) => applyEncryptionKey(raw, generateDatabaseKey()),
        ),
      );
      expect(
        () => wrongKey.settingsDao.read<String>('units'),
        throwsA(isA<Exception>()),
      );
      await wrongKey.close();
    });
  });
}
