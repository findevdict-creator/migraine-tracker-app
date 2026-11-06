// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_dao.dart';

// ignore_for_file: type=lint
mixin _$WeatherDaoMixin on DatabaseAccessor<AppDatabase> {
  $WeatherHoursTable get weatherHours => attachedDatabase.weatherHours;
  WeatherDaoManager get managers => WeatherDaoManager(this);
}

class WeatherDaoManager {
  final _$WeatherDaoMixin _db;
  WeatherDaoManager(this._db);
  $$WeatherHoursTableTableManager get weatherHours =>
      $$WeatherHoursTableTableManager(_db.attachedDatabase, _db.weatherHours);
}
