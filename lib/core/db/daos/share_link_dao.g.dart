// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_link_dao.dart';

// ignore_for_file: type=lint
mixin _$ShareLinkDaoMixin on DatabaseAccessor<AppDatabase> {
  $ShareLinksTable get shareLinks => attachedDatabase.shareLinks;
  ShareLinkDaoManager get managers => ShareLinkDaoManager(this);
}

class ShareLinkDaoManager {
  final _$ShareLinkDaoMixin _db;
  ShareLinkDaoManager(this._db);
  $$ShareLinksTableTableManager get shareLinks =>
      $$ShareLinksTableTableManager(_db.attachedDatabase, _db.shareLinks);
}
