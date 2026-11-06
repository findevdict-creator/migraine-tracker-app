import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/features/attack_log/application/duration_estimate_provider.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/attack_log/domain/duration_estimate.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';

void main() {
  final t0 = DateTime(2026, 10);
  var n = 0;

  AttackEntity past(double hours, {int? intensity}) {
    n++;
    final start = t0.add(Duration(days: n));
    return AttackEntity(
      id: 'a$n',
      startedAt: start,
      endedAt: start.add(Duration(minutes: (hours * 60).round())),
      intensity: intensity,
    );
  }

  AttackEntity running({int? intensity}) => AttackEntity(
    id: 'now',
    startedAt: DateTime(2026, 11, 6, 9),
    intensity: intensity,
  );

  setUp(() => n = 0);

  test('nothing until five completed attacks', () {
    final four = [
      for (final h in [3.0, 4.0, 5.0, 6.0]) past(h),
    ];
    // A running attack and a zero-length one do not count.
    final noise = [
      AttackEntity(id: 'open', startedAt: t0),
      AttackEntity(id: 'zero', startedAt: t0, endedAt: t0),
    ];
    expect(
      DurationEstimator.estimate(
        running: running(),
        attacks: [...four, ...noise],
        medsByAttack: const {},
      ),
      isNull,
    );
    expect(
      DurationEstimator.estimate(
        running: running(),
        attacks: [...four, past(8)],
        medsByAttack: const {},
      ),
      const DurationEstimate(
        low: Duration(hours: 4),
        high: Duration(hours: 6),
        sample: 5,
        basis: EstimateBasis.noMedication,
      ),
    );
  });

  test('similar intensity and the same medication come first', () {
    final treated = [
      for (final h in [2.0, 3.0, 3.0, 4.0, 5.0]) past(h, intensity: 6),
    ];
    final other = [
      for (final h in [10.0, 12.0]) past(h, intensity: 7),
    ];
    final meds = {
      for (final a in treated) a.id: {'ibuprofen'},
      for (final a in other) a.id: {'sumatriptan'},
      'now': {'ibuprofen'},
    };
    final e = DurationEstimator.estimate(
      running: running(intensity: 7),
      attacks: [...treated, ...other],
      medsByAttack: meds,
    )!;
    expect(e.basis, EstimateBasis.sameMedication);
    expect(e.sample, 5);
    expect(
      (e.low, e.high),
      (const Duration(hours: 3), const Duration(hours: 4)),
    );
  });

  test('too few with the same medication falls back to similar intensity, '
      'then to every attack', () {
    final similar = [
      for (final h in [4.0, 5.0, 6.0, 7.0, 8.0]) past(h, intensity: 8),
    ];
    final meds = {
      'a1': {'ibuprofen'},
      'now': {'ibuprofen'},
    };
    final bySimilar = DurationEstimator.estimate(
      running: running(intensity: 9),
      attacks: similar,
      medsByAttack: meds,
    )!;
    expect(bySimilar.basis, EstimateBasis.similarIntensity);
    expect(bySimilar.sample, 5);

    // Intensity 3 is more than two away from every past attack.
    final byAll = DurationEstimator.estimate(
      running: running(intensity: 3),
      attacks: similar,
      medsByAttack: meds,
    )!;
    expect(byAll.basis, EstimateBasis.allAttacks);
    expect(byAll.sample, 5);
  });

  test('an attack with no intensity yet compares by medication only', () {
    final attacks = [
      for (final i in [2, 4, 6, 8, 10]) past(5, intensity: i),
    ];
    final e = DurationEstimator.estimate(
      running: running(),
      attacks: attacks,
      medsByAttack: const {},
    )!;
    expect(e.basis, EstimateBasis.noMedication);
  });

  test('always a range: whole hours from three hours, half hours below', () {
    final same = [for (var i = 0; i < 6; i++) past(4)];
    final wide = DurationEstimator.estimate(
      running: running(),
      attacks: same,
      medsByAttack: const {},
    )!;
    expect(
      (wide.low, wide.high),
      (const Duration(hours: 4), const Duration(hours: 5)),
    );

    final short = [
      for (final h in [0.75, 1.0, 1.25, 1.5, 2.0]) past(h),
    ];
    final fine = DurationEstimator.estimate(
      running: running(),
      attacks: short,
      medsByAttack: const {},
    )!;
    expect(
      (fine.low, fine.high),
      (const Duration(minutes: 60), const Duration(minutes: 90)),
    );
  });

  test('medication names match regardless of case and spacing; preventive '
      'doses do not count', () {
    MedicationEntity dose(String attackId, String name, MedicationKind kind) =>
        MedicationEntity(
          id: '$attackId-$name',
          attackId: attackId,
          name: name,
          takenAt: t0,
          kind: kind,
        );
    expect(
      acuteNamesByAttack([
        dose('a', 'Ibuprofen ', MedicationKind.acute),
        dose('a', 'ibuprofen', MedicationKind.acute),
        dose('a', 'Propranolol', MedicationKind.preventive),
        MedicationEntity(
          id: 'loose',
          name: 'Naproxen',
          takenAt: t0,
          kind: MedicationKind.acute,
        ),
      ]),
      {
        'a': {'ibuprofen'},
      },
    );
  });
}
