import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/features/report/domain/report_csv.dart';

import 'support/report_fixtures.dart';

void main() {
  final today = DateTime(2026, 11, 6);
  final inputs = yearOfData(today: today);

  test('attacks CSV has one row per attack with stable columns', () {
    final lines = ReportCsv.attacks(inputs).trim().split('\n');
    expect(lines.first, ReportCsv.attackColumns.join(','));
    expect(lines.length - 1, inputs.attacks.length);
    // Sorted by start, oldest first.
    expect(lines[1], startsWith('2025-11-07T09:00'));
    // Quotes in notes are escaped and the row still has every column.
    final noted = lines.firstWhere((l) => l.contains('quotes'));
    expect(noted, contains('"note, with ""quotes"""'));
    // Linked medication names appear on the attack row.
    expect(lines.where((l) => l.contains('Sumatriptan')), isNotEmpty);
  });

  test('days CSV has one row per day of the range', () {
    final lines = ReportCsv.days(inputs).trim().split('\n');
    expect(lines.first, ReportCsv.dayColumns.join(','));
    expect(lines.length - 1, inputs.range.days);
    expect(lines[1], startsWith('2025-11-07,1,'));
    expect(lines.last, startsWith('2026-11-06,'));
    for (final l in lines.skip(1)) {
      expect(l.split(',').length, ReportCsv.dayColumns.length, reason: l);
    }
  });
}
