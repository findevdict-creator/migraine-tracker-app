import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/features/report/data/report_pdf.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';

import 'support/report_fixtures.dart';

void main() {
  final today = DateTime(2026, 11, 6);
  final l10n = lookupAppLocalizations(AppLocales.fallback);

  setUpAll(() => initializeDateFormatting(AppLocales.fallback.toString()));

  test('a year of fixture data renders under 5 s', () async {
    final summary = ReportBuilder.build(yearOfData(today: today));
    final watch = Stopwatch()..start();
    final bytes = await ReportPdf(l10n).build(summary);
    watch.stop();
    expect(watch.elapsed, lessThan(const Duration(seconds: 5)));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(10000));
  });

  test('an empty period still renders every section', () async {
    final summary = ReportBuilder.build(
      ReportInputs(
        range: ReportRange.lastDays(30, today: today),
        generatedAt: today,
      ),
    );
    final bytes = await ReportPdf(l10n).build(summary);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });
}
