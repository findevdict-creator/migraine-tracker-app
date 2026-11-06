import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/device_locale.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/units/units.dart';
import 'package:migraine_tracker/features/report/application/report_service.dart';
import 'package:migraine_tracker/features/report/data/report_pdf.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';

import '../../features/report/support/report_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final en = lookupAppLocalizations(const Locale('en'));
  final de = lookupAppLocalizations(const Locale('de'));

  group('Units', () {
    test('converts and formats each pressure unit', () {
      expect(const Units().pressureText(en, 1013.25), '1013.3 hPa');
      const inHg = Units(pressure: PressureUnit.inHg);
      expect(inHg.pressureText(en, 1013.25), '29.92 inHg');
      const mmHg = Units(pressure: PressureUnit.mmHg);
      expect(mmHg.pressureText(en, 1013.25), '760.0 mmHg');
    });

    test('signs changes and never shows a minus zero', () {
      expect(const Units().pressureText(en, 2.34, signed: true), '+2.3 hPa');
      expect(const Units().pressureText(en, -2.34, signed: true), '-2.3 hPa');
      expect(const Units().pressureText(en, 0.01, signed: true), '0.0 hPa');
      expect(const Units().pressureText(en, -0.01), '0.0 hPa');
    });

    test('thresholds read naturally in each unit', () {
      expect(const Units().pressureChange(en, 6), '6 hPa');
      expect(
        const Units(pressure: PressureUnit.inHg).pressureChange(en, 6),
        '0.18 inHg',
      );
      expect(
        const Units(pressure: PressureUnit.mmHg).pressureChange(en, 6),
        '4.5 mmHg',
      );
    });

    test('temperatures in whole degrees', () {
      expect(const Units().temperatureText(en, 12.4), '12 °C');
      const f = Units(temperature: TemperatureUnit.fahrenheit);
      expect(f.temperatureText(en, 12.4), '54 °F');
      expect(f.temperatureText(en, -40), '-40 °F');
    });

    test('numbers follow the language: a decimal comma in German', () {
      expect(const Units().pressureText(de, 1013.25), startsWith('1013,3'));
    });

    test('region defaults: inHg and °F in the US, metric elsewhere', () {
      final us = Units.forRegion('US');
      expect(us.pressure, PressureUnit.inHg);
      expect(us.temperature, TemperatureUnit.fahrenheit);
      final gb = Units.forRegion('GB');
      expect(gb.pressure, PressureUnit.hpa);
      expect(gb.temperature, TemperatureUnit.celsius);
      expect(Units.forRegion(null).pressure, PressureUnit.hpa);
    });
  });

  group('device language', () {
    test('picks the closest supported language, English otherwise', () {
      expect(deviceAppLocale(const [Locale('pt', 'BR')]), const Locale('pt'));
      expect(deviceAppLocale(const [Locale('ja', 'JP')]), const Locale('ja'));
      expect(
        deviceAppLocale(const [Locale('nl'), Locale('de', 'AT')]),
        const Locale('de'),
      );
      expect(deviceAppLocale(const [Locale('ko')]), AppLocales.fallback);
    });
  });

  group('PDF by language', () {
    final today = DateTime(2026, 11, 6);
    setUpAll(() async {
      for (final l in AppLocales.supported) {
        await initializeDateFormatting(l.toString());
      }
    });

    test('Japanese embeds the bundled Unicode font', () async {
      final ja = lookupAppLocalizations(const Locale('ja'));
      final asked = <String>[];
      final bytes = await ReportPdf(
        ja,
        locale: 'ja',
        loadFont: (asset) {
          asked.add(asset);
          return rootBundle.load(asset);
        },
      ).build(ReportBuilder.build(yearOfData(today: today)));
      expect(asked, [AppAssets.pdfFontJapanese]);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('Hindi falls back to the configured PDF language', () {
      expect(AppLocales.pdfFallback['hi'], 'en');
      expect(ReportService.pdfLanguageFor('hi'), const Locale('en'));
      expect(ReportService.pdfLanguageFor('es'), const Locale('es'));
    });
  });
}
