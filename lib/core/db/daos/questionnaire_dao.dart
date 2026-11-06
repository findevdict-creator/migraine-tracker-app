import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/questionnaires.dart';

part 'questionnaire_dao.g.dart';

/// Reads and writes questionnaire responses.
@DriftAccessor(tables: [Questionnaires])
class QuestionnaireDao extends DatabaseAccessor<AppDatabase>
    with _$QuestionnaireDaoMixin {
  QuestionnaireDao(super.attachedDatabase);

  Future<List<Questionnaire>> ofType(String type) =>
      (select(questionnaires)
            ..where((q) => q.type.equals(type))
            ..orderBy([(q) => OrderingTerm.asc(q.date)]))
          .get();

  Future<Questionnaire?> latest(String type) =>
      (select(questionnaires)
            ..where((q) => q.type.equals(type))
            ..orderBy([(q) => OrderingTerm.desc(q.date)])
            ..limit(1))
          .getSingleOrNull();

  Future<void> upsert(QuestionnairesCompanion questionnaire) =>
      into(questionnaires).insertOnConflictUpdate(questionnaire);

  Future<List<Questionnaire>> all() => (select(
    questionnaires,
  )..orderBy([(q) => OrderingTerm.asc(q.date)])).get();
}
