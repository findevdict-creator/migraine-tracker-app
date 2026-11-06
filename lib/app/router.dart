import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_screen.dart';
import 'package:migraine_tracker/features/barometer/presentation/barometer_screen.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_screen.dart';
import 'package:migraine_tracker/features/cycle/presentation/cycle_screen.dart';
import 'package:migraine_tracker/features/dev_tools/presentation/theme_gallery_screen.dart';
import 'package:migraine_tracker/features/health/presentation/health_settings_screen.dart';
import 'package:migraine_tracker/features/home/presentation/home_screen.dart';
import 'package:migraine_tracker/features/insights/presentation/insights_screen.dart';
import 'package:migraine_tracker/features/medication/presentation/medication_log_screen.dart';
import 'package:migraine_tracker/features/notifications/presentation/notification_settings_screen.dart';
import 'package:migraine_tracker/features/onboarding/application/onboarding_state.dart';
import 'package:migraine_tracker/features/onboarding/presentation/level_explainer.dart';
import 'package:migraine_tracker/features/onboarding/presentation/onboarding_screen.dart';
import 'package:migraine_tracker/features/report/presentation/report_screen.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_screen.dart';
import 'package:migraine_tracker/features/settings/presentation/settings_screen.dart';
import 'package:migraine_tracker/features/weather/presentation/about_data_screen.dart';
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
  static const String aboutData = '/about-data';
  static const String health = '/health';
  static const String onboarding = '/onboarding';
  static const String explainer = '/explainer';
  static const String risk = '/risk';
  static const String insights = '/insights';
  static const String report = '/report';
  static const String notifications = '/notifications';
  static const String insightsMethod = '/insights/method';
  static String checkin(String date) => '/checkin/$date';
}

/// The app router. Kept in a provider so features can read it for navigation
/// from controllers and so tests can override it.
final routerProvider = Provider<GoRouter>((ref) {
  final config = ref.watch(appConfigProvider);
  final onboarding = OnboardingListenable(ref);
  ref.onDispose(onboarding.dispose);
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: onboarding,
    // First run: everything goes to onboarding until it is completed or
    // skipped. Null (still loading) is treated as done so existing users
    // never see a flash of the flow; the app shows a splash meanwhile.
    redirect: (context, state) {
      final done = ref.read(onboardingStateProvider) ?? true;
      final inFlow = state.matchedLocation == AppRoutes.onboarding;
      if (!done && !inFlow) return AppRoutes.onboarding;
      if (done && inFlow) return AppRoutes.environment;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.explainer,
        name: 'explainer',
        builder: (context, state) => const ExplainerScreen(),
      ),
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
        path: AppRoutes.risk,
        name: 'risk',
        builder: (context, state) => const RiskScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.report,
        name: 'report',
        builder: (context, state) => const ReportScreen(),
      ),
      GoRoute(
        path: AppRoutes.insights,
        name: 'insights',
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: AppRoutes.insightsMethod,
        name: 'insightsMethod',
        builder: (context, state) => const InsightsMethodScreen(),
      ),
      GoRoute(
        path: AppRoutes.barometer,
        name: 'barometer',
        builder: (context, state) => const BarometerScreen(),
      ),
      GoRoute(
        path: AppRoutes.aboutData,
        name: 'aboutData',
        builder: (context, state) => const AboutDataScreen(),
      ),
      if (AppFeatureFlags.healthSyncAvailable)
        GoRoute(
          path: AppRoutes.health,
          name: 'health',
          builder: (context, state) => const HealthSettingsScreen(),
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
