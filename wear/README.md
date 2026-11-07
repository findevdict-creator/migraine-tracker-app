# Aurawell for Wear OS

The watch companion (phase 27). It starts and ends an attack, sets the
intensity and shows today's level on a tile. It never goes online: it
talks only to the phone app through the Wearable data layer, using the
messages in `packages/watch_protocol`.

- Taps are saved on the watch first and sent to the phone until the phone
  acknowledges them, so they work with the phone out of reach.
- The phone sends the level, the running attack and every label in its
  language.

Build: `flutter build apk --debug --flavor dev` from this folder. The
application id and flavors match the phone app, which the data layer
requires (same package name, same signing key).

See `docs/phases/27-wear-os.md` for the details and the manual checks.
