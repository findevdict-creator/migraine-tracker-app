import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/features/questionnaires/domain/questionnaire.dart';
import 'package:migraine_tracker/features/questionnaires/domain/questionnaire_repository.dart';

final questionnaireRepositoryProvider = Provider<QuestionnaireRepository>(
  (ref) => DriftQuestionnaireRepository(ref.watch(appDatabaseProvider)),
);

class DriftQuestionnaireRepository implements QuestionnaireRepository {
  DriftQuestionnaireRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(QuestionnaireResponse response) =>
      _db.questionnaireDao.upsert(
        QuestionnairesCompanion.insert(
          id: response.id,
          type: response.kind.code,
          date: response.completedAt,
          answers: response.answers,
          score: response.score,
        ),
      );

  @override
  Future<List<QuestionnaireResponse>> history(QuestionnaireKind kind) async =>
      _map(await _db.questionnaireDao.ofType(kind.code));

  @override
  Future<QuestionnaireResponse?> latest(QuestionnaireKind kind) async {
    final row = await _db.questionnaireDao.latest(kind.code);
    return row == null ? null : _one(row);
  }

  @override
  Future<List<QuestionnaireResponse>> all() async =>
      _map(await _db.questionnaireDao.all());

  @override
  Future<List<QuestionnaireResponse>> inRange(
    DateTime from,
    DateTime to,
  ) async => [
    for (final r in await all())
      if (!r.completedAt.isBefore(from) && r.completedAt.isBefore(to)) r,
  ];

  List<QuestionnaireResponse> _map(List<Questionnaire> rows) =>
      rows.map(_one).nonNulls.toList();

  QuestionnaireResponse? _one(Questionnaire row) {
    final kind = QuestionnaireKind.fromCode(row.type);
    if (kind == null) return null;
    return QuestionnaireResponse(
      id: row.id,
      kind: kind,
      completedAt: row.date,
      answers: {
        for (final e in row.answers.entries)
          if (e.value is num) e.key: (e.value as num).toInt(),
      },
      score: row.score,
    );
  }
}
