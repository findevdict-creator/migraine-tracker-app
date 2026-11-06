import 'dart:convert';

import 'package:drift/drift.dart';

/// Stores a `List<String>` as a JSON array.
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List<dynamic>).cast<String>();

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

/// Stores a `Map<String, dynamic>` as a JSON object.
class JsonMapConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonMapConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) =>
      jsonDecode(fromDb) as Map<String, dynamic>;

  @override
  String toSql(Map<String, dynamic> value) => jsonEncode(value);
}

/// Stores a `List<Map<String, dynamic>>` as a JSON array of objects.
class JsonListConverter
    extends TypeConverter<List<Map<String, dynamic>>, String> {
  const JsonListConverter();

  @override
  List<Map<String, dynamic>> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List<dynamic>).cast<Map<String, dynamic>>();

  @override
  String toSql(List<Map<String, dynamic>> value) => jsonEncode(value);
}
