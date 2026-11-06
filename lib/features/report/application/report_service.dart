import 'dart:io';
import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/units/units.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_repository.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_repository.dart';
import 'package:migraine_tracker/features/medication/data/medication_repository_impl.dart';
import 'package:migraine_tracker/features/medication/domain/medication_repository.dart';
import 'package:migraine_tracker/features/questionnaires/data/questionnaire_repository_impl.dart';
import 'package:migraine_tracker/features/questionnaires/domain/questionnaire_repository.dart';
import 'package:migraine_tracker/features/report/data/report_pdf.dart';
import 'package:migraine_tracker/features/report/domain/report_csv.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:migraine_tracker/features/risk/domain/risk_repository.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final reportServiceProvider = Provider<ReportService>(
  (ref) => ReportService(
    attacks: ref.watch(attackRepositoryProvider),
    medications: ref.watch(medicationRepositoryProvider),
    checkins: ref.watch(checkinRepositoryProvider),
    risk: ref.watch(riskRepositoryProvider),
    questionnaires: ref.watch(questionnaireRepositoryProvider),
    clock: ref.watch(clockProvider),
    units: ref.watch(unitsProvider),
  ),
);

/// Which files a share includes.
enum ReportFormat { pdf, csv, all }

/// Loads a range from the repositories, builds the summary and writes the
/// files the share sheet sends.
class ReportService {
  ReportService({
    required AttackRepository attacks,
    required MedicationRepository medications,
    required CheckinRepository checkins,
    required RiskRepository risk,
    required QuestionnaireRepository questionnaires,
    required DateTime Function() clock,
    Units units = const Units(),
  }) : this._(
         attacks,
         medications,
         checkins,
         risk,
         questionnaires,
         clock,
         units,
       );

  const ReportService._(
    this._attacks,
    this._medications,
    this._checkins,
    this._risk,
    this._questionnaires,
    this._clock,
    this.units,
  );

  final AttackRepository _attacks;
  final MedicationRepository _medications;
  final CheckinRepository _checkins;
  final RiskRepository _risk;
  final QuestionnaireRepository _questionnaires;
  final DateTime Function() _clock;

  /// Display units for the report text.
  final Units units;

  Future<ReportInputs> load(ReportRange range) async {
    final attacks = await _attacks.inRange(range.from, range.end);
    final medications = await _medications.inRange(range.from, range.end);
    final checkins = await _checkins.inRange(
      range.from.dateKey,
      range.to.dateKey,
    );
    final weights = await _risk.weights();
    final questionnaires = await _questionnaires.inRange(range.from, range.end);
    return ReportInputs(
      range: range,
      generatedAt: _clock(),
      attacks: attacks,
      medications: medications,
      checkins: checkins,
      weights: weights,
      questionnaires: questionnaires,
    );
  }

  /// The PDF in the person's language, or in `AppLocales.pdfFallback`'s
  /// language when the PDF cannot set their script.
  ReportPdf _pdf(AppLocalizations l10n, String? locale) {
    final language = pdfLanguageFor(l10n.localeName);
    if (language.languageCode == l10n.localeName.split('_').first) {
      return ReportPdf(l10n, locale: locale, units: units);
    }
    return ReportPdf(
      lookupAppLocalizations(language),
      locale: language.toString(),
      units: units,
    );
  }

  /// The language the PDF is written in for an app language.
  static Locale pdfLanguageFor(String localeName) {
    final language = localeName.split('_').first;
    return Locale(AppLocales.pdfFallback[language] ?? language);
  }

  Future<ReportSummary> summary(ReportRange range) async =>
      ReportBuilder.build(await load(range));

  /// Writes the requested files into [directory] (the temp directory by
  /// default) and returns them in share order: PDF first.
  Future<List<File>> write(
    ReportRange range, {
    required ReportFormat format,
    required AppLocalizations l10n,
    String? locale,
    Directory? directory,
    bool includeQuestionnaires = true,
  }) async {
    final inputs = await load(range);
    final dir = directory ?? await getTemporaryDirectory();
    final stem =
        '${AppIdentity.name.toLowerCase().replaceAll(' ', '-')}-report-'
        '${range.from.dateKey}-${range.to.dateKey}';
    return [
      if (format != ReportFormat.csv)
        await File(p.join(dir.path, '$stem.pdf')).writeAsBytes(
          await _pdf(l10n, locale).build(
            ReportBuilder.build(inputs),
            includeQuestionnaires: includeQuestionnaires,
          ),
        ),
      if (format != ReportFormat.pdf) ...[
        await File(p.join(dir.path, '$stem-attacks.csv'))
            .writeAsString(ReportCsv.attacks(inputs)),
        await File(p.join(dir.path, '$stem-days.csv'))
            .writeAsString(ReportCsv.days(inputs)),
      ],
    ];
  }
}
