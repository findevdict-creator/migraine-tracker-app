// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Migraine Tracker';

  @override
  String get homeEmptyState =>
      'Nothing logged yet.\nYour risk level and environment will appear here.';

  @override
  String get riskLevelLow => 'Low';

  @override
  String get riskLevelModerate => 'Moderate';

  @override
  String get riskLevelHigh => 'High';

  @override
  String get devThemeGalleryTitle => 'Theme gallery';

  @override
  String get devThemeLight => 'Light theme';

  @override
  String get devThemeDark => 'Dark theme';

  @override
  String get devThemeAttack => 'Attack theme';

  @override
  String get devSampleBody =>
      'Body text at the default size. It must stay readable at 200% text scale without truncation.';

  @override
  String get devSamplePrimary => 'Primary';

  @override
  String get devSampleSecondary => 'Secondary';

  @override
  String get devSampleText => 'Text';

  @override
  String get devSampleDisabled => 'Disabled';

  @override
  String get devSampleChipOn => 'Aura';

  @override
  String get devSampleChipOff => 'Nausea';

  @override
  String get devSampleChipIcon => 'Light';

  @override
  String get devSampleSlider => 'Intensity';

  @override
  String get devSampleSliderLow => 'No pain';

  @override
  String get devSampleSliderHigh => 'Worst';

  @override
  String get devSampleCard => 'A card with a badge';

  @override
  String get attackStart => 'Start attack';

  @override
  String get attackContinue => 'Continue attack';

  @override
  String get attackTitleRunning => 'Attack in progress';

  @override
  String get attackTitleEnded => 'Attack';

  @override
  String attackStartedAt(String time) {
    return 'Started at $time';
  }

  @override
  String get attackNotFound => 'This attack no longer exists.';

  @override
  String get attackIntensity => 'Pain intensity';

  @override
  String get attackIntensityLow => 'No pain';

  @override
  String get attackIntensityHigh => 'Worst';

  @override
  String get attackWhereItHurts => 'Where it hurts';

  @override
  String get attackSymptoms => 'Symptoms';

  @override
  String get attackPhases => 'Phases';

  @override
  String get attackNotes => 'Notes';

  @override
  String get attackNotesHint => 'Anything else worth remembering';

  @override
  String get attackEnd => 'End attack';

  @override
  String get attackDone => 'Done';

  @override
  String get attackFinishLater => 'Finish later';

  @override
  String get symptomAura => 'Aura';

  @override
  String get symptomNeckTension => 'Neck tension';

  @override
  String get symptomLightSensitivity => 'Light';

  @override
  String get symptomSoundSensitivity => 'Sound';

  @override
  String get symptomSmellSensitivity => 'Smell';

  @override
  String get symptomNausea => 'Nausea';

  @override
  String get phaseProdrome => 'Prodrome';

  @override
  String get phaseAura => 'Aura';

  @override
  String get phaseAttack => 'Attack';

  @override
  String get phasePostdrome => 'Postdrome';

  @override
  String get headForehead => 'Forehead';

  @override
  String get headLeftTemple => 'Left temple';

  @override
  String get headRightTemple => 'Right temple';

  @override
  String get headBehindEyes => 'Behind the eyes';

  @override
  String get headLeftSide => 'Left side';

  @override
  String get headRightSide => 'Right side';

  @override
  String get headTopOfHead => 'Top of head';

  @override
  String get headBackOfHead => 'Back of head';

  @override
  String get headNeck => 'Neck';

  @override
  String get checkinTitle => 'Daily check-in';

  @override
  String get checkinLoadError => 'Could not load this day.';

  @override
  String get checkinIntro => 'Three taps. How was it?';

  @override
  String get checkinComplete => 'Done for this day. Tap a number to change it.';

  @override
  String get checkinAddMore => 'Add more (optional)';

  @override
  String get checkinOptionalTitle => 'Optional';

  @override
  String get checkinDone => 'Done';

  @override
  String get checkinToday => 'Today';

  @override
  String get checkinSleepQuality => 'Sleep quality';

  @override
  String get checkinStress => 'Stress';

  @override
  String get checkinNeckTension => 'Neck tension';

  @override
  String get checkinCaffeine => 'Caffeine';

  @override
  String get checkinHydration => 'Hydration';

  @override
  String get checkinAlcohol => 'Alcohol';

  @override
  String get checkinLightExposure => 'Bright light';

  @override
  String get checkinScreenExposure => 'Screen time';

  @override
  String get checkinSleepLow => 'Poor';

  @override
  String get checkinSleepHigh => 'Great';

  @override
  String get checkinStressLow => 'Calm';

  @override
  String get checkinStressHigh => 'Very stressed';

  @override
  String get checkinNeckLow => 'Relaxed';

  @override
  String get checkinNeckHigh => 'Very tight';

  @override
  String get checkinHydrationLow => 'Little';

  @override
  String get checkinHydrationHigh => 'Plenty';

  @override
  String get checkinExposureLow => 'Little';

  @override
  String get checkinExposureHigh => 'A lot';

  @override
  String get checkinNone => 'None';

  @override
  String checkinCupsOrMore(int count) {
    return '$count+ cups';
  }

  @override
  String checkinDrinksOrMore(int count) {
    return '$count+ drinks';
  }

  @override
  String checkinValueSemantics(String field, int value, int max) {
    return '$field, $value of $max';
  }

  @override
  String get checkinReminderTooltip => 'Reminder time';

  @override
  String checkinReminderAt(String time) {
    return 'Reminder at $time';
  }

  @override
  String get checkinReminderPickerTitle => 'Daily check-in reminder';

  @override
  String get checkinCardTitle => 'Daily check-in';

  @override
  String get checkinCardDone => 'Done for today';

  @override
  String get checkinCardTodo => 'Three taps, about 10 seconds';

  @override
  String get medicationTitle => 'Medication';

  @override
  String get medicationAdd => 'Add medication';

  @override
  String get medicationAddTitle => 'Log a dose';

  @override
  String get medicationName => 'Medication';

  @override
  String get medicationDose => 'Dose';

  @override
  String get medicationDoseHint => 'e.g. 400 mg';

  @override
  String get medicationKindAcute => 'Acute';

  @override
  String get medicationKindPreventive => 'Preventive';

  @override
  String medicationTakenAt(String time) {
    return 'Taken at $time';
  }

  @override
  String get medicationLog => 'Log';

  @override
  String get medicationDelete => 'Delete';

  @override
  String get medicationThisMonth => 'This month';

  @override
  String get medicationEmpty => 'No doses logged this month.';

  @override
  String get medicationReliefQuestion => 'Relief after 2 h?';

  @override
  String get medicationReliefNone => 'None';

  @override
  String get medicationReliefPartial => 'Some';

  @override
  String get medicationReliefFull => 'Full';

  @override
  String medicationAcuteDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count acute-medication days this month',
      one: '1 acute-medication day this month',
      zero: 'No acute-medication days this month',
    );
    return '$_temp0';
  }

  @override
  String get medicationAcuteDaysHint =>
      'Days with at least one acute dose, counted per calendar month.';

  @override
  String medicationOveruseFirstNote(int days) {
    return 'You have reached $days acute-medication days this month. Many clinicians suggest keeping this number low; it may be worth a conversation.';
  }

  @override
  String medicationOveruseSecondNote(int days) {
    return 'You have reached $days acute-medication days this month. Please consider talking to your clinician about this pattern.';
  }

  @override
  String get medicationTalkToClinician => 'Talk to your clinician';

  @override
  String get cycleTitle => 'Cycle';

  @override
  String get cycleToggleTitle => 'Track my cycle';

  @override
  String get cycleToggleSubtitle =>
      'Off by default. When on, cycle day is kept with each check-in and used as a factor.';

  @override
  String get cycleNoData => 'Log a period start to see your cycle day.';

  @override
  String cycleDayAndPhase(int day, String phase) {
    return 'Cycle day $day · $phase';
  }

  @override
  String cycleLength(int days) {
    return 'Based on a $days-day cycle';
  }

  @override
  String get cyclePeriodStarts => 'Period starts';

  @override
  String get cycleNoStarts => 'None logged yet.';

  @override
  String get cycleRemoveStart => 'Remove';

  @override
  String get cyclePeriodStartedToday => 'Period started this day';

  @override
  String get cyclePhaseMenstrual => 'Menstrual';

  @override
  String get cyclePhaseFollicular => 'Follicular';

  @override
  String get cyclePhaseOvulation => 'Around ovulation';

  @override
  String get cyclePhaseLuteal => 'Luteal';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionDaily => 'Daily';

  @override
  String get settingsSectionData => 'Your data';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsExportJson => 'Export as JSON';

  @override
  String get settingsExportJsonHint =>
      'Every table in one file you can import again.';

  @override
  String get settingsExportCsv => 'Export as CSV';

  @override
  String get settingsExportCsvHint => 'One spreadsheet file per table.';

  @override
  String get settingsExportEmpty => 'Nothing to export yet.';

  @override
  String get settingsDeleteAll => 'Delete everything';

  @override
  String get settingsDeleteAllHint =>
      'Removes all data from this device. Cannot be undone.';

  @override
  String settingsDeleteAllConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'This deletes $count records from this device. This cannot be undone.',
      one: 'This deletes 1 record from this device. This cannot be undone.',
      zero: 'There is nothing stored yet. Delete anyway?',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeleteAllButton => 'Delete';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsDeletedAll => 'All data deleted.';

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String get settingsTerms => 'Terms of use';

  @override
  String get settingsSupport => 'Support';
}
