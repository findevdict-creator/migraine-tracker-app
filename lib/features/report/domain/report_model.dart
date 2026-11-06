import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/insights/domain/factor_insight.dart';
import 'package:migraine_tracker/features/medication/domain/acute_day_counter.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:risk_model/risk_model.dart';

/// Inclusive range of local calendar days.
@immutable
class ReportRange {
  ReportRange(DateTime from, DateTime to)
    : from = from.startOfDay,
      to = to.startOfDay;

  /// The last [days] days ending on [today].
  factory ReportRange.lastDays(int days, {required DateTime today}) =>
      ReportRange(today.subtract(Duration(days: days - 1)), today);

  final DateTime from;
  final DateTime to;

  /// Number of calendar days, at least one.
  int get days => to.difference(from).inDays + 1;

  /// Exclusive end instant, for repository queries.
  DateTime get end => to.add(const Duration(days: 1));

  /// `(year, month)` pairs from [from] to [to].
  List<(int, int)> get months {
    final out = <(int, int)>[];
    var y = from.year;
    var m = from.month;
    while (y < to.year || (y == to.year && m <= to.month)) {
      out.add((y, m));
      m++;
      if (m > 12) {
        m = 1;
        y++;
      }
    }
    return out;
  }

  bool contains(DateTime when) {
    final day = when.toLocal().startOfDay;
    return !day.isBefore(from) && !day.isAfter(to);
  }

  @override
  bool operator ==(Object other) =>
      other is ReportRange && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);
}

/// Everything the report is built from, already limited to the range.
@immutable
class ReportInputs {
  const ReportInputs({
    required this.range,
    required this.generatedAt,
    this.attacks = const [],
    this.medications = const [],
    this.checkins = const [],
    this.weights,
  });

  final ReportRange range;
  final DateTime generatedAt;
  final List<AttackEntity> attacks;
  final List<MedicationEntity> medications;
  final List<CheckinEntity> checkins;
  final WeightTable? weights;
}

/// One calendar month of the range.
@immutable
class MonthStat {
  const MonthStat({
    required this.year,
    required this.month,
    required this.attacks,
    required this.attackDays,
    required this.meanIntensity,
    required this.acuteDays,
    required this.overuse,
  });

  final int year;
  final int month;
  final int attacks;
  final int attackDays;
  final double? meanIntensity;
  final int acuteDays;
  final OveruseNote overuse;
}

/// Duration buckets clinicians look at (untreated migraine runs 4 to 72 h).
enum DurationBucket {
  underFourHours,
  fourToTwelve,
  twelveToTwentyFour,
  oneToThreeDays,
  overThreeDays;

  static DurationBucket of(Duration d) {
    if (d < const Duration(hours: 4)) return underFourHours;
    if (d < const Duration(hours: 12)) return fourToTwelve;
    if (d < const Duration(hours: 24)) return twelveToTwentyFour;
    if (d <= const Duration(hours: 72)) return oneToThreeDays;
    return overThreeDays;
  }
}

@immutable
class DurationStats {
  const DurationStats({
    required this.count,
    required this.shortest,
    required this.median,
    required this.longest,
    required this.buckets,
  });

  factory DurationStats.of(Iterable<Duration> durations) {
    final sorted = durations.toList()..sort();
    if (sorted.isEmpty) {
      return const DurationStats(
        count: 0,
        shortest: null,
        median: null,
        longest: null,
        buckets: {},
      );
    }
    return DurationStats(
      count: sorted.length,
      shortest: sorted.first,
      median: sorted[sorted.length ~/ 2],
      longest: sorted.last,
      buckets: {
        for (final b in DurationBucket.values)
          b: sorted.where((d) => DurationBucket.of(d) == b).length,
      },
    );
  }

  final int count;
  final Duration? shortest;
  final Duration? median;
  final Duration? longest;
  final Map<DurationBucket, int> buckets;
}

/// One medication over the range.
@immutable
class MedicationStat {
  const MedicationStat({
    required this.name,
    required this.kind,
    required this.doses,
    required this.days,
    required this.relief,
  });

  final String name;
  final MedicationKind kind;
  final int doses;

  /// Distinct local days with a dose.
  final int days;

  /// Answered two-hour relief, by answer.
  final Map<Relief, int> relief;
}

/// Attacks that began after a pressure fall against days that had one.
@immutable
class WeatherCorrelation {
  const WeatherCorrelation({
    required this.thresholdHpa,
    required this.attacksWithData,
    required this.attacksAfterFall,
    required this.daysWithData,
    required this.daysAfterFall,
  });

  final double thresholdHpa;
  final int attacksWithData;
  final int attacksAfterFall;
  final int daysWithData;
  final int daysAfterFall;

  double? get attackShare =>
      attacksWithData == 0 ? null : attacksAfterFall / attacksWithData;

  double? get dayShare =>
      daysWithData == 0 ? null : daysAfterFall / daysWithData;

  /// Attack share over the day share; 1 means no relation. Null until
  /// both sides have data.
  double? get lift {
    final a = attackShare;
    final d = dayShare;
    if (a == null || d == null || d == 0) return null;
    return (a / d * 100).roundToDouble() / 100;
  }
}

/// The numbers the PDF and the preview show.
@immutable
class ReportSummary {
  const ReportSummary({
    required this.inputs,
    required this.attacks,
    required this.attackDays,
    required this.meanIntensity,
    required this.durations,
    required this.months,
    required this.calendar,
    required this.triggers,
    required this.medications,
    required this.acuteDays,
    required this.weather,
    required this.symptoms,
    required this.locations,
    required this.checkinDays,
  });

