// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barometer_dao.dart';

// ignore_for_file: type=lint
mixin _$BarometerDaoMixin on DatabaseAccessor<AppDatabase> {
  $BarometerReadingsTable get barometerReadings =>
      attachedDatabase.barometerReadings;
  BarometerDaoManager get managers => BarometerDaoManager(this);
}

class BarometerDaoManager {
  final _$BarometerDaoMixin _db;
  BarometerDaoManager(this._db);
  $$BarometerReadingsTableTableManager get barometerReadings =>
      $$BarometerReadingsTableTableManager(
        _db.attachedDatabase,
        _db.barometerReadings,
      );
}
