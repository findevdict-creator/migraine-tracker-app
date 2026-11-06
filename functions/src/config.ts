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
    /** Hosts used once the commercial key is set; Premium makes the app commercial. */
    customerForecastUrl: "https://customer-api.open-meteo.com/v1/forecast",
    customerAirQualityUrl: "https://customer-air-quality-api.open-meteo.com/v1/air-quality",
  },

  /** Premium tier (phase 35). */
  premium: {
    /** RevenueCat entitlement; must equal AppPremium.entitlementId in the app. */
    entitlementId: "premium",
    /**
     * Refuse Premium-only calls (creating share links) without an active
     * entitlement. Set false together with AppFeatureFlags.premiumAvailable
     * to make everything free. Always skipped on the emulator.
     */
    enforceOnServer: true as boolean,
    /** Secret Manager name of the value RevenueCat sends in the Authorization header. */
    webhookAuthSecret: "REVENUECAT_WEBHOOK_AUTH",
    /**
     * Accept sandbox purchases. App Review and TestFlight buy in the sandbox
     * against production builds, so this stays true in every project.
     */
    acceptSandbox: true as boolean,
  },

  /** Silent push wake-ups (phase 22). */
  push: {
    /** Cloud Scheduler expression for the wake-up function. */
    schedule: "every 6 hours",
    /** Tokens not re-registered within this window are dropped (Firestore TTL). */
    tokenTtlMs: 60 * 24 * 60 * 60 * 1000,
    /** FCM multicast limit per request. */
    batchSize: 500,
    /** `data.type` the app's handler expects. */
    wakeupType: "wakeup",
  },

  /** Clinician share links (phase 34). */
  shareLink: {
    /** 16 random bytes = a 128-bit token, 22 characters in base64url. */
    tokenBytes: 16,
    /** Lifetimes the app may ask for; mirrors AppThresholds.shareLinkDays. */
    allowedDays: [7, 30],
    /** Largest report snapshot accepted, as JSON. */
    maxDocumentBytes: 256 * 1024,
    /** Report document format the share page can draw. */
    documentVersion: 1,
    /** Expired snapshots are also removed by Firestore TTL on `expiresAt`. */
    sweepSchedule: "every 24 hours",
    sweepBatch: 400,
  },

  /** Account purge deadline after deletion, documented in the privacy policy. */
  purgeWithinMs: 24 * 60 * 60 * 1000,

  /** Account deletion (phase 32). */
  account: {
    /**
     * Cloud Scheduler expression for the purge sweep. Must run well inside
     * `purgeWithinMs` so a failed purge is retried several times.
     */
    sweepSchedule: "every 1 hours",
    /** Sweep interval in ms; the test checks it fits the deadline. */
    sweepEveryMs: 60 * 60 * 1000,
    /** Documents deleted per batch when purging a collection. */
    batchSize: 400,
  },

  /** Firestore collection names. */
  collections: {
    weatherCells: "weather_cells",
    pushTokens: "push_tokens",
    users: "users",
    shareSnapshots: "share_snapshots",
    auditCounts: "audit_counts",
    /** One tombstone per deleted account until its purge has finished. */
    accountDeletions: "account_deletions",
    /** One document per account with its Premium expiry, written by the RevenueCat webhook. */
    entitlements: "entitlements",
  },

  /** Storage paths. */
  storage: {
    backupsPrefix: "backups",
  },
} as const;
