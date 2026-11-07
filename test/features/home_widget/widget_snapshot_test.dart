import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/features/home_widget/domain/widget_snapshot.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_planner.dart';
import 'package:migraine_tracker/features/risk/domain/risk_entities.dart';
import 'package:risk_model/risk_model.dart';

void main() {
  final now = DateTime(2026, 11, 6, 9, 30);
  final l10n = lookupAppLocalizations(AppLocales.fallback);
  setUpAll(() => initializeDateFormatting(AppLocales.fallback.toString()));

  RiskDayEntity today(RiskLevel level, {Factor? driver}) => RiskDayEntity(
    date: '2026-11-06',
    level: level,
    score: 70,
    contributions: [
      if (driver != null)
        Contribution(
          factor: driver,
          exposure: 1,
          weight: 0.5,
          confidence: 0.4,
          points: 50,
        ),
    ],
    modelVersion: modelVersion,
    computedAt: now,
  );

  PressureForecastPoint at(int hoursFromNow, double delta) =>
      PressureForecastPoint(
        hourLocal: DateTime(2026, 11, 6, 9).add(Duration(hours: hoursFromNow)),
        delta24h: delta,
      );

  test('trend thresholds at the steady band', () {
    expect(WidgetSnapshot.trendOf(-2), PressureTrend.falling);
    expect(WidgetSnapshot.trendOf(-1.9), PressureTrend.steady);
    expect(WidgetSnapshot.trendOf(1.9), PressureTrend.steady);
    expect(WidgetSnapshot.trendOf(2), PressureTrend.rising);
  });

  test('builds from today, the current forecast hour and the attack', () {
    final s = WidgetSnapshot.build(
      now: now,
      today: today(RiskLevel.high, driver: Factor.pressureDrop),
      pressure: [at(3, 1), at(0, -4.25), at(-5, 0)],
      attackRunning: true,
    );
    expect(s.level, RiskLevel.high);
    expect(s.driver, Factor.pressureDrop);
    expect(s.delta24h, -4.25);
    expect(s.trend, PressureTrend.falling);

    final data = s.render(l10n, locale: 'en');
    expect(data[AppHomeWidgets.keyLevel], 'high');
    expect(data[AppHomeWidgets.keyLevelLabel], 'Level: High');
    expect(data[AppHomeWidgets.keyHeadline], startsWith('Top factor: '));
    expect(
      data[AppHomeWidgets.keyPressure],
      'Pressure falling 4.3 hPa in 24 h',
    );
    expect(data[AppHomeWidgets.keyUpdated], 'Updated 09:30');
    expect(data[AppHomeWidgets.keyStartLabel], 'Open attack');
    expect(data[AppHomeWidgets.keyRunning], '1');
  });

  test('nothing stored yet still renders every key', () {
    final data = WidgetSnapshot.build(now: now).render(l10n, locale: 'en');
    expect(data[AppHomeWidgets.keyLevel], '');
    expect(
      data[AppHomeWidgets.keyLevelLabel],
      "Open the app to load today's level",
    );
    expect(data[AppHomeWidgets.keyHeadline], 'No single factor stands out');
    expect(data[AppHomeWidgets.keyPressure], 'No pressure forecast yet');
    expect(data[AppHomeWidgets.keyStartLabel], 'Start attack');
    expect(data[AppHomeWidgets.keyRunning], '0');
  });

  test('steady and rising pressure', () {
    String pressure(double d) => WidgetSnapshot.build(
      now: now,
      pressure: [at(0, d)],
    ).render(l10n, locale: 'en')[AppHomeWidgets.keyPressure]!;
    expect(pressure(0.5), 'Pressure steady');
    expect(pressure(3), 'Pressure rising 3.0 hPa in 24 h');
  });

  group('WidgetLink', () {
    test('the start link round-trips', () {
      expect(
        WidgetLink.parse(AppHomeWidgets.startAttackUri),
        WidgetAction.startAttack,
      );
      expect(
        AppHomeWidgets.startAttackUri.toString(),
        'aurawell://widget/start-attack?homeWidget',
      );
    });

    test('other app links just open; foreign links are ignored', () {
      expect(
        WidgetLink.parse(Uri.parse('aurawell://widget')),
        WidgetAction.open,
      );
      expect(WidgetLink.parse(Uri.parse('https://example.com/x')), isNull);
      expect(WidgetLink.parse(null), isNull);
    });
  });
}
