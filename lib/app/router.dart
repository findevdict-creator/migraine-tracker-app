import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_screen.dart';
import 'package:migraine_tracker/features/barometer/presentation/barometer_screen.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_screen.dart';
import 'package:migraine_tracker/features/cycle/presentation/cycle_screen.dart';
import 'package:migraine_tracker/features/dev_tools/presentation/theme_gallery_screen.dart';
import 'package:migraine_tracker/features/home/presentation/home_screen.dart';
import 'package:migraine_tracker/features/medication/presentation/medication_log_screen.dart';
import 'package:migraine_tracker/features/settings/presentation/settings_screen.dart';
import 'package:migraine_tracker/features/weather/presentation/environment_screen.dart';

/// Route paths. Features register their routes here so deep links, widgets
/// and notifications share one table.
abstract final class AppRoutes {
  static const String home = '/';
  static const String devThemeGallery = '/dev/theme';
  static const String attackPattern = '/attack/:id';
  static String attack(String id) => '/attack/$id';
  static const String checkinPattern = '/checkin/:date';
  static const String medications = '/medications';
  static const String cycle = '/cycle';
  static const String settings = '/settings';
  static const String environment = '/environment';
  static const String barometer = '/barometer';
  static String checkin(String date) => '/checkin/$date';
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
      GoRoute(
        path: AppRoutes.attackPattern,
        name: 'attack',
        builder: (context, state) =>
            AttackScreen(attackId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.checkinPattern,
        name: 'checkin',
        builder: (context, state) =>
            CheckinScreen(date: state.pathParameters['date']!),
      ),
      GoRoute(
        path: AppRoutes.medications,
        name: 'medications',
        builder: (context, state) => const MedicationLogScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.environment,
        name: 'environment',
        builder: (context, state) => const EnvironmentScreen(),
      ),
      GoRoute(
        path: AppRoutes.barometer,
        name: 'barometer',
        builder: (context, state) => const BarometerScreen(),
      ),
      if (AppFeatureFlags.cycleTrackingAvailable)
        GoRoute(
          path: AppRoutes.cycle,
          name: 'cycle',
          builder: (context, state) => const CycleScreen(),
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
