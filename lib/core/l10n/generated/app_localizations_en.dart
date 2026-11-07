// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Aurawell';

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
  String get durationEstimateTitle => 'How long attacks like this usually last';

  @override
  String durationEstimateRange(String low, String high) {
    return 'Typically $low to $high h';
  }

  @override
  String durationEstimateSameMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Based on $count past attacks of similar intensity with the same medication',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateNoMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Based on $count past attacks of similar intensity without medication',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateSimilar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Based on $count past attacks of similar intensity',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Based on $count of your past attacks',
    );
    return '$_temp0';
  }

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

  @override
  String get environmentTitle => 'Environment';

  @override
  String get environmentCardTitle => 'Pressure';

  @override
  String get environmentCardEmpty =>
      'No weather saved yet. Tap to set your location.';

  @override
  String environmentCardSummary(String pressure, String trend) {
    return '$pressure, $trend';
  }

  @override
  String get envPressureSection => 'Air pressure';

  @override
  String get envPressureUnknown => 'No reading for this hour';

  @override
  String get envDelta3h => '3 h';

  @override
  String get envDelta6h => '6 h';

  @override
  String get envDelta12h => '12 h';

  @override
  String get envDelta24h => '24 h';

  @override
  String get envDeltaUnknown => '–';

  @override
  String get envChartTitle => 'Last 48 hours and next 24';

  @override
  String get envUpdatedNever => 'Not updated yet';

  @override
  String get envUpdatedJustNow => 'Updated just now';

  @override
  String envUpdatedMinutes(int n) {
    return 'Updated $n min ago';
  }

  @override
  String envUpdatedHours(int n) {
    return 'Updated $n h ago';
  }

  @override
  String envUpdatedDays(int n) {
    return 'Updated $n d ago';
  }

  @override
  String get envStale =>
      'This forecast is a few hours old. It refreshes when you are back online.';

  @override
  String get envOffline =>
      'Could not reach the weather service. Showing what is saved on this device.';

  @override
  String get envNoData =>
      'No weather saved yet. Allow location or choose a city to see the pressure trend.';

  @override
  String get envRefresh => 'Refresh';

  @override
  String get envLocationSection => 'Location';

  @override
  String get envLocationGps => 'Using your approximate location';

  @override
  String envLocationManual(String city) {
    return 'Using $city';
  }

  @override
  String get envLocationLast => 'Using the last known area';

  @override
  String get envLocationNone => 'No location set';

  @override
  String get envUseMyLocation => 'Use my location';

  @override
  String get envChooseCity => 'Choose a city';

  @override
  String get envCitySearchTitle => 'Choose a city';

  @override
  String get envCitySearchHint => 'City name';

  @override
  String get envCityNoResults => 'No places found';

  @override
  String get envCitySearchFailed =>
      'Could not search right now. Check your connection and try again.';

  @override
  String get envPrivacyNote =>
      'Your location is rounded to about 10 km before it leaves this device.';

  @override
  String get envAttribution => 'Weather data by Open-Meteo';

  @override
  String get envTrendRising => 'rising';

  @override
  String get envTrendFalling => 'falling';

  @override
  String get envTrendSteady => 'steady';

  @override
  String get envTrendUnknown => 'no trend yet';

  @override
  String get barometerTitle => 'Barometer';

  @override
  String get barometerOpen => 'Open the barometer';

  @override
  String get barometerNoReading => 'No reading';

  @override
  String get barometerFromSensor => 'From this device\'s sensor';

  @override
  String get barometerFromStation => 'From the nearest station';

  @override
  String get barometerNoSource =>
      'No sensor on this device and no forecast saved yet';

  @override
  String get barometerCalibrationSection => 'Calibration';

  @override
  String barometerOffset(String offset, int pairs) {
    return 'Sensor offset $offset against the station series, from $pairs hourly pairs.';
  }

  @override
  String barometerNotCalibrated(int pairs) {
    return 'Not calibrated yet. Needs at least $pairs hours with both a sensor sample and a station value.';
  }

  @override
  String get barometerTrendSection => 'Last 24 hours on this device';

  @override
  String get barometerTrendEmpty =>
      'Samples are taken while the app is open. Come back later to see the trend.';

  @override
  String barometerTrendSamples(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n samples',
      one: '1 sample',
    );
    return '$_temp0';
  }

  @override
  String get barometerStampNote =>
      'Each attack you start records the sensor reading and the station value of that hour.';

  @override
  String get envFactorsTitle => 'Today\'s factors';

  @override
  String get envFactorsEmpty => 'No daily factors for this area yet.';

  @override
  String get factorBandLow => 'low';

  @override
  String get factorBandModerate => 'moderate';

  @override
  String get factorBandHigh => 'high';

  @override
  String get factorBandVeryHigh => 'very high';

  @override
  String factorValueWithBand(String value, String band) {
    return '$value ($band)';
  }

  @override
  String get factorAqiUs => 'Air quality (US AQI)';

  @override
  String get factorAqiEu => 'Air quality (European AQI)';

  @override
  String get factorParticulates => 'Particulates PM2.5 / PM10';

  @override
  String factorParticulatesValue(String pm25, String pm10) {
    return '$pm25 / $pm10 µg/m³';
  }

  @override
  String get factorOzone => 'Ozone';

  @override
  String factorMicrograms(String value) {
    return '$value µg/m³';
  }

  @override
  String get factorPollen => 'Pollen (Europe only)';

  @override
  String factorPollenType(String type, String band) {
    return '$type $band';
  }

  @override
  String get pollenAlder => 'alder';

  @override
  String get pollenBirch => 'birch';

  @override
  String get pollenGrass => 'grass';

  @override
  String get pollenMugwort => 'mugwort';

  @override
  String get pollenOlive => 'olive';

  @override
  String get pollenRagweed => 'ragweed';

  @override
  String get factorUvMax => 'UV index, daily max';

  @override
  String get factorDaylight => 'Daylight';

  @override
  String factorDaylightValue(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get factorSun => 'Sunrise and sunset';

  @override
  String factorSunValue(String sunrise, String sunset) {
    return '$sunrise to $sunset';
  }

  @override
  String get aboutDataTitle => 'About the data';

  @override
  String get aboutDataIntro =>
      'Where the numbers in this app come from, and what each one can and cannot tell you.';

  @override
  String get aboutDataSources => 'Sources';

  @override
  String aboutDataLicence(String coverage, String licence) {
    return '$coverage. Licence: $licence.';
  }

  @override
  String get aboutDataPrivacy => 'What leaves your phone';

  @override
  String get aboutDataPrivacyBody =>
      'Only a location rounded to about 10 km, so the weather service can answer for your area. Your attacks, check-ins, medication and health data stay on this device unless you choose to back up or share them.';

  @override
  String get aboutDataLimits => 'Limits';

  @override
  String get aboutDataLimitsBody =>
      'Forecasts are model estimates for a grid cell, not a measurement at your door. Pollen is only available in Europe. Air quality may be missing in some regions. Where a factor has no data for your area it is simply not shown.';

  @override
  String get settingsHealthHint =>
      'Sleep, heart rate, steps and cycle from your health app';

  @override
  String get healthTitle => 'Health data';

  @override
  String healthIntro(String store) {
    return 'Choose what to read from $store. Each type has its own switch and its own reason.';
  }

  @override
  String get healthPrivacyNote =>
      'Imported data stays on this phone. It is never uploaded, not even with backup, unless you export it yourself.';

  @override
  String get healthStoreApple => 'Apple Health';

  @override
  String get healthStoreConnect => 'Health Connect';

  @override
  String healthUnavailable(String store) {
    return '$store is not available on this device.';
  }

  @override
  String get healthReadSection => 'Read';

  @override
  String get healthTypeSleep => 'Sleep';

  @override
  String get healthReasonSleep =>
      'Fills in sleep quality on your daily check-in from the night\'s sleep, so you have one less tap.';

  @override
  String get healthTypeRestingHr => 'Resting heart rate';

  @override
  String get healthReasonRestingHr =>
      'A higher resting rate than usual can show strain the day before an attack.';

  @override
  String get healthTypeHrv => 'Heart rate variability';

  @override
  String get healthReasonHrv =>
      'Lower variability than usual often goes with stress and poor recovery.';

  @override
  String get healthTypeSteps => 'Steps';

  @override
  String get healthReasonSteps =>
      'Very low or very high activity days are worth seeing next to your attacks.';

  @override
  String get healthTypeFlow => 'Menstrual flow';

  @override
  String get healthReasonFlow =>
      'Fills in period starts for cycle tracking, if you use it.';

  @override
  String healthDenied(String store) {
    return '$store did not grant access. You can change this in its own settings.';
  }

  @override
  String get healthWriteSection => 'Write';

  @override
  String healthWriteHeadaches(String store) {
    return 'Write headache events to $store';
  }

  @override
  String get healthWriteHeadachesHint =>
      'Each ended attack is saved as a headache with its start, end and severity. Nothing else is written.';

  @override
  String get healthImportSection => 'Import';

  @override
  String get healthImportNow => 'Import now';

  @override
  String get healthImportNever => 'Nothing imported yet';

  @override
  String healthImportLast(String age) {
    return '$age';
  }

  @override
  String get healthImportFailed =>
      'The import did not finish. Try again later.';

  @override
  String healthImportResult(int imported, int prefilled) {
    String _temp0 = intl.Intl.pluralLogic(
      imported,
      locale: localeName,
      other: '$imported new samples.',
      one: '1 new sample.',
      zero: 'Nothing new.',
    );
    String _temp1 = intl.Intl.pluralLogic(
      prefilled,
      locale: localeName,
      other: 'Sleep filled in for $prefilled days.',
      one: 'Sleep filled in for 1 day.',
      zero: '',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get checkinSourceHealthkit => 'From Apple Health';

  @override
  String get checkinSourceHealthConnect => 'From Health Connect';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingFinish => 'Finish';

  @override
  String onboardingStep(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get onboardingWelcomeTitle => 'Welcome';

  @override
  String get onboardingLocationTitle => 'Your area\'s weather';

  @override
  String get onboardingLocationBody =>
      'Air pressure changes are one of the most common things people notice before an attack. Allow an approximate location, or pick a city, to see them.';

  @override
  String get onboardingLocationNone =>
      'No location yet. You can also set this later from the environment screen.';

  @override
  String get onboardingHealthTitle => 'Health data';

  @override
  String get onboardingHealthBody =>
      'Optional. Each type has its own switch and its own reason. You can change any of them later in Settings.';

  @override
  String get onboardingHealthUnavailable =>
      'No health app is available on this device. You can skip this step.';

  @override
  String get onboardingReminderTitle => 'Daily check-in';

  @override
  String get onboardingReminderBody =>
      'Three taps a day, about ten seconds. Pick a time for the reminder.';

  @override
  String get onboardingReminderNote =>
      'Reminders start once notifications are set up. You can change the time any day from the check-in.';

  @override
  String get explainerTitle => 'What the level means';

  @override
  String get explainerIntro =>
      'Each day the app shows a level built from your own history and today\'s conditions.';

  @override
  String get explainerDoesTitle => 'What it does';

  @override
  String get explainerDoes1 =>
      'Shows how today\'s weather, sleep, stress and routine compare with the days before your past attacks.';

  @override
  String get explainerDoes2 =>
      'Learns from your own log, so it gets more specific the more you record.';

  @override
  String get explainerDoes3 =>
      'Helps you decide whether today is a day to go easier on yourself.';

  @override
  String get explainerDoesNotTitle => 'What it does not do';

  @override
  String get explainerDoesNot1 =>
      'It is not a forecast of an attack. A high level is a pattern, not a certainty, and a low level is not a promise.';

  @override
  String get explainerDoesNot2 =>
      'It is not a medical opinion and does not replace your clinician.';

  @override
  String get explainerDoesNot3 =>
      'It never sends your log anywhere. The level is computed on this phone.';

  @override
  String get riskCardTitle => 'Today\'s level';

  @override
  String get riskCardEmpty =>
      'No level yet. Add a check-in or let the weather load.';

  @override
  String get riskScreenTitle => 'Your level';

  @override
  String get riskWhyTitle => 'Why';

  @override
  String get riskNoDrivers => 'Nothing stands out.';

  @override
  String get riskNextDays => 'Next days';

  @override
  String get riskDayToday => 'Today';

  @override
  String get riskDayTomorrow => 'Tomorrow';

  @override
  String riskLoad(String value) {
    return 'Load $value of 100';
  }

  @override
  String riskConfidence(String label) {
    return 'Confidence: $label';
  }

  @override
  String get riskConfidenceLow => 'low';

  @override
  String get riskConfidenceMedium => 'medium';

  @override
  String get riskConfidenceHigh => 'high';

  @override
  String riskStillLearning(int count, int needed) {
    return 'Still learning: $count of $needed attacks logged';
  }

  @override
  String get riskTuned => 'Tuned to your log';

  @override
  String riskDriverPoints(String points) {
    return '$points points';
  }

  @override
  String riskUpdated(String time) {
    return 'Updated $time';
  }

  @override
  String get riskExplainerLink => 'What the level means';

  @override
  String get riskOpenCheckin => 'Add today\'s check-in';

  @override
  String get riskFactorPressureDrop => 'Falling air pressure';

  @override
  String get riskFactorHumidity => 'High humidity';

  @override
  String get riskFactorTemperatureSwing => 'Temperature change';

  @override
  String get riskFactorAirQuality => 'Air quality';

  @override
  String get riskFactorPollen => 'Pollen';

  @override
  String get riskFactorBrightLight => 'Bright light';

  @override
  String get riskFactorScreenTime => 'Screen time';

  @override
  String get riskFactorPoorSleep => 'Poor sleep';

  @override
  String get riskFactorStress => 'Stress';

  @override
  String get riskFactorNeckTension => 'Neck tension';

  @override
  String get riskFactorCaffeine => 'Caffeine';

  @override
  String get riskFactorAlcohol => 'Alcohol';

  @override
  String get riskFactorDehydration => 'Low hydration';

  @override
  String get riskFactorCyclePhase => 'Cycle phase';

  @override
  String get loadMeterTitle => 'Load';

  @override
  String loadMeterSemantics(String value, String segments) {
    return 'Load $value of 100. $segments';
  }

  @override
  String loadSegmentDetail(String name, String points) {
    return '$name: $points points';
  }

  @override
  String loadThresholdModerate(String value) {
    return 'Moderate from $value';
  }

  @override
  String loadThresholdHigh(String value) {
    return 'High from $value';
  }

  @override
  String get loadMeterEmpty => 'No load yet';

  @override
  String get insightsTitle => 'Your factors';

  @override
  String get insightsIntro =>
      'How often an attack followed each factor in your own log, compared with your usual rate.';

  @override
  String get insightsTriggers => 'More attacks followed';

  @override
  String get insightsProtectors => 'Fewer attacks followed';

  @override
  String get insightsNeutral => 'No clear effect';

  @override
  String get insightsNotEnough => 'Not enough data yet';

  @override
  String get insightsEmptyBucket => 'Nothing here yet.';

  @override
  String insightsSample(int days, int attacks) {
    return '$days exposure days, $attacks followed by an attack';
  }

  @override
  String insightsLift(String ratio) {
    return '$ratio× your usual rate';
  }

  @override
  String insightsNeedMore(int days, int needed) {
    return '$days of $needed exposure days logged';
  }

  @override
  String get insightsNoRunYet => 'Log and end an attack to start counting.';

  @override
  String get insightsMethodLink => 'How this is counted';

  @override
  String get insightsMethodTitle => 'How this is counted';

  @override
  String insightsMethod1(String pressure) {
    return 'An exposure day is a day where a factor was present in your log or in the weather, for example a sleep answer of 1 or a pressure drop of more than $pressure.';
  }

  @override
  String get insightsMethod2 =>
      'An attack counts as following a day when it started on that day or the next, the 24 to 48 hours the model looks at.';

  @override
  String get insightsMethod3 =>
      'The ratio compares how often attacks followed that factor\'s days with how often they followed any day in your log. 1.5× means one and a half times your usual rate; 0.5× means half.';

  @override
  String insightsMethod4(int needed) {
    return 'A factor needs $needed exposure days before it is sorted. Until then it sits under \"Not enough data yet\". Fewer attacks following a factor is as useful to know as more, so both lists get the same place.';
  }

  @override
  String get insightsMethod5 =>
      'None of this is a cause. A factor can sit in a list because of something it travels with, such as weekends or a medication change. Use the lists to decide what to try, not what to blame.';

  @override
  String get riskInsightsLink => 'Your factors';

  @override
  String get settingsInsightsHint =>
      'Which factors attacks followed in your log';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsHint =>
      'Level alerts, pressure drops, reminders';

  @override
  String get notificationsIntro =>
      'Everything is scheduled on this phone from the saved forecast and your log. Switch off any type you do not want.';

  @override
  String get notificationsPermissionDenied =>
      'Notifications are off for this app in the system settings.';

  @override
  String get notifTypeRiskRising => 'Level rising';

  @override
  String get notifTypeRiskRisingHint =>
      'The evening before and the morning of a higher day';

  @override
  String get notifTypePressureDrop => 'Pressure drop';

  @override
  String notifTypePressureDropHint(String pressure) {
    return 'When the forecast shows a fall of $pressure or more in 24 hours';
  }

  @override
  String get notifTypeAttackOver => 'Is your attack over?';

  @override
  String get notifTypeAttackOverHint =>
      'At your typical attack length, with an End button';

  @override
  String get notifTypeCheckin => 'Check-in reminder';

  @override
  String get notifTypeCheckinHint => 'At the time set under Daily';

  @override
  String get notifTypeMedication => 'Preventive reminder';

  @override
  String get notifTypeMedicationHint => 'A daily nudge for a preventive dose';

  @override
  String notifPressureThreshold(String pressure) {
    return 'Pressure drop threshold: $pressure in 24 h';
  }

  @override
  String get notifMedicationTime => 'Preventive reminder time';

  @override
  String notifRiskEveningTitle(String level) {
    return 'Tomorrow\'s level: $level';
  }

  @override
  String notifRiskEveningBody(String level, String driver) {
    return 'Your level for tomorrow is $level. Top of the list: $driver.';
  }

  @override
  String notifRiskMorningTitle(String level) {
    return 'Today\'s level: $level';
  }

  @override
  String notifRiskMorningBody(String level, String driver) {
    return 'Your level today is $level. Top of the list: $driver.';
  }

  @override
  String get notifPressureTitle => 'Air pressure is dropping';

  @override
  String notifPressureBody(String pressure, String time) {
    return 'A fall of $pressure is expected by $time.';
  }

  @override
  String get notifAttackOverTitle => 'Is your attack over?';

  @override
  String notifAttackOverBody(String duration) {
    return 'It started $duration ago. End it here when it has passed.';
  }

  @override
  String get notifEndAttackAction => 'End attack';

  @override
  String get notifCheckinTitle => 'Three taps for today';

  @override
  String get notifCheckinBody =>
      'Sleep, stress and neck tension. Fifteen seconds.';

  @override
  String get notifMedicationTitle => 'Preventive dose';

  @override
  String get notifMedicationBody =>
      'Time for today\'s preventive medication, if you take one.';

  @override
  String get notifChannelAlerts => 'Alerts';

  @override
  String get notifChannelAlertsDescription =>
      'Level and pressure alerts from the saved forecast';

  @override
  String get notifChannelReminders => 'Reminders';

  @override
  String get notifChannelRemindersDescription =>
      'Check-in and preventive dose reminders';

  @override
  String get notifChannelAttack => 'Attack';

  @override
  String get notifChannelAttackDescription =>
      'Questions about a running attack';

  @override
  String get reportTitle => 'Doctor report';

  @override
  String get settingsReportHint => 'PDF and spreadsheet for a date range';

  @override
  String get reportIntro =>
      'A summary of what you logged, for your next appointment. Pick a period, then share the PDF or the spreadsheets.';

  @override
  String get reportRangeLabel => 'Period';

  @override
  String reportRangeDays(int days) {
    return '$days days';
  }

  @override
  String get reportRangeCustom => 'Custom';

  @override
  String reportRangeText(String from, String to) {
    return '$from to $to';
  }

  @override
  String reportPreviewAttacks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count attacks',
      one: '1 attack',
      zero: 'No attacks',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewAttackDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count attack days',
      one: '1 attack day',
      zero: 'no attack days',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewDoses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doses',
      one: '1 dose',
      zero: 'no doses',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewCheckins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count check-ins',
      one: '1 check-in',
      zero: 'no check-ins',
    );
    return '$_temp0';
  }

  @override
  String get reportEmpty => 'Nothing logged in this period yet.';

  @override
  String get reportSharePdf => 'Share PDF';

  @override
  String get reportShareCsv => 'Share spreadsheets';

  @override
  String get reportShareAll => 'Share everything';

  @override
  String get reportBuilding => 'Preparing the report';

  @override
  String get reportFailed => 'The report could not be prepared. Try again.';

  @override
  String get reportWhatIsIn => 'What the PDF contains';

  @override
  String get reportContents =>
      'Attack calendar, monthly counts, duration, factors with their sample sizes, medication days, pressure changes, symptoms and head locations. No names, no notes.';

  @override
  String reportPdfTitle(String app) {
    return '$app report';
  }

  @override
  String reportPdfPeriod(String from, String to, int days) {
    return 'Period: $from to $to ($days days)';
  }

  @override
  String reportPdfGenerated(String date) {
    return 'Generated $date on the person\'s device from their own log.';
  }

  @override
  String get reportPdfDisclaimer =>
      'This is a self-reported diary summary from a wellness app. It is not a medical record and does not replace a clinical assessment. Factor ratios describe this person\'s log only and are not causes.';

  @override
  String reportPdfPage(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String get reportSectionOverview => 'Overview';

  @override
  String get reportStatAttacks => 'Attacks';

  @override
  String get reportStatAttackDays => 'Attack days';

  @override
  String get reportStatPerMonth => 'Attacks per 30 days';

  @override
  String get reportStatMeanIntensity => 'Mean intensity (0-10)';

  @override
  String get reportStatAcuteDays => 'Days with acute medication';

  @override
  String get reportStatCheckins => 'Days with a check-in';

  @override
  String get reportSectionMonths => 'By month';

  @override
  String get reportColMonth => 'Month';

  @override
  String get reportColAttacks => 'Attacks';

  @override
  String get reportColAttackDays => 'Attack days';

  @override
  String get reportColMeanIntensity => 'Mean intensity';

  @override
  String get reportColAcuteDays => 'Acute days';

  @override
  String get reportColNote => 'Note';

  @override
  String get reportOveruseWatch => '10+ acute days';

  @override
  String get reportOveruseHigh => '15+ acute days';

  @override
  String get reportSectionCalendar => 'Attack calendar';

  @override
  String get reportCalendarHint =>
      'One cell per day. Shaded cells had an attack; the number is the highest intensity that day.';

  @override
  String get reportSectionDuration => 'Attack duration';

  @override
  String get reportDurationNone => 'No ended attacks in this period.';

  @override
  String reportDurationSummary(
    int count,
    String shortest,
    String median,
    String longest,
  ) {
    return '$count ended attacks. Shortest $shortest, median $median, longest $longest.';
  }

  @override
  String get reportBucketUnderFour => 'Under 4 h';

  @override
  String get reportBucketFourToTwelve => '4 to 12 h';

  @override
  String get reportBucketTwelveToDay => '12 to 24 h';

  @override
  String get reportBucketOneToThreeDays => '1 to 3 days';

  @override
  String get reportBucketOverThreeDays => 'Over 3 days';

  @override
  String get reportSectionTriggers => 'Factors in the person\'s log';

  @override
  String reportTriggersHint(int floor) {
    return 'Ratio of attacks after days with the factor to the person\'s usual rate, with the number of exposure days behind it. Below $floor exposure days the ratio is not shown.';
  }

  @override
  String get reportTriggersNone =>
      'Not enough logged days yet to compare factors.';

  @override
  String get reportColFactor => 'Factor';

  @override
  String get reportColRatio => 'Ratio';

  @override
  String get reportColExposures => 'Exposure days';

  @override
  String get reportColFollowed => 'Followed by attack';

  @override
  String get reportColConfidence => 'Evidence';

  @override
  String get reportConfidenceLow => 'low';

  @override
  String get reportConfidenceMedium => 'moderate';

  @override
  String get reportConfidenceHigh => 'good';

  @override
  String get reportSectionMedications => 'Medication';

  @override
  String get reportMedicationsNone => 'No doses logged in this period.';

  @override
  String get reportColMedication => 'Medication';

  @override
  String get reportColKind => 'Type';

  @override
  String get reportColDoses => 'Doses';

  @override
  String get reportColDays => 'Days';

  @override
  String get reportColRelief => 'Relief at 2 h (none / partial / full)';

  @override
  String get reportKindAcute => 'acute';

  @override
  String get reportKindPreventive => 'preventive';

  @override
  String get reportSectionWeather => 'Air pressure';

  @override
  String reportWeatherHint(String pressure) {
    return 'A fall is a drop of $pressure or more over 24 h at the time of the entry.';
  }

  @override
  String get reportWeatherNone => 'No weather snapshots in this period.';

  @override
  String reportWeatherAttacks(int fall, int total) {
    return '$fall of $total attacks began after a pressure fall.';
  }

  @override
  String reportWeatherDays(int fall, int total) {
    return '$fall of $total check-in days had one.';
  }

  @override
  String reportWeatherLift(String lift) {
    return 'Ratio: ${lift}x (1.0 means no relation).';
  }

  @override
  String get reportSectionSymptoms => 'Symptoms and head locations';

  @override
  String get reportSymptomsNone => 'No symptoms or locations logged.';

  @override
  String reportCountOfAttacks(String name, int count, int total) {
    return '$name: $count of $total attacks';
  }

  @override
  String reportHoursShort(String hours) {
    return '$hours h';
  }

  @override
  String get notifTypeQuestionnaire => 'Three-month questionnaires';

  @override
  String get notifTypeQuestionnaireHint =>
      'MIDAS and HIT-6, three months after the last round';

  @override
  String get notifQuestionnaireTitle =>
      'Three months since your last questionnaires';

  @override
  String get notifQuestionnaireBody =>
      'Fill in MIDAS and HIT-6 again to see how the last quarter compares.';

  @override
  String get questionnairesTitle => 'Questionnaires';

  @override
  String get settingsQuestionnairesHint =>
      'MIDAS and HIT-6, scored and charted';

  @override
  String get questionnairesIntro =>
      'Two short, validated questionnaires about the last three months. Repeat them every quarter and the scores are charted here and can go into the doctor report.';

  @override
  String get questionnaireMidasTitle => 'MIDAS';

  @override
  String get questionnaireMidasSubtitle =>
      'Migraine Disability Assessment: five day counts over the last three months';

  @override
  String get questionnaireHit6Title => 'HIT-6';

  @override
  String get questionnaireHit6Subtitle =>
      'Headache Impact Test: six questions on how headaches affect your life';

  @override
  String get questionnaireNeverDone => 'Not filled in yet';

  @override
  String questionnaireLatest(int score, String date) {
    return 'Last score $score on $date';
  }

  @override
  String get questionnaireDueNow => 'Due now';

  @override
  String questionnaireDueOn(String date) {
    return 'Next round $date';
  }

  @override
  String get questionnaireStart => 'Fill in';

  @override
  String get questionnaireRepeat => 'Fill in again';

  @override
  String get questionnaireHistory => 'Score history';

  @override
  String questionnaireChartLabel(
    int count,
    String first,
    String last,
    int latest,
  ) {
    return '$count scores from $first to $last, latest $latest';
  }

  @override
  String get questionnaireAbout => 'About the scores';

  @override
  String get questionnaireAboutBody =>
      'MIDAS adds up five day counts: 0 to 5 is grade I (little or no disability), 6 to 10 grade II (mild), 11 to 20 grade III (moderate), 21 and over grade IV (severe). HIT-6 gives 6, 8, 10, 11 or 13 points per answer, 36 to 78 in all: up to 49 is little or no impact, 50 to 55 some impact, 56 to 59 substantial impact, 60 and over severe impact. The bands are the published ones; the scores are for you and your clinician to discuss.';

  @override
  String get questionnaireMidasIntro =>
      'Think about the last three months. Count days; a day counts once per question.';

  @override
  String get questionnaireMidasQ1 =>
      'On how many days did you miss work or school because of your headaches?';

  @override
  String get questionnaireMidasQ2 =>
      'On how many days was your productivity at work or school reduced by half or more because of your headaches? (Do not count days you missed.)';

  @override
  String get questionnaireMidasQ3 =>
      'On how many days did you not do household work because of your headaches?';

  @override
  String get questionnaireMidasQ4 =>
      'On how many days was your productivity in household work reduced by half or more because of your headaches? (Do not count days you did none.)';

  @override
  String get questionnaireMidasQ5 =>
      'On how many days did you miss family, social or leisure activities because of your headaches?';

  @override
  String get questionnaireMidasA =>
      'On how many days did you have a headache? (If a headache lasted more than one day, count each day.)';

  @override
  String get questionnaireMidasB =>
      'On a scale of 0 to 10, on average how painful were these headaches? (0 = no pain, 10 = pain as bad as it can be)';

  @override
  String get questionnaireMidasUnscored => 'Not part of the score';

  @override
  String get questionnaireDaysField => 'Days (0 to 90)';

  @override
  String get questionnairePainField => 'Pain (0 to 10)';

  @override
  String questionnaireDaysError(int max) {
    return 'Enter a number from 0 to $max';
  }

  @override
  String get questionnaireHit6Intro =>
      'Think about the last four weeks and pick the answer that fits best for each question.';

  @override
  String get questionnaireHit6Q1 =>
      'When you have headaches, how often is the pain severe?';

  @override
  String get questionnaireHit6Q2 =>
      'How often do headaches limit your ability to do usual daily activities, including household work, work, school or social activities?';

  @override
  String get questionnaireHit6Q3 =>
      'When you have a headache, how often do you wish you could lie down?';

  @override
  String get questionnaireHit6Q4 =>
      'In the past four weeks, how often have you felt too tired to do work or daily activities because of your headaches?';

  @override
  String get questionnaireHit6Q5 =>
      'In the past four weeks, how often have you felt fed up or irritated because of your headaches?';

  @override
  String get questionnaireHit6Q6 =>
      'In the past four weeks, how often did headaches limit your ability to concentrate on work or daily activities?';

  @override
  String get questionnaireOptionNever => 'Never';

  @override
  String get questionnaireOptionRarely => 'Rarely';

  @override
  String get questionnaireOptionSometimes => 'Sometimes';

  @override
  String get questionnaireOptionVeryOften => 'Very often';

  @override
  String get questionnaireOptionAlways => 'Always';

  @override
  String get questionnaireSave => 'Save and score';

  @override
  String get questionnaireIncomplete => 'Answer every scored question to save.';

  @override
  String questionnaireResultTitle(int score) {
    return 'Your score: $score';
  }

  @override
  String get questionnaireResultDone => 'Done';

  @override
  String get questionnaireResultDisclaimer =>
      'A score describes the last three months as you remember them. It is a starting point for a conversation with your clinician, not a medical assessment.';

  @override
  String get questionnaireMidasBandMinimal =>
      'Grade I: little or no disability';

  @override
  String get questionnaireMidasBandMild => 'Grade II: mild disability';

  @override
  String get questionnaireMidasBandModerate => 'Grade III: moderate disability';

  @override
  String get questionnaireMidasBandSevere => 'Grade IV: severe disability';

  @override
  String get questionnaireHit6BandMinimal => 'Little or no impact';

  @override
  String get questionnaireHit6BandMild => 'Some impact';

  @override
  String get questionnaireHit6BandModerate => 'Substantial impact';

  @override
  String get questionnaireHit6BandSevere => 'Severe impact';

  @override
  String get reportIncludeQuestionnaires => 'Include questionnaire scores';

  @override
  String get reportIncludeQuestionnairesHint =>
      'MIDAS and HIT-6 rounds completed in the period';

  @override
  String get reportSectionQuestionnaires => 'Questionnaires';

  @override
  String get reportQuestionnairesNone =>
      'No questionnaires completed in this period.';

  @override
  String get reportColDate => 'Date';

  @override
  String get reportColQuestionnaire => 'Questionnaire';

  @override
  String get reportColScore => 'Score';

  @override
  String get reportColBand => 'Band';

  @override
  String get voiceButton => 'Log by voice';

  @override
  String get voiceListening => 'Listening';

  @override
  String get voiceListeningHint =>
      'Say how it feels, for example: pain seven out of ten, behind my eyes, nausea, took ibuprofen.';

  @override
  String get voiceStop => 'Done talking';

  @override
  String get voiceCancel => 'Cancel';

  @override
  String get voiceTryAgain => 'Try again';

  @override
  String get voiceUnavailable =>
      'Voice is not available on this phone. Speech recognition needs microphone permission and an offline speech pack for your language.';

  @override
  String get voiceNoMatch =>
      'Nothing was heard. Try again closer to the phone, or tap the fields instead.';

  @override
  String get voiceReviewTitle => 'Check before saving';

  @override
  String voiceHeard(String text) {
    return 'Heard: “$text”';
  }

  @override
  String get voiceNothingUnderstood =>
      'Nothing on the form matched what was said. Tap the fields instead, or try again.';

  @override
  String get voiceIntensity => 'Intensity';

  @override
  String get voiceIntensityNone => 'Not said';

  @override
  String get voiceSymptoms => 'Symptoms';

  @override
  String get voiceLocations => 'Where it hurts';

  @override
  String get voiceMedications => 'Medication taken now';

  @override
  String get voiceSave => 'Save to attack';

  @override
  String widgetLevel(String level) {
    return 'Level: $level';
  }

  @override
  String get widgetNoLevel => 'Open the app to load today\'s level';

  @override
  String widgetDriver(String factor) {
    return 'Top factor: $factor';
  }

  @override
  String get widgetNoDriver => 'No single factor stands out';

  @override
  String widgetPressureFalling(String pressure) {
    return 'Pressure falling $pressure in 24 h';
  }

  @override
  String widgetPressureRising(String pressure) {
    return 'Pressure rising $pressure in 24 h';
  }

  @override
  String get widgetPressureSteady => 'Pressure steady';

  @override
  String get widgetPressureUnknown => 'No pressure forecast yet';

  @override
  String widgetUpdated(String time) {
    return 'Updated $time';
  }

  @override
  String get widgetStartAttack => 'Start attack';

  @override
  String get widgetOpenAttack => 'Open attack';

  @override
  String get watchStart => 'Start attack';

  @override
  String get watchStop => 'End attack';

  @override
  String get watchIntensity => 'Intensity';

  @override
  String watchSince(String time) {
    return 'Since $time';
  }

  @override
  String get watchPending =>
      'Saved on the watch. Sends when your phone is near.';

  @override
  String get watchNoPhone =>
      'Open the app on your phone once to connect the watch.';

  @override
  String get routinesTitle => 'Self-care routines';

  @override
  String get routinesIntro =>
      'Simple things many people find helpful on hard days. Use what suits you and skip the rest.';

  @override
  String get routineCardTitle => 'Something that may help today';

  @override
  String get routineNotToday => 'Not today';

  @override
  String get routineSeeAll => 'All routines';

  @override
  String get routineStepsTitle => 'How to';

  @override
  String get routineReasonHighDay => 'Today\'s level is high';

  @override
  String get routineReasonNeckTension => 'Your check-in shows neck tension';

  @override
  String get routineReasonStress => 'Your check-in shows high stress';

  @override
  String get routineStretchesTitle => 'Gentle neck and shoulder stretches';

  @override
  String get routineStretchesSummary =>
      'Five slow movements to ease tightness in your neck and shoulders. Stop if anything hurts.';

  @override
  String get routineStretchesSteps =>
      'Sit tall with your shoulders relaxed and your feet flat.\nSlowly tilt your right ear towards your right shoulder. Hold for 15 seconds, then switch sides.\nLower your chin towards your chest and hold for 15 seconds.\nRoll your shoulders backwards five times, then forwards five times.\nClasp your hands behind your back and gently open your chest for 15 seconds.';

  @override
  String get routineBreathingTitle => 'Paced breathing';

  @override
  String get routineBreathingSummary =>
      'Breathe in for 4 seconds and out for 6, for about a minute. A slow out-breath helps many people settle.';

  @override
  String get routineBreathingSteps =>
      'Sit or lie down somewhere comfortable.\nBreathe in through your nose while the circle grows.\nBreathe out slowly while it shrinks.\nKeep going for six rounds, or for as long as feels good.';

  @override
  String get routineLowLightTitle => 'Low light and quiet';

  @override
  String get routineLowLightSummary =>
      'Bright light and noise bother many people on sensitive days and during an attack.';

  @override
  String get routineLowLightSteps =>
      'Dim the lights or close the curtains.\nTurn on dark mode and lower your screen brightness.\nWear an eye mask or sunglasses if light still bothers you.\nCut down noise with earplugs or a quiet room.';

  @override
  String get routineHydrationTitle => 'Drink some water';

  @override
  String get routineHydrationSummary =>
      'Keeping water within reach makes it easier to drink through the day.';

  @override
  String get routineHydrationSteps =>
      'Keep a glass or bottle of water within reach.\nTake a few sips every hour.\nHave a glass of water with each meal.';

  @override
  String get routineCaffeineTitle => 'Keep caffeine steady';

  @override
  String get routineCaffeineSummary =>
      'Big changes in how much caffeine you have can matter for some people.';

  @override
  String get routineCaffeineSteps =>
      'Have caffeine at about the same times each day.\nAvoid big increases, and avoid suddenly skipping your usual amount.\nHave your last caffeinated drink by early afternoon.';

  @override
  String get routineSleepTitle => 'Steady sleep';

  @override
  String get routineSleepSummary =>
      'A regular sleep schedule, weekends included, helps many people.';

  @override
  String get routineSleepSteps =>
      'Go to bed and get up at about the same time every day.\nKeep the bedroom dark, quiet and cool.\nPut screens away 30 minutes before bed.\nAvoid long naps late in the day.';

  @override
  String get breathingStart => 'Start breathing';

  @override
  String get breathingStop => 'Stop';

  @override
  String get breathingIn => 'Breathe in';

  @override
  String get breathingOut => 'Breathe out';

  @override
  String breathingRound(int round, int total) {
    return 'Round $round of $total';
  }

  @override
  String get breathingDone => 'Done. Take a moment before you get up.';

  @override
  String get settingsRoutinesHint =>
      'Stretches, breathing and other simple routines';

  @override
  String get experimentsTitle => 'Experiments';

  @override
  String get settingsExperimentsHint =>
      'Try one change for two weeks and compare';

  @override
  String get experimentsIntro =>
      'Try one change for two weeks and compare it with the two weeks before. One experiment at a time.';

  @override
  String get experimentsPick => 'Pick one change';

  @override
  String get experimentChangeCutCaffeine => 'Cut back on caffeine';

  @override
  String get experimentChangeRegularSleep =>
      'Go to bed at the same time every night';

  @override
  String get experimentChangeMoreWater => 'Drink more water';

  @override
  String get experimentChangeDailyStretches => 'Stretch your neck every day';

  @override
  String get experimentChangeLessScreens => 'Less screen time in the evening';

  @override
  String get experimentChangeNoAlcohol => 'Skip alcohol';

  @override
  String experimentDay(int day, int total) {
    return 'Day $day of $total';
  }

  @override
  String get experimentAdherenceQuestion => 'Did you stick with it today?';

  @override
  String get experimentYes => 'Yes';

  @override
  String get experimentNo => 'No';

  @override
  String experimentAdherence(int kept, int days) {
    return 'Kept to it on $kept of $days days';
  }

  @override
  String get experimentCompareTitle => 'Two weeks before and during';

  @override
  String get experimentBefore => 'Before';

  @override
  String get experimentDuring => 'During';

  @override
  String get experimentRowRate => 'Attacks per week';

  @override
  String get experimentRowIntensity => 'Average intensity';

  @override
  String get experimentRowDuration => 'Median duration';

  @override
  String experimentSample(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'from $count attacks',
      one: 'from 1 attack',
      zero: 'no attacks',
    );
    return '$_temp0';
  }

  @override
  String experimentDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get experimentNoData => 'No data';

  @override
  String get experimentCaveat =>
      'Two weeks is short. Weather, seasons and stress change on their own, so read this as a hint, not proof.';

  @override
  String experimentSmallSample(int min) {
    return 'Fewer than $min attacks in one of the periods, so the numbers can swing a lot.';
  }

  @override
  String get experimentStop => 'Stop experiment';

  @override
  String get experimentFinish => 'Finish and save the result';

  @override
  String get experimentDue => 'The two weeks are over.';

  @override
  String get experimentPast => 'Past experiments';

  @override
  String experimentFinished(String date) {
    return 'Finished $date';
  }

  @override
  String experimentStopped(String date) {
    return 'Stopped $date';
  }

  @override
  String experimentPastSummary(String before, String during) {
    return '$before attacks per week before, $during during';
  }

  @override
  String get accountTitle => 'Account';

  @override
  String get settingsAccountHint =>
      'Optional. Only needed for backup and share links';

  @override
  String get accountIntro =>
      'An account is optional. Everything in the app works without one, and your entries stay on this phone. You only need one for encrypted backup and share links.';

  @override
  String get accountUnavailable => 'Accounts aren\'t set up in this build.';

  @override
  String get accountApple => 'Continue with Apple';

  @override
  String get accountGoogle => 'Continue with Google';

  @override
  String get accountOrEmail => 'Or use your email';

  @override
  String get accountEmail => 'Email';

  @override
  String get accountPassword => 'Password';

  @override
  String accountPasswordHint(int min) {
    return 'At least $min characters for a new account';
  }

  @override
  String get accountSignIn => 'Sign in';

  @override
  String get accountCreate => 'Create account';

  @override
  String get accountForgot => 'Forgot password?';

  @override
  String get accountResetSent =>
      'If that email has an account, a reset link is on its way.';

  @override
  String accountSignedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String accountSignedInWith(String method) {
    return 'Signed in with $method';
  }

  @override
  String get accountMethodApple => 'Apple';

  @override
  String get accountMethodGoogle => 'Google';

  @override
  String get accountMethodEmail => 'email';

  @override
  String get accountSignedInNote =>
      'Your entries still live on this phone. Signing out deletes nothing.';

  @override
  String get accountSignOut => 'Sign out';

  @override
  String get accountDelete => 'Delete account';

  @override
  String get accountDeleteTitle => 'Delete your account?';

  @override
  String accountDeleteBody(int hours) {
    return 'This deletes your account. Within $hours hours your encrypted backup and any share links are removed from our servers. Everything on this phone stays.';
  }

  @override
  String get accountDeletePassword => 'Enter your password to confirm';

  @override
  String get accountDeleteSubscription =>
      'A Premium subscription is billed by the App Store or Google Play. Deleting the account does not cancel it; cancel it in the store.';

  @override
  String get accountDeleteCancel => 'Keep account';

  @override
  String accountDeleted(int hours) {
    return 'Account deleted. Its server data will be gone within $hours hours.';
  }

  @override
  String get accountErrorWrongCredentials =>
      'That email and password don\'t match.';

  @override
  String get accountErrorEmailInUse =>
      'That email already has an account. Try signing in instead.';

  @override
  String get accountErrorWeakPassword => 'Choose a longer password.';

  @override
  String get accountErrorInvalidEmail => 'Check the email address.';

  @override
  String get accountErrorNetwork =>
      'No connection. Try again when you\'re online.';

  @override
  String get accountErrorRecentSignIn =>
      'For your safety, sign in again, then try once more.';

  @override
  String get accountErrorUnknown => 'Something went wrong. Try again.';

  @override
  String get backupTitle => 'Encrypted backup';

  @override
  String get settingsBackupHint => 'Locked with a passphrase only you know';

  @override
  String get backupIntro =>
      'Your backup is locked on this phone with your passphrase before it is uploaded. We store only the locked file and cannot open it.';

  @override
  String get backupForgetWarning =>
      'If you forget the passphrase, nobody can open the backup, not even us. Write it down somewhere safe.';

  @override
  String get backupNeedsAccount =>
      'Backup needs an account. Everything else works without one.';

  @override
  String get backupOpenAccount => 'Set up an account';

  @override
  String get backupNone => 'No backup yet';

  @override
  String backupLast(String date) {
    return 'Last backup: $date';
  }

  @override
  String get backupStatusUnknown => 'Couldn\'t check for a backup right now.';

  @override
  String get backupPassphrase => 'Passphrase';

  @override
  String backupPassphraseHint(int min) {
    return 'At least $min characters. A few unrelated words work well.';
  }

  @override
  String get backupPassphraseRepeat => 'Repeat the passphrase to back up';

  @override
  String get backupNow => 'Back up now';

  @override
  String get backupDone => 'Backed up.';

  @override
  String get backupRestore => 'Restore from backup';

  @override
  String get backupRestoreTitle => 'Replace everything on this phone?';

  @override
  String backupRestoreBody(String date) {
    return 'Everything on this phone is replaced with the backup from $date.';
  }

  @override
  String get backupRestoreConfirm => 'Restore';

  @override
  String get backupRestored => 'Restored from your backup.';

  @override
  String get backupDelete => 'Delete backup';

  @override
  String get backupDeleteTitle => 'Delete the backup?';

  @override
  String get backupDeleteBody =>
      'The locked file is removed from our servers. Everything on this phone stays.';

  @override
  String get backupDeleted => 'Backup deleted.';

  @override
  String get backupWorking => 'Working on it. This can take a few seconds.';

  @override
  String get backupErrorMismatch => 'The two passphrases don\'t match.';

  @override
  String backupErrorShort(int min) {
    return 'Use at least $min characters.';
  }

  @override
  String get backupErrorNoBackup => 'There\'s no backup on this account yet.';

  @override
  String get backupErrorTooLarge => 'The backup is too large to upload.';

  @override
  String get backupErrorNewerApp =>
      'This backup was made by a newer version of the app. Update the app, then try again.';

  @override
  String get backupErrorWrongPassphrase =>
      'That passphrase doesn\'t open this backup.';

  @override
  String get backupErrorDamaged => 'The backup file is damaged.';

  @override
  String get backupErrorPinning =>
      'The connection to the backup server couldn\'t be verified, so nothing was sent. Try another network.';

  @override
  String get backupErrorNotAllowed =>
      'Your sign-in has expired. Sign in again, then retry.';

  @override
  String get shareLinkButton => 'Share as a web link';

  @override
  String get shareLinkTitle => 'Share with your clinician';

  @override
  String get shareLinkExplain =>
      'Anyone with the link can read this report until it expires. It shows the same summary as the PDF, not your diary. You can stop sharing at any time.';

  @override
  String get shareLinkNeedsAccount =>
      'Sharing a link needs an account. The PDF and CSV work without one.';

  @override
  String shareLinkDuration(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get shareLinkCreate => 'Create link';

  @override
  String get shareLinkWorking => 'Creating the link.';

  @override
  String shareLinkReady(String date) {
    return 'Link ready. Shared until $date.';
  }

  @override
  String get shareLinkCopy => 'Copy link';

  @override
  String get shareLinkCopied => 'Link copied.';

  @override
  String get shareLinkShare => 'Share link';

  @override
  String shareLinkMessage(String url) {
    return 'My migraine report: $url';
  }

  @override
  String get shareLinksTitle => 'Shared links';

  @override
  String get settingsShareLinksHint =>
      'See and stop the report links you shared';

  @override
  String get shareLinksEmpty =>
      'You haven\'t shared any links. Create one from Doctor report.';

  @override
  String shareLinkActiveUntil(String date) {
    return 'Shared until $date';
  }

  @override
  String shareLinkExpiredOn(String date) {
    return 'Expired $date';
  }

  @override
  String get shareLinkRevoked => 'Sharing stopped';

  @override
  String shareLinkCreatedOn(String date) {
    return 'Created $date';
  }

  @override
  String get shareLinkRevoke => 'Stop sharing';

  @override
  String get shareLinkRevokeTitle => 'Stop sharing this report?';

  @override
  String get shareLinkRevokeBody =>
      'The link stops working at once, for everyone who has it.';

  @override
  String get shareLinkRevokedDone =>
      'Sharing stopped. The link no longer works.';

  @override
  String get shareLinkErrorUnavailable =>
      'Share links aren\'t set up in this build.';

  @override
  String get shareLinkErrorSignedOut =>
      'Your sign-in has expired. Sign in again, then retry.';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumIntro =>
      'Premium adds four extras. Everything else stays free, with no time limit.';

  @override
  String get premiumFreeNote =>
      'Always free: logging attacks and check-ins, the weather feed, the risk level, insights, the medication log and the doctor report.';

  @override
  String get premiumFeatureShareLink => 'Clinician share link';

  @override
  String get premiumFeatureShareLinkHint =>
      'Send your report as a web link that stops working after 7 or 30 days.';

  @override
  String get premiumFeatureExperiments => 'Experiments';

  @override
  String get premiumFeatureExperimentsHint =>
      'Try one change for two weeks and compare it with the weeks before.';

  @override
  String get premiumFeatureExtendedFactors => 'Extended environment factors';

  @override
  String get premiumFeatureExtendedFactorsHint =>
      'Particulates, ozone and pollen by type.';

  @override
  String get premiumFeatureBackup => 'Backup across phones';

  @override
  String get premiumFeatureBackupHint =>
      'An encrypted backup you can restore on a new phone.';

  @override
  String get premiumActive => 'Premium is on.';

  @override
  String premiumRenews(String date) {
    return 'Renews on $date.';
  }

  @override
  String premiumEnds(String date) {
    return 'Ends on $date.';
  }

  @override
  String get premiumManage => 'Manage subscription';

  @override
  String premiumOfferMonthly(String price) {
    return 'Monthly, $price';
  }

  @override
  String premiumOfferAnnual(String price) {
    return 'Yearly, $price';
  }

  @override
  String premiumOfferOther(String price) {
    return '$price';
  }

  @override
  String get premiumRestore => 'Restore purchases';

  @override
  String get premiumRestoredNone =>
      'No Premium purchase was found for this store account.';

  @override
  String get premiumThanks => 'Thank you. Premium is on.';

  @override
  String get premiumRenewalTerms =>
      'Subscriptions renew automatically until you cancel in the store\'s settings. Cancel at least 24 hours before the renewal date to avoid the next charge.';

  @override
  String get premiumLoadingOffers => 'Loading prices.';

  @override
  String get premiumNoOffers =>
      'Prices couldn\'t be loaded. Check the connection and try again.';

  @override
  String get premiumRetry => 'Try again';

  @override
  String get premiumUnavailable => 'Purchases aren\'t set up in this build.';

  @override
  String get premiumDevUnlocked =>
      'Development build: every Premium feature is unlocked.';

  @override
  String get premiumAccountTip =>
      'Using more than one phone? Sign in first, so Premium follows your account.';

  @override
  String get premiumErrorNotAllowed =>
      'This store account can\'t make purchases.';

  @override
  String get premiumErrorPending =>
      'The purchase is waiting for approval. Premium turns on once it goes through.';

  @override
  String get premiumErrorStore => 'The store had a problem. Try again later.';

  @override
  String premiumLockTitle(String feature) {
    return '$feature comes with Premium.';
  }

  @override
  String get premiumLockButton => 'See Premium';

  @override
  String get premiumLockShareLinkNote =>
      'Links you already made keep working until they end, and you can stop sharing them at any time.';

  @override
  String get premiumLockExperimentsNote => 'Your past results stay here.';

  @override
  String get premiumLockBackupNote =>
      'You can still restore or delete a backup you already have.';

  @override
  String get premiumFactorsLocked =>
      'Particulates, ozone and pollen come with Premium.';

  @override
  String get settingsPremiumHint =>
      'Share link, experiments, extended factors and backup';

  @override
  String get settingsPremiumActive => 'On';

  @override
  String get shareLinkErrorPremium =>
      'Share links need Premium. If you just subscribed, wait a minute and try again.';

  @override
  String get auditTitle => 'How the risk level has done';

  @override
  String auditNotYet(int needed, int logged) {
    return 'This page appears once you have logged $needed attacks. You have logged $logged so far.';
  }

  @override
  String auditIntro(int window) {
    String _temp0 = intl.Intl.pluralLogic(
      window,
      locale: localeName,
      other: '$window days',
      one: 'day',
    );
    return 'This compares the level the app showed each day with when your attacks started. An attack counts as following a High day when the day it started, or the $_temp0 before, was shown as High.';
  }

  @override
  String get auditEmpty =>
      'Nothing to compare yet. The app keeps the level it shows each day from now on, and the first numbers appear after your next attack or High day.';

  @override
  String get auditHitsTitle => 'Attacks that followed a High day';

  @override
  String auditHitsValue(int hits, int attacks, String share) {
    return '$hits of $attacks ($share)';
  }

  @override
  String get auditMissesTitle => 'Attacks without a High day before them';

  @override
  String auditMissesValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count attacks',
      one: '1 attack',
    );
    return '$_temp0';
  }

  @override
  String get auditFalseAlarmsTitle => 'High days with no attack';

  @override
  String auditFalseAlarmsValue(int count, int highDays) {
    return '$count of $highDays High days';
  }

  @override
  String get auditTrend => 'By month';

  @override
  String auditMonthLine(int hits, int attacks, int falseAlarms, int highDays) {
    return '$hits of $attacks attacks after a High day; $falseAlarms of $highDays High days without an attack';
  }

  @override
  String get auditCaveat =>
      'Small numbers move a lot from month to month. A High day without an attack is not a mistake: it means more of your usual triggers lined up. The level is a guide to plan around, not a promise.';

  @override
  String get auditShare => 'Share these counts each month';

  @override
  String get auditShareHint =>
      'Helps check the app for everyone. Only the five numbers and the model version are sent, never dates, places, your log or your account. Off unless you turn it on.';

  @override
  String get settingsAuditHint =>
      'Attacks after High days and High days without one';

  @override
  String unitHpa(String value) {
    return '$value hPa';
  }

  @override
  String unitInHg(String value) {
    return '$value inHg';
  }

  @override
  String unitMmHg(String value) {
    return '$value mmHg';
  }

  @override
  String unitCelsius(String value) {
    return '$value °C';
  }

  @override
  String unitFahrenheit(String value) {
    return '$value °F';
  }

  @override
  String get unitsTitle => 'Units';

  @override
  String get settingsUnitsHint => 'Pressure and temperature';

  @override
  String get unitsPressure => 'Pressure';

  @override
  String get unitsTemperature => 'Temperature';

  @override
  String get unitNameHpa => 'Hectopascals (hPa)';

  @override
  String get unitNameInHg => 'Inches of mercury (inHg)';

  @override
  String get unitNameMmHg => 'Millimetres of mercury (mmHg)';

  @override
  String get unitNameCelsius => 'Celsius (°C)';

  @override
  String get unitNameFahrenheit => 'Fahrenheit (°F)';

  @override
  String get unitsNote =>
      'The first choice comes from your phone\'s region. Changing it only changes how values are shown; your log stays the same.';

  @override
  String envTemperatureNow(String temperature) {
    return 'Temperature now: $temperature';
  }

  @override
  String get questionnaireEnglishNote =>
      'The questions are shown in their original English wording until a validated translation is added, so your scores stay comparable.';

  @override
  String get wellnessDisclaimer =>
      'General wellness information, not medical advice. Talk to your clinician about treatment.';

  @override
  String get dataSourceWeather => 'Open-Meteo weather';

  @override
  String get dataSourceAirQuality => 'Open-Meteo air quality and UV (CAMS)';

  @override
  String get dataSourcePollen => 'Open-Meteo pollen (CAMS)';

  @override
  String get dataSourceGeocoding => 'Open-Meteo geocoding';

  @override
  String get dataSourceBarometer => 'Device barometer';

  @override
  String get dataCoverageWorldwide => 'Worldwide';

  @override
  String get dataCoverageEuropeanAqi => 'Worldwide, European AQI in Europe';

  @override
  String get dataCoverageEurope => 'Europe only';

  @override
  String get dataCoverageBarometer => 'Phones with a pressure sensor';

  @override
  String get settingsReduceMotion => 'Reduce motion';

  @override
  String get settingsReduceMotionHint =>
      'Fewer animations, even when your phone\'s setting is off';
}

