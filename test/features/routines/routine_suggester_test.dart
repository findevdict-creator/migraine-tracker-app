import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/routines/domain/routine.dart';
import 'package:migraine_tracker/features/routines/presentation/routine_text.dart';
import 'package:risk_model/risk_model.dart';

void main() {
  CheckinEntity checkin({int stress = 2, int neck = 2}) => CheckinEntity(
    date: '2026-11-06',
    values: {
      CheckinField.sleepQuality: 3,
      CheckinField.stress: stress,
      CheckinField.neckTension: neck,
    },
  );

  List<String> codes(List<RoutineSuggestion> s) =>
      s.map((x) => '${x.routine.code}:${x.reason.name}').toList();

  test('nothing to suggest on a calm day', () {
    expect(RoutineSuggester.suggest(), isEmpty);
    expect(
      RoutineSuggester.suggest(level: RiskLevel.moderate, checkin: checkin()),
      isEmpty,
    );
  });

  test('neck tension and stress at the trigger suggest stretches and '
      'breathing, check-in reasons first', () {
    const t = AppThresholds.routineCheckinTrigger;
    expect(
      codes(
        RoutineSuggester.suggest(
          level: RiskLevel.high,
          checkin: checkin(stress: t, neck: t),
        ),
      ),
      ['stretches:neckTension', 'breathing:stress'],
    );
    expect(
      RoutineSuggester.suggest(
        checkin: checkin(stress: t - 1, neck: t - 1),
      ),
      isEmpty,
    );
  });

  test('a high day suggests breathing and low light; each routine once', () {
    expect(codes(RoutineSuggester.suggest(level: RiskLevel.high)), [
      'breathing:highDay',
      'lowLight:highDay',
    ]);
    expect(
      codes(
        RoutineSuggester.suggest(
          level: RiskLevel.high,
          checkin: checkin(stress: 5),
          max: 5,
        ),
      ),
      ['breathing:stress', 'lowLight:highDay', 'hydration:highDay'],
    );
  });

  test('dismissed routines are skipped and the next one moves up', () {
    expect(
      codes(
        RoutineSuggester.suggest(
          level: RiskLevel.high,
          dismissed: {Routine.breathing},
        ),
      ),
      ['lowLight:highDay', 'hydration:highDay'],
    );
  });

  test('dismissals last one day and survive storage', () {
    final d = const RoutineDismissals.none().add('2026-11-06', [
      Routine.breathing,
    ]);
    final back = RoutineDismissals.fromJson(d.toJson());
    expect(back.forDate('2026-11-06'), {Routine.breathing});
    expect(back.forDate('2026-11-07'), isEmpty);
    expect(back.add('2026-11-07', [Routine.lowLight]).routines, {
      Routine.lowLight,
    });
    expect(RoutineDismissals.fromJson('junk').routines, isEmpty);
    expect(
      RoutineDismissals.fromJson(const {
        'date': '2026-11-06',
        'codes': ['breathing', 'nope', 3],
      }).routines,
      {Routine.breathing},
    );
  });

  test('every routine has a title, summary, steps and an illustration', () {
    final l10n = lookupAppLocalizations(AppLocales.fallback);
    for (final r in Routine.values) {
      expect(r.title(l10n), isNotEmpty, reason: r.code);
      expect(r.summary(l10n), isNotEmpty, reason: r.code);
      expect(r.steps(l10n).length, greaterThanOrEqualTo(3), reason: r.code);
      expect(r.illustration, 'assets/routines/${r.code}.svg');
      expect(Routine.fromCode(r.code), r);
    }
    for (final reason in SuggestionReason.values) {
      expect(reason.label(l10n), isNotEmpty);
    }
  });
}
