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

  /// The flavor named by the `APP_FLAVOR` define (the env file), for
  /// isolates that have no entry point of their own (push handlers).
  static AppFlavor fromEnvironment() => AppFlavor.values.firstWhere(
    (f) => f.name == AppEnv.flavorName,
    orElse: () => AppFlavor.prod,
  );
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

  /// Page behind the "talk to your clinician" notes (medication overuse).
  static const String clinicianGuidanceUrl =
      'https://migrainetracker.app/talk-to-your-clinician';

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

  /// Flavor name for isolates without an entry point (see
  /// [AppFlavor.fromEnvironment]); the env files set it.
  static const String flavorName = String.fromEnvironment(
    'APP_FLAVOR',
    defaultValue: 'prod',
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

  /// Free geocoding for the typed-city fallback. Only the typed name leaves
  /// the device; the result is rounded to a cell like any location.
  static const String openMeteoGeocoding =
      'https://geocoding-api.open-meteo.com/v1/search';

  /// Cloud Function names, one per server job.
  static const String weatherCacheFunction = 'weatherCache';
  static const String pushWakeupFunction = 'pushWakeup';
  static const String registerPushTokenFunction = 'registerPushToken';
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
/// Every outside source the app shows data from, for the "About the data"
/// screen. Add a row when a source is added; the screen lists this.
class AppDataSources {
  const AppDataSources._();

  static const List<DataSource> entries = [
    DataSource(
      id: 'open-meteo-weather',
      name: 'Open-Meteo weather',
      url: AppEndpoints.openMeteoAttributionUrl,
      licence: 'CC BY 4.0',
      coverage: 'Worldwide',
    ),
    DataSource(
      id: 'open-meteo-air-quality',
      name: 'Open-Meteo air quality and UV (CAMS)',
      url: AppEndpoints.openMeteoAttributionUrl,
      licence: 'CC BY 4.0',
      coverage: 'Worldwide, European AQI in Europe',
    ),
    DataSource(
      id: 'open-meteo-pollen',
      name: 'Open-Meteo pollen (CAMS)',
      url: AppEndpoints.openMeteoAttributionUrl,
      licence: 'CC BY 4.0',
      coverage: 'Europe only',
    ),
    DataSource(
      id: 'open-meteo-geocoding',
      name: 'Open-Meteo geocoding',
      url: AppEndpoints.openMeteoAttributionUrl,
      licence: 'CC BY 4.0',
      coverage: 'Worldwide',
    ),
    DataSource(
      id: 'device-barometer',
      name: 'Device barometer',
      url: null,
      licence: null,
      coverage: 'Phones with a pressure sensor',
    ),
  ];
}

/// One row of [AppDataSources.entries].
class DataSource {
  const DataSource({
    required this.id,
    required this.name,
    required this.url,
    required this.licence,
    required this.coverage,
  });

  final String id;
  final String name;
  final String? url;
  final String? licence;
  final String coverage;
}

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
  static const bool healthSyncAvailable = true;
  static const bool voiceLogAvailable = true;
  static const bool premiumAvailable = true;
  static const bool shareLinkAvailable = true;
  static const bool experimentsAvailable = true;

  /// Silent push wake-ups that refresh the forecast between opens. Needs
  /// a Firebase project with Cloud Messaging; off means local scheduling
  /// only.
  static const bool pushWakeupAvailable = true;
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

  /// Risk learning (FR-9). An exposure counts as followed by an attack
  /// when one starts on that day or the next ([riskAttackWindowDays] = 2,
  /// the 24 to 48 h before). [riskWeightShrinkage] exposure days bring a
  /// factor's confidence to one half; [attacksBeforeModelIsTuned] attacks
  /// let it reach one. Thresholds move to the person's own load
  /// distribution after [riskThresholdMinDays] days of data.
  static const int riskAttackWindowDays = 2;
  static const int riskWeightShrinkage = 10;
  static const double riskModeratePercentile = 0.6;
  static const double riskHighPercentile = 0.85;
  static const int riskThresholdMinDays = 30;
  static const double riskThresholdMinGap = 5;

  /// Days of history the learner reads, and days ahead that are scored.
  static const int riskHistoryDays = 730;
  static const int riskForecastDays = 3;

  /// Local notifications (FR-14). A rising level is announced the evening
  /// before at [riskRisingEveningHour] and the morning of at
  /// [riskRisingMorningHour] (local hours). "Is your attack over?" fires
  /// at the person's typical attack duration, [defaultAttackDuration]
  /// until [attacksBeforeDurationEstimate] attacks exist. Delivered event
  /// keys are kept for [notificationDedupeRetention] so the same event is
  /// never announced twice.
  static const int riskRisingEveningHour = 20;
  static const int riskRisingMorningHour = 8;
  static const Duration defaultAttackDuration = Duration(hours: 4);
  static const Duration notificationDedupeRetention = Duration(days: 7);
  static const Duration notificationLeadTime = Duration(minutes: 1);

  /// A push token is re-registered with the server after this long even
  /// when unchanged, so the server's TTL (60 days) never expires a live
  /// device.
  static const Duration pushTokenRefresh = Duration(days: 7);
  static const TimeOfDay defaultMedicationReminder = TimeOfDay(
    hour: 21,
    minute: 0,
  );

  /// Mean weight confidence below which the card says "low", and from
  /// which it says "high"; "medium" between.
  static const List<double> riskConfidenceBands = [0.3, 0.7];

  /// Exposures below which a factor is "not enough data".
  static const int minExposuresForInsight = 5;

  /// Period the doctor report opens with; the chips offer 30, 90, 180
  /// and 365 days plus a custom range.
  static const int defaultReportDays = 90;

  /// Insight buckets (FR-11) from the ratio of the learned weight to the
  /// population weight: a trigger at or above [insightTriggerLift], a
  /// protector at or below [insightProtectorLift], no clear effect
  /// between.
  static const double insightTriggerLift = 1.25;
  static const double insightProtectorLift = 0.8;

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

  /// Unpinned weather hours older than this are pruned.
  static const int weatherRetentionDays = 14;

  /// Cached weather older than this is shown with an "outdated" note.
  static const Duration weatherStaleAfter = Duration(hours: 6);

  /// Barometer (phase 12): one stored sample per interval while the app is
  /// open, the trend window shown on the gauge screen, how long samples are
  /// kept, and how old a reading may be to be stamped on a new attack.
  static const Duration barometerSampleInterval = Duration(minutes: 10);
  static const Duration barometerTrendWindow = Duration(hours: 24);
  static const Duration barometerRetention = Duration(hours: 48);
  static const Duration barometerStampMaxAge = Duration(minutes: 15);

  /// Calibration: median offset between station and sensor over this
  /// window, only once this many hourly pairs exist.
  static const Duration barometerCalibrationWindow = Duration(hours: 24);
  static const int barometerCalibrationMinPairs = 3;

  /// Gauge range in hPa.
  static const double barometerGaugeMinHpa = 950;
  static const double barometerGaugeMaxHpa = 1050;

  /// Health sync (phase 14): history imported on first consent, and the
  /// sleep-minute bounds (inclusive upper) that map imported sleep onto the
  /// 1 to 5 check-in scale: under 5 h is 1, under 6 h is 2, and so on.
  static const int healthImportDays = 30;
  static const List<int> sleepQualityMinuteBands = [300, 360, 420, 480];

  /// Environment factor bands (phase 13): upper bounds, inclusive, of the
  /// low, moderate and high bands. Above the last bound is "very high".
  /// US AQI follows the EPA breakpoints; UV the WHO index; pollen is in
  /// grains per cubic metre as served by Open-Meteo.
  static const List<int> aqiUsBands = [50, 100, 150];
  static const List<int> aqiEuBands = [20, 40, 60];
  static const List<double> uvBands = [2, 5, 7];
  static const List<double> pollenBands = [20, 50, 100];

  /// Days a check-in can be back-filled.
  static const int checkinBackfillDays = 7;

  /// Cycle length assumed until enough periods are logged, and the range an
  /// averaged length is clamped to.
  static const int defaultCycleLengthDays = 28;
  static const int minCycleLengthDays = 21;
  static const int maxCycleLengthDays = 35;

  /// Period starts averaged for the cycle length.
  static const int cycleLengthSampleSize = 6;

  /// Default daily check-in reminder time (local), until the user changes it.
  static const TimeOfDay defaultCheckinReminder = TimeOfDay(
    hour: 20,
    minute: 0,
  );

  /// Widget refresh cadence.
  static const Duration widgetRefresh = Duration(minutes: 30);

  /// Questionnaire reminder cadence (MIDAS and HIT-6 ask about the last
  /// three months), and the local hour the reminder fires.
  static const Duration questionnaireReminder = Duration(days: 90);
  static const int questionnaireReminderHour = 10;

  /// Voice logging: the longest a listen runs, the silence that ends it,
  /// and whether recognition must stay on the device (FR-3). With
  /// [voiceOnDeviceOnly] a phone without an offline speech model shows a
  /// message instead of sending audio to a server.
  static const Duration voiceListenFor = Duration(seconds: 20);
  static const Duration voicePauseFor = Duration(seconds: 3);
  static const bool voiceOnDeviceOnly = true;

  /// Points of score history drawn on the questionnaire chart.
  static const int questionnaireChartPoints = 8;

  /// Experiment comparison window, in days.
  static const int experimentWindowDays = 14;

  /// Share link lifetimes offered to the user.
  static const List<int> shareLinkDays = [7, 30];

  /// Attack-mode flow targets from the requirements doc.
  static const Duration attackLogTarget = Duration(seconds: 30);
  static const Duration checkinTarget = Duration(seconds: 10);
}

