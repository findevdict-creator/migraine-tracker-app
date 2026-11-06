import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/features/audit/domain/audit_upload.dart';
import 'package:migraine_tracker/features/audit/domain/self_audit.dart';
import 'package:risk_model/risk_model.dart';

void main() {
  const high = RiskLevel.high;
  const moderate = RiskLevel.moderate;
  const low = RiskLevel.low;

  group('SelfAudit', () {
    test('an attack is a hit when its day or the day before was High', () {
      final r = SelfAudit.compute(
        shown: {
          '2026-10-01': high,
          '2026-10-02': low,
          '2026-10-09': low,
          '2026-10-10': moderate,
          '2026-10-14': high,
        },
        attackDates: ['2026-10-02', '2026-10-10', '2026-10-14'],
        today: '2026-11-06',
      );
      expect(r.total.attacks, 3);
      expect(r.total.hits, 2);
      expect(r.total.misses, 1);
    });

    test('attacks with no recorded level near them are not scored', () {
      final r = SelfAudit.compute(
        shown: {'2026-10-01': high},
        attackDates: ['2026-10-20', '2026-09-30'],
        today: '2026-11-06',
      );
      // 09-30 is before any level was recorded; 10-20 has none near it.
      expect(r.total.attacks, 0);
    });

    test('a High day is a false alarm when no attack starts that day or '
        'the next', () {
      final r = SelfAudit.compute(
        shown: {'2026-10-01': high, '2026-10-15': high, '2026-10-20': moderate},
        attackDates: ['2026-10-02'],
        today: '2026-11-06',
      );
      expect(r.total.highDays, 2);
      expect(r.total.falseAlarms, 1);
      expect(r.total.falseAlarmShare, 0.5);
    });

    test('a High day waits until its window has passed', () {
      final r = SelfAudit.compute(
        shown: {'2026-11-04': high, '2026-11-05': high, '2026-11-06': high},
        attackDates: const [],
        today: '2026-11-06',
      );
      // Only 11-04 is settled: 11-05 could still be followed by an attack
      // today.
      expect(r.total.highDays, 1);
      expect(r.total.falseAlarms, 1);
    });

    test('counts split by month, oldest first', () {
      final r = SelfAudit.compute(
        shown: {'2026-09-30': high, '2026-10-01': low, '2026-10-05': high},
        attackDates: ['2026-10-01', '2026-10-06'],
        today: '2026-11-06',
      );
      expect(r.byMonth.keys, ['2026-09', '2026-10']);
      // The 10-01 attack is a hit from the 09-30 High day, counted in the
      // month it started.
      expect(r.byMonth['2026-10']!.attacks, 2);
      expect(r.byMonth['2026-10']!.hits, 2);
      expect(r.byMonth['2026-09']!.highDays, 1);
      expect(r.byMonth['2026-09']!.falseAlarms, 0);
      expect(r.total.attacks, 2);
    });

    test('empty input gives an empty result', () {
      final r = SelfAudit.compute(
        shown: const {},
        attackDates: const [],
        today: '2026-11-06',
      );
      expect(r.total.isEmpty, isTrue);
      expect(r.total.hitShare, isNull);
      expect(r.byMonth, isEmpty);
    });

    test('date helpers cross month and year boundaries', () {
      expect(SelfAudit.shift('2026-03-01', -1), '2026-02-28');
      expect(SelfAudit.shift('2026-12-31', 1), '2027-01-01');
      expect(SelfAudit.previousMonth('2027-01-05'), '2026-12');
      expect(SelfAudit.previousMonth('2026-11-06'), '2026-10');
    });
  });

  group('AuditUpload', () {
    test('the payload is exactly five counts and the model version: no '
        'dates, places, log entries or account id', () {
      const counts = AuditCounts(
        attacks: 4,
        hits: 3,
        highDays: 5,
        falseAlarms: 2,
      );
      final payload = AuditUpload.payload(counts, '1.0.0');
      expect(payload.keys.toSet(), AuditUpload.keys);
      expect(payload, {
        'attacks': 4,
        'hits': 3,
        'misses': 1,
        'highDays': 5,
        'falseAlarms': 2,
        'modelVersion': '1.0.0',
      });
      for (final v in payload.values) {
        expect(v is int || v == '1.0.0', isTrue);
        expect('$v', isNot(matches(RegExp(r'\d{4}-\d{2}'))));
      }
    });
  });
}
