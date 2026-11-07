import 'package:flutter/foundation.dart';

/// Format name written into every JSON export so imports can refuse files
/// that are not ours.
const String exportFormat = 'aurawell-export';

/// Bumped when the export envelope changes shape (not the schema).
const int exportFormatVersion = 1;

/// An export of every table, as raw column values. Dates are ISO-8601
/// text (the database stores them that way), JSON columns are JSON text.
@immutable
class DataExport {
  const DataExport({
    required this.schemaVersion,
    required this.exportedAt,
    required this.tables,
    this.formatVersion = exportFormatVersion,
  });

  /// Parses an envelope, throwing [FormatException] for foreign files.
  factory DataExport.fromJson(Map<String, Object?> json) {
    if (json['format'] != exportFormat) {
      throw const FormatException('Not a Aurawell export');
    }
    final tables = json['tables'];
    if (tables is! Map) throw const FormatException('Missing tables');
    final exportedAt = json['exportedAt'];
    if (exportedAt is! String) throw const FormatException('Missing date');
    return DataExport(
      formatVersion: json['formatVersion'] as int? ?? 1,
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      exportedAt: DateTime.parse(exportedAt),
      tables: {
        for (final e in tables.entries)
          e.key as String: [
            for (final row in e.value as List)
              (row as Map).cast<String, Object?>(),
          ],
      },
    );
  }

  final int formatVersion;
  final int schemaVersion;
  final DateTime exportedAt;

  /// Table name to rows, each row column name to value.
  final Map<String, List<Map<String, Object?>>> tables;

  int get rowCount => tables.values.fold(0, (n, rows) => n + rows.length);

  Map<String, Object?> toJson() => {
    'format': exportFormat,
    'formatVersion': formatVersion,
    'schemaVersion': schemaVersion,
    'exportedAt': exportedAt.toUtc().toIso8601String(),
    'tables': tables,
  };
}

/// Minimal RFC 4180 writer. Values containing a comma, quote or newline
/// are quoted; quotes are doubled. Nulls are empty cells.
abstract final class Csv {
  static String encode(List<String> header, List<List<Object?>> rows) {
    final buffer = StringBuffer()..writeln(header.map(_cell).join(','));
    for (final row in rows) {
      buffer.writeln(row.map(_cell).join(','));
    }
    return buffer.toString();
  }

  static String _cell(Object? value) {
    if (value == null) return '';
    final text = value.toString();
    if (text.contains(',') ||
        text.contains('"') ||
        text.contains('\n') ||
        text.contains('\r')) {
      return '"${text.replaceAll('"', '""')}"';
    }
    return text;
  }

  /// Parses what [encode] wrote. Used by tests to prove the CSV is
  /// re-importable; not a general-purpose parser.
  static List<List<String?>> decode(String csv) {
    final rows = <List<String?>>[];
    var row = <String?>[];
    final cell = StringBuffer();
    var quoted = false;
    var wasQuoted = false;
    for (var i = 0; i < csv.length; i++) {
      final ch = csv[i];
      if (quoted) {
        if (ch == '"') {
          if (i + 1 < csv.length && csv[i + 1] == '"') {
            cell.write('"');
            i++;
          } else {
            quoted = false;
          }
        } else {
          cell.write(ch);
        }
        continue;
      }
      switch (ch) {
        case '"':
          quoted = true;
          wasQuoted = true;
        case ',':
          row.add(_finish(cell, wasQuoted));
          wasQuoted = false;
        case '\n':
          row.add(_finish(cell, wasQuoted));
          wasQuoted = false;
          rows.add(row);
          row = <String?>[];
        case '\r':
          break;
        default:
          cell.write(ch);
      }
    }
    if (cell.isNotEmpty || wasQuoted || row.isNotEmpty) {
      row.add(_finish(cell, wasQuoted));
      rows.add(row);
    }
    return rows;
  }

  static String? _finish(StringBuffer cell, bool wasQuoted) {
    final text = cell.toString();
    cell.clear();
    return text.isEmpty && !wasQuoted ? null : text;
  }
}
