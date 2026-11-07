# Store listing (English)

Source text for Play and the App Store, version 1.0.0. Translations
follow the same native-speaker review as the app (CONFIGURATION item 16).
Never use "predict", "diagnose" or "cure", in any language: the
same rule `tool/copy_lint.dart` enforces in the app.

## Name and category

| Field | Value |
| ----- | ----- |
| App name | Aurawell (`AppIdentity.name`) |
| Subtitle (App Store, 30 characters) | Log attacks, spot your triggers |
| Short description (Play, 80 characters) | Log migraine attacks in one tap and see which triggers line up with yours. |
| Category | Health & Fitness (both stores) |
| Content rating | Everyone (Play questionnaire: no violence, no user-generated sharing, no ads); App Store 4+ |
| Support URL | `AppIdentity.websiteUrl` |
| Privacy policy | `AppIdentity.privacyPolicyUrl` |
| Keywords (App Store, 100 characters) | migraine,headache,diary,log,trigger,weather,pressure,barometer,aura,medication,doctor,report |

## Description

Aurawell helps you log attacks quickly and see what tends to come
before them, so you can plan your day and bring clear notes to your
doctor.

**Log in one tap.** Start an attack from the home screen, a widget or your
watch. Add pain intensity, where it hurts, symptoms, medication and notes
when you are ready. The attack screen uses a dark, low-light theme.

**A daily check-in in seconds.** Sleep, stress, neck tension, water and
screen time, with values filled in from Apple Health or Health Connect
if you allow it.

**Weather that matters for migraine.** Air pressure changes over the last
48 hours and the next 24, plus temperature, humidity, air quality and
pollen. Your phone's barometer adds readings where it has one.

**Today's risk level.** Low, Moderate or High, worked out from your own
history and the forecast. It is a planning aid, not a promise, and the
app shows how often High days were followed by an attack.

**Your triggers, in plain numbers.** See which factors appeared before
your attacks more often than on other days, with how many days each
finding is based on.

**A report for your doctor.** Attack days, medication days with overuse
notes, triggers, MIDAS and HIT-6 scores, and a calendar, as a PDF or a
temporary link.

**Private by design.** Everything you log stays on your phone. No account
is needed. If you want a backup, it is encrypted on your phone with a
passphrase only you know.

**Premium** adds a share link for your clinician, two-week experiments,
extended environment factors and backup across phones. Everything else is
free, with no time limit.

Aurawell offers general wellness information and is not a medical
device. Talk to your clinician about your care and treatment.

## Screenshots

Take them from a dev or staging build with the demo data, in light theme,
at 6.7" (1290 × 2796) for the App Store and 1080 × 2400 for Play:

1. Home with today's level and the pressure card.
2. The attack screen mid-attack.
3. The environment screen with the 72-hour pressure chart.
4. Insights with two or three findings.
5. The doctor report preview.
6. The daily check-in.

## Graphics

Rendered by `tool/store_assets` from the brand artwork and colour (see
[assets](assets/)):

- `play_icon_512.png`: Play hi-res icon.
- `play_feature_graphic.png`: Play feature graphic, 1024 × 500.
- `app_store_icon_1024.png`: App Store icon (the Xcode asset catalogue
  carries the same image).

Replace `assets/brand/logo_mark.svg` with the final artwork and re-run.
