import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// Where the SQLCipher key lives. The key never leaves the platform keystore
/// (Android Keystore, iOS Keychain) except to open the database.
abstract interface class DatabaseKeyStore {
  /// Returns the existing key or creates and stores a new one.
  Future<String> readOrCreate();

  /// Removes the key. The database file becomes unreadable.
  Future<void> delete();
}

/// Generates a 256-bit key as 64 hex characters, for `PRAGMA key = "x'..'"`.
String generateDatabaseKey([Random? random]) {
  final rng = random ?? Random.secure();
  final buffer = StringBuffer();
  for (var i = 0; i < 32; i++) {
    buffer.write(rng.nextInt(256).toRadixString(16).padLeft(2, '0'));
  }
  return buffer.toString();
}

/// Production key store backed by the platform keystore.
class SecureDatabaseKeyStore implements DatabaseKeyStore {
  SecureDatabaseKeyStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<String> readOrCreate() async {
    final existing = await _storage.read(key: AppStorage.databaseKeyName);
    if (existing != null && existing.length == 64) return existing;
    final key = generateDatabaseKey();
    await _storage.write(key: AppStorage.databaseKeyName, value: key);
    return key;
  }

  @override
  Future<void> delete() => _storage.delete(key: AppStorage.databaseKeyName);
}

/// Key store for tests and the dev flavor's in-memory database.
class InMemoryDatabaseKeyStore implements DatabaseKeyStore {
  InMemoryDatabaseKeyStore([this._key]);

  String? _key;

  @override
  Future<String> readOrCreate() async => _key ??= generateDatabaseKey();

  @override
  Future<void> delete() async => _key = null;
}
