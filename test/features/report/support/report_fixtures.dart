import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';
import 'package:risk_model/risk_model.dart';

/// A deterministic year of data: an attack roughly every fourth day with a
/// pressure snapshot, an acute dose on most attack days, a check-in every
/// day, and learned weights for every factor.
ReportInputs yearOfData({required DateTime today}) {
  final range = ReportRange.lastDays(365, today: today);
  final attacks = <AttackEntity>[];
  final medications = <MedicationEntity>[];
  final checkins = <CheckinEntity>[];
  for (var i = 0; i < range.days; i++) {
    final day = range.from.add(Duration(days: i));
    final fell = i % 5 == 0;
    checkins.add(
      CheckinEntity(
        date: day.dateKey,
        values: {
          CheckinField.sleepQuality: 1 + i % 5,
          CheckinField.stress: 1 + (i * 3) % 5,
          CheckinField.neckTension: 1 + (i * 7) % 5,
          if (i.isEven) CheckinField.caffeine: i % 4,
        },
        cycleDay: i % 28 + 1,
        weather: {'delta24h': fell ? -6.0 : 1.5},
      ),
    );
    if (i % 4 != 0) continue;
    final start = day.add(const Duration(hours: 9));
    final hours = 2 + (i * 7) % 40;
    final id = 'a$i';
    attacks.add(
      AttackEntity(
        id: id,
        startedAt: start,
        endedAt: start.add(Duration(hours: hours)),
        intensity: 1 + (i * 3) % 10,
        headLocations: {
          HeadLocation.values[i % HeadLocation.values.length],
          if (i.isEven) HeadLocation.values.first,
        },
        phases: {AttackPhase.values.first: start},
        symptoms: [
          SymptomTap(
            symptom: Symptom.values[i % Symptom.values.length],
            at: start,
          ),
          SymptomTap(symptom: Symptom.values.first, at: start),
        ],
        notes: i % 8 == 0 ? 'note, with "quotes"' : null,
        weather: {'delta24h': fell ? -7.0 : 0.5},
      ),
    );
    if (i % 12 != 0) {
      medications.add(
        MedicationEntity(
          id: 'm$i',
          name: i % 8 == 4 ? 'Ibuprofen' : 'Sumatriptan',
          takenAt: start.add(const Duration(minutes: 30)),
          kind: MedicationKind.acute,
          attackId: id,
          dose: '1',
          reliefAt2h: Relief.values[i % 3],
        ),
      );
    }
    if (i.isEven) {
      medications.add(
        MedicationEntity(
          id: 'p$i',
          name: 'Propranolol',
          takenAt: day.add(const Duration(hours: 8)),
          kind: MedicationKind.preventive,
        ),
      );
    }
  }
  var table = WeightTable.population();
  for (final (n, f) in Factor.values.indexed) {
    table = table.copyWith(
      f,
      FactorWeight(
        population: 0.3,
        personal: 0.2 + n * 0.05,
        confidence: 0.2 + n * 0.05,
        nExposures: 4 + n * 3,
        nAttacksAfter: 1 + n,
      ),
    );
  }
  return ReportInputs(
    range: range,
    generatedAt: today,
    attacks: attacks,
    medications: medications,
    checkins: checkins,
    weights: table,
  );
}
