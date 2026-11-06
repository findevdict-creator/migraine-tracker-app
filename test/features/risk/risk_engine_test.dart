import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';
import 'package:migraine_tracker/features/risk/application/risk_engine.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:risk_model/risk_model.dart';

import '../../support/test_database.dart';
import 'support/risk_seed.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  var now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    now = DateTime(2026, 11, 6, 9, 30);
    db = newTestDatabase();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  RiskEngine engine() => container.read(riskEngineProvider);

  /// Forty days of check-ins where stress is high every fourth day and an
  /// attack starts the day after each stressed day.
  Future<void> seedHistory({int days = 40}) async {
    final start = now.subtract(Duration(days: days));
    for (var i = 0; i < days; i++) {
      final day = start.add(Duration(days: i));
      final stressed = i % 4 == 0;
      await seedCheckin(
        container,
        day.dateKey,
        stress: stressed ? 5 : 2,
        sleepQuality: 4,
        caffeine: i.isEven ? 4 : 1,
      );
      if (stressed) {
        final at = day.add(const Duration(days: 1, hours: 8));
        await container
            .read(attackRepositoryProvider)
            .save(
              AttackEntity(
                id: 'a$i',
                startedAt: at,
                endedAt: at.add(const Duration(hours: 5)),
              ),
            );
      }
    }
  }

  test(
    'before any run: population weights and thresholds, nothing stored',
    () async {
      expect((await engine().weights())[Factor.stress].confidence, 0);
      expect((await engine().thresholds()).moderate, 35);
      expect(await engine().relearn(), isNull);
      expect(await container.read(riskRepositoryProvider).allRisk(), isEmpty);
    },
  );

  test('relearn stores weights, thresholds and the history', () async {
    await seedHistory();
    final result = await engine().relearn();
    expect(result, isNotNull);
    expect(result!.attackCount, 10);
    expect(result.dayCount, 40);

    final stored = await container.read(riskRepositoryProvider).weights();
    expect(stored, isNotNull);
    final stress = stored![Factor.stress];
    expect(stress.nExposures, 10);
    expect(stress.nAttacksAfter, 10);
    expect(stress.confidence, greaterThan(0.4));
    expect(stress.personal, greaterThan(stress.population));
    // Caffeine has exposures but no special relation to attacks.
    expect(stored[Factor.caffeine].nExposures, 20);

    final settings = container.read(settingsRepositoryProvider);
    final thresholds = await settings.read<Map<String, dynamic>>(
      SettingsKeys.riskThresholds,
    );
    expect(thresholds, isNotNull);
    expect(await engine().thresholds(), isA<LevelThresholds>());
    expect(
      await settings.read<String>(SettingsKeys.riskLastLearnedAt),
      now.toIso8601String(),
    );

    final risks = await container.read(riskRepositoryProvider).allRisk();
    // 40 history days plus today (scored by scoreUpcoming; today has a
    // check-in? no: history ends yesterday, today has no data).
    expect(risks.length, 40);
    expect(risks.first.modelVersion, modelVersion);
    expect(risks.first.computedAt, now);
    final stressedDay = risks.firstWhere(
      (r) => r.contributions.any(
        (c) => c.factor == Factor.stress && c.exposure == 1,
      ),
    );
    expect(stressedDay.drivers().first.factor, Factor.stress);
    expect(stressedDay.score, greaterThan(0));
  });

  test(
    'scoreUpcoming stores today and the days ahead that have data',
    () async {
      await seedCell(container);
      // Weather for today and the next three days.
      await seedHours(
        container,
        firstDay: DateTime(2026, 11, 5),
        days: 5,
        pressureAt: (i) => 1020 - i * 0.3,
        humidityAt: (_) => 70,
      );
      await seedCheckin(container, '2026-11-06', stress: 5);
      final risks = await engine().scoreUpcoming();
      expect(risks.map((r) => r.date), [
        '2026-11-06',
        '2026-11-07',
        '2026-11-08',
        '2026-11-09',
      ]);
      expect(
        risks.first.drivers().map((c) => c.factor),
        containsAll([Factor.stress, Factor.pressureDrop]),
      );
      // Tomorrow has weather only: pressure drop of 7.2 hPa.
      expect(
        risks[1].contributions.map((c) => c.factor),
        contains(Factor.pressureDrop),
      );
      final stored = await container
          .read(riskRepositoryProvider)
          .riskFor('2026-11-07');
      expect(stored, isNotNull);
      expect(stored!.level, risks[1].level);

      // Live providers see the rows.
      final sub = container.listen(riskDayProvider('2026-11-06'), (_, _) {});
      addTearDown(sub.close);
      final today = await container.read(riskDayProvider('2026-11-06').future);
      expect(today!.score, risks.first.load);
      const span = (from: '2026-11-06', to: '2026-11-09');
      final rangeSub = container.listen(riskRangeProvider(span), (_, _) {});
      addTearDown(rangeSub.close);
      final range = await container.read(riskRangeProvider(span).future);
      expect(range.length, 4);
      expect(await container.read(attackCountProvider.future), 0);
    },
  );

  test('ending an attack re-learns', () async {
    await seedHistory(days: 20);
    final sub = container.listen(riskWeightsProvider, (_, _) {});
    addTearDown(sub.close);
    expect(await container.read(riskWeightsProvider.future), isNull);
    final starter = container.read(attackStarterProvider);
    final id = await starter.start();
    final editor = container.read(attackEditorProvider(id).notifier);
    await container.read(attackEditorProvider(id).future);
    await editor.end();
    final weights = await container.read(riskRepositoryProvider).weights();
    expect(weights, isNotNull);
    expect(weights![Factor.stress].nExposures, 5);
  });

  test('a failing relearn is swallowed', () async {
    await db.close();
    await relearnQuietly(container.read(_refProvider));
  });
}

/// Hands a Ref to the test.
final _refProvider = Provider<Ref>((ref) => ref);
