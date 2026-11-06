# Phase 25: Voice log

Branch: `25-feat-voice-log`, cut from `24-feat-questionnaires`.
Requirement IDs: FR-3.

## What was done

- **Parser** (`VoiceParser`, pure): turns one spoken sentence into
  attack fields.
  - Intensity: a 0 to 10 number followed by "out of ten" or "/10", or
    within three words after a cue ("pain is a seven", "intensity
    eight"); otherwise a plain level ("mild" 3, "moderate" 5, "severe"
    8, "unbearable" 10). Numbers above 10, decimals and dose numbers are
    never read as the intensity.
  - Symptoms and head locations: everyday phrasings per enum value
    ("zigzags", "light hurts", "feel sick", "behind my eyes", "back of
    my head", "both temples"), longest phrase first so "stiff neck" is a
    symptom while "neck" alone is a location; "light and sound
    sensitivity" names both.
  - Negation: "no", "not", "without", "didn't" and similar up to two
    words before a phrase cancel it ("no nausea", "didn't take
    sumatriptan").
  - Medications: matched only against the person's own logged names
    (up to 50, most recent first), multi-word names included, with a
    dose when a number and unit are said next to the name ("400 mg of
    ibuprofen", "sumatriptan 50 milligrams", "two tablets of ...").
  - Number words up to the hundreds ("four hundred milligrams").
- **Lexicon** (`VoiceLexicon`): the vocabulary lives in one place per
  language. English ships now and is the fallback; the localization
  phase adds the others. It is parsing vocabulary, not display copy, so
  it is not in the ARB.
- **Speech** (`DeviceSpeechCapture`, `speech_to_text`): on-device
  recognition only (`AppThresholds.voiceOnDeviceOnly`), dictation mode,
  20 s maximum, ends after 3 s of silence, in the app's locale. A phone
  without a recognizer or offline speech pack gets an explanation
  instead of a server round trip.
- **Attack screen**: a microphone button in the app bar opens a sheet
  that listens (live partial text, "Done talking", "Cancel"), then shows
  the confirmation form: the transcript, the intensity slider if one was
  heard, symptom, location and medication chips pre-selected from the
  parse and editable. "Save to attack" merges in one save
  (`AttackEditor.applyVoice`: sets the intensity if said, adds symptoms
  stamped now and locations not already there, never removes) and logs
  each medication as an acute dose linked to the attack. "Try again"
  listens again; "Cancel" saves nothing. When nothing matched, save is
  off and the form says so.
- **Permissions**: Android `RECORD_AUDIO` and the `RecognitionService`
  query; iOS `NSMicrophoneUsageDescription` and
  `NSSpeechRecognitionUsageDescription`.
- **Config**: `voiceListenFor`, `voicePauseFor`, `voiceOnDeviceOnly`;
  `AppFeatureFlags.voiceLogAvailable` (already present) hides the button.

## Tests

- `voice_parser_test.dart`: a 26-phrase corpus (intensity forms,
  symptoms, locations, negation, doses, multi-word names, ordering,
  phrases with nothing to parse) plus dose-versus-intensity, own-names
  only, out-of-range numbers, trimming.
- `voice_log_sheet_test.dart` with a scripted speech fake: a sentence
  fills the form, a hand edit sticks, save writes intensity, location,
  symptoms and a linked dose; cancel saves nothing; nothing understood
  disables save and retry listens again; no recognizer shows the
  explanation; nothing heard offers a retry.
- `apply_voice_test.dart`: merge without removing or duplicating, and
  existing tap times are kept.
- Full suite: 363 tests.

## Acceptance criteria

- [x] Voice button on the attack screen with a confirmation form before
      save.
- [x] Parser tests over a phrase corpus.
- [ ] Checked on a real device of each platform with the offline speech
      pack installed (parity row 25).

## Manual checks

- Android: Settings > System > Languages > On-device speech recognition
  has the English pack. Start an attack, tap the microphone, say "pain
  seven out of ten, behind my eyes, nausea, took ibuprofen": the form
  shows each item; Save fills the attack and the dose list.
- iOS: the first tap asks for microphone and speech permission. Turn on
  airplane mode and repeat: recognition still works on-device.
- Deny the microphone permission: the sheet explains and offers Cancel
  only.
