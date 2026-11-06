import 'dart:typed_data';

import 'package:migraine_tracker/features/backup/domain/backup_envelope.dart';
import 'package:migraine_tracker/features/backup/domain/backup_store.dart';

/// Cheap Argon2id costs so tests run fast. The real ones are covered once.
const testKdf = KdfParams(memoryKiB: 64, iterations: 1, parallelism: 1);

/// The server, in memory: holds one object, like `backups/{uid}/latest.bin`.
class MemoryBackupStore implements BackupStore {
  MemoryBackupStore({this.now});

  Uint8List? bytes;
  DateTime? updatedAt;
  final DateTime Function()? now;
  BackupStoreException? failWith;

  @override
  Future<BackupInfo?> info() async {
    _maybeFail();
    final b = bytes;
    return b == null
        ? null
        : BackupInfo(
            updatedAt: updatedAt ?? DateTime(2026),
            sizeBytes: b.length,
          );
  }

  @override
  Future<void> upload(Uint8List data) async {
    _maybeFail();
    bytes = Uint8List.fromList(data);
    updatedAt = now?.call();
  }

  @override
  Future<Uint8List?> download() async {
    _maybeFail();
    return bytes == null ? null : Uint8List.fromList(bytes!);
  }

  @override
  Future<void> delete() async {
    _maybeFail();
    bytes = null;
  }

  void _maybeFail() {
    final f = failWith;
    if (f != null) throw f;
  }
}
