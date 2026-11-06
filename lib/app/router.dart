import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/features/dev_tools/presentation/theme_gallery_screen.dart';
import 'package:migraine_tracker/features/home/presentation/home_screen.dart';

/// Route paths. Features register their routes here so deep links, widgets
/// and notifications share one table.
abstract final class AppRoutes {
  static const String home = '/';
  static const String devThemeGallery = '/dev/theme';
}

/// The app router. Kept in a provider so features can read it for navigation
/// from controllers and so tests can override it.
final routerProvider = Provider<GoRouter>((ref) {
  final config = ref.watch(appConfigProvider);
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      if (config.showDevTools)
        GoRoute(
          path: AppRoutes.devThemeGallery,
          name: 'devThemeGallery',
          builder: (context, state) => const ThemeGalleryScreen(),
        ),
    ],
  );
});
