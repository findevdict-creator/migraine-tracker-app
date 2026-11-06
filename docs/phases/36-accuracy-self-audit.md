# Phase 36: Accuracy self-audit

Branch: `36-feat-accuracy-self-audit`, cut from `35-feat-premium`.
Requirement IDs: FR-13.

## What was done

### A record the model cannot rewrite

The risk model relearns as attacks are logged, and every relearn rewrites
`risk_days` for past days with what it now knows. Scoring the audit from
`risk_days` would grade the model on hindsight and flatter it. So the app
now keeps a second, frozen record:

- New table `audit_days` (schema version 3; the migration only creates the
  table). One row per day: the level shown, the model version and when it
  was recorded.
- `RiskEngine.scoreUpcoming` writes it after every scoring run, through
  `RiskRepository.recordShown`:
  - days still ahead are replaced by the newest forecast, so the row ends
    up as the last forecast made before the day began;
  - the day itself is only written if there is no row yet, so the first
    score of the day stands when there was no forecast;
  - past days are never touched. Relearning writes `risk_days` only.
- Like every table it is in the JSON and CSV export, in the encrypted
  backup, and emptied by "Delete everything".

Counting starts with this version. Days before it have no frozen level and
are left out, which the page says.

### What is scored

`SelfAudit.compute` in `lib/features/audit/domain/self_audit.dart` is pure
and works on `yyyy-MM-dd` keys. The window is
`AppThresholds.auditWindowDays` (1 day):

- **Attacks that followed a High day.** An attack counts as scored when the
  day it started, or the day before, has a frozen level. It is a hit when
  either of those was High; otherwise it is a miss. Attacks with no frozen
  level near them are not scored at all.
- **High days with no attack.** A High day is settled once its window has
  passed (the day after it is over). It is a false alarm when no attack
  started that day or the next. High days still inside their window wait.
- Counts are split by the month the attack or High day falls in.

### The page

Settings gets a "How the risk level has done" entry once
`AppThresholds.attacksBeforeSelfAudit` (10) attacks are logged. Opened
earlier through its route, the page says how many attacks are needed.

The page (`/audit`) shows:

- attacks after a High day as "2 of 3 (67%)", attacks without one, and
  High days with no attack as "1 of 3 High days";
- the last `AppThresholds.auditTrendMonths` (6) months, newest first;
- a caveat: small numbers swing, a High day without an attack is not a
  mistake, and the level is a guide to plan around, not a promise;
- the sharing switch, off by default.

### Opt-in monthly counts

When the person turns sharing on, the app sends last month's counts once a
month, from the `AppThresholds.auditUploadFromDay` (3rd) so the last High
days of the month are settled. `AuditMonthlySend` at the app root tries on
start and on resume; a failure is retried on the next start, and an empty
month is marked done without calling the server.

What is sent is fixed by `AuditUpload.payload` and checked again by the
server: `attacks`, `hits`, `misses`, `highDays`, `falseAlarms` and
`modelVersion`. No dates, places, log entries or account id.

Server side (`functions/src/audit/`):

- `auditCounts` is a callable function with App Check and **no account
  needed**. It accepts exactly those six fields, as whole numbers in range
  that add up (hits + misses = attacks, false alarms at most High days).
  A stray field fails the call instead of being dropped, so a client bug
  cannot leak one quietly.
- It stores the counts with the previous UTC month from the server clock
  and an auto id. No uid, no IP.
- `firestore.rules`: `audit_counts` is now closed to clients. The phase 4
  rule let a signed-in user create documents carrying their uid; that is
  replaced, since nothing should tie the counts to a person.
- Because the documents carry no uid, account deletion (phase 32) no
  longer looks in `audit_counts`; there is nothing of the account's there.

## Configuration

All in `lib/config/app_config.dart`:

| Value | Default | Meaning |
| ----- | ------- | ------- |
| `AppThresholds.attacksBeforeSelfAudit` | 10 | attacks before the page appears |
| `AppThresholds.auditWindowDays` | 1 | days before an attack that count, and days after a High day |
| `AppThresholds.auditTrendMonths` | 6 | months in the trend |
| `AppThresholds.auditUploadFromDay` | 3 | first day of the month the counts are sent |
| `AppFeatureFlags.selfAuditAvailable` | true | hides the page and settings entry |
| `AppFeatureFlags.auditUploadAvailable` | true | hides the sharing switch and stops sending |
| `AppEndpoints.auditCountsFunction` | `auditCounts` | function name |

Server limits are `audit` in `functions/src/config.ts`: highest attack
count, highest High-day count (31) and the model version pattern.

## Tests

- `self_audit_test.dart`: hits and misses with the one-day window,
  unscored attacks, false alarms, High days waiting for their window,
  months, empty input, date helpers across month and year ends, and the
  payload holding exactly five counts and the model version with nothing
  shaped like a date.
- `risk_repository_test.dart`: forecasts replaced until the day begins,
  the day keeping its first score, and relearning leaving the record alone.
- `audit_flow_test.dart`:
  - off by default and sends nothing;
  - once on, nothing before the 3rd, then last month exactly once;
  - a failed send retried, an empty month marked done;
  - no settings entry below ten attacks and the page saying why;
  - from ten attacks the counts, trend, caveat and switch, off until
    turned on, and turning it on sending once.
- `migration_test.dart` covers version 2 to 3 against the new schema dump;
  `app_database_test.dart` counts 14 tables.
- `functions/test/audit.test.ts`: exact fields, every stray field refused
  (uid, month, dates, coordinates, cell), range and sum checks, the
  server-stamped month across a year end, and the function reading no uid.
- `firestore.rules.test.ts`: clients can neither write nor read
  `audit_counts`.
- `account.test.ts`: purge leaves anonymous audit counts alone.
- Full suites: 476 app tests and 66 functions tests (rules tests run
  separately on the emulators in CI).

## Acceptance criteria

- [x] Correctly computed on synthetic data (unit tests above).
- [x] Upload payload contains no dates, locations or log entries (app and
  server tests).
- [ ] Seen on a device after ten real attacks (Manual checks).

## Manual checks

1. On a staging build, log ten attacks over a few weeks with the app
   opened daily, so levels are recorded. Settings shows "How the risk
   level has done".
2. The counts match a hand count from the calendar: for each attack, was
   that day or the day before shown as High?
3. Turn sharing on after the 3rd of a month. In the Firestore console an
   `audit_counts` document appears with the six fields, `month` and
   `receivedAt`, and nothing else.
4. Restart the app the same month: no second document.

## What M must fill in

Nothing new. The function uses App Check like the others; deploy it with
`npm run deploy` in `functions/`. Decide whether to keep sharing offered
(`AppFeatureFlags.auditUploadAvailable`) and mention the anonymous counts
in the privacy policy if it stays on.

## Risk and rollback

- The migration only adds a table. A phone that has migrated cannot go
  back to a schema 2 build (drift does not downgrade), so a problem here is
  fixed forward: turning the flags below off hides the feature without a
  schema change.
- Turning `auditUploadAvailable` off stops all sending at once. The
  function can be removed from `src/index.ts` without affecting the rest.
- The rules change only closes access; nothing reads `audit_counts` from
  a client.
