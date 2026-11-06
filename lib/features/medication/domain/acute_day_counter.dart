import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';

/// Which gentle note applies for the month's acute-medication days.
enum OveruseNote {
  none,
  first,
  second;

  static OveruseNote forDays(int acuteDays) {
    if (acuteDays >= AppThresholds.medicationOveruseSecondNote) {
      return OveruseNote.second;
    }
    if (acuteDays >= AppThresholds.medicationOveruseFirstNote) {
      return OveruseNote.first;
    }
    return OveruseNote.none;
  }
}

/// Counts calendar days (local time) in one month with at least one acute
/// dose. Two doses on one day count once. Preventive doses never count.
abstract final class AcuteDayCounter {
  static int daysInMonth(
    Iterable<MedicationEntity> events, {
    required int year,
    required int month,
  }) => acuteDays(events, year: year, month: month).length;

  /// The distinct local date keys with an acute dose in that month.
  static Set<String> acuteDays(
    Iterable<MedicationEntity> events, {
    required int year,
    required int month,
  }) {
    final days = <String>{};
    for (final e in events) {
      if (!e.isAcute) continue;
      final local = e.takenAt.toLocal();
      if (local.year == year && local.month == month) {
        days.add(local.dateKey);
      }
    }
    return days;
  }

  /// Start of the local month containing [when], as a UTC instant.
  static DateTime monthStart(DateTime when) {
    final l = when.toLocal();
    return DateTime(l.year, l.month);
  }

  /// Start of the following local month.
  static DateTime nextMonthStart(DateTime when) {
    final l = when.toLocal();
    return DateTime(l.year, l.month + 1);
  }
}
