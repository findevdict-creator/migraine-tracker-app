/// Central configuration for the whole app.
///
/// This is the ONE file to edit when something configurable changes:
/// app name, bundle ids, flavors, colours, typography, logos and assets,
/// API endpoints, Firebase projects, feature flags, thresholds and locales.
/// No other file in `lib/` may hard-code any of these values; every screen,
/// service and theme reads them from here.
///
/// Secrets (API keys, Firebase options) are NOT written in this file. They
/// come in through `--dart-define-from-file=env/<flavor>.json` and are read
/// by [AppEnv] below with `String.fromEnvironment`. The placeholder files in
/// `env/` list every key that must be filled in.
library;

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Flavors
// ---------------------------------------------------------------------------

/// Build flavor. Selected by the entry point (`main_dev.dart`,
/// `main_staging.dart`, `main_prod.dart`), never by runtime detection.
enum AppFlavor {
  /// Local development against emulators; debug tooling on.
  dev,

  /// Internal and external beta builds against the staging Firebase project.
  staging,

  /// Store builds.
  prod;

  /// True for every flavor that is not a store build.
  bool get isNonProd => this != AppFlavor.prod;
}

// ---------------------------------------------------------------------------
// Identity
// ---------------------------------------------------------------------------

/// App identity: names, identifiers and public links.
class AppIdentity {
  const AppIdentity._();

  /// User-facing product name. Shown in the launcher, the app bar and reports.
  static const String name = 'Migraine Tracker';

  /// Short name used where space is tight (widgets, watch, notifications).
  static const String shortName = 'Migraine';

  /// Per-flavor suffix appended to [name] so testers can tell builds apart.
  static String displayName(AppFlavor flavor) => switch (flavor) {
    AppFlavor.dev => '$name (dev)',
    AppFlavor.staging => '$name (beta)',
    AppFlavor.prod => name,
  };

  /// Base application id. Flavors append a suffix (see
  /// `android/app/build.gradle.kts` and the iOS schemes, which mirror this).
  static const String bundleId = 'app.migrainetracker.migraine_tracker';

  /// Application id for a flavor. Must match the native build configuration.
  static String bundleIdFor(AppFlavor flavor) => switch (flavor) {
    AppFlavor.dev => '$bundleId.dev',
    AppFlavor.staging => '$bundleId.staging',
    AppFlavor.prod => bundleId,
  };

  /// Scheme used by deep links (widgets, watch, notifications).
  static const String deepLinkScheme = 'migrainetracker';

  /// Support and legal links shown in settings and on the stores.
  static const String supportEmail = 'support@migrainetracker.app';
  static const String privacyPolicyUrl = 'https://migrainetracker.app/privacy';
  static const String termsUrl = 'https://migrainetracker.app/terms';
  static const String websiteUrl = 'https://migrainetracker.app';

  /// One-line wellness disclaimer shown under the risk level and in reports.
  static const String wellnessDisclaimer =
      'General wellness information, not medical advice. '
      'Talk to your clinician about treatment.';
}

// ---------------------------------------------------------------------------
// Environment (secrets and endpoints)
// ---------------------------------------------------------------------------

/// Values injected at build time with `--dart-define-from-file`.
///
/// Every key here has a placeholder in `env/dev.json`, `env/staging.json.example`
/// and `env/prod.json.example`. An empty string means "not configured" and the
/// feature that needs it degrades gracefully (for example, the weather feed
/// shows a "not configured" state instead of crashing).
class AppEnv {
  const AppEnv._();

  // Firebase (one project per flavor). Filled from the Firebase console,
  // Project settings > General > Your apps.
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
  );
  static const String firebaseAppIdAndroid = String.fromEnvironment(
    'FIREBASE_APP_ID_ANDROID',
  );
  static const String firebaseAppIdIos = String.fromEnvironment(
    'FIREBASE_APP_ID_IOS',
  );
  static const String firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const String firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
  );
  static const String firebaseIosBundleId = String.fromEnvironment(
    'FIREBASE_IOS_BUNDLE_ID',
  );

  /// Region the Cloud Functions are deployed to.
  static const String functionsRegion = String.fromEnvironment(
    'FUNCTIONS_REGION',
    defaultValue: 'us-central1',
  );

  /// Base URL of the HTTPS Cloud Functions. Empty means "derive from the
  /// Firebase project id and [functionsRegion]".
  static const String functionsBaseUrl = String.fromEnvironment(
    'FUNCTIONS_BASE_URL',
  );

  /// Host of the Firebase emulator suite when [AppFeatureFlags.useEmulators]
  /// is on.
  static const String emulatorHost = String.fromEnvironment(
    'FIREBASE_EMULATOR_HOST',
    defaultValue: '10.0.2.2',
  );

  /// RevenueCat public SDK keys (phase 35).
  static const String revenueCatApiKeyAndroid = String.fromEnvironment(
    'REVENUECAT_API_KEY_ANDROID',
  );
  static const String revenueCatApiKeyIos = String.fromEnvironment(
    'REVENUECAT_API_KEY_IOS',
  );

  /// True when the Firebase project has been configured for this build.
  static bool get hasFirebase =>
      firebaseProjectId.isNotEmpty && firebaseApiKey.isNotEmpty;
}