/// The translations for English (`en_XA`).
class AppLocalizationsEnXa extends AppLocalizationsEn {
  AppLocalizationsEnXa() : super('en_XA');

  @override
  String get appTitle => '⟦Åûŕáŵéļļ ···⟧';

  @override
  String get homeEmptyState =>
      '⟦Ñöţĥîñĝ ļöĝĝéð ýéţ.\nÝöûŕ ŕîšķ ļéṽéļ áñð éñṽîŕöñɱéñţ ŵîļļ áþþéáŕ ĥéŕé. ·························⟧';

  @override
  String get riskLevelLow => '⟦Ļöŵ ··⟧';

  @override
  String get riskLevelModerate => '⟦Ṁöðéŕáţé ···⟧';

  @override
  String get riskLevelHigh => '⟦Ĥîĝĥ ··⟧';

  @override
  String get devThemeGalleryTitle => '⟦Ţĥéɱé ĝáļļéŕý ·····⟧';

  @override
  String get devThemeLight => '⟦Ļîĝĥţ ţĥéɱé ····⟧';

  @override
  String get devThemeDark => '⟦Ðáŕķ ţĥéɱé ····⟧';

  @override
  String get devThemeAttack => '⟦Åţţáçķ ţĥéɱé ·····⟧';

  @override
  String get devSampleBody =>
      '⟦Ɓöðý ţéẋţ áţ ţĥé ðéƒáûļţ šîžé. Îţ ɱûšţ šţáý ŕéáðáƀļé áţ 200% ţéẋţ šçáļé ŵîţĥöûţ ţŕûñçáţîöñ. ································⟧';

