# Phase 37: Localization

Branch: `37-feat-localization`, cut from `36-feat-accuracy-self-audit`.
Requirement IDs: NFR localization (six launch languages, units by region).

## What was done

### Six more languages

`lib/core/l10n/arb/` now has `app_es`, `app_pt`, `app_de`, `app_fr`,
`app_hi` and `app_ja` next to English. Each one holds every key in
`app_en.arb`, and the app follows the phone's language with English as the
fallback (`AppLocales.supported`).

- Plurals use each language's own categories (Hindi and Japanese only need
  `other`, with `=0` and `=1` kept where the English text says something
  different for them).
- Placeholders were checked against English for every key, so no
  translation can drop or rename a value.
- **MIDAS and HIT-6 items stay in English** in every language. They are
  validated, licensed instruments, and a home-made translation would make
  scores incomparable. The form shows a translated note saying so
  (`questionnaireEnglishNote`) whenever the app is not in English. The
  intros, buttons and results around them are translated.
- Two strings that lived in the config as English text moved to the ARB
  files so they translate: the wellness disclaimer (`wellnessDisclaimer`)
  and the "About the data" source names and coverage. `AppDataSources`
  keeps the id, link, licence and a `DataCoverage` value.

Everything outside the widget tree now uses the phone's language too:
notifications (including times, with the date symbols loaded in the
background isolate), the home-screen widget and the watch. Before this
phase those were always English (`deviceLocaleProvider` in
`lib/core/l10n/device_locale.dart`).

### Units

`lib/core/units/units.dart`:

- Pressure in hPa, inHg or mmHg; temperature in °C or °F. Values are
  still stored in hPa and °C; only the display changes.
- The first choice comes from the phone's region (`AppUnits`: inHg and °F
  in the US, °F also in a few other regions), then Settings > Units.
- Numbers follow the language (German gets a decimal comma) and never show
  a minus zero.
- Every pressure the app shows goes through it: the environment card and
  screen, the chart axis, the barometer, notification settings and texts,
  the widget, the watch, insights and the doctor report.
- The environment screen gained a "Temperature now" line, which is the
  only temperature the app shows, so the °C/°F switch has a visible effect.

### The PDF in each language

The PDF engine draws text without complex-script shaping, and its built-in
Helvetica covers Latin-1 only.

- es, pt, de and fr print with Helvetica. A test builds the report in each
  and checks every character is in Latin-1, so a „quote“ or a dash outside
  it cannot slip in and print blank.
