import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart'
    hide FactorWeight, RiskDay;
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:migraine_tracker/features/risk/presentation/load_meter.dart';
import 'package:risk_model/risk_model.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';

void main() {
  group('loadSegments', () {
    test('shares add up to the load in proportion to points', () {
      final risk = const DailyLoad().compute(
        const DayInputs(date: '2026-11-06', stress: 5, sleepQuality: 1),
      );
      final segments = loadSegments(risk.load, risk.contributions);
      expect(segments.length, 2);
      final total = segments.fold<double>(0, (a, s) => a + s.share);
      expect(total, closeTo(risk.load, 1e-9));
      expect(segments.first.factor, Factor.poorSleep);
      expect(segments.first.points, 50);
      expect(segments.first.share, closeTo(72.5 * 50 / 95, 1e-9));
      expect(segments.first.color, isA<Color>());
    });

    test('zero load or zero points gives no segments', () {
      expect(loadSegments(0, const []), isEmpty);
      expect(
        loadSegments(10, const [
          Contribution(
            factor: Factor.pollen,
            exposure: 0,
            weight: 0.2,
            confidence: 0,
            points: 0,
          ),
        ]),
        isEmpty,
      );
    });
  });

  group('LoadMeter', () {
    late AppDatabase db;
    final now = DateTime(2026, 11, 6, 9, 30);

    setUp(() => db = newTestDatabase());
    tearDown(() => db.close());

    testWidgets('segments and legend are tappable and name the factor', (
      tester,
    ) async {
      await DriftRiskRepository(db).saveRisk([
        const DailyLoad().compute(
          const DayInputs(date: '2026-11-06', stress: 5, alcohol: 3),
        ),
      ], now: now);
      await tester.pumpApp(
        database: db,
        overrides: [clockProvider.overrideWithValue(() => now)],
      );
      expect(find.byKey(const ValueKey('risk-card-meter')), findsOneWidget);
      expect(find.byKey(const ValueKey('load-segment-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('load-segment-1')), findsOneWidget);
      final seg = find.byKey(const ValueKey('load-segment-1'));
      expect(tester.getSize(seg).height, 14);
      await tester.tap(seg);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Alcohol: 18 points'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('risk-card')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('load-legend-0')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('load-legend-0')));
      await tester.pumpAndSettle();
      expect(find.text('Stress: 45 points'), findsOneWidget);
      expect(
        find.textContaining('Moderate from 35', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('High from 60', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('threshold marks move with the learned thresholds', (
      tester,
    ) async {
      await DriftRiskRepository(db).saveRisk([
        const DailyLoad().compute(
          const DayInputs(date: '2026-11-06', stress: 5),
        ),
      ], now: now);
      await tester.pumpApp(
        database: db,
        overrides: [clockProvider.overrideWithValue(() => now)],
      );
      double markX(String key) =>
          tester.getTopLeft(find.byKey(ValueKey(key))).dx;
      final meter = tester.getTopLeft(
        find.byKey(const ValueKey('risk-card-meter')),
      );
      final width = tester
          .getSize(find.byKey(const ValueKey('risk-card-meter')))
          .width;
      expect(
        markX('load-mark-moderate') - meter.dx,
        closeTo(width * 0.35, 1.5),
      );

      await SettingsRepository(db)
          .write(SettingsKeys.riskThresholds, {'moderate': 20, 'high': 45});
      await tester.pumpAndSettle();
      expect(
        markX('load-mark-moderate') - meter.dx,
        closeTo(width * 0.20, 1.5),
      );
      expect(markX('load-mark-high') - meter.dx, closeTo(width * 0.45, 1.5));
    });
  });
}