  final ReportInputs inputs;
  final int attacks;
  final int attackDays;
  final double? meanIntensity;
  final DurationStats durations;
  final List<MonthStat> months;

  /// Date key to the day's highest intensity (null when unrated), only for
  /// days with an attack.
  final Map<String, int?> calendar;
  final List<FactorInsight> triggers;
  final List<MedicationStat> medications;

  /// Distinct days with an acute dose over the whole range.
  final int acuteDays;
  final WeatherCorrelation weather;
  final Map<Symptom, int> symptoms;
  final Map<HeadLocation, int> locations;
  final int checkinDays;

  ReportRange get range => inputs.range;

  /// Attacks per 30 days, for ranges of any length.
  double get attacksPerMonth => attacks / range.days * 30;

  bool get isEmpty => attacks == 0 && medications.isEmpty && checkinDays == 0;
}

/// Pure: same inputs, same summary.
abstract final class ReportBuilder {
  static ReportSummary build(ReportInputs inputs) {
    final range = inputs.range;
    final attacks = inputs.attacks
        .where((a) => range.contains(a.startedAt))
        .toList();
    final calendar = <String, int?>{};
    for (final a in attacks) {
      final key = a.startedAt.toLocal().dateKey;
      final current = calendar[key];
      final i = a.intensity;
      calendar[key] = current == null || (i != null && i > current)
          ? i
          : current;
    }
    final rated = attacks.map((a) => a.intensity).nonNulls.toList();
    final meanIntensity = rated.isEmpty
        ? null
        : rated.fold<int>(0, (a, b) => a + b) / rated.length;

    final months = <MonthStat>[];
    for (final (y, m) in range.months) {
      final inMonth = attacks
          .where(
            (a) =>
                a.startedAt.toLocal().year == y &&
                a.startedAt.toLocal().month == m,
          )
          .toList();
      final ratedMonth = inMonth.map((a) => a.intensity).nonNulls.toList();
      final acute = AcuteDayCounter.daysInMonth(
        inputs.medications,
        year: y,
        month: m,
      );
      months.add(
        MonthStat(
          year: y,
          month: m,
          attacks: inMonth.length,
          attackDays: inMonth
              .map((a) => a.startedAt.toLocal().dateKey)
              .toSet()
              .length,
          meanIntensity: ratedMonth.isEmpty
              ? null
              : ratedMonth.fold<int>(0, (a, b) => a + b) / ratedMonth.length,
          acuteDays: acute,
          overuse: OveruseNote.forDays(acute),
        ),
      );
    }

    final byName = <String, List<MedicationEntity>>{};
    for (final e in inputs.medications) {
      if (!range.contains(e.takenAt)) continue;
      byName.putIfAbsent(e.name, () => []).add(e);
    }
    final medications = [
      for (final e in byName.entries)
        MedicationStat(
          name: e.key,
          kind: e.value.first.kind,
          doses: e.value.length,
          days: e.value.map((d) => d.takenAt.toLocal().dateKey).toSet().length,
          relief: {
            for (final r in Relief.values)
              r: e.value.where((d) => d.reliefAt2h == r).length,
          },
        ),
    ]..sort((a, b) => b.doses.compareTo(a.doses));
    final acuteDays = inputs.medications
        .where((e) => e.isAcute && range.contains(e.takenAt))
        .map((e) => e.takenAt.toLocal().dateKey)
        .toSet()
        .length;

    final symptoms = <Symptom, int>{};
    final locations = <HeadLocation, int>{};
    for (final a in attacks) {
      for (final s in a.symptoms.map((t) => t.symptom).toSet()) {
        symptoms[s] = (symptoms[s] ?? 0) + 1;
      }
      for (final l in a.headLocations) {
        locations[l] = (locations[l] ?? 0) + 1;
      }
    }

    final checkins = inputs.checkins
        .where((c) => range.contains(parseDateKey(c.date)))
        .toList();

    return ReportSummary(
      inputs: inputs,
      attacks: attacks.length,
      attackDays: calendar.length,
      meanIntensity: meanIntensity,
      durations: DurationStats.of(attacks.map((a) => a.duration).nonNulls),
      months: months,
      calendar: calendar,
      triggers: factorInsights(inputs.weights),
      medications: medications,
      acuteDays: acuteDays,
      weather: _weather(attacks, checkins),
      symptoms: symptoms,
      locations: locations,
      checkinDays: checkins.length,
    );
  }

  static const double _fallHpa = AppThresholds.defaultPressureDropAlertHpa;

  static bool? _fell(Map<String, Object?>? weather) {
    final delta = weather?['delta24h'];
    if (delta is! num) return null;
    return delta <= -_fallHpa;
  }

  static WeatherCorrelation _weather(
    List<AttackEntity> attacks,
    List<CheckinEntity> checkins,
  ) {
    final attackFalls = attacks.map((a) => _fell(a.weather)).nonNulls.toList();
    final dayFalls = checkins.map((c) => _fell(c.weather)).nonNulls.toList();
    return WeatherCorrelation(
      thresholdHpa: _fallHpa,
      attacksWithData: attackFalls.length,
      attacksAfterFall: attackFalls.where((f) => f).length,
      daysWithData: dayFalls.length,
      daysAfterFall: dayFalls.where((f) => f).length,
    );
  }
}
