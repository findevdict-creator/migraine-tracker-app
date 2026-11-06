import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Fallback app title; the live title comes from AppIdentity.
  ///
  /// In en, this message translates to:
  /// **'Migraine Tracker'**
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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
