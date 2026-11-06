// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_dao.dart';

// ignore_for_file: type=lint
mixin _$MedicationDaoMixin on DatabaseAccessor<AppDatabase> {
  $AttacksTable get attacks => attachedDatabase.attacks;
  $MedicationEventsTable get medicationEvents =>
      attachedDatabase.medicationEvents;
  MedicationDaoManager get managers => MedicationDaoManager(this);
}

class MedicationDaoManager {
  final _$MedicationDaoMixin _db;
  MedicationDaoManager(this._db);
  $$AttacksTableTableManager get attacks =>
      $$AttacksTableTableManager(_db.attachedDatabase, _db.attacks);
  $$MedicationEventsTableTableManager get medicationEvents =>
      $$MedicationEventsTableTableManager(
        _db.attachedDatabase,
        _db.medicationEvents,
      );
}
