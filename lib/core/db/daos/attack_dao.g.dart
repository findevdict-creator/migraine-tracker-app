// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attack_dao.dart';

// ignore_for_file: type=lint
mixin _$AttackDaoMixin on DatabaseAccessor<AppDatabase> {
  $AttacksTable get attacks => attachedDatabase.attacks;
  AttackDaoManager get managers => AttackDaoManager(this);
}

class AttackDaoManager {
  final _$AttackDaoMixin _db;
  AttackDaoManager(this._db);
  $$AttacksTableTableManager get attacks =>
      $$AttacksTableTableManager(_db.attachedDatabase, _db.attacks);
}
