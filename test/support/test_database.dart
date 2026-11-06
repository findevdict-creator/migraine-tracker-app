import 'package:drift/native.dart';
import 'package:migraine_tracker/core/db/app_database.dart';

/// An in-memory database for DAO and repository tests.
AppDatabase newTestDatabase() => AppDatabase(NativeDatabase.memory());
