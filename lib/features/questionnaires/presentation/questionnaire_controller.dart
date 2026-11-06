import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/notifications/application/notification_scheduler.dart';
import 'package:migraine_tracker/features/questionnaires/data/questionnaire_repository_impl.dart';
import 'package:migraine_tracker/features/questionnaires/domain/questionnaire.dart';
import 'package:uuid/uuid.dart';

/// Every response of one instrument, oldest first.
final FutureProviderFamily<List<QuestionnaireResponse>, QuestionnaireKind>
questionnaireHistoryProvider =
    FutureProvider.family<List<QuestionnaireResponse>, QuestionnaireKind>(
      (ref, kind) => ref.watch(questionnaireRepositoryProvider).history(kind),
    );

/// When the next round is due, from both instruments; null until one was
/// completed.
final questionnaireDueProvider = FutureProvider<DateTime?>((ref) async {
  final all = await ref.watch(questionnaireRepositoryProvider).all();
  return QuestionnaireDue.nextDue(all, AppThresholds.questionnaireReminder);
});

/// Scores and stores a completed questionnaire, then refreshes the
/// lists and the reminder plan.
final questionnaireSaverProvider = Provider<QuestionnaireSaver>(
  QuestionnaireSaver.new,
);

class QuestionnaireSaver {
  QuestionnaireSaver(this._ref);

  final Ref _ref;

  Future<QuestionnaireResponse> save(
    QuestionnaireKind kind,
    Map<String, int> answers,
  ) async {
    final response = QuestionnaireResponse.scored(
      id: const Uuid().v4(),
      kind: kind,
      completedAt: _ref.read(clockProvider)(),
      answers: answers,
    );
    await _ref.read(questionnaireRepositoryProvider).save(response);
    _ref
      ..invalidate(questionnaireHistoryProvider(kind))
      ..invalidate(questionnaireDueProvider);
    unawaited(_reschedule());
    return response;
  }

  Future<void> _reschedule() async {
    try {
      await _ref.read(notificationSchedulerProvider).reschedule();
    } on Object catch (error) {
      debugPrint('reschedule after questionnaire failed: $error');
    }
  }
}

String questionnaireTitle(AppLocalizations l10n, QuestionnaireKind kind) =>
    switch (kind) {
      QuestionnaireKind.midas => l10n.questionnaireMidasTitle,
      QuestionnaireKind.hit6 => l10n.questionnaireHit6Title,
    };

String questionnaireSubtitle(AppLocalizations l10n, QuestionnaireKind kind) =>
    switch (kind) {
      QuestionnaireKind.midas => l10n.questionnaireMidasSubtitle,
      QuestionnaireKind.hit6 => l10n.questionnaireHit6Subtitle,
    };

String bandLabel(
  AppLocalizations l10n,
  QuestionnaireKind kind,
  SeverityBand band,
) => switch ((kind, band)) {
  (QuestionnaireKind.midas, SeverityBand.minimal) =>
    l10n.questionnaireMidasBandMinimal,
  (QuestionnaireKind.midas, SeverityBand.mild) =>
    l10n.questionnaireMidasBandMild,
  (QuestionnaireKind.midas, SeverityBand.moderate) =>
    l10n.questionnaireMidasBandModerate,
  (QuestionnaireKind.midas, SeverityBand.severe) =>
    l10n.questionnaireMidasBandSevere,
  (QuestionnaireKind.hit6, SeverityBand.minimal) =>
    l10n.questionnaireHit6BandMinimal,
  (QuestionnaireKind.hit6, SeverityBand.mild) => l10n.questionnaireHit6BandMild,
  (QuestionnaireKind.hit6, SeverityBand.moderate) =>
    l10n.questionnaireHit6BandModerate,
  (QuestionnaireKind.hit6, SeverityBand.severe) =>
    l10n.questionnaireHit6BandSevere,
};

String hit6OptionLabel(AppLocalizations l10n, Hit6Option option) =>
    switch (option) {
      Hit6Option.never => l10n.questionnaireOptionNever,
      Hit6Option.rarely => l10n.questionnaireOptionRarely,
      Hit6Option.sometimes => l10n.questionnaireOptionSometimes,
      Hit6Option.veryOften => l10n.questionnaireOptionVeryOften,
      Hit6Option.always => l10n.questionnaireOptionAlways,
    };

String midasQuestion(AppLocalizations l10n, String item) => switch (item) {
  Midas.q1 => l10n.questionnaireMidasQ1,
  Midas.q2 => l10n.questionnaireMidasQ2,
  Midas.q3 => l10n.questionnaireMidasQ3,
  Midas.q4 => l10n.questionnaireMidasQ4,
  Midas.q5 => l10n.questionnaireMidasQ5,
  Midas.headacheDays => l10n.questionnaireMidasA,
  Midas.painAverage => l10n.questionnaireMidasB,
  _ => item,
};

String hit6Question(AppLocalizations l10n, String item) => switch (item) {
  'q1' => l10n.questionnaireHit6Q1,
  'q2' => l10n.questionnaireHit6Q2,
  'q3' => l10n.questionnaireHit6Q3,
  'q4' => l10n.questionnaireHit6Q4,
  'q5' => l10n.questionnaireHit6Q5,
  'q6' => l10n.questionnaireHit6Q6,
  _ => item,
};
