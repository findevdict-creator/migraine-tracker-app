import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/backup/domain/backup_store.dart';

/// Cloud Storage over its REST API, so the connection can be pinned. The
/// Firebase ID token proves the account; storage.rules keep each account
/// to its own folder.
class StorageRestBackupStore implements BackupStore {
  StorageRestBackupStore({
    required this.client,
    required this.base,
    required this.bucket,
    required this.uid,
    required this.idToken,
    this.appCheckToken,
  });

  final http.Client client;

  /// `https://firebasestorage.googleapis.com`, or the emulator.
  final Uri base;
  final String bucket;
  final String uid;
  final Future<String?> Function() idToken;
  final Future<String?> Function()? appCheckToken;

  String get objectPath => '${AppBackup.folder}/$uid/${AppBackup.objectName}';

  Uri _object({Map<String, String>? query}) => base.replace(
    path: '/v0/b/$bucket/o/${Uri.encodeComponent(objectPath)}',
    queryParameters: query,
  );

  Future<Map<String, String>> _headers() async {
    final token = await idToken();
    if (token == null) {
      throw const BackupStoreException(BackupStoreFailure.notAllowed);
    }
    final check = await appCheckToken?.call();
    return {'Authorization': 'Firebase $token', 'X-Firebase-AppCheck': ?check};
  }

  @override
  Future<BackupInfo?> info() => _guard(() async {
    final res = await client.get(_object(), headers: await _headers());
    if (res.statusCode == 404) return null;
    _check(res);
    final json = (jsonDecode(res.body) as Map).cast<String, Object?>();
    return BackupInfo(
      updatedAt: DateTime.parse(json['updated']! as String),
      sizeBytes: int.parse('${json['size']}'),
    );
  });

  @override
  Future<void> upload(Uint8List bytes) => _guard(() async {
    final uri = base.replace(
      path: '/v0/b/$bucket/o',
      queryParameters: {'name': objectPath},
    );
    final res = await client.post(
      uri,
      headers: {
        ...await _headers(),
        // storage.rules accept only this type.
        'Content-Type': 'application/octet-stream',
      },
      body: bytes,
    );
    _check(res);
  });

  @override
  Future<Uint8List?> download() => _guard(() async {
    final res = await client.get(
      _object(query: {'alt': 'media'}),
      headers: await _headers(),
    );
    if (res.statusCode == 404) return null;
    _check(res);
    return res.bodyBytes;
  });

  @override
  Future<void> delete() => _guard(() async {
    final res = await client.delete(_object(), headers: await _headers());
    if (res.statusCode == 404) return;
    _check(res);
  });

  static void _check(http.Response res) {
    if (res.statusCode == 401 || res.statusCode == 403) {
      throw BackupStoreException(
        BackupStoreFailure.notAllowed,
        '${res.statusCode}',
      );
    }
    if (res.statusCode >= 300) {
      throw BackupStoreException(
        BackupStoreFailure.unknown,
        '${res.statusCode}',
      );
    }
  }

  static Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call().timeout(AppBackup.requestTimeout);
    } on HandshakeException catch (e) {
      throw BackupStoreException(BackupStoreFailure.pinning, e.message);
    } on SocketException catch (e) {
      throw BackupStoreException(BackupStoreFailure.network, e.message);
    } on TimeoutException {
      throw const BackupStoreException(BackupStoreFailure.network, 'timeout');
    } on http.ClientException catch (e) {
      throw BackupStoreException(BackupStoreFailure.network, e.message);
    }
  }
}
