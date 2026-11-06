import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/features/home/presentation/home_screen.dart';

/// Route paths. Features register their routes here so deep links, widgets
/// and notifications share one table.
abstract final class AppRoutes {
  static const String home = '/';
}

/// The app router. Kept in a provider so features can read it for navigation
/// from controllers and so tests can override it.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
