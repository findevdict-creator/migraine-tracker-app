import 'package:flutter/foundation.dart';

/// The stored backup's size and time, read without downloading it.
@immutable
class BackupInfo {
  const BackupInfo({required this.updatedAt, required this.sizeBytes});

  final DateTime updatedAt;
  final int sizeBytes;
}

enum BackupStoreFailure { network, pinning, notAllowed, unknown }

class BackupStoreException implements Exception {
  const BackupStoreException(this.failure, [this.detail]);

  final BackupStoreFailure failure;
  final String? detail;

  @override
  String toString() => 'BackupStoreException($failure, $detail)';
}

/// Where the encrypted file lives: one object per account.
abstract interface class BackupStore {
  Future<BackupInfo?> info();
  Future<void> upload(Uint8List bytes);
  Future<Uint8List?> download();
  Future<void> delete();
}
