import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/export/domain/data_export.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final exportServiceProvider = Provider<ExportService>(
  (ref) => ExportService(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

/// Reads and writes whole-database exports. Table-agnostic: it walks
/// `allTables`, so a new table in a later phase is exported without a
/// code change here.
class ExportService {
  ExportService(this._db, {required this.clock});

  final AppDatabase _db;
  final DateTime Function() clock;

  /// Every row of every table as raw column values.
  Future<DataExport> export() async {
    final tables = <String, List<Map<String, Object?>>>{};
    for (final table in _db.allTables) {
      final name = table.actualTableName;
      final rows = await _db.customSelect('SELECT * FROM "$name"').get();
      tables[name] = [for (final r in rows) Map.of(r.data)];
    }
    return DataExport(
      schemaVersion: _db.schemaVersion,
      exportedAt: clock(),
      tables: tables,
    );
  }

  /// Replaces everything with the export, in one transaction. Unknown
  /// tables and columns are skipped so an older export still loads.
  Future<void> import(DataExport data) => _db.transaction(() async {
    await _db.deleteEverything();
    for (final table in _db.allTables) {
      final rows = data.tables[table.actualTableName];
      if (rows == null) continue;
      final known = {for (final c in table.$columns) c.name};
      for (final row in rows) {
        final columns = row.keys.where(known.contains).toList();
        if (columns.isEmpty) continue;
        final names = columns.map((c) => '"$c"').join(', ');
        final marks = List.filled(columns.length, '?').join(', ');
        await _db.customInsert(
          'INSERT INTO "${table.actualTableName}" ($names) VALUES ($marks)',
          variables: [for (final c in columns) Variable(row[c])],
          updates: {table},
        );
      }
    }
  });

  String toJsonString(DataExport data) =>
      const JsonEncoder.withIndent('  ').convert(data.toJson());

  DataExport fromJsonString(String json) =>
      DataExport.fromJson((jsonDecode(json) as Map).cast<String, Object?>());

  /// One CSV per table (file name is the table name).
  Map<String, String> toCsvFiles(DataExport data) => {
    for (final e in data.tables.entries)
      if (e.value.isNotEmpty)
        '${e.key}.csv': Csv.encode(e.value.first.keys.toList(), [
          for (final row in e.value) row.values.toList(),
        ]),
  };

  /// Writes the JSON export to a file and returns it.
  Future<File> writeJsonFile({Directory? directory}) async {
    final data = await export();
    final dir = directory ?? await getTemporaryDirectory();
    final file = File(p.join(dir.path, '${_fileStem(data.exportedAt)}.json'));
    return await file.writeAsString(toJsonString(data));
  }

  /// Writes one CSV per non-empty table and returns the files.
  Future<List<File>> writeCsvFiles({Directory? directory}) async {
    final data = await export();
    final dir = directory ?? await getTemporaryDirectory();
    final stem = _fileStem(data.exportedAt);
    final files = <File>[];
    for (final e in toCsvFiles(data).entries) {
      final file = File(p.join(dir.path, '$stem-${e.key}'));
      files.add(await file.writeAsString(e.value));
    }
    return files;
  }

  /// Deletes every row. The encryption key stays so the app keeps working.
  Future<void> deleteEverything() => _db.deleteEverything();

  Future<Map<String, int>> rowCounts() => _db.rowCounts();

  static String _fileStem(DateTime at) {
    final u = at.toUtc();
    final stamp =
        '${u.year}${u.month.toString().padLeft(2, '0')}'
        '${u.day.toString().padLeft(2, '0')}-'
        '${u.hour.toString().padLeft(2, '0')}'
        '${u.minute.toString().padLeft(2, '0')}';
    return '${AppIdentity.shortName.toLowerCase()}-export-$stamp';
  }
}
