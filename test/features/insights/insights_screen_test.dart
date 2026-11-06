import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart'
    hide FactorWeight, RiskDay;
import 'package:migraine_tracker/features/insights/presentation/insights_screen.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:risk_model/risk_model.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 6, 9, 30);

  setUp(() => db = newTestDatabase());
  tearDown(() => db.close());

  Future<void> open(WidgetTester tester) async {
    await tester.pumpApp(database: db);
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('settings-insights');
    await tester.tap(find.byKey(const ValueKey('settings-insights')));
    await tester.pumpAndSettle();
    expect(find.byType(InsightsScreen), findsOneWidget);
  }

  Future<String> count(WidgetTester tester, String bucket) async {
    await tester.scrollToKey('insights-$bucket-count');
    return tester
        .widget<Text>(find.byKey(ValueKey('insights-$bucket-count')))
        .data!;
  }

  testWidgets('before any learning run everything is not enough data', (
    tester,
  ) async {
    await open(tester);
    expect(find.byKey(const ValueKey('insights-no-run')), findsOneWidget);
    expect(await count(tester, 'trigger'), '0');
    expect(await count(tester, 'protector'), '0');
    expect(await count(tester, 'neutral'), '0');
    expect(await count(tester, 'not-enough'), '14');
    await tester.scrollToKey('insights-trigger');
    expect(find.text('Nothing here yet.'), findsNWidgets(3));
  });

  testWidgets('learned weights fill the buckets with sample sizes and the '
      'protector list looks like the trigger list', (tester) async {
    final table = WeightTable.population()
        .copyWith(
          Factor.stress,
          const FactorWeight(
            population: 0.45,
            personal: 0.9,
            confidence: 0.6,
            nExposures: 12,
            nAttacksAfter: 7,
          ),
        )
        .copyWith(
          Factor.caffeine,
          const FactorWeight(
            population: 0.25,
            personal: 0.1,
            confidence: 0.6,
            nExposures: 20,
            nAttacksAfter: 2,
          ),
        )
        .copyWith(
          Factor.pollen,
          const FactorWeight(
            population: 0.2,
            personal: 0.2,
            confidence: 0.3,
            nExposures: 8,
            nAttacksAfter: 2,
          ),
        )
        .copyWith(
          Factor.alcohol,
          const FactorWeight(
            population: 0.35,
            personal: 0.9,
            confidence: 0.1,
            nExposures: 4,
            nAttacksAfter: 3,
          ),
        );
    await DriftRiskRepository(db).saveWeights(table, now: now);
    await open(tester);
    expect(find.byKey(const ValueKey('insights-no-run')), findsNothing);
    expect(await count(tester, 'trigger'), '1');
    expect(await count(tester, 'protector'), '1');
    expect(await count(tester, 'neutral'), '1');
    expect(await count(tester, 'not-enough'), '11');

    await tester.scrollToKey('insight-stress');
    final stress = find.byKey(const ValueKey('insight-stress'));
    expect(
      find.descendant(
        of: stress,
        matching: find.text('12 exposure days, 7 followed by an attack'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: stress, matching: find.text('2.0× your usual rate')),
      findsOneWidget,
    );
    await tester.scrollToKey('insight-caffeine');
    final caffeine = find.byKey(const ValueKey('insight-caffeine'));
    expect(
      find.descendant(
        of: caffeine,
        matching: find.text('0.4× your usual rate'),
      ),
      findsOneWidget,
    );
    // Same widget shape for both lists.
    expect(tester.widget<ListTile>(caffeine).trailing, isA<Text>());
    await tester.scrollToKey('insight-stress');
    expect(tester.widget<ListTile>(stress).trailing, isA<Text>());

    await tester.scrollToKey('insight-alcohol');
    final alcohol = find.byKey(const ValueKey('insight-alcohol'));
    expect(
      find.descendant(
        of: alcohol,
        matching: find.text('4 of 5 exposure days logged'),
      ),
      findsOneWidget,
    );
    expect(tester.widget<ListTile>(alcohol).trailing, isNull);
  });

  testWidgets('the method page opens from the screen and from the risk '
      'screen link', (tester) async {
    await open(tester);
    await tester.scrollToKey('insights-method');
    await tester.tap(find.byKey(const ValueKey('insights-method')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('insights-method-page')), findsOneWidget);
    expect(find.textContaining('5 exposure days'), findsOneWidget);
  });

  testWidgets('the risk screen links to the factors', (tester) async {
    await tester.pumpApp(database: db);
    await tester.tap(find.byKey(const ValueKey('risk-card')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('risk-insights');
    await tester.tap(find.byKey(const ValueKey('risk-insights')));
    await tester.pumpAndSettle();
    expect(find.byType(InsightsScreen), findsOneWidget);
  });
}