  @override
  String get devSamplePrimary => '⟦Þŕîɱáŕý ···⟧';

  @override
  String get devSampleSecondary => '⟦Šéçöñðáŕý ····⟧';

  @override
  String get devSampleText => '⟦Ţéẋţ ··⟧';

  @override
  String get devSampleDisabled => '⟦Ðîšáƀļéð ···⟧';

  @override
  String get devSampleChipOn => '⟦Åûŕá ··⟧';

  @override
  String get devSampleChipOff => '⟦Ñáûšéá ···⟧';

  @override
  String get devSampleChipIcon => '⟦Ļîĝĥţ ··⟧';

  @override
  String get devSampleSlider => '⟦Îñţéñšîţý ····⟧';

  @override
  String get devSampleSliderLow => '⟦Ñö þáîñ ···⟧';

  @override
  String get devSampleSliderHigh => '⟦Ŵöŕšţ ··⟧';

  @override
  String get devSampleCard => '⟦Å çáŕð ŵîţĥ á ƀáðĝé ·······⟧';

  @override
  String get attackStart => '⟦Šţáŕţ áţţáçķ ·····⟧';

  @override
  String get attackContinue => '⟦Çöñţîñûé áţţáçķ ······⟧';

  @override
  String get attackTitleRunning => '⟦Åţţáçķ îñ þŕöĝŕéšš ·······⟧';

  @override
  String get attackTitleEnded => '⟦Åţţáçķ ···⟧';

  @override
  String attackStartedAt(String time) {
    return '⟦Šţáŕţéð áţ $time ····⟧';
  }

  @override
  String get attackNotFound => '⟦Ţĥîš áţţáçķ ñö ļöñĝéŕ éẋîšţš. ···········⟧';

  @override
  String get attackIntensity => '⟦Þáîñ îñţéñšîţý ·····⟧';

  @override
  String get durationEstimateTitle =>
      '⟦Ĥöŵ ļöñĝ áţţáçķš ļîķé ţĥîš ûšûáļļý ļášţ ··············⟧';

  @override
  String durationEstimateRange(String low, String high) {
    return '⟦Ţýþîçáļļý $low ţö $high ĥ ······⟧';
  }

