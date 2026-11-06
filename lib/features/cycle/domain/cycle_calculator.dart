import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';

/// Phase names are descriptive labels, not clinical findings.
enum CyclePhase { menstrual, follicular, ovulation, luteal }

@immutable
class CycleInfo {
  const CycleInfo({
    required this.day,
    required this.phase,
    required this.cycleLength,
  });

  /// 1-based day of the cycle.
  final int day;
  final CyclePhase phase;
  final int cycleLength;

  @override
  bool operator ==(Object other) =>
      other is CycleInfo &&
      other.day == day &&
      other.phase == phase &&
      other.cycleLength == cycleLength;

  @override
  int get hashCode => Object.hash(day, phase, cycleLength);
}

/// Derives cycle day and phase from logged period starts. Pure.
abstract final class CycleCalculator {
  /// Average of the most recent intervals between starts, clamped to the
  /// configured range; the default length until two starts exist.
  static int cycleLength(List<String> starts) {
    final sorted = [...starts]..sort();
    if (sorted.length < 2) return AppThresholds.defaultCycleLengthDays;
    final recent = sorted.length > AppThresholds.cycleLengthSampleSize + 1
        ? sorted.sublist(
            sorted.length - AppThresholds.cycleLengthSampleSize - 1,
          )
        : sorted;
    var total = 0;
    for (var i = 1; i < recent.length; i++) {
      total += parseDateKey(recent[i])
          .difference(parseDateKey(recent[i - 1]))
          .inDays;
    }
    final avg = (total / (recent.length - 1)).round();
    return avg.clamp(
      AppThresholds.minCycleLengthDays,
      AppThresholds.maxCycleLengthDays,
    );
  }

  /// Info for [date], or null when no start is on or before it.
  static CycleInfo? infoFor(String date, List<String> starts) {
    final before = starts.where((s) => s.compareTo(date) <= 0).toList()..sort();
    if (before.isEmpty) return null;
    final last = before.last;
    final length = cycleLength(starts);
    final elapsed = parseDateKey(date).difference(parseDateKey(last)).inDays;
    final day = elapsed % length + 1;
    return CycleInfo(
      day: day,
      phase: phaseFor(day, length),
      cycleLength: length,
    );
  }

  /// Menstrual for the first five days, ovulation around 14 days before the
  /// next period, luteal after, follicular between.
  static CyclePhase phaseFor(int day, int length) {
    if (day <= 5) return CyclePhase.menstrual;
    final ovulation = length - 14;
    if (day >= ovulation - 1 && day <= ovulation + 1) {
      return CyclePhase.ovulation;
    }
    return day < ovulation ? CyclePhase.follicular : CyclePhase.luteal;
  }
}
