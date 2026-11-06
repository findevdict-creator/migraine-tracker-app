import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/units/units.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_screen.dart';
import 'package:migraine_tracker/features/attack_log/presentation/head_map.dart';
import 'package:migraine_tracker/features/insights/domain/factor_insight.dart';
import 'package:migraine_tracker/features/medication/domain/acute_day_counter.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:migraine_tracker/features/questionnaires/presentation/questionnaire_controller.dart';
import 'package:migraine_tracker/features/report/domain/report_document.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_text.dart';

/// Writes a [ReportSummary] as a [ReportDocument]: every string comes from
/// [AppLocalizations] or a locale-formatted number. The copy avoids
/// typographic dashes because the PDF uses Latin-1 fonts.
class ReportContent {
  ReportContent(this.l10n, {String? locale, this.units = const Units()})
    : _locale = locale ?? AppLocales.fallback.toString();

  final AppLocalizations l10n;
  final Units units;
  final String _locale;

  ReportDocument build(ReportSummary r, {bool includeQuestionnaires = true}) =>
      ReportDocument(
        title: l10n.reportPdfTitle(AppIdentity.name),
        period: l10n.reportPdfPeriod(
          _date(r.range.from),
          _date(r.range.to),
          r.range.days,
        ),
        generated: l10n.reportPdfGenerated(_date(r.inputs.generatedAt)),
        footer: AppIdentity.name,
        disclaimer: l10n.reportPdfDisclaimer,
        lang: l10n.localeName,
        blocks: [
          HeadingBlock(l10n.reportSectionOverview),
          _overview(r),
          HeadingBlock(l10n.reportSectionMonths),
          _months(r),
          HeadingBlock(l10n.reportSectionCalendar),
          HintBlock(l10n.reportCalendarHint),
          ..._calendar(r),
          HeadingBlock(l10n.reportSectionDuration),
          ..._duration(r),
          HeadingBlock(l10n.reportSectionTriggers),
          HintBlock(
            l10n.reportTriggersHint(AppThresholds.minExposuresForInsight),
          ),
          _triggers(r),
          HeadingBlock(l10n.reportSectionMedications),
          _medications(r),
          HeadingBlock(l10n.reportSectionWeather),
          HintBlock(
            l10n.reportWeatherHint(
              units.pressureChange(l10n, r.weather.thresholdHpa),
            ),
          ),
          ..._weather(r),
          HeadingBlock(l10n.reportSectionSymptoms),
          _symptoms(r),
          if (includeQuestionnaires) ...[
            HeadingBlock(l10n.reportSectionQuestionnaires),
            _questionnaires(r),
          ],
        ],
      );

  // Formatting helpers.

  String _date(DateTime d) => DateFormat.yMMMd(_locale).format(d);

  String _month(int year, int month) =>
      DateFormat.yMMM(_locale).format(DateTime(year, month));

  String _num(double value, {int decimals = 1}) =>
      NumberFormat.decimalPatternDigits(
        locale: _locale,
        decimalDigits: decimals,
      ).format(value);

  String _hours(Duration d) => l10n.reportHoursShort(
    _num(d.inMinutes / 60, decimals: d.inMinutes % 60 == 0 ? 0 : 1),
  );

  String _opt(double? value) => value == null ? '-' : _num(value);

  // Blocks.

  ReportBlock _overview(ReportSummary r) => StatsBlock([
    (label: l10n.reportStatAttacks, value: '${r.attacks}'),
    (label: l10n.reportStatAttackDays, value: '${r.attackDays}'),
    (label: l10n.reportStatPerMonth, value: _num(r.attacksPerMonth)),
    (label: l10n.reportStatMeanIntensity, value: _opt(r.meanIntensity)),
    (label: l10n.reportStatAcuteDays, value: '${r.acuteDays}'),
    (label: l10n.reportStatCheckins, value: '${r.checkinDays}'),
  ]);

  String _overuse(OveruseNote note) => switch (note) {
    OveruseNote.none => '',
    OveruseNote.first => l10n.reportOveruseWatch,
    OveruseNote.second => l10n.reportOveruseHigh,
  };

  ReportBlock _months(ReportSummary r) => TableBlock(
    header: [
      l10n.reportColMonth,
      l10n.reportColAttacks,
      l10n.reportColAttackDays,
      l10n.reportColMeanIntensity,
      l10n.reportColAcuteDays,
      l10n.reportColNote,
    ],
    rows: [
      for (final m in r.months)
        [
          _month(m.year, m.month),
          '${m.attacks}',
          '${m.attackDays}',
          _opt(m.meanIntensity),
          '${m.acuteDays}',
          _overuse(m.overuse),
        ],
    ],
  );

  List<ReportBlock> _calendar(ReportSummary r) => [
    for (final (year, month) in r.range.months)
      CalendarBlock(
        title: _month(year, month),
        leadingBlanks: (DateTime(year, month).weekday - 1) % 7,
        days: [
          for (var d = 1; d <= DateTime(year, month + 1, 0).day; d++)
            CalendarDay(
              day: d,
              inRange: r.range.contains(DateTime(year, month, d)),
              attack: r.calendar.containsKey(DateTime(year, month, d).dateKey),
              intensity: r.calendar[DateTime(year, month, d).dateKey],
            ),
        ],
      ),
  ];

