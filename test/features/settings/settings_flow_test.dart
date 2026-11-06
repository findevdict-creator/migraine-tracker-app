import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/export/presentation/share_files.dart';
import 'package:migraine_tracker/features/settings/presentation/settings_screen.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';

class _TempPathProvider extends PathProviderPlatform {
  _TempPathProvider(this.dir);

  final Directory dir;

  @override
  Future<String?> getTemporaryPath() async => dir.path;
}

void main() {
  late AppDatabase db;
  late Directory temp;
  final now = DateTime(2026, 11, 6, 9);
  final shared = <List<File>>[];

  setUp(() async {
    db = newTestDatabase();
    temp = await Directory.systemTemp.createTemp('settings');
    PathProviderPlatform.instance = _TempPathProvider(temp);
    shared.clear();
    await DriftAttackRepository(
      db,
      clock: () => now,
    ).save(AttackEntity(id: 'a1', startedAt: now, endedAt: now));
  });

  tearDown(() async {
    await db.close();
    await temp.delete(recursive: true);
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpApp(
      database: db,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        shareFilesProvider.overrideWithValue((files, {text}) async {
          shared.add(files);
        }),
      ],
    );
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
  }

  /// File writes use real I/O, which fake-async pumps never flush.
  Future<void> tapAndWait(WidgetTester tester, String key) async {
    await tester.runAsync(() async {
      await tester.tap(find.byKey(ValueKey(key)));
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pumpAndSettle();
  }

  testWidgets('JSON export hands one file to the share sheet', (tester) async {
    await pump(tester);
    await tapAndWait(tester, 'settings-export-json');
    expect(shared.single.single.path, endsWith('.json'));
    expect(shared.single.single.existsSync(), isTrue);
  });

  testWidgets('CSV export shares one file per non-empty table', (tester) async {
    await pump(tester);
    await tapAndWait(tester, 'settings-export-csv');
    expect(shared.single.map((f) => f.path.split('-').last), ['attacks.csv']);
  });

  testWidgets('delete everything asks first, then empties the database', (
    tester,
  ) async {
    await pump(tester);
    await tester.scrollToKey('settings-delete-all');
    await tester.tap(find.byKey(const ValueKey('settings-delete-all')));
    await tester.pumpAndSettle();
    expect(find.textContaining('This deletes 1 record'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect((await db.rowCounts())['attacks'], 1);

    await tester.tap(find.byKey(const ValueKey('settings-delete-all')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('settings-delete-confirm')));
    await tester.pumpAndSettle();
    expect(find.text('All data deleted.'), findsOneWidget);
    expect((await db.rowCounts()).values.every((n) => n == 0), isTrue);
  });

  testWidgets('reminder and cycle settings are reachable here', (tester) async {
    await pump(tester);
    expect(find.byKey(const ValueKey('settings-reminder')), findsOneWidget);
    expect(find.byKey(const ValueKey('cycle-toggle')), findsOneWidget);
  });
}
