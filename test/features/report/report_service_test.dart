import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/medication/data/medication_repository_impl.dart';
import 'package:migraine_tracker/features/questionnaires/data/questionnaire_repository_impl.dart';
import 'package:migraine_tracker/features/report/application/report_service.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';

import '../../support/test_database.dart';
import 'support/report_fixtures.dart';

void main() {
  late AppDatabase db;
  late Directory temp;
  late ReportService service;
  final today = DateTime(2026, 11, 6, 9);
  final l10n = lookupAppLocalizations(AppLocales.fallback);

  setUpAll(() => initializeDateFormatting(AppLocales.fallback.toString()));

  setUp(() async {
    db = newTestDatabase();
    temp = await Directory.systemTemp.createTemp('report-service');
    final attacks = DriftAttackRepository(db, clock: () => today);
    final medications = DriftMedicationRepository(db, clock: () => today);
    final checkins = DriftCheckinRepository(db, clock: () => today);
    final risk = DriftRiskRepository(db);
    final data = yearOfData(today: today);
    for (final a in data.attacks) {
      await attacks.save(a);
    }
    for (final m in data.medications) {
      await medications.save(m);
    }
    for (final c in data.checkins) {
      await checkins.save(c);
    }
    await risk.saveWeights(data.weights!, now: today);
    service = ReportService(
      attacks: attacks,
      medications: medications,
      checkins: checkins,
      risk: risk,
      questionnaires: DriftQuestionnaireRepository(db),
      clock: () => today,
    );
  });

  tearDown(() async {
    await db.close();
    await temp.delete(recursive: true);
  });

  test('loads only the range from the database', () async {
    final range = ReportRange.lastDays(30, today: today);
    final inputs = await service.load(range);
    expect(inputs.attacks.every((a) => range.contains(a.startedAt)), isTrue);
    expect(inputs.attacks.length, 8);
    expect(inputs.checkins.length, 30);
    expect(inputs.weights, isNotNull);
    final summary = await service.summary(range);
    expect(summary.attacks, 8);
  });

  test('writes the PDF and both CSV files', () async {
    final files = await service.write(
      ReportRange.lastDays(365, today: today),
      format: ReportFormat.all,
      l10n: l10n,
      directory: temp,
    );
    expect(files.map((f) => f.path.split('/').last), [
      'migraine-tracker-report-2025-11-07-2026-11-06.pdf',
      'migraine-tracker-report-2025-11-07-2026-11-06-attacks.csv',
      'migraine-tracker-report-2025-11-07-2026-11-06-days.csv',
    ]);
    expect(await files.first.length(), greaterThan(10000));
    expect((await files[1].readAsLines()).length, 93);
    expect((await files[2].readAsLines()).length, 366);

    final pdfOnly = await service.write(
      ReportRange.lastDays(30, today: today),
      format: ReportFormat.pdf,
      l10n: l10n,
      directory: temp,
    );
    expect(pdfOnly.single.path, endsWith('.pdf'));
  });
}
