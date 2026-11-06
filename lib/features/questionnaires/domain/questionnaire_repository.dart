import 'package:migraine_tracker/features/questionnaires/domain/questionnaire.dart';

abstract interface class QuestionnaireRepository {
  Future<void> save(QuestionnaireResponse response);

  /// Oldest first.
  Future<List<QuestionnaireResponse>> history(QuestionnaireKind kind);

  Future<QuestionnaireResponse?> latest(QuestionnaireKind kind);

  /// Every response of both kinds, oldest first.
  Future<List<QuestionnaireResponse>> all();

  /// Responses completed in `[from, to)`, oldest first.
  Future<List<QuestionnaireResponse>> inRange(DateTime from, DateTime to);
}
