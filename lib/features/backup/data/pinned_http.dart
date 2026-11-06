import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// An HTTP client that trusts only the roots in [pem], not the system
/// store. A proxy or a mis-issued certificate from any other authority
/// fails the handshake.
http.Client pinnedClient(String pem) {
  // A new SecurityContext starts without the system roots.
  final context = SecurityContext()
    ..setTrustedCertificatesBytes(utf8.encode(_certificatesOnly(pem)));
  final io = HttpClient(context: context)
    ..connectionTimeout = AppBackup.requestTimeout;
  return IOClient(io);
}

/// Drops the comment lines, which BoringSSL does not accept.
String _certificatesOnly(String pem) =>
    pem.split('\n').where((l) => !l.startsWith('#')).join('\n');
