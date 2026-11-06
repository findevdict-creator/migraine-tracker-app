import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';

/// Which past attacks the estimate came from, most specific first.
enum EstimateBasis {
  /// Similar intensity and the same medication.
  sameMedication,

  /// Similar intensity and, like this attack so far, no medication.
  noMedication,

  /// Similar intensity, any medication.
  similarIntensity,

  /// Every completed attack.
  allAttacks,
}

/// "Typically 4 to 7 h (based on 8 attacks)": a range, never one figure.
@immutable
class DurationEstimate {
  const DurationEstimate({
    required this.low,
    required this.high,
    required this.sample,
    required this.basis,
  });

  final Duration low;
  final Duration high;
  final int sample;
  final EstimateBasis basis;

  @override
  bool operator ==(Object other) =>
      other is DurationEstimate &&
      other.low == low &&
      other.high == high &&
      other.sample == sample &&
      other.basis == basis;

  @override
  int get hashCode => Object.hash(low, high, sample, basis);

  @override
  String toString() => 'DurationEstimate($low-$high, n=$sample, $basis)';
}

/// FR-5: the middle half of past durations for attacks like this one.
abstract final class DurationEstimator {
  /// [medsByAttack] maps attack ids to the acute medication names taken
  /// for them. Returns null until there are enough completed attacks.
  static DurationEstimate? estimate({
    required AttackEntity running,
    required Iterable<AttackEntity> attacks,
    required Map<String, Set<String>> medsByAttack,
  }) {
    final completed = [
      for (final a in attacks)
        if (a.id != running.id && (a.duration ?? Duration.zero) > Duration.zero)
          a,
    ];
    const min = AppThresholds.durationEstimateMinAttacks;
    if (completed.length < min) return null;

    final runningMeds = medsByAttack[running.id] ?? const <String>{};
    bool similar(AttackEntity a) {
      final mine = running.intensity;
      if (mine == null) return true;
      final theirs = a.intensity;
      return theirs != null &&
          (theirs - mine).abs() <= AppThresholds.durationIntensityBand;
    }

    bool sameMeds(AttackEntity a) {
      final theirs = medsByAttack[a.id] ?? const <String>{};
      return runningMeds.isEmpty
          ? theirs.isEmpty
          : theirs.any(runningMeds.contains);
    }

    final similarOnes = completed.where(similar).toList();
    final groups = [
      (
        runningMeds.isEmpty
            ? EstimateBasis.noMedication
            : EstimateBasis.sameMedication,
        similarOnes.where(sameMeds).toList(),
      ),
      (EstimateBasis.similarIntensity, similarOnes),
      (EstimateBasis.allAttacks, completed),
    ];
    for (final (basis, group) in groups) {
      if (group.length < min) continue;
      final durations = [for (final a in group) a.duration!]..sort();
      final (low, high) = _rounded(
        _quantile(durations, 0.25),
        _quantile(durations, 0.75),
      );
      return DurationEstimate(
        low: low,
        high: high,
        sample: group.length,
        basis: basis,
      );
    }
    return null;
  }

  /// Linear interpolation between the closest ranks.
  static Duration _quantile(List<Duration> sorted, double q) {
    final pos = (sorted.length - 1) * q;
    final lo = pos.floor();
    final hi = pos.ceil();
    final frac = pos - lo;
    final us =
        sorted[lo].inMicroseconds +
        (sorted[hi].inMicroseconds - sorted[lo].inMicroseconds) * frac;
    return Duration(microseconds: us.round());
  }

  /// Widens to whole steps, so the ends are never equal.
  static (Duration, Duration) _rounded(Duration low, Duration high) {
    final step = high < AppThresholds.durationFineStepBelow
        ? const Duration(minutes: 30)
        : const Duration(hours: 1);
    final s = step.inMinutes;
    var lo = (low.inMinutes ~/ s) * s;
    var hi = ((high.inMinutes + s - 1) ~/ s) * s;
    if (lo < s) lo = s;
    if (hi <= lo) hi = lo + s;
    return (Duration(minutes: lo), Duration(minutes: hi));
  }
}
