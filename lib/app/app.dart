import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/generated/app_localizations.dart';
import 'package:migraine_tracker/core/theme/app_theme.dart';
import 'package:migraine_tracker/core/theme/app_typography.dart';
import 'package:migraine_tracker/features/notifications/presentation/notification_responses.dart';
import 'package:migraine_tracker/features/onboarding/application/onboarding_state.dart';
import 'package:migraine_tracker/features/push/presentation/push_lifecycle.dart';
import 'package:migraine_tracker/features/weather/presentation/weather_lifecycle.dart';

/// Root widget: wires the router, the themes and the localizations.
class MigraineTrackerApp extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    // Splash until the onboarding flag is known, so the router starts on
    // the right screen instead of flashing one and redirecting.
    if (ref.watch(onboardingStateProvider) == null) {
      return MaterialApp(
        title: config.displayName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const Scaffold(
          key: ValueKey('splash'),
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: config.displayName,
      debugShowCheckedModeBanner: config.flavor.isNonProd,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
      builder: (context, child) => PushWakeups(
        child: NotificationResponses(
          child: WeatherRefreshOnResume(
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: AppTypography.clampedScaler(context)),
              child: child!,
            ),
          ),
        ),
      ),
      supportedLocales: AppLocales.supported,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
