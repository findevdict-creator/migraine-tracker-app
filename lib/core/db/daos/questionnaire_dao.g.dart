// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_dao.dart';

// ignore_for_file: type=lint
mixin _$QuestionnaireDaoMixin on DatabaseAccessor<AppDatabase> {
  $QuestionnairesTable get questionnaires => attachedDatabase.questionnaires;
  QuestionnaireDaoManager get managers => QuestionnaireDaoManager(this);
}

class QuestionnaireDaoManager {
  final _$QuestionnaireDaoMixin _db;
  QuestionnaireDaoManager(this._db);
  $$QuestionnairesTableTableManager get questionnaires =>
      $$QuestionnairesTableTableManager(
        _db.attachedDatabase,
        _db.questionnaires,
      );
}
