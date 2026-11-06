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
  String get insightsMethod1 =>
      'An exposure day is a day where a factor was present in your log or in the weather, for example a sleep answer of 1 or a pressure drop of more than 2 hPa.';

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
  String notifTypePressureDropHint(String hpa) {
    return 'When the forecast shows a fall of $hpa hPa or more in 24 hours';
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
  String notifPressureThreshold(String hpa) {
    return 'Pressure drop threshold: $hpa hPa in 24 h';
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
  String notifPressureBody(String hpa, String time) {
    return 'A fall of $hpa hPa is expected by $time.';
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
  String reportWeatherHint(String hpa) {
    return 'A fall is a drop of $hpa hPa or more over 24 h at the time of the entry.';
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
}
