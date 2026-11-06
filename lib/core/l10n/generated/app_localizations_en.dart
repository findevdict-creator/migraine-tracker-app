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

  @override
  String get environmentTitle => 'Environment';

  @override
  String get environmentCardTitle => 'Pressure';

  @override
  String get environmentCardEmpty =>
      'No weather saved yet. Tap to set your location.';

  @override
  String environmentCardSummary(String hpa, String trend) {
    return '$hpa hPa, $trend';
  }

  @override
  String get envPressureSection => 'Air pressure';

  @override
  String envPressureNow(String hpa) {
    return '$hpa hPa';
  }

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
  String envDeltaValue(String value) {
    return '$value hPa';
  }

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
}
