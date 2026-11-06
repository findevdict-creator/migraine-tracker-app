import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_screen.dart';
import 'package:migraine_tracker/features/health/data/health_source_impl.dart';
import 'package:migraine_tracker/features/health/domain/health_entities.dart';
import 'package:migraine_tracker/features/health/presentation/health_settings_screen.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import 'support/health_fakes.dart';

void main() {
  late AppDatabase db;
  late FakeHealthSource source;
  final now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    source = FakeHealthSource()
      ..samples.add(
        sample(
          HealthType.sleep,
          DateTime(2026, 11, 5, 23),
          const Duration(hours: 7),
          420,
        ),
      );
  });

  tearDown(() => db.close());

  Future<void> openHealth(WidgetTester tester) async {
    await tester.pumpApp(
      database: db,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        healthSourceProvider.overrideWithValue(source),
      ],
    );
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('settings-health')));
    await tester.pumpAndSettle();
    expect(find.byType(HealthSettingsScreen), findsOneWidget);
  }

  testWidgets('each type has its own switch with a reason, and turning one '
      'on asks the store and imports', (tester) async {
    await openHealth(tester);
    for (final type in HealthType.values) {
      await tester.scrollToKey('health-${type.name}');
      expect(find.byKey(ValueKey('health-${type.name}')), findsOneWidget);
    }
    await tester.scrollToKey('health-sleep');
    expect(find.textContaining('one less tap'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('health-sleep')));
    await tester.pumpAndSettle();
    expect(source.readRequests, [
      {HealthType.sleep},
    ]);
    final tile = tester.widget<SwitchListTile>(
      find.byKey(const ValueKey('health-sleep')),
    );
    expect(tile.value, isTrue);
    await tester.scrollToKey('health-last-import');
    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('health-last-import')))
          .data,
      'Updated just now',
    );
  });

  testWidgets('a denied store leaves the switch off and says so', (
    tester,
  ) async {
    source.grantRead = false;
    await openHealth(tester);
    await tester.tap(find.byKey(const ValueKey('health-steps')));
    await tester.pumpAndSettle();
    final tile = tester.widget<SwitchListTile>(
      find.byKey(const ValueKey('health-steps')),
    );
    expect(tile.value, isFalse);
    expect(find.textContaining('did not grant access'), findsOneWidget);
  });

  testWidgets('imported sleep shows on the check-in with a source icon', (
    tester,
  ) async {
    await openHealth(tester);
    await tester.tap(find.byKey(const ValueKey('health-sleep')));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('checkin-card')));
    await tester.pumpAndSettle();
    expect(find.byType(CheckinScreen), findsOneWidget);
    expect(
      find.byKey(const ValueKey('checkin-source-sleepQuality')),
      findsOneWidget,
    );
    final chip = find.byKey(const ValueKey('checkin-sleepQuality-3'));
    expect(chip, findsOneWidget);
    expect(find.byKey(const ValueKey('checkin-source-stress')), findsNothing);
  });

  testWidgets('without a store the switches are disabled', (tester) async {
    source.available = false;
    await openHealth(tester);
    expect(find.byKey(const ValueKey('health-unavailable')), findsOneWidget);
    final tile = tester.widget<SwitchListTile>(
      find.byKey(const ValueKey('health-sleep')),
    );
    expect(tile.onChanged, isNull);
  });
}
