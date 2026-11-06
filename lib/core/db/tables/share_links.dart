import 'package:drift/drift.dart';

/// Local mirror of the server share-link record so the user can revoke
/// offline-first.
class ShareLinks extends Table {
  TextColumn get token => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();
  BoolColumn get revoked => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {token};
}
