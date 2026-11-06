// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiment_dao.dart';

// ignore_for_file: type=lint
mixin _$ExperimentDaoMixin on DatabaseAccessor<AppDatabase> {
  $ExperimentsTable get experiments => attachedDatabase.experiments;
  ExperimentDaoManager get managers => ExperimentDaoManager(this);
}

class ExperimentDaoManager {
  final _$ExperimentDaoMixin _db;
  ExperimentDaoManager(this._db);
  $$ExperimentsTableTableManager get experiments =>
      $$ExperimentsTableTableManager(_db.attachedDatabase, _db.experiments);
}
