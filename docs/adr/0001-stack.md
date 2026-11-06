# ADR 0001: Stack

Date: 2026-11-06. Status: accepted.

## Context

The requirements doc compared Flutter with Expo and Firebase with Supabase
for a local-first migraine tracker that must ship on Android and iOS on the
same day, run its risk model on the device and cost nothing until it has
users.

## Decision

- Flutter (Dart) for the app, with Riverpod for state, go_router for
  navigation, Drift over SQLCipher for the database, freezed for models and
  intl for localization.
- Firebase on the Blaze plan for the thin server: Firestore, Cloud Storage,
  Cloud Functions in TypeScript, Cloud Messaging and Hosting.
- Open-Meteo through a Cloud Function cache for weather, air quality and
  pollen.
- The `health` package for HealthKit and Health Connect.
- RevenueCat for subscriptions.

## Consequences

- One codebase; the watchOS app (phase 28) and the widget UIs are the only
  native code.
- The phone is the source of truth; every feature except backup, share links
  and purchases works offline.
- Firestore has no portable dump, so the server schema is kept to five small
  collections that could be rebuilt elsewhere.