/// External API endpoints. The app never calls Open-Meteo directly in
/// production; it goes through the weather cache function (phase 10). The
/// direct URLs are kept here for the function's configuration and for
/// local development without Firebase.
class AppEndpoints {
  const AppEndpoints._();

  static const String openMeteoForecast =
      'https://api.open-meteo.com/v1/forecast';
  static const String openMeteoAirQuality =
      'https://air-quality-api.open-meteo.com/v1/air-quality';
  static const String openMeteoAttributionUrl = 'https://open-meteo.com/';

  /// Cloud Function names, one per server job.
  static const String weatherCacheFunction = 'weatherCache';
  static const String pushWakeupFunction = 'pushWakeup';
  static const String shareLinkFunction = 'shareLink';
  static const String purgeAccountFunction = 'purgeAccount';
  static const String auditCountsFunction = 'auditCounts';

  /// Resolves the base URL for HTTPS functions for a flavor.
  static String functionsBaseUrl(AppFlavor flavor) {
    if (AppEnv.functionsBaseUrl.isNotEmpty) return AppEnv.functionsBaseUrl;
    if (AppFeatureFlags.useEmulators(flavor)) {
      return 'http://${AppEnv.emulatorHost}:5001/'
          '${AppEnv.firebaseProjectId}/${AppEnv.functionsRegion}';
    }
    return 'https://${AppEnv.functionsRegion}-'
        '${AppEnv.firebaseProjectId}.cloudfunctions.net';
  }
}

// ---------------------------------------------------------------------------
// Feature flags
// ---------------------------------------------------------------------------

/// Feature flags. Static per flavor; a flag that must flip at runtime gets a
/// settings entry instead.
class AppFeatureFlags {
  const AppFeatureFlags._();

  /// Shows the theme gallery and other developer screens.
  static bool showDevTools(AppFlavor flavor) => flavor.isNonProd;

  /// Talk to the Firebase emulator suite instead of the cloud project.
  static bool useEmulators(AppFlavor flavor) => flavor == AppFlavor.dev;

  /// Crash reporting is always opt-in by the user; this flag decides whether
  /// the toggle exists at all.
  static bool crashReportingAvailable(AppFlavor flavor) => true;

  /// Features that ship behind a flag until their phase is complete.
  static const bool cycleTrackingAvailable = true;
  static const bool voiceLogAvailable = true;
  static const bool premiumAvailable = true;
  static const bool shareLinkAvailable = true;
  static const bool experimentsAvailable = true;
}

// ---------------------------------------------------------------------------
// Domain thresholds and timings
// ---------------------------------------------------------------------------

/// Numbers from the requirements doc that tune behaviour. Change here, not in
/// the feature code.
class AppThresholds {
  const AppThresholds._();

  /// Acute-medication days per calendar month that trigger the gentle notes.
  static const int medicationOveruseFirstNote = 10;
  static const int medicationOveruseSecondNote = 15;

  /// Logged attacks before the "still learning" badge disappears.
  static const int attacksBeforeModelIsTuned = 10;

  /// Completed attacks before the duration estimate is shown.
  static const int attacksBeforeDurationEstimate = 5;

  /// Exposures below which a factor is "not enough data".
  static const int minExposuresForInsight = 5;

  /// Attacks before the accuracy self-audit page appears.
  static const int attacksBeforeSelfAudit = 10;

  /// Default pressure-drop alert threshold, hPa over 24 h.
  static const double defaultPressureDropAlertHpa = 5;

  /// Weather refresh cadence.
  static const Duration weatherForegroundRefresh = Duration(hours: 3);
  static const Duration weatherBackgroundRefresh = Duration(hours: 24);

  /// Forecast window shown by default, in hours.
  static const int forecastWindowHours = 72;

  /// Days of weather kept on the device (past and future).
  static const int weatherPastDays = 7;
  static const int weatherForecastDays = 7;

  /// Location rounding before any network call, in degrees.
  static const double locationRoundingDegrees = 0.1;

  /// Days a check-in can be back-filled.
  static const int checkinBackfillDays = 7;

  /// Default daily check-in reminder time (local), until the user changes it.
  static const TimeOfDay defaultCheckinReminder = TimeOfDay(
    hour: 20,
    minute: 0,
  );

  /// Widget refresh cadence.
  static const Duration widgetRefresh = Duration(minutes: 30);

  /// Questionnaire reminder cadence.
  static const Duration questionnaireReminder = Duration(days: 90);

  /// Experiment comparison window, in days.
  static const int experimentWindowDays = 14;

  /// Share link lifetimes offered to the user.
  static const List<int> shareLinkDays = [7, 30];

