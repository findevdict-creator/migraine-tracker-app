import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/medication/domain/acute_day_counter.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';

MedicationEntity dose(
  String id,
  DateTime at, {
  MedicationKind kind = MedicationKind.acute,
}) => MedicationEntity(id: id, name: 'x', takenAt: at, kind: kind);

void main() {
  group('AcuteDayCounter', () {
    test('counts distinct local days, not doses', () {
      final events = [
        dose('a', DateTime(2026, 11, 3, 8)),
        dose('b', DateTime(2026, 11, 3, 20)),
        dose('c', DateTime(2026, 11, 4, 1)),
      ];
      expect(AcuteDayCounter.daysInMonth(events, year: 2026, month: 11), 2);
    });

    test('preventive doses never count', () {
      final events = [
        dose('a', DateTime(2026, 11, 3), kind: MedicationKind.preventive),
        dose('b', DateTime(2026, 11, 5)),
      ];
      expect(AcuteDayCounter.daysInMonth(events, year: 2026, month: 11), 1);
    });

    test('month boundaries are local midnight', () {
      final events = [
        dose('a', DateTime(2026, 10, 31, 23, 59)),
        dose('b', DateTime(2026, 11)),
        dose('c', DateTime(2026, 11, 30, 23, 59, 59)),
        dose('d', DateTime(2026, 12)),
      ];
      expect(AcuteDayCounter.daysInMonth(events, year: 2026, month: 11), 2);
      expect(AcuteDayCounter.daysInMonth(events, year: 2026, month: 10), 1);
      expect(AcuteDayCounter.daysInMonth(events, year: 2026, month: 12), 1);
      expect(AcuteDayCounter.acuteDays(events, year: 2026, month: 11), {
        '2026-11-01',
        '2026-11-30',
      });
    });

    test('UTC instants are counted on their local day', () {
      // The test runner is UTC, so this is the identity case; the point is
      // that the counter converts with toLocal() rather than using UTC.
      final e = dose('a', DateTime.utc(2026, 11, 1, 0, 30));
      final local = e.takenAt.toLocal();
      expect(
        AcuteDayCounter.daysInMonth([e], year: local.year, month: local.month),
        1,
      );
    });

    test('monthStart and nextMonthStart wrap the year', () {
      expect(
        AcuteDayCounter.monthStart(DateTime(2026, 12, 15)),
        DateTime(2026, 12),
      );
      expect(
        AcuteDayCounter.nextMonthStart(DateTime(2026, 12, 15)),
        DateTime(2027),
      );
    });
  });

  group('OveruseNote', () {
    test('thresholds come from the config', () {
      expect(OveruseNote.forDays(0), OveruseNote.none);
      expect(
        OveruseNote.forDays(AppThresholds.medicationOveruseFirstNote - 1),
        OveruseNote.none,
      );
      expect(
        OveruseNote.forDays(AppThresholds.medicationOveruseFirstNote),
        OveruseNote.first,
      );
      expect(
        OveruseNote.forDays(AppThresholds.medicationOveruseSecondNote),
        OveruseNote.second,
      );
      expect(OveruseNote.forDays(31), OveruseNote.second);
    });
  });
}
