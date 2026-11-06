import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';

/// Home screen. Empty in the scaffold phase; the risk card, load meter and
/// start-attack button arrive in their own phases.
class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(config.displayName),
        actions: [
          if (config.showDevTools)
            IconButton(
              icon: const Icon(Icons.palette_outlined),
              tooltip: l10n.devThemeGalleryTitle,
              onPressed: () => context.push(AppRoutes.devThemeGallery),
            ),
        ],
      ),
      body: Center(
        child: Text(l10n.homeEmptyState, textAlign: TextAlign.center),
      ),
    );
  }
}
