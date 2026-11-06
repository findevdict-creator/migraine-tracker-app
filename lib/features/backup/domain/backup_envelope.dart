import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// Argon2id cost, stored in every backup's header.
@immutable
class KdfParams {
  const KdfParams({
    required this.memoryKiB,
    required this.iterations,
    required this.parallelism,
  });

  static const standard = KdfParams(
    memoryKiB: AppBackup.argonMemoryKiB,
    iterations: AppBackup.argonIterations,
    parallelism: AppBackup.argonParallelism,
  );

  final int memoryKiB;
  final int iterations;
  final int parallelism;

  bool get withinLimits =>
      parallelism >= 1 &&
      parallelism <= 16 &&
      iterations >= 1 &&
      iterations <= AppBackup.argonMaxIterations &&
      memoryKiB >= 8 * parallelism &&
      memoryKiB <= AppBackup.argonMaxMemoryKiB;
}

/// Turns a passphrase and salt into 32 key bytes. Swappable so the app can
/// run it off the UI thread and tests can count calls.
typedef KeyDeriver = Future<List<int>> Function(
  String passphrase,
  List<int> salt,
  KdfParams params,
);

Future<List<int>> argon2idKey(
  String passphrase,
  List<int> salt,
  KdfParams params,
) async {
  final key = await Argon2id(
    memory: params.memoryKiB,
    iterations: params.iterations,
    parallelism: params.parallelism,
    hashLength: 32,
  ).deriveKeyFromPassword(password: passphrase, nonce: salt);
  return await key.extractBytes();
}

enum BackupFailure {
  /// Not one of our files.
  notABackup,

  /// Made by a newer app version.
  newerFormat,

  /// Header present but unusable, including out-of-range costs.
  damaged,

  /// Authentication failed: a wrong passphrase or changed bytes. AES-GCM
  /// cannot tell the two apart, and neither should the message.
  wrongPassphraseOrDamaged,
}

class BackupFormatException implements Exception {
  const BackupFormatException(this.failure);

  final BackupFailure failure;

  @override
  String toString() => 'BackupFormatException($failure)';
}

/// What a backup says about itself before it is opened.
@immutable
class BackupHeader {
  const BackupHeader({
    required this.params,
    required this.salt,
    required this.nonce,
    required this.schemaVersion,
    required this.createdAt,
  });

  factory BackupHeader.fromJson(Map<String, Object?> json) {
    final kdf = (json['kdf']! as Map).cast<String, Object?>();
    final cipher = (json['cipher']! as Map).cast<String, Object?>();
    if (kdf['alg'] != 'argon2id' || cipher['alg'] != 'aes-256-gcm') {
      throw const BackupFormatException(BackupFailure.damaged);
    }
    return BackupHeader(
      params: KdfParams(
        memoryKiB: kdf['m']! as int,
        iterations: kdf['t']! as int,
        parallelism: kdf['p']! as int,
      ),
      salt: base64Decode(kdf['salt']! as String),
      nonce: base64Decode(cipher['nonce']! as String),
      schemaVersion: json['schema']! as int,
      createdAt: DateTime.parse(json['createdAt']! as String),
    );
  }

  final KdfParams params;
  final List<int> salt;
  final List<int> nonce;
  final int schemaVersion;
  final DateTime createdAt;

  Map<String, Object?> toJson() => {
    'kdf': {
      'alg': 'argon2id',
      'm': params.memoryKiB,
      't': params.iterations,
      'p': params.parallelism,
      'salt': base64Encode(salt),
    },
    'cipher': {'alg': 'aes-256-gcm', 'nonce': base64Encode(nonce)},
    'schema': schemaVersion,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };
}

/// The file format:
///
///     "MTBK" | version (1 byte) | header length (4 bytes, big-endian)
///     | header (UTF-8 JSON) | AES-256-GCM ciphertext | 16-byte tag
///
/// Everything before the ciphertext is the associated data, so changing
/// the costs, salt or nonce in the header fails authentication. The
/// plaintext is the gzipped JSON export.
abstract final class BackupEnvelope {
  static const List<int> magic = [0x4D, 0x54, 0x42, 0x4B]; // MTBK
  static const int version = 1;
  static final _cipher = AesGcm.with256bits();

