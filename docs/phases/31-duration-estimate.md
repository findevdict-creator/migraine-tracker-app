# Phase 31: Attack duration estimate

Branch: `31-feat-duration-estimate`, cut from `30-feat-experiments`.
Requirement IDs: FR-5.

## What was done

- **A card on the running attack screen**, under the start time. It
  reads, for example:

  > How long attacks like this usually last
  > Typically 4 to 6 h
  > Based on 8 past attacks of similar intensity with the same medication

- **Always a range, never one figure.** The range is the middle half of
  the matching past durations, from the 25th to the 75th percentile.
  - Below 3 hours it is rounded out to half hours, for example "1 to
    1.5 h". From 3 hours up it is rounded out to whole hours.
  - The low end is rounded down and the high end up. If both land on
    the same value, the high end moves up one step.
- **Only after 5 completed attacks.** Running attacks and attacks with
  no length do not count. Until then the card does not appear at all.
- **Which past attacks are used** (`DurationEstimator`, pure). The most
  specific group with at least 5 attacks wins:
  1. Similar intensity, within 2 points, and the same medication. When
     no medication has been logged for this attack yet, this means
     past attacks with no medication either. The line below the range
     says which of the two it is.
  2. Similar intensity, any medication.
  3. Every completed attack.

  The line below the range always names the group and its size.
- **Live.** Changing the intensity slider or logging a dose updates the
  card at once. Medication names match regardless of case and spacing,
  so "Ibuprofen" and "ibuprofen " are the same. Preventive doses are
  ignored.
- **Not shown once the attack has ended**, because the real length is
  known then.

## Configuration

All in `lib/config/app_config.dart`:

| Setting | Value | What it does |
| --- | --- | --- |
| `AppThresholds.durationEstimateMinAttacks` | 5 | Completed attacks before the card shows, and the fewest in a group before that group is used |
| `AppThresholds.durationIntensityBand` | 2 | How far apart two intensities can be and still count as similar |
| `AppThresholds.durationFineStepBelow` | 3 h | Below this the range is in half hours, above it in whole hours |

## Tests

- `duration_estimate_test.dart`:
  - Nothing until five completed attacks. Running and zero-length
    attacks do not count.
  - Similar intensity with the same medication comes first.
  - Too few with the same medication falls back to similar intensity,
    then to every attack.
  - An attack with no intensity yet compares by medication only.
  - Always a range: identical durations still give "4 to 5 h", and
    short attacks round to half hours.
  - Medication names are normalised, and preventive doses are ignored.
- `duration_estimate_flow_test.dart`:
  - With five past attacks, starting an attack shows "Typically 4 to
    6 h" and "Based on 5 past attacks of similar intensity without
    medication".
  - With four, the card does not appear.
- Full suite: 405 tests.

## Acceptance criteria

- [x] Shows the median range for attacks of similar intensity and the
      same medication while an attack is running.
- [x] Shows the sample size.
- [x] Appears only after 5 completed attacks.
- [x] A range such as "typically 4 to 7 h (based on 8 attacks)", never
      a single figure.

## Manual checks

1. With fewer than five finished attacks, start an attack. No estimate
   card shows.
2. Log and finish five attacks of different lengths. Start a new one.
   The card shows a range and "Based on 5 past attacks".
3. Move the intensity slider and log a dose. The line below the range
   changes to match.
4. End the attack. The card is gone from the ended attack.

## Risk and rollback

This phase adds one domain file, one provider, one widget and strings.
There is no storage change. Reverting the branch removes the card.

## What M must fill in

Nothing.
