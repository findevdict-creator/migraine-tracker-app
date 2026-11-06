import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart' hide RiskDay;
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/experiments/data/experiment_repository_impl.dart';
import 'package:migraine_tracker/features/experiments/domain/experiment.dart';
import 'package:migraine_tracker/features/experiments/presentation/experiments_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';

void main() {
  late AppDatabase db;
  var now = DateTime(2026, 11, 6, 9);

  setUp(() {
    db = newTestDatabase();
    now = DateTime(2026, 11, 6, 9);
  });
  tearDown(() => db.close());

  Future<void> settleUntil(WidgetTester tester, bool Function() done) async {
    for (var i = 0; i < 400 && !done(); i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(done(), isTrue, reason: 'did not settle');
    await tester.pumpAndSettle();
  }

  bool shown(String key) => find.byKey(ValueKey(key)).evaluate().isNotEmpty;

  DriftExperimentRepository repo() =>
      DriftExperimentRepository(db, newId: () => 'exp1');

  Future<void> open(WidgetTester tester) async {
    await tester.pumpApp(
      database: db,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        idGeneratorProvider.overrideWithValue(() => 'exp1'),
        locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
        weatherSourceProvider.overrideWithValue(
          FakeWeatherSource(null)..error = Exception('offline'),
        ),
      ],
    );
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('settings-experiments');
    await tester.tap(find.byKey(const ValueKey('settings-experiments')));
    await tester.pumpAndSettle();
    expect(find.byType(ExperimentsScreen), findsOneWidget);
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.scrollToKey(key);
    await tester.tap(find.byKey(ValueKey(key)));
  }

  testWidgets('pick a change, answer today, see the comparison with its '
      'caveats, then stop', (tester) async {
    await DriftAttackRepository(db, clock: () => now).save(
      AttackEntity(
        id: 'before',
        startedAt: DateTime(2026, 11, 1, 8),
        endedAt: DateTime(2026, 11, 1, 12),
        intensity: 7,
      ),
    );
    await open(tester);
    await settleUntil(tester, () => shown('experiment-pick-cut_caffeine'));

    await tapKey(tester, 'experiment-pick-cut_caffeine');
    await settleUntil(tester, () => shown('experiment-active'));
    expect(find.text('Cut back on caffeine'), findsOneWidget);
    expect(find.text('Day 1 of 14'), findsOneWidget);
    // One at a time: the picker is gone.
    expect(shown('experiment-pick-more_water'), isFalse);

    await tapKey(tester, 'experiment-kept-yes');
    await settleUntil(
      tester,
      () => find.text('Kept to it on 1 of 1 days').evaluate().isNotEmpty,
    );
    expect((await repo().active())!.adherence, {'2026-11-06': true});

    await tester.scrollToKey('experiment-caveat');
    await settleUntil(tester, () => shown('experiment-comparison'));
    expect(find.text('from 1 attack'), findsWidgets);
    expect(shown('experiment-small'), isTrue);
    expect(shown('experiment-caveat'), isTrue);

    await tapKey(tester, 'experiment-stop');
    await settleUntil(tester, () => shown('experiment-pick-cut_caffeine'));
    await tester.scrollToKey('experiment-past-exp1');
    expect(find.textContaining('Stopped'), findsOneWidget);
    expect(await repo().active(), isNull);
  });

  testWidgets('after two weeks it offers to finish and keeps the result', (
    tester,
  ) async {
    await repo().start(ExperimentChange.moreWater, DateTime(2026, 10, 20));
    await open(tester);
    await settleUntil(tester, () => shown('experiment-active'));
    expect(find.text('Day 14 of 14'), findsOneWidget);
    await tester.scrollToKey('experiment-finish');
    expect(shown('experiment-kept-yes'), isFalse);

    await tapKey(tester, 'experiment-finish');
    await settleUntil(tester, () => shown('experiment-pick-more_water'));
    await tester.scrollToKey('experiment-past-exp1');
    expect(find.textContaining('Finished'), findsOneWidget);
    // Drift streams need real async; the widget test clock is fake.
    final past = (await tester.runAsync(() => repo().watchPast().first))!;
    expect(past.single.status, ExperimentStatus.completed);
    expect(past.single.result!.during.days, 14);
  });

  test('only one experiment can be active', () async {
    final r = repo();
    await r.start(ExperimentChange.noAlcohol, now);
    await expectLater(
      DriftExperimentRepository(
        db,
        newId: () => 'exp2',
      ).start(ExperimentChange.moreWater, now),
      throwsStateError,
    );
  });
}
