import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_screen.dart';
import 'package:migraine_tracker/features/attack_log/presentation/head_map.dart';
import 'package:migraine_tracker/features/insights/domain/factor_insight.dart';
import 'package:migraine_tracker/features/medication/domain/acute_day_counter.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_text.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Renders a [ReportSummary] as an A4 PDF. Pure layout: every string comes
/// from [AppLocalizations] or a formatted number, so the document follows
/// the app's language. Uses the built-in Helvetica fonts (Latin-1), which
/// is why the copy avoids typographic dashes.
class ReportPdf {
  ReportPdf(this.l10n, {String? locale})
    : _locale = locale ?? AppLocales.fallback.toString();

  final AppLocalizations l10n;
  final String _locale;

  static const _ink = PdfColor.fromInt(0xFF1F2933);
  static const _muted = PdfColor.fromInt(0xFF6B7280);
  static const _rule = PdfColor.fromInt(0xFFD1D5DB);
  static const _tileFill = PdfColor.fromInt(0xFFF3F4F6);
  static const _calendarFills = [
    PdfColor.fromInt(0xFFFDE68A),
    PdfColor.fromInt(0xFFFCA5A5),
    PdfColor.fromInt(0xFFEF4444),
  ];

  Future<Uint8List> build(ReportSummary report) async {
    final doc =
        pw.Document(
          title: l10n.reportPdfTitle(AppIdentity.name),
          author: AppIdentity.name,
          creator: AppIdentity.name,
        )..addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(40),
            theme:
                pw.ThemeData.withFont(
                  base: pw.Font.helvetica(),
                  bold: pw.Font.helveticaBold(),
                ).copyWith(
                  defaultTextStyle: const pw.TextStyle(
                    fontSize: 10,
                    color: _ink,
                  ),
                ),
            footer: (context) => pw.Padding(
              padding: const pw.EdgeInsets.only(top: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    AppIdentity.name,
                    style: const pw.TextStyle(fontSize: 8, color: _muted),
                  ),
                  pw.Text(
                    l10n.reportPdfPage(context.pageNumber, context.pagesCount),
                    style: const pw.TextStyle(fontSize: 8, color: _muted),
                  ),
                ],
              ),
            ),
            build: (context) => [
              _header(report),
              _section(l10n.reportSectionOverview),
              _overview(report),
              _section(l10n.reportSectionMonths),
              _months(report),
              _section(l10n.reportSectionCalendar),
              _hint(l10n.reportCalendarHint),
              ..._calendar(report),
              _section(l10n.reportSectionDuration),
              _duration(report),
              _section(l10n.reportSectionTriggers),
              _hint(
                l10n.reportTriggersHint(AppThresholds.minExposuresForInsight),
              ),
              _triggers(report),
              _section(l10n.reportSectionMedications),
              _medications(report),
              _section(l10n.reportSectionWeather),
              _hint(l10n.reportWeatherHint(_num(report.weather.thresholdHpa))),
              _weather(report),
              _section(l10n.reportSectionSymptoms),
              _symptoms(report),
              pw.SizedBox(height: 16),
              pw.Text(
                l10n.reportPdfDisclaimer,
                style: const pw.TextStyle(fontSize: 8, color: _muted),
              ),
            ],
          ),
        );
    return await doc.save();
  }

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

  pw.Widget _header(ReportSummary r) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        l10n.reportPdfTitle(AppIdentity.name),
        style: const pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        l10n.reportPdfPeriod(
          _date(r.range.from),
          _date(r.range.to),
          r.range.days,
        ),
      ),
      pw.Text(
        l10n.reportPdfGenerated(_date(r.inputs.generatedAt)),
        style: const pw.TextStyle(color: _muted),
      ),
      pw.SizedBox(height: 6),
      pw.Divider(color: _rule, thickness: 0.5),
    ],
  );

  pw.Widget _section(String title) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 14, bottom: 6),
    child: pw.Text(
      title,
      style: const pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
    ),
  );

  pw.Widget _hint(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Text(text, style: const pw.TextStyle(color: _muted)),
  );

  pw.Widget _tile(String label, String value) => pw.Expanded(
    child: pw.Container(
      margin: const pw.EdgeInsets.only(right: 6),
      padding: const pw.EdgeInsets.all(8),
      decoration: const pw.BoxDecoration(
        color: _tileFill,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: _muted)),
        ],
      ),
    ),
  );

  pw.Widget _overview(ReportSummary r) => pw.Column(
    children: [
      pw.Row(
        children: [
          _tile(l10n.reportStatAttacks, '${r.attacks}'),
          _tile(l10n.reportStatAttackDays, '${r.attackDays}'),
          _tile(l10n.reportStatPerMonth, _num(r.attacksPerMonth)),
        ],
      ),
      pw.SizedBox(height: 6),
      pw.Row(
        children: [
          _tile(l10n.reportStatMeanIntensity, _opt(r.meanIntensity)),
          _tile(l10n.reportStatAcuteDays, '${r.acuteDays}'),
          _tile(l10n.reportStatCheckins, '${r.checkinDays}'),
        ],
      ),
    ],
  );

  pw.Widget _table(List<String> header, List<List<String>> rows) =>
      pw.TableHelper.fromTextArray(
        headers: header,
        data: rows,
        border: null,
        headerStyle: const pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 9,
        ),
        headerDecoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _rule, width: 0.5)),
        ),
        cellStyle: const pw.TextStyle(fontSize: 9),
        cellPadding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 4),
        rowDecoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _rule, width: 0.25)),
        ),
      );

  String _overuse(OveruseNote note) => switch (note) {
    OveruseNote.none => '',
    OveruseNote.first => l10n.reportOveruseWatch,
    OveruseNote.second => l10n.reportOveruseHigh,
  };

  pw.Widget _months(ReportSummary r) => _table(
    [
      l10n.reportColMonth,
      l10n.reportColAttacks,
      l10n.reportColAttackDays,
      l10n.reportColMeanIntensity,
      l10n.reportColAcuteDays,
      l10n.reportColNote,
    ],
    [
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

  List<pw.Widget> _calendar(ReportSummary r) {
    final out = <pw.Widget>[];
    for (final (year, month) in r.range.months) {
      final first = DateTime(year, month);
      final daysInMonth = DateTime(year, month + 1, 0).day;
      final leading = (first.weekday - 1) % 7;
      final cells = <pw.Widget>[
        for (var i = 0; i < leading; i++) pw.SizedBox(),
      ];
      for (var d = 1; d <= daysInMonth; d++) {
        final day = DateTime(year, month, d);
        final key = day.dateKey;
        final inRange = r.range.contains(day);
        final hasAttack = r.calendar.containsKey(key);
        final intensity = r.calendar[key];
        cells.add(
          pw.Container(
            height: 16,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              color: hasAttack ? _calendarFill(intensity) : null,
              border: pw.Border.all(color: _rule, width: 0.25),
            ),
            child: pw.Text(
              hasAttack && intensity != null ? '$intensity' : '$d',
              style: pw.TextStyle(
                fontSize: 7,
                color: inRange ? _ink : _rule,
                fontWeight: hasAttack ? pw.FontWeight.bold : null,
              ),
            ),
          ),
        );
      }
      while (cells.length % 7 != 0) {
        cells.add(pw.SizedBox());
      }
      out.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                _month(year, month),
                style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 2),
              pw.GridView(
                crossAxisCount: 7,
                childAspectRatio: 1 / 4.4,
                children: cells,
              ),
            ],
          ),
        ),
      );
    }
    return out;
  }

  PdfColor _calendarFill(int? intensity) {
    if (intensity == null || intensity <= 3) return _calendarFills[0];
    if (intensity <= 6) return _calendarFills[1];
    return _calendarFills[2];
  }

  String _bucket(DurationBucket b) => switch (b) {
    DurationBucket.underFourHours => l10n.reportBucketUnderFour,
    DurationBucket.fourToTwelve => l10n.reportBucketFourToTwelve,
    DurationBucket.twelveToTwentyFour => l10n.reportBucketTwelveToDay,
    DurationBucket.oneToThreeDays => l10n.reportBucketOneToThreeDays,
    DurationBucket.overThreeDays => l10n.reportBucketOverThreeDays,
  };

  pw.Widget _duration(ReportSummary r) {
    final d = r.durations;
    if (d.count == 0) return pw.Text(l10n.reportDurationNone);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l10n.reportDurationSummary(
            d.count,
            _hours(d.shortest!),
            _hours(d.median!),
            _hours(d.longest!),
          ),
        ),
        pw.SizedBox(height: 4),
        _table(
          [for (final b in DurationBucket.values) _bucket(b)],
          [
            [for (final b in DurationBucket.values) '${d.buckets[b] ?? 0}'],
          ],
        ),
      ],
    );
  }

  String _confidence(double c) {
    const bands = AppThresholds.riskConfidenceBands;
    if (c < bands[0]) return l10n.reportConfidenceLow;
    if (c < bands[1]) return l10n.reportConfidenceMedium;
    return l10n.reportConfidenceHigh;
  }

  pw.Widget _triggers(ReportSummary r) {
    final rows = r.triggers
        .where((t) => t.bucket != InsightBucket.notEnoughData)
        .toList();
    if (rows.isEmpty) return pw.Text(l10n.reportTriggersNone);
    final weights = r.inputs.weights;
    return _table(
      [
        l10n.reportColFactor,
        l10n.reportColRatio,
        l10n.reportColExposures,
        l10n.reportColFollowed,
        l10n.reportColConfidence,
      ],
      [
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

  pw.Widget _medications(ReportSummary r) {
    if (r.medications.isEmpty) return pw.Text(l10n.reportMedicationsNone);
    return _table(
      [
        l10n.reportColMedication,
        l10n.reportColKind,
        l10n.reportColDoses,
        l10n.reportColDays,
        l10n.reportColRelief,
      ],
      [
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

  pw.Widget _weather(ReportSummary r) {
    final w = r.weather;
    if (w.attacksWithData == 0 && w.daysWithData == 0) {
      return pw.Text(l10n.reportWeatherNone);
    }
    final lift = w.lift;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l10n.reportWeatherAttacks(w.attacksAfterFall, w.attacksWithData),
        ),
        pw.Text(l10n.reportWeatherDays(w.daysAfterFall, w.daysWithData)),
        if (lift != null)
          pw.Text(l10n.reportWeatherLift(_num(lift, decimals: 2))),
      ],
    );
  }

  pw.Widget _symptoms(ReportSummary r) {
    if (r.symptoms.isEmpty && r.locations.isEmpty) {
      return pw.Text(l10n.reportSymptomsNone);
    }
    List<pw.Widget> lines<T>(Map<T, int> counts, String Function(T) label) {
      final entries = counts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      return [
        for (final e in entries)
          pw.Text(l10n.reportCountOfAttacks(label(e.key), e.value, r.attacks)),
      ];
    }

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: lines(r.symptoms, (s) => symptomLabel(l10n, s)),
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: lines(r.locations, (h) => headLocationLabel(l10n, h)),
          ),
        ),
      ],
    );
  }
}
