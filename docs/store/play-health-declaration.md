# Google Play: Health Connect declaration

Text for the Play Console "Health apps" declaration and the Health
Connect permissions form, for version 1.0.0. The rest of App content is in
[play-data-safety.md](play-data-safety.md); the release steps are in
[docs/release/README.md](../release/README.md).

## App category

Health and fitness: symptom and wellness tracking. The app is not a medical
device and does not diagnose or treat any condition.

## Why the app uses Health Connect

The person logs migraine attacks and a daily check-in. With their consent,
the app reads a few types from Health Connect so the check-in needs fewer
taps and so the person can see those values next to their own entries.
Nothing read from Health Connect leaves the device.

## Permissions requested and their use

| Permission | Used for |
| ---------- | -------- |
| `READ_SLEEP` | Minutes asleep the night before, mapped to the 1 to 5 sleep-quality scale on the daily check-in |
| `READ_RESTING_HEART_RATE` | Shown next to the person's own entries on their timeline |
| `READ_HEART_RATE_VARIABILITY` | Shown next to the person's own entries on their timeline |
| `READ_STEPS` | Shown next to the person's own entries on their timeline |
| `READ_MENSTRUATION` | Period start days for the opt-in cycle tracking feature |
| `READ_HEALTH_DATA_HISTORY` | First import of up to 30 days so the check-in history is not empty |

Each permission is behind its own switch on the app's Health data screen,
with a one-sentence reason next to it. The app requests only the
permissions whose switches the person turns on.

## Data handling

- Data read from Health Connect is stored in the app's encrypted on-device
  database and is not transmitted to any server.
- It is not used for advertising, not sold, and not shared with third
  parties.
- The person can switch each type off at any time, which deletes what was
  imported for that type; "Delete everything" in Settings removes all
  app data.
- Exports the person starts themselves (JSON, CSV) include imported
  samples, because the data belongs to the person.

## Privacy policy

Link: `AppIdentity.privacyPolicyUrl` (M to publish). The policy must name
Health Connect, the types above, on-device storage and the deletion
controls.

## Rationale screen

`androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE` opens the app's
Health data screen, which carries the reasons.
