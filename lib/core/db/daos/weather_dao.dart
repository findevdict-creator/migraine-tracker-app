import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/weather_hours.dart';

part 'weather_dao.g.dart';

/// Reads and writes the hourly weather cache.
@DriftAccessor(tables: [WeatherHours])
class WeatherDao extends DatabaseAccessor<AppDatabase> with _$WeatherDaoMixin {
  WeatherDao(super.attachedDatabase);

  Future<WeatherHour?> at(String cell, DateTime hourUtc) =>
      (select(weatherHours)
            ..where((w) => w.cell.equals(cell))
            ..where((w) => w.hourUtc.equals(hourUtc)))
          .getSingleOrNull();

  /// Hours for a cell inside `[from, to)`, oldest first.
  Future<List<WeatherHour>> series(String cell, DateTime from, DateTime to) =>
      (select(weatherHours)
            ..where((w) => w.cell.equals(cell))
            ..where((w) => w.hourUtc.isBiggerOrEqualValue(from))
            ..where((w) => w.hourUtc.isSmallerThanValue(to))
            ..orderBy([(w) => OrderingTerm.asc(w.hourUtc)]))
          .get();

  Stream<List<WeatherHour>> watchSeries(
    String cell,
    DateTime from,
    DateTime to,
  ) =>
      (select(weatherHours)
            ..where((w) => w.cell.equals(cell))
            ..where((w) => w.hourUtc.isBiggerOrEqualValue(from))
            ..where((w) => w.hourUtc.isSmallerThanValue(to))
            ..orderBy([(w) => OrderingTerm.asc(w.hourUtc)]))
          .watch();

  /// Most recent fetch time for a cell, or null when nothing is cached.
  Future<DateTime?> lastFetchedAt(String cell) async {
    final max = weatherHours.fetchedAt.max();
    final row =
        await (selectOnly(weatherHours)
              ..addColumns([max])
              ..where(weatherHours.cell.equals(cell)))
            .getSingle();
    return row.read(max);
  }

  Future<void> upsertAll(List<WeatherHoursCompanion> rows) => batch((b) {
    b.insertAllOnConflictUpdate(weatherHours, rows);
  });

  Future<int> pin(String cell, DateTime hourUtc) =>
      (update(weatherHours)
            ..where((w) => w.cell.equals(cell))
            ..where((w) => w.hourUtc.equals(hourUtc)))
          .write(const WeatherHoursCompanion(pinned: Value(true)));

  /// Drops unpinned hours older than `before`.
  Future<int> prune(DateTime before) =>
      (delete(weatherHours)
            ..where((w) => w.hourUtc.isSmallerThanValue(before))
            ..where((w) => w.pinned.equals(false)))
          .go();

  Future<List<WeatherHour>> all() => (select(
    weatherHours,
  )..orderBy([(w) => OrderingTerm.asc(w.hourUtc)])).get();
}
