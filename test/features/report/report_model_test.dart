import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/insights/domain/factor_insight.dart';
import 'package:migraine_tracker/features/medication/domain/acute_day_counter.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';

import 'support/report_fixtures.dart';

void main() {
  final today = DateTime(2026, 11, 6);

  group('ReportRange', () {
    test('counts days inclusively and lists months', () {
      final r = ReportRange(DateTime(2026, 9, 28, 15), DateTime(2026, 11, 2));
      expect(r.days, 36);
      expect(r.from, DateTime(2026, 9, 28));
      expect(r.months, [(2026, 9), (2026, 10), (2026, 11)]);
      expect(r.contains(DateTime(2026, 11, 2, 23, 59)), isTrue);
      expect(r.contains(DateTime(2026, 11, 3)), isFalse);
      expect(r.end, DateTime(2026, 11, 3));
    });

    test('lastDays ends today and spans a year boundary', () {
      final r = ReportRange.lastDays(30, today: DateTime(2026, 1, 10));
      expect(r.days, 30);
      expect(r.from, DateTime(2025, 12, 12));
      expect(r.months, [(2025, 12), (2026, 1)]);
    });
  });

  group('ReportBuilder', () {
    test('an empty range is empty', () {
      final s = ReportBuilder.build(
        ReportInputs(
          range: ReportRange.lastDays(30, today: today),
          generatedAt: today,
        ),
      );
      expect(s.isEmpty, isTrue);
      expect(s.attacks, 0);
      expect(s.meanIntensity, isNull);
      expect(s.durations.count, 0);
      expect(s.months.length, 2);
      expect(s.weather.lift, isNull);
      expect(
        s.triggers.every((t) => t.bucket == InsightBucket.notEnoughData),
        isTrue,
      );
    });

    test('counts attacks, days, intensity and the calendar', () {
      final range = ReportRange.lastDays(10, today: today);
      final d1 = range.from.add(const Duration(hours: 8));
      final s = ReportBuilder.build(
        ReportInputs(
          range: range,
          generatedAt: today,
          attacks: [
            AttackEntity(id: 'a', startedAt: d1, intensity: 4, endedAt: d1),
            AttackEntity(
              id: 'b',
              startedAt: d1.add(const Duration(hours: 6)),
              intensity: 8,
            ),
            AttackEntity(
              id: 'c',
              startedAt: d1.add(const Duration(days: 2)),
              endedAt: d1.add(const Duration(days: 2, hours: 30)),
            ),
            // Outside the range: ignored.
            AttackEntity(
              id: 'old',
              startedAt: range.from.subtract(const Duration(days: 1)),
              intensity: 10,
            ),
          ],
        ),
      );
      expect(s.attacks, 3);
      expect(s.attackDays, 2);
      expect(s.meanIntensity, 6);
      expect(s.calendar, {
        '2026-10-28': 8, // the day's highest
        '2026-10-30': null, // unrated
      });
      expect(s.durations.count, 2);
      expect(s.durations.shortest, Duration.zero);
      expect(s.durations.longest, const Duration(hours: 30));
      expect(s.durations.buckets[DurationBucket.underFourHours], 1);
      expect(s.durations.buckets[DurationBucket.oneToThreeDays], 1);
      expect(s.attacksPerMonth, 9);
    });

    test('duration buckets sit at the clinical boundaries', () {
      expect(
        DurationBucket.of(const Duration(hours: 3, minutes: 59)),
        DurationBucket.underFourHours,
      );
      expect(
        DurationBucket.of(const Duration(hours: 4)),
        DurationBucket.fourToTwelve,
      );
      expect(
        DurationBucket.of(const Duration(hours: 12)),
        DurationBucket.twelveToTwentyFour,
      );
      expect(
        DurationBucket.of(const Duration(hours: 24)),
        DurationBucket.oneToThreeDays,
      );
      expect(
        DurationBucket.of(const Duration(hours: 72)),
        DurationBucket.oneToThreeDays,
      );
      expect(
        DurationBucket.of(const Duration(hours: 73)),
        DurationBucket.overThreeDays,
      );
    });

    test('medication rows count doses, days and relief; months get notes', () {
      final range = ReportRange(DateTime(2026, 10), DateTime(2026, 10, 31));
      final meds = <MedicationEntity>[
        for (var d = 1; d <= 11; d++)
          MedicationEntity(
            id: 'i$d',
            name: 'Ibuprofen',
            takenAt: DateTime(2026, 10, d, 9),
            kind: MedicationKind.acute,
            reliefAt2h: d.isEven ? Relief.full : Relief.none,
          ),
        MedicationEntity(
          id: 'i-again',
          name: 'Ibuprofen',
          takenAt: DateTime(2026, 10, 1, 15),
          kind: MedicationKind.acute,
        ),
        MedicationEntity(
          id: 'p',
          name: 'Propranolol',
          takenAt: DateTime(2026, 10, 1, 8),
          kind: MedicationKind.preventive,
        ),
      ];
      final s = ReportBuilder.build(
        ReportInputs(range: range, generatedAt: today, medications: meds),
      );
      expect(s.medications.map((m) => m.name), ['Ibuprofen', 'Propranolol']);
      final ibu = s.medications.first;
      expect(ibu.doses, 12);
      expect(ibu.days, 11);
      expect(ibu.relief[Relief.full], 5);
      expect(ibu.relief[Relief.none], 6);
      expect(s.acuteDays, 11);
      expect(s.months.single.acuteDays, 11);
      expect(s.months.single.overuse, OveruseNote.first);
    });

    test('weather correlation compares attacks with check-in days', () {
      final range = ReportRange.lastDays(5, today: today);
      DateTime day(int i) => range.from.add(Duration(days: i, hours: 10));
      final s = ReportBuilder.build(
        ReportInputs(
          range: range,
          generatedAt: today,
          attacks: [
            AttackEntity(
              id: 'a',
              startedAt: day(0),
              weather: const {'delta24h': -5.0},
            ),
            AttackEntity(
              id: 'b',
              startedAt: day(1),
              weather: const {'delta24h': -1.0},
            ),
            AttackEntity(id: 'c', startedAt: day(2)), // no snapshot
          ],
          checkins: [
            for (var i = 0; i < 5; i++)
              CheckinEntity(
                date: range.from
                    .add(Duration(days: i))
                    .toIso8601String()
                    .substring(0, 10),
                weather: {'delta24h': i == 0 ? -8.0 : 2.0},
              ),
          ],
        ),
      );
      final w = s.weather;
      expect(w.attacksWithData, 2);
      expect(w.attacksAfterFall, 1);
      expect(w.daysWithData, 5);
      expect(w.daysAfterFall, 1);
      expect(w.lift, 2.5);
      expect(s.checkinDays, 5);
    });

    test('symptoms and locations count attacks, not taps', () {
      final range = ReportRange.lastDays(3, today: today);
      final at = range.from.add(const Duration(hours: 1));
      final s = ReportBuilder.build(
        ReportInputs(
          range: range,
          generatedAt: today,
          attacks: [
            AttackEntity(
              id: 'a',
              startedAt: at,
              symptoms: [
                SymptomTap(symptom: Symptom.values.first, at: at),
                SymptomTap(symptom: Symptom.values.first, at: at),
              ],
              headLocations: {HeadLocation.values.first},
            ),
          ],
        ),
      );
      expect(s.symptoms, {Symptom.values.first: 1});
      expect(s.locations, {HeadLocation.values.first: 1});
    });

    test('a year of fixture data builds consistently', () {
      final s = ReportBuilder.build(yearOfData(today: today));
      expect(s.attacks, 92);
      expect(s.months.length, 13);
      expect(s.months.map((m) => m.attacks).fold(0, (a, b) => a + b), 92);
      expect(s.medications.map((m) => m.name), [
        'Propranolol',
        'Ibuprofen',
        'Sumatriptan',
      ]);
      expect(s.checkinDays, 365);
      expect(s.weather.lift, greaterThan(1));
    });
  });
}
