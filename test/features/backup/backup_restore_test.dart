import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/backup/application/backup_service.dart';
import 'package:migraine_tracker/features/backup/data/pinned_http.dart';
import 'package:migraine_tracker/features/backup/domain/backup_envelope.dart';
import 'package:migraine_tracker/features/backup/domain/backup_store.dart';
import 'package:migraine_tracker/features/export/data/export_service.dart';
import 'package:migraine_tracker/features/medication/data/medication_repository_impl.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';

import '../../support/test_database.dart';
import 'support/backup_fakes.dart';

void main() {
  final now = DateTime.utc(2026, 11, 6, 9, 30);
  const passphrase = 'correct horse battery staple';
  const secretNote = 'only-on-this-phone-7f3a';
  late AppDatabase phoneA;
  late AppDatabase freshInstall;
  late MemoryBackupStore server;

  setUp(() {
    phoneA = newTestDatabase();
    freshInstall = newTestDatabase();
    server = MemoryBackupStore(now: () => now);
  });
  tearDown(() async {
    await phoneA.close();
    await freshInstall.close();
  });

  BackupService service(
    AppDatabase db, {
    BackupStore? store,
    bool signedIn = true,
    KeyDeriver derive = argon2idKey,
    int? schemaVersion,
  }) => BackupService(
    export: ExportService(db, clock: () => now),
    store: () async => signedIn ? store ?? server : null,
    clock: () => now,
    schemaVersion: schemaVersion ?? db.schemaVersion,
    params: testKdf,
    derive: derive,
  );

  Future<void> seed(AppDatabase db) async {
    await DriftAttackRepository(db, clock: () => now).save(
      AttackEntity(
        id: 'a1',
        startedAt: DateTime.utc(2026, 11, 1, 8),
        endedAt: DateTime.utc(2026, 11, 1, 14),
        intensity: 7,
        headLocations: {HeadLocation.values.first},
        notes: secretNote,
      ),
    );
    await DriftMedicationRepository(db, clock: () => now).save(
      MedicationEntity(
        id: 'm1',
        attackId: 'a1',
        name: 'Sumatriptan',
        takenAt: DateTime.utc(2026, 11, 1, 9),
        kind: MedicationKind.acute,
        reliefAt2h: Relief.partial,
      ),
    );
  }

  Future<Map<String, Object?>> everything(AppDatabase db) async =>
      (await ExportService(db, clock: () => now).export()).toJson()
        ..remove('exportedAt');

  group('restore on a fresh install', () {
    test('everything comes back exactly', () async {
      await seed(phoneA);
      final info = await service(phoneA).backUp(passphrase);
      expect(info.sizeBytes, server.bytes!.length);

      await service(freshInstall).restore(passphrase);
      expect(await everything(freshInstall), await everything(phoneA));
      expect(
        (await DriftAttackRepository(
          freshInstall,
          clock: () => now,
        ).all()).single.notes,
        secretNote,
      );
    });

    test('a second phone on the same account sees and opens the backup made '
        'by the first', () async {
      await seed(phoneA);
      await service(phoneA).backUp(passphrase);
      final seen = await service(freshInstall).info();
      expect(seen!.updatedAt, now);
      await service(freshInstall).restore(passphrase);
      expect(await everything(freshInstall), await everything(phoneA));
    });

    test('a wrong passphrase leaves the phone untouched', () async {
      await seed(phoneA);
      await service(phoneA).backUp(passphrase);
      await DriftAttackRepository(
        freshInstall,
        clock: () => now,
      ).save(AttackEntity(id: 'keep-me', startedAt: now));
      await expectLater(
        service(freshInstall).restore('Correct horse battery staple'),
        throwsBackup(BackupProblem.wrongPassphrase),
      );
      expect(
        (await DriftAttackRepository(
          freshInstall,
          clock: () => now,
        ).all()).map((a) => a.id),
        ['keep-me'],
      );
    });

    test('no backup yet, or signed out, is said plainly', () async {
      await expectLater(
        service(freshInstall).restore(passphrase),
        throwsBackup(BackupProblem.noBackup),
      );
      await expectLater(
        service(freshInstall, signedIn: false).backUp(passphrase),
        throwsBackup(BackupProblem.signedOut),
      );
    });

    test('a backup from a newer app version is refused before the '
        'passphrase is tried', () async {
      await seed(phoneA);
      await service(
        phoneA,
        schemaVersion: phoneA.schemaVersion + 1,
      ).backUp(passphrase);
      var derived = 0;
      await expectLater(
        service(
          freshInstall,
          derive: (p, s, k) {
            derived++;
            return argon2idKey(p, s, k);
          },
        ).restore(passphrase),
        throwsBackup(BackupProblem.newerApp),
      );
      expect(derived, 0);
    });

    test('server errors map to plain problems', () async {
      server.failWith = const BackupStoreException(BackupStoreFailure.pinning);
      await expectLater(
        service(phoneA).info(),
        throwsBackup(BackupProblem.pinning),
      );
      server.failWith = const BackupStoreException(
        BackupStoreFailure.notAllowed,
      );
      await expectLater(
        service(phoneA).backUp(passphrase),
        throwsBackup(BackupProblem.notAllowed),
      );
    });
  });

  group('what the server receives', () {
    test('holds no readable health data', () async {
      await seed(phoneA);
      await service(phoneA).backUp(passphrase);
      final stored = server.bytes!;
      final asText = latin1.decode(stored);
      expect(asText, isNot(contains(secretNote)));
      expect(asText, isNot(contains('Sumatriptan')));
      expect(asText, isNot(contains('attacks')));
      // Only the header is readable: costs, salt, nonce, schema and time.
      final header = BackupEnvelope.peek(stored).toJson();
      expect(header.keys, {'kdf', 'cipher', 'schema', 'createdAt'});
    });

    test('every backup uses a fresh salt and nonce', () async {
      await seed(phoneA);
      await service(phoneA).backUp(passphrase);
      final first = BackupEnvelope.peek(server.bytes!);
      await service(phoneA).backUp(passphrase);
      final second = BackupEnvelope.peek(server.bytes!);
      expect(second.salt, isNot(first.salt));
      expect(second.nonce, isNot(first.nonce));
    });
  });

  group('envelope', () {
    Future<Uint8List> sealed() => BackupEnvelope.seal(
      json: '{"hello":"world"}',
      passphrase: passphrase,
      schemaVersion: 1,
      createdAt: now,
      params: testKdf,
    );

    test('a changed byte anywhere fails authentication', () async {
      final bytes = await sealed();
      // One byte in the ciphertext, and one in the header's createdAt.
      final headerEnd = 9 + ByteData.sublistView(bytes, 5, 9).getUint32(0);
      for (final i in [bytes.length - 20, headerEnd - 5]) {
        final copy = Uint8List.fromList(bytes)..[i] ^= 0x01;
        await expectLater(
          BackupEnvelope.open(bytes: copy, passphrase: passphrase),
          throwsA(
            isA<BackupFormatException>().having(
              (e) => e.failure,
              'failure',
              anyOf(
                BackupFailure.wrongPassphraseOrDamaged,
                BackupFailure.damaged,
              ),
            ),
          ),
        );
      }
    });

    test('a crafted header asking for huge costs is refused without '
        'deriving a key', () async {
      final bytes = await sealed();
      final headerLength = ByteData.sublistView(bytes, 5, 9).getUint32(0);
      final header = (jsonDecode(
        utf8.decode(bytes.sublist(9, 9 + headerLength)),
      ) as Map).cast<String, Object?>();
      (header['kdf']! as Map)['m'] = 4 * 1024 * 1024;
      final evil = utf8.encode(jsonEncode(header));
      final forged =
          (BytesBuilder()
                ..add(BackupEnvelope.magic)
                ..addByte(1)
                ..add(
                  (ByteData(4)..setUint32(0, evil.length)).buffer.asUint8List(),
                )
                ..add(evil)
                ..add(bytes.sublist(9 + headerLength)))
              .toBytes();
      var derived = 0;
      await expectLater(
        BackupEnvelope.open(
          bytes: forged,
          passphrase: passphrase,
          derive: (p, s, k) async {
            derived++;
            return List.filled(32, 0);
          },
        ),
        throwsA(
          isA<BackupFormatException>().having(
            (e) => e.failure,
            'failure',
            BackupFailure.damaged,
          ),
        ),
      );
      expect(derived, 0);
    });

    test('other files and newer formats are recognised', () async {
      await expectLater(
        BackupEnvelope.open(
          bytes: Uint8List.fromList(utf8.encode('{"tables":{}}')),
          passphrase: passphrase,
        ),
        throwsA(
          isA<BackupFormatException>().having(
            (e) => e.failure,
            'failure',
            BackupFailure.notABackup,
          ),
        ),
      );
      final newer = Uint8List.fromList(await sealed())..[4] = 2;
      expect(
        () => BackupEnvelope.peek(newer),
        throwsA(
          isA<BackupFormatException>().having(
            (e) => e.failure,
            'failure',
            BackupFailure.newerFormat,
          ),
        ),
      );
    });

    test('the real Argon2id costs round-trip', () async {
      expect(KdfParams.standard.memoryKiB, 19456);
      expect(KdfParams.standard.iterations, 2);
      final bytes = await BackupEnvelope.seal(
        json: '{"ok":true}',
        passphrase: passphrase,
        schemaVersion: 1,
        createdAt: now,
      );
      expect(BackupEnvelope.peek(bytes).params.memoryKiB, 19456);
      expect(
        await BackupEnvelope.open(bytes: bytes, passphrase: passphrase),
        '{"ok":true}',
      );
    });
  });

  test('the pinned roots parse, and the client accepts them', () {
    final pem = File(AppAssets.backupTrustRoots).readAsStringSync();
    expect('BEGIN CERTIFICATE'.allMatches(pem).length, 4);
    final client = pinnedClient(pem);
    addTearDown(client.close);
  });
}

Matcher throwsBackup(BackupProblem problem) => throwsA(
  isA<BackupException>().having((e) => e.problem, 'problem', problem),
);
