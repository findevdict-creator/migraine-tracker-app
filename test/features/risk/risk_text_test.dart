import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/l10n/generated/app_localizations_en.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_text.dart';
import 'package:risk_model/risk_model.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('every factor has plain words', () {
    final labels = {for (final f in Factor.values) factorLabel(l10n, f)};
    expect(labels.length, Factor.values.length);
    for (final label in labels) {
      expect(label, isNotEmpty);
      expect(label.toLowerCase(), isNot(contains('predict')));
    }
  });

  test('confidence bands', () {
    expect(confidenceLabel(l10n, 0), 'low');
    expect(confidenceLabel(l10n, 0.29), 'low');
    expect(confidenceLabel(l10n, 0.3), 'medium');
    expect(confidenceLabel(l10n, 0.69), 'medium');
    expect(confidenceLabel(l10n, 0.7), 'high');
    expect(confidenceLabel(l10n, 1), 'high');
  });

  test('day labels', () {
    expect(dayLabel(l10n, '2026-11-06', '2026-11-06'), 'Today');
    expect(dayLabel(l10n, '2026-11-07', '2026-11-06'), 'Tomorrow');
    expect(dayLabel(l10n, '2026-11-08', '2026-11-06'), 'Sunday');
    expect(dayLabel(l10n, '2026-11-09', '2026-11-06'), 'Monday');
  });
}
