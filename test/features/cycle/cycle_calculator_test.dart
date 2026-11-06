import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/cycle/domain/cycle_calculator.dart';

void main() {
  group('CycleCalculator.cycleLength', () {
    test('defaults until two starts exist', () {
      expect(CycleCalculator.cycleLength([]), 28);
      expect(CycleCalculator.cycleLength(['2026-10-01']), 28);
    });

    test('averages recent intervals and clamps to the config range', () {
      expect(
        CycleCalculator.cycleLength(['2026-09-01', '2026-10-01', '2026-10-31']),
        30,
      );
      expect(
        CycleCalculator.cycleLength(['2026-01-01', '2026-01-10']),
        AppThresholds.minCycleLengthDays,
      );
      expect(
        CycleCalculator.cycleLength(['2026-01-01', '2026-03-30']),
        AppThresholds.maxCycleLengthDays,
      );
    });

    test('only the most recent sample of intervals counts', () {
      final starts = <String>[
        '2025-01-01', // 60-day gap below would skew without sampling
        '2025-03-02',
        for (var i = 0; i < AppThresholds.cycleLengthSampleSize; i++)
          '2025-${(4 + i).toString().padLeft(2, '0')}-01',
      ];
      final length = CycleCalculator.cycleLength(starts);
      expect(length, inInclusiveRange(28, 31));
    });
  });

  group('CycleCalculator.infoFor', () {
    const starts = ['2026-10-05', '2026-11-02'];

    test('null before any start', () {
      expect(CycleCalculator.infoFor('2026-10-01', starts), isNull);
    });

    test('day 1 on the start, counting from the latest start', () {
      expect(CycleCalculator.infoFor('2026-11-02', starts)!.day, 1);
      expect(CycleCalculator.infoFor('2026-11-06', starts)!.day, 5);
      expect(CycleCalculator.infoFor('2026-10-20', starts)!.day, 16);
    });

    test('wraps past the cycle length when no new start is logged', () {
      // 28-day cycle from the two starts; day 29 after the last start is
      // reported as day 1 again.
      final info = CycleCalculator.infoFor('2026-11-30', starts)!;
      expect(info.cycleLength, 28);
      expect(info.day, 1);
    });
  });

  group('CycleCalculator.phaseFor', () {
    test('phases over a 28-day cycle', () {
      expect(CycleCalculator.phaseFor(1, 28), CyclePhase.menstrual);
      expect(CycleCalculator.phaseFor(5, 28), CyclePhase.menstrual);
      expect(CycleCalculator.phaseFor(6, 28), CyclePhase.follicular);
      expect(CycleCalculator.phaseFor(12, 28), CyclePhase.follicular);
      expect(CycleCalculator.phaseFor(13, 28), CyclePhase.ovulation);
      expect(CycleCalculator.phaseFor(14, 28), CyclePhase.ovulation);
      expect(CycleCalculator.phaseFor(15, 28), CyclePhase.ovulation);
      expect(CycleCalculator.phaseFor(16, 28), CyclePhase.luteal);
      expect(CycleCalculator.phaseFor(28, 28), CyclePhase.luteal);
    });

    test('ovulation window moves with the cycle length', () {
      expect(CycleCalculator.phaseFor(19, 35), CyclePhase.follicular);
      expect(CycleCalculator.phaseFor(20, 35), CyclePhase.ovulation);
      expect(CycleCalculator.phaseFor(22, 35), CyclePhase.ovulation);
      expect(CycleCalculator.phaseFor(23, 35), CyclePhase.luteal);
    });
  });
}
