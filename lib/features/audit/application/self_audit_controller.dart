import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';
import 'package:migraine_tracker/features/audit/data/functions_audit_gateway.dart';
import 'package:migraine_tracker/features/audit/domain/audit_upload.dart';
import 'package:migraine_tracker/features/audit/domain/self_audit.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:migraine_tracker/features/risk/domain/risk_entities.dart';
import 'package:risk_model/risk_model.dart' show modelVersion;

/// The frozen daily levels, live.
final shownRiskProvider = StreamProvider<List<ShownRisk>>(
  (ref) => ref.watch(riskRepositoryProvider).watchShown(),
);

/// The audit, recomputed whenever a level is recorded or an attack logged.
final selfAuditProvider = Provider<AuditResult?>((ref) {
  final shown = ref.watch(shownRiskProvider).value;
  final attacks = ref.watch(attacksProvider).value;
  if (shown == null || attacks == null) return null;
  return SelfAudit.compute(
    shown: {for (final s in shown) s.date: s.level},
    attackDates: [for (final a in attacks) a.startedAt.dateKey],
    today: ref.watch(clockProvider)().dateKey,
  );
});

/// The page appears once this many attacks are logged (FR-13).
final selfAuditReadyProvider = Provider<bool>(
  (ref) =>
      AppFeatureFlags.selfAuditAvailable &&
      (ref.watch(attacksProvider).value?.length ?? 0) >=
          AppThresholds.attacksBeforeSelfAudit,
);

/// Whether the person shares the monthly counts. Off unless turned on.
final auditShareProvider = StreamProvider<bool>(
  (ref) => ref
      .watch(settingsRepositoryProvider)
      .watch<bool>(SettingsKeys.auditShare)
      .map((v) => v ?? false),
);

enum AuditSendOutcome { off, notYet, alreadySent, nothingToSend, sent, failed }

final auditUploaderProvider = Provider<AuditUploader>(AuditUploader.new);

/// Sends last month's counts once, when sharing is on.
class AuditUploader {
  AuditUploader(this._ref);

  final Ref _ref;

  Future<void> setShare({required bool on}) async {
    await _ref
        .read(settingsRepositoryProvider)
        .write(SettingsKeys.auditShare, on);
    if (on) await sendIfDue();
  }

  Future<AuditSendOutcome> sendIfDue() async {
    final settings = _ref.read(settingsRepositoryProvider);
    final gateway = _ref.read(auditGatewayProvider);
    if (!AppFeatureFlags.auditUploadAvailable || !gateway.available) {
      return AuditSendOutcome.off;
    }
    if (!(await settings.read<bool>(SettingsKeys.auditShare) ?? false)) {
      return AuditSendOutcome.off;
    }
    final today = _ref.read(clockProvider)().dateKey;
    if (int.parse(today.substring(8, 10)) < AppThresholds.auditUploadFromDay) {
      return AuditSendOutcome.notYet;
    }
    final month = SelfAudit.previousMonth(today);
    final last = await settings.read<String>(SettingsKeys.auditLastSentMonth);
    if (last != null && last.compareTo(month) >= 0) {
      return AuditSendOutcome.alreadySent;
    }
    final shown = await _ref.read(riskRepositoryProvider).allShown();
    final attacks = await _ref.read(attackRepositoryProvider).all();
    final counts =
        SelfAudit.compute(
          shown: {for (final s in shown) s.date: s.level},
          attackDates: [for (final a in attacks) a.startedAt.dateKey],
          today: today,
        ).byMonth[month] ??
        AuditCounts.zero;
    if (!counts.isEmpty) {
      final version =
          shown
              .where((s) => SelfAudit.monthOf(s.date) == month)
              .lastOrNull
              ?.modelVersion ??
          modelVersion;
      try {
        await gateway.send(AuditUpload.payload(counts, version));
      } on Object {
        // Offline or refused: tried again on the next start.
        return AuditSendOutcome.failed;
      }
    }
    await settings.write(SettingsKeys.auditLastSentMonth, month);
    return counts.isEmpty
        ? AuditSendOutcome.nothingToSend
        : AuditSendOutcome.sent;
  }
}
