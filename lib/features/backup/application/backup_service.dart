import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/account/data/firebase_auth_gateway.dart';
import 'package:migraine_tracker/features/account/presentation/account_controller.dart';
import 'package:migraine_tracker/features/backup/data/pinned_http.dart';
import 'package:migraine_tracker/features/backup/data/storage_rest_backup_store.dart';
import 'package:migraine_tracker/features/backup/domain/backup_envelope.dart';
import 'package:migraine_tracker/features/backup/domain/backup_store.dart';
import 'package:migraine_tracker/features/export/data/export_service.dart';

/// The signed-in account's backup location, or null when signed out.
final backupStoreProvider = FutureProvider<BackupStore?>((ref) async {
  final user = ref.watch(accountProvider).value;
  if (user == null) return null;
  final gateway = ref.watch(authGatewayProvider);
  final flavor = ref.watch(appConfigProvider).flavor;
  final emulator = AppFeatureFlags.useEmulators(flavor);
  final client = emulator
      ? http.Client()
      : pinnedClient(await rootBundle.loadString(AppAssets.backupTrustRoots));
  ref.onDispose(client.close);
  return StorageRestBackupStore(
    client: client,
    base: emulator
        ? Uri(
            scheme: 'http',
            host: AppEnv.emulatorHost,
            port: AppBackup.emulatorStoragePort,
          )
        : Uri(scheme: 'https', host: AppBackup.storageHost),
    bucket: AppEnv.firebaseStorageBucket,
    uid: user.uid,
    idToken: gateway.idToken,
    appCheckToken: _appCheckToken,
  );
});

Future<String?> _appCheckToken() async {
  try {
    return await FirebaseAppCheck.instance.getToken();
  } on Object {
    return null;
  }
}

/// Argon2id on a background isolate, so the screen keeps animating.
Future<List<int>> backgroundArgon2id(
  String passphrase,
  List<int> salt,
  KdfParams params,
) => Isolate.run(() => argon2idKey(passphrase, salt, params));

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    export: ref.watch(exportServiceProvider),
    store: () => ref.read(backupStoreProvider.future),
    clock: ref.watch(clockProvider),
    schemaVersion: ref.watch(appDatabaseProvider).schemaVersion,
  ),
);

enum BackupProblem {
  signedOut,
  noBackup,
  tooLarge,
  newerApp,
  wrongPassphrase,
  damaged,
  network,
  pinning,
  notAllowed,
  unknown,
}

class BackupException implements Exception {
  const BackupException(this.problem);

  final BackupProblem problem;

  @override
  String toString() => 'BackupException($problem)';
}

/// Backs up and restores the whole database, encrypted on the phone.
class BackupService {
  BackupService({
    required this.export,
    required this.store,
    required this.clock,
    required this.schemaVersion,
    this.params = KdfParams.standard,
    this.derive = backgroundArgon2id,
  });

  final ExportService export;
  final Future<BackupStore?> Function() store;
  final DateTime Function() clock;
  final int schemaVersion;
  final KdfParams params;
  final KeyDeriver derive;

  Future<BackupInfo?> info() =>
      _guard(() async => await (await _store()).info());

  /// Encrypts everything with [passphrase] and replaces the stored backup.
  Future<BackupInfo> backUp(String passphrase) => _guard(() async {
    final target = await _store();
    final data = await export.export();
    final bytes = await BackupEnvelope.seal(
      json: jsonEncode(data.toJson()),
      passphrase: passphrase,
      schemaVersion: schemaVersion,
      createdAt: clock(),
      params: params,
      derive: derive,
    );
    if (bytes.length > AppBackup.maxBytes) {
      throw const BackupException(BackupProblem.tooLarge);
    }
    await target.upload(bytes);
    return BackupInfo(updatedAt: clock(), sizeBytes: bytes.length);
  });

  /// Replaces everything on this phone with the stored backup. Nothing is
  /// touched until the backup has opened and parsed.
  Future<void> restore(String passphrase) => _guard(() async {
    final bytes = await (await _store()).download();
    if (bytes == null) throw const BackupException(BackupProblem.noBackup);
    if (BackupEnvelope.peek(bytes).schemaVersion > schemaVersion) {
      throw const BackupException(BackupProblem.newerApp);
    }
    final json = await BackupEnvelope.open(
      bytes: bytes,
      passphrase: passphrase,
      derive: derive,
    );
    await export.import(export.fromJsonString(json));
  });

  Future<void> deleteBackup() =>
      _guard(() async => await (await _store()).delete());

  Future<BackupStore> _store() async {
    final s = await store();
    if (s == null) throw const BackupException(BackupProblem.signedOut);
    return s;
  }

  static Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on BackupFormatException catch (e) {
      throw BackupException(switch (e.failure) {
        BackupFailure.wrongPassphraseOrDamaged => BackupProblem.wrongPassphrase,
        BackupFailure.newerFormat => BackupProblem.newerApp,
        BackupFailure.notABackup ||
        BackupFailure.damaged => BackupProblem.damaged,
      });
    } on BackupStoreException catch (e) {
      throw BackupException(switch (e.failure) {
        BackupStoreFailure.network => BackupProblem.network,
        BackupStoreFailure.pinning => BackupProblem.pinning,
        BackupStoreFailure.notAllowed => BackupProblem.notAllowed,
        BackupStoreFailure.unknown => BackupProblem.unknown,
      });
    }
  }
}
