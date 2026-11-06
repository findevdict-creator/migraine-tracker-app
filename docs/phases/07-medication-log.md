# Phase 07: Medication log

Branch: `07-feat-medication-log`, cut from `06-feat-daily-checkin`.
Requirement IDs: FR-18 (acute and preventive log, dose, time, relief at
2 h, acute-day counter per calendar month, notes at 10 and 15 days with a
"talk to your clinician" link). Safety NFR: the notes never claim a
diagnosis; copy lint still passes.

## What was done

- **Domain.** `MedicationEntity` (name, dose, time, kind acute or
  preventive, relief at 2 h none/partial/full, optional attack id),
  `MedicationRepository` with a Drift implementation and mapper, and
  streams on the DAO for the attack view and the month view.
- **Acute-day counter.** `AcuteDayCounter.daysInMonth` counts distinct
  local calendar days with at least one acute dose; preventive doses never
  count; two doses on one day count once. Month edges are local midnight.
  `OveruseNote.forDays` maps the count to none, first (10) or second (15)
  using `AppThresholds.medicationOveruseFirstNote` and `SecondNote`.
- **Entry sheet** (`showMedicationEntrySheet`): recent names as one-tap
  suggestion chips (distinct, most recent first), free-text name, dose,
  acute or preventive segmented control, taken-at time picker defaulting
  to now. Used both standalone and inside an attack.
- **Standalone screen** at `/medications` (medication icon in the home app
  bar): acute-days card, this month's doses newest first, delete, add.
- **Inside an attack.** `AttackMedicationSection` on the attack screen
  lists the attack's doses and adds one linked to the attack. Deleting the
  attack keeps the dose and clears the link (`onDelete: setNull`).
- **Relief at 2 h.** Once two hours have passed since an acute dose, the
  tile asks "Relief after 2 h?" with none / some / full chips; the answer
  is stored and can be changed or cleared.
- **Gentle notes.** At 10 acute days the card shows the first note, at 15
  the second, each with a "Talk to your clinician" button opening
  `AppIdentity.clinicianGuidanceUrl` (new config value) in the browser.
- `url_launcher` added (also used later by the attribution screen).

## Tests

- `test/features/medication/acute_day_counter_test.dart`: distinct days
  not doses, preventive excluded, month boundaries at local midnight
  (23:59 on the 31st, 00:00 on the 1st, 23:59:59 on the 30th), year wrap
  of the month helpers, thresholds from the config.
- `test/features/medication/medication_repository_test.dart`: round-trip,
  update keeps `createdAt`, attack link survives attack deletion as null,
  distinct recent names ordering, half-open ranges.
- `test/features/medication/medication_flow_test.dart` (widget): add a
  dose standalone; suggestion chip and preventive kind; dose logged inside
  an attack is linked and the relief question appears after two hours and
  stores the answer; overuse notes appear exactly at the thresholds with
  the clinician link; delete.

## Deviations from the plan

- The clinician link opens a page under the product website
  (`AppIdentity.clinicianGuidanceUrl`); M can point it elsewhere in the
  central config.

## How to verify

```bash
flutter test test/features/medication
```

Home > medication icon > Add medication. Or start an attack and use "Add
medication" at the bottom of the attack screen.

## What M must fill in

Publish the page behind `AppIdentity.clinicianGuidanceUrl` (or change the
URL) before release.
