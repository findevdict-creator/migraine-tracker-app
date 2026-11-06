@Tags(['network'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/backup/data/pinned_http.dart';

/// Proves the pinning against the real hosts: Cloud Storage passes the
/// handshake with only the bundled roots, and a site under another
/// authority fails it.
void main() {
  final pem = File(AppAssets.backupTrustRoots).readAsStringSync();

  test('the pinned client reaches Cloud Storage', () async {
    final client = pinnedClient(pem);
    addTearDown(client.close);
    final res = await client.get(
      Uri.https(AppBackup.storageHost, '/v0/b/pinning-check.appspot.com/o'),
    );
    // Any HTTP answer means the TLS handshake was accepted.
    expect(res.statusCode, inInclusiveRange(200, 599));
  });

  test('the pinned client refuses a site outside the pinned roots', () async {
    final client = pinnedClient(pem);
    addTearDown(client.close);
    await expectLater(
      client.get(Uri.https('example.com', '/')),
      throwsA(isA<TlsException>()),
    );
  });
}
