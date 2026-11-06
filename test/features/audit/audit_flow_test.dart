import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/audit/application/self_audit_controller.dart';
import 'package:migraine_tracker/features/audit/data/functions_audit_gateway.dart';
import 'package:migraine_tracker/features/audit/domain/audit_upload.dart';
import 'package:migraine_tracker/features/audit/presentation/audit_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';

class FakeAuditGateway implements AuditGateway {
  final sent = <Map<String, Object>>[];
  Exception? error;

  @override
  bool get available => true;

  @override
  Future<void> send(Map<String, Object> payload) async {
    if (error != null) throw error!;
    sent.add(payload);
  }
}

void main() {
  late AppDatabase db;
  late FakeAuditGateway gateway;
  var now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    gateway = FakeAuditGateway();
    now = DateTime(2026, 11, 6, 9, 30);
  });
  tearDown(() => db.close());

  Future<void> attack(String id, String date) => db.attackDao.upsert(
    AttacksCompanion.insert(
      id: id,
      startedAt: DateTime.parse('${date}T08:00:00'),
      endedAt: Value(DateTime.parse('${date}T12:00:00')),
      createdAt: DateTime.parse(date),
      updatedAt: DateTime.parse(date),
    ),
  );

  Future<void> shown(String date, String level) => db
      .into(db.auditDays)
      .insert(
        AuditDaysCompanion.insert(
          date: date,
          level: level,
          modelVersion: '1.0.0',
          recordedAt: DateTime.parse(date),
        ),
      );

  /// October: two attacks after High days, one without; three High days,
  /// one with no attack. Plus nine older attacks to pass the threshold.
  Future<void> seed() async {
    await shown('2026-10-01', 'high');
    await shown('2026-10-02', 'low');
    await shown('2026-10-09', 'moderate');
    await shown('2026-10-10', 'low');
    await shown('2026-10-14', 'high');
    await shown('2026-10-20', 'high');
    await attack('a1', '2026-10-02');
    await attack('a2', '2026-10-10');
    await attack('a3', '2026-10-14');
    for (var i = 0; i < 7; i++) {
      await attack('old$i', '2026-0${i + 1}-15');
    }
  }

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        auditGatewayProvider.overrideWithValue(gateway),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  group('monthly upload', () {
    test('is off by default and sends nothing', () async {
      await seed();
      final c = container();
      expect(
        await c.read(auditUploaderProvider).sendIfDue(),
        AuditSendOutcome.off,
      );
      expect(gateway.sent, isEmpty);
    });

    test('once on, sends last month exactly once, from the 3rd', () async {
      await seed();
      now = DateTime(2026, 11, 2, 9);
      final c = container();
      final uploader = c.read(auditUploaderProvider);
      await uploader.setShare(on: true);
      expect(gateway.sent, isEmpty, reason: 'before the 3rd');
      expect(await uploader.sendIfDue(), AuditSendOutcome.notYet);

      now = DateTime(2026, 11, 6, 9);
      expect(await uploader.sendIfDue(), AuditSendOutcome.sent);
      expect(gateway.sent, [
        {
          'attacks': 3,
          'hits': 2,
          'misses': 1,
          'highDays': 3,
          'falseAlarms': 1,
          'modelVersion': '1.0.0',
        },
      ]);
      expect(gateway.sent.single.keys.toSet(), AuditUpload.keys);
      expect(await uploader.sendIfDue(), AuditSendOutcome.alreadySent);
      expect(gateway.sent, hasLength(1));
      expect(
        await c
            .read(settingsRepositoryProvider)
            .read<String>(SettingsKeys.auditLastSentMonth),
        '2026-10',
      );
    });

    test('a failed send is retried on the next start', () async {
      await seed();
      final c = container();
      await c
          .read(settingsRepositoryProvider)
          .write(SettingsKeys.auditShare, true);
      gateway.error = Exception('offline');
      final uploader = c.read(auditUploaderProvider);
      expect(await uploader.sendIfDue(), AuditSendOutcome.failed);
      gateway.error = null;
      expect(await uploader.sendIfDue(), AuditSendOutcome.sent);
    });

    test('an empty month is marked done without calling the server', () async {
      await seed();
      now = DateTime(2026, 12, 5, 9);
      final c = container();
      await c
          .read(settingsRepositoryProvider)
          .write(SettingsKeys.auditShare, true);
      expect(
        await c.read(auditUploaderProvider).sendIfDue(),
        AuditSendOutcome.nothingToSend,
      );
      expect(gateway.sent, isEmpty);
    });
  });

  group('screen', () {
    Future<void> pump(WidgetTester tester) => tester.pumpApp(
      database: db,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        auditGatewayProvider.overrideWithValue(gateway),
        locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
        weatherSourceProvider.overrideWithValue(
          FakeWeatherSource(null)..error = Exception('offline'),
        ),
      ],
    );

    bool present(String key) => find.byKey(ValueKey(key)).evaluate().isNotEmpty;

    String textOf(WidgetTester tester, String key) =>
        tester.widget<Text>(find.byKey(ValueKey(key))).data ?? '';

    Future<void> openSettings(WidgetTester tester) async {
      await tester.tap(find.byKey(const ValueKey('home-settings')));
      await tester.pumpAndSettle();
    }

    testWidgets('before ten attacks there is no settings entry, and the '
        'page says why it is empty', (tester) async {
      await tester.runAsync(() async {
        await shown('2026-10-01', 'high');
        await attack('a1', '2026-10-02');
      });
      await pump(tester);
      await openSettings(tester);
      expect(present('settings-audit'), isFalse);
      final router = GoRouter.of(
        tester.element(find.byKey(const ValueKey('settings-reminder'))),
      );
      unawaited(router.push<void>(AppRoutes.audit));
      await tester.pumpAndSettle();
      expect(find.byType(AuditScreen), findsOneWidget);
      expect(present('audit-not-yet'), isTrue);
      expect(present('audit-hits'), isFalse);
    });

    testWidgets('from ten attacks: counts, the trend and the caveat, with '
        'sharing off until turned on', (tester) async {
      await tester.runAsync(seed);
      await pump(tester);
      await openSettings(tester);
      await tester.scrollToKey('settings-audit');
      await tester.tap(find.byKey(const ValueKey('settings-audit')));
      await tester.pumpAndSettle();

      expect(textOf(tester, 'audit-hits-value'), '2 of 3 (67%)');
      expect(textOf(tester, 'audit-misses-value'), '1 attack');
      expect(textOf(tester, 'audit-false-alarms-value'), '1 of 3 High days');
      await tester.scrollToKey('audit-month-2026-10');
      await tester.scrollToKey('audit-caveat');
      await tester.scrollToKey('audit-share');
      SwitchListTile share() => tester.widget<SwitchListTile>(
        find.byKey(const ValueKey('audit-share')),
      );
      expect(share().value, isFalse);
      expect(gateway.sent, isEmpty);

      await tester.tap(find.byKey(const ValueKey('audit-share')));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
      expect(share().value, isTrue);
      expect(gateway.sent, hasLength(1));
    });
  });
}
