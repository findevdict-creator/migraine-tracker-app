import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/features/report/application/report_content.dart';
import 'package:migraine_tracker/features/report/data/report_pdf.dart';
import 'package:migraine_tracker/features/report/domain/report_document.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';

import 'support/report_fixtures.dart';

void main() {
  final today = DateTime(2026, 11, 6);
  final l10n = lookupAppLocalizations(AppLocales.fallback);

  setUpAll(() => initializeDateFormatting(AppLocales.fallback.toString()));

  ReportDocument year() =>
      ReportContent(l10n).build(ReportBuilder.build(yearOfData(today: today)));

  test('one document for the PDF and the share page, with every section', () {
    final doc = year();
    final headings = [
      for (final b in doc.blocks)
        if (b is HeadingBlock) b.text,
    ];
    expect(headings, [
      l10n.reportSectionOverview,
      l10n.reportSectionMonths,
      l10n.reportSectionCalendar,
      l10n.reportSectionDuration,
      l10n.reportSectionTriggers,
      l10n.reportSectionMedications,
      l10n.reportSectionWeather,
      l10n.reportSectionSymptoms,
      l10n.reportSectionQuestionnaires,
    ]);
    expect(doc.blocks.whereType<CalendarBlock>(), hasLength(13));
    expect(doc.blocks.whereType<StatsBlock>().single.tiles, hasLength(6));
  });

  test('survives JSON unchanged, as the server stores it', () {
    final doc = year();
    final json = jsonDecode(jsonEncode(doc.toJson())) as Map<String, Object?>;
    expect(json['v'], ReportDocument.formatVersion);
    expect(ReportDocument.fromJson(json).toJson(), doc.toJson());
  });

  test('holds the summary, never the diary', () {
    // The fixture writes a free-text note on some attacks.
    final text = jsonEncode(year().toJson());
    expect(text, isNot(contains('note, with')));
  });

  test('the PDF draws the same document', () async {
    final bytes = await ReportPdf(l10n).render(year());
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test('questionnaires can be left out', () {
    final doc = ReportContent(l10n).build(
      ReportBuilder.build(yearOfData(today: today)),
      includeQuestionnaires: false,
    );
    expect(
      doc.blocks.whereType<HeadingBlock>().map((b) => b.text),
      isNot(contains(l10n.reportSectionQuestionnaires)),
    );
  });

  test('calendar days carry the shade the PDF and page both use', () {
    const mild = CalendarDay(day: 1, inRange: true, attack: true, intensity: 3);
    const severe = CalendarDay(
      day: 2,
      inRange: true,
      attack: true,
      intensity: 8,
    );
    const quiet = CalendarDay(day: 3, inRange: true, attack: false);
    expect([mild.band, severe.band], [0, 2]);
    expect([mild.label, severe.label, quiet.label], ['3', '8', '3']);
  });
}
