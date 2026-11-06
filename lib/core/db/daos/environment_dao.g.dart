// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_dao.dart';

// ignore_for_file: type=lint
mixin _$EnvironmentDaoMixin on DatabaseAccessor<AppDatabase> {
  $EnvironmentDaysTable get environmentDays => attachedDatabase.environmentDays;
  EnvironmentDaoManager get managers => EnvironmentDaoManager(this);
}

class EnvironmentDaoManager {
  final _$EnvironmentDaoMixin _db;
  EnvironmentDaoManager(this._db);
  $$EnvironmentDaysTableTableManager get environmentDays =>
      $$EnvironmentDaysTableTableManager(
        _db.attachedDatabase,
        _db.environmentDays,
      );
}
