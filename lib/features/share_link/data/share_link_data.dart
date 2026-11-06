import 'package:cloud_functions/cloud_functions.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/firebase/firebase_bootstrap.dart';
import 'package:migraine_tracker/features/share_link/domain/share_link.dart';

final shareLinkGatewayProvider = Provider<ShareLinkGateway>((ref) {
  if (!ref.watch(firebaseStatusProvider).enabled) {
    return const UnavailableShareLinkGateway();
  }
  final flavor = ref.watch(appConfigProvider).flavor;
  return FunctionsShareLinkGateway(
    useEmulator: AppFeatureFlags.useEmulators(flavor),
  );
});

final shareLinkMirrorProvider = Provider<ShareLinkMirror>(
  (ref) => ShareLinkMirror(ref.watch(appDatabaseProvider)),
);

/// Calls `createShareLink` and `revokeShareLink`. Both need a signed-in
/// account; App Check covers the calls.
class FunctionsShareLinkGateway implements ShareLinkGateway {
  FunctionsShareLinkGateway({required bool useEmulator}) {
    final functions = FirebaseFunctions.instanceFor(
      region: AppEnv.functionsRegion,
    );
    if (useEmulator) functions.useFunctionsEmulator(AppEnv.emulatorHost, 5001);
    final options = HttpsCallableOptions(timeout: const Duration(seconds: 30));
    _create = functions.httpsCallable(
      AppEndpoints.createShareLinkFunction,
      options: options,
    );
    _revoke = functions.httpsCallable(
      AppEndpoints.revokeShareLinkFunction,
      options: options,
    );
  }

  late final HttpsCallable _create;
  late final HttpsCallable _revoke;

  @override
  bool get available => true;

  @override
  Future<({String token, DateTime expiresAt})> create({
    required int days,
    required Map<String, Object?> document,
  }) => _guard(() async {
    final res = await _create.call<Map<Object?, Object?>>({
      'days': days,
      'document': document,
    });
    return (
      token: res.data['token']! as String,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        res.data['expiresAt']! as int,
        isUtc: true,
      ),
    );
  });

  @override
  Future<void> revoke(String token) => _guard(() async {
    await _revoke.call<Object?>({'token': token});
  });

  static Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on FirebaseFunctionsException catch (e) {
      throw ShareLinkException(switch (e.code) {
        'unauthenticated' => ShareLinkError.signedOut,
        'unavailable' || 'deadline-exceeded' => ShareLinkError.network,
        _ => ShareLinkError.unknown,
      });
    }
  }
}

/// The local `share_links` table: which links this phone made.
class ShareLinkMirror {
  ShareLinkMirror(this._db);

  final AppDatabase _db;

  Stream<List<ShareLinkEntity>> watchAll() =>
      _db.shareLinkDao.watchAll().map((rows) => rows.map(_map).toList());

  Future<void> add(ShareLinkEntity link) => _db.shareLinkDao.upsert(
    ShareLinksCompanion.insert(
      token: link.token,
      createdAt: link.createdAt,
      expiresAt: link.expiresAt,
      revoked: Value(link.revoked),
    ),
  );

  Future<void> markRevoked(String token) => _db.shareLinkDao.revoke(token);

  static ShareLinkEntity _map(ShareLink row) => ShareLinkEntity(
    token: row.token,
    createdAt: row.createdAt,
    expiresAt: row.expiresAt,
    revoked: row.revoked,
  );
}
