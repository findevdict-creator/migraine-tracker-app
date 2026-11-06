// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_dao.dart';

// ignore_for_file: type=lint
mixin _$HealthDaoMixin on DatabaseAccessor<AppDatabase> {
  $HealthSamplesTable get healthSamples => attachedDatabase.healthSamples;
  HealthDaoManager get managers => HealthDaoManager(this);
}

class HealthDaoManager {
  final _$HealthDaoMixin _db;
  HealthDaoManager(this._db);
  $$HealthSamplesTableTableManager get healthSamples =>
      $$HealthSamplesTableTableManager(_db.attachedDatabase, _db.healthSamples);
}
