import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/share_links.dart';

part 'share_link_dao.g.dart';

/// Reads and writes the local share-link mirror.
@DriftAccessor(tables: [ShareLinks])
class ShareLinkDao extends DatabaseAccessor<AppDatabase>
    with _$ShareLinkDaoMixin {
  ShareLinkDao(super.attachedDatabase);

  Future<List<ShareLink>> all() => (select(
    shareLinks,
  )..orderBy([(s) => OrderingTerm.desc(s.createdAt)])).get();

  Stream<List<ShareLink>> watchAll() => (select(
    shareLinks,
  )..orderBy([(s) => OrderingTerm.desc(s.createdAt)])).watch();

  Future<void> upsert(ShareLinksCompanion link) =>
      into(shareLinks).insertOnConflictUpdate(link);

  Future<int> revoke(String token) =>
      (update(shareLinks)..where((s) => s.token.equals(token))).write(
        const ShareLinksCompanion(revoked: Value(true)),
      );
}
