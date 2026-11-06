import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/account/data/firebase_auth_gateway.dart';
import 'package:migraine_tracker/features/account/domain/account.dart';
import 'package:migraine_tracker/features/account/presentation/account_screen.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/backup/application/backup_service.dart';
import 'package:migraine_tracker/features/backup/domain/backup_envelope.dart';
import 'package:migraine_tracker/features/backup/presentation/backup_screen.dart';
import 'package:migraine_tracker/features/export/data/export_service.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../account/account_screen_test.dart' show FakeAuthGateway;
import '../weather/support/weather_fakes.dart';
import 'support/backup_fakes.dart';

void main() {
  late AppDatabase db;
  late MemoryBackupStore server;
  final now = DateTime(2026, 11, 6, 9, 30);
  const passphrase = 'violet kettle harbour';

  setUp(() {
    db = newTestDatabase();
    server = MemoryBackupStore(now: () => now);
  });
  tearDown(() => db.close());

  bool shown(String key) => find.byKey(ValueKey(key)).evaluate().isNotEmpty;

  /// The status line under the buttons; scrolled to, since the list is lazy.
  Future<String> message(WidgetTester tester) async {
    await tester.scrollToKey('backup-message');
    return tester
            .widget<Text>(find.byKey(const ValueKey('backup-message')))
            .data ??
        '';
  }

  Future<void> open(WidgetTester tester, {bool signedIn = true}) async {
    final gateway = FakeAuthGateway(
      current: signedIn
          ? const AccountUser(
              uid: 'u1',
              email: 'me@example.com',
              method: SignInMethod.email,
            )
          : null,
    );
    await tester.pumpApp(
      database: db,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        authGatewayProvider.overrideWithValue(gateway),
        backupServiceProvider.overrideWithValue(
          BackupService(
            export: ExportService(db, clock: () => now),
            store: () async => signedIn ? server : null,
            clock: () => now,
            schemaVersion: db.schemaVersion,
            params: testKdf,
            derive: argon2idKey,
          ),
        ),
        locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
        weatherSourceProvider.overrideWithValue(
          FakeWeatherSource(null)..error = Exception('offline'),
        ),
      ],
    );
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('settings-backup');
    await tester.tap(find.byKey(const ValueKey('settings-backup')));
    await tester.pumpAndSettle();
    expect(find.byType(BackupScreen), findsOneWidget);
  }

  Future<void> type(WidgetTester tester, String key, String text) async {
    await tester.scrollToKey(key);
    await tester.enterText(find.byKey(ValueKey(key)), text);
  }

  /// Taps and lets the real async work (key derivation, database) finish.
  Future<void> tapAndWork(WidgetTester tester, String key) async {
    await tester.scrollToKey(key);
    await tester.tap(find.byKey(ValueKey(key)));
    for (var i = 0; i < 50; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 20));
      if (shown('backup-message') && !shown('backup-busy')) break;
    }
    await tester.pumpAndSettle();
  }

  testWidgets('signed out, it explains that backup needs an account and '
      'links there', (tester) async {
    await open(tester, signedIn: false);
    expect(shown('backup-needs-account'), isTrue);
    expect(shown('backup-now'), isFalse);
    await tester.tap(find.byKey(const ValueKey('backup-open-account')));
    await tester.pumpAndSettle();
    expect(find.byType(AccountScreen), findsOneWidget);
  });

  testWidgets('back up: the passphrase is checked, then the locked file is '
      'stored', (tester) async {
    await DriftAttackRepository(
      db,
      clock: () => now,
    ).save(AttackEntity(id: 'a1', startedAt: now, notes: 'private words'));
    await open(tester);
    expect(find.text('No backup yet'), findsOneWidget);
    expect(find.textContaining('nobody can open the backup'), findsOneWidget);

    await type(tester, 'backup-passphrase', 'too short');
    await tapAndWork(tester, 'backup-now');
    expect(await message(tester), 'Use at least 12 characters.');

    await type(tester, 'backup-passphrase', passphrase);
    await type(tester, 'backup-passphrase-repeat', 'violet kettle harbor');
    await tapAndWork(tester, 'backup-now');
    expect(await message(tester), "The two passphrases don't match.");
    expect(server.bytes, isNull);

    await type(tester, 'backup-passphrase-repeat', passphrase);
    await tapAndWork(tester, 'backup-now');
    expect(await message(tester), 'Backed up.');
    expect(server.bytes, isNotNull);
    expect(find.textContaining('Last backup:'), findsOneWidget);
  });

  testWidgets('restore replaces the phone data after a confirmation; a '
      'wrong passphrase changes nothing', (tester) async {
    // Another phone made the backup.
    final other = newTestDatabase();
    addTearDown(other.close);
    await DriftAttackRepository(
      other,
      clock: () => now,
    ).save(AttackEntity(id: 'from-backup', startedAt: now));
    await tester.runAsync(
      () => BackupService(
        export: ExportService(other, clock: () => now),
        store: () async => server,
        clock: () => now,
        schemaVersion: other.schemaVersion,
        params: testKdf,
      ).backUp(passphrase),
    );
    await DriftAttackRepository(
      db,
      clock: () => now,
    ).save(AttackEntity(id: 'on-this-phone', startedAt: now));

    await open(tester);
    expect(find.textContaining('Last backup:'), findsOneWidget);

    await type(tester, 'backup-passphrase', 'not the passphrase');
    await tester.scrollToKey('backup-restore');
    await tester.tap(find.byKey(const ValueKey('backup-restore')));
    await tester.pumpAndSettle();
    expect(find.text('Replace everything on this phone?'), findsOneWidget);
    await tapAndWork(tester, 'backup-restore-confirm');
    expect(await message(tester), "That passphrase doesn't open this backup.");

    Future<List<String>> ids() async => (await tester.runAsync(
      () => DriftAttackRepository(db, clock: () => now).all(),
    ))!.map((a) => a.id).toList();
    expect(await ids(), ['on-this-phone']);

    await type(tester, 'backup-passphrase', passphrase);
    await tester.scrollToKey('backup-restore');
    await tester.tap(find.byKey(const ValueKey('backup-restore')));
    await tester.pumpAndSettle();
    await tapAndWork(tester, 'backup-restore-confirm');
    expect(await message(tester), 'Restored from your backup.');
    expect(await ids(), ['from-backup']);
  });

  testWidgets('delete removes the stored file after a confirmation', (
    tester,
  ) async {
    await tester.runAsync(
      () => BackupService(
        export: ExportService(db, clock: () => now),
        store: () async => server,
        clock: () => now,
        schemaVersion: db.schemaVersion,
        params: testKdf,
      ).backUp(passphrase),
    );
    await open(tester);
    await tester.scrollToKey('backup-delete');
    await tester.tap(find.byKey(const ValueKey('backup-delete')));
    await tester.pumpAndSettle();
    await tapAndWork(tester, 'backup-delete-confirm');
    expect(await message(tester), 'Backup deleted.');
    expect(server.bytes, isNull);
    expect(find.text('No backup yet'), findsOneWidget);
  });
}
