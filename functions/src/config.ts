/**
 * Server-side configuration. The single place for region, TTLs, limits and
 * secret names. The Flutter app's counterpart is lib/config/app_config.dart;
 * values that both sides need (region, function names) must match.
 */
export const config = {
  /** Deploy region; must equal FUNCTIONS_REGION in the app's env files. */
  region: "us-central1",

  /** Weather cache. */
  weather: {
    /** Serve a cached cell series while younger than this. */
    freshForMs: 3 * 60 * 60 * 1000,
    /** Firestore TTL on weather_cells documents. */
    ttlMs: 48 * 60 * 60 * 1000,
    /** Cell rounding in degrees, mirrored by the app. */
    cellDegrees: 0.1,
    pastDays: 7,
    forecastDays: 7,
    /** Secret Manager name of the commercial Open-Meteo key; unset while non-commercial. */
    apiKeySecret: "OPEN_METEO_API_KEY",
    forecastUrl: "https://api.open-meteo.com/v1/forecast",
    airQualityUrl: "https://air-quality-api.open-meteo.com/v1/air-quality",
  },

  /** Share links. */
  shareLink: {
    tokenBytes: 16,
    allowedDays: [7, 30],
  },

  /** Account purge deadline after deletion, documented in the privacy policy. */
  purgeWithinMs: 24 * 60 * 60 * 1000,

  /** Firestore collection names. */
  collections: {
    weatherCells: "weather_cells",
    users: "users",
    shareSnapshots: "share_snapshots",
    auditCounts: "audit_counts",
  },

  /** Storage paths. */
  storage: {
    backupsPrefix: "backups",
  },
} as const;
