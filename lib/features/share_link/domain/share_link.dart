import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';

enum ShareLinkStatus { active, expired, revoked }

/// The phone's record of a link it created. The server keeps the report
/// snapshot; this mirror lets the person see and revoke their links.
@immutable
class ShareLinkEntity {
  const ShareLinkEntity({
    required this.token,
    required this.createdAt,
    required this.expiresAt,
    this.revoked = false,
  });

  final String token;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool revoked;

  Uri get url => AppShareLinks.url(token);

  ShareLinkStatus statusAt(DateTime now) {
    if (revoked) return ShareLinkStatus.revoked;
    if (!now.isBefore(expiresAt)) return ShareLinkStatus.expired;
    return ShareLinkStatus.active;
  }
}

enum ShareLinkError { signedOut, unavailable, network, unknown }

class ShareLinkException implements Exception {
  const ShareLinkException(this.error);

  final ShareLinkError error;

  @override
  String toString() => 'ShareLinkException($error)';
}

/// The server side: stores and deletes report snapshots.
abstract interface class ShareLinkGateway {
  bool get available;

  /// Uploads [document] (a report document as JSON) for [days].
  Future<({String token, DateTime expiresAt})> create({
    required int days,
    required Map<String, Object?> document,
  });

  Future<void> revoke(String token);
}

class UnavailableShareLinkGateway implements ShareLinkGateway {
  const UnavailableShareLinkGateway();

  @override
  bool get available => false;

  @override
  Future<({String token, DateTime expiresAt})> create({
    required int days,
    required Map<String, Object?> document,
  }) => Future.error(const ShareLinkException(ShareLinkError.unavailable));

  @override
  Future<void> revoke(String token) =>
      Future.error(const ShareLinkException(ShareLinkError.unavailable));
}
