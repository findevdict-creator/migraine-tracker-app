# Phase 23: Doctor report

Branch: `23-feat-doctor-report`, cut from `22-feat-push-wakeup`.
Requirement IDs: FR-19.

## What was done

- **Summary model** (`ReportBuilder.build`, pure): from the attacks,
  doses, check-ins and learned weights of a date range it derives attack
  and attack-day counts, attacks per 30 days, mean intensity, a
  per-month table (attacks, attack days, mean intensity, acute days and
  the overuse note at 10 and 15 days), a calendar map of date to highest
  intensity, duration statistics (shortest, median, longest and five
  buckets at the clinical 4 h, 12 h, 24 h and 72 h boundaries), the
  factor insights of phase 20, one row per medication (doses, distinct
  days, relief answers), a pressure correlation (attacks that began
  after a 24 h fall of `defaultPressureDropAlertHpa` or more against
  check-in days that had one, and the ratio of the two shares), and
  symptom and head-location counts per attack.
- **PDF** (`ReportPdf`, A4, `pdf` package, on device): header with app
  name, period and generation date; six stat tiles; monthly table;
  calendar grid per month with shaded attack cells carrying the
  intensity; duration summary and buckets; factor table with ratio,
  exposure days, attacks after and an evidence word from the learned
  confidence (`riskConfidenceBands`); medication table; pressure
  paragraph; symptoms and locations in two columns; page numbers and a
  disclaimer that this is a self-reported diary summary from a wellness
  app and not a medical record. Every string comes from the ARB, so the
  PDF follows the app's language. Built-in Helvetica only (Latin-1), so
  the copy uses plain hyphens. No notes and no name in the PDF.
- **CSV** (`ReportCsv`): one file per attack (start, end, minutes,
  intensity, locations, symptoms, phases, linked doses, 24 h pressure
  change, notes) and one per day of the range (attacks, highest
  intensity, acute and preventive doses, the eight check-in fields,
  cycle day, pressure change). Column names are stable identifiers.
- **Screen** (`/report`, Settings > Doctor report): chips for 30, 90,
  180 and 365 days plus a custom range picker, a preview card with the
  counts, and three share buttons (PDF, spreadsheets, everything) that
  write to the temp directory and open the OS share sheet through
  `shareFilesProvider`, as the phase 09 exports do. Failures show a
  snackbar and never leave the screen busy.
- **Config**: `AppThresholds.defaultReportDays` (90).
- **Layout source**: the plan refers to a research document with the
  neurologist sources for the report layout. No such document is in the
  repository, so the layout follows the sections a standard headache
  diary summary carries (frequency per month, attack days, duration,
  intensity, acute-medication days with the overuse thresholds, triggers
  with sample sizes). M should compare it with the research document
  before release and list any section to add or drop.

## Tests

- `report_model_test.dart`: inclusive ranges and month lists across a
  year boundary; empty range; counts, calendar and durations; bucket
  boundaries; medication rows and the overuse note; pressure
  correlation; symptoms counted per attack, not per tap; the year
  fixture.
- `report_csv_test.dart`: one row per attack and per day, stable
  headers, quote escaping, linked medication names.
- `report_pdf_test.dart`: a year of fixture data renders in under 5 s
  (about 0.5 s on the CI runner) and starts with `%PDF-`; an empty
  period renders every section.
- `report_service_test.dart`: loads only the range from the database and
  writes the PDF and both CSV files with the expected names.
- `report_screen_test.dart`: opens from settings with the default period,
  a shorter preset narrows the preview, each share button hands the
  right files to the share sheet.
- Full suite: 304 tests.

## Acceptance criteria

- [x] On-device PDF and CSV for a date range with calendar, trends,
      duration, trigger table with confidence, medication days and
      weather correlation; shared through the OS share sheet.
- [x] Timed test: a year of fixture data renders under 5 s.
- [ ] Layout checked against the research document's neurologist
      sources (document not in the repository; see above).

## Manual checks

- Settings > Doctor report, pick 90 days, Share PDF: the share sheet
  opens with one PDF; open it in a viewer and check the calendar months
  match the attack log.
- Share spreadsheets: two CSV files open in a spreadsheet app with one
  row per attack and one per day.
- Custom: pick a range that starts before the first entry; the preview
  shows the counts for that range only.
