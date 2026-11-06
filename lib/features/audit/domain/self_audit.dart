import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:risk_model/risk_model.dart';

/// The five numbers of the accuracy self-audit (FR-13), for one period.
@immutable
class AuditCounts {
  const AuditCounts({
    this.attacks = 0,
    this.hits = 0,
    this.highDays = 0,
    this.falseAlarms = 0,
  });

  static const zero = AuditCounts();

  /// Attacks with a shown level for their window; the rest are not scored.
  final int attacks;

  /// Scored attacks that followed a High day.
  final int hits;

  /// High days whose outcome is known (their window has passed).
  final int highDays;

  /// High days with no attack in their window.
  final int falseAlarms;

  /// Scored attacks with no High day in their window.
  int get misses => attacks - hits;

  bool get isEmpty => attacks == 0 && highDays == 0;

  /// Share of scored attacks that followed a High day; null with none.
  double? get hitShare => attacks == 0 ? null : hits / attacks;

  /// Share of High days with no attack; null with none.
  double? get falseAlarmShare => highDays == 0 ? null : falseAlarms / highDays;

  AuditCounts operator +(AuditCounts o) => AuditCounts(
    attacks: attacks + o.attacks,
    hits: hits + o.hits,
    highDays: highDays + o.highDays,
    falseAlarms: falseAlarms + o.falseAlarms,
  );

  @override
  bool operator ==(Object other) =>
      other is AuditCounts &&
      other.attacks == attacks &&
      other.hits == hits &&
      other.highDays == highDays &&
      other.falseAlarms == falseAlarms;

  @override
  int get hashCode => Object.hash(attacks, hits, highDays, falseAlarms);

  @override
  String toString() =>
      'AuditCounts(attacks: $attacks, hits: $hits, highDays: $highDays, '
      'falseAlarms: $falseAlarms)';
}

/// The whole audit: totals and counts per calendar month (`yyyy-MM`).
@immutable
class AuditResult {
  const AuditResult({required this.total, required this.byMonth});

  final AuditCounts total;

  /// Oldest month first; only months with something scored.
  final Map<String, AuditCounts> byMonth;
}

/// Scores the frozen levels against when attacks started. Pure: dates are
/// `yyyy-MM-dd` keys, so the result never depends on the clock beyond
/// `today`.
abstract final class SelfAudit {
  static AuditResult compute({
    required Map<String, RiskLevel> shown,
    required List<String> attackDates,
    required String today,
    int window = AppThresholds.auditWindowDays,
  }) {
    final byMonth = <String, AuditCounts>{};
    void add(String date, AuditCounts c) => byMonth[monthOf(date)] =
        (byMonth[monthOf(date)] ?? AuditCounts.zero) + c;

    for (final date in attackDates) {
      if (date.compareTo(today) > 0) continue;
      final days = [for (var k = 0; k <= window; k++) shift(date, -k)];
      final levels = [for (final d in days) ?shown[d]];
      if (levels.isEmpty) continue;
      add(
        date,
        AuditCounts(attacks: 1, hits: levels.contains(RiskLevel.high) ? 1 : 0),
      );
    }

    final starts = attackDates.toSet();
    for (final MapEntry(key: date, value: level) in shown.entries) {
      if (level != RiskLevel.high) continue;
      // The outcome is known once the whole window lies before today.
      if (shift(date, window).compareTo(today) >= 0) continue;
      final hadAttack = [for (var k = 0; k <= window; k++) shift(date, k)]
          .any(starts.contains);
      add(date, AuditCounts(highDays: 1, falseAlarms: hadAttack ? 0 : 1));
    }

    final months = byMonth.keys.toList()..sort();
    return AuditResult(
      total: byMonth.values.fold(AuditCounts.zero, (a, b) => a + b),
      byMonth: {for (final m in months) m: byMonth[m]!},
    );
  }

  static String monthOf(String date) => date.substring(0, 7);

  /// The date key [days] away, in calendar days.
  static String shift(String date, int days) {
    final d = DateTime.utc(
      int.parse(date.substring(0, 4)),
      int.parse(date.substring(5, 7)),
      int.parse(date.substring(8, 10)),
    ).add(Duration(days: days));
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  /// The calendar month before the one [today] falls in.
  static String previousMonth(String today) {
    final y = int.parse(today.substring(0, 4));
    final m = int.parse(today.substring(5, 7));
    final py = m == 1 ? y - 1 : y;
    final pm = m == 1 ? 12 : m - 1;
    return '$py-${pm.toString().padLeft(2, '0')}';
  }
}
