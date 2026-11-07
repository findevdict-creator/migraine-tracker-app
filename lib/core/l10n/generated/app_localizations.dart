import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('en', 'XA'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
  ];

  /// Fallback app title; the live title comes from AppIdentity.
  ///
  /// In en, this message translates to:
  /// **'Aurawell'**
  String get appTitle;

  /// Home screen placeholder before any feature ships.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet.\nYour risk level and environment will appear here.'**
  String get homeEmptyState;

  /// Risk level name.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get riskLevelLow;

  /// Risk level name.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get riskLevelModerate;

  /// Risk level name.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get riskLevelHigh;

  /// Developer screen title.
  ///
  /// In en, this message translates to:
  /// **'Theme gallery'**
  String get devThemeGalleryTitle;

  /// No description provided for @devThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get devThemeLight;

  /// No description provided for @devThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get devThemeDark;

  /// No description provided for @devThemeAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack theme'**
  String get devThemeAttack;

  /// No description provided for @devSampleBody.
  ///
  /// In en, this message translates to:
  /// **'Body text at the default size. It must stay readable at 200% text scale without truncation.'**
  String get devSampleBody;

  /// No description provided for @devSamplePrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get devSamplePrimary;

  /// No description provided for @devSampleSecondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get devSampleSecondary;

  /// No description provided for @devSampleText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get devSampleText;

  /// No description provided for @devSampleDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get devSampleDisabled;

  /// No description provided for @devSampleChipOn.
  ///
  /// In en, this message translates to:
  /// **'Aura'**
  String get devSampleChipOn;

  /// No description provided for @devSampleChipOff.
  ///
  /// In en, this message translates to:
  /// **'Nausea'**
  String get devSampleChipOff;

  /// No description provided for @devSampleChipIcon.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get devSampleChipIcon;

  /// No description provided for @devSampleSlider.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get devSampleSlider;

  /// No description provided for @devSampleSliderLow.
  ///
  /// In en, this message translates to:
  /// **'No pain'**
  String get devSampleSliderLow;

  /// No description provided for @devSampleSliderHigh.
  ///
  /// In en, this message translates to:
  /// **'Worst'**
  String get devSampleSliderHigh;

  /// No description provided for @devSampleCard.
  ///
  /// In en, this message translates to:
  /// **'A card with a badge'**
  String get devSampleCard;

  /// Home screen one-tap button.
  ///
  /// In en, this message translates to:
  /// **'Start attack'**
  String get attackStart;

  /// Home button when an attack is running.
  ///
  /// In en, this message translates to:
  /// **'Continue attack'**
  String get attackContinue;

  /// No description provided for @attackTitleRunning.
  ///
  /// In en, this message translates to:
  /// **'Attack in progress'**
  String get attackTitleRunning;

  /// No description provided for @attackTitleEnded.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get attackTitleEnded;

  /// No description provided for @attackStartedAt.
  ///
  /// In en, this message translates to:
  /// **'Started at {time}'**
  String attackStartedAt(String time);

  /// No description provided for @attackNotFound.
  ///
  /// In en, this message translates to:
  /// **'This attack no longer exists.'**
  String get attackNotFound;

  /// No description provided for @attackIntensity.
  ///
  /// In en, this message translates to:
  /// **'Pain intensity'**
  String get attackIntensity;

  /// No description provided for @durationEstimateTitle.
  ///
  /// In en, this message translates to:
  /// **'How long attacks like this usually last'**
  String get durationEstimateTitle;

  /// No description provided for @durationEstimateRange.
  ///
  /// In en, this message translates to:
  /// **'Typically {low} to {high} h'**
  String durationEstimateRange(String low, String high);

  /// No description provided for @durationEstimateSameMedication.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Based on {count} past attacks of similar intensity with the same medication}}'**
  String durationEstimateSameMedication(int count);

  /// No description provided for @durationEstimateNoMedication.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Based on {count} past attacks of similar intensity without medication}}'**
  String durationEstimateNoMedication(int count);

  /// No description provided for @durationEstimateSimilar.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Based on {count} past attacks of similar intensity}}'**
  String durationEstimateSimilar(int count);

  /// No description provided for @durationEstimateAll.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Based on {count} of your past attacks}}'**
  String durationEstimateAll(int count);

  /// No description provided for @attackIntensityLow.
  ///
  /// In en, this message translates to:
  /// **'No pain'**
  String get attackIntensityLow;

  /// No description provided for @attackIntensityHigh.
  ///
  /// In en, this message translates to:
  /// **'Worst'**
  String get attackIntensityHigh;

  /// No description provided for @attackWhereItHurts.
  ///
  /// In en, this message translates to:
  /// **'Where it hurts'**
  String get attackWhereItHurts;

  /// No description provided for @attackSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get attackSymptoms;

  /// No description provided for @attackPhases.
  ///
  /// In en, this message translates to:
  /// **'Phases'**
  String get attackPhases;

  /// No description provided for @attackNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get attackNotes;

  /// No description provided for @attackNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Anything else worth remembering'**
  String get attackNotesHint;

  /// No description provided for @attackEnd.
  ///
  /// In en, this message translates to:
  /// **'End attack'**
  String get attackEnd;

  /// No description provided for @attackDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get attackDone;

  /// No description provided for @attackFinishLater.
  ///
  /// In en, this message translates to:
  /// **'Finish later'**
  String get attackFinishLater;

  /// No description provided for @symptomAura.
  ///
  /// In en, this message translates to:
  /// **'Aura'**
  String get symptomAura;

  /// No description provided for @symptomNeckTension.
  ///
  /// In en, this message translates to:
  /// **'Neck tension'**
  String get symptomNeckTension;

  /// No description provided for @symptomLightSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get symptomLightSensitivity;

  /// No description provided for @symptomSoundSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get symptomSoundSensitivity;

  /// No description provided for @symptomSmellSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Smell'**
  String get symptomSmellSensitivity;

  /// No description provided for @symptomNausea.
  ///
  /// In en, this message translates to:
  /// **'Nausea'**
  String get symptomNausea;

  /// No description provided for @phaseProdrome.
  ///
  /// In en, this message translates to:
  /// **'Prodrome'**
  String get phaseProdrome;

  /// No description provided for @phaseAura.
  ///
  /// In en, this message translates to:
  /// **'Aura'**
  String get phaseAura;

  /// No description provided for @phaseAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get phaseAttack;

  /// No description provided for @phasePostdrome.
  ///
  /// In en, this message translates to:
  /// **'Postdrome'**
  String get phasePostdrome;

  /// No description provided for @headForehead.
  ///
  /// In en, this message translates to:
  /// **'Forehead'**
  String get headForehead;

  /// No description provided for @headLeftTemple.
  ///
  /// In en, this message translates to:
  /// **'Left temple'**
  String get headLeftTemple;

  /// No description provided for @headRightTemple.
  ///
  /// In en, this message translates to:
  /// **'Right temple'**
  String get headRightTemple;

  /// No description provided for @headBehindEyes.
  ///
  /// In en, this message translates to:
  /// **'Behind the eyes'**
  String get headBehindEyes;

  /// No description provided for @headLeftSide.
  ///
  /// In en, this message translates to:
  /// **'Left side'**
  String get headLeftSide;

  /// No description provided for @headRightSide.
  ///
  /// In en, this message translates to:
  /// **'Right side'**
  String get headRightSide;

  /// No description provided for @headTopOfHead.
  ///
  /// In en, this message translates to:
  /// **'Top of head'**
  String get headTopOfHead;

  /// No description provided for @headBackOfHead.
  ///
  /// In en, this message translates to:
  /// **'Back of head'**
  String get headBackOfHead;

  /// No description provided for @headNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get headNeck;

  /// No description provided for @checkinTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in'**
  String get checkinTitle;

  /// No description provided for @checkinLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this day.'**
  String get checkinLoadError;

  /// No description provided for @checkinIntro.
  ///
  /// In en, this message translates to:
  /// **'Three taps. How was it?'**
  String get checkinIntro;

  /// No description provided for @checkinComplete.
  ///
  /// In en, this message translates to:
  /// **'Done for this day. Tap a number to change it.'**
  String get checkinComplete;

  /// No description provided for @checkinAddMore.
  ///
  /// In en, this message translates to:
  /// **'Add more (optional)'**
  String get checkinAddMore;

  /// No description provided for @checkinOptionalTitle.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get checkinOptionalTitle;

  /// No description provided for @checkinDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get checkinDone;

  /// No description provided for @checkinToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get checkinToday;

  /// No description provided for @checkinSleepQuality.
  ///
  /// In en, this message translates to:
  /// **'Sleep quality'**
  String get checkinSleepQuality;

  /// No description provided for @checkinStress.
  ///
  /// In en, this message translates to:
  /// **'Stress'**
  String get checkinStress;

  /// No description provided for @checkinNeckTension.
  ///
  /// In en, this message translates to:
  /// **'Neck tension'**
  String get checkinNeckTension;

  /// No description provided for @checkinCaffeine.
  ///
  /// In en, this message translates to:
  /// **'Caffeine'**
  String get checkinCaffeine;

  /// No description provided for @checkinHydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get checkinHydration;

  /// No description provided for @checkinAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get checkinAlcohol;

  /// No description provided for @checkinLightExposure.
  ///
  /// In en, this message translates to:
  /// **'Bright light'**
  String get checkinLightExposure;

  /// No description provided for @checkinScreenExposure.
  ///
  /// In en, this message translates to:
  /// **'Screen time'**
  String get checkinScreenExposure;

  /// No description provided for @checkinSleepLow.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get checkinSleepLow;

  /// No description provided for @checkinSleepHigh.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get checkinSleepHigh;

  /// No description provided for @checkinStressLow.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get checkinStressLow;

  /// No description provided for @checkinStressHigh.
  ///
  /// In en, this message translates to:
  /// **'Very stressed'**
  String get checkinStressHigh;

  /// No description provided for @checkinNeckLow.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get checkinNeckLow;

  /// No description provided for @checkinNeckHigh.
  ///
  /// In en, this message translates to:
  /// **'Very tight'**
  String get checkinNeckHigh;

  /// No description provided for @checkinHydrationLow.
  ///
  /// In en, this message translates to:
  /// **'Little'**
  String get checkinHydrationLow;

  /// No description provided for @checkinHydrationHigh.
  ///
  /// In en, this message translates to:
  /// **'Plenty'**
  String get checkinHydrationHigh;

  /// No description provided for @checkinExposureLow.
  ///
  /// In en, this message translates to:
  /// **'Little'**
  String get checkinExposureLow;

  /// No description provided for @checkinExposureHigh.
  ///
  /// In en, this message translates to:
  /// **'A lot'**
  String get checkinExposureHigh;

  /// No description provided for @checkinNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get checkinNone;

  /// No description provided for @checkinCupsOrMore.
  ///
  /// In en, this message translates to:
  /// **'{count}+ cups'**
  String checkinCupsOrMore(int count);

  /// No description provided for @checkinDrinksOrMore.
  ///
  /// In en, this message translates to:
  /// **'{count}+ drinks'**
  String checkinDrinksOrMore(int count);

  /// No description provided for @checkinValueSemantics.
  ///
  /// In en, this message translates to:
  /// **'{field}, {value} of {max}'**
  String checkinValueSemantics(String field, int value, int max);

  /// No description provided for @checkinReminderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get checkinReminderTooltip;

  /// No description provided for @checkinReminderAt.
  ///
  /// In en, this message translates to:
  /// **'Reminder at {time}'**
  String checkinReminderAt(String time);

  /// No description provided for @checkinReminderPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in reminder'**
  String get checkinReminderPickerTitle;

  /// No description provided for @checkinCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in'**
  String get checkinCardTitle;

  /// No description provided for @checkinCardDone.
  ///
  /// In en, this message translates to:
  /// **'Done for today'**
  String get checkinCardDone;

  /// No description provided for @checkinCardTodo.
  ///
  /// In en, this message translates to:
  /// **'Three taps, about 10 seconds'**
  String get checkinCardTodo;

  /// No description provided for @medicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medicationTitle;

  /// No description provided for @medicationAdd.
  ///
  /// In en, this message translates to:
  /// **'Add medication'**
  String get medicationAdd;

  /// No description provided for @medicationAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Log a dose'**
  String get medicationAddTitle;

  /// No description provided for @medicationName.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medicationName;

  /// No description provided for @medicationDose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get medicationDose;

  /// No description provided for @medicationDoseHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 400 mg'**
  String get medicationDoseHint;

  /// No description provided for @medicationKindAcute.
  ///
  /// In en, this message translates to:
  /// **'Acute'**
  String get medicationKindAcute;

  /// No description provided for @medicationKindPreventive.
  ///
  /// In en, this message translates to:
  /// **'Preventive'**
  String get medicationKindPreventive;

  /// No description provided for @medicationTakenAt.
  ///
  /// In en, this message translates to:
  /// **'Taken at {time}'**
  String medicationTakenAt(String time);

  /// No description provided for @medicationLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get medicationLog;

  /// No description provided for @medicationDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get medicationDelete;

  /// No description provided for @medicationThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get medicationThisMonth;

  /// No description provided for @medicationEmpty.
  ///
  /// In en, this message translates to:
  /// **'No doses logged this month.'**
  String get medicationEmpty;

  /// No description provided for @medicationReliefQuestion.
  ///
  /// In en, this message translates to:
  /// **'Relief after 2 h?'**
  String get medicationReliefQuestion;

  /// No description provided for @medicationReliefNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get medicationReliefNone;

  /// No description provided for @medicationReliefPartial.
  ///
  /// In en, this message translates to:
  /// **'Some'**
  String get medicationReliefPartial;

  /// No description provided for @medicationReliefFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get medicationReliefFull;

  /// No description provided for @medicationAcuteDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No acute-medication days this month} =1{1 acute-medication day this month} other{{count} acute-medication days this month}}'**
  String medicationAcuteDays(int count);

  /// No description provided for @medicationAcuteDaysHint.
  ///
  /// In en, this message translates to:
  /// **'Days with at least one acute dose, counted per calendar month.'**
  String get medicationAcuteDaysHint;

  /// No description provided for @medicationOveruseFirstNote.
  ///
  /// In en, this message translates to:
  /// **'You have reached {days} acute-medication days this month. Many clinicians suggest keeping this number low; it may be worth a conversation.'**
  String medicationOveruseFirstNote(int days);

  /// No description provided for @medicationOveruseSecondNote.
  ///
  /// In en, this message translates to:
  /// **'You have reached {days} acute-medication days this month. Please consider talking to your clinician about this pattern.'**
  String medicationOveruseSecondNote(int days);

  /// No description provided for @medicationTalkToClinician.
  ///
  /// In en, this message translates to:
  /// **'Talk to your clinician'**
  String get medicationTalkToClinician;

  /// No description provided for @cycleTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get cycleTitle;

  /// No description provided for @cycleToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Track my cycle'**
  String get cycleToggleTitle;

  /// No description provided for @cycleToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Off by default. When on, cycle day is kept with each check-in and used as a factor.'**
  String get cycleToggleSubtitle;

  /// No description provided for @cycleNoData.
  ///
  /// In en, this message translates to:
  /// **'Log a period start to see your cycle day.'**
  String get cycleNoData;

  /// No description provided for @cycleDayAndPhase.
  ///
  /// In en, this message translates to:
  /// **'Cycle day {day} · {phase}'**
  String cycleDayAndPhase(int day, String phase);

  /// No description provided for @cycleLength.
  ///
  /// In en, this message translates to:
  /// **'Based on a {days}-day cycle'**
  String cycleLength(int days);

  /// No description provided for @cyclePeriodStarts.
  ///
  /// In en, this message translates to:
  /// **'Period starts'**
  String get cyclePeriodStarts;

  /// No description provided for @cycleNoStarts.
  ///
  /// In en, this message translates to:
  /// **'None logged yet.'**
  String get cycleNoStarts;

  /// No description provided for @cycleRemoveStart.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get cycleRemoveStart;

  /// No description provided for @cyclePeriodStartedToday.
  ///
  /// In en, this message translates to:
  /// **'Period started this day'**
  String get cyclePeriodStartedToday;

  /// No description provided for @cyclePhaseMenstrual.
  ///
  /// In en, this message translates to:
  /// **'Menstrual'**
  String get cyclePhaseMenstrual;

  /// No description provided for @cyclePhaseFollicular.
  ///
  /// In en, this message translates to:
  /// **'Follicular'**
  String get cyclePhaseFollicular;

  /// No description provided for @cyclePhaseOvulation.
  ///
  /// In en, this message translates to:
  /// **'Around ovulation'**
  String get cyclePhaseOvulation;

  /// No description provided for @cyclePhaseLuteal.
  ///
  /// In en, this message translates to:
  /// **'Luteal'**
  String get cyclePhaseLuteal;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get settingsSectionDaily;

  /// No description provided for @settingsSectionData.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get settingsSectionData;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsExportJson.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get settingsExportJson;

  /// No description provided for @settingsExportJsonHint.
  ///
  /// In en, this message translates to:
  /// **'Every table in one file you can import again.'**
  String get settingsExportJsonHint;

  /// No description provided for @settingsExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get settingsExportCsv;

  /// No description provided for @settingsExportCsvHint.
  ///
  /// In en, this message translates to:
  /// **'One spreadsheet file per table.'**
  String get settingsExportCsvHint;

  /// No description provided for @settingsExportEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to export yet.'**
  String get settingsExportEmpty;

  /// No description provided for @settingsDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get settingsDeleteAll;

  /// No description provided for @settingsDeleteAllHint.
  ///
  /// In en, this message translates to:
  /// **'Removes all data from this device. Cannot be undone.'**
  String get settingsDeleteAllHint;

  /// No description provided for @settingsDeleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{There is nothing stored yet. Delete anyway?} =1{This deletes 1 record from this device. This cannot be undone.} other{This deletes {count} records from this device. This cannot be undone.}}'**
  String settingsDeleteAllConfirm(int count);

  /// No description provided for @settingsDeleteAllButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settingsDeleteAllButton;

  /// No description provided for @settingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// No description provided for @settingsDeletedAll.
  ///
  /// In en, this message translates to:
  /// **'All data deleted.'**
  String get settingsDeletedAll;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get settingsTerms;

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @environmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environmentTitle;

  /// No description provided for @environmentCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get environmentCardTitle;

  /// No description provided for @environmentCardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No weather saved yet. Tap to set your location.'**
  String get environmentCardEmpty;

  /// No description provided for @environmentCardSummary.
  ///
  /// In en, this message translates to:
  /// **'{pressure}, {trend}'**
  String environmentCardSummary(String pressure, String trend);

  /// No description provided for @envPressureSection.
  ///
  /// In en, this message translates to:
  /// **'Air pressure'**
  String get envPressureSection;

  /// No description provided for @envPressureUnknown.
  ///
  /// In en, this message translates to:
  /// **'No reading for this hour'**
  String get envPressureUnknown;

  /// No description provided for @envDelta3h.
  ///
  /// In en, this message translates to:
  /// **'3 h'**
  String get envDelta3h;

  /// No description provided for @envDelta6h.
  ///
  /// In en, this message translates to:
  /// **'6 h'**
  String get envDelta6h;

  /// No description provided for @envDelta12h.
  ///
  /// In en, this message translates to:
  /// **'12 h'**
  String get envDelta12h;

  /// No description provided for @envDelta24h.
  ///
  /// In en, this message translates to:
  /// **'24 h'**
  String get envDelta24h;

  /// No description provided for @envDeltaUnknown.
  ///
  /// In en, this message translates to:
  /// **'–'**
  String get envDeltaUnknown;

  /// No description provided for @envChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Last 48 hours and next 24'**
  String get envChartTitle;

  /// No description provided for @envUpdatedNever.
  ///
  /// In en, this message translates to:
  /// **'Not updated yet'**
  String get envUpdatedNever;

  /// No description provided for @envUpdatedJustNow.
  ///
  /// In en, this message translates to:
  /// **'Updated just now'**
  String get envUpdatedJustNow;

  /// No description provided for @envUpdatedMinutes.
  ///
  /// In en, this message translates to:
  /// **'Updated {n} min ago'**
  String envUpdatedMinutes(int n);

  /// No description provided for @envUpdatedHours.
  ///
  /// In en, this message translates to:
  /// **'Updated {n} h ago'**
  String envUpdatedHours(int n);

  /// No description provided for @envUpdatedDays.
  ///
  /// In en, this message translates to:
  /// **'Updated {n} d ago'**
  String envUpdatedDays(int n);

  /// No description provided for @envStale.
  ///
  /// In en, this message translates to:
  /// **'This forecast is a few hours old. It refreshes when you are back online.'**
  String get envStale;

  /// No description provided for @envOffline.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the weather service. Showing what is saved on this device.'**
  String get envOffline;

  /// No description provided for @envNoData.
  ///
  /// In en, this message translates to:
  /// **'No weather saved yet. Allow location or choose a city to see the pressure trend.'**
  String get envNoData;

  /// No description provided for @envRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get envRefresh;

  /// No description provided for @envLocationSection.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get envLocationSection;

  /// No description provided for @envLocationGps.
  ///
  /// In en, this message translates to:
  /// **'Using your approximate location'**
  String get envLocationGps;

  /// No description provided for @envLocationManual.
  ///
  /// In en, this message translates to:
  /// **'Using {city}'**
  String envLocationManual(String city);

  /// No description provided for @envLocationLast.
  ///
  /// In en, this message translates to:
  /// **'Using the last known area'**
  String get envLocationLast;

  /// No description provided for @envLocationNone.
  ///
  /// In en, this message translates to:
  /// **'No location set'**
  String get envLocationNone;

  /// No description provided for @envUseMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get envUseMyLocation;

  /// No description provided for @envChooseCity.
  ///
  /// In en, this message translates to:
  /// **'Choose a city'**
  String get envChooseCity;

  /// No description provided for @envCitySearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a city'**
  String get envCitySearchTitle;

  /// No description provided for @envCitySearchHint.
  ///
  /// In en, this message translates to:
  /// **'City name'**
  String get envCitySearchHint;

  /// No description provided for @envCityNoResults.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get envCityNoResults;

  /// No description provided for @envCitySearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not search right now. Check your connection and try again.'**
  String get envCitySearchFailed;

  /// No description provided for @envPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your location is rounded to about 10 km before it leaves this device.'**
  String get envPrivacyNote;

  /// No description provided for @envAttribution.
  ///
  /// In en, this message translates to:
  /// **'Weather data by Open-Meteo'**
  String get envAttribution;

  /// No description provided for @envTrendRising.
  ///
  /// In en, this message translates to:
  /// **'rising'**
  String get envTrendRising;

  /// No description provided for @envTrendFalling.
  ///
  /// In en, this message translates to:
  /// **'falling'**
  String get envTrendFalling;

  /// No description provided for @envTrendSteady.
  ///
  /// In en, this message translates to:
  /// **'steady'**
  String get envTrendSteady;

  /// No description provided for @envTrendUnknown.
  ///
  /// In en, this message translates to:
  /// **'no trend yet'**
  String get envTrendUnknown;

  /// No description provided for @barometerTitle.
  ///
  /// In en, this message translates to:
  /// **'Barometer'**
  String get barometerTitle;

  /// No description provided for @barometerOpen.
  ///
  /// In en, this message translates to:
  /// **'Open the barometer'**
  String get barometerOpen;

  /// No description provided for @barometerNoReading.
  ///
  /// In en, this message translates to:
  /// **'No reading'**
  String get barometerNoReading;

  /// No description provided for @barometerFromSensor.
  ///
  /// In en, this message translates to:
  /// **'From this device\'s sensor'**
  String get barometerFromSensor;

  /// No description provided for @barometerFromStation.
  ///
  /// In en, this message translates to:
  /// **'From the nearest station'**
  String get barometerFromStation;

  /// No description provided for @barometerNoSource.
  ///
  /// In en, this message translates to:
  /// **'No sensor on this device and no forecast saved yet'**
  String get barometerNoSource;

  /// No description provided for @barometerCalibrationSection.
  ///
  /// In en, this message translates to:
  /// **'Calibration'**
  String get barometerCalibrationSection;

  /// No description provided for @barometerOffset.
  ///
  /// In en, this message translates to:
  /// **'Sensor offset {offset} against the station series, from {pairs} hourly pairs.'**
  String barometerOffset(String offset, int pairs);

  /// No description provided for @barometerNotCalibrated.
  ///
  /// In en, this message translates to:
  /// **'Not calibrated yet. Needs at least {pairs} hours with both a sensor sample and a station value.'**
  String barometerNotCalibrated(int pairs);

  /// No description provided for @barometerTrendSection.
  ///
  /// In en, this message translates to:
  /// **'Last 24 hours on this device'**
  String get barometerTrendSection;

  /// No description provided for @barometerTrendEmpty.
  ///
  /// In en, this message translates to:
  /// **'Samples are taken while the app is open. Come back later to see the trend.'**
  String get barometerTrendEmpty;

  /// No description provided for @barometerTrendSamples.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 sample} other{{n} samples}}'**
  String barometerTrendSamples(int n);

  /// No description provided for @barometerStampNote.
  ///
  /// In en, this message translates to:
  /// **'Each attack you start records the sensor reading and the station value of that hour.'**
  String get barometerStampNote;

  /// No description provided for @envFactorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s factors'**
  String get envFactorsTitle;

  /// No description provided for @envFactorsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No daily factors for this area yet.'**
  String get envFactorsEmpty;

  /// No description provided for @factorBandLow.
  ///
  /// In en, this message translates to:
  /// **'low'**
  String get factorBandLow;

  /// No description provided for @factorBandModerate.
  ///
  /// In en, this message translates to:
  /// **'moderate'**
  String get factorBandModerate;

  /// No description provided for @factorBandHigh.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get factorBandHigh;

  /// No description provided for @factorBandVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'very high'**
  String get factorBandVeryHigh;

  /// No description provided for @factorValueWithBand.
  ///
  /// In en, this message translates to:
  /// **'{value} ({band})'**
  String factorValueWithBand(String value, String band);

  /// No description provided for @factorAqiUs.
  ///
  /// In en, this message translates to:
  /// **'Air quality (US AQI)'**
  String get factorAqiUs;

  /// No description provided for @factorAqiEu.
  ///
  /// In en, this message translates to:
  /// **'Air quality (European AQI)'**
  String get factorAqiEu;

  /// No description provided for @factorParticulates.
  ///
  /// In en, this message translates to:
  /// **'Particulates PM2.5 / PM10'**
  String get factorParticulates;

  /// No description provided for @factorParticulatesValue.
  ///
  /// In en, this message translates to:
  /// **'{pm25} / {pm10} µg/m³'**
  String factorParticulatesValue(String pm25, String pm10);

  /// No description provided for @factorOzone.
  ///
  /// In en, this message translates to:
  /// **'Ozone'**
  String get factorOzone;

  /// No description provided for @factorMicrograms.
  ///
  /// In en, this message translates to:
  /// **'{value} µg/m³'**
  String factorMicrograms(String value);

  /// No description provided for @factorPollen.
  ///
  /// In en, this message translates to:
  /// **'Pollen (Europe only)'**
  String get factorPollen;

  /// No description provided for @factorPollenType.
  ///
  /// In en, this message translates to:
  /// **'{type} {band}'**
  String factorPollenType(String type, String band);

  /// No description provided for @pollenAlder.
  ///
  /// In en, this message translates to:
  /// **'alder'**
  String get pollenAlder;

  /// No description provided for @pollenBirch.
  ///
  /// In en, this message translates to:
  /// **'birch'**
  String get pollenBirch;

  /// No description provided for @pollenGrass.
  ///
  /// In en, this message translates to:
  /// **'grass'**
  String get pollenGrass;

  /// No description provided for @pollenMugwort.
  ///
  /// In en, this message translates to:
  /// **'mugwort'**
  String get pollenMugwort;

  /// No description provided for @pollenOlive.
  ///
  /// In en, this message translates to:
  /// **'olive'**
  String get pollenOlive;

  /// No description provided for @pollenRagweed.
  ///
  /// In en, this message translates to:
  /// **'ragweed'**
  String get pollenRagweed;

  /// No description provided for @factorUvMax.
  ///
  /// In en, this message translates to:
  /// **'UV index, daily max'**
  String get factorUvMax;

  /// No description provided for @factorDaylight.
  ///
  /// In en, this message translates to:
  /// **'Daylight'**
  String get factorDaylight;

  /// No description provided for @factorDaylightValue.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String factorDaylightValue(int hours, int minutes);

  /// No description provided for @factorSun.
  ///
  /// In en, this message translates to:
  /// **'Sunrise and sunset'**
  String get factorSun;

  /// No description provided for @factorSunValue.
  ///
  /// In en, this message translates to:
  /// **'{sunrise} to {sunset}'**
  String factorSunValue(String sunrise, String sunset);

  /// No description provided for @aboutDataTitle.
  ///
  /// In en, this message translates to:
  /// **'About the data'**
  String get aboutDataTitle;

  /// No description provided for @aboutDataIntro.
  ///
  /// In en, this message translates to:
  /// **'Where the numbers in this app come from, and what each one can and cannot tell you.'**
  String get aboutDataIntro;

  /// No description provided for @aboutDataSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get aboutDataSources;

  /// No description provided for @aboutDataLicence.
  ///
  /// In en, this message translates to:
  /// **'{coverage}. Licence: {licence}.'**
  String aboutDataLicence(String coverage, String licence);

  /// No description provided for @aboutDataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'What leaves your phone'**
  String get aboutDataPrivacy;

  /// No description provided for @aboutDataPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Only a location rounded to about 10 km, so the weather service can answer for your area. Your attacks, check-ins, medication and health data stay on this device unless you choose to back up or share them.'**
  String get aboutDataPrivacyBody;

  /// No description provided for @aboutDataLimits.
  ///
  /// In en, this message translates to:
  /// **'Limits'**
  String get aboutDataLimits;

  /// No description provided for @aboutDataLimitsBody.
  ///
  /// In en, this message translates to:
  /// **'Forecasts are model estimates for a grid cell, not a measurement at your door. Pollen is only available in Europe. Air quality may be missing in some regions. Where a factor has no data for your area it is simply not shown.'**
  String get aboutDataLimitsBody;

  /// No description provided for @settingsHealthHint.
  ///
  /// In en, this message translates to:
  /// **'Sleep, heart rate, steps and cycle from your health app'**
  String get settingsHealthHint;

  /// No description provided for @healthTitle.
  ///
  /// In en, this message translates to:
  /// **'Health data'**
  String get healthTitle;

  /// No description provided for @healthIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose what to read from {store}. Each type has its own switch and its own reason.'**
  String healthIntro(String store);

  /// No description provided for @healthPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Imported data stays on this phone. It is never uploaded, not even with backup, unless you export it yourself.'**
  String get healthPrivacyNote;

  /// No description provided for @healthStoreApple.
  ///
  /// In en, this message translates to:
  /// **'Apple Health'**
  String get healthStoreApple;

  /// No description provided for @healthStoreConnect.
  ///
  /// In en, this message translates to:
  /// **'Health Connect'**
  String get healthStoreConnect;

  /// No description provided for @healthUnavailable.
  ///
  /// In en, this message translates to:
  /// **'{store} is not available on this device.'**
  String healthUnavailable(String store);

  /// No description provided for @healthReadSection.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get healthReadSection;

  /// No description provided for @healthTypeSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get healthTypeSleep;

  /// No description provided for @healthReasonSleep.
  ///
  /// In en, this message translates to:
  /// **'Fills in sleep quality on your daily check-in from the night\'s sleep, so you have one less tap.'**
  String get healthReasonSleep;

  /// No description provided for @healthTypeRestingHr.
  ///
  /// In en, this message translates to:
  /// **'Resting heart rate'**
  String get healthTypeRestingHr;

  /// No description provided for @healthReasonRestingHr.
  ///
  /// In en, this message translates to:
  /// **'A higher resting rate than usual can show strain the day before an attack.'**
  String get healthReasonRestingHr;

  /// No description provided for @healthTypeHrv.
  ///
  /// In en, this message translates to:
  /// **'Heart rate variability'**
  String get healthTypeHrv;

  /// No description provided for @healthReasonHrv.
  ///
  /// In en, this message translates to:
  /// **'Lower variability than usual often goes with stress and poor recovery.'**
  String get healthReasonHrv;

  /// No description provided for @healthTypeSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get healthTypeSteps;

  /// No description provided for @healthReasonSteps.
  ///
  /// In en, this message translates to:
  /// **'Very low or very high activity days are worth seeing next to your attacks.'**
  String get healthReasonSteps;

  /// No description provided for @healthTypeFlow.
  ///
  /// In en, this message translates to:
  /// **'Menstrual flow'**
  String get healthTypeFlow;

  /// No description provided for @healthReasonFlow.
  ///
  /// In en, this message translates to:
  /// **'Fills in period starts for cycle tracking, if you use it.'**
  String get healthReasonFlow;

  /// No description provided for @healthDenied.
  ///
  /// In en, this message translates to:
  /// **'{store} did not grant access. You can change this in its own settings.'**
  String healthDenied(String store);

  /// No description provided for @healthWriteSection.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get healthWriteSection;

  /// No description provided for @healthWriteHeadaches.
  ///
  /// In en, this message translates to:
  /// **'Write headache events to {store}'**
  String healthWriteHeadaches(String store);

  /// No description provided for @healthWriteHeadachesHint.
  ///
  /// In en, this message translates to:
  /// **'Each ended attack is saved as a headache with its start, end and severity. Nothing else is written.'**
  String get healthWriteHeadachesHint;

  /// No description provided for @healthImportSection.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get healthImportSection;

  /// No description provided for @healthImportNow.
  ///
  /// In en, this message translates to:
  /// **'Import now'**
  String get healthImportNow;

  /// No description provided for @healthImportNever.
  ///
  /// In en, this message translates to:
  /// **'Nothing imported yet'**
  String get healthImportNever;

  /// No description provided for @healthImportLast.
  ///
  /// In en, this message translates to:
  /// **'{age}'**
  String healthImportLast(String age);

  /// No description provided for @healthImportFailed.
  ///
  /// In en, this message translates to:
  /// **'The import did not finish. Try again later.'**
  String get healthImportFailed;

  /// No description provided for @healthImportResult.
  ///
  /// In en, this message translates to:
  /// **'{imported, plural, =0{Nothing new.} =1{1 new sample.} other{{imported} new samples.}} {prefilled, plural, =0{} =1{Sleep filled in for 1 day.} other{Sleep filled in for {prefilled} days.}}'**
  String healthImportResult(int imported, int prefilled);

  /// No description provided for @checkinSourceHealthkit.
  ///
  /// In en, this message translates to:
  /// **'From Apple Health'**
  String get checkinSourceHealthkit;

  /// No description provided for @checkinSourceHealthConnect.
  ///
  /// In en, this message translates to:
  /// **'From Health Connect'**
  String get checkinSourceHealthConnect;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get onboardingFinish;

  /// No description provided for @onboardingStep.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String onboardingStep(int step, int total);

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Your area\'s weather'**
  String get onboardingLocationTitle;

  /// No description provided for @onboardingLocationBody.
  ///
  /// In en, this message translates to:
  /// **'Air pressure changes are one of the most common things people notice before an attack. Allow an approximate location, or pick a city, to see them.'**
  String get onboardingLocationBody;

  /// No description provided for @onboardingLocationNone.
  ///
  /// In en, this message translates to:
  /// **'No location yet. You can also set this later from the environment screen.'**
  String get onboardingLocationNone;

  /// No description provided for @onboardingHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Health data'**
  String get onboardingHealthTitle;

  /// No description provided for @onboardingHealthBody.
  ///
  /// In en, this message translates to:
  /// **'Optional. Each type has its own switch and its own reason. You can change any of them later in Settings.'**
  String get onboardingHealthBody;

  /// No description provided for @onboardingHealthUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No health app is available on this device. You can skip this step.'**
  String get onboardingHealthUnavailable;

  /// No description provided for @onboardingReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in'**
  String get onboardingReminderTitle;

  /// No description provided for @onboardingReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Three taps a day, about ten seconds. Pick a time for the reminder.'**
  String get onboardingReminderBody;

  /// No description provided for @onboardingReminderNote.
  ///
  /// In en, this message translates to:
  /// **'Reminders start once notifications are set up. You can change the time any day from the check-in.'**
  String get onboardingReminderNote;

  /// No description provided for @explainerTitle.
  ///
  /// In en, this message translates to:
  /// **'What the level means'**
  String get explainerTitle;

  /// No description provided for @explainerIntro.
  ///
  /// In en, this message translates to:
  /// **'Each day the app shows a level built from your own history and today\'s conditions.'**
  String get explainerIntro;

  /// No description provided for @explainerDoesTitle.
  ///
  /// In en, this message translates to:
  /// **'What it does'**
  String get explainerDoesTitle;

  /// No description provided for @explainerDoes1.
  ///
  /// In en, this message translates to:
  /// **'Shows how today\'s weather, sleep, stress and routine compare with the days before your past attacks.'**
  String get explainerDoes1;

  /// No description provided for @explainerDoes2.
  ///
  /// In en, this message translates to:
  /// **'Learns from your own log, so it gets more specific the more you record.'**
  String get explainerDoes2;

  /// No description provided for @explainerDoes3.
  ///
  /// In en, this message translates to:
  /// **'Helps you decide whether today is a day to go easier on yourself.'**
  String get explainerDoes3;

  /// No description provided for @explainerDoesNotTitle.
  ///
  /// In en, this message translates to:
  /// **'What it does not do'**
  String get explainerDoesNotTitle;

  /// No description provided for @explainerDoesNot1.
  ///
  /// In en, this message translates to:
  /// **'It is not a forecast of an attack. A high level is a pattern, not a certainty, and a low level is not a promise.'**
  String get explainerDoesNot1;

  /// No description provided for @explainerDoesNot2.
  ///
  /// In en, this message translates to:
  /// **'It is not a medical opinion and does not replace your clinician.'**
  String get explainerDoesNot2;

  /// No description provided for @explainerDoesNot3.
  ///
  /// In en, this message translates to:
  /// **'It never sends your log anywhere. The level is computed on this phone.'**
  String get explainerDoesNot3;

  /// No description provided for @riskCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s level'**
  String get riskCardTitle;

  /// No description provided for @riskCardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No level yet. Add a check-in or let the weather load.'**
  String get riskCardEmpty;

  /// No description provided for @riskScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Your level'**
  String get riskScreenTitle;

  /// No description provided for @riskWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why'**
  String get riskWhyTitle;

  /// No description provided for @riskNoDrivers.
  ///
  /// In en, this message translates to:
  /// **'Nothing stands out.'**
  String get riskNoDrivers;

  /// No description provided for @riskNextDays.
  ///
  /// In en, this message translates to:
  /// **'Next days'**
  String get riskNextDays;

  /// No description provided for @riskDayToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get riskDayToday;

  /// No description provided for @riskDayTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get riskDayTomorrow;

  /// No description provided for @riskLoad.
  ///
  /// In en, this message translates to:
  /// **'Load {value} of 100'**
  String riskLoad(String value);

  /// No description provided for @riskConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {label}'**
  String riskConfidence(String label);

  /// No description provided for @riskConfidenceLow.
  ///
  /// In en, this message translates to:
  /// **'low'**
  String get riskConfidenceLow;

  /// No description provided for @riskConfidenceMedium.
  ///
  /// In en, this message translates to:
  /// **'medium'**
  String get riskConfidenceMedium;

  /// No description provided for @riskConfidenceHigh.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get riskConfidenceHigh;

  /// No description provided for @riskStillLearning.
  ///
  /// In en, this message translates to:
  /// **'Still learning: {count} of {needed} attacks logged'**
  String riskStillLearning(int count, int needed);

  /// No description provided for @riskTuned.
  ///
  /// In en, this message translates to:
  /// **'Tuned to your log'**
  String get riskTuned;

  /// No description provided for @riskDriverPoints.
  ///
  /// In en, this message translates to:
  /// **'{points} points'**
  String riskDriverPoints(String points);

  /// No description provided for @riskUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String riskUpdated(String time);

  /// No description provided for @riskExplainerLink.
  ///
  /// In en, this message translates to:
  /// **'What the level means'**
  String get riskExplainerLink;

  /// No description provided for @riskOpenCheckin.
  ///
  /// In en, this message translates to:
  /// **'Add today\'s check-in'**
  String get riskOpenCheckin;

  /// No description provided for @riskFactorPressureDrop.
  ///
  /// In en, this message translates to:
  /// **'Falling air pressure'**
  String get riskFactorPressureDrop;

  /// No description provided for @riskFactorHumidity.
  ///
  /// In en, this message translates to:
  /// **'High humidity'**
  String get riskFactorHumidity;

  /// No description provided for @riskFactorTemperatureSwing.
  ///
  /// In en, this message translates to:
  /// **'Temperature change'**
  String get riskFactorTemperatureSwing;

  /// No description provided for @riskFactorAirQuality.
  ///
  /// In en, this message translates to:
  /// **'Air quality'**
  String get riskFactorAirQuality;

  /// No description provided for @riskFactorPollen.
  ///
  /// In en, this message translates to:
  /// **'Pollen'**
  String get riskFactorPollen;

  /// No description provided for @riskFactorBrightLight.
  ///
  /// In en, this message translates to:
  /// **'Bright light'**
  String get riskFactorBrightLight;

  /// No description provided for @riskFactorScreenTime.
  ///
  /// In en, this message translates to:
  /// **'Screen time'**
  String get riskFactorScreenTime;

  /// No description provided for @riskFactorPoorSleep.
  ///
  /// In en, this message translates to:
  /// **'Poor sleep'**
  String get riskFactorPoorSleep;

  /// No description provided for @riskFactorStress.
  ///
  /// In en, this message translates to:
  /// **'Stress'**
  String get riskFactorStress;

  /// No description provided for @riskFactorNeckTension.
  ///
  /// In en, this message translates to:
  /// **'Neck tension'**
  String get riskFactorNeckTension;

  /// No description provided for @riskFactorCaffeine.
  ///
  /// In en, this message translates to:
  /// **'Caffeine'**
  String get riskFactorCaffeine;

  /// No description provided for @riskFactorAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get riskFactorAlcohol;

  /// No description provided for @riskFactorDehydration.
  ///
  /// In en, this message translates to:
  /// **'Low hydration'**
  String get riskFactorDehydration;

  /// No description provided for @riskFactorCyclePhase.
  ///
  /// In en, this message translates to:
  /// **'Cycle phase'**
  String get riskFactorCyclePhase;

  /// No description provided for @loadMeterTitle.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get loadMeterTitle;

  /// No description provided for @loadMeterSemantics.
  ///
  /// In en, this message translates to:
  /// **'Load {value} of 100. {segments}'**
  String loadMeterSemantics(String value, String segments);

  /// No description provided for @loadSegmentDetail.
  ///
  /// In en, this message translates to:
  /// **'{name}: {points} points'**
  String loadSegmentDetail(String name, String points);

  /// No description provided for @loadThresholdModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate from {value}'**
  String loadThresholdModerate(String value);

  /// No description provided for @loadThresholdHigh.
  ///
  /// In en, this message translates to:
  /// **'High from {value}'**
  String loadThresholdHigh(String value);

  /// No description provided for @loadMeterEmpty.
  ///
  /// In en, this message translates to:
  /// **'No load yet'**
  String get loadMeterEmpty;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your factors'**
  String get insightsTitle;

  /// No description provided for @insightsIntro.
  ///
  /// In en, this message translates to:
  /// **'How often an attack followed each factor in your own log, compared with your usual rate.'**
  String get insightsIntro;

  /// No description provided for @insightsTriggers.
  ///
  /// In en, this message translates to:
  /// **'More attacks followed'**
  String get insightsTriggers;

  /// No description provided for @insightsProtectors.
  ///
  /// In en, this message translates to:
  /// **'Fewer attacks followed'**
  String get insightsProtectors;

  /// No description provided for @insightsNeutral.
  ///
  /// In en, this message translates to:
  /// **'No clear effect'**
  String get insightsNeutral;

  /// No description provided for @insightsNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet'**
  String get insightsNotEnough;

  /// No description provided for @insightsEmptyBucket.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get insightsEmptyBucket;

  /// No description provided for @insightsSample.
  ///
  /// In en, this message translates to:
  /// **'{days} exposure days, {attacks} followed by an attack'**
  String insightsSample(int days, int attacks);

  /// No description provided for @insightsLift.
  ///
  /// In en, this message translates to:
  /// **'{ratio}× your usual rate'**
  String insightsLift(String ratio);

  /// No description provided for @insightsNeedMore.
  ///
  /// In en, this message translates to:
  /// **'{days} of {needed} exposure days logged'**
  String insightsNeedMore(int days, int needed);

  /// No description provided for @insightsNoRunYet.
  ///
  /// In en, this message translates to:
  /// **'Log and end an attack to start counting.'**
  String get insightsNoRunYet;

  /// No description provided for @insightsMethodLink.
  ///
  /// In en, this message translates to:
  /// **'How this is counted'**
  String get insightsMethodLink;

  /// No description provided for @insightsMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'How this is counted'**
  String get insightsMethodTitle;

  /// No description provided for @insightsMethod1.
  ///
  /// In en, this message translates to:
  /// **'An exposure day is a day where a factor was present in your log or in the weather, for example a sleep answer of 1 or a pressure drop of more than {pressure}.'**
  String insightsMethod1(String pressure);

  /// No description provided for @insightsMethod2.
  ///
  /// In en, this message translates to:
  /// **'An attack counts as following a day when it started on that day or the next, the 24 to 48 hours the model looks at.'**
  String get insightsMethod2;

  /// No description provided for @insightsMethod3.
  ///
  /// In en, this message translates to:
  /// **'The ratio compares how often attacks followed that factor\'s days with how often they followed any day in your log. 1.5× means one and a half times your usual rate; 0.5× means half.'**
  String get insightsMethod3;

  /// No description provided for @insightsMethod4.
  ///
  /// In en, this message translates to:
  /// **'A factor needs {needed} exposure days before it is sorted. Until then it sits under \"Not enough data yet\". Fewer attacks following a factor is as useful to know as more, so both lists get the same place.'**
  String insightsMethod4(int needed);

  /// No description provided for @insightsMethod5.
  ///
  /// In en, this message translates to:
  /// **'None of this is a cause. A factor can sit in a list because of something it travels with, such as weekends or a medication change. Use the lists to decide what to try, not what to blame.'**
  String get insightsMethod5;

  /// No description provided for @riskInsightsLink.
  ///
  /// In en, this message translates to:
  /// **'Your factors'**
  String get riskInsightsLink;

  /// No description provided for @settingsInsightsHint.
  ///
  /// In en, this message translates to:
  /// **'Which factors attacks followed in your log'**
  String get settingsInsightsHint;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @settingsNotificationsHint.
  ///
  /// In en, this message translates to:
  /// **'Level alerts, pressure drops, reminders'**
  String get settingsNotificationsHint;

  /// No description provided for @notificationsIntro.
  ///
  /// In en, this message translates to:
  /// **'Everything is scheduled on this phone from the saved forecast and your log. Switch off any type you do not want.'**
  String get notificationsIntro;

  /// No description provided for @notificationsPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off for this app in the system settings.'**
  String get notificationsPermissionDenied;

  /// No description provided for @notifTypeRiskRising.
  ///
  /// In en, this message translates to:
  /// **'Level rising'**
  String get notifTypeRiskRising;

  /// No description provided for @notifTypeRiskRisingHint.
  ///
  /// In en, this message translates to:
  /// **'The evening before and the morning of a higher day'**
  String get notifTypeRiskRisingHint;

  /// No description provided for @notifTypePressureDrop.
  ///
  /// In en, this message translates to:
  /// **'Pressure drop'**
  String get notifTypePressureDrop;

  /// No description provided for @notifTypePressureDropHint.
  ///
  /// In en, this message translates to:
  /// **'When the forecast shows a fall of {pressure} or more in 24 hours'**
  String notifTypePressureDropHint(String pressure);

  /// No description provided for @notifTypeAttackOver.
  ///
  /// In en, this message translates to:
  /// **'Is your attack over?'**
  String get notifTypeAttackOver;

  /// No description provided for @notifTypeAttackOverHint.
  ///
  /// In en, this message translates to:
  /// **'At your typical attack length, with an End button'**
  String get notifTypeAttackOverHint;

  /// No description provided for @notifTypeCheckin.
  ///
  /// In en, this message translates to:
  /// **'Check-in reminder'**
  String get notifTypeCheckin;

  /// No description provided for @notifTypeCheckinHint.
  ///
  /// In en, this message translates to:
  /// **'At the time set under Daily'**
  String get notifTypeCheckinHint;

  /// No description provided for @notifTypeMedication.
  ///
  /// In en, this message translates to:
  /// **'Preventive reminder'**
  String get notifTypeMedication;

  /// No description provided for @notifTypeMedicationHint.
  ///
  /// In en, this message translates to:
  /// **'A daily nudge for a preventive dose'**
  String get notifTypeMedicationHint;

  /// No description provided for @notifPressureThreshold.
  ///
  /// In en, this message translates to:
  /// **'Pressure drop threshold: {pressure} in 24 h'**
  String notifPressureThreshold(String pressure);

  /// No description provided for @notifMedicationTime.
  ///
  /// In en, this message translates to:
  /// **'Preventive reminder time'**
  String get notifMedicationTime;

  /// No description provided for @notifRiskEveningTitle.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow\'s level: {level}'**
  String notifRiskEveningTitle(String level);

  /// No description provided for @notifRiskEveningBody.
  ///
  /// In en, this message translates to:
  /// **'Your level for tomorrow is {level}. Top of the list: {driver}.'**
  String notifRiskEveningBody(String level, String driver);

  /// No description provided for @notifRiskMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s level: {level}'**
  String notifRiskMorningTitle(String level);

  /// No description provided for @notifRiskMorningBody.
  ///
  /// In en, this message translates to:
  /// **'Your level today is {level}. Top of the list: {driver}.'**
  String notifRiskMorningBody(String level, String driver);

  /// No description provided for @notifPressureTitle.
  ///
  /// In en, this message translates to:
  /// **'Air pressure is dropping'**
  String get notifPressureTitle;

  /// No description provided for @notifPressureBody.
  ///
  /// In en, this message translates to:
  /// **'A fall of {pressure} is expected by {time}.'**
  String notifPressureBody(String pressure, String time);

  /// No description provided for @notifAttackOverTitle.
  ///
  /// In en, this message translates to:
  /// **'Is your attack over?'**
  String get notifAttackOverTitle;

  /// No description provided for @notifAttackOverBody.
  ///
  /// In en, this message translates to:
  /// **'It started {duration} ago. End it here when it has passed.'**
  String notifAttackOverBody(String duration);

  /// No description provided for @notifEndAttackAction.
  ///
  /// In en, this message translates to:
  /// **'End attack'**
  String get notifEndAttackAction;

  /// No description provided for @notifCheckinTitle.
  ///
  /// In en, this message translates to:
  /// **'Three taps for today'**
  String get notifCheckinTitle;

  /// No description provided for @notifCheckinBody.
  ///
  /// In en, this message translates to:
  /// **'Sleep, stress and neck tension. Fifteen seconds.'**
  String get notifCheckinBody;

  /// No description provided for @notifMedicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Preventive dose'**
  String get notifMedicationTitle;

  /// No description provided for @notifMedicationBody.
  ///
  /// In en, this message translates to:
  /// **'Time for today\'s preventive medication, if you take one.'**
  String get notifMedicationBody;

  /// No description provided for @notifChannelAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get notifChannelAlerts;

  /// No description provided for @notifChannelAlertsDescription.
  ///
  /// In en, this message translates to:
  /// **'Level and pressure alerts from the saved forecast'**
  String get notifChannelAlertsDescription;

  /// No description provided for @notifChannelReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notifChannelReminders;

  /// No description provided for @notifChannelRemindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Check-in and preventive dose reminders'**
  String get notifChannelRemindersDescription;

  /// No description provided for @notifChannelAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get notifChannelAttack;

  /// No description provided for @notifChannelAttackDescription.
  ///
  /// In en, this message translates to:
  /// **'Questions about a running attack'**
  String get notifChannelAttackDescription;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor report'**
  String get reportTitle;

  /// No description provided for @settingsReportHint.
  ///
  /// In en, this message translates to:
  /// **'PDF and spreadsheet for a date range'**
  String get settingsReportHint;

  /// No description provided for @reportIntro.
  ///
  /// In en, this message translates to:
  /// **'A summary of what you logged, for your next appointment. Pick a period, then share the PDF or the spreadsheets.'**
  String get reportIntro;

  /// No description provided for @reportRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get reportRangeLabel;

  /// No description provided for @reportRangeDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String reportRangeDays(int days);

  /// No description provided for @reportRangeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get reportRangeCustom;

  /// No description provided for @reportRangeText.
  ///
  /// In en, this message translates to:
  /// **'{from} to {to}'**
  String reportRangeText(String from, String to);

  /// No description provided for @reportPreviewAttacks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No attacks} =1{1 attack} other{{count} attacks}}'**
  String reportPreviewAttacks(int count);

  /// No description provided for @reportPreviewAttackDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no attack days} =1{1 attack day} other{{count} attack days}}'**
  String reportPreviewAttackDays(int count);

  /// No description provided for @reportPreviewDoses.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no doses} =1{1 dose} other{{count} doses}}'**
  String reportPreviewDoses(int count);

  /// No description provided for @reportPreviewCheckins.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no check-ins} =1{1 check-in} other{{count} check-ins}}'**
  String reportPreviewCheckins(int count);

  /// No description provided for @reportEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged in this period yet.'**
  String get reportEmpty;

  /// No description provided for @reportSharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get reportSharePdf;

  /// No description provided for @reportShareCsv.
  ///
  /// In en, this message translates to:
  /// **'Share spreadsheets'**
  String get reportShareCsv;

  /// No description provided for @reportShareAll.
  ///
  /// In en, this message translates to:
  /// **'Share everything'**
  String get reportShareAll;

  /// No description provided for @reportBuilding.
  ///
  /// In en, this message translates to:
  /// **'Preparing the report'**
  String get reportBuilding;

  /// No description provided for @reportFailed.
  ///
  /// In en, this message translates to:
  /// **'The report could not be prepared. Try again.'**
  String get reportFailed;

  /// No description provided for @reportWhatIsIn.
  ///
  /// In en, this message translates to:
  /// **'What the PDF contains'**
  String get reportWhatIsIn;

  /// No description provided for @reportContents.
  ///
  /// In en, this message translates to:
  /// **'Attack calendar, monthly counts, duration, factors with their sample sizes, medication days, pressure changes, symptoms and head locations. No names, no notes.'**
  String get reportContents;

  /// No description provided for @reportPdfTitle.
  ///
  /// In en, this message translates to:
  /// **'{app} report'**
  String reportPdfTitle(String app);

  /// No description provided for @reportPdfPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period: {from} to {to} ({days} days)'**
  String reportPdfPeriod(String from, String to, int days);

  /// No description provided for @reportPdfGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated {date} on the person\'s device from their own log.'**
  String reportPdfGenerated(String date);

  /// No description provided for @reportPdfDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is a self-reported diary summary from a wellness app. It is not a medical record and does not replace a clinical assessment. Factor ratios describe this person\'s log only and are not causes.'**
  String get reportPdfDisclaimer;

  /// No description provided for @reportPdfPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages}'**
  String reportPdfPage(int page, int pages);

  /// No description provided for @reportSectionOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get reportSectionOverview;

  /// No description provided for @reportStatAttacks.
  ///
  /// In en, this message translates to:
  /// **'Attacks'**
  String get reportStatAttacks;

  /// No description provided for @reportStatAttackDays.
  ///
  /// In en, this message translates to:
  /// **'Attack days'**
  String get reportStatAttackDays;

  /// No description provided for @reportStatPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Attacks per 30 days'**
  String get reportStatPerMonth;

  /// No description provided for @reportStatMeanIntensity.
  ///
  /// In en, this message translates to:
  /// **'Mean intensity (0-10)'**
  String get reportStatMeanIntensity;

  /// No description provided for @reportStatAcuteDays.
  ///
  /// In en, this message translates to:
  /// **'Days with acute medication'**
  String get reportStatAcuteDays;

  /// No description provided for @reportStatCheckins.
  ///
  /// In en, this message translates to:
  /// **'Days with a check-in'**
  String get reportStatCheckins;

  /// No description provided for @reportSectionMonths.
  ///
  /// In en, this message translates to:
  /// **'By month'**
  String get reportSectionMonths;

  /// No description provided for @reportColMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get reportColMonth;

  /// No description provided for @reportColAttacks.
  ///
  /// In en, this message translates to:
  /// **'Attacks'**
  String get reportColAttacks;

  /// No description provided for @reportColAttackDays.
  ///
  /// In en, this message translates to:
  /// **'Attack days'**
  String get reportColAttackDays;

  /// No description provided for @reportColMeanIntensity.
  ///
  /// In en, this message translates to:
  /// **'Mean intensity'**
  String get reportColMeanIntensity;

  /// No description provided for @reportColAcuteDays.
  ///
  /// In en, this message translates to:
  /// **'Acute days'**
  String get reportColAcuteDays;

  /// No description provided for @reportColNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get reportColNote;

  /// No description provided for @reportOveruseWatch.
  ///
  /// In en, this message translates to:
  /// **'10+ acute days'**
  String get reportOveruseWatch;

  /// No description provided for @reportOveruseHigh.
  ///
  /// In en, this message translates to:
  /// **'15+ acute days'**
  String get reportOveruseHigh;

  /// No description provided for @reportSectionCalendar.
  ///
  /// In en, this message translates to:
  /// **'Attack calendar'**
  String get reportSectionCalendar;

  /// No description provided for @reportCalendarHint.
  ///
  /// In en, this message translates to:
  /// **'One cell per day. Shaded cells had an attack; the number is the highest intensity that day.'**
  String get reportCalendarHint;

  /// No description provided for @reportSectionDuration.
  ///
  /// In en, this message translates to:
  /// **'Attack duration'**
  String get reportSectionDuration;

  /// No description provided for @reportDurationNone.
  ///
  /// In en, this message translates to:
  /// **'No ended attacks in this period.'**
  String get reportDurationNone;

  /// No description provided for @reportDurationSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} ended attacks. Shortest {shortest}, median {median}, longest {longest}.'**
  String reportDurationSummary(
    int count,
    String shortest,
    String median,
    String longest,
  );

  /// No description provided for @reportBucketUnderFour.
  ///
  /// In en, this message translates to:
  /// **'Under 4 h'**
  String get reportBucketUnderFour;

  /// No description provided for @reportBucketFourToTwelve.
  ///
  /// In en, this message translates to:
  /// **'4 to 12 h'**
  String get reportBucketFourToTwelve;

  /// No description provided for @reportBucketTwelveToDay.
  ///
  /// In en, this message translates to:
  /// **'12 to 24 h'**
  String get reportBucketTwelveToDay;

  /// No description provided for @reportBucketOneToThreeDays.
  ///
  /// In en, this message translates to:
  /// **'1 to 3 days'**
  String get reportBucketOneToThreeDays;

  /// No description provided for @reportBucketOverThreeDays.
  ///
  /// In en, this message translates to:
  /// **'Over 3 days'**
  String get reportBucketOverThreeDays;

  /// No description provided for @reportSectionTriggers.
  ///
  /// In en, this message translates to:
  /// **'Factors in the person\'s log'**
  String get reportSectionTriggers;

  /// No description provided for @reportTriggersHint.
  ///
  /// In en, this message translates to:
  /// **'Ratio of attacks after days with the factor to the person\'s usual rate, with the number of exposure days behind it. Below {floor} exposure days the ratio is not shown.'**
  String reportTriggersHint(int floor);

  /// No description provided for @reportTriggersNone.
  ///
  /// In en, this message translates to:
  /// **'Not enough logged days yet to compare factors.'**
  String get reportTriggersNone;

  /// No description provided for @reportColFactor.
  ///
  /// In en, this message translates to:
  /// **'Factor'**
  String get reportColFactor;

  /// No description provided for @reportColRatio.
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get reportColRatio;

  /// No description provided for @reportColExposures.
  ///
  /// In en, this message translates to:
  /// **'Exposure days'**
  String get reportColExposures;

  /// No description provided for @reportColFollowed.
  ///
  /// In en, this message translates to:
  /// **'Followed by attack'**
  String get reportColFollowed;

  /// No description provided for @reportColConfidence.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get reportColConfidence;

  /// No description provided for @reportConfidenceLow.
  ///
  /// In en, this message translates to:
  /// **'low'**
  String get reportConfidenceLow;

  /// No description provided for @reportConfidenceMedium.
  ///
  /// In en, this message translates to:
  /// **'moderate'**
  String get reportConfidenceMedium;

  /// No description provided for @reportConfidenceHigh.
  ///
  /// In en, this message translates to:
  /// **'good'**
  String get reportConfidenceHigh;

  /// No description provided for @reportSectionMedications.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get reportSectionMedications;

  /// No description provided for @reportMedicationsNone.
  ///
  /// In en, this message translates to:
  /// **'No doses logged in this period.'**
  String get reportMedicationsNone;

  /// No description provided for @reportColMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get reportColMedication;

  /// No description provided for @reportColKind.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get reportColKind;

  /// No description provided for @reportColDoses.
  ///
  /// In en, this message translates to:
  /// **'Doses'**
  String get reportColDoses;

  /// No description provided for @reportColDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get reportColDays;

  /// No description provided for @reportColRelief.
  ///
  /// In en, this message translates to:
  /// **'Relief at 2 h (none / partial / full)'**
  String get reportColRelief;

  /// No description provided for @reportKindAcute.
  ///
  /// In en, this message translates to:
  /// **'acute'**
  String get reportKindAcute;

  /// No description provided for @reportKindPreventive.
  ///
  /// In en, this message translates to:
  /// **'preventive'**
  String get reportKindPreventive;

  /// No description provided for @reportSectionWeather.
  ///
  /// In en, this message translates to:
  /// **'Air pressure'**
  String get reportSectionWeather;

  /// No description provided for @reportWeatherHint.
  ///
  /// In en, this message translates to:
  /// **'A fall is a drop of {pressure} or more over 24 h at the time of the entry.'**
  String reportWeatherHint(String pressure);

  /// No description provided for @reportWeatherNone.
  ///
  /// In en, this message translates to:
  /// **'No weather snapshots in this period.'**
  String get reportWeatherNone;

  /// No description provided for @reportWeatherAttacks.
  ///
  /// In en, this message translates to:
  /// **'{fall} of {total} attacks began after a pressure fall.'**
  String reportWeatherAttacks(int fall, int total);

  /// No description provided for @reportWeatherDays.
  ///
  /// In en, this message translates to:
  /// **'{fall} of {total} check-in days had one.'**
  String reportWeatherDays(int fall, int total);

  /// No description provided for @reportWeatherLift.
  ///
  /// In en, this message translates to:
  /// **'Ratio: {lift}x (1.0 means no relation).'**
  String reportWeatherLift(String lift);

  /// No description provided for @reportSectionSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms and head locations'**
  String get reportSectionSymptoms;

  /// No description provided for @reportSymptomsNone.
  ///
  /// In en, this message translates to:
  /// **'No symptoms or locations logged.'**
  String get reportSymptomsNone;

  /// No description provided for @reportCountOfAttacks.
  ///
  /// In en, this message translates to:
  /// **'{name}: {count} of {total} attacks'**
  String reportCountOfAttacks(String name, int count, int total);

  /// No description provided for @reportHoursShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String reportHoursShort(String hours);

  /// No description provided for @notifTypeQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'Three-month questionnaires'**
  String get notifTypeQuestionnaire;

  /// No description provided for @notifTypeQuestionnaireHint.
  ///
  /// In en, this message translates to:
  /// **'MIDAS and HIT-6, three months after the last round'**
  String get notifTypeQuestionnaireHint;

  /// No description provided for @notifQuestionnaireTitle.
  ///
  /// In en, this message translates to:
  /// **'Three months since your last questionnaires'**
  String get notifQuestionnaireTitle;

  /// No description provided for @notifQuestionnaireBody.
  ///
  /// In en, this message translates to:
  /// **'Fill in MIDAS and HIT-6 again to see how the last quarter compares.'**
  String get notifQuestionnaireBody;

  /// No description provided for @questionnairesTitle.
  ///
  /// In en, this message translates to:
  /// **'Questionnaires'**
  String get questionnairesTitle;

  /// No description provided for @settingsQuestionnairesHint.
  ///
  /// In en, this message translates to:
  /// **'MIDAS and HIT-6, scored and charted'**
  String get settingsQuestionnairesHint;

  /// No description provided for @questionnairesIntro.
  ///
  /// In en, this message translates to:
  /// **'Two short, validated questionnaires about the last three months. Repeat them every quarter and the scores are charted here and can go into the doctor report.'**
  String get questionnairesIntro;

  /// No description provided for @questionnaireMidasTitle.
  ///
  /// In en, this message translates to:
  /// **'MIDAS'**
  String get questionnaireMidasTitle;

  /// No description provided for @questionnaireMidasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Migraine Disability Assessment: five day counts over the last three months'**
  String get questionnaireMidasSubtitle;

  /// No description provided for @questionnaireHit6Title.
  ///
  /// In en, this message translates to:
  /// **'HIT-6'**
  String get questionnaireHit6Title;

  /// No description provided for @questionnaireHit6Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Headache Impact Test: six questions on how headaches affect your life'**
  String get questionnaireHit6Subtitle;

  /// No description provided for @questionnaireNeverDone.
  ///
  /// In en, this message translates to:
  /// **'Not filled in yet'**
  String get questionnaireNeverDone;

  /// No description provided for @questionnaireLatest.
  ///
  /// In en, this message translates to:
  /// **'Last score {score} on {date}'**
  String questionnaireLatest(int score, String date);

  /// No description provided for @questionnaireDueNow.
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get questionnaireDueNow;

  /// No description provided for @questionnaireDueOn.
  ///
  /// In en, this message translates to:
  /// **'Next round {date}'**
  String questionnaireDueOn(String date);

  /// No description provided for @questionnaireStart.
  ///
  /// In en, this message translates to:
  /// **'Fill in'**
  String get questionnaireStart;

  /// No description provided for @questionnaireRepeat.
  ///
  /// In en, this message translates to:
  /// **'Fill in again'**
  String get questionnaireRepeat;

  /// No description provided for @questionnaireHistory.
  ///
  /// In en, this message translates to:
  /// **'Score history'**
  String get questionnaireHistory;

  /// No description provided for @questionnaireChartLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} scores from {first} to {last}, latest {latest}'**
  String questionnaireChartLabel(
    int count,
    String first,
    String last,
    int latest,
  );

  /// No description provided for @questionnaireAbout.
  ///
  /// In en, this message translates to:
  /// **'About the scores'**
  String get questionnaireAbout;

  /// No description provided for @questionnaireAboutBody.
  ///
  /// In en, this message translates to:
  /// **'MIDAS adds up five day counts: 0 to 5 is grade I (little or no disability), 6 to 10 grade II (mild), 11 to 20 grade III (moderate), 21 and over grade IV (severe). HIT-6 gives 6, 8, 10, 11 or 13 points per answer, 36 to 78 in all: up to 49 is little or no impact, 50 to 55 some impact, 56 to 59 substantial impact, 60 and over severe impact. The bands are the published ones; the scores are for you and your clinician to discuss.'**
  String get questionnaireAboutBody;

  /// No description provided for @questionnaireMidasIntro.
  ///
  /// In en, this message translates to:
  /// **'Think about the last three months. Count days; a day counts once per question.'**
  String get questionnaireMidasIntro;

  /// No description provided for @questionnaireMidasQ1.
  ///
  /// In en, this message translates to:
  /// **'On how many days did you miss work or school because of your headaches?'**
  String get questionnaireMidasQ1;

  /// No description provided for @questionnaireMidasQ2.
  ///
  /// In en, this message translates to:
  /// **'On how many days was your productivity at work or school reduced by half or more because of your headaches? (Do not count days you missed.)'**
  String get questionnaireMidasQ2;

  /// No description provided for @questionnaireMidasQ3.
  ///
  /// In en, this message translates to:
  /// **'On how many days did you not do household work because of your headaches?'**
  String get questionnaireMidasQ3;

  /// No description provided for @questionnaireMidasQ4.
  ///
  /// In en, this message translates to:
  /// **'On how many days was your productivity in household work reduced by half or more because of your headaches? (Do not count days you did none.)'**
  String get questionnaireMidasQ4;

  /// No description provided for @questionnaireMidasQ5.
  ///
  /// In en, this message translates to:
  /// **'On how many days did you miss family, social or leisure activities because of your headaches?'**
  String get questionnaireMidasQ5;

  /// No description provided for @questionnaireMidasA.
  ///
  /// In en, this message translates to:
  /// **'On how many days did you have a headache? (If a headache lasted more than one day, count each day.)'**
  String get questionnaireMidasA;

  /// No description provided for @questionnaireMidasB.
  ///
  /// In en, this message translates to:
  /// **'On a scale of 0 to 10, on average how painful were these headaches? (0 = no pain, 10 = pain as bad as it can be)'**
  String get questionnaireMidasB;

  /// No description provided for @questionnaireMidasUnscored.
  ///
  /// In en, this message translates to:
  /// **'Not part of the score'**
  String get questionnaireMidasUnscored;

  /// No description provided for @questionnaireDaysField.
  ///
  /// In en, this message translates to:
  /// **'Days (0 to 90)'**
  String get questionnaireDaysField;

  /// No description provided for @questionnairePainField.
  ///
  /// In en, this message translates to:
  /// **'Pain (0 to 10)'**
  String get questionnairePainField;

  /// No description provided for @questionnaireDaysError.
  ///
  /// In en, this message translates to:
  /// **'Enter a number from 0 to {max}'**
  String questionnaireDaysError(int max);

  /// No description provided for @questionnaireHit6Intro.
  ///
  /// In en, this message translates to:
  /// **'Think about the last four weeks and pick the answer that fits best for each question.'**
  String get questionnaireHit6Intro;

  /// No description provided for @questionnaireHit6Q1.
  ///
  /// In en, this message translates to:
  /// **'When you have headaches, how often is the pain severe?'**
  String get questionnaireHit6Q1;

  /// No description provided for @questionnaireHit6Q2.
  ///
  /// In en, this message translates to:
  /// **'How often do headaches limit your ability to do usual daily activities, including household work, work, school or social activities?'**
  String get questionnaireHit6Q2;

  /// No description provided for @questionnaireHit6Q3.
  ///
  /// In en, this message translates to:
  /// **'When you have a headache, how often do you wish you could lie down?'**
  String get questionnaireHit6Q3;

  /// No description provided for @questionnaireHit6Q4.
  ///
  /// In en, this message translates to:
  /// **'In the past four weeks, how often have you felt too tired to do work or daily activities because of your headaches?'**
  String get questionnaireHit6Q4;

  /// No description provided for @questionnaireHit6Q5.
  ///
  /// In en, this message translates to:
  /// **'In the past four weeks, how often have you felt fed up or irritated because of your headaches?'**
  String get questionnaireHit6Q5;

  /// No description provided for @questionnaireHit6Q6.
  ///
  /// In en, this message translates to:
  /// **'In the past four weeks, how often did headaches limit your ability to concentrate on work or daily activities?'**
  String get questionnaireHit6Q6;

  /// No description provided for @questionnaireOptionNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get questionnaireOptionNever;

  /// No description provided for @questionnaireOptionRarely.
  ///
  /// In en, this message translates to:
  /// **'Rarely'**
  String get questionnaireOptionRarely;

  /// No description provided for @questionnaireOptionSometimes.
  ///
  /// In en, this message translates to:
  /// **'Sometimes'**
  String get questionnaireOptionSometimes;

  /// No description provided for @questionnaireOptionVeryOften.
  ///
  /// In en, this message translates to:
  /// **'Very often'**
  String get questionnaireOptionVeryOften;

  /// No description provided for @questionnaireOptionAlways.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get questionnaireOptionAlways;

  /// No description provided for @questionnaireSave.
  ///
  /// In en, this message translates to:
  /// **'Save and score'**
  String get questionnaireSave;

  /// No description provided for @questionnaireIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Answer every scored question to save.'**
  String get questionnaireIncomplete;

  /// No description provided for @questionnaireResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Your score: {score}'**
  String questionnaireResultTitle(int score);

  /// No description provided for @questionnaireResultDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get questionnaireResultDone;

  /// No description provided for @questionnaireResultDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'A score describes the last three months as you remember them. It is a starting point for a conversation with your clinician, not a medical assessment.'**
  String get questionnaireResultDisclaimer;

  /// No description provided for @questionnaireMidasBandMinimal.
  ///
  /// In en, this message translates to:
  /// **'Grade I: little or no disability'**
  String get questionnaireMidasBandMinimal;

  /// No description provided for @questionnaireMidasBandMild.
  ///
  /// In en, this message translates to:
  /// **'Grade II: mild disability'**
  String get questionnaireMidasBandMild;

  /// No description provided for @questionnaireMidasBandModerate.
  ///
  /// In en, this message translates to:
  /// **'Grade III: moderate disability'**
  String get questionnaireMidasBandModerate;

  /// No description provided for @questionnaireMidasBandSevere.
  ///
  /// In en, this message translates to:
  /// **'Grade IV: severe disability'**
  String get questionnaireMidasBandSevere;

  /// No description provided for @questionnaireHit6BandMinimal.
  ///
  /// In en, this message translates to:
  /// **'Little or no impact'**
  String get questionnaireHit6BandMinimal;

  /// No description provided for @questionnaireHit6BandMild.
  ///
  /// In en, this message translates to:
  /// **'Some impact'**
  String get questionnaireHit6BandMild;

  /// No description provided for @questionnaireHit6BandModerate.
  ///
  /// In en, this message translates to:
  /// **'Substantial impact'**
  String get questionnaireHit6BandModerate;

  /// No description provided for @questionnaireHit6BandSevere.
  ///
  /// In en, this message translates to:
  /// **'Severe impact'**
  String get questionnaireHit6BandSevere;

  /// No description provided for @reportIncludeQuestionnaires.
  ///
  /// In en, this message translates to:
  /// **'Include questionnaire scores'**
  String get reportIncludeQuestionnaires;

  /// No description provided for @reportIncludeQuestionnairesHint.
  ///
  /// In en, this message translates to:
  /// **'MIDAS and HIT-6 rounds completed in the period'**
  String get reportIncludeQuestionnairesHint;

  /// No description provided for @reportSectionQuestionnaires.
  ///
  /// In en, this message translates to:
  /// **'Questionnaires'**
  String get reportSectionQuestionnaires;

  /// No description provided for @reportQuestionnairesNone.
  ///
  /// In en, this message translates to:
  /// **'No questionnaires completed in this period.'**
  String get reportQuestionnairesNone;

  /// No description provided for @reportColDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get reportColDate;

  /// No description provided for @reportColQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire'**
  String get reportColQuestionnaire;

  /// No description provided for @reportColScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get reportColScore;

  /// No description provided for @reportColBand.
  ///
  /// In en, this message translates to:
  /// **'Band'**
  String get reportColBand;

  /// No description provided for @voiceButton.
  ///
  /// In en, this message translates to:
  /// **'Log by voice'**
  String get voiceButton;

  /// No description provided for @voiceListening.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get voiceListening;

  /// No description provided for @voiceListeningHint.
  ///
  /// In en, this message translates to:
  /// **'Say how it feels, for example: pain seven out of ten, behind my eyes, nausea, took ibuprofen.'**
  String get voiceListeningHint;

  /// No description provided for @voiceStop.
  ///
  /// In en, this message translates to:
  /// **'Done talking'**
  String get voiceStop;

  /// No description provided for @voiceCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get voiceCancel;

  /// No description provided for @voiceTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get voiceTryAgain;

  /// No description provided for @voiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice is not available on this phone. Speech recognition needs microphone permission and an offline speech pack for your language.'**
  String get voiceUnavailable;

  /// No description provided for @voiceNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Nothing was heard. Try again closer to the phone, or tap the fields instead.'**
  String get voiceNoMatch;

  /// No description provided for @voiceReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Check before saving'**
  String get voiceReviewTitle;

  /// No description provided for @voiceHeard.
  ///
  /// In en, this message translates to:
  /// **'Heard: “{text}”'**
  String voiceHeard(String text);

  /// No description provided for @voiceNothingUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Nothing on the form matched what was said. Tap the fields instead, or try again.'**
  String get voiceNothingUnderstood;

  /// No description provided for @voiceIntensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get voiceIntensity;

  /// No description provided for @voiceIntensityNone.
  ///
  /// In en, this message translates to:
  /// **'Not said'**
  String get voiceIntensityNone;

  /// No description provided for @voiceSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get voiceSymptoms;

  /// No description provided for @voiceLocations.
  ///
  /// In en, this message translates to:
  /// **'Where it hurts'**
  String get voiceLocations;

  /// No description provided for @voiceMedications.
  ///
  /// In en, this message translates to:
  /// **'Medication taken now'**
  String get voiceMedications;

  /// No description provided for @voiceSave.
  ///
  /// In en, this message translates to:
  /// **'Save to attack'**
  String get voiceSave;

  /// No description provided for @widgetLevel.
  ///
  /// In en, this message translates to:
  /// **'Level: {level}'**
  String widgetLevel(String level);

  /// No description provided for @widgetNoLevel.
  ///
  /// In en, this message translates to:
  /// **'Open the app to load today\'s level'**
  String get widgetNoLevel;

  /// No description provided for @widgetDriver.
  ///
  /// In en, this message translates to:
  /// **'Top factor: {factor}'**
  String widgetDriver(String factor);

  /// No description provided for @widgetNoDriver.
  ///
  /// In en, this message translates to:
  /// **'No single factor stands out'**
  String get widgetNoDriver;

  /// No description provided for @widgetPressureFalling.
  ///
  /// In en, this message translates to:
  /// **'Pressure falling {pressure} in 24 h'**
  String widgetPressureFalling(String pressure);

  /// No description provided for @widgetPressureRising.
  ///
  /// In en, this message translates to:
  /// **'Pressure rising {pressure} in 24 h'**
  String widgetPressureRising(String pressure);

  /// No description provided for @widgetPressureSteady.
  ///
  /// In en, this message translates to:
  /// **'Pressure steady'**
  String get widgetPressureSteady;

  /// No description provided for @widgetPressureUnknown.
  ///
  /// In en, this message translates to:
  /// **'No pressure forecast yet'**
  String get widgetPressureUnknown;

  /// No description provided for @widgetUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String widgetUpdated(String time);

  /// No description provided for @widgetStartAttack.
  ///
  /// In en, this message translates to:
  /// **'Start attack'**
  String get widgetStartAttack;

  /// No description provided for @widgetOpenAttack.
  ///
  /// In en, this message translates to:
  /// **'Open attack'**
  String get widgetOpenAttack;

  /// No description provided for @watchStart.
  ///
  /// In en, this message translates to:
  /// **'Start attack'**
  String get watchStart;

  /// No description provided for @watchStop.
  ///
  /// In en, this message translates to:
  /// **'End attack'**
  String get watchStop;

  /// No description provided for @watchIntensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get watchIntensity;

  /// No description provided for @watchSince.
  ///
  /// In en, this message translates to:
  /// **'Since {time}'**
  String watchSince(String time);

  /// No description provided for @watchPending.
  ///
  /// In en, this message translates to:
  /// **'Saved on the watch. Sends when your phone is near.'**
  String get watchPending;

  /// No description provided for @watchNoPhone.
  ///
  /// In en, this message translates to:
  /// **'Open the app on your phone once to connect the watch.'**
  String get watchNoPhone;

  /// No description provided for @routinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Self-care routines'**
  String get routinesTitle;

  /// No description provided for @routinesIntro.
  ///
  /// In en, this message translates to:
  /// **'Simple things many people find helpful on hard days. Use what suits you and skip the rest.'**
  String get routinesIntro;

  /// No description provided for @routineCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Something that may help today'**
  String get routineCardTitle;

  /// No description provided for @routineNotToday.
  ///
  /// In en, this message translates to:
  /// **'Not today'**
  String get routineNotToday;

  /// No description provided for @routineSeeAll.
  ///
  /// In en, this message translates to:
  /// **'All routines'**
  String get routineSeeAll;

  /// No description provided for @routineStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to'**
  String get routineStepsTitle;

  /// No description provided for @routineReasonHighDay.
  ///
  /// In en, this message translates to:
  /// **'Today\'s level is high'**
  String get routineReasonHighDay;

  /// No description provided for @routineReasonNeckTension.
  ///
  /// In en, this message translates to:
  /// **'Your check-in shows neck tension'**
  String get routineReasonNeckTension;

  /// No description provided for @routineReasonStress.
  ///
  /// In en, this message translates to:
  /// **'Your check-in shows high stress'**
  String get routineReasonStress;

  /// No description provided for @routineStretchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle neck and shoulder stretches'**
  String get routineStretchesTitle;

  /// No description provided for @routineStretchesSummary.
  ///
  /// In en, this message translates to:
  /// **'Five slow movements to ease tightness in your neck and shoulders. Stop if anything hurts.'**
  String get routineStretchesSummary;

  /// One step per line.
  ///
  /// In en, this message translates to:
  /// **'Sit tall with your shoulders relaxed and your feet flat.\nSlowly tilt your right ear towards your right shoulder. Hold for 15 seconds, then switch sides.\nLower your chin towards your chest and hold for 15 seconds.\nRoll your shoulders backwards five times, then forwards five times.\nClasp your hands behind your back and gently open your chest for 15 seconds.'**
  String get routineStretchesSteps;

  /// No description provided for @routineBreathingTitle.
  ///
  /// In en, this message translates to:
  /// **'Paced breathing'**
  String get routineBreathingTitle;

  /// No description provided for @routineBreathingSummary.
  ///
  /// In en, this message translates to:
  /// **'Breathe in for 4 seconds and out for 6, for about a minute. A slow out-breath helps many people settle.'**
  String get routineBreathingSummary;

  /// One step per line.
  ///
  /// In en, this message translates to:
  /// **'Sit or lie down somewhere comfortable.\nBreathe in through your nose while the circle grows.\nBreathe out slowly while it shrinks.\nKeep going for six rounds, or for as long as feels good.'**
  String get routineBreathingSteps;

  /// No description provided for @routineLowLightTitle.
  ///
  /// In en, this message translates to:
  /// **'Low light and quiet'**
  String get routineLowLightTitle;

  /// No description provided for @routineLowLightSummary.
  ///
  /// In en, this message translates to:
  /// **'Bright light and noise bother many people on sensitive days and during an attack.'**
  String get routineLowLightSummary;

  /// One step per line.
  ///
  /// In en, this message translates to:
  /// **'Dim the lights or close the curtains.\nTurn on dark mode and lower your screen brightness.\nWear an eye mask or sunglasses if light still bothers you.\nCut down noise with earplugs or a quiet room.'**
  String get routineLowLightSteps;

  /// No description provided for @routineHydrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Drink some water'**
  String get routineHydrationTitle;

  /// No description provided for @routineHydrationSummary.
  ///
  /// In en, this message translates to:
  /// **'Keeping water within reach makes it easier to drink through the day.'**
  String get routineHydrationSummary;

  /// One step per line.
  ///
  /// In en, this message translates to:
  /// **'Keep a glass or bottle of water within reach.\nTake a few sips every hour.\nHave a glass of water with each meal.'**
  String get routineHydrationSteps;

  /// No description provided for @routineCaffeineTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep caffeine steady'**
  String get routineCaffeineTitle;

  /// No description provided for @routineCaffeineSummary.
  ///
  /// In en, this message translates to:
  /// **'Big changes in how much caffeine you have can matter for some people.'**
  String get routineCaffeineSummary;

  /// One step per line.
  ///
  /// In en, this message translates to:
  /// **'Have caffeine at about the same times each day.\nAvoid big increases, and avoid suddenly skipping your usual amount.\nHave your last caffeinated drink by early afternoon.'**
  String get routineCaffeineSteps;

  /// No description provided for @routineSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Steady sleep'**
  String get routineSleepTitle;

  /// No description provided for @routineSleepSummary.
  ///
  /// In en, this message translates to:
  /// **'A regular sleep schedule, weekends included, helps many people.'**
  String get routineSleepSummary;

  /// One step per line.
  ///
  /// In en, this message translates to:
  /// **'Go to bed and get up at about the same time every day.\nKeep the bedroom dark, quiet and cool.\nPut screens away 30 minutes before bed.\nAvoid long naps late in the day.'**
  String get routineSleepSteps;

  /// No description provided for @breathingStart.
  ///
  /// In en, this message translates to:
  /// **'Start breathing'**
  String get breathingStart;

  /// No description provided for @breathingStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get breathingStop;

  /// No description provided for @breathingIn.
  ///
  /// In en, this message translates to:
  /// **'Breathe in'**
  String get breathingIn;

  /// No description provided for @breathingOut.
  ///
  /// In en, this message translates to:
  /// **'Breathe out'**
  String get breathingOut;

  /// No description provided for @breathingRound.
  ///
  /// In en, this message translates to:
  /// **'Round {round} of {total}'**
  String breathingRound(int round, int total);

  /// No description provided for @breathingDone.
  ///
  /// In en, this message translates to:
  /// **'Done. Take a moment before you get up.'**
  String get breathingDone;

  /// No description provided for @settingsRoutinesHint.
  ///
  /// In en, this message translates to:
  /// **'Stretches, breathing and other simple routines'**
  String get settingsRoutinesHint;

  /// No description provided for @experimentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Experiments'**
  String get experimentsTitle;

  /// No description provided for @settingsExperimentsHint.
  ///
  /// In en, this message translates to:
  /// **'Try one change for two weeks and compare'**
  String get settingsExperimentsHint;

  /// No description provided for @experimentsIntro.
  ///
  /// In en, this message translates to:
  /// **'Try one change for two weeks and compare it with the two weeks before. One experiment at a time.'**
  String get experimentsIntro;

  /// No description provided for @experimentsPick.
  ///
  /// In en, this message translates to:
  /// **'Pick one change'**
  String get experimentsPick;

  /// No description provided for @experimentChangeCutCaffeine.
  ///
  /// In en, this message translates to:
  /// **'Cut back on caffeine'**
  String get experimentChangeCutCaffeine;

  /// No description provided for @experimentChangeRegularSleep.
  ///
  /// In en, this message translates to:
  /// **'Go to bed at the same time every night'**
  String get experimentChangeRegularSleep;

  /// No description provided for @experimentChangeMoreWater.
  ///
  /// In en, this message translates to:
  /// **'Drink more water'**
  String get experimentChangeMoreWater;

  /// No description provided for @experimentChangeDailyStretches.
  ///
  /// In en, this message translates to:
  /// **'Stretch your neck every day'**
  String get experimentChangeDailyStretches;

  /// No description provided for @experimentChangeLessScreens.
  ///
  /// In en, this message translates to:
  /// **'Less screen time in the evening'**
  String get experimentChangeLessScreens;

  /// No description provided for @experimentChangeNoAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Skip alcohol'**
  String get experimentChangeNoAlcohol;

  /// No description provided for @experimentDay.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of {total}'**
  String experimentDay(int day, int total);

  /// No description provided for @experimentAdherenceQuestion.
  ///
  /// In en, this message translates to:
  /// **'Did you stick with it today?'**
  String get experimentAdherenceQuestion;

  /// No description provided for @experimentYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get experimentYes;

  /// No description provided for @experimentNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get experimentNo;

  /// No description provided for @experimentAdherence.
  ///
  /// In en, this message translates to:
  /// **'Kept to it on {kept} of {days} days'**
  String experimentAdherence(int kept, int days);

  /// No description provided for @experimentCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'Two weeks before and during'**
  String get experimentCompareTitle;

  /// No description provided for @experimentBefore.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get experimentBefore;

  /// No description provided for @experimentDuring.
  ///
  /// In en, this message translates to:
  /// **'During'**
  String get experimentDuring;

  /// No description provided for @experimentRowRate.
  ///
  /// In en, this message translates to:
  /// **'Attacks per week'**
  String get experimentRowRate;

  /// No description provided for @experimentRowIntensity.
  ///
  /// In en, this message translates to:
  /// **'Average intensity'**
  String get experimentRowIntensity;

  /// No description provided for @experimentRowDuration.
  ///
  /// In en, this message translates to:
  /// **'Median duration'**
  String get experimentRowDuration;

  /// No description provided for @experimentSample.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no attacks} =1{from 1 attack} other{from {count} attacks}}'**
  String experimentSample(int count);

  /// No description provided for @experimentDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String experimentDays(int count);

  /// No description provided for @experimentNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get experimentNoData;

  /// No description provided for @experimentCaveat.
  ///
  /// In en, this message translates to:
  /// **'Two weeks is short. Weather, seasons and stress change on their own, so read this as a hint, not proof.'**
  String get experimentCaveat;

  /// No description provided for @experimentSmallSample.
  ///
  /// In en, this message translates to:
  /// **'Fewer than {min} attacks in one of the periods, so the numbers can swing a lot.'**
  String experimentSmallSample(int min);

  /// No description provided for @experimentStop.
  ///
  /// In en, this message translates to:
  /// **'Stop experiment'**
  String get experimentStop;

  /// No description provided for @experimentFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish and save the result'**
  String get experimentFinish;

  /// No description provided for @experimentDue.
  ///
  /// In en, this message translates to:
  /// **'The two weeks are over.'**
  String get experimentDue;

  /// No description provided for @experimentPast.
  ///
  /// In en, this message translates to:
  /// **'Past experiments'**
  String get experimentPast;

  /// No description provided for @experimentFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished {date}'**
  String experimentFinished(String date);

  /// No description provided for @experimentStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped {date}'**
  String experimentStopped(String date);

  /// No description provided for @experimentPastSummary.
  ///
  /// In en, this message translates to:
  /// **'{before} attacks per week before, {during} during'**
  String experimentPastSummary(String before, String during);

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @settingsAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Only needed for backup and share links'**
  String get settingsAccountHint;

  /// No description provided for @accountIntro.
  ///
  /// In en, this message translates to:
  /// **'An account is optional. Everything in the app works without one, and your entries stay on this phone. You only need one for encrypted backup and share links.'**
  String get accountIntro;

  /// No description provided for @accountUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Accounts aren\'t set up in this build.'**
  String get accountUnavailable;

  /// No description provided for @accountApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get accountApple;

  /// No description provided for @accountGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get accountGoogle;

  /// No description provided for @accountOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Or use your email'**
  String get accountOrEmail;

  /// No description provided for @accountEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountEmail;

  /// No description provided for @accountPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get accountPassword;

  /// No description provided for @accountPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'At least {min} characters for a new account'**
  String accountPasswordHint(int min);

  /// No description provided for @accountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get accountSignIn;

  /// No description provided for @accountCreate.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get accountCreate;

  /// No description provided for @accountForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get accountForgot;

  /// No description provided for @accountResetSent.
  ///
  /// In en, this message translates to:
  /// **'If that email has an account, a reset link is on its way.'**
  String get accountResetSent;

  /// No description provided for @accountSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String accountSignedInAs(String email);

  /// No description provided for @accountSignedInWith.
  ///
  /// In en, this message translates to:
  /// **'Signed in with {method}'**
  String accountSignedInWith(String method);

  /// No description provided for @accountMethodApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get accountMethodApple;

  /// No description provided for @accountMethodGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get accountMethodGoogle;

  /// No description provided for @accountMethodEmail.
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get accountMethodEmail;

  /// No description provided for @accountSignedInNote.
  ///
  /// In en, this message translates to:
  /// **'Your entries still live on this phone. Signing out deletes nothing.'**
  String get accountSignedInNote;

  /// No description provided for @accountSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get accountSignOut;

  /// No description provided for @accountDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get accountDelete;

  /// No description provided for @accountDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get accountDeleteTitle;

  /// No description provided for @accountDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This deletes your account. Within {hours} hours your encrypted backup and any share links are removed from our servers. Everything on this phone stays.'**
  String accountDeleteBody(int hours);

  /// No description provided for @accountDeletePassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to confirm'**
  String get accountDeletePassword;

  /// No description provided for @accountDeleteSubscription.
  ///
  /// In en, this message translates to:
  /// **'A Premium subscription is billed by the App Store or Google Play. Deleting the account does not cancel it; cancel it in the store.'**
  String get accountDeleteSubscription;

  /// No description provided for @accountDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Keep account'**
  String get accountDeleteCancel;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted. Its server data will be gone within {hours} hours.'**
  String accountDeleted(int hours);

  /// No description provided for @accountErrorWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'That email and password don\'t match.'**
  String get accountErrorWrongCredentials;

  /// No description provided for @accountErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'That email already has an account. Try signing in instead.'**
  String get accountErrorEmailInUse;

  /// No description provided for @accountErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a longer password.'**
  String get accountErrorWeakPassword;

  /// No description provided for @accountErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Check the email address.'**
  String get accountErrorInvalidEmail;

  /// No description provided for @accountErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection. Try again when you\'re online.'**
  String get accountErrorNetwork;

  /// No description provided for @accountErrorRecentSignIn.
  ///
  /// In en, this message translates to:
  /// **'For your safety, sign in again, then try once more.'**
  String get accountErrorRecentSignIn;

  /// No description provided for @accountErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get accountErrorUnknown;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted backup'**
  String get backupTitle;

  /// No description provided for @settingsBackupHint.
  ///
  /// In en, this message translates to:
  /// **'Locked with a passphrase only you know'**
  String get settingsBackupHint;

  /// No description provided for @backupIntro.
  ///
  /// In en, this message translates to:
  /// **'Your backup is locked on this phone with your passphrase before it is uploaded. We store only the locked file and cannot open it.'**
  String get backupIntro;

  /// No description provided for @backupForgetWarning.
  ///
  /// In en, this message translates to:
  /// **'If you forget the passphrase, nobody can open the backup, not even us. Write it down somewhere safe.'**
  String get backupForgetWarning;

  /// No description provided for @backupNeedsAccount.
  ///
  /// In en, this message translates to:
  /// **'Backup needs an account. Everything else works without one.'**
  String get backupNeedsAccount;

  /// No description provided for @backupOpenAccount.
  ///
  /// In en, this message translates to:
  /// **'Set up an account'**
  String get backupOpenAccount;

  /// No description provided for @backupNone.
  ///
  /// In en, this message translates to:
  /// **'No backup yet'**
  String get backupNone;

  /// No description provided for @backupLast.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {date}'**
  String backupLast(String date);

  /// No description provided for @backupStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check for a backup right now.'**
  String get backupStatusUnknown;

  /// No description provided for @backupPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get backupPassphrase;

  /// No description provided for @backupPassphraseHint.
  ///
  /// In en, this message translates to:
  /// **'At least {min} characters. A few unrelated words work well.'**
  String backupPassphraseHint(int min);

  /// No description provided for @backupPassphraseRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat the passphrase to back up'**
  String get backupPassphraseRepeat;

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backupNow;

  /// No description provided for @backupDone.
  ///
  /// In en, this message translates to:
  /// **'Backed up.'**
  String get backupDone;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get backupRestore;

  /// No description provided for @backupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace everything on this phone?'**
  String get backupRestoreTitle;

  /// No description provided for @backupRestoreBody.
  ///
  /// In en, this message translates to:
  /// **'Everything on this phone is replaced with the backup from {date}.'**
  String backupRestoreBody(String date);

  /// No description provided for @backupRestoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupRestoreConfirm;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Restored from your backup.'**
  String get backupRestored;

  /// No description provided for @backupDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete backup'**
  String get backupDelete;

  /// No description provided for @backupDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete the backup?'**
  String get backupDeleteTitle;

  /// No description provided for @backupDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'The locked file is removed from our servers. Everything on this phone stays.'**
  String get backupDeleteBody;

  /// No description provided for @backupDeleted.
  ///
  /// In en, this message translates to:
  /// **'Backup deleted.'**
  String get backupDeleted;

  /// No description provided for @backupWorking.
  ///
  /// In en, this message translates to:
  /// **'Working on it. This can take a few seconds.'**
  String get backupWorking;

  /// No description provided for @backupErrorMismatch.
  ///
  /// In en, this message translates to:
  /// **'The two passphrases don\'t match.'**
  String get backupErrorMismatch;

  /// No description provided for @backupErrorShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least {min} characters.'**
  String backupErrorShort(int min);

  /// No description provided for @backupErrorNoBackup.
  ///
  /// In en, this message translates to:
  /// **'There\'s no backup on this account yet.'**
  String get backupErrorNoBackup;

  /// No description provided for @backupErrorTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The backup is too large to upload.'**
  String get backupErrorTooLarge;

  /// No description provided for @backupErrorNewerApp.
  ///
  /// In en, this message translates to:
  /// **'This backup was made by a newer version of the app. Update the app, then try again.'**
  String get backupErrorNewerApp;

  /// No description provided for @backupErrorWrongPassphrase.
  ///
  /// In en, this message translates to:
  /// **'That passphrase doesn\'t open this backup.'**
  String get backupErrorWrongPassphrase;

  /// No description provided for @backupErrorDamaged.
  ///
  /// In en, this message translates to:
  /// **'The backup file is damaged.'**
  String get backupErrorDamaged;

  /// No description provided for @backupErrorPinning.
  ///
  /// In en, this message translates to:
  /// **'The connection to the backup server couldn\'t be verified, so nothing was sent. Try another network.'**
  String get backupErrorPinning;

  /// No description provided for @backupErrorNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Your sign-in has expired. Sign in again, then retry.'**
  String get backupErrorNotAllowed;

  /// No description provided for @shareLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Share as a web link'**
  String get shareLinkButton;

  /// No description provided for @shareLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Share with your clinician'**
  String get shareLinkTitle;

  /// No description provided for @shareLinkExplain.
  ///
  /// In en, this message translates to:
  /// **'Anyone with the link can read this report until it expires. It shows the same summary as the PDF, not your diary. You can stop sharing at any time.'**
  String get shareLinkExplain;

  /// No description provided for @shareLinkNeedsAccount.
  ///
  /// In en, this message translates to:
  /// **'Sharing a link needs an account. The PDF and CSV work without one.'**
  String get shareLinkNeedsAccount;

  /// No description provided for @shareLinkDuration.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day} other{{days} days}}'**
  String shareLinkDuration(int days);

  /// No description provided for @shareLinkCreate.
  ///
  /// In en, this message translates to:
  /// **'Create link'**
  String get shareLinkCreate;

  /// No description provided for @shareLinkWorking.
  ///
  /// In en, this message translates to:
  /// **'Creating the link.'**
  String get shareLinkWorking;

  /// No description provided for @shareLinkReady.
  ///
  /// In en, this message translates to:
  /// **'Link ready. Shared until {date}.'**
  String shareLinkReady(String date);

  /// No description provided for @shareLinkCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get shareLinkCopy;

  /// No description provided for @shareLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied.'**
  String get shareLinkCopied;

  /// No description provided for @shareLinkShare.
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get shareLinkShare;

  /// No description provided for @shareLinkMessage.
  ///
  /// In en, this message translates to:
  /// **'My migraine report: {url}'**
  String shareLinkMessage(String url);

  /// No description provided for @shareLinksTitle.
  ///
  /// In en, this message translates to:
  /// **'Shared links'**
  String get shareLinksTitle;

  /// No description provided for @settingsShareLinksHint.
  ///
  /// In en, this message translates to:
  /// **'See and stop the report links you shared'**
  String get settingsShareLinksHint;

  /// No description provided for @shareLinksEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t shared any links. Create one from Doctor report.'**
  String get shareLinksEmpty;

  /// No description provided for @shareLinkActiveUntil.
  ///
  /// In en, this message translates to:
  /// **'Shared until {date}'**
  String shareLinkActiveUntil(String date);

  /// No description provided for @shareLinkExpiredOn.
  ///
  /// In en, this message translates to:
  /// **'Expired {date}'**
  String shareLinkExpiredOn(String date);

  /// No description provided for @shareLinkRevoked.
  ///
  /// In en, this message translates to:
  /// **'Sharing stopped'**
  String get shareLinkRevoked;

  /// No description provided for @shareLinkCreatedOn.
  ///
  /// In en, this message translates to:
  /// **'Created {date}'**
  String shareLinkCreatedOn(String date);

  /// No description provided for @shareLinkRevoke.
  ///
  /// In en, this message translates to:
  /// **'Stop sharing'**
  String get shareLinkRevoke;

  /// No description provided for @shareLinkRevokeTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop sharing this report?'**
  String get shareLinkRevokeTitle;

  /// No description provided for @shareLinkRevokeBody.
  ///
  /// In en, this message translates to:
  /// **'The link stops working at once, for everyone who has it.'**
  String get shareLinkRevokeBody;

  /// No description provided for @shareLinkRevokedDone.
  ///
  /// In en, this message translates to:
  /// **'Sharing stopped. The link no longer works.'**
  String get shareLinkRevokedDone;

  /// No description provided for @shareLinkErrorUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Share links aren\'t set up in this build.'**
  String get shareLinkErrorUnavailable;

  /// No description provided for @shareLinkErrorSignedOut.
  ///
  /// In en, this message translates to:
  /// **'Your sign-in has expired. Sign in again, then retry.'**
  String get shareLinkErrorSignedOut;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumTitle;

  /// No description provided for @premiumIntro.
  ///
  /// In en, this message translates to:
  /// **'Premium adds four extras. Everything else stays free, with no time limit.'**
  String get premiumIntro;

  /// No description provided for @premiumFreeNote.
  ///
  /// In en, this message translates to:
  /// **'Always free: logging attacks and check-ins, the weather feed, the risk level, insights, the medication log and the doctor report.'**
  String get premiumFreeNote;

  /// No description provided for @premiumFeatureShareLink.
  ///
  /// In en, this message translates to:
  /// **'Clinician share link'**
  String get premiumFeatureShareLink;

  /// No description provided for @premiumFeatureShareLinkHint.
  ///
  /// In en, this message translates to:
  /// **'Send your report as a web link that stops working after 7 or 30 days.'**
  String get premiumFeatureShareLinkHint;

  /// No description provided for @premiumFeatureExperiments.
  ///
  /// In en, this message translates to:
  /// **'Experiments'**
  String get premiumFeatureExperiments;

  /// No description provided for @premiumFeatureExperimentsHint.
  ///
  /// In en, this message translates to:
  /// **'Try one change for two weeks and compare it with the weeks before.'**
  String get premiumFeatureExperimentsHint;

  /// No description provided for @premiumFeatureExtendedFactors.
  ///
  /// In en, this message translates to:
  /// **'Extended environment factors'**
  String get premiumFeatureExtendedFactors;

  /// No description provided for @premiumFeatureExtendedFactorsHint.
  ///
  /// In en, this message translates to:
  /// **'Particulates, ozone and pollen by type.'**
  String get premiumFeatureExtendedFactorsHint;

  /// No description provided for @premiumFeatureBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup across phones'**
  String get premiumFeatureBackup;

  /// No description provided for @premiumFeatureBackupHint.
  ///
  /// In en, this message translates to:
  /// **'An encrypted backup you can restore on a new phone.'**
  String get premiumFeatureBackupHint;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium is on.'**
  String get premiumActive;

  /// No description provided for @premiumRenews.
  ///
  /// In en, this message translates to:
  /// **'Renews on {date}.'**
  String premiumRenews(String date);

  /// No description provided for @premiumEnds.
  ///
  /// In en, this message translates to:
  /// **'Ends on {date}.'**
  String premiumEnds(String date);

  /// No description provided for @premiumManage.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get premiumManage;

  /// No description provided for @premiumOfferMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly, {price}'**
  String premiumOfferMonthly(String price);

  /// No description provided for @premiumOfferAnnual.
  ///
  /// In en, this message translates to:
  /// **'Yearly, {price}'**
  String premiumOfferAnnual(String price);

  /// No description provided for @premiumOfferOther.
  ///
  /// In en, this message translates to:
  /// **'{price}'**
  String premiumOfferOther(String price);

  /// No description provided for @premiumRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get premiumRestore;

  /// No description provided for @premiumRestoredNone.
  ///
  /// In en, this message translates to:
  /// **'No Premium purchase was found for this store account.'**
  String get premiumRestoredNone;

  /// No description provided for @premiumThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you. Premium is on.'**
  String get premiumThanks;

  /// No description provided for @premiumRenewalTerms.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions renew automatically until you cancel in the store\'s settings. Cancel at least 24 hours before the renewal date to avoid the next charge.'**
  String get premiumRenewalTerms;

  /// No description provided for @premiumLoadingOffers.
  ///
  /// In en, this message translates to:
  /// **'Loading prices.'**
  String get premiumLoadingOffers;

  /// No description provided for @premiumNoOffers.
  ///
  /// In en, this message translates to:
  /// **'Prices couldn\'t be loaded. Check the connection and try again.'**
  String get premiumNoOffers;

  /// No description provided for @premiumRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get premiumRetry;

  /// No description provided for @premiumUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Purchases aren\'t set up in this build.'**
  String get premiumUnavailable;

  /// No description provided for @premiumDevUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Development build: every Premium feature is unlocked.'**
  String get premiumDevUnlocked;

  /// No description provided for @premiumAccountTip.
  ///
  /// In en, this message translates to:
  /// **'Using more than one phone? Sign in first, so Premium follows your account.'**
  String get premiumAccountTip;

  /// No description provided for @premiumErrorNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This store account can\'t make purchases.'**
  String get premiumErrorNotAllowed;

  /// No description provided for @premiumErrorPending.
  ///
  /// In en, this message translates to:
  /// **'The purchase is waiting for approval. Premium turns on once it goes through.'**
  String get premiumErrorPending;

  /// No description provided for @premiumErrorStore.
  ///
  /// In en, this message translates to:
  /// **'The store had a problem. Try again later.'**
  String get premiumErrorStore;

  /// No description provided for @premiumLockTitle.
  ///
  /// In en, this message translates to:
  /// **'{feature} comes with Premium.'**
  String premiumLockTitle(String feature);

  /// No description provided for @premiumLockButton.
  ///
  /// In en, this message translates to:
  /// **'See Premium'**
  String get premiumLockButton;

  /// No description provided for @premiumLockShareLinkNote.
  ///
  /// In en, this message translates to:
  /// **'Links you already made keep working until they end, and you can stop sharing them at any time.'**
  String get premiumLockShareLinkNote;

  /// No description provided for @premiumLockExperimentsNote.
  ///
  /// In en, this message translates to:
  /// **'Your past results stay here.'**
  String get premiumLockExperimentsNote;

  /// No description provided for @premiumLockBackupNote.
  ///
  /// In en, this message translates to:
  /// **'You can still restore or delete a backup you already have.'**
  String get premiumLockBackupNote;

  /// No description provided for @premiumFactorsLocked.
  ///
  /// In en, this message translates to:
  /// **'Particulates, ozone and pollen come with Premium.'**
  String get premiumFactorsLocked;

  /// No description provided for @settingsPremiumHint.
  ///
  /// In en, this message translates to:
  /// **'Share link, experiments, extended factors and backup'**
  String get settingsPremiumHint;

  /// No description provided for @settingsPremiumActive.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsPremiumActive;

  /// No description provided for @shareLinkErrorPremium.
  ///
  /// In en, this message translates to:
  /// **'Share links need Premium. If you just subscribed, wait a minute and try again.'**
  String get shareLinkErrorPremium;

  /// No description provided for @auditTitle.
  ///
  /// In en, this message translates to:
  /// **'How the risk level has done'**
  String get auditTitle;

  /// No description provided for @auditNotYet.
  ///
  /// In en, this message translates to:
  /// **'This page appears once you have logged {needed} attacks. You have logged {logged} so far.'**
  String auditNotYet(int needed, int logged);

  /// No description provided for @auditIntro.
  ///
  /// In en, this message translates to:
  /// **'This compares the level the app showed each day with when your attacks started. An attack counts as following a High day when the day it started, or the {window, plural, =1{day} other{{window} days}} before, was shown as High.'**
  String auditIntro(int window);

  /// No description provided for @auditEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to compare yet. The app keeps the level it shows each day from now on, and the first numbers appear after your next attack or High day.'**
  String get auditEmpty;

  /// No description provided for @auditHitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Attacks that followed a High day'**
  String get auditHitsTitle;

  /// No description provided for @auditHitsValue.
  ///
  /// In en, this message translates to:
  /// **'{hits} of {attacks} ({share})'**
  String auditHitsValue(int hits, int attacks, String share);

  /// No description provided for @auditMissesTitle.
  ///
  /// In en, this message translates to:
  /// **'Attacks without a High day before them'**
  String get auditMissesTitle;

  /// No description provided for @auditMissesValue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 attack} other{{count} attacks}}'**
  String auditMissesValue(int count);

  /// No description provided for @auditFalseAlarmsTitle.
  ///
  /// In en, this message translates to:
  /// **'High days with no attack'**
  String get auditFalseAlarmsTitle;

  /// No description provided for @auditFalseAlarmsValue.
  ///
  /// In en, this message translates to:
  /// **'{count} of {highDays} High days'**
  String auditFalseAlarmsValue(int count, int highDays);

  /// No description provided for @auditTrend.
  ///
  /// In en, this message translates to:
  /// **'By month'**
  String get auditTrend;

  /// No description provided for @auditMonthLine.
  ///
  /// In en, this message translates to:
  /// **'{hits} of {attacks} attacks after a High day; {falseAlarms} of {highDays} High days without an attack'**
  String auditMonthLine(int hits, int attacks, int falseAlarms, int highDays);

  /// No description provided for @auditCaveat.
  ///
  /// In en, this message translates to:
  /// **'Small numbers move a lot from month to month. A High day without an attack is not a mistake: it means more of your usual triggers lined up. The level is a guide to plan around, not a promise.'**
  String get auditCaveat;

  /// No description provided for @auditShare.
  ///
  /// In en, this message translates to:
  /// **'Share these counts each month'**
  String get auditShare;

  /// No description provided for @auditShareHint.
  ///
  /// In en, this message translates to:
  /// **'Helps check the app for everyone. Only the five numbers and the model version are sent, never dates, places, your log or your account. Off unless you turn it on.'**
  String get auditShareHint;

  /// No description provided for @settingsAuditHint.
  ///
  /// In en, this message translates to:
  /// **'Attacks after High days and High days without one'**
  String get settingsAuditHint;

  /// No description provided for @unitHpa.
  ///
  /// In en, this message translates to:
  /// **'{value} hPa'**
  String unitHpa(String value);

  /// No description provided for @unitInHg.
  ///
  /// In en, this message translates to:
  /// **'{value} inHg'**
  String unitInHg(String value);

  /// No description provided for @unitMmHg.
  ///
  /// In en, this message translates to:
  /// **'{value} mmHg'**
  String unitMmHg(String value);

  /// No description provided for @unitCelsius.
  ///
  /// In en, this message translates to:
  /// **'{value} °C'**
  String unitCelsius(String value);

  /// No description provided for @unitFahrenheit.
  ///
  /// In en, this message translates to:
  /// **'{value} °F'**
  String unitFahrenheit(String value);

  /// No description provided for @unitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get unitsTitle;

  /// No description provided for @settingsUnitsHint.
  ///
  /// In en, this message translates to:
  /// **'Pressure and temperature'**
  String get settingsUnitsHint;

  /// No description provided for @unitsPressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get unitsPressure;

  /// No description provided for @unitsTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get unitsTemperature;

  /// No description provided for @unitNameHpa.
  ///
  /// In en, this message translates to:
  /// **'Hectopascals (hPa)'**
  String get unitNameHpa;

  /// No description provided for @unitNameInHg.
  ///
  /// In en, this message translates to:
  /// **'Inches of mercury (inHg)'**
  String get unitNameInHg;

  /// No description provided for @unitNameMmHg.
  ///
  /// In en, this message translates to:
  /// **'Millimetres of mercury (mmHg)'**
  String get unitNameMmHg;

  /// No description provided for @unitNameCelsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius (°C)'**
  String get unitNameCelsius;

  /// No description provided for @unitNameFahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit (°F)'**
  String get unitNameFahrenheit;

  /// No description provided for @unitsNote.
  ///
  /// In en, this message translates to:
  /// **'The first choice comes from your phone\'s region. Changing it only changes how values are shown; your log stays the same.'**
  String get unitsNote;

  /// No description provided for @envTemperatureNow.
  ///
  /// In en, this message translates to:
  /// **'Temperature now: {temperature}'**
  String envTemperatureNow(String temperature);

  /// No description provided for @questionnaireEnglishNote.
  ///
  /// In en, this message translates to:
  /// **'The questions are shown in their original English wording until a validated translation is added, so your scores stay comparable.'**
  String get questionnaireEnglishNote;

  /// No description provided for @wellnessDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'General wellness information, not medical advice. Talk to your clinician about treatment.'**
  String get wellnessDisclaimer;

  /// No description provided for @dataSourceWeather.
  ///
  /// In en, this message translates to:
  /// **'Open-Meteo weather'**
  String get dataSourceWeather;

  /// No description provided for @dataSourceAirQuality.
  ///
  /// In en, this message translates to:
  /// **'Open-Meteo air quality and UV (CAMS)'**
  String get dataSourceAirQuality;

  /// No description provided for @dataSourcePollen.
  ///
  /// In en, this message translates to:
  /// **'Open-Meteo pollen (CAMS)'**
  String get dataSourcePollen;

  /// No description provided for @dataSourceGeocoding.
  ///
  /// In en, this message translates to:
  /// **'Open-Meteo geocoding'**
  String get dataSourceGeocoding;

  /// No description provided for @dataSourceBarometer.
  ///
  /// In en, this message translates to:
  /// **'Device barometer'**
  String get dataSourceBarometer;

  /// No description provided for @dataCoverageWorldwide.
  ///
  /// In en, this message translates to:
  /// **'Worldwide'**
  String get dataCoverageWorldwide;

  /// No description provided for @dataCoverageEuropeanAqi.
  ///
  /// In en, this message translates to:
  /// **'Worldwide, European AQI in Europe'**
  String get dataCoverageEuropeanAqi;

  /// No description provided for @dataCoverageEurope.
  ///
  /// In en, this message translates to:
  /// **'Europe only'**
  String get dataCoverageEurope;

  /// No description provided for @dataCoverageBarometer.
  ///
  /// In en, this message translates to:
  /// **'Phones with a pressure sensor'**
  String get dataCoverageBarometer;

  /// No description provided for @settingsReduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get settingsReduceMotion;

  /// No description provided for @settingsReduceMotionHint.
  ///
  /// In en, this message translates to:
  /// **'Fewer animations, even when your phone\'s setting is off'**
  String get settingsReduceMotionHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'XA':
            return AppLocalizationsEnXa();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
