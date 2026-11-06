import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_repository.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_repository.dart';
import 'package:migraine_tracker/features/medication/data/medication_repository_impl.dart';
import 'package:migraine_tracker/features/medication/domain/medication_repository.dart';
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
    clock: ref.watch(clockProvider),
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
    required DateTime Function() clock,
  }) : this._(attacks, medications, checkins, risk, clock);

  const ReportService._(
    this._attacks,
    this._medications,
    this._checkins,
    this._risk,
    this._clock,
  );

  final AttackRepository _attacks;
  final MedicationRepository _medications;
  final CheckinRepository _checkins;
  final RiskRepository _risk;
  final DateTime Function() _clock;

  Future<ReportInputs> load(ReportRange range) async {
    final attacks = await _attacks.inRange(range.from, range.end);
    final medications = await _medications.inRange(range.from, range.end);
    final checkins = await _checkins.inRange(
      range.from.dateKey,
      range.to.dateKey,
    );
    final weights = await _risk.weights();
    return ReportInputs(
      range: range,
      generatedAt: _clock(),
      attacks: attacks,
      medications: medications,
      checkins: checkins,
      weights: weights,
    );
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
  }) async {
    final inputs = await load(range);
    final dir = directory ?? await getTemporaryDirectory();
    final stem =
        '${AppIdentity.name.toLowerCase().replaceAll(' ', '-')}-report-'
        '${range.from.dateKey}-${range.to.dateKey}';
    return [
      if (format != ReportFormat.csv)
        await File(p.join(dir.path, '$stem.pdf')).writeAsBytes(
          await ReportPdf(
            l10n,
            locale: locale,
          ).build(ReportBuilder.build(inputs)),
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