  /// Attack-mode flow targets from the requirements doc.
  static const Duration attackLogTarget = Duration(seconds: 30);
  static const Duration checkinTarget = Duration(seconds: 10);
}

// ---------------------------------------------------------------------------
// Theme tokens
// ---------------------------------------------------------------------------

/// Colour, type and shape tokens. `lib/core/theme/` builds the Material 3
/// themes from these; widgets never reference a raw colour.
class AppThemeTokens {
  const AppThemeTokens._();

  /// Seed colour for the light and dark schemes.
  static const Color seed = Color(0xFF5B5BD6);

  /// Risk level colours. The light set is used as a fill with white text
  /// and as text on light surfaces; the dark set as text and fills on dark
  /// surfaces. All pairs meet WCAG 2.2 AA (4.5:1), checked by
  /// `test/core/theme/contrast_test.dart`.
  static const Color riskLow = Color(0xFF2E7D32);
  static const Color riskModerate = Color(0xFF9A5B00);
  static const Color riskHigh = Color(0xFFC62828);
  static const Color riskLowDark = Color(0xFF81C784);
  static const Color riskModerateDark = Color(0xFFFFB74D);
  static const Color riskHighDark = Color(0xFFEF9A9A);

  /// Attack theme: high-contrast dark palette for photophobia.
  static const Color attackBackground = Color(0xFF000000);
  static const Color attackSurface = Color(0xFF0E0E0E);
  static const Color attackSurfaceRaised = Color(0xFF1E1E1E);
  static const Color attackOnBackground = Color(0xFFE6E6E6);
  static const Color attackAccent = Color(0xFFFFB74D);
  static const Color attackMuted = Color(0xFFA0A0A0);

  /// Semantic colours (light surfaces; the dark theme reuses the risk set).
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFF9A5B00);
  static const Color danger = Color(0xFFC62828);
  static const Color info = Color(0xFF1565C0);
  static const Color infoDark = Color(0xFF90CAF9);

  /// Typography. Null family means the platform default.
  static const String? fontFamily = null;
  static const double fontDisplay = 44;
  static const double fontHeadline = 28;
  static const double fontTitle = 22;
  static const double fontBody = 17;
  static const double fontBodySmall = 15;
  static const double fontLabel = 15;

  /// Spacing scale in logical pixels.
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 24;
  static const double space6 = 32;

  /// Corner radii.
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 20;

  /// Tap targets. Attack-mode controls use the larger value.
  static const double minTapTarget = 48;
  static const double attackTapTarget = 56;

  /// Dynamic type ceiling the attack screen must honour without truncation.
  static const double maxTextScale = 2;

  /// Animation durations; honoured only when reduce-motion is off.
  static const Duration animationShort = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
}

// ---------------------------------------------------------------------------
// Storage
// ---------------------------------------------------------------------------

/// On-device storage names. Changing these after release needs a migration.
class AppStorage {
  const AppStorage._();

  /// SQLCipher database file inside the application support directory.
  static const String databaseFileName = 'migraine_tracker.db';

  /// Keystore entry that holds the database key.
  static const String databaseKeyName = 'migraine_tracker.db.key';
}

// ---------------------------------------------------------------------------
// Assets
// ---------------------------------------------------------------------------

/// Paths of bundled assets. Replace the files, keep the paths.
class AppAssets {
  const AppAssets._();

  static const String logo = 'assets/brand/logo.svg';
  static const String logoMark = 'assets/brand/logo_mark.svg';
  static const String launcherIcon = 'assets/brand/launcher_icon.png';
  static const String headMap = 'assets/images/head_map.svg';
  static const String routinesDir = 'assets/routines/';
}

// ---------------------------------------------------------------------------
// Localization
// ---------------------------------------------------------------------------

/// Supported locales. The first entry is the fallback.
class AppLocales {
  const AppLocales._();

  static const List<Locale> supported = [
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('de'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
  ];

  static const Locale fallback = Locale('en');
}

// ---------------------------------------------------------------------------
// Aggregate
// ---------------------------------------------------------------------------

/// The resolved configuration for the running flavor. Built once in
/// `bootstrap()` and provided through Riverpod as `appConfigProvider`.
@immutable
class AppConfig {
  const new({required this.flavor});

  final AppFlavor flavor;

  String get displayName => AppIdentity.displayName(flavor);
  String get bundleId => AppIdentity.bundleIdFor(flavor);
  bool get showDevTools => AppFeatureFlags.showDevTools(flavor);
  bool get useEmulators => AppFeatureFlags.useEmulators(flavor);
  bool get hasFirebase => AppEnv.hasFirebase;
  String get functionsBaseUrl => AppEndpoints.functionsBaseUrl(flavor);

  @override
  bool operator ==(Object other) =>
      other is AppConfig && other.flavor == flavor;

  @override
  int get hashCode => flavor.hashCode;

  @override
  String toString() => 'AppConfig(flavor: ${flavor.name})';
}
