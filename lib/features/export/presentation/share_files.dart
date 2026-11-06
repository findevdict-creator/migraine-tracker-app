import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

/// Hands files to the platform share sheet. Overridden in tests.
typedef ShareFiles = Future<void> Function(List<File> files, {String? text});

final shareFilesProvider = Provider<ShareFiles>(
  (_) => (files, {text}) async {
    await SharePlus.instance.share(
      ShareParams(files: [for (final f in files) XFile(f.path)], text: text),
    );
  },
);
