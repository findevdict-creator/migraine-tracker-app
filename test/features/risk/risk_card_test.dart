import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart'
    hide FactorWeight, RiskDay;
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_screen.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:risk_model/risk_model.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
  });

  tearDown(() => db.close());

  /// Stores a scored day straight into the local store, as the engine
  /// would have done on a previous open.
  Future<void> storeRisk(
    String date, {
    int? stress,
    int? sleepQuality,
    int? alcohol,
    WeightTable? weights,
  }) => DriftRiskRepository(db).saveRisk([
    DailyLoad(weights: weights).compute(
      DayInputs(
        date: date,
        stress: stress,
        sleepQuality: sleepQuality,
        alcohol: alcohol,
      ),
    ),
  ], now: now);

  /// Weather that fails, so everything on screen must come from the
  /// local store.
  List<Override> offline() => [
    clockProvider.overrideWithValue(() => now),
    weatherSourceProvider.overrideWithValue(
      FakeWeatherSource(null)..error = Exception('offline'),
    ),
  ];

  testWidgets('empty state before any scored day', (tester) async {
    await tester.pumpApp(database: db, overrides: offline());
    expect(find.byKey(const ValueKey('risk-card')), findsOneWidget);
    expect(find.byKey(const ValueKey('risk-empty')), findsOneWidget);
    expect(find.byKey(const ValueKey('risk-level')), findsNothing);
    expect(find.byKey(const ValueKey('risk-learning')), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('risk-learning'))).data,
      'Still learning: 0 of 10 attacks logged',
    );
  });

  testWidgets('shows the stored level, drivers, confidence and the next '
      'days while offline', (tester) async {
    await storeRisk('2026-11-06', stress: 5, sleepQuality: 1, alcohol: 3);
    await storeRisk('2026-11-07', stress: 2);
    await storeRisk('2026-11-08', stress: 5);
    await storeRisk('2026-11-09', stress: 4, sleepQuality: 1);
    await storeRisk('2026-11-10', stress: 5); // outside the window
    await tester.pumpApp(database: db, overrides: offline());

    expect(find.byKey(const ValueKey('risk-empty')), findsNothing);
    final badge = find.byKey(const ValueKey('risk-level'));
    expect(badge, findsOneWidget);
    expect(
      find.descendant(of: badge, matching: find.text('High')),
      findsOneWidget,
    );
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('risk-driver-0'))).data,
      'Poor sleep',
    );
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('risk-driver-1'))).data,
      'Stress',
    );
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('risk-driver-2'))).data,
      'Alcohol',
    );
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('risk-confidence'))).data,
      'Confidence: low',
    );
    expect(find.byKey(const ValueKey('risk-day-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('risk-day-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('risk-day-3')), findsNothing);
    expect(find.textContaining('Tomorrow · Low'), findsOneWidget);
    expect(find.textContaining('Sunday · Moderate'), findsOneWidget);
  });

  testWidgets('confidence label follows the learned weights', (tester) async {
    final tuned = WeightTable.population().copyWith(
      Factor.stress,
      const FactorWeight(population: 0.45, personal: 0.9, confidence: 0.8),
    );
    await storeRisk('2026-11-06', stress: 5, weights: tuned);
    await tester.pumpApp(database: db, overrides: offline());
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('risk-confidence'))).data,
      'Confidence: high',
    );
  });

  testWidgets('the badge turns to "tuned" at ten attacks', (tester) async {
    final repo = DriftAttackRepository(db, clock: () => now);
    for (var i = 0; i < 10; i++) {
      await repo.save(
        AttackEntity(
          id: 'a$i',
          startedAt: now.subtract(Duration(days: i + 1)),
          endedAt: now.subtract(Duration(days: i + 1, hours: -3)),
        ),
      );
    }
    await tester.pumpApp(database: db, overrides: offline());
    expect(find.byKey(const ValueKey('risk-learning')), findsNothing);
    expect(find.byKey(const ValueKey('risk-tuned')), findsOneWidget);
  });

  testWidgets('tapping the card opens the risk screen with every driver, '
      'the explainer link and the disclaimer', (tester) async {
    await storeRisk('2026-11-06', stress: 5, alcohol: 3);
    await storeRisk('2026-11-07', stress: 2);
    await tester.pumpApp(database: db, overrides: offline());
    await tester.tap(find.byKey(const ValueKey('risk-card')));
    await tester.pumpAndSettle();
    expect(find.byType(RiskScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('risk-section-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('risk-section-1')), findsOneWidget);
    expect(find.text('Load 55 of 100'), findsOneWidget);
    expect(find.text('45 points'), findsOneWidget);
    expect(find.text('18 points'), findsOneWidget);
    await tester.scrollToKey('risk-disclaimer');
    expect(find.byKey(const ValueKey('risk-disclaimer')), findsOneWidget);
    await tester.scrollToKey('risk-explainer');
    await tester.tap(find.byKey(const ValueKey('risk-explainer')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('level-explainer')), findsOneWidget);
  });

  testWidgets('the risk screen without data offers the check-in', (
    tester,
  ) async {
    await tester.pumpApp(database: db, overrides: offline());
    await tester.tap(find.byKey(const ValueKey('risk-card')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('risk-screen-empty')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('risk-open-checkin')));
    await tester.pumpAndSettle();
    expect(find.byType(CheckinScreen), findsOneWidget);
  });
}