  String _bucket(DurationBucket b) => switch (b) {
    DurationBucket.underFourHours => l10n.reportBucketUnderFour,
    DurationBucket.fourToTwelve => l10n.reportBucketFourToTwelve,
    DurationBucket.twelveToTwentyFour => l10n.reportBucketTwelveToDay,
    DurationBucket.oneToThreeDays => l10n.reportBucketOneToThreeDays,
    DurationBucket.overThreeDays => l10n.reportBucketOverThreeDays,
  };

  List<ReportBlock> _duration(ReportSummary r) {
    final d = r.durations;
    if (d.count == 0) return [TextBlock(l10n.reportDurationNone)];
    return [
      TextBlock(
        l10n.reportDurationSummary(
          d.count,
          _hours(d.shortest!),
          _hours(d.median!),
          _hours(d.longest!),
        ),
      ),
      TableBlock(
        header: [for (final b in DurationBucket.values) _bucket(b)],
        rows: [
          [for (final b in DurationBucket.values) '${d.buckets[b] ?? 0}'],
        ],
      ),
    ];
  }

  String _confidence(double c) {
    const bands = AppThresholds.riskConfidenceBands;
    if (c < bands[0]) return l10n.reportConfidenceLow;
    if (c < bands[1]) return l10n.reportConfidenceMedium;
    return l10n.reportConfidenceHigh;
  }

  ReportBlock _triggers(ReportSummary r) {
    final rows = r.triggers
        .where((t) => t.bucket != InsightBucket.notEnoughData)
        .toList();
    if (rows.isEmpty) return TextBlock(l10n.reportTriggersNone);
    final weights = r.inputs.weights;
    return TableBlock(
      header: [
        l10n.reportColFactor,
        l10n.reportColRatio,
        l10n.reportColExposures,
        l10n.reportColFollowed,
        l10n.reportColConfidence,
      ],
      rows: [
        for (final t in rows)
          [
            factorLabel(l10n, t.factor),
            '${_num(t.lift, decimals: 2)}x',
            '${t.exposures}',
            '${t.attacksAfter}',
            if (weights == null)
              '-'
            else
              _confidence(weights[t.factor].confidence),
          ],
      ],
    );
  }

  ReportBlock _medications(ReportSummary r) {
    if (r.medications.isEmpty) return TextBlock(l10n.reportMedicationsNone);
    return TableBlock(
      header: [
        l10n.reportColMedication,
        l10n.reportColKind,
        l10n.reportColDoses,
        l10n.reportColDays,
        l10n.reportColRelief,
      ],
      rows: [
        for (final m in r.medications)
          [
            m.name,
            if (m.kind == MedicationKind.acute)
              l10n.reportKindAcute
            else
              l10n.reportKindPreventive,
            '${m.doses}',
            '${m.days}',
            if (m.kind == MedicationKind.acute)
              '${m.relief[Relief.none] ?? 0} / '
                  '${m.relief[Relief.partial] ?? 0} / '
                  '${m.relief[Relief.full] ?? 0}'
            else
              '',
          ],
      ],
    );
  }

  List<ReportBlock> _weather(ReportSummary r) {
    final w = r.weather;
    if (w.attacksWithData == 0 && w.daysWithData == 0) {
      return [TextBlock(l10n.reportWeatherNone)];
    }
    final lift = w.lift;
    return [
      TextBlock(
        l10n.reportWeatherAttacks(w.attacksAfterFall, w.attacksWithData),
      ),
      TextBlock(l10n.reportWeatherDays(w.daysAfterFall, w.daysWithData)),
      if (lift != null)
        TextBlock(l10n.reportWeatherLift(_num(lift, decimals: 2))),
    ];
  }

  ReportBlock _questionnaires(ReportSummary r) {
    if (r.questionnaires.isEmpty) {
      return TextBlock(l10n.reportQuestionnairesNone);
    }
    return TableBlock(
      header: [
        l10n.reportColDate,
        l10n.reportColQuestionnaire,
        l10n.reportColScore,
        l10n.reportColBand,
      ],
      rows: [
        for (final q in r.questionnaires)
          [
            _date(q.completedAt),
            questionnaireTitle(l10n, q.kind),
            '${q.score}',
            bandLabel(l10n, q.kind, q.band),
          ],
      ],
    );
  }

  ReportBlock _symptoms(ReportSummary r) {
    if (r.symptoms.isEmpty && r.locations.isEmpty) {
      return TextBlock(l10n.reportSymptomsNone);
    }
    List<String> lines<T>(Map<T, int> counts, String Function(T) label) {
      final entries = counts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      return [
        for (final e in entries)
          l10n.reportCountOfAttacks(label(e.key), e.value, r.attacks),
      ];
    }

    return ColumnsBlock([
      lines(r.symptoms, (s) => symptomLabel(l10n, s)),
      lines(r.locations, (h) => headLocationLabel(l10n, h)),
    ]);
  }
}