- Japanese embeds Noto Sans JP (`assets/fonts/NotoSansJP-Regular.ttf`,
  SIL Open Font License, registered in the app's licence page).
- Hindi prints in English (`AppLocales.pdfFallback`). Devanagari needs
  shaping the engine does not have; the app screens and the share page are
  unaffected because Flutter and browsers shape it properly.

### The share page

`hosting/share.js` has the page's own labels in every language. The report
document now carries its language (`lang`), and the page uses it for its
labels and the expiry date, then the browser's languages, then English.
Older documents without `lang` fall back to the browser.

### Pseudo-locale and CI

- `tool/pseudo_arb.dart` generates `app_en_XA.arb`: every letter
  accented, each message wrapped in ⟦ ⟧ and padded by about a third, with
  placeholders and plural syntax untouched. CI fails if it is stale
  (`dart run tool/pseudo_arb.dart --check`).
- `test/l10n/pseudo_locale_test.dart` opens 20 screens on a 360 × 720
  phone, scrolls each to the end, and fails on any overflow or on visible
  plain-ASCII words outside the ⟦ ⟧ marks. It found and this phase fixed
  a clipped header on the environment factors card and the two English
  strings in the config above. The same walk runs in each of the six real
  languages for overflow.
- Dev and staging builds offer the pseudo-locale, which matches Android's
  "English (XA)" developer language, for checking by eye.
- `tool/copy_lint.dart` now also checks per-language stems for predict,
  diagnose and cure (`bannedStems`), matched at the start of a word so
  that, for example, Spanish "procurar" or French "mercure" pass. German
  "Vorhersage" is the weather forecast and is allowed.

## Configuration

All in `lib/config/app_config.dart`:

| Value | Default | Meaning |
| ----- | ------- | ------- |
| `AppLocales.supported` | en, es, pt, de, fr, hi, ja | languages offered |
| `AppLocales.pdfFallback` | `{'hi': 'en'}` | language the PDF uses instead |
| `AppLocales.pdfFonts` | `{'ja': AppAssets.pdfFontJapanese}` | embedded PDF font per language |
| `AppLocales.pseudo` | `en_XA` | pseudo-locale, dev and staging only |
| `AppUnits.inHgRegions` | US | regions defaulting to inHg |
| `AppUnits.fahrenheitRegions` | US, BS, BZ, KY, LR, PW | regions defaulting to °F |
| `AppUnits.*Digits` | hPa 1, inHg 2, mmHg 1 | decimals shown |
| `AppAssets.pdfFontJapanese` | `assets/fonts/NotoSansJP-Regular.ttf` | Japanese PDF font |

Adding a language: add the ARB file, add it to `AppLocales.supported`,
add its stems to `bannedStems` in `tool/copy_lint.dart`, add its labels to
`STRINGS` in `hosting/share.js`, and check whether the PDF needs a font
(`pdfFonts`) or a fallback (`pdfFallback`).

## Tests

- `test/core/units/units_test.dart`: conversion and formatting per unit,
  signed changes without minus zero, thresholds, whole-degree
  temperatures, the German decimal comma, region defaults, picking the
  phone's language, the Japanese PDF loading its font, Hindi falling back.
- `test/l10n/pseudo_locale_test.dart`: the pseudo-locale walk and the
  overflow walk in each language (7 tests).
- `test/features/report/report_document_test.dart`: in each language the
  document names its language, and for Helvetica languages every
  character is in Latin-1 and the PDF builds.
- Existing tests updated for the renamed placeholders (pressure strings
  now carry their unit) and the translated disclaimer.
- Full suites: 498 app tests and 66 functions tests.

## Acceptance criteria

- [x] All screens in six languages without clipping (pseudo and per-language walks).
- [x] Units switch hPa/inHg and °C/°F, defaulting by region.
- [x] Pseudo-localization check in CI.
- [x] Copy lint covers each language.
- [ ] Native-speaker review of each language (What M must fill in).

## Manual checks

1. Set the phone to each language in turn. Home, Settings, a scheduled
   notification, the home-screen widget and the doctor report PDF are in
   that language with nothing cut off.
2. Japanese: the PDF shows Japanese text. Hindi: the app is in Hindi and
   the PDF in English.
3. Settings > Units: switch to inHg, then mmHg, then °F. The pressure
   card, chart axis, barometer, notification text and widget follow.
4. A phone with its region set to the United States starts on inHg and °F.
5. Share a link from a German report and open it in a browser set to
   English: the page labels are German, matching the report.
6. On a dev build, set Android's developer language "English (XA)": every
   string shows accented and bracketed.

## What M must fill in

- **Native-speaker review** of es, pt, de, fr, hi and ja before release,
  safety copy first (disclaimers, overuse notes, the risk explainer), and
  the reviewer's banned words added to `bannedStems`.
- **Licensed MIDAS and HIT-6 translations** if they should be offered;
  until then the items stay in English by design.
- Store listings and screenshots per language.

## Risk and rollback

- Removing a language is removing its ARB file and its `AppLocales`
  entry; the app falls back to English.
- Units only change display; stored values are untouched, so switching
  back is lossless.
- The 5.7 MB Japanese font adds to the app size. Dropping the
  `pdfFonts` entry and the file makes the Japanese PDF fall back to
  whatever `pdfFallback` names.