  static Future<Uint8List> seal({
    required String json,
    required String passphrase,
    required int schemaVersion,
    required DateTime createdAt,
    KdfParams params = KdfParams.standard,
    KeyDeriver derive = argon2idKey,
  }) async {
    final salt = SecretKeyData.random(length: AppBackup.saltBytes).bytes;
    final header = BackupHeader(
      params: params,
      salt: salt,
      nonce: _cipher.newNonce(),
      schemaVersion: schemaVersion,
      createdAt: createdAt,
    );
    final headerBytes = utf8.encode(jsonEncode(header.toJson()));
    final prefix = BytesBuilder()
      ..add(magic)
      ..addByte(version)
      ..add(_uint32(headerBytes.length))
      ..add(headerBytes);
    final aad = prefix.toBytes();
    final key = await derive(passphrase, salt, params);
    final box = await _cipher.encrypt(
      gzip.encode(utf8.encode(json)),
      secretKey: SecretKey(key),
      nonce: header.nonce,
      aad: aad,
    );
    return (BytesBuilder(copy: false)
          ..add(aad)
          ..add(box.cipherText)
          ..add(box.mac.bytes))
        .toBytes();
  }

  /// Reads the header without the passphrase.
  static BackupHeader peek(Uint8List bytes) => _split(bytes).header;

  /// Returns the export JSON, or throws [BackupFormatException].
  static Future<String> open({
    required Uint8List bytes,
    required String passphrase,
    KeyDeriver derive = argon2idKey,
  }) async {
    final parts = _split(bytes);
    final key = await derive(
      passphrase,
      parts.header.salt,
      parts.header.params,
    );
    try {
      final clear = await _cipher.decrypt(
        SecretBox(
          parts.cipherText,
          nonce: parts.header.nonce,
          mac: Mac(parts.tag),
        ),
        secretKey: SecretKey(key),
        aad: parts.aad,
      );
      return utf8.decode(gzip.decode(clear));
    } on SecretBoxAuthenticationError {
      throw const BackupFormatException(BackupFailure.wrongPassphraseOrDamaged);
    }
  }

  static ({
    BackupHeader header,
    Uint8List aad,
    Uint8List cipherText,
    Uint8List tag,
  })
  _split(Uint8List bytes) {
    const fixed = 4 + 1 + 4;
    if (bytes.length < fixed || !listEquals(bytes.sublist(0, 4), magic)) {
      throw const BackupFormatException(BackupFailure.notABackup);
    }
    if (bytes[4] > version) {
      throw const BackupFormatException(BackupFailure.newerFormat);
    }
    final headerLength = ByteData.sublistView(bytes, 5, 9).getUint32(0);
    final headerEnd = fixed + headerLength;
    if (headerLength > 4096 || bytes.length < headerEnd + 16) {
      throw const BackupFormatException(BackupFailure.damaged);
    }
    final BackupHeader header;
    try {
      header = BackupHeader.fromJson(
        (jsonDecode(utf8.decode(bytes.sublist(fixed, headerEnd))) as Map)
            .cast<String, Object?>(),
      );
    } on BackupFormatException {
      rethrow;
    } on Object {
      throw const BackupFormatException(BackupFailure.damaged);
    }
    if (!header.params.withinLimits ||
        header.salt.length < 16 ||
        header.nonce.length != 12) {
      throw const BackupFormatException(BackupFailure.damaged);
    }
    return (
      header: header,
      aad: Uint8List.sublistView(bytes, 0, headerEnd),
      cipherText: Uint8List.sublistView(bytes, headerEnd, bytes.length - 16),
      tag: Uint8List.sublistView(bytes, bytes.length - 16),
    );
  }

  static List<int> _uint32(int value) =>
      (ByteData(4)..setUint32(0, value)).buffer.asUint8List();
}