// ---------------------------------------------------------------------------
// Background tasks
// ---------------------------------------------------------------------------

/// Names of scheduled background jobs. The iOS identifiers must also be
/// listed in `ios/Runner/Info.plist` under BGTaskSchedulerPermittedIdentifiers.
class AppBackgroundTasks {
  const AppBackgroundTasks._();

  /// Daily weather refresh (workmanager / BGTaskScheduler).
  static const String weatherRefresh = 'app.migrainetracker.weatherRefresh';

  /// `data.type` of the silent push the wake-up function sends; must match
  /// `config.push.wakeupType` in `functions/src/config.ts`.
  static const String pushWakeupType = 'wakeup';
}

/// Local notification channels (Android) and categories (iOS). The ids
/// are stored by the OS; renaming one creates a new channel.
class AppNotificationChannels {
  const AppNotificationChannels._();

  static const String alerts = 'alerts';
  static const String reminders = 'reminders';
  static const String attack = 'attack';

  /// iOS category carrying the "End attack" action.
  static const String attackCategory = 'attack';

  /// Action identifier shared by Android and iOS.
  static const String endAttackAction = 'end-attack';

  /// Android small icon resource.
  static const String androidIcon = '@mipmap/ic_launcher';
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

  /// Segment colours of the load meter, one per factor in `Factor` order
  /// (fourteen). Chosen to stay distinguishable from their neighbours on
  /// both light and dark surfaces; names are always shown beside them.
  static const List<Color> factorPalette = [
    Color(0xFF5B5BD6), // pressure drop
    Color(0xFF26A69A), // humidity
    Color(0xFFEF6C00), // temperature swing
    Color(0xFF8D6E63), // air quality
    Color(0xFF9CCC65), // pollen
    Color(0xFFFFCA28), // bright light
    Color(0xFF42A5F5), // screen time
    Color(0xFF7E57C2), // poor sleep
    Color(0xFFEC407A), // stress
    Color(0xFFAB47BC), // neck tension
    Color(0xFF6D4C41), // caffeine
    Color(0xFFD4E157), // alcohol
    Color(0xFF29B6F6), // dehydration
    Color(0xFFF06292), // cycle phase
  ];

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
