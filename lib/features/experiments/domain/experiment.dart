import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';

/// The changes a person can test (FR-12). The code is stored.
enum ExperimentChange {
  cutCaffeine('cut_caffeine'),
  regularSleep('regular_sleep'),
  moreWater('more_water'),
  dailyStretches('daily_stretches'),
  lessScreens('less_screens'),
  noAlcohol('no_alcohol');

  ExperimentChange(this.code);

  final String code;

  static ExperimentChange? fromCode(String code) =>
      values.where((c) => c.code == code).firstOrNull;
}

enum ExperimentStatus {
  active,
  completed,
  abandoned;

  static ExperimentStatus fromCode(String code) =>
      values.where((s) => s.name == code).firstOrNull ?? abandoned;
}

/// One two-week experiment. [start] is local midnight of the first day.
@immutable
class ExperimentEntity {
  const ExperimentEntity({
    required this.id,
    required this.change,
    required this.start,
    this.end,
    this.adherence = const {},
    this.status = ExperimentStatus.active,
    this.result,
  });

  final String id;
  final ExperimentChange change;
  final DateTime start;
  final DateTime? end;

  /// `yyyy-MM-dd` to whether the person kept to the change that day.
  final Map<String, bool> adherence;
  final ExperimentStatus status;

  /// The comparison frozen when the experiment finished.
  final ExperimentComparison? result;

  bool get isActive => status == ExperimentStatus.active;

  /// The last day of the two weeks, exclusive.
  DateTime get windowEnd =>
      start.add(const Duration(days: AppThresholds.experimentWindowDays));

  /// 1-based day of the experiment on [now], capped at the window.
  int dayOn(DateTime now) {
    final days = now.startOfDay.difference(start).inDays + 1;
    return days.clamp(1, AppThresholds.experimentWindowDays);
  }

  /// Whether the two weeks are over on [now].
  bool isDueOn(DateTime now) => !now.isBefore(windowEnd);

  int get daysKept => adherence.values.where((v) => v).length;

  ExperimentEntity copyWith({
    DateTime? end,
    Map<String, bool>? adherence,
    ExperimentStatus? status,
    ExperimentComparison? result,
  }) => ExperimentEntity(
    id: id,
    change: change,
    start: start,
    end: end ?? this.end,
    adherence: adherence ?? this.adherence,
    status: status ?? this.status,
    result: result ?? this.result,
  );
}

/// Attack numbers for one period.
@immutable
class PeriodStats {
  const PeriodStats({
    required this.days,
    required this.attacks,
    this.meanIntensity,
    this.intensityCount = 0,
    this.medianDuration,
    this.durationCount = 0,
  });

  factory PeriodStats.of(Iterable<AttackEntity> attacks, int days) {
    final list = attacks.toList();
    final intensities = [
      for (final a in list)
        if (a.intensity != null) a.intensity!,
    ];
    final durations = [
      for (final a in list)
        if (a.duration != null) a.duration!,
    ]..sort();
    return PeriodStats(
      days: days,
      attacks: list.length,
      meanIntensity: intensities.isEmpty
          ? null
          : intensities.reduce((a, b) => a + b) / intensities.length,
      intensityCount: intensities.length,
      medianDuration: durations.isEmpty ? null : _median(durations),
      durationCount: durations.length,
    );
  }

  factory PeriodStats.fromJson(Map<String, Object?> json) {
    final mean = json['meanIntensity'];
    final median = json['medianMinutes'];
    return PeriodStats(
      days: json['days'] as int? ?? 0,
      attacks: json['attacks'] as int? ?? 0,
      meanIntensity: mean is num ? mean.toDouble() : null,
      intensityCount: json['intensityCount'] as int? ?? 0,
      medianDuration: median is int ? Duration(minutes: median) : null,
      durationCount: json['durationCount'] as int? ?? 0,
    );
  }

  /// Days the period covers so far.
  final int days;
  final int attacks;
  final double? meanIntensity;

  /// Attacks with an intensity, behind [meanIntensity].
  final int intensityCount;
  final Duration? medianDuration;

  /// Finished attacks, behind [medianDuration].
  final int durationCount;

  /// Attacks per seven days; null before the first full day.
  double? get perWeek => days == 0 ? null : attacks * 7 / days;

  /// Too few attacks to compare (`AppThresholds.experimentMinAttacks`).
  bool get small => attacks < AppThresholds.experimentMinAttacks;

  Map<String, Object?> toJson() => {
    'days': days,
    'attacks': attacks,
    'meanIntensity': meanIntensity,
    'intensityCount': intensityCount,
    'medianMinutes': medianDuration?.inMinutes,
    'durationCount': durationCount,
  };

  static Duration _median(List<Duration> sorted) {
    final mid = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[mid];
    return (sorted[mid - 1] + sorted[mid]) ~/ 2;
  }
}

/// The two weeks before the start against the experiment days so far.
@immutable
class ExperimentComparison {
  const ExperimentComparison({required this.before, required this.during});

  /// Compares [attacks] in the window before [experiment] started with the
  /// experiment days up to [now]. Attacks count in the period they started.
  factory ExperimentComparison.build(
    ExperimentEntity experiment,
    Iterable<AttackEntity> attacks,
    DateTime now,
  ) {
    const window = Duration(days: AppThresholds.experimentWindowDays);
    final start = experiment.start;
    final beforeFrom = start.subtract(window);
    final duringTo = now.isBefore(experiment.windowEnd)
        ? now
        : experiment.windowEnd;
    bool within(AttackEntity a, DateTime from, DateTime to) =>
        !a.startedAt.isBefore(from) && a.startedAt.isBefore(to);
    final list = attacks.toList();
    final duringDays = duringTo.isAfter(start)
        ? (duringTo.difference(start).inHours / 24).ceil().clamp(
            0,
            AppThresholds.experimentWindowDays,
          )
        : 0;
    return ExperimentComparison(
      before: PeriodStats.of(
        list.where((a) => within(a, beforeFrom, start)),
        AppThresholds.experimentWindowDays,
      ),
      during: PeriodStats.of(
        list.where((a) => within(a, start, duringTo)),
        duringDays,
      ),
    );
  }

  factory ExperimentComparison.fromJson(Map<String, Object?> json) =>
      ExperimentComparison(
        before: PeriodStats.fromJson(
          (json['before'] as Map?)?.cast<String, Object?>() ?? const {},
        ),
        during: PeriodStats.fromJson(
          (json['during'] as Map?)?.cast<String, Object?>() ?? const {},
        ),
      );

  final PeriodStats before;
  final PeriodStats during;

  /// Either period has too few attacks to say much.
  bool get small => before.small || during.small;

  Map<String, Object?> toJson() => {
    'before': before.toJson(),
    'during': during.toJson(),
  };
}