  @override
  String durationEstimateSameMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ɓášéð öñ $count þášţ áţţáçķš öƒ šîɱîļáŕ îñţéñšîţý ŵîţĥ ţĥé šáɱé ɱéðîçáţîöñ',
    );
    return '⟦$_temp0 ·································⟧';
  }

  @override
  String durationEstimateNoMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ɓášéð öñ $count þášţ áţţáçķš öƒ šîɱîļáŕ îñţéñšîţý ŵîţĥöûţ ɱéðîçáţîöñ',
    );
    return '⟦$_temp0 ·······························⟧';
  }

  @override
  String durationEstimateSimilar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ɓášéð öñ $count þášţ áţţáçķš öƒ šîɱîļáŕ îñţéñšîţý',
    );
    return '⟦$_temp0 ························⟧';
  }

  @override
  String durationEstimateAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ɓášéð öñ $count öƒ ýöûŕ þášţ áţţáçķš',
    );
    return '⟦$_temp0 ···················⟧';
  }

  @override
  String get attackIntensityLow => '⟦Ñö þáîñ ···⟧';

  @override
  String get attackIntensityHigh => '⟦Ŵöŕšţ ··⟧';

  @override
  String get attackWhereItHurts => '⟦Ŵĥéŕé îţ ĥûŕţš ·····⟧';

  @override
  String get attackSymptoms => '⟦Šýɱþţöɱš ···⟧';

  @override
  String get attackPhases => '⟦Þĥášéš ···⟧';

  @override
  String get attackNotes => '⟦Ñöţéš ··⟧';

  @override
  String get attackNotesHint => '⟦Åñýţĥîñĝ éļšé ŵöŕţĥ ŕéɱéɱƀéŕîñĝ ···········⟧';

  @override
  String get attackEnd => '⟦Éñð áţţáçķ ····⟧';

  @override
  String get attackDone => '⟦Ðöñé ··⟧';

  @override
  String get attackFinishLater => '⟦Ƒîñîšĥ ļáţéŕ ·····⟧';

  @override
  String get symptomAura => '⟦Åûŕá ··⟧';

  @override
  String get symptomNeckTension => '⟦Ñéçķ ţéñšîöñ ·····⟧';

  @override
  String get symptomLightSensitivity => '⟦Ļîĝĥţ ··⟧';

  @override
  String get symptomSoundSensitivity => '⟦Šöûñð ··⟧';

  @override
  String get symptomSmellSensitivity => '⟦Šɱéļļ ··⟧';

  @override
  String get symptomNausea => '⟦Ñáûšéá ···⟧';

  @override
  String get phaseProdrome => '⟦Þŕöðŕöɱé ···⟧';

  @override
  String get phaseAura => '⟦Åûŕá ··⟧';

  @override
  String get phaseAttack => '⟦Åţţáçķ ···⟧';

  @override
  String get phasePostdrome => '⟦Þöšţðŕöɱé ····⟧';

  @override
  String get headForehead => '⟦Ƒöŕéĥéáð ···⟧';

  @override
  String get headLeftTemple => '⟦Ļéƒţ ţéɱþļé ····⟧';

  @override
  String get headRightTemple => '⟦Ŕîĝĥţ ţéɱþļé ·····⟧';

  @override
  String get headBehindEyes => '⟦Ɓéĥîñð ţĥé éýéš ······⟧';

  @override
  String get headLeftSide => '⟦Ļéƒţ šîðé ····⟧';

  @override
  String get headRightSide => '⟦Ŕîĝĥţ šîðé ····⟧';

  @override
  String get headTopOfHead => '⟦Ţöþ öƒ ĥéáð ····⟧';

  @override
  String get headBackOfHead => '⟦Ɓáçķ öƒ ĥéáð ·····⟧';

  @override
  String get headNeck => '⟦Ñéçķ ··⟧';

  @override
  String get checkinTitle => '⟦Ðáîļý çĥéçķ-îñ ·····⟧';

  @override
  String get checkinLoadError => '⟦Çöûļð ñöţ ļöáð ţĥîš ðáý. ·········⟧';

  @override
  String get checkinIntro => '⟦Ţĥŕéé ţáþš. Ĥöŵ ŵáš îţ? ·········⟧';

  @override
  String get checkinComplete =>
      '⟦Ðöñé ƒöŕ ţĥîš ðáý. Ţáþ á ñûɱƀéŕ ţö çĥáñĝé îţ. ················⟧';

  @override
  String get checkinAddMore => '⟦Åðð ɱöŕé (öþţîöñáļ) ·······⟧';

  @override
  String get checkinOptionalTitle => '⟦Öþţîöñáļ ···⟧';

  @override
  String get checkinDone => '⟦Ðöñé ··⟧';

  @override
  String get checkinToday => '⟦Ţöðáý ··⟧';

  @override
  String get checkinSleepQuality => '⟦Šļééþ ǫûáļîţý ·····⟧';

  @override
  String get checkinStress => '⟦Šţŕéšš ···⟧';

  @override
  String get checkinNeckTension => '⟦Ñéçķ ţéñšîöñ ·····⟧';

  @override
  String get checkinCaffeine => '⟦Çáƒƒéîñé ···⟧';

  @override
  String get checkinHydration => '⟦Ĥýðŕáţîöñ ····⟧';

  @override
  String get checkinAlcohol => '⟦Åļçöĥöļ ···⟧';

  @override
  String get checkinLightExposure => '⟦Ɓŕîĝĥţ ļîĝĥţ ·····⟧';

  @override
  String get checkinScreenExposure => '⟦Šçŕééñ ţîɱé ····⟧';

  @override
  String get checkinSleepLow => '⟦Þööŕ ··⟧';

  @override
  String get checkinSleepHigh => '⟦Ĝŕéáţ ··⟧';

  @override
  String get checkinStressLow => '⟦Çáļɱ ··⟧';

  @override
  String get checkinStressHigh => '⟦Ṽéŕý šţŕéššéð ·····⟧';

  @override
  String get checkinNeckLow => '⟦Ŕéļáẋéð ···⟧';

  @override
  String get checkinNeckHigh => '⟦Ṽéŕý ţîĝĥţ ····⟧';

  @override
  String get checkinHydrationLow => '⟦Ļîţţļé ···⟧';

  @override
  String get checkinHydrationHigh => '⟦Þļéñţý ···⟧';

  @override
  String get checkinExposureLow => '⟦Ļîţţļé ···⟧';

  @override
  String get checkinExposureHigh => '⟦Å ļöţ ··⟧';

  @override
  String get checkinNone => '⟦Ñöñé ··⟧';

  @override
  String checkinCupsOrMore(int count) {
    return '⟦$count+ çûþš ···⟧';
  }

  @override
  String checkinDrinksOrMore(int count) {
    return '⟦$count+ ðŕîñķš ···⟧';
  }

  @override
  String checkinValueSemantics(String field, int value, int max) {
    return '⟦$field, $value öƒ $max ···⟧';
  }

  @override
  String get checkinReminderTooltip => '⟦Ŕéɱîñðéŕ ţîɱé ·····⟧';

  @override
  String checkinReminderAt(String time) {
    return '⟦Ŕéɱîñðéŕ áţ $time ·····⟧';
  }

  @override
  String get checkinReminderPickerTitle =>
      '⟦Ðáîļý çĥéçķ-îñ ŕéɱîñðéŕ ·········⟧';

  @override
  String get checkinCardTitle => '⟦Ðáîļý çĥéçķ-îñ ·····⟧';

  @override
  String get checkinCardDone => '⟦Ðöñé ƒöŕ ţöðáý ·····⟧';

  @override
  String get checkinCardTodo => '⟦Ţĥŕéé ţáþš, áƀöûţ 10 šéçöñðš ··········⟧';

  @override
  String get medicationTitle => '⟦Ṁéðîçáţîöñ ····⟧';

  @override
  String get medicationAdd => '⟦Åðð ɱéðîçáţîöñ ·····⟧';

  @override
  String get medicationAddTitle => '⟦Ļöĝ á ðöšé ····⟧';

  @override
  String get medicationName => '⟦Ṁéðîçáţîöñ ····⟧';

  @override
  String get medicationDose => '⟦Ðöšé ··⟧';

  @override
  String get medicationDoseHint => '⟦é.ĝ. 400 ɱĝ ····⟧';

  @override
  String get medicationKindAcute => '⟦Åçûţé ··⟧';

  @override
  String get medicationKindPreventive => '⟦Þŕéṽéñţîṽé ····⟧';

  @override
  String medicationTakenAt(String time) {
    return '⟦Ţáķéñ áţ $time ····⟧';
  }

  @override
  String get medicationLog => '⟦Ļöĝ ··⟧';

  @override
  String get medicationDelete => '⟦Ðéļéţé ···⟧';

  @override
  String get medicationThisMonth => '⟦Ţĥîš ɱöñţĥ ····⟧';

  @override
  String get medicationEmpty => '⟦Ñö ðöšéš ļöĝĝéð ţĥîš ɱöñţĥ. ··········⟧';

  @override
  String get medicationReliefQuestion => '⟦Ŕéļîéƒ áƒţéŕ 2 ĥ? ······⟧';

  @override
  String get medicationReliefNone => '⟦Ñöñé ··⟧';

  @override
  String get medicationReliefPartial => '⟦Šöɱé ··⟧';

  @override
  String get medicationReliefFull => '⟦Ƒûļļ ··⟧';

  @override
  String medicationAcuteDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count áçûţé-ɱéðîçáţîöñ ðáýš ţĥîš ɱöñţĥ',
      one: '1 áçûţé-ɱéðîçáţîöñ ðáý ţĥîš ɱöñţĥ',
      zero: 'Ñö áçûţé-ɱéðîçáţîöñ ðáýš ţĥîš ɱöñţĥ',
    );
    return '⟦$_temp0 ·······················⟧';
  }

  @override
  String get medicationAcuteDaysHint =>
      '⟦Ðáýš ŵîţĥ áţ ļéášţ öñé áçûţé ðöšé, çöûñţéð þéŕ çáļéñðáŕ ɱöñţĥ. ······················⟧';

  @override
  String medicationOveruseFirstNote(int days) {
    return '⟦Ýöû ĥáṽé ŕéáçĥéð $days áçûţé-ɱéðîçáţîöñ ðáýš ţĥîš ɱöñţĥ. Ṁáñý çļîñîçîáñš šûĝĝéšţ ķééþîñĝ ţĥîš ñûɱƀéŕ ļöŵ; îţ ɱáý ƀé ŵöŕţĥ á çöñṽéŕšáţîöñ. ········································⟧';
  }

  @override
  String medicationOveruseSecondNote(int days) {
    return '⟦Ýöû ĥáṽé ŕéáçĥéð $days áçûţé-ɱéðîçáţîöñ ðáýš ţĥîš ɱöñţĥ. Þļéášé çöñšîðéŕ ţáļķîñĝ ţö ýöûŕ çļîñîçîáñ áƀöûţ ţĥîš þáţţéŕñ. ········································⟧';
  }

  @override
  String get medicationTalkToClinician => '⟦Ţáļķ ţö ýöûŕ çļîñîçîáñ ········⟧';

  @override
  String get cycleTitle => '⟦Çýçļé ··⟧';

  @override
  String get cycleToggleTitle => '⟦Ţŕáçķ ɱý çýçļé ·····⟧';

  @override
  String get cycleToggleSubtitle =>
      '⟦Öƒƒ ƀý ðéƒáûļţ. Ŵĥéñ öñ, çýçļé ðáý îš ķéþţ ŵîţĥ éáçĥ çĥéçķ-îñ áñð ûšéð áš á ƒáçţöŕ. ······························⟧';

  @override
  String get cycleNoData =>
      '⟦Ļöĝ á þéŕîöð šţáŕţ ţö šéé ýöûŕ çýçļé ðáý. ···············⟧';

  @override
  String cycleDayAndPhase(int day, String phase) {
    return '⟦Çýçļé ðáý $day · $phase ·····⟧';
  }

  @override
  String cycleLength(int days) {
    return '⟦Ɓášéð öñ á $days-ðáý çýçļé ········⟧';
  }

  @override
  String get cyclePeriodStarts => '⟦Þéŕîöð šţáŕţš ·····⟧';

  @override
  String get cycleNoStarts => '⟦Ñöñé ļöĝĝéð ýéţ. ······⟧';

  @override
  String get cycleRemoveStart => '⟦Ŕéɱöṽé ···⟧';

  @override
  String get cyclePeriodStartedToday => '⟦Þéŕîöð šţáŕţéð ţĥîš ðáý ·········⟧';

  @override
  String get cyclePhaseMenstrual => '⟦Ṁéñšţŕûáļ ····⟧';

  @override
  String get cyclePhaseFollicular => '⟦Ƒöļļîçûļáŕ ····⟧';

  @override
  String get cyclePhaseOvulation => '⟦Åŕöûñð öṽûļáţîöñ ······⟧';

  @override
  String get cyclePhaseLuteal => '⟦Ļûţéáļ ···⟧';

  @override
  String get settingsTitle => '⟦Šéţţîñĝš ···⟧';

  @override
  String get settingsSectionDaily => '⟦Ðáîļý ··⟧';

  @override
  String get settingsSectionData => '⟦Ýöûŕ ðáţá ····⟧';

  @override
  String get settingsSectionAbout => '⟦Åƀöûţ ··⟧';

  @override
  String get settingsExportJson => '⟦Éẋþöŕţ áš ĴŠÖÑ ·····⟧';

  @override
  String get settingsExportJsonHint =>
      '⟦Éṽéŕý ţáƀļé îñ öñé ƒîļé ýöû çáñ îɱþöŕţ áĝáîñ. ················⟧';

  @override
  String get settingsExportCsv => '⟦Éẋþöŕţ áš ÇŠṼ ·····⟧';

  @override
  String get settingsExportCsvHint =>
      '⟦Öñé šþŕéáðšĥééţ ƒîļé þéŕ ţáƀļé. ···········⟧';

  @override
  String get settingsExportEmpty => '⟦Ñöţĥîñĝ ţö éẋþöŕţ ýéţ. ········⟧';

  @override
  String get settingsDeleteAll => '⟦Ðéļéţé éṽéŕýţĥîñĝ ······⟧';

  @override
  String get settingsDeleteAllHint =>
      '⟦Ŕéɱöṽéš áļļ ðáţá ƒŕöɱ ţĥîš ðéṽîçé. Çáññöţ ƀé ûñðöñé. ···················⟧';

  @override
  String settingsDeleteAllConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ţĥîš ðéļéţéš $count ŕéçöŕðš ƒŕöɱ ţĥîš ðéṽîçé. Ţĥîš çáññöţ ƀé ûñðöñé.',
      one: 'Ţĥîš ðéļéţéš 1 ŕéçöŕð ƒŕöɱ ţĥîš ðéṽîçé. Ţĥîš çáññöţ ƀé ûñðöñé.',
      zero: 'Ţĥéŕé îš ñöţĥîñĝ šţöŕéð ýéţ. Ðéļéţé áñýŵáý?',
    );
    return '⟦$_temp0 ·································⟧';
  }

  @override
  String get settingsDeleteAllButton => '⟦Ðéļéţé ···⟧';

  @override
  String get settingsCancel => '⟦Çáñçéļ ···⟧';

  @override
  String get settingsDeletedAll => '⟦Åļļ ðáţá ðéļéţéð. ······⟧';

  @override
  String get settingsPrivacyPolicy => '⟦Þŕîṽáçý þöļîçý ·····⟧';

  @override
  String get settingsTerms => '⟦Ţéŕɱš öƒ ûšé ·····⟧';

  @override
  String get settingsSupport => '⟦Šûþþöŕţ ···⟧';

  @override
  String get environmentTitle => '⟦Éñṽîŕöñɱéñţ ····⟧';

  @override
  String get environmentCardTitle => '⟦Þŕéššûŕé ···⟧';

  @override
  String get environmentCardEmpty =>
      '⟦Ñö ŵéáţĥéŕ šáṽéð ýéţ. Ţáþ ţö šéţ ýöûŕ ļöçáţîöñ. ·················⟧';

  @override
  String environmentCardSummary(String pressure, String trend) {
    return '⟦$pressure, $trend ·⟧';
  }

  @override
  String get envPressureSection => '⟦Åîŕ þŕéššûŕé ·····⟧';

  @override
  String get envPressureUnknown => '⟦Ñö ŕéáðîñĝ ƒöŕ ţĥîš ĥöûŕ ·········⟧';

  @override
  String get envDelta3h => '⟦3 ĥ ··⟧';

  @override
  String get envDelta6h => '⟦6 ĥ ··⟧';

  @override
  String get envDelta12h => '⟦12 ĥ ··⟧';

  @override
  String get envDelta24h => '⟦24 ĥ ··⟧';

  @override
  String get envDeltaUnknown => '⟦– ·⟧';

  @override
  String get envChartTitle => '⟦Ļášţ 48 ĥöûŕš áñð ñéẋţ 24 ·········⟧';

  @override
  String get envUpdatedNever => '⟦Ñöţ ûþðáţéð ýéţ ······⟧';

  @override
  String get envUpdatedJustNow => '⟦Ûþðáţéð ĵûšţ ñöŵ ······⟧';

  @override
  String envUpdatedMinutes(int n) {
    return '⟦Ûþðáţéð $n ɱîñ áĝö ······⟧';
  }

  @override
  String envUpdatedHours(int n) {
    return '⟦Ûþðáţéð $n ĥ áĝö ·····⟧';
  }

  @override
  String envUpdatedDays(int n) {
    return '⟦Ûþðáţéð $n ð áĝö ·····⟧';
  }

  @override
  String get envStale =>
      '⟦Ţĥîš ƒöŕéçášţ îš á ƒéŵ ĥöûŕš öļð. Îţ ŕéƒŕéšĥéš ŵĥéñ ýöû áŕé ƀáçķ öñļîñé. ··························⟧';

  @override
  String get envOffline =>
      '⟦Çöûļð ñöţ ŕéáçĥ ţĥé ŵéáţĥéŕ šéŕṽîçé. Šĥöŵîñĝ ŵĥáţ îš šáṽéð öñ ţĥîš ðéṽîçé. ··························⟧';

  @override
  String get envNoData =>
      '⟦Ñö ŵéáţĥéŕ šáṽéð ýéţ. Åļļöŵ ļöçáţîöñ öŕ çĥööšé á çîţý ţö šéé ţĥé þŕéššûŕé ţŕéñð. ····························⟧';

  @override
  String get envRefresh => '⟦Ŕéƒŕéšĥ ···⟧';

  @override
  String get envLocationSection => '⟦Ļöçáţîöñ ···⟧';

  @override
  String get envLocationGps => '⟦Ûšîñĝ ýöûŕ áþþŕöẋîɱáţé ļöçáţîöñ ···········⟧';

  @override
  String envLocationManual(String city) {
    return '⟦Ûšîñĝ $city ···⟧';
  }

  @override
  String get envLocationLast => '⟦Ûšîñĝ ţĥé ļášţ ķñöŵñ áŕéá ·········⟧';

  @override
  String get envLocationNone => '⟦Ñö ļöçáţîöñ šéţ ······⟧';

  @override
  String get envUseMyLocation => '⟦Ûšé ɱý ļöçáţîöñ ······⟧';

  @override
  String get envChooseCity => '⟦Çĥööšé á çîţý ·····⟧';

  @override
  String get envCitySearchTitle => '⟦Çĥööšé á çîţý ·····⟧';

  @override
  String get envCitySearchHint => '⟦Çîţý ñáɱé ····⟧';

  @override
  String get envCityNoResults => '⟦Ñö þļáçéš ƒöûñð ······⟧';

  @override
  String get envCitySearchFailed =>
      '⟦Çöûļð ñöţ šéáŕçĥ ŕîĝĥţ ñöŵ. Çĥéçķ ýöûŕ çöññéçţîöñ áñð ţŕý áĝáîñ. ·······················⟧';

  @override
  String get envPrivacyNote =>
      '⟦Ýöûŕ ļöçáţîöñ îš ŕöûñðéð ţö áƀöûţ 10 ķɱ ƀéƒöŕé îţ ļéáṽéš ţĥîš ðéṽîçé. ·························⟧';

  @override
  String get envAttribution => '⟦Ŵéáţĥéŕ ðáţá ƀý Öþéñ-Ṁéţéö ··········⟧';

  @override
  String get envTrendRising => '⟦ŕîšîñĝ ···⟧';

  @override
  String get envTrendFalling => '⟦ƒáļļîñĝ ···⟧';

  @override
  String get envTrendSteady => '⟦šţéáðý ···⟧';

  @override
  String get envTrendUnknown => '⟦ñö ţŕéñð ýéţ ·····⟧';

  @override
  String get barometerTitle => '⟦Ɓáŕöɱéţéŕ ····⟧';

  @override
  String get barometerOpen => '⟦Öþéñ ţĥé ƀáŕöɱéţéŕ ·······⟧';

  @override
  String get barometerNoReading => '⟦Ñö ŕéáðîñĝ ····⟧';

  @override
  String get barometerFromSensor => '⟦Ƒŕöɱ ţĥîš ðéṽîçé\'š šéñšöŕ ·········⟧';

  @override
  String get barometerFromStation => '⟦Ƒŕöɱ ţĥé ñéáŕéšţ šţáţîöñ ·········⟧';

  @override
  String get barometerNoSource =>
      '⟦Ñö šéñšöŕ öñ ţĥîš ðéṽîçé áñð ñö ƒöŕéçášţ šáṽéð ýéţ ··················⟧';

  @override
  String get barometerCalibrationSection => '⟦Çáļîƀŕáţîöñ ····⟧';

  @override
  String barometerOffset(String offset, int pairs) {
    return '⟦Šéñšöŕ öƒƒšéţ $offset áĝáîñšţ ţĥé šţáţîöñ šéŕîéš, ƒŕöɱ $pairs ĥöûŕļý þáîŕš. ······················⟧';
  }

  @override
  String barometerNotCalibrated(int pairs) {
    return '⟦Ñöţ çáļîƀŕáţéð ýéţ. Ñééðš áţ ļéášţ $pairs ĥöûŕš ŵîţĥ ƀöţĥ á šéñšöŕ šáɱþļé áñð á šţáţîöñ ṽáļûé. ·······························⟧';
  }

  @override
  String get barometerTrendSection =>
      '⟦Ļášţ 24 ĥöûŕš öñ ţĥîš ðéṽîçé ··········⟧';

  @override
  String get barometerTrendEmpty =>
      '⟦Šáɱþļéš áŕé ţáķéñ ŵĥîļé ţĥé áþþ îš öþéñ. Çöɱé ƀáçķ ļáţéŕ ţö šéé ţĥé ţŕéñð. ··························⟧';

  @override
  String barometerTrendSamples(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n šáɱþļéš',
      one: '1 šáɱþļé',
    );
    return '⟦$_temp0 ···········⟧';
  }

  @override
  String get barometerStampNote =>
      '⟦Éáçĥ áţţáçķ ýöû šţáŕţ ŕéçöŕðš ţĥé šéñšöŕ ŕéáðîñĝ áñð ţĥé šţáţîöñ ṽáļûé öƒ ţĥáţ ĥöûŕ. ······························⟧';

  @override
  String get envFactorsTitle => '⟦Ţöðáý\'š ƒáçţöŕš ······⟧';

  @override
  String get envFactorsEmpty =>
      '⟦Ñö ðáîļý ƒáçţöŕš ƒöŕ ţĥîš áŕéá ýéţ. ·············⟧';

  @override
  String get factorBandLow => '⟦ļöŵ ··⟧';

  @override
  String get factorBandModerate => '⟦ɱöðéŕáţé ···⟧';

  @override
  String get factorBandHigh => '⟦ĥîĝĥ ··⟧';

  @override
  String get factorBandVeryHigh => '⟦ṽéŕý ĥîĝĥ ····⟧';

  @override
  String factorValueWithBand(String value, String band) {
    return '⟦$value ($band) ··⟧';
  }

  @override
  String get factorAqiUs => '⟦Åîŕ ǫûáļîţý (ÛŠ ÅǪÎ) ·······⟧';

  @override
  String get factorAqiEu => '⟦Åîŕ ǫûáļîţý (Éûŕöþéáñ ÅǪÎ) ··········⟧';

  @override
  String get factorParticulates => '⟦Þáŕţîçûļáţéš ÞṀ2.5 / ÞṀ10 ·········⟧';

  @override
  String factorParticulatesValue(String pm25, String pm10) {
    return '⟦$pm25 / $pm10 µĝ/ɱ³ ····⟧';
  }

  @override
  String get factorOzone => '⟦Öžöñé ··⟧';

  @override
  String factorMicrograms(String value) {
    return '⟦$value µĝ/ɱ³ ···⟧';
  }

  @override
  String get factorPollen => '⟦Þöļļéñ (Éûŕöþé öñļý) ·······⟧';

  @override
  String factorPollenType(String type, String band) {
    return '⟦$type $band ·⟧';
  }

  @override
  String get pollenAlder => '⟦áļðéŕ ··⟧';

  @override
  String get pollenBirch => '⟦ƀîŕçĥ ··⟧';

  @override
  String get pollenGrass => '⟦ĝŕášš ··⟧';

  @override
  String get pollenMugwort => '⟦ɱûĝŵöŕţ ···⟧';

  @override
  String get pollenOlive => '⟦öļîṽé ··⟧';

  @override
  String get pollenRagweed => '⟦ŕáĝŵééð ···⟧';

  @override
  String get factorUvMax => '⟦ÛṼ îñðéẋ, ðáîļý ɱáẋ ·······⟧';

  @override
  String get factorDaylight => '⟦Ðáýļîĝĥţ ···⟧';

  @override
  String factorDaylightValue(int hours, int minutes) {
    return '⟦$hours ĥ $minutes ɱîñ ···⟧';
  }

  @override
  String get factorSun => '⟦Šûñŕîšé áñð šûñšéţ ·······⟧';

  @override
  String factorSunValue(String sunrise, String sunset) {
    return '⟦$sunrise ţö $sunset ··⟧';
  }

  @override
  String get aboutDataTitle => '⟦Åƀöûţ ţĥé ðáţá ·····⟧';

  @override
  String get aboutDataIntro =>
      '⟦Ŵĥéŕé ţĥé ñûɱƀéŕš îñ ţĥîš áþþ çöɱé ƒŕöɱ, áñð ŵĥáţ éáçĥ öñé çáñ áñð çáññöţ ţéļļ ýöû. ······························⟧';

  @override
  String get aboutDataSources => '⟦Šöûŕçéš ···⟧';

  @override
  String aboutDataLicence(String coverage, String licence) {
    return '⟦$coverage. Ļîçéñçé: $licence. ·····⟧';
  }

  @override
  String get aboutDataPrivacy => '⟦Ŵĥáţ ļéáṽéš ýöûŕ þĥöñé ········⟧';

  @override
  String get aboutDataPrivacyBody =>
      '⟦Öñļý á ļöçáţîöñ ŕöûñðéð ţö áƀöûţ 10 ķɱ, šö ţĥé ŵéáţĥéŕ šéŕṽîçé çáñ áñšŵéŕ ƒöŕ ýöûŕ áŕéá. Ýöûŕ áţţáçķš, çĥéçķ-îñš, ɱéðîçáţîöñ áñð ĥéáļţĥ ðáţá šţáý öñ ţĥîš ðéṽîçé ûñļéšš ýöû çĥööšé ţö ƀáçķ ûþ öŕ šĥáŕé ţĥéɱ. ········································⟧';

  @override
  String get aboutDataLimits => '⟦Ļîɱîţš ···⟧';

  @override
  String get aboutDataLimitsBody =>
      '⟦Ƒöŕéçášţš áŕé ɱöðéļ éšţîɱáţéš ƒöŕ á ĝŕîð çéļļ, ñöţ á ɱéášûŕéɱéñţ áţ ýöûŕ ðööŕ. Þöļļéñ îš öñļý áṽáîļáƀļé îñ Éûŕöþé. Åîŕ ǫûáļîţý ɱáý ƀé ɱîššîñĝ îñ šöɱé ŕéĝîöñš. Ŵĥéŕé á ƒáçţöŕ ĥáš ñö ðáţá ƒöŕ ýöûŕ áŕéá îţ îš šîɱþļý ñöţ šĥöŵñ. ········································⟧';

  @override
  String get settingsHealthHint =>
      '⟦Šļééþ, ĥéáŕţ ŕáţé, šţéþš áñð çýçļé ƒŕöɱ ýöûŕ ĥéáļţĥ áþþ ····················⟧';

  @override
  String get healthTitle => '⟦Ĥéáļţĥ ðáţá ····⟧';

  @override
  String healthIntro(String store) {
    return '⟦Çĥööšé ŵĥáţ ţö ŕéáð ƒŕöɱ $store. Éáçĥ ţýþé ĥáš îţš öŵñ šŵîţçĥ áñð îţš öŵñ ŕéášöñ. ···························⟧';
  }

  @override
  String get healthPrivacyNote =>
      '⟦Îɱþöŕţéð ðáţá šţáýš öñ ţĥîš þĥöñé. Îţ îš ñéṽéŕ ûþļöáðéð, ñöţ éṽéñ ŵîţĥ ƀáçķûþ, ûñļéšš ýöû éẋþöŕţ îţ ýöûŕšéļƒ. ·······································⟧';

  @override
  String get healthStoreApple => '⟦Åþþļé Ĥéáļţĥ ·····⟧';

  @override
  String get healthStoreConnect => '⟦Ĥéáļţĥ Çöññéçţ ·····⟧';

  @override
  String healthUnavailable(String store) {
    return '⟦$store îš ñöţ áṽáîļáƀļé öñ ţĥîš ðéṽîçé. ············⟧';
  }

  @override
  String get healthReadSection => '⟦Ŕéáð ··⟧';

  @override
  String get healthTypeSleep => '⟦Šļééþ ··⟧';

  @override
  String get healthReasonSleep =>
      '⟦Ƒîļļš îñ šļééþ ǫûáļîţý öñ ýöûŕ ðáîļý çĥéçķ-îñ ƒŕöɱ ţĥé ñîĝĥţ\'š šļééþ, šö ýöû ĥáṽé öñé ļéšš ţáþ. ··································⟧';

  @override
  String get healthTypeRestingHr => '⟦Ŕéšţîñĝ ĥéáŕţ ŕáţé ·······⟧';

  @override
  String get healthReasonRestingHr =>
      '⟦Å ĥîĝĥéŕ ŕéšţîñĝ ŕáţé ţĥáñ ûšûáļ çáñ šĥöŵ šţŕáîñ ţĥé ðáý ƀéƒöŕé áñ áţţáçķ. ··························⟧';

  @override
  String get healthTypeHrv => '⟦Ĥéáŕţ ŕáţé ṽáŕîáƀîļîţý ········⟧';

  @override
  String get healthReasonHrv =>
      '⟦Ļöŵéŕ ṽáŕîáƀîļîţý ţĥáñ ûšûáļ öƒţéñ ĝöéš ŵîţĥ šţŕéšš áñð þööŕ ŕéçöṽéŕý. ·························⟧';

  @override
  String get healthTypeSteps => '⟦Šţéþš ··⟧';

  @override
  String get healthReasonSteps =>
      '⟦Ṽéŕý ļöŵ öŕ ṽéŕý ĥîĝĥ áçţîṽîţý ðáýš áŕé ŵöŕţĥ šééîñĝ ñéẋţ ţö ýöûŕ áţţáçķš. ··························⟧';

  @override
  String get healthTypeFlow => '⟦Ṁéñšţŕûáļ ƒļöŵ ·····⟧';

  @override
  String get healthReasonFlow =>
      '⟦Ƒîļļš îñ þéŕîöð šţáŕţš ƒöŕ çýçļé ţŕáçķîñĝ, îƒ ýöû ûšé îţ. ····················⟧';

  @override
  String healthDenied(String store) {
    return '⟦$store ðîð ñöţ ĝŕáñţ áççéšš. Ýöû çáñ çĥáñĝé ţĥîš îñ îţš öŵñ šéţţîñĝš. ·······················⟧';
  }

  @override
  String get healthWriteSection => '⟦Ŵŕîţé ··⟧';

  @override
  String healthWriteHeadaches(String store) {
    return '⟦Ŵŕîţé ĥéáðáçĥé éṽéñţš ţö $store ·········⟧';
  }

  @override
  String get healthWriteHeadachesHint =>
      '⟦Éáçĥ éñðéð áţţáçķ îš šáṽéð áš á ĥéáðáçĥé ŵîţĥ îţš šţáŕţ, éñð áñð šéṽéŕîţý. Ñöţĥîñĝ éļšé îš ŵŕîţţéñ. ···································⟧';

  @override
  String get healthImportSection => '⟦Îɱþöŕţ ···⟧';

  @override
  String get healthImportNow => '⟦Îɱþöŕţ ñöŵ ····⟧';

  @override
  String get healthImportNever => '⟦Ñöţĥîñĝ îɱþöŕţéð ýéţ ·······⟧';

  @override
  String healthImportLast(String age) {
    return '⟦$age ·⟧';
  }

  @override
  String get healthImportFailed =>
      '⟦Ţĥé îɱþöŕţ ðîð ñöţ ƒîñîšĥ. Ţŕý áĝáîñ ļáţéŕ. ················⟧';

  @override
  String healthImportResult(int imported, int prefilled) {
    String _temp0 = intl.Intl.pluralLogic(
      imported,
      locale: localeName,
      other: '$imported ñéŵ šáɱþļéš.',
      one: '1 ñéŵ šáɱþļé.',
      zero: 'Ñöţĥîñĝ ñéŵ.',
    );
    String _temp1 = intl.Intl.pluralLogic(
      prefilled,
      locale: localeName,
      other: 'Šļééþ ƒîļļéð îñ ƒöŕ $prefilled ðáýš.',
      one: 'Šļééþ ƒîļļéð îñ ƒöŕ 1 ðáý.',
      zero: '',
    );
    return '⟦$_temp0 $_temp1 ······································⟧';
  }

  @override
  String get checkinSourceHealthkit => '⟦Ƒŕöɱ Åþþļé Ĥéáļţĥ ······⟧';

  @override
  String get checkinSourceHealthConnect => '⟦Ƒŕöɱ Ĥéáļţĥ Çöññéçţ ·······⟧';

  @override
  String get onboardingSkip => '⟦Šķîþ ··⟧';

  @override
  String get onboardingNext => '⟦Ñéẋţ ··⟧';

  @override
  String get onboardingFinish => '⟦Ƒîñîšĥ ···⟧';

  @override
  String onboardingStep(int step, int total) {
    return '⟦Šţéþ $step öƒ $total ····⟧';
  }

  @override
  String get onboardingWelcomeTitle => '⟦Ŵéļçöɱé ···⟧';

  @override
  String get onboardingLocationTitle => '⟦Ýöûŕ áŕéá\'š ŵéáţĥéŕ ·······⟧';

  @override
  String get onboardingLocationBody =>
      '⟦Åîŕ þŕéššûŕé çĥáñĝéš áŕé öñé öƒ ţĥé ɱöšţ çöɱɱöñ ţĥîñĝš þéöþļé ñöţîçé ƀéƒöŕé áñ áţţáçķ. Åļļöŵ áñ áþþŕöẋîɱáţé ļöçáţîöñ, öŕ þîçķ á çîţý, ţö šéé ţĥéɱ. ········································⟧';

  @override
  String get onboardingLocationNone =>
      '⟦Ñö ļöçáţîöñ ýéţ. Ýöû çáñ áļšö šéţ ţĥîš ļáţéŕ ƒŕöɱ ţĥé éñṽîŕöñɱéñţ šçŕééñ. ··························⟧';

  @override
  String get onboardingHealthTitle => '⟦Ĥéáļţĥ ðáţá ····⟧';

  @override
  String get onboardingHealthBody =>
      '⟦Öþţîöñáļ. Éáçĥ ţýþé ĥáš îţš öŵñ šŵîţçĥ áñð îţš öŵñ ŕéášöñ. Ýöû çáñ çĥáñĝé áñý öƒ ţĥéɱ ļáţéŕ îñ Šéţţîñĝš. ·····································⟧';

  @override
  String get onboardingHealthUnavailable =>
      '⟦Ñö ĥéáļţĥ áþþ îš áṽáîļáƀļé öñ ţĥîš ðéṽîçé. Ýöû çáñ šķîþ ţĥîš šţéþ. ························⟧';

  @override
  String get onboardingReminderTitle => '⟦Ðáîļý çĥéçķ-îñ ·····⟧';

  @override
  String get onboardingReminderBody =>
      '⟦Ţĥŕéé ţáþš á ðáý, áƀöûţ ţéñ šéçöñðš. Þîçķ á ţîɱé ƒöŕ ţĥé ŕéɱîñðéŕ. ························⟧';

  @override
  String get onboardingReminderNote =>
      '⟦Ŕéɱîñðéŕš šţáŕţ öñçé ñöţîƒîçáţîöñš áŕé šéţ ûþ. Ýöû çáñ çĥáñĝé ţĥé ţîɱé áñý ðáý ƒŕöɱ ţĥé çĥéçķ-îñ. ··································⟧';

  @override
  String get explainerTitle => '⟦Ŵĥáţ ţĥé ļéṽéļ ɱéáñš ·······⟧';

  @override
  String get explainerIntro =>
      '⟦Éáçĥ ðáý ţĥé áþþ šĥöŵš á ļéṽéļ ƀûîļţ ƒŕöɱ ýöûŕ öŵñ ĥîšţöŕý áñð ţöðáý\'š çöñðîţîöñš. ·····························⟧';

  @override
  String get explainerDoesTitle => '⟦Ŵĥáţ îţ ðöéš ·····⟧';

  @override
  String get explainerDoes1 =>
      '⟦Šĥöŵš ĥöŵ ţöðáý\'š ŵéáţĥéŕ, šļééþ, šţŕéšš áñð ŕöûţîñé çöɱþáŕé ŵîţĥ ţĥé ðáýš ƀéƒöŕé ýöûŕ þášţ áţţáçķš. ···································⟧';

  @override
  String get explainerDoes2 =>
      '⟦Ļéáŕñš ƒŕöɱ ýöûŕ öŵñ ļöĝ, šö îţ ĝéţš ɱöŕé šþéçîƒîç ţĥé ɱöŕé ýöû ŕéçöŕð. ·························⟧';

  @override
  String get explainerDoes3 =>
      '⟦Ĥéļþš ýöû ðéçîðé ŵĥéţĥéŕ ţöðáý îš á ðáý ţö ĝö éášîéŕ öñ ýöûŕšéļƒ. ·······················⟧';

  @override
  String get explainerDoesNotTitle => '⟦Ŵĥáţ îţ ðöéš ñöţ ðö ·······⟧';

  @override
  String get explainerDoesNot1 =>
      '⟦Îţ îš ñöţ á ƒöŕéçášţ öƒ áñ áţţáçķ. Å ĥîĝĥ ļéṽéļ îš á þáţţéŕñ, ñöţ á çéŕţáîñţý, áñð á ļöŵ ļéṽéļ îš ñöţ á þŕöɱîšé. ········································⟧';

  @override
  String get explainerDoesNot2 =>
      '⟦Îţ îš ñöţ á ɱéðîçáļ öþîñîöñ áñð ðöéš ñöţ ŕéþļáçé ýöûŕ çļîñîçîáñ. ·······················⟧';

  @override
  String get explainerDoesNot3 =>
      '⟦Îţ ñéṽéŕ šéñðš ýöûŕ ļöĝ áñýŵĥéŕé. Ţĥé ļéṽéļ îš çöɱþûţéð öñ ţĥîš þĥöñé. ·························⟧';

  @override
  String get riskCardTitle => '⟦Ţöðáý\'š ļéṽéļ ·····⟧';

  @override
  String get riskCardEmpty =>
      '⟦Ñö ļéṽéļ ýéţ. Åðð á çĥéçķ-îñ öŕ ļéţ ţĥé ŵéáţĥéŕ ļöáð. ···················⟧';

  @override
  String get riskScreenTitle => '⟦Ýöûŕ ļéṽéļ ····⟧';

  @override
  String get riskWhyTitle => '⟦Ŵĥý ··⟧';

  @override
  String get riskNoDrivers => '⟦Ñöţĥîñĝ šţáñðš öûţ. ·······⟧';

  @override
  String get riskNextDays => '⟦Ñéẋţ ðáýš ····⟧';

  @override
  String get riskDayToday => '⟦Ţöðáý ··⟧';

  @override
  String get riskDayTomorrow => '⟦Ţöɱöŕŕöŵ ···⟧';

  @override
  String riskLoad(String value) {
    return '⟦Ļöáð $value öƒ 100 ·····⟧';
  }

  @override
  String riskConfidence(String label) {
    return '⟦Çöñƒîðéñçé: $label ·····⟧';
  }

  @override
  String get riskConfidenceLow => '⟦ļöŵ ··⟧';

  @override
  String get riskConfidenceMedium => '⟦ɱéðîûɱ ···⟧';

  @override
  String get riskConfidenceHigh => '⟦ĥîĝĥ ··⟧';

  @override
  String riskStillLearning(int count, int needed) {
    return '⟦Šţîļļ ļéáŕñîñĝ: $count öƒ $needed áţţáçķš ļöĝĝéð ·············⟧';
  }

  @override
  String get riskTuned => '⟦Ţûñéð ţö ýöûŕ ļöĝ ······⟧';

  @override
  String riskDriverPoints(String points) {
    return '⟦$points þöîñţš ···⟧';
  }

  @override
  String riskUpdated(String time) {
    return '⟦Ûþðáţéð $time ···⟧';
  }

  @override
  String get riskExplainerLink => '⟦Ŵĥáţ ţĥé ļéṽéļ ɱéáñš ·······⟧';

  @override
  String get riskOpenCheckin => '⟦Åðð ţöðáý\'š çĥéçķ-îñ ·······⟧';

  @override
  String get riskFactorPressureDrop => '⟦Ƒáļļîñĝ áîŕ þŕéššûŕé ·······⟧';

  @override
  String get riskFactorHumidity => '⟦Ĥîĝĥ ĥûɱîðîţý ·····⟧';

  @override
  String get riskFactorTemperatureSwing => '⟦Ţéɱþéŕáţûŕé çĥáñĝé ·······⟧';

  @override
  String get riskFactorAirQuality => '⟦Åîŕ ǫûáļîţý ····⟧';

  @override
  String get riskFactorPollen => '⟦Þöļļéñ ···⟧';

  @override
  String get riskFactorBrightLight => '⟦Ɓŕîĝĥţ ļîĝĥţ ·····⟧';

  @override
  String get riskFactorScreenTime => '⟦Šçŕééñ ţîɱé ····⟧';

  @override
  String get riskFactorPoorSleep => '⟦Þööŕ šļééþ ····⟧';

  @override
  String get riskFactorStress => '⟦Šţŕéšš ···⟧';

  @override
  String get riskFactorNeckTension => '⟦Ñéçķ ţéñšîöñ ·····⟧';

  @override
  String get riskFactorCaffeine => '⟦Çáƒƒéîñé ···⟧';

  @override
  String get riskFactorAlcohol => '⟦Åļçöĥöļ ···⟧';

  @override
  String get riskFactorDehydration => '⟦Ļöŵ ĥýðŕáţîöñ ·····⟧';

  @override
  String get riskFactorCyclePhase => '⟦Çýçļé þĥášé ····⟧';

  @override
  String get loadMeterTitle => '⟦Ļöáð ··⟧';

  @override
  String loadMeterSemantics(String value, String segments) {
    return '⟦Ļöáð $value öƒ 100. $segments ·····⟧';
  }

  @override
  String loadSegmentDetail(String name, String points) {
    return '⟦$name: $points þöîñţš ····⟧';
  }

  @override
  String loadThresholdModerate(String value) {
    return '⟦Ṁöðéŕáţé ƒŕöɱ $value ·····⟧';
  }

  @override
  String loadThresholdHigh(String value) {
    return '⟦Ĥîĝĥ ƒŕöɱ $value ····⟧';
  }

  @override
  String get loadMeterEmpty => '⟦Ñö ļöáð ýéţ ····⟧';

  @override
  String get insightsTitle => '⟦Ýöûŕ ƒáçţöŕš ·····⟧';

  @override
  String get insightsIntro =>
      '⟦Ĥöŵ öƒţéñ áñ áţţáçķ ƒöļļöŵéð éáçĥ ƒáçţöŕ îñ ýöûŕ öŵñ ļöĝ, çöɱþáŕéð ŵîţĥ ýöûŕ ûšûáļ ŕáţé. ·······························⟧';

  @override
  String get insightsTriggers => '⟦Ṁöŕé áţţáçķš ƒöļļöŵéð ········⟧';

  @override
  String get insightsProtectors => '⟦Ƒéŵéŕ áţţáçķš ƒöļļöŵéð ········⟧';

  @override
  String get insightsNeutral => '⟦Ñö çļéáŕ éƒƒéçţ ······⟧';

  @override
  String get insightsNotEnough => '⟦Ñöţ éñöûĝĥ ðáţá ýéţ ·······⟧';

  @override
  String get insightsEmptyBucket => '⟦Ñöţĥîñĝ ĥéŕé ýéţ. ······⟧';

  @override
  String insightsSample(int days, int attacks) {
    return '⟦$days éẋþöšûŕé ðáýš, $attacks ƒöļļöŵéð ƀý áñ áţţáçķ ··············⟧';
  }

  @override
  String insightsLift(String ratio) {
    return '⟦$ratio× ýöûŕ ûšûáļ ŕáţé ······⟧';
  }

  @override
  String insightsNeedMore(int days, int needed) {
    return '⟦$days öƒ $needed éẋþöšûŕé ðáýš ļöĝĝéð ·········⟧';
  }

  @override
  String get insightsNoRunYet =>
      '⟦Ļöĝ áñð éñð áñ áţţáçķ ţö šţáŕţ çöûñţîñĝ. ··············⟧';

  @override
  String get insightsMethodLink => '⟦Ĥöŵ ţĥîš îš çöûñţéð ·······⟧';

  @override
  String get insightsMethodTitle => '⟦Ĥöŵ ţĥîš îš çöûñţéð ·······⟧';

  @override
  String insightsMethod1(String pressure) {
    return '⟦Åñ éẋþöšûŕé ðáý îš á ðáý ŵĥéŕé á ƒáçţöŕ ŵáš þŕéšéñţ îñ ýöûŕ ļöĝ öŕ îñ ţĥé ŵéáţĥéŕ, ƒöŕ éẋáɱþļé á šļééþ áñšŵéŕ öƒ 1 öŕ á þŕéššûŕé ðŕöþ öƒ ɱöŕé ţĥáñ $pressure. ········································⟧';
  }

  @override
  String get insightsMethod2 =>
      '⟦Åñ áţţáçķ çöûñţš áš ƒöļļöŵîñĝ á ðáý ŵĥéñ îţ šţáŕţéð öñ ţĥáţ ðáý öŕ ţĥé ñéẋţ, ţĥé 24 ţö 48 ĥöûŕš ţĥé ɱöðéļ ļööķš áţ. ········································⟧';

  @override
  String get insightsMethod3 =>
      '⟦Ţĥé ŕáţîö çöɱþáŕéš ĥöŵ öƒţéñ áţţáçķš ƒöļļöŵéð ţĥáţ ƒáçţöŕ\'š ðáýš ŵîţĥ ĥöŵ öƒţéñ ţĥéý ƒöļļöŵéð áñý ðáý îñ ýöûŕ ļöĝ. 1.5× ɱéáñš öñé áñð á ĥáļƒ ţîɱéš ýöûŕ ûšûáļ ŕáţé; 0.5× ɱéáñš ĥáļƒ. ········································⟧';

  @override
  String insightsMethod4(int needed) {
    return '⟦Å ƒáçţöŕ ñééðš $needed éẋþöšûŕé ðáýš ƀéƒöŕé îţ îš šöŕţéð. Ûñţîļ ţĥéñ îţ šîţš ûñðéŕ \"Ñöţ éñöûĝĥ ðáţá ýéţ\". Ƒéŵéŕ áţţáçķš ƒöļļöŵîñĝ á ƒáçţöŕ îš áš ûšéƒûļ ţö ķñöŵ áš ɱöŕé, šö ƀöţĥ ļîšţš ĝéţ ţĥé šáɱé þļáçé. ········································⟧';
  }

  @override
  String get insightsMethod5 =>
      '⟦Ñöñé öƒ ţĥîš îš á çáûšé. Å ƒáçţöŕ çáñ šîţ îñ á ļîšţ ƀéçáûšé öƒ šöɱéţĥîñĝ îţ ţŕáṽéļš ŵîţĥ, šûçĥ áš ŵééķéñðš öŕ á ɱéðîçáţîöñ çĥáñĝé. Ûšé ţĥé ļîšţš ţö ðéçîðé ŵĥáţ ţö ţŕý, ñöţ ŵĥáţ ţö ƀļáɱé. ········································⟧';

  @override
  String get riskInsightsLink => '⟦Ýöûŕ ƒáçţöŕš ·····⟧';

  @override
  String get settingsInsightsHint =>
      '⟦Ŵĥîçĥ ƒáçţöŕš áţţáçķš ƒöļļöŵéð îñ ýöûŕ ļöĝ ···············⟧';

  @override
  String get notificationsTitle => '⟦Ñöţîƒîçáţîöñš ·····⟧';

  @override
  String get settingsNotificationsHint =>
      '⟦Ļéṽéļ áļéŕţš, þŕéššûŕé ðŕöþš, ŕéɱîñðéŕš ··············⟧';

  @override
  String get notificationsIntro =>
      '⟦Éṽéŕýţĥîñĝ îš šçĥéðûļéð öñ ţĥîš þĥöñé ƒŕöɱ ţĥé šáṽéð ƒöŕéçášţ áñð ýöûŕ ļöĝ. Šŵîţçĥ öƒƒ áñý ţýþé ýöû ðö ñöţ ŵáñţ. ········································⟧';

  @override
  String get notificationsPermissionDenied =>
      '⟦Ñöţîƒîçáţîöñš áŕé öƒƒ ƒöŕ ţĥîš áþþ îñ ţĥé šýšţéɱ šéţţîñĝš. ·····················⟧';

  @override
  String get notifTypeRiskRising => '⟦Ļéṽéļ ŕîšîñĝ ·····⟧';

  @override
  String get notifTypeRiskRisingHint =>
      '⟦Ţĥé éṽéñîñĝ ƀéƒöŕé áñð ţĥé ɱöŕñîñĝ öƒ á ĥîĝĥéŕ ðáý ··················⟧';

  @override
  String get notifTypePressureDrop => '⟦Þŕéššûŕé ðŕöþ ·····⟧';

  @override
  String notifTypePressureDropHint(String pressure) {
    return '⟦Ŵĥéñ ţĥé ƒöŕéçášţ šĥöŵš á ƒáļļ öƒ $pressure öŕ ɱöŕé îñ 24 ĥöûŕš ···················⟧';
  }

  @override
  String get notifTypeAttackOver => '⟦Îš ýöûŕ áţţáçķ öṽéŕ? ·······⟧';

  @override
  String get notifTypeAttackOverHint =>
      '⟦Åţ ýöûŕ ţýþîçáļ áţţáçķ ļéñĝţĥ, ŵîţĥ áñ Éñð ƀûţţöñ ··················⟧';

  @override
  String get notifTypeCheckin => '⟦Çĥéçķ-îñ ŕéɱîñðéŕ ······⟧';

  @override
  String get notifTypeCheckinHint => '⟦Åţ ţĥé ţîɱé šéţ ûñðéŕ Ðáîļý ··········⟧';

  @override
  String get notifTypeMedication => '⟦Þŕéṽéñţîṽé ŕéɱîñðéŕ ·······⟧';

  @override
  String get notifTypeMedicationHint =>
      '⟦Å ðáîļý ñûðĝé ƒöŕ á þŕéṽéñţîṽé ðöšé ·············⟧';

  @override
  String notifPressureThreshold(String pressure) {
    return '⟦Þŕéššûŕé ðŕöþ ţĥŕéšĥöļð: $pressure îñ 24 ĥ ············⟧';
  }

  @override
  String get notifMedicationTime => '⟦Þŕéṽéñţîṽé ŕéɱîñðéŕ ţîɱé ·········⟧';

  @override
  String notifRiskEveningTitle(String level) {
    return '⟦Ţöɱöŕŕöŵ\'š ļéṽéļ: $level ·······⟧';
  }

  @override
  String notifRiskEveningBody(String level, String driver) {
    return '⟦Ýöûŕ ļéṽéļ ƒöŕ ţöɱöŕŕöŵ îš $level. Ţöþ öƒ ţĥé ļîšţ: $driver. ·················⟧';
  }

  @override
  String notifRiskMorningTitle(String level) {
    return '⟦Ţöðáý\'š ļéṽéļ: $level ······⟧';
  }

  @override
  String notifRiskMorningBody(String level, String driver) {
    return '⟦Ýöûŕ ļéṽéļ ţöðáý îš $level. Ţöþ öƒ ţĥé ļîšţ: $driver. ··············⟧';
  }

  @override
  String get notifPressureTitle => '⟦Åîŕ þŕéššûŕé îš ðŕöþþîñĝ ·········⟧';

  @override
  String notifPressureBody(String pressure, String time) {
    return '⟦Å ƒáļļ öƒ $pressure îš éẋþéçţéð ƀý $time. ··········⟧';
  }

  @override
  String get notifAttackOverTitle => '⟦Îš ýöûŕ áţţáçķ öṽéŕ? ·······⟧';

  @override
  String notifAttackOverBody(String duration) {
    return '⟦Îţ šţáŕţéð $duration áĝö. Éñð îţ ĥéŕé ŵĥéñ îţ ĥáš þáššéð. ·················⟧';
  }

  @override
  String get notifEndAttackAction => '⟦Éñð áţţáçķ ····⟧';

  @override
  String get notifCheckinTitle => '⟦Ţĥŕéé ţáþš ƒöŕ ţöðáý ·······⟧';

  @override
  String get notifCheckinBody =>
      '⟦Šļééþ, šţŕéšš áñð ñéçķ ţéñšîöñ. Ƒîƒţééñ šéçöñðš. ·················⟧';

  @override
  String get notifMedicationTitle => '⟦Þŕéṽéñţîṽé ðöšé ······⟧';

  @override
  String get notifMedicationBody =>
      '⟦Ţîɱé ƒöŕ ţöðáý\'š þŕéṽéñţîṽé ɱéðîçáţîöñ, îƒ ýöû ţáķé öñé. ····················⟧';

  @override
  String get notifChannelAlerts => '⟦Åļéŕţš ···⟧';

  @override
  String get notifChannelAlertsDescription =>
      '⟦Ļéṽéļ áñð þŕéššûŕé áļéŕţš ƒŕöɱ ţĥé šáṽéð ƒöŕéçášţ ··················⟧';

  @override
  String get notifChannelReminders => '⟦Ŕéɱîñðéŕš ····⟧';

  @override
  String get notifChannelRemindersDescription =>
      '⟦Çĥéçķ-îñ áñð þŕéṽéñţîṽé ðöšé ŕéɱîñðéŕš ··············⟧';

  @override
  String get notifChannelAttack => '⟦Åţţáçķ ···⟧';

  @override
  String get notifChannelAttackDescription =>
      '⟦Ǫûéšţîöñš áƀöûţ á ŕûññîñĝ áţţáçķ ············⟧';

  @override
  String get reportTitle => '⟦Ðöçţöŕ ŕéþöŕţ ·····⟧';

  @override
  String get settingsReportHint =>
      '⟦ÞÐƑ áñð šþŕéáðšĥééţ ƒöŕ á ðáţé ŕáñĝé ·············⟧';

  @override
  String get reportIntro =>
      '⟦Å šûɱɱáŕý öƒ ŵĥáţ ýöû ļöĝĝéð, ƒöŕ ýöûŕ ñéẋţ áþþöîñţɱéñţ. Þîçķ á þéŕîöð, ţĥéñ šĥáŕé ţĥé ÞÐƑ öŕ ţĥé šþŕéáðšĥééţš. ·······································⟧';

  @override
  String get reportRangeLabel => '⟦Þéŕîöð ···⟧';

  @override
  String reportRangeDays(int days) {
    return '⟦$days ðáýš ··⟧';
  }

  @override
  String get reportRangeCustom => '⟦Çûšţöɱ ···⟧';

  @override
  String reportRangeText(String from, String to) {
    return '⟦$from ţö $to ··⟧';
  }

  @override
  String reportPreviewAttacks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count áţţáçķš',
      one: '1 áţţáçķ',
      zero: 'Ñö áţţáçķš',
    );
    return '⟦$_temp0 ··············⟧';
  }

  @override
  String reportPreviewAttackDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count áţţáçķ ðáýš',
      one: '1 áţţáçķ ðáý',
      zero: 'ñö áţţáçķ ðáýš',
    );
    return '⟦$_temp0 ···············⟧';
  }

  @override
  String reportPreviewDoses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ðöšéš',
      one: '1 ðöšé',
      zero: 'ñö ðöšéš',
    );
    return '⟦$_temp0 ·············⟧';
  }

  @override
  String reportPreviewCheckins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count çĥéçķ-îñš',
      one: '1 çĥéçķ-îñ',
      zero: 'ñö çĥéçķ-îñš',
    );
    return '⟦$_temp0 ··············⟧';
  }

  @override
  String get reportEmpty => '⟦Ñöţĥîñĝ ļöĝĝéð îñ ţĥîš þéŕîöð ýéţ. ············⟧';

  @override
  String get reportSharePdf => '⟦Šĥáŕé ÞÐƑ ····⟧';

  @override
  String get reportShareCsv => '⟦Šĥáŕé šþŕéáðšĥééţš ·······⟧';

  @override
  String get reportShareAll => '⟦Šĥáŕé éṽéŕýţĥîñĝ ······⟧';

  @override
  String get reportBuilding => '⟦Þŕéþáŕîñĝ ţĥé ŕéþöŕţ ·······⟧';

  @override
  String get reportFailed =>
      '⟦Ţĥé ŕéþöŕţ çöûļð ñöţ ƀé þŕéþáŕéð. Ţŕý áĝáîñ. ················⟧';

  @override
  String get reportWhatIsIn => '⟦Ŵĥáţ ţĥé ÞÐƑ çöñţáîñš ········⟧';

  @override
  String get reportContents =>
      '⟦Åţţáçķ çáļéñðáŕ, ɱöñţĥļý çöûñţš, ðûŕáţîöñ, ƒáçţöŕš ŵîţĥ ţĥéîŕ šáɱþļé šîžéš, ɱéðîçáţîöñ ðáýš, þŕéššûŕé çĥáñĝéš, šýɱþţöɱš áñð ĥéáð ļöçáţîöñš. Ñö ñáɱéš, ñö ñöţéš. ········································⟧';

  @override
  String reportPdfTitle(String app) {
    return '⟦$app ŕéþöŕţ ···⟧';
  }

  @override
  String reportPdfPeriod(String from, String to, int days) {
    return '⟦Þéŕîöð: $from ţö $to ($days ðáýš) ·······⟧';
  }

  @override
  String reportPdfGenerated(String date) {
    return '⟦Ĝéñéŕáţéð $date öñ ţĥé þéŕšöñ\'š ðéṽîçé ƒŕöɱ ţĥéîŕ öŵñ ļöĝ. ···················⟧';
  }

  @override
  String get reportPdfDisclaimer =>
      '⟦Ţĥîš îš á šéļƒ-ŕéþöŕţéð ðîáŕý šûɱɱáŕý ƒŕöɱ á ŵéļļñéšš áþþ. Îţ îš ñöţ á ɱéðîçáļ ŕéçöŕð áñð ðöéš ñöţ ŕéþļáçé á çļîñîçáļ áššéššɱéñţ. Ƒáçţöŕ ŕáţîöš ðéšçŕîƀé ţĥîš þéŕšöñ\'š ļöĝ öñļý áñð áŕé ñöţ çáûšéš. ········································⟧';

  @override
  String reportPdfPage(int page, int pages) {
    return '⟦Þáĝé $page öƒ $pages ····⟧';
  }

  @override
  String get reportSectionOverview => '⟦Öṽéŕṽîéŵ ···⟧';

  @override
  String get reportStatAttacks => '⟦Åţţáçķš ···⟧';

  @override
  String get reportStatAttackDays => '⟦Åţţáçķ ðáýš ····⟧';

  @override
  String get reportStatPerMonth => '⟦Åţţáçķš þéŕ 30 ðáýš ·······⟧';

  @override
  String get reportStatMeanIntensity => '⟦Ṁéáñ îñţéñšîţý (0-10) ········⟧';

  @override
  String get reportStatAcuteDays => '⟦Ðáýš ŵîţĥ áçûţé ɱéðîçáţîöñ ··········⟧';

  @override
  String get reportStatCheckins => '⟦Ðáýš ŵîţĥ á çĥéçķ-îñ ·······⟧';

  @override
  String get reportSectionMonths => '⟦Ɓý ɱöñţĥ ···⟧';

  @override
  String get reportColMonth => '⟦Ṁöñţĥ ··⟧';

  @override
  String get reportColAttacks => '⟦Åţţáçķš ···⟧';

  @override
  String get reportColAttackDays => '⟦Åţţáçķ ðáýš ····⟧';

  @override
  String get reportColMeanIntensity => '⟦Ṁéáñ îñţéñšîţý ·····⟧';

  @override
  String get reportColAcuteDays => '⟦Åçûţé ðáýš ····⟧';

  @override
  String get reportColNote => '⟦Ñöţé ··⟧';

  @override
  String get reportOveruseWatch => '⟦10+ áçûţé ðáýš ·····⟧';

  @override
  String get reportOveruseHigh => '⟦15+ áçûţé ðáýš ·····⟧';

  @override
  String get reportSectionCalendar => '⟦Åţţáçķ çáļéñðáŕ ······⟧';

  @override
  String get reportCalendarHint =>
      '⟦Öñé çéļļ þéŕ ðáý. Šĥáðéð çéļļš ĥáð áñ áţţáçķ; ţĥé ñûɱƀéŕ îš ţĥé ĥîĝĥéšţ îñţéñšîţý ţĥáţ ðáý. ································⟧';

  @override
  String get reportSectionDuration => '⟦Åţţáçķ ðûŕáţîöñ ······⟧';

  @override
  String get reportDurationNone =>
      '⟦Ñö éñðéð áţţáçķš îñ ţĥîš þéŕîöð. ············⟧';

  @override
  String reportDurationSummary(
    int count,
    String shortest,
    String median,
    String longest,
  ) {
    return '⟦$count éñðéð áţţáçķš. Šĥöŕţéšţ $shortest, ɱéðîáñ $median, ļöñĝéšţ $longest. ················⟧';
  }

  @override
  String get reportBucketUnderFour => '⟦Ûñðéŕ 4 ĥ ····⟧';

  @override
  String get reportBucketFourToTwelve => '⟦4 ţö 12 ĥ ····⟧';

  @override
  String get reportBucketTwelveToDay => '⟦12 ţö 24 ĥ ····⟧';

  @override
  String get reportBucketOneToThreeDays => '⟦1 ţö 3 ðáýš ····⟧';

  @override
  String get reportBucketOverThreeDays => '⟦Öṽéŕ 3 ðáýš ····⟧';

  @override
  String get reportSectionTriggers =>
      '⟦Ƒáçţöŕš îñ ţĥé þéŕšöñ\'š ļöĝ ··········⟧';

  @override
  String reportTriggersHint(int floor) {
    return '⟦Ŕáţîö öƒ áţţáçķš áƒţéŕ ðáýš ŵîţĥ ţĥé ƒáçţöŕ ţö ţĥé þéŕšöñ\'š ûšûáļ ŕáţé, ŵîţĥ ţĥé ñûɱƀéŕ öƒ éẋþöšûŕé ðáýš ƀéĥîñð îţ. Ɓéļöŵ $floor éẋþöšûŕé ðáýš ţĥé ŕáţîö îš ñöţ šĥöŵñ. ········································⟧';
  }

  @override
  String get reportTriggersNone =>
      '⟦Ñöţ éñöûĝĥ ļöĝĝéð ðáýš ýéţ ţö çöɱþáŕé ƒáçţöŕš. ·················⟧';

  @override
  String get reportColFactor => '⟦Ƒáçţöŕ ···⟧';

  @override
  String get reportColRatio => '⟦Ŕáţîö ··⟧';

  @override
  String get reportColExposures => '⟦Éẋþöšûŕé ðáýš ·····⟧';

  @override
  String get reportColFollowed => '⟦Ƒöļļöŵéð ƀý áţţáçķ ·······⟧';

  @override
  String get reportColConfidence => '⟦Éṽîðéñçé ···⟧';

  @override
  String get reportConfidenceLow => '⟦ļöŵ ··⟧';

  @override
  String get reportConfidenceMedium => '⟦ɱöðéŕáţé ···⟧';

  @override
  String get reportConfidenceHigh => '⟦ĝööð ··⟧';

  @override
  String get reportSectionMedications => '⟦Ṁéðîçáţîöñ ····⟧';

  @override
  String get reportMedicationsNone =>
      '⟦Ñö ðöšéš ļöĝĝéð îñ ţĥîš þéŕîöð. ···········⟧';

  @override
  String get reportColMedication => '⟦Ṁéðîçáţîöñ ····⟧';

  @override
  String get reportColKind => '⟦Ţýþé ··⟧';

  @override
  String get reportColDoses => '⟦Ðöšéš ··⟧';

  @override
  String get reportColDays => '⟦Ðáýš ··⟧';

  @override
  String get reportColRelief =>
      '⟦Ŕéļîéƒ áţ 2 ĥ (ñöñé / þáŕţîáļ / ƒûļļ) ·············⟧';

  @override
  String get reportKindAcute => '⟦áçûţé ··⟧';

  @override
  String get reportKindPreventive => '⟦þŕéṽéñţîṽé ····⟧';

  @override
  String get reportSectionWeather => '⟦Åîŕ þŕéššûŕé ·····⟧';

  @override
  String reportWeatherHint(String pressure) {
    return '⟦Å ƒáļļ îš á ðŕöþ öƒ $pressure öŕ ɱöŕé öṽéŕ 24 ĥ áţ ţĥé ţîɱé öƒ ţĥé éñţŕý. ·······················⟧';
  }

  @override
  String get reportWeatherNone =>
      '⟦Ñö ŵéáţĥéŕ šñáþšĥöţš îñ ţĥîš þéŕîöð. ·············⟧';

  @override
  String reportWeatherAttacks(int fall, int total) {
    return '⟦$fall öƒ $total áţţáçķš ƀéĝáñ áƒţéŕ á þŕéššûŕé ƒáļļ. ···············⟧';
  }

  @override
  String reportWeatherDays(int fall, int total) {
    return '⟦$fall öƒ $total çĥéçķ-îñ ðáýš ĥáð öñé. ··········⟧';
  }

  @override
  String reportWeatherLift(String lift) {
    return '⟦Ŕáţîö: $liftẋ (1.0 ɱéáñš ñö ŕéļáţîöñ). ············⟧';
  }

  @override
  String get reportSectionSymptoms =>
      '⟦Šýɱþţöɱš áñð ĥéáð ļöçáţîöñš ··········⟧';

  @override
  String get reportSymptomsNone =>
      '⟦Ñö šýɱþţöɱš öŕ ļöçáţîöñš ļöĝĝéð. ············⟧';

  @override
  String reportCountOfAttacks(String name, int count, int total) {
    return '⟦$name: $count öƒ $total áţţáçķš ·····⟧';
  }

  @override
  String reportHoursShort(String hours) {
    return '⟦$hours ĥ ·⟧';
  }

  @override
  String get notifTypeQuestionnaire =>
      '⟦Ţĥŕéé-ɱöñţĥ ǫûéšţîöññáîŕéš ··········⟧';

  @override
  String get notifTypeQuestionnaireHint =>
      '⟦ṀÎÐÅŠ áñð ĤÎŢ-6, ţĥŕéé ɱöñţĥš áƒţéŕ ţĥé ļášţ ŕöûñð ··················⟧';

  @override
  String get notifQuestionnaireTitle =>
      '⟦Ţĥŕéé ɱöñţĥš šîñçé ýöûŕ ļášţ ǫûéšţîöññáîŕéš ················⟧';

  @override
  String get notifQuestionnaireBody =>
      '⟦Ƒîļļ îñ ṀÎÐÅŠ áñð ĤÎŢ-6 áĝáîñ ţö šéé ĥöŵ ţĥé ļášţ ǫûáŕţéŕ çöɱþáŕéš. ························⟧';

  @override
  String get questionnairesTitle => '⟦Ǫûéšţîöññáîŕéš ·····⟧';

  @override
  String get settingsQuestionnairesHint =>
      '⟦ṀÎÐÅŠ áñð ĤÎŢ-6, šçöŕéð áñð çĥáŕţéð ·············⟧';

  @override
  String get questionnairesIntro =>
      '⟦Ţŵö šĥöŕţ, ṽáļîðáţéð ǫûéšţîöññáîŕéš áƀöûţ ţĥé ļášţ ţĥŕéé ɱöñţĥš. Ŕéþéáţ ţĥéɱ éṽéŕý ǫûáŕţéŕ áñð ţĥé šçöŕéš áŕé çĥáŕţéð ĥéŕé áñð çáñ ĝö îñţö ţĥé ðöçţöŕ ŕéþöŕţ. ········································⟧';

  @override
  String get questionnaireMidasTitle => '⟦ṀÎÐÅŠ ··⟧';

  @override
  String get questionnaireMidasSubtitle =>
      '⟦Ṁîĝŕáîñé Ðîšáƀîļîţý Åššéššɱéñţ: ƒîṽé ðáý çöûñţš öṽéŕ ţĥé ļášţ ţĥŕéé ɱöñţĥš ··························⟧';

  @override
  String get questionnaireHit6Title => '⟦ĤÎŢ-6 ··⟧';

  @override
  String get questionnaireHit6Subtitle =>
      '⟦Ĥéáðáçĥé Îɱþáçţ Ţéšţ: šîẋ ǫûéšţîöñš öñ ĥöŵ ĥéáðáçĥéš áƒƒéçţ ýöûŕ ļîƒé ·························⟧';

  @override
  String get questionnaireNeverDone => '⟦Ñöţ ƒîļļéð îñ ýéţ ······⟧';

  @override
  String questionnaireLatest(int score, String date) {
    return '⟦Ļášţ šçöŕé $score öñ $date ······⟧';
  }

  @override
  String get questionnaireDueNow => '⟦Ðûé ñöŵ ···⟧';

  @override
  String questionnaireDueOn(String date) {
    return '⟦Ñéẋţ ŕöûñð $date ····⟧';
  }

  @override
  String get questionnaireStart => '⟦Ƒîļļ îñ ···⟧';

  @override
  String get questionnaireRepeat => '⟦Ƒîļļ îñ áĝáîñ ·····⟧';

  @override
  String get questionnaireHistory => '⟦Šçöŕé ĥîšţöŕý ·····⟧';

  @override
  String questionnaireChartLabel(
    int count,
    String first,
    String last,
    int latest,
  ) {
    return '⟦$count šçöŕéš ƒŕöɱ $first ţö $last, ļáţéšţ $latest ··········⟧';
  }

  @override
  String get questionnaireAbout => '⟦Åƀöûţ ţĥé šçöŕéš ······⟧';

  @override
  String get questionnaireAboutBody =>
      '⟦ṀÎÐÅŠ áððš ûþ ƒîṽé ðáý çöûñţš: 0 ţö 5 îš ĝŕáðé Î (ļîţţļé öŕ ñö ðîšáƀîļîţý), 6 ţö 10 ĝŕáðé ÎÎ (ɱîļð), 11 ţö 20 ĝŕáðé ÎÎÎ (ɱöðéŕáţé), 21 áñð öṽéŕ ĝŕáðé ÎṼ (šéṽéŕé). ĤÎŢ-6 ĝîṽéš 6, 8, 10, 11 öŕ 13 þöîñţš þéŕ áñšŵéŕ, 36 ţö 78 îñ áļļ: ûþ ţö 49 îš ļîţţļé öŕ ñö îɱþáçţ, 50 ţö 55 šöɱé îɱþáçţ, 56 ţö 59 šûƀšţáñţîáļ îɱþáçţ, 60 áñð öṽéŕ šéṽéŕé îɱþáçţ. Ţĥé ƀáñðš áŕé ţĥé þûƀļîšĥéð öñéš; ţĥé šçöŕéš áŕé ƒöŕ ýöû áñð ýöûŕ çļîñîçîáñ ţö ðîšçûšš. ········································⟧';

  @override
  String get questionnaireMidasIntro =>
      '⟦Ţĥîñķ áƀöûţ ţĥé ļášţ ţĥŕéé ɱöñţĥš. Çöûñţ ðáýš; á ðáý çöûñţš öñçé þéŕ ǫûéšţîöñ. ····························⟧';

  @override
  String get questionnaireMidasQ1 =>
      '⟦Öñ ĥöŵ ɱáñý ðáýš ðîð ýöû ɱîšš ŵöŕķ öŕ šçĥööļ ƀéçáûšé öƒ ýöûŕ ĥéáðáçĥéš? ·························⟧';

  @override
  String get questionnaireMidasQ2 =>
      '⟦Öñ ĥöŵ ɱáñý ðáýš ŵáš ýöûŕ þŕöðûçţîṽîţý áţ ŵöŕķ öŕ šçĥööļ ŕéðûçéð ƀý ĥáļƒ öŕ ɱöŕé ƀéçáûšé öƒ ýöûŕ ĥéáðáçĥéš? (Ðö ñöţ çöûñţ ðáýš ýöû ɱîššéð.) ········································⟧';

  @override
  String get questionnaireMidasQ3 =>
      '⟦Öñ ĥöŵ ɱáñý ðáýš ðîð ýöû ñöţ ðö ĥöûšéĥöļð ŵöŕķ ƀéçáûšé öƒ ýöûŕ ĥéáðáçĥéš? ··························⟧';

  @override
  String get questionnaireMidasQ4 =>
      '⟦Öñ ĥöŵ ɱáñý ðáýš ŵáš ýöûŕ þŕöðûçţîṽîţý îñ ĥöûšéĥöļð ŵöŕķ ŕéðûçéð ƀý ĥáļƒ öŕ ɱöŕé ƀéçáûšé öƒ ýöûŕ ĥéáðáçĥéš? (Ðö ñöţ çöûñţ ðáýš ýöû ðîð ñöñé.) ········································⟧';

  @override
  String get questionnaireMidasQ5 =>
      '⟦Öñ ĥöŵ ɱáñý ðáýš ðîð ýöû ɱîšš ƒáɱîļý, šöçîáļ öŕ ļéîšûŕé áçţîṽîţîéš ƀéçáûšé öƒ ýöûŕ ĥéáðáçĥéš? ·································⟧';

  @override
  String get questionnaireMidasA =>
      '⟦Öñ ĥöŵ ɱáñý ðáýš ðîð ýöû ĥáṽé á ĥéáðáçĥé? (Îƒ á ĥéáðáçĥé ļášţéð ɱöŕé ţĥáñ öñé ðáý, çöûñţ éáçĥ ðáý.) ···································⟧';

  @override
  String get questionnaireMidasB =>
      '⟦Öñ á šçáļé öƒ 0 ţö 10, öñ áṽéŕáĝé ĥöŵ þáîñƒûļ ŵéŕé ţĥéšé ĥéáðáçĥéš? (0 = ñö þáîñ, 10 = þáîñ áš ƀáð áš îţ çáñ ƀé) ········································⟧';

  @override
  String get questionnaireMidasUnscored => '⟦Ñöţ þáŕţ öƒ ţĥé šçöŕé ········⟧';

  @override
  String get questionnaireDaysField => '⟦Ðáýš (0 ţö 90) ·····⟧';

  @override
  String get questionnairePainField => '⟦Þáîñ (0 ţö 10) ·····⟧';

  @override
  String questionnaireDaysError(int max) {
    return '⟦Éñţéŕ á ñûɱƀéŕ ƒŕöɱ 0 ţö $max ·········⟧';
  }

  @override
  String get questionnaireHit6Intro =>
      '⟦Ţĥîñķ áƀöûţ ţĥé ļášţ ƒöûŕ ŵééķš áñð þîçķ ţĥé áñšŵéŕ ţĥáţ ƒîţš ƀéšţ ƒöŕ éáçĥ ǫûéšţîöñ. ······························⟧';

  @override
  String get questionnaireHit6Q1 =>
      '⟦Ŵĥéñ ýöû ĥáṽé ĥéáðáçĥéš, ĥöŵ öƒţéñ îš ţĥé þáîñ šéṽéŕé? ···················⟧';

  @override
  String get questionnaireHit6Q2 =>
      '⟦Ĥöŵ öƒţéñ ðö ĥéáðáçĥéš ļîɱîţ ýöûŕ áƀîļîţý ţö ðö ûšûáļ ðáîļý áçţîṽîţîéš, îñçļûðîñĝ ĥöûšéĥöļð ŵöŕķ, ŵöŕķ, šçĥööļ öŕ šöçîáļ áçţîṽîţîéš? ········································⟧';

  @override
  String get questionnaireHit6Q3 =>
      '⟦Ŵĥéñ ýöû ĥáṽé á ĥéáðáçĥé, ĥöŵ öƒţéñ ðö ýöû ŵîšĥ ýöû çöûļð ļîé ðöŵñ? ························⟧';

  @override
  String get questionnaireHit6Q4 =>
      '⟦Îñ ţĥé þášţ ƒöûŕ ŵééķš, ĥöŵ öƒţéñ ĥáṽé ýöû ƒéļţ ţöö ţîŕéð ţö ðö ŵöŕķ öŕ ðáîļý áçţîṽîţîéš ƀéçáûšé öƒ ýöûŕ ĥéáðáçĥéš? ········································⟧';

  @override
  String get questionnaireHit6Q5 =>
      '⟦Îñ ţĥé þášţ ƒöûŕ ŵééķš, ĥöŵ öƒţéñ ĥáṽé ýöû ƒéļţ ƒéð ûþ öŕ îŕŕîţáţéð ƀéçáûšé öƒ ýöûŕ ĥéáðáçĥéš? ·································⟧';

  @override
  String get questionnaireHit6Q6 =>
      '⟦Îñ ţĥé þášţ ƒöûŕ ŵééķš, ĥöŵ öƒţéñ ðîð ĥéáðáçĥéš ļîɱîţ ýöûŕ áƀîļîţý ţö çöñçéñţŕáţé öñ ŵöŕķ öŕ ðáîļý áçţîṽîţîéš? ·······································⟧';

  @override
  String get questionnaireOptionNever => '⟦Ñéṽéŕ ··⟧';

  @override
  String get questionnaireOptionRarely => '⟦Ŕáŕéļý ···⟧';

  @override
  String get questionnaireOptionSometimes => '⟦Šöɱéţîɱéš ····⟧';

  @override
  String get questionnaireOptionVeryOften => '⟦Ṽéŕý öƒţéñ ····⟧';

  @override
  String get questionnaireOptionAlways => '⟦Åļŵáýš ···⟧';

  @override
  String get questionnaireSave => '⟦Šáṽé áñð šçöŕé ·····⟧';

  @override
  String get questionnaireIncomplete =>
      '⟦Åñšŵéŕ éṽéŕý šçöŕéð ǫûéšţîöñ ţö šáṽé. ·············⟧';

  @override
  String questionnaireResultTitle(int score) {
    return '⟦Ýöûŕ šçöŕé: $score ·····⟧';
  }

  @override
  String get questionnaireResultDone => '⟦Ðöñé ··⟧';

  @override
  String get questionnaireResultDisclaimer =>
      '⟦Å šçöŕé ðéšçŕîƀéš ţĥé ļášţ ţĥŕéé ɱöñţĥš áš ýöû ŕéɱéɱƀéŕ ţĥéɱ. Îţ îš á šţáŕţîñĝ þöîñţ ƒöŕ á çöñṽéŕšáţîöñ ŵîţĥ ýöûŕ çļîñîçîáñ, ñöţ á ɱéðîçáļ áššéššɱéñţ. ········································⟧';

  @override
  String get questionnaireMidasBandMinimal =>
      '⟦Ĝŕáðé Î: ļîţţļé öŕ ñö ðîšáƀîļîţý ············⟧';

  @override
  String get questionnaireMidasBandMild =>
      '⟦Ĝŕáðé ÎÎ: ɱîļð ðîšáƀîļîţý ·········⟧';

  @override
  String get questionnaireMidasBandModerate =>
      '⟦Ĝŕáðé ÎÎÎ: ɱöðéŕáţé ðîšáƀîļîţý ···········⟧';

  @override
  String get questionnaireMidasBandSevere =>
      '⟦Ĝŕáðé ÎṼ: šéṽéŕé ðîšáƀîļîţý ··········⟧';

  @override
  String get questionnaireHit6BandMinimal => '⟦Ļîţţļé öŕ ñö îɱþáçţ ·······⟧';

  @override
  String get questionnaireHit6BandMild => '⟦Šöɱé îɱþáçţ ····⟧';

  @override
  String get questionnaireHit6BandModerate => '⟦Šûƀšţáñţîáļ îɱþáçţ ·······⟧';

  @override
  String get questionnaireHit6BandSevere => '⟦Šéṽéŕé îɱþáçţ ·····⟧';

  @override
  String get reportIncludeQuestionnaires =>
      '⟦Îñçļûðé ǫûéšţîöññáîŕé šçöŕéš ··········⟧';

  @override
  String get reportIncludeQuestionnairesHint =>
      '⟦ṀÎÐÅŠ áñð ĤÎŢ-6 ŕöûñðš çöɱþļéţéð îñ ţĥé þéŕîöð ·················⟧';

  @override
  String get reportSectionQuestionnaires => '⟦Ǫûéšţîöññáîŕéš ·····⟧';

  @override
  String get reportQuestionnairesNone =>
      '⟦Ñö ǫûéšţîöññáîŕéš çöɱþļéţéð îñ ţĥîš þéŕîöð. ················⟧';

  @override
  String get reportColDate => '⟦Ðáţé ··⟧';

  @override
  String get reportColQuestionnaire => '⟦Ǫûéšţîöññáîŕé ·····⟧';

  @override
  String get reportColScore => '⟦Šçöŕé ··⟧';

  @override
  String get reportColBand => '⟦Ɓáñð ··⟧';

  @override
  String get voiceButton => '⟦Ļöĝ ƀý ṽöîçé ·····⟧';

  @override
  String get voiceListening => '⟦Ļîšţéñîñĝ ····⟧';

  @override
  String get voiceListeningHint =>
      '⟦Šáý ĥöŵ îţ ƒééļš, ƒöŕ éẋáɱþļé: þáîñ šéṽéñ öûţ öƒ ţéñ, ƀéĥîñð ɱý éýéš, ñáûšéá, ţööķ îƀûþŕöƒéñ. ·································⟧';

  @override
  String get voiceStop => '⟦Ðöñé ţáļķîñĝ ·····⟧';

  @override
  String get voiceCancel => '⟦Çáñçéļ ···⟧';

  @override
  String get voiceTryAgain => '⟦Ţŕý áĝáîñ ····⟧';

  @override
  String get voiceUnavailable =>
      '⟦Ṽöîçé îš ñöţ áṽáîļáƀļé öñ ţĥîš þĥöñé. Šþééçĥ ŕéçöĝñîţîöñ ñééðš ɱîçŕöþĥöñé þéŕɱîššîöñ áñð áñ öƒƒļîñé šþééçĥ þáçķ ƒöŕ ýöûŕ ļáñĝûáĝé. ········································⟧';

  @override
  String get voiceNoMatch =>
      '⟦Ñöţĥîñĝ ŵáš ĥéáŕð. Ţŕý áĝáîñ çļöšéŕ ţö ţĥé þĥöñé, öŕ ţáþ ţĥé ƒîéļðš îñšţéáð. ···························⟧';

  @override
  String get voiceReviewTitle => '⟦Çĥéçķ ƀéƒöŕé šáṽîñĝ ·······⟧';

  @override
  String voiceHeard(String text) {
    return '⟦Ĥéáŕð: “$text” ····⟧';
  }

  @override
  String get voiceNothingUnderstood =>
      '⟦Ñöţĥîñĝ öñ ţĥé ƒöŕɱ ɱáţçĥéð ŵĥáţ ŵáš šáîð. Ţáþ ţĥé ƒîéļðš îñšţéáð, öŕ ţŕý áĝáîñ. ····························⟧';

  @override
  String get voiceIntensity => '⟦Îñţéñšîţý ····⟧';

  @override
  String get voiceIntensityNone => '⟦Ñöţ šáîð ···⟧';

  @override
  String get voiceSymptoms => '⟦Šýɱþţöɱš ···⟧';

  @override
  String get voiceLocations => '⟦Ŵĥéŕé îţ ĥûŕţš ·····⟧';

  @override
  String get voiceMedications => '⟦Ṁéðîçáţîöñ ţáķéñ ñöŵ ·······⟧';

  @override
  String get voiceSave => '⟦Šáṽé ţö áţţáçķ ·····⟧';

  @override
  String widgetLevel(String level) {
    return '⟦Ļéṽéļ: $level ···⟧';
  }

  @override
  String get widgetNoLevel =>
      '⟦Öþéñ ţĥé áþþ ţö ļöáð ţöðáý\'š ļéṽéļ ············⟧';

  @override
  String widgetDriver(String factor) {
    return '⟦Ţöþ ƒáçţöŕ: $factor ·····⟧';
  }

  @override
  String get widgetNoDriver => '⟦Ñö šîñĝļé ƒáçţöŕ šţáñðš öûţ ··········⟧';

  @override
  String widgetPressureFalling(String pressure) {
    return '⟦Þŕéššûŕé ƒáļļîñĝ $pressure îñ 24 ĥ ·········⟧';
  }

  @override
  String widgetPressureRising(String pressure) {
    return '⟦Þŕéššûŕé ŕîšîñĝ $pressure îñ 24 ĥ ·········⟧';
  }

  @override
  String get widgetPressureSteady => '⟦Þŕéššûŕé šţéáðý ······⟧';

  @override
  String get widgetPressureUnknown => '⟦Ñö þŕéššûŕé ƒöŕéçášţ ýéţ ·········⟧';

  @override
  String widgetUpdated(String time) {
    return '⟦Ûþðáţéð $time ···⟧';
  }

  @override
  String get widgetStartAttack => '⟦Šţáŕţ áţţáçķ ·····⟧';

  @override
  String get widgetOpenAttack => '⟦Öþéñ áţţáçķ ····⟧';

  @override
  String get watchStart => '⟦Šţáŕţ áţţáçķ ·····⟧';

  @override
  String get watchStop => '⟦Éñð áţţáçķ ····⟧';

  @override
  String get watchIntensity => '⟦Îñţéñšîţý ····⟧';

  @override
  String watchSince(String time) {
    return '⟦Šîñçé $time ···⟧';
  }

  @override
  String get watchPending =>
      '⟦Šáṽéð öñ ţĥé ŵáţçĥ. Šéñðš ŵĥéñ ýöûŕ þĥöñé îš ñéáŕ. ··················⟧';

  @override
  String get watchNoPhone =>
      '⟦Öþéñ ţĥé áþþ öñ ýöûŕ þĥöñé öñçé ţö çöññéçţ ţĥé ŵáţçĥ. ···················⟧';

  @override
  String get routinesTitle => '⟦Šéļƒ-çáŕé ŕöûţîñéš ·······⟧';

  @override
  String get routinesIntro =>
      '⟦Šîɱþļé ţĥîñĝš ɱáñý þéöþļé ƒîñð ĥéļþƒûļ öñ ĥáŕð ðáýš. Ûšé ŵĥáţ šûîţš ýöû áñð šķîþ ţĥé ŕéšţ. ································⟧';

  @override
  String get routineCardTitle => '⟦Šöɱéţĥîñĝ ţĥáţ ɱáý ĥéļþ ţöðáý ···········⟧';

  @override
  String get routineNotToday => '⟦Ñöţ ţöðáý ····⟧';

  @override
  String get routineSeeAll => '⟦Åļļ ŕöûţîñéš ·····⟧';

  @override
  String get routineStepsTitle => '⟦Ĥöŵ ţö ···⟧';

  @override
  String get routineReasonHighDay => '⟦Ţöðáý\'š ļéṽéļ îš ĥîĝĥ ········⟧';

  @override
  String get routineReasonNeckTension =>
      '⟦Ýöûŕ çĥéçķ-îñ šĥöŵš ñéçķ ţéñšîöñ ············⟧';

  @override
  String get routineReasonStress =>
      '⟦Ýöûŕ çĥéçķ-îñ šĥöŵš ĥîĝĥ šţŕéšš ···········⟧';

  @override
  String get routineStretchesTitle =>
      '⟦Ĝéñţļé ñéçķ áñð šĥöûļðéŕ šţŕéţçĥéš ············⟧';

  @override
  String get routineStretchesSummary =>
      '⟦Ƒîṽé šļöŵ ɱöṽéɱéñţš ţö éášé ţîĝĥţñéšš îñ ýöûŕ ñéçķ áñð šĥöûļðéŕš. Šţöþ îƒ áñýţĥîñĝ ĥûŕţš. ································⟧';

  @override
  String get routineStretchesSteps =>
      '⟦Šîţ ţáļļ ŵîţĥ ýöûŕ šĥöûļðéŕš ŕéļáẋéð áñð ýöûŕ ƒééţ ƒļáţ.\nŠļöŵļý ţîļţ ýöûŕ ŕîĝĥţ éáŕ ţöŵáŕðš ýöûŕ ŕîĝĥţ šĥöûļðéŕ. Ĥöļð ƒöŕ 15 šéçöñðš, ţĥéñ šŵîţçĥ šîðéš.\nĻöŵéŕ ýöûŕ çĥîñ ţöŵáŕðš ýöûŕ çĥéšţ áñð ĥöļð ƒöŕ 15 šéçöñðš.\nŔöļļ ýöûŕ šĥöûļðéŕš ƀáçķŵáŕðš ƒîṽé ţîɱéš, ţĥéñ ƒöŕŵáŕðš ƒîṽé ţîɱéš.\nÇļášþ ýöûŕ ĥáñðš ƀéĥîñð ýöûŕ ƀáçķ áñð ĝéñţļý öþéñ ýöûŕ çĥéšţ ƒöŕ 15 šéçöñðš. ········································⟧';

  @override
  String get routineBreathingTitle => '⟦Þáçéð ƀŕéáţĥîñĝ ······⟧';

  @override
  String get routineBreathingSummary =>
      '⟦Ɓŕéáţĥé îñ ƒöŕ 4 šéçöñðš áñð öûţ ƒöŕ 6, ƒöŕ áƀöûţ á ɱîñûţé. Å šļöŵ öûţ-ƀŕéáţĥ ĥéļþš ɱáñý þéöþļé šéţţļé. ·····································⟧';

  @override
  String get routineBreathingSteps =>
      '⟦Šîţ öŕ ļîé ðöŵñ šöɱéŵĥéŕé çöɱƒöŕţáƀļé.\nƁŕéáţĥé îñ ţĥŕöûĝĥ ýöûŕ ñöšé ŵĥîļé ţĥé çîŕçļé ĝŕöŵš.\nƁŕéáţĥé öûţ šļöŵļý ŵĥîļé îţ šĥŕîñķš.\nĶééþ ĝöîñĝ ƒöŕ šîẋ ŕöûñðš, öŕ ƒöŕ áš ļöñĝ áš ƒééļš ĝööð. ········································⟧';

  @override
  String get routineLowLightTitle => '⟦Ļöŵ ļîĝĥţ áñð ǫûîéţ ·······⟧';

  @override
  String get routineLowLightSummary =>
      '⟦Ɓŕîĝĥţ ļîĝĥţ áñð ñöîšé ƀöţĥéŕ ɱáñý þéöþļé öñ šéñšîţîṽé ðáýš áñð ðûŕîñĝ áñ áţţáçķ. ·····························⟧';

  @override
  String get routineLowLightSteps =>
      '⟦Ðîɱ ţĥé ļîĝĥţš öŕ çļöšé ţĥé çûŕţáîñš.\nŢûŕñ öñ ðáŕķ ɱöðé áñð ļöŵéŕ ýöûŕ šçŕééñ ƀŕîĝĥţñéšš.\nŴéáŕ áñ éýé ɱášķ öŕ šûñĝļáššéš îƒ ļîĝĥţ šţîļļ ƀöţĥéŕš ýöû.\nÇûţ ðöŵñ ñöîšé ŵîţĥ éáŕþļûĝš öŕ á ǫûîéţ ŕööɱ. ········································⟧';

  @override
  String get routineHydrationTitle => '⟦Ðŕîñķ šöɱé ŵáţéŕ ······⟧';

  @override
  String get routineHydrationSummary =>
      '⟦Ķééþîñĝ ŵáţéŕ ŵîţĥîñ ŕéáçĥ ɱáķéš îţ éášîéŕ ţö ðŕîñķ ţĥŕöûĝĥ ţĥé ðáý. ························⟧';

  @override
  String get routineHydrationSteps =>
      '⟦Ķééþ á ĝļášš öŕ ƀöţţļé öƒ ŵáţéŕ ŵîţĥîñ ŕéáçĥ.\nŢáķé á ƒéŵ šîþš éṽéŕý ĥöûŕ.\nĤáṽé á ĝļášš öƒ ŵáţéŕ ŵîţĥ éáçĥ ɱéáļ. ·······································⟧';

  @override
  String get routineCaffeineTitle => '⟦Ķééþ çáƒƒéîñé šţéáðý ·······⟧';

  @override
  String get routineCaffeineSummary =>
      '⟦Ɓîĝ çĥáñĝéš îñ ĥöŵ ɱûçĥ çáƒƒéîñé ýöû ĥáṽé çáñ ɱáţţéŕ ƒöŕ šöɱé þéöþļé. ·························⟧';

  @override
  String get routineCaffeineSteps =>
      '⟦Ĥáṽé çáƒƒéîñé áţ áƀöûţ ţĥé šáɱé ţîɱéš éáçĥ ðáý.\nÅṽöîð ƀîĝ îñçŕéášéš, áñð áṽöîð šûððéñļý šķîþþîñĝ ýöûŕ ûšûáļ áɱöûñţ.\nĤáṽé ýöûŕ ļášţ çáƒƒéîñáţéð ðŕîñķ ƀý éáŕļý áƒţéŕñööñ. ········································⟧';

  @override
  String get routineSleepTitle => '⟦Šţéáðý šļééþ ·····⟧';

  @override
  String get routineSleepSummary =>
      '⟦Å ŕéĝûļáŕ šļééþ šçĥéðûļé, ŵééķéñðš îñçļûðéð, ĥéļþš ɱáñý þéöþļé. ·······················⟧';

  @override
  String get routineSleepSteps =>
      '⟦Ĝö ţö ƀéð áñð ĝéţ ûþ áţ áƀöûţ ţĥé šáɱé ţîɱé éṽéŕý ðáý.\nĶééþ ţĥé ƀéðŕööɱ ðáŕķ, ǫûîéţ áñð çööļ.\nÞûţ šçŕééñš áŵáý 30 ɱîñûţéš ƀéƒöŕé ƀéð.\nÅṽöîð ļöñĝ ñáþš ļáţé îñ ţĥé ðáý. ········································⟧';

  @override
  String get breathingStart => '⟦Šţáŕţ ƀŕéáţĥîñĝ ······⟧';

  @override
  String get breathingStop => '⟦Šţöþ ··⟧';

  @override
  String get breathingIn => '⟦Ɓŕéáţĥé îñ ····⟧';

  @override
  String get breathingOut => '⟦Ɓŕéáţĥé öûţ ····⟧';

  @override
  String breathingRound(int round, int total) {
    return '⟦Ŕöûñð $round öƒ $total ····⟧';
  }

  @override
  String get breathingDone =>
      '⟦Ðöñé. Ţáķé á ɱöɱéñţ ƀéƒöŕé ýöû ĝéţ ûþ. ··············⟧';

  @override
  String get settingsRoutinesHint =>
      '⟦Šţŕéţçĥéš, ƀŕéáţĥîñĝ áñð öţĥéŕ šîɱþļé ŕöûţîñéš ·················⟧';

  @override
  String get experimentsTitle => '⟦Éẋþéŕîɱéñţš ····⟧';

  @override
  String get settingsExperimentsHint =>
      '⟦Ţŕý öñé çĥáñĝé ƒöŕ ţŵö ŵééķš áñð çöɱþáŕé ··············⟧';

  @override
  String get experimentsIntro =>
      '⟦Ţŕý öñé çĥáñĝé ƒöŕ ţŵö ŵééķš áñð çöɱþáŕé îţ ŵîţĥ ţĥé ţŵö ŵééķš ƀéƒöŕé. Öñé éẋþéŕîɱéñţ áţ á ţîɱé. ··································⟧';

  @override
  String get experimentsPick => '⟦Þîçķ öñé çĥáñĝé ······⟧';

  @override
  String get experimentChangeCutCaffeine => '⟦Çûţ ƀáçķ öñ çáƒƒéîñé ·······⟧';

  @override
  String get experimentChangeRegularSleep =>
      '⟦Ĝö ţö ƀéð áţ ţĥé šáɱé ţîɱé éṽéŕý ñîĝĥţ ··············⟧';

  @override
  String get experimentChangeMoreWater => '⟦Ðŕîñķ ɱöŕé ŵáţéŕ ······⟧';

  @override
  String get experimentChangeDailyStretches =>
      '⟦Šţŕéţçĥ ýöûŕ ñéçķ éṽéŕý ðáý ··········⟧';

  @override
  String get experimentChangeLessScreens =>
      '⟦Ļéšš šçŕééñ ţîɱé îñ ţĥé éṽéñîñĝ ···········⟧';

  @override
  String get experimentChangeNoAlcohol => '⟦Šķîþ áļçöĥöļ ·····⟧';

  @override
  String experimentDay(int day, int total) {
    return '⟦Ðáý $day öƒ $total ···⟧';
  }

  @override
  String get experimentAdherenceQuestion =>
      '⟦Ðîð ýöû šţîçķ ŵîţĥ îţ ţöðáý? ··········⟧';

  @override
  String get experimentYes => '⟦Ýéš ··⟧';

  @override
  String get experimentNo => '⟦Ñö ·⟧';

  @override
  String experimentAdherence(int kept, int days) {
    return '⟦Ķéþţ ţö îţ öñ $kept öƒ $days ðáýš ·········⟧';
  }

  @override
  String get experimentCompareTitle =>
      '⟦Ţŵö ŵééķš ƀéƒöŕé áñð ðûŕîñĝ ··········⟧';

  @override
  String get experimentBefore => '⟦Ɓéƒöŕé ···⟧';

  @override
  String get experimentDuring => '⟦Ðûŕîñĝ ···⟧';

  @override
  String get experimentRowRate => '⟦Åţţáçķš þéŕ ŵééķ ······⟧';

  @override
  String get experimentRowIntensity => '⟦Åṽéŕáĝé îñţéñšîţý ······⟧';

  @override
  String get experimentRowDuration => '⟦Ṁéðîáñ ðûŕáţîöñ ······⟧';

  @override
  String experimentSample(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ƒŕöɱ $count áţţáçķš',
      one: 'ƒŕöɱ 1 áţţáçķ',
      zero: 'ñö áţţáçķš',
    );
    return '⟦$_temp0 ················⟧';
  }

  @override
  String experimentDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ðáýš',
      one: '1 ðáý',
    );
    return '⟦$_temp0 ············⟧';
  }

  @override
  String get experimentNoData => '⟦Ñö ðáţá ···⟧';

  @override
  String get experimentCaveat =>
      '⟦Ţŵö ŵééķš îš šĥöŕţ. Ŵéáţĥéŕ, šéášöñš áñð šţŕéšš çĥáñĝé öñ ţĥéîŕ öŵñ, šö ŕéáð ţĥîš áš á ĥîñţ, ñöţ þŕööƒ. ·····································⟧';

  @override
  String experimentSmallSample(int min) {
    return '⟦Ƒéŵéŕ ţĥáñ $min áţţáçķš îñ öñé öƒ ţĥé þéŕîöðš, šö ţĥé ñûɱƀéŕš çáñ šŵîñĝ á ļöţ. ··························⟧';
  }

  @override
  String get experimentStop => '⟦Šţöþ éẋþéŕîɱéñţ ······⟧';

  @override
  String get experimentFinish => '⟦Ƒîñîšĥ áñð šáṽé ţĥé ŕéšûļţ ··········⟧';

  @override
  String get experimentDue => '⟦Ţĥé ţŵö ŵééķš áŕé öṽéŕ. ·········⟧';

  @override
  String get experimentPast => '⟦Þášţ éẋþéŕîɱéñţš ······⟧';

  @override
  String experimentFinished(String date) {
    return '⟦Ƒîñîšĥéð $date ····⟧';
  }

  @override
  String experimentStopped(String date) {
    return '⟦Šţöþþéð $date ···⟧';
  }

  @override
  String experimentPastSummary(String before, String during) {
    return '⟦$before áţţáçķš þéŕ ŵééķ ƀéƒöŕé, $during ðûŕîñĝ ············⟧';
  }

  @override
  String get accountTitle => '⟦Åççöûñţ ···⟧';

  @override
  String get settingsAccountHint =>
      '⟦Öþţîöñáļ. Öñļý ñééðéð ƒöŕ ƀáçķûþ áñð šĥáŕé ļîñķš ·················⟧';

  @override
  String get accountIntro =>
      '⟦Åñ áççöûñţ îš öþţîöñáļ. Éṽéŕýţĥîñĝ îñ ţĥé áþþ ŵöŕķš ŵîţĥöûţ öñé, áñð ýöûŕ éñţŕîéš šţáý öñ ţĥîš þĥöñé. Ýöû öñļý ñééð öñé ƒöŕ éñçŕýþţéð ƀáçķûþ áñð šĥáŕé ļîñķš. ········································⟧';

  @override
  String get accountUnavailable =>
      '⟦Åççöûñţš áŕéñ\'ţ šéţ ûþ îñ ţĥîš ƀûîļð. ·············⟧';

  @override
  String get accountApple => '⟦Çöñţîñûé ŵîţĥ Åþþļé ·······⟧';

  @override
  String get accountGoogle => '⟦Çöñţîñûé ŵîţĥ Ĝööĝļé ·······⟧';

  @override
  String get accountOrEmail => '⟦Öŕ ûšé ýöûŕ éɱáîļ ······⟧';

  @override
  String get accountEmail => '⟦Éɱáîļ ··⟧';

  @override
  String get accountPassword => '⟦Þáššŵöŕð ···⟧';

  @override
  String accountPasswordHint(int min) {
    return '⟦Åţ ļéášţ $min çĥáŕáçţéŕš ƒöŕ á ñéŵ áççöûñţ ··············⟧';
  }

  @override
  String get accountSignIn => '⟦Šîĝñ îñ ···⟧';

  @override
  String get accountCreate => '⟦Çŕéáţé áççöûñţ ·····⟧';

  @override
  String get accountForgot => '⟦Ƒöŕĝöţ þáššŵöŕð? ······⟧';

  @override
  String get accountResetSent =>
      '⟦Îƒ ţĥáţ éɱáîļ ĥáš áñ áççöûñţ, á ŕéšéţ ļîñķ îš öñ îţš ŵáý. ····················⟧';

  @override
  String accountSignedInAs(String email) {
    return '⟦Šîĝñéð îñ áš $email ·····⟧';
  }

  @override
  String accountSignedInWith(String method) {
    return '⟦Šîĝñéð îñ ŵîţĥ $method ······⟧';
  }

  @override
  String get accountMethodApple => '⟦Åþþļé ··⟧';

  @override
  String get accountMethodGoogle => '⟦Ĝööĝļé ···⟧';

  @override
  String get accountMethodEmail => '⟦éɱáîļ ··⟧';

  @override
  String get accountSignedInNote =>
      '⟦Ýöûŕ éñţŕîéš šţîļļ ļîṽé öñ ţĥîš þĥöñé. Šîĝñîñĝ öûţ ðéļéţéš ñöţĥîñĝ. ························⟧';

  @override
  String get accountSignOut => '⟦Šîĝñ öûţ ···⟧';

  @override
  String get accountDelete => '⟦Ðéļéţé áççöûñţ ·····⟧';

  @override
  String get accountDeleteTitle => '⟦Ðéļéţé ýöûŕ áççöûñţ? ·······⟧';

  @override
  String accountDeleteBody(int hours) {
    return '⟦Ţĥîš ðéļéţéš ýöûŕ áççöûñţ. Ŵîţĥîñ $hours ĥöûŕš ýöûŕ éñçŕýþţéð ƀáçķûþ áñð áñý šĥáŕé ļîñķš áŕé ŕéɱöṽéð ƒŕöɱ öûŕ šéŕṽéŕš. Éṽéŕýţĥîñĝ öñ ţĥîš þĥöñé šţáýš. ········································⟧';
  }

  @override
  String get accountDeletePassword =>
      '⟦Éñţéŕ ýöûŕ þáššŵöŕð ţö çöñƒîŕɱ ···········⟧';

  @override
  String get accountDeleteSubscription =>
      '⟦Å Þŕéɱîûɱ šûƀšçŕîþţîöñ îš ƀîļļéð ƀý ţĥé Åþþ Šţöŕé öŕ Ĝööĝļé Þļáý. Ðéļéţîñĝ ţĥé áççöûñţ ðöéš ñöţ çáñçéļ îţ; çáñçéļ îţ îñ ţĥé šţöŕé. ········································⟧';

  @override
  String get accountDeleteCancel => '⟦Ķééþ áççöûñţ ·····⟧';

  @override
  String accountDeleted(int hours) {
    return '⟦Åççöûñţ ðéļéţéð. Îţš šéŕṽéŕ ðáţá ŵîļļ ƀé ĝöñé ŵîţĥîñ $hours ĥöûŕš. ·····················⟧';
  }

  @override
  String get accountErrorWrongCredentials =>
      '⟦Ţĥáţ éɱáîļ áñð þáššŵöŕð ðöñ\'ţ ɱáţçĥ. ·············⟧';

  @override
  String get accountErrorEmailInUse =>
      '⟦Ţĥáţ éɱáîļ áļŕéáðý ĥáš áñ áççöûñţ. Ţŕý šîĝñîñĝ îñ îñšţéáð. ·····················⟧';

  @override
  String get accountErrorWeakPassword =>
      '⟦Çĥööšé á ļöñĝéŕ þáššŵöŕð. ·········⟧';

  @override
  String get accountErrorInvalidEmail => '⟦Çĥéçķ ţĥé éɱáîļ áððŕéšš. ·········⟧';

  @override
  String get accountErrorNetwork =>
      '⟦Ñö çöññéçţîöñ. Ţŕý áĝáîñ ŵĥéñ ýöû\'ŕé öñļîñé. ················⟧';

  @override
  String get accountErrorRecentSignIn =>
      '⟦Ƒöŕ ýöûŕ šáƒéţý, šîĝñ îñ áĝáîñ, ţĥéñ ţŕý öñçé ɱöŕé. ··················⟧';

  @override
  String get accountErrorUnknown =>
      '⟦Šöɱéţĥîñĝ ŵéñţ ŵŕöñĝ. Ţŕý áĝáîñ. ············⟧';

  @override
  String get backupTitle => '⟦Éñçŕýþţéð ƀáçķûþ ······⟧';

  @override
  String get settingsBackupHint =>
      '⟦Ļöçķéð ŵîţĥ á þáššþĥŕášé öñļý ýöû ķñöŵ ··············⟧';

  @override
  String get backupIntro =>
      '⟦Ýöûŕ ƀáçķûþ îš ļöçķéð öñ ţĥîš þĥöñé ŵîţĥ ýöûŕ þáššþĥŕášé ƀéƒöŕé îţ îš ûþļöáðéð. Ŵé šţöŕé öñļý ţĥé ļöçķéð ƒîļé áñð çáññöţ öþéñ îţ. ········································⟧';

  @override
  String get backupForgetWarning =>
      '⟦Îƒ ýöû ƒöŕĝéţ ţĥé þáššþĥŕášé, ñöƀöðý çáñ öþéñ ţĥé ƀáçķûþ, ñöţ éṽéñ ûš. Ŵŕîţé îţ ðöŵñ šöɱéŵĥéŕé šáƒé. ···································⟧';

  @override
  String get backupNeedsAccount =>
      '⟦Ɓáçķûþ ñééðš áñ áççöûñţ. Éṽéŕýţĥîñĝ éļšé ŵöŕķš ŵîţĥöûţ öñé. ·····················⟧';

  @override
  String get backupOpenAccount => '⟦Šéţ ûþ áñ áççöûñţ ······⟧';

  @override
  String get backupNone => '⟦Ñö ƀáçķûþ ýéţ ·····⟧';

  @override
  String backupLast(String date) {
    return '⟦Ļášţ ƀáçķûþ: $date ·····⟧';
  }

  @override
  String get backupStatusUnknown =>
      '⟦Çöûļðñ\'ţ çĥéçķ ƒöŕ á ƀáçķûþ ŕîĝĥţ ñöŵ. ··············⟧';

  @override
  String get backupPassphrase => '⟦Þáššþĥŕášé ····⟧';

  @override
  String backupPassphraseHint(int min) {
    return '⟦Åţ ļéášţ $min çĥáŕáçţéŕš. Å ƒéŵ ûñŕéļáţéð ŵöŕðš ŵöŕķ ŵéļļ. ···················⟧';
  }

  @override
  String get backupPassphraseRepeat =>
      '⟦Ŕéþéáţ ţĥé þáššþĥŕášé ţö ƀáçķ ûþ ············⟧';

  @override
  String get backupNow => '⟦Ɓáçķ ûþ ñöŵ ····⟧';

  @override
  String get backupDone => '⟦Ɓáçķéð ûþ. ····⟧';

  @override
  String get backupRestore => '⟦Ŕéšţöŕé ƒŕöɱ ƀáçķûþ ·······⟧';

  @override
  String get backupRestoreTitle =>
      '⟦Ŕéþļáçé éṽéŕýţĥîñĝ öñ ţĥîš þĥöñé? ············⟧';

  @override
  String backupRestoreBody(String date) {
    return '⟦Éṽéŕýţĥîñĝ öñ ţĥîš þĥöñé îš ŕéþļáçéð ŵîţĥ ţĥé ƀáçķûþ ƒŕöɱ $date. ·····················⟧';
  }

  @override
  String get backupRestoreConfirm => '⟦Ŕéšţöŕé ···⟧';

  @override
  String get backupRestored => '⟦Ŕéšţöŕéð ƒŕöɱ ýöûŕ ƀáçķûþ. ··········⟧';

  @override
  String get backupDelete => '⟦Ðéļéţé ƀáçķûþ ·····⟧';

  @override
  String get backupDeleteTitle => '⟦Ðéļéţé ţĥé ƀáçķûþ? ·······⟧';

  @override
  String get backupDeleteBody =>
      '⟦Ţĥé ļöçķéð ƒîļé îš ŕéɱöṽéð ƒŕöɱ öûŕ šéŕṽéŕš. Éṽéŕýţĥîñĝ öñ ţĥîš þĥöñé šţáýš. ···························⟧';

  @override
  String get backupDeleted => '⟦Ɓáçķûþ ðéļéţéð. ······⟧';

  @override
  String get backupWorking =>
      '⟦Ŵöŕķîñĝ öñ îţ. Ţĥîš çáñ ţáķé á ƒéŵ šéçöñðš. ················⟧';

  @override
  String get backupErrorMismatch =>
      '⟦Ţĥé ţŵö þáššþĥŕášéš ðöñ\'ţ ɱáţçĥ. ············⟧';

  @override
  String backupErrorShort(int min) {
    return '⟦Ûšé áţ ļéášţ $min çĥáŕáçţéŕš. ·········⟧';
  }

  @override
  String get backupErrorNoBackup =>
      '⟦Ţĥéŕé\'š ñö ƀáçķûþ öñ ţĥîš áççöûñţ ýéţ. ··············⟧';

  @override
  String get backupErrorTooLarge =>
      '⟦Ţĥé ƀáçķûþ îš ţöö ļáŕĝé ţö ûþļöáð. ············⟧';

  @override
  String get backupErrorNewerApp =>
      '⟦Ţĥîš ƀáçķûþ ŵáš ɱáðé ƀý á ñéŵéŕ ṽéŕšîöñ öƒ ţĥé áþþ. Ûþðáţé ţĥé áþþ, ţĥéñ ţŕý áĝáîñ. ······························⟧';

  @override
  String get backupErrorWrongPassphrase =>
      '⟦Ţĥáţ þáššþĥŕášé ðöéšñ\'ţ öþéñ ţĥîš ƀáçķûþ. ···············⟧';

  @override
  String get backupErrorDamaged => '⟦Ţĥé ƀáçķûþ ƒîļé îš ðáɱáĝéð. ··········⟧';

  @override
  String get backupErrorPinning =>
      '⟦Ţĥé çöññéçţîöñ ţö ţĥé ƀáçķûþ šéŕṽéŕ çöûļðñ\'ţ ƀé ṽéŕîƒîéð, šö ñöţĥîñĝ ŵáš šéñţ. Ţŕý áñöţĥéŕ ñéţŵöŕķ. ···································⟧';

  @override
  String get backupErrorNotAllowed =>
      '⟦Ýöûŕ šîĝñ-îñ ĥáš éẋþîŕéð. Šîĝñ îñ áĝáîñ, ţĥéñ ŕéţŕý. ···················⟧';

  @override
  String get shareLinkButton => '⟦Šĥáŕé áš á ŵéƀ ļîñķ ·······⟧';

  @override
  String get shareLinkTitle => '⟦Šĥáŕé ŵîţĥ ýöûŕ çļîñîçîáñ ·········⟧';

  @override
  String get shareLinkExplain =>
      '⟦Åñýöñé ŵîţĥ ţĥé ļîñķ çáñ ŕéáð ţĥîš ŕéþöŕţ ûñţîļ îţ éẋþîŕéš. Îţ šĥöŵš ţĥé šáɱé šûɱɱáŕý áš ţĥé ÞÐƑ, ñöţ ýöûŕ ðîáŕý. Ýöû çáñ šţöþ šĥáŕîñĝ áţ áñý ţîɱé. ········································⟧';

  @override
  String get shareLinkNeedsAccount =>
      '⟦Šĥáŕîñĝ á ļîñķ ñééðš áñ áççöûñţ. Ţĥé ÞÐƑ áñð ÇŠṼ ŵöŕķ ŵîţĥöûţ öñé. ························⟧';

  @override
  String shareLinkDuration(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ðáýš',
      one: '1 ðáý',
    );
    return '⟦$_temp0 ···········⟧';
  }

  @override
  String get shareLinkCreate => '⟦Çŕéáţé ļîñķ ····⟧';

  @override
  String get shareLinkWorking => '⟦Çŕéáţîñĝ ţĥé ļîñķ. ·······⟧';

  @override
  String shareLinkReady(String date) {
    return '⟦Ļîñķ ŕéáðý. Šĥáŕéð ûñţîļ $date. ··········⟧';
  }

  @override
  String get shareLinkCopy => '⟦Çöþý ļîñķ ····⟧';

  @override
  String get shareLinkCopied => '⟦Ļîñķ çöþîéð. ·····⟧';

  @override
  String get shareLinkShare => '⟦Šĥáŕé ļîñķ ····⟧';

  @override
  String shareLinkMessage(String url) {
    return '⟦Ṁý ɱîĝŕáîñé ŕéþöŕţ: $url ·······⟧';
  }

  @override
  String get shareLinksTitle => '⟦Šĥáŕéð ļîñķš ·····⟧';

  @override
  String get settingsShareLinksHint =>
      '⟦Šéé áñð šţöþ ţĥé ŕéþöŕţ ļîñķš ýöû šĥáŕéð ··············⟧';

  @override
  String get shareLinksEmpty =>
      '⟦Ýöû ĥáṽéñ\'ţ šĥáŕéð áñý ļîñķš. Çŕéáţé öñé ƒŕöɱ Ðöçţöŕ ŕéþöŕţ. ·····················⟧';

  @override
  String shareLinkActiveUntil(String date) {
    return '⟦Šĥáŕéð ûñţîļ $date ·····⟧';
  }

  @override
  String shareLinkExpiredOn(String date) {
    return '⟦Éẋþîŕéð $date ···⟧';
  }

  @override
  String get shareLinkRevoked => '⟦Šĥáŕîñĝ šţöþþéð ······⟧';

  @override
  String shareLinkCreatedOn(String date) {
    return '⟦Çŕéáţéð $date ···⟧';
  }

  @override
  String get shareLinkRevoke => '⟦Šţöþ šĥáŕîñĝ ·····⟧';

  @override
  String get shareLinkRevokeTitle => '⟦Šţöþ šĥáŕîñĝ ţĥîš ŕéþöŕţ? ·········⟧';

  @override
  String get shareLinkRevokeBody =>
      '⟦Ţĥé ļîñķ šţöþš ŵöŕķîñĝ áţ öñçé, ƒöŕ éṽéŕýöñé ŵĥö ĥáš îţ. ····················⟧';

  @override
  String get shareLinkRevokedDone =>
      '⟦Šĥáŕîñĝ šţöþþéð. Ţĥé ļîñķ ñö ļöñĝéŕ ŵöŕķš. ···············⟧';

  @override
  String get shareLinkErrorUnavailable =>
      '⟦Šĥáŕé ļîñķš áŕéñ\'ţ šéţ ûþ îñ ţĥîš ƀûîļð. ··············⟧';

  @override
  String get shareLinkErrorSignedOut =>
      '⟦Ýöûŕ šîĝñ-îñ ĥáš éẋþîŕéð. Šîĝñ îñ áĝáîñ, ţĥéñ ŕéţŕý. ···················⟧';

  @override
  String get premiumTitle => '⟦Þŕéɱîûɱ ···⟧';

  @override
  String get premiumIntro =>
      '⟦Þŕéɱîûɱ áððš ƒöûŕ éẋţŕáš. Éṽéŕýţĥîñĝ éļšé šţáýš ƒŕéé, ŵîţĥ ñö ţîɱé ļîɱîţ. ··························⟧';

  @override
  String get premiumFreeNote =>
      '⟦Åļŵáýš ƒŕéé: ļöĝĝîñĝ áţţáçķš áñð çĥéçķ-îñš, ţĥé ŵéáţĥéŕ ƒééð, ţĥé ŕîšķ ļéṽéļ, îñšîĝĥţš, ţĥé ɱéðîçáţîöñ ļöĝ áñð ţĥé ðöçţöŕ ŕéþöŕţ. ········································⟧';

  @override
  String get premiumFeatureShareLink => '⟦Çļîñîçîáñ šĥáŕé ļîñķ ·······⟧';

  @override
  String get premiumFeatureShareLinkHint =>
      '⟦Šéñð ýöûŕ ŕéþöŕţ áš á ŵéƀ ļîñķ ţĥáţ šţöþš ŵöŕķîñĝ áƒţéŕ 7 öŕ 30 ðáýš. ·························⟧';

  @override
  String get premiumFeatureExperiments => '⟦Éẋþéŕîɱéñţš ····⟧';

  @override
  String get premiumFeatureExperimentsHint =>
      '⟦Ţŕý öñé çĥáñĝé ƒöŕ ţŵö ŵééķš áñð çöɱþáŕé îţ ŵîţĥ ţĥé ŵééķš ƀéƒöŕé. ························⟧';

  @override
  String get premiumFeatureExtendedFactors =>
      '⟦Éẋţéñðéð éñṽîŕöñɱéñţ ƒáçţöŕš ··········⟧';

  @override
  String get premiumFeatureExtendedFactorsHint =>
      '⟦Þáŕţîçûļáţéš, öžöñé áñð þöļļéñ ƀý ţýþé. ··············⟧';

  @override
  String get premiumFeatureBackup => '⟦Ɓáçķûþ áçŕöšš þĥöñéš ·······⟧';

  @override
  String get premiumFeatureBackupHint =>
      '⟦Åñ éñçŕýþţéð ƀáçķûþ ýöû çáñ ŕéšţöŕé öñ á ñéŵ þĥöñé. ··················⟧';

  @override
  String get premiumActive => '⟦Þŕéɱîûɱ îš öñ. ·····⟧';

  @override
  String premiumRenews(String date) {
    return '⟦Ŕéñéŵš öñ $date. ····⟧';
  }

  @override
  String premiumEnds(String date) {
    return '⟦Éñðš öñ $date. ····⟧';
  }

  @override
  String get premiumManage => '⟦Ṁáñáĝé šûƀšçŕîþţîöñ ·······⟧';

  @override
  String premiumOfferMonthly(String price) {
    return '⟦Ṁöñţĥļý, $price ····⟧';
  }

  @override
  String premiumOfferAnnual(String price) {
    return '⟦Ýéáŕļý, $price ···⟧';
  }

  @override
  String premiumOfferOther(String price) {
    return '⟦$price ·⟧';
  }

  @override
  String get premiumRestore => '⟦Ŕéšţöŕé þûŕçĥášéš ······⟧';

  @override
  String get premiumRestoredNone =>
      '⟦Ñö Þŕéɱîûɱ þûŕçĥášé ŵáš ƒöûñð ƒöŕ ţĥîš šţöŕé áççöûñţ. ···················⟧';

  @override
  String get premiumThanks => '⟦Ţĥáñķ ýöû. Þŕéɱîûɱ îš öñ. ·········⟧';

  @override
  String get premiumRenewalTerms =>
      '⟦Šûƀšçŕîþţîöñš ŕéñéŵ áûţöɱáţîçáļļý ûñţîļ ýöû çáñçéļ îñ ţĥé šţöŕé\'š šéţţîñĝš. Çáñçéļ áţ ļéášţ 24 ĥöûŕš ƀéƒöŕé ţĥé ŕéñéŵáļ ðáţé ţö áṽöîð ţĥé ñéẋţ çĥáŕĝé. ········································⟧';

  @override
  String get premiumLoadingOffers => '⟦Ļöáðîñĝ þŕîçéš. ······⟧';

  @override
  String get premiumNoOffers =>
      '⟦Þŕîçéš çöûļðñ\'ţ ƀé ļöáðéð. Çĥéçķ ţĥé çöññéçţîöñ áñð ţŕý áĝáîñ. ······················⟧';

  @override
  String get premiumRetry => '⟦Ţŕý áĝáîñ ····⟧';

  @override
  String get premiumUnavailable =>
      '⟦Þûŕçĥášéš áŕéñ\'ţ šéţ ûþ îñ ţĥîš ƀûîļð. ··············⟧';

  @override
  String get premiumDevUnlocked =>
      '⟦Ðéṽéļöþɱéñţ ƀûîļð: éṽéŕý Þŕéɱîûɱ ƒéáţûŕé îš ûñļöçķéð. ···················⟧';

  @override
  String get premiumAccountTip =>
      '⟦Ûšîñĝ ɱöŕé ţĥáñ öñé þĥöñé? Šîĝñ îñ ƒîŕšţ, šö Þŕéɱîûɱ ƒöļļöŵš ýöûŕ áççöûñţ. ··························⟧';

  @override
  String get premiumErrorNotAllowed =>
      '⟦Ţĥîš šţöŕé áççöûñţ çáñ\'ţ ɱáķé þûŕçĥášéš. ··············⟧';

  @override
  String get premiumErrorPending =>
      '⟦Ţĥé þûŕçĥášé îš ŵáîţîñĝ ƒöŕ áþþŕöṽáļ. Þŕéɱîûɱ ţûŕñš öñ öñçé îţ ĝöéš ţĥŕöûĝĥ. ···························⟧';

  @override
  String get premiumErrorStore =>
      '⟦Ţĥé šţöŕé ĥáð á þŕöƀļéɱ. Ţŕý áĝáîñ ļáţéŕ. ···············⟧';

  @override
  String premiumLockTitle(String feature) {
    return '⟦$feature çöɱéš ŵîţĥ Þŕéɱîûɱ. ·······⟧';
  }

  @override
  String get premiumLockButton => '⟦Šéé Þŕéɱîûɱ ····⟧';

  @override
  String get premiumLockShareLinkNote =>
      '⟦Ļîñķš ýöû áļŕéáðý ɱáðé ķééþ ŵöŕķîñĝ ûñţîļ ţĥéý éñð, áñð ýöû çáñ šţöþ šĥáŕîñĝ ţĥéɱ áţ áñý ţîɱé. ·································⟧';

  @override
  String get premiumLockExperimentsNote =>
      '⟦Ýöûŕ þášţ ŕéšûļţš šţáý ĥéŕé. ··········⟧';

  @override
  String get premiumLockBackupNote =>
      '⟦Ýöû çáñ šţîļļ ŕéšţöŕé öŕ ðéļéţé á ƀáçķûþ ýöû áļŕéáðý ĥáṽé. ·····················⟧';

  @override
  String get premiumFactorsLocked =>
      '⟦Þáŕţîçûļáţéš, öžöñé áñð þöļļéñ çöɱé ŵîţĥ Þŕéɱîûɱ. ··················⟧';

  @override
  String get settingsPremiumHint =>
      '⟦Šĥáŕé ļîñķ, éẋþéŕîɱéñţš, éẋţéñðéð ƒáçţöŕš áñð ƀáçķûþ ···················⟧';

  @override
  String get settingsPremiumActive => '⟦Öñ ·⟧';

  @override
  String get shareLinkErrorPremium =>
      '⟦Šĥáŕé ļîñķš ñééð Þŕéɱîûɱ. Îƒ ýöû ĵûšţ šûƀšçŕîƀéð, ŵáîţ á ɱîñûţé áñð ţŕý áĝáîñ. ····························⟧';

  @override
  String get auditTitle => '⟦Ĥöŵ ţĥé ŕîšķ ļéṽéļ ĥáš ðöñé ··········⟧';

  @override
  String auditNotYet(int needed, int logged) {
    return '⟦Ţĥîš þáĝé áþþéáŕš öñçé ýöû ĥáṽé ļöĝĝéð $needed áţţáçķš. Ýöû ĥáṽé ļöĝĝéð $logged šö ƒáŕ. ··························⟧';
  }

  @override
  String auditIntro(int window) {
    String _temp0 = intl.Intl.pluralLogic(
      window,
      locale: localeName,
      other: '$window ðáýš',
      one: 'ðáý',
    );
    return '⟦Ţĥîš çöɱþáŕéš ţĥé ļéṽéļ ţĥé áþþ šĥöŵéð éáçĥ ðáý ŵîţĥ ŵĥéñ ýöûŕ áţţáçķš šţáŕţéð. Åñ áţţáçķ çöûñţš áš ƒöļļöŵîñĝ á Ĥîĝĥ ðáý ŵĥéñ ţĥé ðáý îţ šţáŕţéð, öŕ ţĥé $_temp0 ƀéƒöŕé, ŵáš šĥöŵñ áš Ĥîĝĥ. ········································⟧';
  }

  @override
  String get auditEmpty =>
      '⟦Ñöţĥîñĝ ţö çöɱþáŕé ýéţ. Ţĥé áþþ ķééþš ţĥé ļéṽéļ îţ šĥöŵš éáçĥ ðáý ƒŕöɱ ñöŵ öñ, áñð ţĥé ƒîŕšţ ñûɱƀéŕš áþþéáŕ áƒţéŕ ýöûŕ ñéẋţ áţţáçķ öŕ Ĥîĝĥ ðáý. ········································⟧';

  @override
  String get auditHitsTitle =>
      '⟦Åţţáçķš ţĥáţ ƒöļļöŵéð á Ĥîĝĥ ðáý ············⟧';

  @override
  String auditHitsValue(int hits, int attacks, String share) {
    return '⟦$hits öƒ $attacks ($share) ···⟧';
  }

  @override
  String get auditMissesTitle =>
      '⟦Åţţáçķš ŵîţĥöûţ á Ĥîĝĥ ðáý ƀéƒöŕé ţĥéɱ ··············⟧';

  @override
  String auditMissesValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count áţţáçķš',
      one: '1 áţţáçķ',
    );
    return '⟦$_temp0 ·············⟧';
  }

  @override
  String get auditFalseAlarmsTitle => '⟦Ĥîĝĥ ðáýš ŵîţĥ ñö áţţáçķ ·········⟧';

  @override
  String auditFalseAlarmsValue(int count, int highDays) {
    return '⟦$count öƒ $highDays Ĥîĝĥ ðáýš ·····⟧';
  }

  @override
  String get auditTrend => '⟦Ɓý ɱöñţĥ ···⟧';

  @override
  String auditMonthLine(int hits, int attacks, int falseAlarms, int highDays) {
    return '⟦$hits öƒ $attacks áţţáçķš áƒţéŕ á Ĥîĝĥ ðáý; $falseAlarms öƒ $highDays Ĥîĝĥ ðáýš ŵîţĥöûţ áñ áţţáçķ ·······················⟧';
  }

  @override
  String get auditCaveat =>
      '⟦Šɱáļļ ñûɱƀéŕš ɱöṽé á ļöţ ƒŕöɱ ɱöñţĥ ţö ɱöñţĥ. Å Ĥîĝĥ ðáý ŵîţĥöûţ áñ áţţáçķ îš ñöţ á ɱîšţáķé: îţ ɱéáñš ɱöŕé öƒ ýöûŕ ûšûáļ ţŕîĝĝéŕš ļîñéð ûþ. Ţĥé ļéṽéļ îš á ĝûîðé ţö þļáñ áŕöûñð, ñöţ á þŕöɱîšé. ········································⟧';

  @override
  String get auditShare => '⟦Šĥáŕé ţĥéšé çöûñţš éáçĥ ɱöñţĥ ···········⟧';

  @override
  String get auditShareHint =>
      '⟦Ĥéļþš çĥéçķ ţĥé áþþ ƒöŕ éṽéŕýöñé. Öñļý ţĥé ƒîṽé ñûɱƀéŕš áñð ţĥé ɱöðéļ ṽéŕšîöñ áŕé šéñţ, ñéṽéŕ ðáţéš, þļáçéš, ýöûŕ ļöĝ öŕ ýöûŕ áççöûñţ. Öƒƒ ûñļéšš ýöû ţûŕñ îţ öñ. ········································⟧';

  @override
  String get settingsAuditHint =>
      '⟦Åţţáçķš áƒţéŕ Ĥîĝĥ ðáýš áñð Ĥîĝĥ ðáýš ŵîţĥöûţ öñé ··················⟧';

  @override
  String unitHpa(String value) {
    return '⟦$value ĥÞá ··⟧';
  }

  @override
  String unitInHg(String value) {
    return '⟦$value îñĤĝ ··⟧';
  }

  @override
  String unitMmHg(String value) {
    return '⟦$value ɱɱĤĝ ··⟧';
  }

  @override
  String unitCelsius(String value) {
    return '⟦$value °Ç ··⟧';
  }

  @override
  String unitFahrenheit(String value) {
    return '⟦$value °Ƒ ··⟧';
  }

  @override
  String get unitsTitle => '⟦Ûñîţš ··⟧';

  @override
  String get settingsUnitsHint => '⟦Þŕéššûŕé áñð ţéɱþéŕáţûŕé ·········⟧';

  @override
  String get unitsPressure => '⟦Þŕéššûŕé ···⟧';

  @override
  String get unitsTemperature => '⟦Ţéɱþéŕáţûŕé ····⟧';

  @override
  String get unitNameHpa => '⟦Ĥéçţöþášçáļš (ĥÞá) ·······⟧';

  @override
  String get unitNameInHg => '⟦Îñçĥéš öƒ ɱéŕçûŕý (îñĤĝ) ·········⟧';

  @override
  String get unitNameMmHg => '⟦Ṁîļļîɱéţŕéš öƒ ɱéŕçûŕý (ɱɱĤĝ) ···········⟧';

  @override
  String get unitNameCelsius => '⟦Çéļšîûš (°Ç) ·····⟧';

  @override
  String get unitNameFahrenheit => '⟦Ƒáĥŕéñĥéîţ (°Ƒ) ······⟧';

  @override
  String get unitsNote =>
      '⟦Ţĥé ƒîŕšţ çĥöîçé çöɱéš ƒŕöɱ ýöûŕ þĥöñé\'š ŕéĝîöñ. Çĥáñĝîñĝ îţ öñļý çĥáñĝéš ĥöŵ ṽáļûéš áŕé šĥöŵñ; ýöûŕ ļöĝ šţáýš ţĥé šáɱé. ········································⟧';

  @override
  String envTemperatureNow(String temperature) {
    return '⟦Ţéɱþéŕáţûŕé ñöŵ: $temperature ······⟧';
  }

  @override
  String get questionnaireEnglishNote =>
      '⟦Ţĥé ǫûéšţîöñš áŕé šĥöŵñ îñ ţĥéîŕ öŕîĝîñáļ Éñĝļîšĥ ŵöŕðîñĝ ûñţîļ á ṽáļîðáţéð ţŕáñšļáţîöñ îš áððéð, šö ýöûŕ šçöŕéš šţáý çöɱþáŕáƀļé. ········································⟧';

  @override
  String get wellnessDisclaimer =>
      '⟦Ĝéñéŕáļ ŵéļļñéšš îñƒöŕɱáţîöñ, ñöţ ɱéðîçáļ áðṽîçé. Ţáļķ ţö ýöûŕ çļîñîçîáñ áƀöûţ ţŕéáţɱéñţ. ································⟧';

  @override
  String get dataSourceWeather => '⟦Öþéñ-Ṁéţéö ŵéáţĥéŕ ·······⟧';

  @override
  String get dataSourceAirQuality =>
      '⟦Öþéñ-Ṁéţéö áîŕ ǫûáļîţý áñð ÛṼ (ÇÅṀŠ) ·············⟧';

  @override
  String get dataSourcePollen => '⟦Öþéñ-Ṁéţéö þöļļéñ (ÇÅṀŠ) ·········⟧';

  @override
  String get dataSourceGeocoding => '⟦Öþéñ-Ṁéţéö ĝéöçöðîñĝ ·······⟧';

  @override
  String get dataSourceBarometer => '⟦Ðéṽîçé ƀáŕöɱéţéŕ ······⟧';

  @override
  String get dataCoverageWorldwide => '⟦Ŵöŕļðŵîðé ····⟧';

  @override
  String get dataCoverageEuropeanAqi =>
      '⟦Ŵöŕļðŵîðé, Éûŕöþéáñ ÅǪÎ îñ Éûŕöþé ············⟧';

  @override
  String get dataCoverageEurope => '⟦Éûŕöþé öñļý ····⟧';

  @override
  String get dataCoverageBarometer =>
      '⟦Þĥöñéš ŵîţĥ á þŕéššûŕé šéñšöŕ ···········⟧';

  @override
  String get settingsReduceMotion => '⟦Ŕéðûçé ɱöţîöñ ·····⟧';

  @override
  String get settingsReduceMotionHint =>
      '⟦Ƒéŵéŕ áñîɱáţîöñš, éṽéñ ŵĥéñ ýöûŕ þĥöñé\'š šéţţîñĝ îš öƒƒ ····················⟧';
}
