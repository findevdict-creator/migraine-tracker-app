// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Migraine Tracker';

  @override
  String get homeEmptyState =>
      'अभी तक कुछ दर्ज नहीं किया गया।\nआपका जोखिम स्तर और आसपास का मौसम यहाँ दिखेगा।';

  @override
  String get riskLevelLow => 'कम';

  @override
  String get riskLevelModerate => 'मध्यम';

  @override
  String get riskLevelHigh => 'ज़्यादा';

  @override
  String get devThemeGalleryTitle => 'थीम गैलरी';

  @override
  String get devThemeLight => 'हल्की थीम';

  @override
  String get devThemeDark => 'गहरी थीम';

  @override
  String get devThemeAttack => 'अटैक थीम';

  @override
  String get devSampleBody =>
      'डिफ़ॉल्ट आकार का मुख्य टेक्स्ट। 200% टेक्स्ट आकार पर भी यह बिना कटे पढ़ने योग्य रहना चाहिए।';

  @override
  String get devSamplePrimary => 'मुख्य';

  @override
  String get devSampleSecondary => 'द्वितीयक';

  @override
  String get devSampleText => 'टेक्स्ट';

  @override
  String get devSampleDisabled => 'बंद';

  @override
  String get devSampleChipOn => 'ऑरा';

  @override
  String get devSampleChipOff => 'मतली';

  @override
  String get devSampleChipIcon => 'रोशनी';

  @override
  String get devSampleSlider => 'तीव्रता';

  @override
  String get devSampleSliderLow => 'कोई दर्द नहीं';

  @override
  String get devSampleSliderHigh => 'सबसे बुरा';

  @override
  String get devSampleCard => 'बैज वाला एक कार्ड';

  @override
  String get attackStart => 'अटैक शुरू करें';

  @override
  String get attackContinue => 'अटैक जारी रखें';

  @override
  String get attackTitleRunning => 'अटैक चल रहा है';

  @override
  String get attackTitleEnded => 'अटैक';

  @override
  String attackStartedAt(String time) {
    return '$time बजे शुरू हुआ';
  }

  @override
  String get attackNotFound => 'यह अटैक अब मौजूद नहीं है।';

  @override
  String get attackIntensity => 'दर्द की तीव्रता';

  @override
  String get durationEstimateTitle => 'ऐसे अटैक आमतौर पर कितनी देर रहते हैं';

  @override
  String durationEstimateRange(String low, String high) {
    return 'आमतौर पर $low से $high घंटे';
  }

  @override
  String durationEstimateSameMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'मिलती-जुलती तीव्रता और उसी दवा वाले पिछले $count अटैक के आधार पर',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateNoMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'मिलती-जुलती तीव्रता और बिना दवा वाले पिछले $count अटैक के आधार पर',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateSimilar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'मिलती-जुलती तीव्रता वाले पिछले $count अटैक के आधार पर',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपके पिछले $count अटैक के आधार पर',
    );
    return '$_temp0';
  }

  @override
  String get attackIntensityLow => 'कोई दर्द नहीं';

  @override
  String get attackIntensityHigh => 'सबसे बुरा';

  @override
  String get attackWhereItHurts => 'दर्द कहाँ है';

  @override
  String get attackSymptoms => 'लक्षण';

  @override
  String get attackPhases => 'चरण';

  @override
  String get attackNotes => 'नोट्स';

  @override
  String get attackNotesHint => 'याद रखने लायक कोई और बात';

  @override
  String get attackEnd => 'अटैक खत्म करें';

  @override
  String get attackDone => 'हो गया';

  @override
  String get attackFinishLater => 'बाद में पूरा करें';

  @override
  String get symptomAura => 'ऑरा';

  @override
  String get symptomNeckTension => 'गर्दन में अकड़न';

  @override
  String get symptomLightSensitivity => 'रोशनी';

  @override
  String get symptomSoundSensitivity => 'आवाज़';

  @override
  String get symptomSmellSensitivity => 'गंध';

  @override
  String get symptomNausea => 'मतली';

  @override
  String get phaseProdrome => 'प्रोड्रोम';

  @override
  String get phaseAura => 'ऑरा';

  @override
  String get phaseAttack => 'अटैक';

  @override
  String get phasePostdrome => 'पोस्टड्रोम';

  @override
  String get headForehead => 'माथा';

  @override
  String get headLeftTemple => 'बाईं कनपटी';

  @override
  String get headRightTemple => 'दाईं कनपटी';

  @override
  String get headBehindEyes => 'आँखों के पीछे';

  @override
  String get headLeftSide => 'बायाँ हिस्सा';

  @override
  String get headRightSide => 'दायाँ हिस्सा';

  @override
  String get headTopOfHead => 'सिर का ऊपरी हिस्सा';

  @override
  String get headBackOfHead => 'सिर का पिछला हिस्सा';

  @override
  String get headNeck => 'गर्दन';

  @override
  String get checkinTitle => 'रोज़ का चेक-इन';

  @override
  String get checkinLoadError => 'यह दिन लोड नहीं हो सका।';

  @override
  String get checkinIntro => 'तीन टैप। दिन कैसा रहा?';

  @override
  String get checkinComplete =>
      'इस दिन का हो गया। बदलने के लिए किसी नंबर पर टैप करें।';

  @override
  String get checkinAddMore => 'और जोड़ें (वैकल्पिक)';

  @override
  String get checkinOptionalTitle => 'वैकल्पिक';

  @override
  String get checkinDone => 'हो गया';

  @override
  String get checkinToday => 'आज';

  @override
  String get checkinSleepQuality => 'नींद की गुणवत्ता';

  @override
  String get checkinStress => 'तनाव';

  @override
  String get checkinNeckTension => 'गर्दन में अकड़न';

  @override
  String get checkinCaffeine => 'कैफ़ीन';

  @override
  String get checkinHydration => 'पानी';

  @override
  String get checkinAlcohol => 'शराब';

  @override
  String get checkinLightExposure => 'तेज़ रोशनी';

  @override
  String get checkinScreenExposure => 'स्क्रीन टाइम';

  @override
  String get checkinSleepLow => 'खराब';

  @override
  String get checkinSleepHigh => 'बहुत अच्छी';

  @override
  String get checkinStressLow => 'शांत';

  @override
  String get checkinStressHigh => 'बहुत तनाव';

  @override
  String get checkinNeckLow => 'ढीली';

  @override
  String get checkinNeckHigh => 'बहुत अकड़ी';

  @override
  String get checkinHydrationLow => 'कम';

  @override
  String get checkinHydrationHigh => 'भरपूर';

  @override
  String get checkinExposureLow => 'कम';

  @override
  String get checkinExposureHigh => 'बहुत';

  @override
  String get checkinNone => 'कुछ नहीं';

  @override
  String checkinCupsOrMore(int count) {
    return '$count+ कप';
  }

  @override
  String checkinDrinksOrMore(int count) {
    return '$count+ ड्रिंक';
  }

  @override
  String checkinValueSemantics(String field, int value, int max) {
    return '$field, $max में से $value';
  }

  @override
  String get checkinReminderTooltip => 'रिमाइंडर का समय';

  @override
  String checkinReminderAt(String time) {
    return '$time बजे रिमाइंडर';
  }

  @override
  String get checkinReminderPickerTitle => 'रोज़ के चेक-इन का रिमाइंडर';

  @override
  String get checkinCardTitle => 'रोज़ का चेक-इन';

  @override
  String get checkinCardDone => 'आज का हो गया';

  @override
  String get checkinCardTodo => 'तीन टैप, लगभग 10 सेकंड';

  @override
  String get medicationTitle => 'दवा';

  @override
  String get medicationAdd => 'दवा जोड़ें';

  @override
  String get medicationAddTitle => 'खुराक दर्ज करें';

  @override
  String get medicationName => 'दवा';

  @override
  String get medicationDose => 'खुराक';

  @override
  String get medicationDoseHint => 'जैसे 400 mg';

  @override
  String get medicationKindAcute => 'तुरंत राहत';

  @override
  String get medicationKindPreventive => 'रोकथाम';

  @override
  String medicationTakenAt(String time) {
    return '$time बजे ली';
  }

  @override
  String get medicationLog => 'दर्ज करें';

  @override
  String get medicationDelete => 'हटाएँ';

  @override
  String get medicationThisMonth => 'इस महीने';

  @override
  String get medicationEmpty => 'इस महीने कोई खुराक दर्ज नहीं हुई।';

  @override
  String get medicationReliefQuestion => '2 घंटे बाद राहत?';

  @override
  String get medicationReliefNone => 'नहीं';

  @override
  String get medicationReliefPartial => 'थोड़ी';

  @override
  String get medicationReliefFull => 'पूरी';

  @override
  String medicationAcuteDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'इस महीने तुरंत-राहत दवा के $count दिन',
      one: 'इस महीने तुरंत-राहत दवा का 1 दिन',
      zero: 'इस महीने तुरंत-राहत दवा का कोई दिन नहीं',
    );
    return '$_temp0';
  }

  @override
  String get medicationAcuteDaysHint =>
      'वे दिन जिनमें कम से कम एक तुरंत-राहत खुराक ली गई, हर कैलेंडर महीने में गिने गए।';

  @override
  String medicationOveruseFirstNote(int days) {
    return 'इस महीने तुरंत-राहत दवा के $days दिन हो गए हैं। कई डॉक्टर यह संख्या कम रखने की सलाह देते हैं; इस पर बात करना ठीक रहेगा।';
  }

  @override
  String medicationOveruseSecondNote(int days) {
    return 'इस महीने तुरंत-राहत दवा के $days दिन हो गए हैं। कृपया इस पैटर्न के बारे में अपने डॉक्टर से बात करने पर विचार करें।';
  }

  @override
  String get medicationTalkToClinician => 'अपने डॉक्टर से बात करें';

  @override
  String get cycleTitle => 'मासिक चक्र';

  @override
  String get cycleToggleTitle => 'मेरा चक्र ट्रैक करें';

  @override
  String get cycleToggleSubtitle =>
      'डिफ़ॉल्ट रूप से बंद। चालू होने पर चक्र का दिन हर चेक-इन के साथ रखा जाता है और एक कारक के रूप में इस्तेमाल होता है।';

  @override
  String get cycleNoData =>
      'चक्र का दिन देखने के लिए पीरियड शुरू होने की तारीख दर्ज करें।';

  @override
  String cycleDayAndPhase(int day, String phase) {
    return 'चक्र का दिन $day · $phase';
  }

  @override
  String cycleLength(int days) {
    return '$days दिन के चक्र के आधार पर';
  }

  @override
  String get cyclePeriodStarts => 'पीरियड शुरू होने की तारीखें';

  @override
  String get cycleNoStarts => 'अभी तक कोई दर्ज नहीं।';

  @override
  String get cycleRemoveStart => 'हटाएँ';

  @override
  String get cyclePeriodStartedToday => 'इस दिन पीरियड शुरू हुआ';

  @override
  String get cyclePhaseMenstrual => 'मासिक धर्म';

  @override
  String get cyclePhaseFollicular => 'फ़ॉलिक्युलर';

  @override
  String get cyclePhaseOvulation => 'ओव्यूलेशन के आसपास';

  @override
  String get cyclePhaseLuteal => 'ल्यूटियल';

  @override
  String get settingsTitle => 'सेटिंग';

  @override
  String get settingsSectionDaily => 'रोज़ाना';

  @override
  String get settingsSectionData => 'आपका डेटा';

  @override
  String get settingsSectionAbout => 'जानकारी';

  @override
  String get settingsExportJson => 'JSON के रूप में एक्सपोर्ट करें';

  @override
  String get settingsExportJsonHint =>
      'सभी टेबल एक फ़ाइल में, जिसे आप फिर से इंपोर्ट कर सकते हैं।';

  @override
  String get settingsExportCsv => 'CSV के रूप में एक्सपोर्ट करें';

  @override
  String get settingsExportCsvHint => 'हर टेबल के लिए एक स्प्रेडशीट फ़ाइल।';

  @override
  String get settingsExportEmpty => 'अभी एक्सपोर्ट करने को कुछ नहीं है।';

  @override
  String get settingsDeleteAll => 'सब कुछ मिटाएँ';

  @override
  String get settingsDeleteAllHint =>
      'इस डिवाइस से सारा डेटा हटा देता है। इसे वापस नहीं लिया जा सकता।';

  @override
  String settingsDeleteAllConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'इससे इस डिवाइस से $count रिकॉर्ड मिट जाएँगे। इसे वापस नहीं लिया जा सकता।',
      one: 'इससे इस डिवाइस से 1 रिकॉर्ड मिट जाएगा। इसे वापस नहीं लिया जा सकता।',
      zero: 'अभी कुछ सेव नहीं है। फिर भी मिटाएँ?',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeleteAllButton => 'मिटाएँ';

  @override
  String get settingsCancel => 'रद्द करें';

  @override
  String get settingsDeletedAll => 'सारा डेटा मिटा दिया गया।';

  @override
  String get settingsPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get settingsTerms => 'उपयोग की शर्तें';

  @override
  String get settingsSupport => 'सहायता';

  @override
  String get environmentTitle => 'वातावरण';

  @override
  String get environmentCardTitle => 'दबाव';

  @override
  String get environmentCardEmpty =>
      'अभी मौसम का कोई डेटा सेव नहीं है। अपनी जगह चुनने के लिए टैप करें।';

  @override
  String environmentCardSummary(String pressure, String trend) {
    return '$pressure, $trend';
  }

  @override
  String get envPressureSection => 'वायुदाब';

  @override
  String get envPressureUnknown => 'इस घंटे की कोई रीडिंग नहीं';

  @override
  String get envDelta3h => '3 घं';

  @override
  String get envDelta6h => '6 घं';

  @override
  String get envDelta12h => '12 घं';

  @override
  String get envDelta24h => '24 घं';

  @override
  String get envDeltaUnknown => '–';

  @override
  String get envChartTitle => 'पिछले 48 घंटे और अगले 24';

  @override
  String get envUpdatedNever => 'अभी अपडेट नहीं हुआ';

  @override
  String get envUpdatedJustNow => 'अभी-अभी अपडेट हुआ';

  @override
  String envUpdatedMinutes(int n) {
    return '$n मिनट पहले अपडेट हुआ';
  }

  @override
  String envUpdatedHours(int n) {
    return '$n घंटे पहले अपडेट हुआ';
  }

  @override
  String envUpdatedDays(int n) {
    return '$n दिन पहले अपडेट हुआ';
  }

  @override
  String get envStale =>
      'यह पूर्वानुमान कुछ घंटे पुराना है। ऑनलाइन होने पर यह रिफ़्रेश हो जाएगा।';

  @override
  String get envOffline =>
      'मौसम सेवा से जुड़ नहीं सके। इस डिवाइस पर सेव डेटा दिखाया जा रहा है।';

  @override
  String get envNoData =>
      'अभी मौसम का कोई डेटा सेव नहीं है। दबाव का रुझान देखने के लिए लोकेशन की अनुमति दें या कोई शहर चुनें।';

  @override
  String get envRefresh => 'रिफ़्रेश करें';

  @override
  String get envLocationSection => 'जगह';

  @override
  String get envLocationGps => 'आपकी अनुमानित जगह इस्तेमाल हो रही है';

  @override
  String envLocationManual(String city) {
    return '$city इस्तेमाल हो रहा है';
  }

  @override
  String get envLocationLast => 'आख़िरी ज्ञात इलाका इस्तेमाल हो रहा है';

  @override
  String get envLocationNone => 'कोई जगह सेट नहीं';

  @override
  String get envUseMyLocation => 'मेरी जगह इस्तेमाल करें';

  @override
  String get envChooseCity => 'शहर चुनें';

  @override
  String get envCitySearchTitle => 'शहर चुनें';

  @override
  String get envCitySearchHint => 'शहर का नाम';

  @override
  String get envCityNoResults => 'कोई जगह नहीं मिली';

  @override
  String get envCitySearchFailed =>
      'अभी खोज नहीं हो सकी। अपना कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get envPrivacyNote =>
      'इस डिवाइस से बाहर जाने से पहले आपकी जगह को लगभग 10 km तक गोल कर दिया जाता है।';

  @override
  String get envAttribution => 'मौसम डेटा: Open-Meteo';

  @override
  String get envTrendRising => 'बढ़ रहा है';

  @override
  String get envTrendFalling => 'गिर रहा है';

  @override
  String get envTrendSteady => 'स्थिर';

  @override
  String get envTrendUnknown => 'अभी कोई रुझान नहीं';

  @override
  String get barometerTitle => 'बैरोमीटर';

  @override
  String get barometerOpen => 'बैरोमीटर खोलें';

  @override
  String get barometerNoReading => 'कोई रीडिंग नहीं';

  @override
  String get barometerFromSensor => 'इस डिवाइस के सेंसर से';

  @override
  String get barometerFromStation => 'सबसे नज़दीकी स्टेशन से';

  @override
  String get barometerNoSource =>
      'इस डिवाइस में सेंसर नहीं है और अभी कोई पूर्वानुमान सेव नहीं है';

  @override
  String get barometerCalibrationSection => 'कैलिब्रेशन';

  @override
  String barometerOffset(String offset, int pairs) {
    return '$pairs घंटेवार जोड़ों के आधार पर स्टेशन की तुलना में सेंसर का अंतर $offset।';
  }

  @override
  String barometerNotCalibrated(int pairs) {
    return 'अभी कैलिब्रेट नहीं हुआ। कम से कम $pairs घंटे ऐसे चाहिए जिनमें सेंसर और स्टेशन दोनों का मान हो।';
  }

  @override
  String get barometerTrendSection => 'इस डिवाइस पर पिछले 24 घंटे';

  @override
  String get barometerTrendEmpty =>
      'ऐप खुला रहने पर ही रीडिंग ली जाती हैं। रुझान देखने के लिए बाद में फिर आएँ।';

  @override
  String barometerTrendSamples(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n रीडिंग',
      one: '1 रीडिंग',
    );
    return '$_temp0';
  }

  @override
  String get barometerStampNote =>
      'आप जो भी अटैक शुरू करते हैं, उसमें उस घंटे की सेंसर रीडिंग और स्टेशन का मान दर्ज हो जाता है।';

  @override
  String get envFactorsTitle => 'आज के कारक';

  @override
  String get envFactorsEmpty =>
      'इस इलाके के लिए अभी रोज़ के कारक उपलब्ध नहीं हैं।';

  @override
  String get factorBandLow => 'कम';

  @override
  String get factorBandModerate => 'मध्यम';

  @override
  String get factorBandHigh => 'ज़्यादा';

  @override
  String get factorBandVeryHigh => 'बहुत ज़्यादा';

  @override
  String factorValueWithBand(String value, String band) {
    return '$value ($band)';
  }

  @override
  String get factorAqiUs => 'वायु गुणवत्ता (US AQI)';

  @override
  String get factorAqiEu => 'वायु गुणवत्ता (यूरोपीय AQI)';

  @override
  String get factorParticulates => 'कण PM2.5 / PM10';

  @override
  String factorParticulatesValue(String pm25, String pm10) {
    return '$pm25 / $pm10 µg/m³';
  }

  @override
  String get factorOzone => 'ओज़ोन';

  @override
  String factorMicrograms(String value) {
    return '$value µg/m³';
  }

  @override
  String get factorPollen => 'पराग (केवल यूरोप)';

  @override
  String factorPollenType(String type, String band) {
    return '$type $band';
  }

  @override
  String get pollenAlder => 'एल्डर';

  @override
  String get pollenBirch => 'बर्च';

  @override
  String get pollenGrass => 'घास';

  @override
  String get pollenMugwort => 'मगवर्ट';

  @override
  String get pollenOlive => 'जैतून';

  @override
  String get pollenRagweed => 'रैगवीड';

  @override
  String get factorUvMax => 'UV इंडेक्स, दिन का अधिकतम';

  @override
  String get factorDaylight => 'दिन की रोशनी';

  @override
  String factorDaylightValue(int hours, int minutes) {
    return '$hours घंटे $minutes मिनट';
  }

  @override
  String get factorSun => 'सूर्योदय और सूर्यास्त';

  @override
  String factorSunValue(String sunrise, String sunset) {
    return '$sunrise से $sunset';
  }

  @override
  String get aboutDataTitle => 'डेटा के बारे में';

  @override
  String get aboutDataIntro =>
      'इस ऐप के आँकड़े कहाँ से आते हैं, और हर आँकड़ा क्या बता सकता है और क्या नहीं।';

  @override
  String get aboutDataSources => 'स्रोत';

  @override
  String aboutDataLicence(String coverage, String licence) {
    return '$coverage. लाइसेंस: $licence.';
  }

  @override
  String get aboutDataPrivacy => 'आपके फ़ोन से क्या बाहर जाता है';

  @override
  String get aboutDataPrivacyBody =>
      'सिर्फ़ लगभग 10 km तक गोल की गई जगह, ताकि मौसम सेवा आपके इलाके के लिए जवाब दे सके। आपके अटैक, चेक-इन, दवाएँ और स्वास्थ्य डेटा इसी डिवाइस पर रहते हैं, जब तक आप उनका बैकअप लेना या उन्हें शेयर करना न चुनें।';

  @override
  String get aboutDataLimits => 'सीमाएँ';

  @override
  String get aboutDataLimitsBody =>
      'पूर्वानुमान एक ग्रिड सेल के लिए मॉडल के अनुमान हैं, आपके दरवाज़े पर लिया गया माप नहीं। पराग की जानकारी केवल यूरोप में उपलब्ध है। कुछ इलाकों में वायु गुणवत्ता का डेटा नहीं हो सकता। जिस कारक का आपके इलाके के लिए डेटा नहीं है, वह बस दिखाया नहीं जाता।';

  @override
  String get settingsHealthHint =>
      'आपके हेल्थ ऐप से नींद, दिल की धड़कन, कदम और मासिक चक्र';

  @override
  String get healthTitle => 'स्वास्थ्य डेटा';

  @override
  String healthIntro(String store) {
    return 'चुनें कि $store से क्या पढ़ना है। हर प्रकार का अपना स्विच और अपना कारण है।';
  }

  @override
  String get healthPrivacyNote =>
      'इंपोर्ट किया गया डेटा इसी फ़ोन पर रहता है। इसे कभी अपलोड नहीं किया जाता, बैकअप में भी नहीं, जब तक आप खुद एक्सपोर्ट न करें।';

  @override
  String get healthStoreApple => 'Apple Health';

  @override
  String get healthStoreConnect => 'Health Connect';

  @override
  String healthUnavailable(String store) {
    return '$store इस डिवाइस पर उपलब्ध नहीं है।';
  }

  @override
  String get healthReadSection => 'पढ़ें';

  @override
  String get healthTypeSleep => 'नींद';

  @override
  String get healthReasonSleep =>
      'रात की नींद से आपके रोज़ के चेक-इन में नींद की गुणवत्ता भर देता है, ताकि एक टैप कम हो।';

  @override
  String get healthTypeRestingHr => 'आराम के समय दिल की धड़कन';

  @override
  String get healthReasonRestingHr =>
      'आराम के समय सामान्य से तेज़ धड़कन अटैक से पहले वाले दिन थकान दिखा सकती है।';

  @override
  String get healthTypeHrv => 'दिल की धड़कन में परिवर्तनशीलता';

  @override
  String get healthReasonHrv =>
      'सामान्य से कम परिवर्तनशीलता अक्सर तनाव और कम आराम के साथ आती है।';

  @override
  String get healthTypeSteps => 'कदम';

  @override
  String get healthReasonSteps =>
      'बहुत कम या बहुत ज़्यादा गतिविधि वाले दिनों को अपने अटैक के साथ देखना उपयोगी है।';

  @override
  String get healthTypeFlow => 'मासिक धर्म का प्रवाह';

  @override
  String get healthReasonFlow =>
      'अगर आप चक्र ट्रैकिंग इस्तेमाल करते हैं, तो पीरियड शुरू होने की तारीखें भर देता है।';

  @override
  String healthDenied(String store) {
    return '$store ने अनुमति नहीं दी। आप इसे उसकी अपनी सेटिंग में बदल सकते हैं।';
  }

  @override
  String get healthWriteSection => 'लिखें';

  @override
  String healthWriteHeadaches(String store) {
    return 'सिरदर्द की घटनाएँ $store में लिखें';
  }

  @override
  String get healthWriteHeadachesHint =>
      'हर खत्म हुआ अटैक शुरुआत, अंत और तीव्रता के साथ सिरदर्द के रूप में सेव होता है। और कुछ नहीं लिखा जाता।';

  @override
  String get healthImportSection => 'इंपोर्ट';

  @override
  String get healthImportNow => 'अभी इंपोर्ट करें';

  @override
  String get healthImportNever => 'अभी तक कुछ इंपोर्ट नहीं हुआ';

  @override
  String healthImportLast(String age) {
    return '$age';
  }

  @override
  String get healthImportFailed =>
      'इंपोर्ट पूरा नहीं हुआ। बाद में फिर कोशिश करें।';

  @override
  String healthImportResult(int imported, int prefilled) {
    String _temp0 = intl.Intl.pluralLogic(
      imported,
      locale: localeName,
      other: '$imported नई रीडिंग।',
      one: '1 नई रीडिंग।',
      zero: 'कुछ नया नहीं।',
    );
    String _temp1 = intl.Intl.pluralLogic(
      prefilled,
      locale: localeName,
      other: '$prefilled दिनों की नींद भरी गई।',
      one: '1 दिन की नींद भरी गई।',
      zero: '',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get checkinSourceHealthkit => 'Apple Health से';

  @override
  String get checkinSourceHealthConnect => 'Health Connect से';

  @override
  String get onboardingSkip => 'छोड़ें';

  @override
  String get onboardingNext => 'आगे';

  @override
  String get onboardingFinish => 'पूरा करें';

  @override
  String onboardingStep(int step, int total) {
    return 'चरण $step/$total';
  }

  @override
  String get onboardingWelcomeTitle => 'स्वागत है';

  @override
  String get onboardingLocationTitle => 'आपके इलाके का मौसम';

  @override
  String get onboardingLocationBody =>
      'वायुदाब में बदलाव उन बातों में से है जिन्हें लोग अटैक से पहले सबसे ज़्यादा महसूस करते हैं। इन्हें देखने के लिए अनुमानित जगह की अनुमति दें या कोई शहर चुनें।';

  @override
  String get onboardingLocationNone =>
      'अभी कोई जगह नहीं। आप इसे बाद में वातावरण स्क्रीन से भी सेट कर सकते हैं।';

  @override
  String get onboardingHealthTitle => 'स्वास्थ्य डेटा';

  @override
  String get onboardingHealthBody =>
      'वैकल्पिक। हर प्रकार का अपना स्विच और अपना कारण है। आप इनमें से कोई भी बाद में सेटिंग में बदल सकते हैं।';

  @override
  String get onboardingHealthUnavailable =>
      'इस डिवाइस पर कोई हेल्थ ऐप उपलब्ध नहीं है। आप यह चरण छोड़ सकते हैं।';

  @override
  String get onboardingReminderTitle => 'रोज़ का चेक-इन';

  @override
  String get onboardingReminderBody =>
      'दिन में तीन टैप, लगभग दस सेकंड। रिमाइंडर के लिए समय चुनें।';

  @override
  String get onboardingReminderNote =>
      'सूचनाएँ सेट होने के बाद रिमाइंडर शुरू होंगे। आप किसी भी दिन चेक-इन से समय बदल सकते हैं।';

  @override
  String get explainerTitle => 'स्तर का क्या मतलब है';

  @override
  String get explainerIntro =>
      'हर दिन ऐप आपके अपने इतिहास और आज की स्थितियों से बना एक स्तर दिखाता है।';

  @override
  String get explainerDoesTitle => 'यह क्या करता है';

  @override
  String get explainerDoes1 =>
      'दिखाता है कि आज का मौसम, नींद, तनाव और दिनचर्या आपके पिछले अटैक से पहले के दिनों से कैसे मेल खाते हैं।';

  @override
  String get explainerDoes2 =>
      'आपके अपने रिकॉर्ड से सीखता है, इसलिए आप जितना दर्ज करेंगे, यह उतना सटीक होगा।';

  @override
  String get explainerDoes3 =>
      'यह तय करने में मदद करता है कि आज खुद पर थोड़ा कम दबाव डालने का दिन है या नहीं।';

  @override
  String get explainerDoesNotTitle => 'यह क्या नहीं करता';

  @override
  String get explainerDoesNot1 =>
      'यह अटैक की सूचना नहीं है। ऊँचा स्तर एक पैटर्न है, निश्चितता नहीं, और कम स्तर कोई वादा नहीं।';

  @override
  String get explainerDoesNot2 =>
      'यह चिकित्सकीय राय नहीं है और आपके डॉक्टर की जगह नहीं लेता।';

  @override
  String get explainerDoesNot3 =>
      'यह आपका रिकॉर्ड कहीं नहीं भेजता। स्तर इसी फ़ोन पर निकाला जाता है।';

  @override
  String get riskCardTitle => 'आज का स्तर';

  @override
  String get riskCardEmpty =>
      'अभी कोई स्तर नहीं। चेक-इन जोड़ें या मौसम लोड होने दें।';

  @override
  String get riskScreenTitle => 'आपका स्तर';

  @override
  String get riskWhyTitle => 'क्यों';

  @override
  String get riskNoDrivers => 'कुछ खास नहीं दिखता।';

  @override
  String get riskNextDays => 'अगले दिन';

  @override
  String get riskDayToday => 'आज';

  @override
  String get riskDayTomorrow => 'कल';

  @override
  String riskLoad(String value) {
    return 'भार 100 में से $value';
  }

  @override
  String riskConfidence(String label) {
    return 'भरोसा: $label';
  }

  @override
  String get riskConfidenceLow => 'कम';

  @override
  String get riskConfidenceMedium => 'मध्यम';

  @override
  String get riskConfidenceHigh => 'ज़्यादा';

  @override
  String riskStillLearning(int count, int needed) {
    return 'अभी सीख रहा है: $needed में से $count अटैक दर्ज';
  }

  @override
  String get riskTuned => 'आपके रिकॉर्ड के अनुसार ढला हुआ';

  @override
  String riskDriverPoints(String points) {
    return '$points अंक';
  }

  @override
  String riskUpdated(String time) {
    return '$time अपडेट हुआ';
  }

  @override
  String get riskExplainerLink => 'स्तर का क्या मतलब है';

  @override
  String get riskOpenCheckin => 'आज का चेक-इन जोड़ें';

  @override
  String get riskFactorPressureDrop => 'गिरता वायुदाब';

  @override
  String get riskFactorHumidity => 'ज़्यादा नमी';

  @override
  String get riskFactorTemperatureSwing => 'तापमान में बदलाव';

  @override
  String get riskFactorAirQuality => 'वायु गुणवत्ता';

  @override
  String get riskFactorPollen => 'पराग';

  @override
  String get riskFactorBrightLight => 'तेज़ रोशनी';

  @override
  String get riskFactorScreenTime => 'स्क्रीन टाइम';

  @override
  String get riskFactorPoorSleep => 'खराब नींद';

  @override
  String get riskFactorStress => 'तनाव';

  @override
  String get riskFactorNeckTension => 'गर्दन में अकड़न';

  @override
  String get riskFactorCaffeine => 'कैफ़ीन';

  @override
  String get riskFactorAlcohol => 'शराब';

  @override
  String get riskFactorDehydration => 'पानी कम';

  @override
  String get riskFactorCyclePhase => 'चक्र का चरण';

  @override
  String get loadMeterTitle => 'भार';

  @override
  String loadMeterSemantics(String value, String segments) {
    return 'भार 100 में से $value। $segments';
  }

  @override
  String loadSegmentDetail(String name, String points) {
    return '$name: $points अंक';
  }

  @override
  String loadThresholdModerate(String value) {
    return '$value से मध्यम';
  }

  @override
  String loadThresholdHigh(String value) {
    return '$value से ज़्यादा';
  }

  @override
  String get loadMeterEmpty => 'अभी कोई भार नहीं';

  @override
  String get insightsTitle => 'आपके कारक';

  @override
  String get insightsIntro =>
      'आपके अपने रिकॉर्ड में हर कारक के बाद कितनी बार अटैक आया, आपकी सामान्य दर की तुलना में।';

  @override
  String get insightsTriggers => 'बाद में ज़्यादा अटैक आए';

  @override
  String get insightsProtectors => 'बाद में कम अटैक आए';

  @override
  String get insightsNeutral => 'कोई साफ़ असर नहीं';

  @override
  String get insightsNotEnough => 'अभी पर्याप्त डेटा नहीं';

  @override
  String get insightsEmptyBucket => 'यहाँ अभी कुछ नहीं।';

  @override
  String insightsSample(int days, int attacks) {
    return '$days दिन यह कारक रहा, उनमें से $attacks के बाद अटैक आया';
  }

  @override
  String insightsLift(String ratio) {
    return 'आपकी सामान्य दर का $ratio×';
  }

  @override
  String insightsNeedMore(int days, int needed) {
    return '$needed में से $days दिन दर्ज';
  }

  @override
  String get insightsNoRunYet =>
      'गिनती शुरू करने के लिए एक अटैक दर्ज करें और खत्म करें।';

  @override
  String get insightsMethodLink => 'यह कैसे गिना जाता है';

  @override
  String get insightsMethodTitle => 'यह कैसे गिना जाता है';

  @override
  String insightsMethod1(String pressure) {
    return 'कारक वाला दिन वह दिन है जब कोई कारक आपके रिकॉर्ड या मौसम में मौजूद था, जैसे नींद का जवाब 1 होना या $pressure से ज़्यादा दबाव गिरना।';
  }

  @override
  String get insightsMethod2 =>
      'कोई अटैक किसी दिन के बाद आया माना जाता है जब वह उसी दिन या अगले दिन शुरू हुआ हो, यानी वे 24 से 48 घंटे जिन्हें मॉडल देखता है।';

  @override
  String get insightsMethod3 =>
      'यह अनुपात बताता है कि उस कारक वाले दिनों के बाद कितनी बार अटैक आए, आपके रिकॉर्ड के किसी भी दिन के बाद की तुलना में। 1.5× का मतलब सामान्य दर का डेढ़ गुना; 0.5× का मतलब आधा।';

  @override
  String insightsMethod4(int needed) {
    return 'किसी कारक को छाँटने से पहले $needed दिन चाहिए। तब तक वह \"अभी पर्याप्त डेटा नहीं\" में रहता है। किसी कारक के बाद कम अटैक आना उतना ही काम का है जितना ज़्यादा आना, इसलिए दोनों सूचियों को बराबर जगह मिलती है।';
  }

  @override
  String get insightsMethod5 =>
      'इनमें से कुछ भी कारण नहीं है। कोई कारक किसी ऐसी चीज़ की वजह से सूची में हो सकता है जो उसके साथ आती है, जैसे सप्ताहांत या दवा में बदलाव। सूचियों से तय करें कि क्या आज़माना है, यह नहीं कि किसे दोष देना है।';

  @override
  String get riskInsightsLink => 'आपके कारक';

  @override
  String get settingsInsightsHint =>
      'आपके रिकॉर्ड में किन कारकों के बाद अटैक आए';

  @override
  String get notificationsTitle => 'सूचनाएँ';

  @override
  String get settingsNotificationsHint =>
      'स्तर की सूचनाएँ, दबाव गिरना, रिमाइंडर';

  @override
  String get notificationsIntro =>
      'सब कुछ सेव किए गए पूर्वानुमान और आपके रिकॉर्ड से इसी फ़ोन पर शेड्यूल होता है। जो प्रकार नहीं चाहिए, उसे बंद करें।';

  @override
  String get notificationsPermissionDenied =>
      'सिस्टम सेटिंग में इस ऐप की सूचनाएँ बंद हैं।';

  @override
  String get notifTypeRiskRising => 'स्तर बढ़ रहा है';

  @override
  String get notifTypeRiskRisingHint =>
      'ऊँचे स्तर वाले दिन से पहले की शाम और उसी दिन सुबह';

  @override
  String get notifTypePressureDrop => 'दबाव गिरना';

  @override
  String notifTypePressureDropHint(String pressure) {
    return 'जब पूर्वानुमान में 24 घंटे में $pressure या ज़्यादा गिरावट दिखे';
  }

  @override
  String get notifTypeAttackOver => 'क्या आपका अटैक खत्म हो गया?';

  @override
  String get notifTypeAttackOverHint =>
      'आपके अटैक की सामान्य अवधि पर, खत्म करें बटन के साथ';

  @override
  String get notifTypeCheckin => 'चेक-इन रिमाइंडर';

  @override
  String get notifTypeCheckinHint => 'रोज़ाना में सेट किए गए समय पर';

  @override
  String get notifTypeMedication => 'रोकथाम दवा रिमाइंडर';

  @override
  String get notifTypeMedicationHint => 'रोकथाम वाली खुराक के लिए रोज़ एक याद';

  @override
  String notifPressureThreshold(String pressure) {
    return 'दबाव गिरने की सीमा: 24 घंटे में $pressure';
  }

  @override
  String get notifMedicationTime => 'रोकथाम दवा रिमाइंडर का समय';

  @override
  String notifRiskEveningTitle(String level) {
    return 'कल का स्तर: $level';
  }

  @override
  String notifRiskEveningBody(String level, String driver) {
    return 'कल के लिए आपका स्तर $level है। सूची में सबसे ऊपर: $driver।';
  }

  @override
  String notifRiskMorningTitle(String level) {
    return 'आज का स्तर: $level';
  }

  @override
  String notifRiskMorningBody(String level, String driver) {
    return 'आज आपका स्तर $level है। सूची में सबसे ऊपर: $driver।';
  }

  @override
  String get notifPressureTitle => 'वायुदाब गिर रहा है';

  @override
  String notifPressureBody(String pressure, String time) {
    return '$time तक $pressure की गिरावट की उम्मीद है।';
  }

  @override
  String get notifAttackOverTitle => 'क्या आपका अटैक खत्म हो गया?';

  @override
  String notifAttackOverBody(String duration) {
    return 'यह $duration पहले शुरू हुआ। खत्म हो जाए तो यहाँ बंद करें।';
  }

  @override
  String get notifEndAttackAction => 'अटैक खत्म करें';

  @override
  String get notifCheckinTitle => 'आज के लिए तीन टैप';

  @override
  String get notifCheckinBody => 'नींद, तनाव और गर्दन की अकड़न। पंद्रह सेकंड।';

  @override
  String get notifMedicationTitle => 'रोकथाम वाली खुराक';

  @override
  String get notifMedicationBody =>
      'अगर आप रोकथाम की दवा लेते हैं, तो आज की खुराक का समय हो गया है।';

  @override
  String get notifChannelAlerts => 'सूचनाएँ';

  @override
  String get notifChannelAlertsDescription =>
      'सेव किए गए पूर्वानुमान से स्तर और दबाव की सूचनाएँ';

  @override
  String get notifChannelReminders => 'रिमाइंडर';

  @override
  String get notifChannelRemindersDescription =>
      'चेक-इन और रोकथाम खुराक के रिमाइंडर';

  @override
  String get notifChannelAttack => 'अटैक';

  @override
  String get notifChannelAttackDescription => 'चल रहे अटैक के बारे में सवाल';

  @override
  String get reportTitle => 'डॉक्टर के लिए रिपोर्ट';

  @override
  String get settingsReportHint => 'किसी अवधि के लिए PDF और स्प्रेडशीट';

  @override
  String get reportIntro =>
      'आपने जो दर्ज किया उसका सारांश, अगली मुलाकात के लिए। अवधि चुनें, फिर PDF या स्प्रेडशीट शेयर करें।';

  @override
  String get reportRangeLabel => 'अवधि';

  @override
  String reportRangeDays(int days) {
    return '$days दिन';
  }

  @override
  String get reportRangeCustom => 'अपनी पसंद';

  @override
  String reportRangeText(String from, String to) {
    return '$from से $to';
  }

  @override
  String reportPreviewAttacks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अटैक',
      one: '1 अटैक',
      zero: 'कोई अटैक नहीं',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewAttackDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'अटैक के $count दिन',
      one: 'अटैक का 1 दिन',
      zero: 'अटैक का कोई दिन नहीं',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewDoses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खुराक',
      one: '1 खुराक',
      zero: 'कोई खुराक नहीं',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewCheckins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चेक-इन',
      one: '1 चेक-इन',
      zero: 'कोई चेक-इन नहीं',
    );
    return '$_temp0';
  }

  @override
  String get reportEmpty => 'इस अवधि में अभी कुछ दर्ज नहीं है।';

  @override
  String get reportSharePdf => 'PDF शेयर करें';

  @override
  String get reportShareCsv => 'स्प्रेडशीट शेयर करें';

  @override
  String get reportShareAll => 'सब शेयर करें';

  @override
  String get reportBuilding => 'रिपोर्ट तैयार हो रही है';

  @override
  String get reportFailed => 'रिपोर्ट तैयार नहीं हो सकी। फिर कोशिश करें।';

  @override
  String get reportWhatIsIn => 'PDF में क्या है';

  @override
  String get reportContents =>
      'अटैक कैलेंडर, महीने की गिनती, अवधि, सैंपल साइज़ के साथ कारक, दवा वाले दिन, दबाव में बदलाव, लक्षण और दर्द की जगहें। कोई नाम नहीं, कोई नोट्स नहीं।';

  @override
  String reportPdfTitle(String app) {
    return '$app रिपोर्ट';
  }

  @override
  String reportPdfPeriod(String from, String to, int days) {
    return 'अवधि: $from से $to ($days दिन)';
  }

  @override
  String reportPdfGenerated(String date) {
    return '$date को व्यक्ति के डिवाइस पर उसके अपने रिकॉर्ड से बनाई गई।';
  }

  @override
  String get reportPdfDisclaimer =>
      'यह एक वेलनेस ऐप में खुद भरी गई डायरी का सारांश है। यह मेडिकल रिकॉर्ड नहीं है और क्लिनिकल जाँच की जगह नहीं लेता। कारकों के अनुपात सिर्फ़ इस व्यक्ति के रिकॉर्ड को बताते हैं और कारण नहीं हैं।';

  @override
  String reportPdfPage(int page, int pages) {
    return 'पेज $page/$pages';
  }

  @override
  String get reportSectionOverview => 'सारांश';

  @override
  String get reportStatAttacks => 'अटैक';

  @override
  String get reportStatAttackDays => 'अटैक वाले दिन';

  @override
  String get reportStatPerMonth => 'हर 30 दिन में अटैक';

  @override
  String get reportStatMeanIntensity => 'औसत तीव्रता (0-10)';

  @override
  String get reportStatAcuteDays => 'तुरंत-राहत दवा वाले दिन';

  @override
  String get reportStatCheckins => 'चेक-इन वाले दिन';

  @override
  String get reportSectionMonths => 'महीने के अनुसार';

  @override
  String get reportColMonth => 'महीना';

  @override
  String get reportColAttacks => 'अटैक';

  @override
  String get reportColAttackDays => 'अटैक वाले दिन';

  @override
  String get reportColMeanIntensity => 'औसत तीव्रता';

  @override
  String get reportColAcuteDays => 'तुरंत-राहत दिन';

  @override
  String get reportColNote => 'टिप्पणी';

  @override
  String get reportOveruseWatch => '10+ तुरंत-राहत दिन';

  @override
  String get reportOveruseHigh => '15+ तुरंत-राहत दिन';

  @override
  String get reportSectionCalendar => 'अटैक कैलेंडर';

  @override
  String get reportCalendarHint =>
      'हर दिन के लिए एक खाना। रंगे खानों में अटैक था; संख्या उस दिन की सबसे ज़्यादा तीव्रता है।';

  @override
  String get reportSectionDuration => 'अटैक की अवधि';

  @override
  String get reportDurationNone => 'इस अवधि में कोई खत्म हुआ अटैक नहीं।';

  @override
  String reportDurationSummary(
    int count,
    String shortest,
    String median,
    String longest,
  ) {
    return '$count खत्म हुए अटैक। सबसे छोटा $shortest, माध्यिका $median, सबसे लंबा $longest।';
  }

  @override
  String get reportBucketUnderFour => '4 घंटे से कम';

  @override
  String get reportBucketFourToTwelve => '4 से 12 घंटे';

  @override
  String get reportBucketTwelveToDay => '12 से 24 घंटे';

  @override
  String get reportBucketOneToThreeDays => '1 से 3 दिन';

  @override
  String get reportBucketOverThreeDays => '3 दिन से ज़्यादा';

  @override
  String get reportSectionTriggers => 'व्यक्ति के रिकॉर्ड में कारक';

  @override
  String reportTriggersHint(int floor) {
    return 'कारक वाले दिनों के बाद अटैक का व्यक्ति की सामान्य दर से अनुपात, उसके पीछे के दिनों की संख्या के साथ। $floor दिन से कम होने पर अनुपात नहीं दिखाया जाता।';
  }

  @override
  String get reportTriggersNone =>
      'कारकों की तुलना के लिए अभी पर्याप्त दिन दर्ज नहीं हैं।';

  @override
  String get reportColFactor => 'कारक';

  @override
  String get reportColRatio => 'अनुपात';

  @override
  String get reportColExposures => 'कारक वाले दिन';

  @override
  String get reportColFollowed => 'बाद में अटैक';

  @override
  String get reportColConfidence => 'प्रमाण';

  @override
  String get reportConfidenceLow => 'कम';

  @override
  String get reportConfidenceMedium => 'मध्यम';

  @override
  String get reportConfidenceHigh => 'अच्छा';

  @override
  String get reportSectionMedications => 'दवा';

  @override
  String get reportMedicationsNone => 'इस अवधि में कोई खुराक दर्ज नहीं।';

  @override
  String get reportColMedication => 'दवा';

  @override
  String get reportColKind => 'प्रकार';

  @override
  String get reportColDoses => 'खुराक';

  @override
  String get reportColDays => 'दिन';

  @override
  String get reportColRelief => '2 घंटे पर राहत (नहीं / थोड़ी / पूरी)';

  @override
  String get reportKindAcute => 'तुरंत राहत';

  @override
  String get reportKindPreventive => 'रोकथाम';

  @override
  String get reportSectionWeather => 'वायुदाब';

  @override
  String reportWeatherHint(String pressure) {
    return 'गिरावट का मतलब है दर्ज करते समय 24 घंटे में $pressure या ज़्यादा कमी।';
  }

  @override
  String get reportWeatherNone => 'इस अवधि में मौसम का कोई डेटा नहीं।';

  @override
  String reportWeatherAttacks(int fall, int total) {
    return '$total में से $fall अटैक दबाव गिरने के बाद शुरू हुए।';
  }

  @override
  String reportWeatherDays(int fall, int total) {
    return '$total चेक-इन दिनों में से $fall में गिरावट थी।';
  }

  @override
  String reportWeatherLift(String lift) {
    return 'अनुपात: ${lift}x (1.0 का मतलब कोई संबंध नहीं)।';
  }

  @override
  String get reportSectionSymptoms => 'लक्षण और दर्द की जगहें';

  @override
  String get reportSymptomsNone => 'कोई लक्षण या जगह दर्ज नहीं।';

  @override
  String reportCountOfAttacks(String name, int count, int total) {
    return '$name: $total में से $count अटैक';
  }

  @override
  String reportHoursShort(String hours) {
    return '$hours घं';
  }

  @override
  String get notifTypeQuestionnaire => 'तीन-मासिक प्रश्नावली';

  @override
  String get notifTypeQuestionnaireHint =>
      'पिछली बार के तीन महीने बाद MIDAS और HIT-6';

  @override
  String get notifQuestionnaireTitle => 'पिछली प्रश्नावली को तीन महीने हो गए';

  @override
  String get notifQuestionnaireBody =>
      'पिछली तिमाही की तुलना देखने के लिए MIDAS और HIT-6 फिर से भरें।';

  @override
  String get questionnairesTitle => 'प्रश्नावली';

  @override
  String get settingsQuestionnairesHint =>
      'MIDAS और HIT-6, स्कोर और चार्ट के साथ';

  @override
  String get questionnairesIntro =>
      'पिछले तीन महीनों के बारे में दो छोटी, मान्य प्रश्नावली। इन्हें हर तिमाही दोहराएँ: स्कोर यहाँ चार्ट में दिखते हैं और डॉक्टर की रिपोर्ट में जोड़े जा सकते हैं।';

  @override
  String get questionnaireMidasTitle => 'MIDAS';

  @override
  String get questionnaireMidasSubtitle =>
      'Migraine Disability Assessment: पिछले तीन महीनों के पाँच दिन-गिनती सवाल';

  @override
  String get questionnaireHit6Title => 'HIT-6';

  @override
  String get questionnaireHit6Subtitle =>
      'Headache Impact Test: सिरदर्द आपके जीवन पर कैसे असर डालता है, इस पर छह सवाल';

  @override
  String get questionnaireNeverDone => 'अभी नहीं भरी गई';

  @override
  String questionnaireLatest(int score, String date) {
    return '$date को आख़िरी स्कोर $score';
  }

  @override
  String get questionnaireDueNow => 'अभी भरनी है';

  @override
  String questionnaireDueOn(String date) {
    return 'अगली बार $date';
  }

  @override
  String get questionnaireStart => 'भरें';

  @override
  String get questionnaireRepeat => 'फिर से भरें';

  @override
  String get questionnaireHistory => 'स्कोर का इतिहास';

  @override
  String questionnaireChartLabel(
    int count,
    String first,
    String last,
    int latest,
  ) {
    return '$first से $last तक $count स्कोर, आख़िरी $latest';
  }

  @override
  String get questionnaireAbout => 'स्कोर के बारे में';

  @override
  String get questionnaireAboutBody =>
      'MIDAS पाँच दिन-गिनतियों को जोड़ता है: 0 से 5 ग्रेड I (बहुत कम या कोई अक्षमता नहीं), 6 से 10 ग्रेड II (हल्की), 11 से 20 ग्रेड III (मध्यम), 21 और ऊपर ग्रेड IV (गंभीर)। HIT-6 हर जवाब पर 6, 8, 10, 11 या 13 अंक देता है, कुल 36 से 78: 49 तक बहुत कम या कोई असर नहीं, 50 से 55 कुछ असर, 56 से 59 काफ़ी असर, 60 और ऊपर गंभीर असर। ये प्रकाशित श्रेणियाँ हैं; स्कोर आपके और आपके डॉक्टर के बीच बातचीत के लिए हैं।';

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
  String get questionnaireMidasUnscored => 'स्कोर का हिस्सा नहीं';

  @override
  String get questionnaireDaysField => 'दिन (0 से 90)';

  @override
  String get questionnairePainField => 'दर्द (0 से 10)';

  @override
  String questionnaireDaysError(int max) {
    return '0 से $max तक की संख्या डालें';
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
  String get questionnaireSave => 'सेव करें और स्कोर देखें';

  @override
  String get questionnaireIncomplete =>
      'सेव करने के लिए हर स्कोर वाले सवाल का जवाब दें।';

  @override
  String questionnaireResultTitle(int score) {
    return 'आपका स्कोर: $score';
  }

  @override
  String get questionnaireResultDone => 'हो गया';

  @override
  String get questionnaireResultDisclaimer =>
      'स्कोर पिछले तीन महीनों को वैसे बताता है जैसे आपको याद हैं। यह डॉक्टर से बातचीत की शुरुआत है, चिकित्सकीय जाँच नहीं।';

  @override
  String get questionnaireMidasBandMinimal =>
      'ग्रेड I: बहुत कम या कोई अक्षमता नहीं';

  @override
  String get questionnaireMidasBandMild => 'ग्रेड II: हल्की अक्षमता';

  @override
  String get questionnaireMidasBandModerate => 'ग्रेड III: मध्यम अक्षमता';

  @override
  String get questionnaireMidasBandSevere => 'ग्रेड IV: गंभीर अक्षमता';

  @override
  String get questionnaireHit6BandMinimal => 'बहुत कम या कोई असर नहीं';

  @override
  String get questionnaireHit6BandMild => 'कुछ असर';

  @override
  String get questionnaireHit6BandModerate => 'काफ़ी असर';

  @override
  String get questionnaireHit6BandSevere => 'गंभीर असर';

  @override
  String get reportIncludeQuestionnaires => 'प्रश्नावली के स्कोर शामिल करें';

  @override
  String get reportIncludeQuestionnairesHint =>
      'इस अवधि में पूरी हुई MIDAS और HIT-6';

  @override
  String get reportSectionQuestionnaires => 'प्रश्नावली';

  @override
  String get reportQuestionnairesNone =>
      'इस अवधि में कोई प्रश्नावली पूरी नहीं हुई।';

  @override
  String get reportColDate => 'तारीख';

  @override
  String get reportColQuestionnaire => 'प्रश्नावली';

  @override
  String get reportColScore => 'स्कोर';

  @override
  String get reportColBand => 'श्रेणी';

  @override
  String get voiceButton => 'बोलकर दर्ज करें';

  @override
  String get voiceListening => 'सुन रहा है';

  @override
  String get voiceListeningHint =>
      'बताएँ कि कैसा लग रहा है, जैसे: दर्द दस में से सात, आँखों के पीछे, मतली, आइबुप्रोफ़ेन ली।';

  @override
  String get voiceStop => 'बोल लिया';

  @override
  String get voiceCancel => 'रद्द करें';

  @override
  String get voiceTryAgain => 'फिर कोशिश करें';

  @override
  String get voiceUnavailable =>
      'इस फ़ोन पर आवाज़ उपलब्ध नहीं है। आवाज़ पहचानने के लिए माइक्रोफ़ोन की अनुमति और आपकी भाषा का ऑफ़लाइन स्पीच पैक चाहिए।';

  @override
  String get voiceNoMatch =>
      'कुछ सुनाई नहीं दिया। फ़ोन के पास से फिर कोशिश करें, या खानों पर टैप करें।';

  @override
  String get voiceReviewTitle => 'सेव करने से पहले जाँचें';

  @override
  String voiceHeard(String text) {
    return 'सुना: \"$text\"';
  }

  @override
  String get voiceNothingUnderstood =>
      'जो कहा गया वह फ़ॉर्म से मेल नहीं खाया। खानों पर टैप करें या फिर कोशिश करें।';

  @override
  String get voiceIntensity => 'तीव्रता';

  @override
  String get voiceIntensityNone => 'नहीं बताया';

  @override
  String get voiceSymptoms => 'लक्षण';

  @override
  String get voiceLocations => 'दर्द कहाँ है';

  @override
  String get voiceMedications => 'अभी ली गई दवा';

  @override
  String get voiceSave => 'अटैक में सेव करें';

  @override
  String widgetLevel(String level) {
    return 'स्तर: $level';
  }

  @override
  String get widgetNoLevel => 'आज का स्तर लोड करने के लिए ऐप खोलें';

  @override
  String widgetDriver(String factor) {
    return 'मुख्य कारक: $factor';
  }

  @override
  String get widgetNoDriver => 'कोई एक कारक खास नहीं';

  @override
  String widgetPressureFalling(String pressure) {
    return '24 घंटे में दबाव $pressure गिर रहा है';
  }

  @override
  String widgetPressureRising(String pressure) {
    return '24 घंटे में दबाव $pressure बढ़ रहा है';
  }

  @override
  String get widgetPressureSteady => 'दबाव स्थिर';

  @override
  String get widgetPressureUnknown => 'अभी दबाव का पूर्वानुमान नहीं';

  @override
  String widgetUpdated(String time) {
    return '$time अपडेट हुआ';
  }

  @override
  String get widgetStartAttack => 'अटैक शुरू करें';

  @override
  String get widgetOpenAttack => 'अटैक खोलें';

  @override
  String get watchStart => 'अटैक शुरू करें';

  @override
  String get watchStop => 'अटैक खत्म करें';

  @override
  String get watchIntensity => 'तीव्रता';

  @override
  String watchSince(String time) {
    return '$time से';
  }

  @override
  String get watchPending => 'घड़ी पर सेव हुआ। फ़ोन पास आने पर भेजा जाएगा।';

  @override
  String get watchNoPhone => 'घड़ी जोड़ने के लिए फ़ोन पर एक बार ऐप खोलें।';

  @override
  String get routinesTitle => 'खुद की देखभाल के तरीके';

  @override
  String get routinesIntro =>
      'आसान चीज़ें जो कई लोगों को मुश्किल दिनों में मददगार लगती हैं। जो आपको ठीक लगे वह अपनाएँ, बाकी छोड़ दें।';

  @override
  String get routineCardTitle => 'आज शायद यह मदद करे';

  @override
  String get routineNotToday => 'आज नहीं';

  @override
  String get routineSeeAll => 'सभी तरीके';

  @override
  String get routineStepsTitle => 'कैसे करें';

  @override
  String get routineReasonHighDay => 'आज का स्तर ज़्यादा है';

  @override
  String get routineReasonNeckTension => 'आपके चेक-इन में गर्दन की अकड़न है';

  @override
  String get routineReasonStress => 'आपके चेक-इन में तनाव ज़्यादा है';

  @override
  String get routineStretchesTitle => 'गर्दन और कंधों की हल्की स्ट्रेचिंग';

  @override
  String get routineStretchesSummary =>
      'गर्दन और कंधों की अकड़न कम करने के लिए पाँच धीमी हरकतें। कहीं दर्द हो तो रुक जाएँ।';

  @override
  String get routineStretchesSteps =>
      'कंधे ढीले रखकर और पैर ज़मीन पर टिकाकर सीधे बैठें।\nधीरे से दायाँ कान दाएँ कंधे की ओर झुकाएँ। 15 सेकंड रुकें, फिर दूसरी तरफ़ करें।\nठुड्डी को छाती की ओर झुकाएँ और 15 सेकंड रुकें।\nकंधों को पाँच बार पीछे की ओर घुमाएँ, फिर पाँच बार आगे की ओर।\nपीठ के पीछे हाथ जोड़ें और 15 सेकंड तक धीरे से छाती खोलें।';

  @override
  String get routineBreathingTitle => 'धीमी साँसें';

  @override
  String get routineBreathingSummary =>
      'लगभग एक मिनट तक 4 सेकंड साँस लें और 6 सेकंड छोड़ें। धीरे साँस छोड़ने से कई लोगों को शांति मिलती है।';

  @override
  String get routineBreathingSteps =>
      'किसी आरामदायक जगह बैठें या लेटें।\nघेरा बड़ा होते समय नाक से साँस लें।\nघेरा छोटा होते समय धीरे से साँस छोड़ें।\nछह बार या जब तक अच्छा लगे, करते रहें।';

  @override
  String get routineLowLightTitle => 'कम रोशनी और शांति';

  @override
  String get routineLowLightSummary =>
      'संवेदनशील दिनों में और अटैक के दौरान तेज़ रोशनी और शोर कई लोगों को परेशान करते हैं।';

  @override
  String get routineLowLightSteps =>
      'रोशनी धीमी करें या पर्दे बंद करें।\nडार्क मोड चालू करें और स्क्रीन की चमक कम करें।\nरोशनी फिर भी परेशान करे तो आई मास्क या धूप का चश्मा पहनें।\nईयरप्लग या शांत कमरे से शोर कम करें।';

  @override
  String get routineHydrationTitle => 'थोड़ा पानी पिएँ';

  @override
  String get routineHydrationSummary =>
      'पानी पास रखने से दिन भर पीना आसान होता है।';

  @override
  String get routineHydrationSteps =>
      'एक गिलास या बोतल पानी पास रखें।\nहर घंटे कुछ घूँट पिएँ।\nहर भोजन के साथ एक गिलास पानी पिएँ।';

  @override
  String get routineCaffeineTitle => 'कैफ़ीन एक जैसा रखें';

  @override
  String get routineCaffeineSummary =>
      'कैफ़ीन की मात्रा में बड़े बदलाव कुछ लोगों के लिए मायने रख सकते हैं।';

  @override
  String get routineCaffeineSteps =>
      'हर दिन लगभग एक ही समय पर कैफ़ीन लें।\nअचानक ज़्यादा बढ़ाने से बचें, और अपनी सामान्य मात्रा अचानक छोड़ने से भी।\nकैफ़ीन वाला आख़िरी पेय दोपहर की शुरुआत तक ले लें।';

  @override
  String get routineSleepTitle => 'नियमित नींद';

  @override
  String get routineSleepSummary =>
      'सप्ताहांत समेत सोने का नियमित समय कई लोगों की मदद करता है।';

  @override
  String get routineSleepSteps =>
      'हर दिन लगभग एक ही समय पर सोएँ और उठें।\nसोने का कमरा अंधेरा, शांत और ठंडा रखें।\nसोने से 30 मिनट पहले स्क्रीन दूर रखें।\nदिन ढलने पर लंबी झपकी से बचें।';

  @override
  String get breathingStart => 'साँस लेना शुरू करें';

  @override
  String get breathingStop => 'रोकें';

  @override
  String get breathingIn => 'साँस लें';

  @override
  String get breathingOut => 'साँस छोड़ें';

  @override
  String breathingRound(int round, int total) {
    return 'राउंड $round/$total';
  }

  @override
  String get breathingDone => 'हो गया। उठने से पहले एक पल रुकें।';

  @override
  String get settingsRoutinesHint => 'स्ट्रेचिंग, साँसें और अन्य आसान तरीके';

  @override
  String get experimentsTitle => 'प्रयोग';

  @override
  String get settingsExperimentsHint =>
      'दो हफ़्ते एक बदलाव आज़माएँ और तुलना करें';

  @override
  String get experimentsIntro =>
      'दो हफ़्ते तक एक बदलाव आज़माएँ और उससे पहले के दो हफ़्तों से तुलना करें। एक समय में एक ही प्रयोग।';

  @override
  String get experimentsPick => 'एक बदलाव चुनें';

  @override
  String get experimentChangeCutCaffeine => 'कैफ़ीन कम करें';

  @override
  String get experimentChangeRegularSleep => 'हर रात एक ही समय पर सोएँ';

  @override
  String get experimentChangeMoreWater => 'ज़्यादा पानी पिएँ';

  @override
  String get experimentChangeDailyStretches => 'रोज़ गर्दन की स्ट्रेचिंग करें';

  @override
  String get experimentChangeLessScreens => 'शाम को स्क्रीन कम देखें';

  @override
  String get experimentChangeNoAlcohol => 'शराब से दूर रहें';

  @override
  String experimentDay(int day, int total) {
    return 'दिन $day/$total';
  }

  @override
  String get experimentAdherenceQuestion => 'क्या आज आपने इसका पालन किया?';

  @override
  String get experimentYes => 'हाँ';

  @override
  String get experimentNo => 'नहीं';

  @override
  String experimentAdherence(int kept, int days) {
    return '$days में से $kept दिन पालन किया';
  }

  @override
  String get experimentCompareTitle => 'पहले के दो हफ़्ते और प्रयोग के दौरान';

  @override
  String get experimentBefore => 'पहले';

  @override
  String get experimentDuring => 'दौरान';

  @override
  String get experimentRowRate => 'हर हफ़्ते अटैक';

  @override
  String get experimentRowIntensity => 'औसत तीव्रता';

  @override
  String get experimentRowDuration => 'मध्य अवधि';

  @override
  String experimentSample(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अटैक से',
      zero: 'कोई अटैक नहीं',
    );
    return '$_temp0';
  }

  @override
  String experimentDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
    );
    return '$_temp0';
  }

  @override
  String get experimentNoData => 'कोई डेटा नहीं';

  @override
  String get experimentCaveat =>
      'दो हफ़्ते कम समय है। मौसम, ऋतु और तनाव अपने आप बदलते हैं, इसलिए इसे एक संकेत मानें, सबूत नहीं।';

  @override
  String experimentSmallSample(int min) {
    return 'किसी एक अवधि में $min से कम अटैक हैं, इसलिए आँकड़े काफ़ी ऊपर-नीचे हो सकते हैं।';
  }

  @override
  String get experimentStop => 'प्रयोग रोकें';

  @override
  String get experimentFinish => 'पूरा करें और नतीजा सहेजें';

  @override
  String get experimentDue => 'दो हफ़्ते पूरे हो गए।';

  @override
  String get experimentPast => 'पिछले प्रयोग';

  @override
  String experimentFinished(String date) {
    return '$date को पूरा हुआ';
  }

  @override
  String experimentStopped(String date) {
    return '$date को रोका गया';
  }

  @override
  String experimentPastSummary(String before, String during) {
    return 'पहले हर हफ़्ते $before अटैक, दौरान $during';
  }

  @override
  String get accountTitle => 'खाता';

  @override
  String get settingsAccountHint =>
      'वैकल्पिक। सिर्फ़ बैकअप और लिंक के लिए ज़रूरी';

  @override
  String get accountIntro =>
      'खाता वैकल्पिक है। ऐप में सब कुछ इसके बिना चलता है, और आपकी जानकारी इसी फ़ोन पर रहती है। यह सिर्फ़ एन्क्रिप्टेड बैकअप और शेयर लिंक के लिए ज़रूरी है।';

  @override
  String get accountUnavailable => 'इस बिल्ड में खाते सेट नहीं किए गए हैं।';

  @override
  String get accountApple => 'Apple के साथ जारी रखें';

  @override
  String get accountGoogle => 'Google के साथ जारी रखें';

  @override
  String get accountOrEmail => 'या अपना ईमेल इस्तेमाल करें';

  @override
  String get accountEmail => 'ईमेल';

  @override
  String get accountPassword => 'पासवर्ड';

  @override
  String accountPasswordHint(int min) {
    return 'नए खाते के लिए कम से कम $min अक्षर';
  }

  @override
  String get accountSignIn => 'साइन इन करें';

  @override
  String get accountCreate => 'खाता बनाएँ';

  @override
  String get accountForgot => 'पासवर्ड भूल गए?';

  @override
  String get accountResetSent =>
      'अगर इस ईमेल का खाता है, तो रीसेट लिंक भेजा जा रहा है।';

  @override
  String accountSignedInAs(String email) {
    return '$email के रूप में साइन इन';
  }

  @override
  String accountSignedInWith(String method) {
    return '$method से साइन इन';
  }

  @override
  String get accountMethodApple => 'Apple';

  @override
  String get accountMethodGoogle => 'Google';

  @override
  String get accountMethodEmail => 'ईमेल';

  @override
  String get accountSignedInNote =>
      'आपकी जानकारी इसी फ़ोन पर रहती है। साइन आउट करने से कुछ नहीं मिटता।';

  @override
  String get accountSignOut => 'साइन आउट करें';

  @override
  String get accountDelete => 'खाता मिटाएँ';

  @override
  String get accountDeleteTitle => 'अपना खाता मिटाएँ?';

  @override
  String accountDeleteBody(int hours) {
    return 'इससे आपका खाता मिट जाएगा। $hours घंटों के अंदर आपका एन्क्रिप्टेड बैकअप और शेयर किए गए लिंक हमारे सर्वर से हटा दिए जाएँगे। इस फ़ोन पर सब कुछ बना रहेगा।';
  }

  @override
  String get accountDeletePassword => 'पुष्टि के लिए अपना पासवर्ड डालें';

  @override
  String get accountDeleteSubscription =>
      'Premium का बिल App Store या Google Play से आता है। खाता मिटाने से यह बंद नहीं होता; इसे स्टोर में रद्द करें।';

  @override
  String get accountDeleteCancel => 'खाता रखें';

  @override
  String accountDeleted(int hours) {
    return 'खाता मिटा दिया गया। सर्वर का डेटा $hours घंटों के अंदर मिटा दिया जाएगा।';
  }

  @override
  String get accountErrorWrongCredentials =>
      'यह ईमेल और पासवर्ड मेल नहीं खाते।';

  @override
  String get accountErrorEmailInUse =>
      'इस ईमेल का खाता पहले से है। साइन इन करके देखें।';

  @override
  String get accountErrorWeakPassword => 'लंबा पासवर्ड चुनें।';

  @override
  String get accountErrorInvalidEmail => 'ईमेल पता जाँचें।';

  @override
  String get accountErrorNetwork =>
      'कनेक्शन नहीं है। ऑनलाइन होने पर फिर कोशिश करें।';

  @override
  String get accountErrorRecentSignIn =>
      'सुरक्षा के लिए दोबारा साइन इन करें और फिर कोशिश करें।';

  @override
  String get accountErrorUnknown => 'कुछ गड़बड़ हो गई। फिर कोशिश करें।';

  @override
  String get backupTitle => 'एन्क्रिप्टेड बैकअप';

  @override
  String get settingsBackupHint =>
      'ऐसे पासफ़्रेज़ से सुरक्षित जो सिर्फ़ आप जानते हैं';

  @override
  String get backupIntro =>
      'अपलोड होने से पहले आपका बैकअप इसी फ़ोन पर आपके पासफ़्रेज़ से एन्क्रिप्ट होता है। हम सिर्फ़ एन्क्रिप्टेड फ़ाइल रखते हैं और उसे खोल नहीं सकते।';

  @override
  String get backupForgetWarning =>
      'अगर आप पासफ़्रेज़ भूल गए, तो कोई भी बैकअप नहीं खोल पाएगा, हम भी नहीं। इसे किसी सुरक्षित जगह लिख लें।';

  @override
  String get backupNeedsAccount =>
      'बैकअप के लिए खाता चाहिए। बाकी सब इसके बिना चलता है।';

  @override
  String get backupOpenAccount => 'खाता बनाएँ';

  @override
  String get backupNone => 'अभी कोई बैकअप नहीं';

  @override
  String backupLast(String date) {
    return 'आख़िरी बैकअप: $date';
  }

  @override
  String get backupStatusUnknown => 'अभी बैकअप की जाँच नहीं हो सकी।';

  @override
  String get backupPassphrase => 'पासफ़्रेज़';

  @override
  String backupPassphraseHint(int min) {
    return 'कम से कम $min अक्षर। कुछ असंबंधित शब्द अच्छे रहते हैं।';
  }

  @override
  String get backupPassphraseRepeat => 'बैकअप के लिए पासफ़्रेज़ दोबारा डालें';

  @override
  String get backupNow => 'अभी बैकअप लें';

  @override
  String get backupDone => 'बैकअप हो गया।';

  @override
  String get backupRestore => 'बैकअप से वापस लाएँ';

  @override
  String get backupRestoreTitle => 'इस फ़ोन पर सब कुछ बदलें?';

  @override
  String backupRestoreBody(String date) {
    return 'इस फ़ोन पर सब कुछ $date के बैकअप से बदल दिया जाएगा।';
  }

  @override
  String get backupRestoreConfirm => 'वापस लाएँ';

  @override
  String get backupRestored => 'आपके बैकअप से वापस लाया गया।';

  @override
  String get backupDelete => 'बैकअप मिटाएँ';

  @override
  String get backupDeleteTitle => 'बैकअप मिटाएँ?';

  @override
  String get backupDeleteBody =>
      'एन्क्रिप्टेड फ़ाइल हमारे सर्वर से हटा दी जाएगी। इस फ़ोन पर सब कुछ बना रहेगा।';

  @override
  String get backupDeleted => 'बैकअप मिटा दिया गया।';

  @override
  String get backupWorking => 'काम चल रहा है। इसमें कुछ सेकंड लग सकते हैं।';

  @override
  String get backupErrorMismatch => 'दोनों पासफ़्रेज़ मेल नहीं खाते।';

  @override
  String backupErrorShort(int min) {
    return 'कम से कम $min अक्षर इस्तेमाल करें।';
  }

  @override
  String get backupErrorNoBackup => 'इस खाते पर अभी कोई बैकअप नहीं है।';

  @override
  String get backupErrorTooLarge => 'बैकअप अपलोड करने के लिए बहुत बड़ा है।';

  @override
  String get backupErrorNewerApp =>
      'यह बैकअप ऐप के नए वर्शन से बना है। ऐप अपडेट करें और फिर कोशिश करें।';

  @override
  String get backupErrorWrongPassphrase =>
      'यह पासफ़्रेज़ इस बैकअप को नहीं खोलता।';

  @override
  String get backupErrorDamaged => 'बैकअप फ़ाइल ख़राब है।';

  @override
  String get backupErrorPinning =>
      'बैकअप सर्वर से कनेक्शन की पुष्टि नहीं हो सकी, इसलिए कुछ नहीं भेजा गया। दूसरा नेटवर्क आज़माएँ।';

  @override
  String get backupErrorNotAllowed =>
      'आपका साइन इन समाप्त हो गया है। दोबारा साइन इन करें और फिर कोशिश करें।';

  @override
  String get shareLinkButton => 'लिंक के रूप में शेयर करें';

  @override
  String get shareLinkTitle => 'अपने डॉक्टर के साथ शेयर करें';

  @override
  String get shareLinkExplain =>
      'जिसके पास भी लिंक है, वह इसकी समय-सीमा ख़त्म होने तक यह रिपोर्ट पढ़ सकता है। इसमें PDF वाला सारांश दिखता है, आपकी डायरी नहीं। आप कभी भी शेयर करना बंद कर सकते हैं।';

  @override
  String get shareLinkNeedsAccount =>
      'लिंक शेयर करने के लिए खाता चाहिए। PDF और CSV इसके बिना चलते हैं।';

  @override
  String shareLinkDuration(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन',
    );
    return '$_temp0';
  }

  @override
  String get shareLinkCreate => 'लिंक बनाएँ';

  @override
  String get shareLinkWorking => 'लिंक बन रहा है।';

  @override
  String shareLinkReady(String date) {
    return 'लिंक तैयार है। $date तक शेयर किया गया।';
  }

  @override
  String get shareLinkCopy => 'लिंक कॉपी करें';

  @override
  String get shareLinkCopied => 'लिंक कॉपी हो गया।';

  @override
  String get shareLinkShare => 'लिंक शेयर करें';

  @override
  String shareLinkMessage(String url) {
    return 'मेरी माइग्रेन रिपोर्ट: $url';
  }

  @override
  String get shareLinksTitle => 'शेयर किए गए लिंक';

  @override
  String get settingsShareLinksHint =>
      'शेयर किए गए रिपोर्ट लिंक देखें और बंद करें';

  @override
  String get shareLinksEmpty =>
      'आपने कोई लिंक शेयर नहीं किया है। डॉक्टर के लिए रिपोर्ट से एक बनाएँ।';

  @override
  String shareLinkActiveUntil(String date) {
    return '$date तक शेयर';
  }

  @override
  String shareLinkExpiredOn(String date) {
    return '$date को समाप्त';
  }

  @override
  String get shareLinkRevoked => 'शेयर करना बंद';

  @override
  String shareLinkCreatedOn(String date) {
    return '$date को बनाया गया';
  }

  @override
  String get shareLinkRevoke => 'शेयर करना बंद करें';

  @override
  String get shareLinkRevokeTitle => 'इस रिपोर्ट को शेयर करना बंद करें?';

  @override
  String get shareLinkRevokeBody =>
      'लिंक तुरंत काम करना बंद कर देगा, उन सभी के लिए जिनके पास यह है।';

  @override
  String get shareLinkRevokedDone =>
      'शेयर करना बंद हो गया। लिंक अब काम नहीं करता।';

  @override
  String get shareLinkErrorUnavailable =>
      'इस बिल्ड में शेयर लिंक सेट नहीं किए गए हैं।';

  @override
  String get shareLinkErrorSignedOut =>
      'आपका साइन इन समाप्त हो गया है। दोबारा साइन इन करें और फिर कोशिश करें।';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumIntro =>
      'Premium चार अतिरिक्त सुविधाएँ जोड़ता है। बाकी सब बिना किसी समय-सीमा के मुफ़्त रहता है।';

  @override
  String get premiumFreeNote =>
      'हमेशा मुफ़्त: अटैक और रोज़ की जानकारी दर्ज करना, मौसम, जोखिम स्तर, आपके कारक, दवा का लॉग और डॉक्टर के लिए रिपोर्ट।';

  @override
  String get premiumFeatureShareLink => 'डॉक्टर के लिए लिंक';

  @override
  String get premiumFeatureShareLinkHint =>
      'अपनी रिपोर्ट ऐसे लिंक के रूप में भेजें जो 7 या 30 दिन बाद काम करना बंद कर दे।';

  @override
  String get premiumFeatureExperiments => 'प्रयोग';

  @override
  String get premiumFeatureExperimentsHint =>
      'दो हफ़्ते एक बदलाव आज़माएँ और पिछले हफ़्तों से तुलना करें।';

  @override
  String get premiumFeatureExtendedFactors => 'विस्तृत पर्यावरण कारक';

  @override
  String get premiumFeatureExtendedFactorsHint =>
      'प्रकार के अनुसार कण, ओज़ोन और पराग।';

  @override
  String get premiumFeatureBackup => 'एक से दूसरे फ़ोन पर बैकअप';

  @override
  String get premiumFeatureBackupHint =>
      'एक एन्क्रिप्टेड बैकअप जिसे आप नए फ़ोन पर वापस ला सकते हैं।';

  @override
  String get premiumActive => 'Premium चालू है।';

  @override
  String premiumRenews(String date) {
    return '$date को रिन्यू होगा।';
  }

  @override
  String premiumEnds(String date) {
    return '$date को समाप्त होगा।';
  }

  @override
  String get premiumManage => 'सदस्यता प्रबंधित करें';

  @override
  String premiumOfferMonthly(String price) {
    return 'मासिक, $price';
  }

  @override
  String premiumOfferAnnual(String price) {
    return 'वार्षिक, $price';
  }

  @override
  String premiumOfferOther(String price) {
    return '$price';
  }

  @override
  String get premiumRestore => 'ख़रीदारी वापस लाएँ';

  @override
  String get premiumRestoredNone =>
      'इस स्टोर खाते के लिए कोई Premium ख़रीदारी नहीं मिली।';

  @override
  String get premiumThanks => 'धन्यवाद। Premium चालू है।';

  @override
  String get premiumRenewalTerms =>
      'सदस्यता तब तक अपने आप रिन्यू होती है जब तक आप स्टोर सेटिंग में इसे रद्द न करें। अगले शुल्क से बचने के लिए रिन्यू होने की तारीख़ से कम से कम 24 घंटे पहले रद्द करें।';

  @override
  String get premiumLoadingOffers => 'कीमतें लोड हो रही हैं।';

  @override
  String get premiumNoOffers =>
      'कीमतें लोड नहीं हो सकीं। अपना कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get premiumRetry => 'फिर कोशिश करें';

  @override
  String get premiumUnavailable => 'इस बिल्ड में ख़रीदारी सेट नहीं की गई है।';

  @override
  String get premiumDevUnlocked =>
      'डेवलपमेंट बिल्ड: सभी Premium सुविधाएँ खुली हैं।';

  @override
  String get premiumAccountTip =>
      'एक से ज़्यादा फ़ोन इस्तेमाल करते हैं? पहले साइन इन करें, ताकि Premium आपके खाते के साथ रहे।';

  @override
  String get premiumErrorNotAllowed => 'यह स्टोर खाता ख़रीदारी नहीं कर सकता।';

  @override
  String get premiumErrorPending =>
      'ख़रीदारी मंज़ूरी का इंतज़ार कर रही है। पूरी होने पर Premium चालू हो जाएगा।';

  @override
  String get premiumErrorStore =>
      'स्टोर में कोई समस्या आई। बाद में फिर कोशिश करें।';

  @override
  String premiumLockTitle(String feature) {
    return '$feature Premium में शामिल है।';
  }

  @override
  String get premiumLockButton => 'Premium देखें';

  @override
  String get premiumLockShareLinkNote =>
      'आपके बनाए लिंक समय-सीमा ख़त्म होने तक काम करते रहेंगे, और आप कभी भी उन्हें शेयर करना बंद कर सकते हैं।';

  @override
  String get premiumLockExperimentsNote => 'आपके पिछले नतीजे यहीं रहेंगे।';

  @override
  String get premiumLockBackupNote =>
      'आप अब भी मौजूदा बैकअप को वापस ला या मिटा सकते हैं।';

  @override
  String get premiumFactorsLocked => 'कण, ओज़ोन और पराग Premium में शामिल हैं।';

  @override
  String get settingsPremiumHint => 'शेयर लिंक, प्रयोग, विस्तृत कारक और बैकअप';

  @override
  String get settingsPremiumActive => 'चालू';

  @override
  String get shareLinkErrorPremium =>
      'शेयर लिंक के लिए Premium चाहिए। अगर आपने अभी सदस्यता ली है, तो एक मिनट रुककर फिर कोशिश करें।';

  @override
  String get auditTitle => 'जोखिम स्तर कितना सही रहा';

  @override
  String auditNotYet(int needed, int logged) {
    return 'यह पेज $needed अटैक दर्ज होने के बाद दिखेगा। अब तक आपने $logged दर्ज किए हैं।';
  }

  @override
  String auditIntro(int window) {
    String _temp0 = intl.Intl.pluralLogic(
      window,
      locale: localeName,
      other: 'उससे पहले के $window दिनों में',
      one: 'उससे एक दिन पहले',
    );
    return 'यह ऐप ने हर दिन जो स्तर दिखाया, उसकी तुलना आपके अटैक शुरू होने के समय से करता है। कोई अटैक ज़्यादा वाले दिन के बाद गिना जाता है, जब उसके शुरू होने के दिन या $_temp0 स्तर ज़्यादा दिखाया गया हो।';
  }

  @override
  String get auditEmpty =>
      'अभी तुलना के लिए कुछ नहीं है। अब से ऐप हर दिन दिखाया गया स्तर सहेजेगा, और पहले आँकड़े आपके अगले अटैक या अगले ज़्यादा वाले दिन के बाद दिखेंगे।';

  @override
  String get auditHitsTitle => 'ज़्यादा वाले दिन के बाद आए अटैक';

  @override
  String auditHitsValue(int hits, int attacks, String share) {
    return '$attacks में से $hits ($share)';
  }

  @override
  String get auditMissesTitle => 'बिना ज़्यादा वाले दिन के आए अटैक';

  @override
  String auditMissesValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अटैक',
    );
    return '$_temp0';
  }

  @override
  String get auditFalseAlarmsTitle => 'बिना अटैक वाले ज़्यादा दिन';

  @override
  String auditFalseAlarmsValue(int count, int highDays) {
    return '$highDays ज़्यादा वाले दिनों में से $count';
  }

  @override
  String get auditTrend => 'महीने के अनुसार';

  @override
  String auditMonthLine(int hits, int attacks, int falseAlarms, int highDays) {
    return '$attacks में से $hits अटैक ज़्यादा वाले दिन के बाद; $highDays ज़्यादा वाले दिनों में से $falseAlarms बिना अटैक';
  }

  @override
  String get auditCaveat =>
      'छोटे आँकड़े महीने-दर-महीने काफ़ी बदलते हैं। बिना अटैक वाला ज़्यादा दिन कोई गलती नहीं है: इसका मतलब है कि आपके सामान्य ट्रिगर में से ज़्यादा एक साथ आए। यह स्तर योजना बनाने में मदद है, कोई वादा नहीं।';

  @override
  String get auditShare => 'ये आँकड़े हर महीने शेयर करें';

  @override
  String get auditShareHint =>
      'इससे सबके लिए ऐप को परखने में मदद मिलती है। सिर्फ़ पाँच आँकड़े और मॉडल वर्शन भेजे जाते हैं, कभी तारीख़ें, जगहें, आपका लॉग या आपका खाता नहीं। जब तक आप चालू न करें, बंद रहता है।';

  @override
  String get settingsAuditHint =>
      'ज़्यादा वाले दिनों के बाद अटैक और बिना अटैक वाले ज़्यादा दिन';

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
  String get unitsTitle => 'इकाइयाँ';

  @override
  String get settingsUnitsHint => 'दबाव और तापमान';

  @override
  String get unitsPressure => 'दबाव';

  @override
  String get unitsTemperature => 'तापमान';

  @override
  String get unitNameHpa => 'हेक्टोपास्कल (hPa)';

  @override
  String get unitNameInHg => 'इंच पारा (inHg)';

  @override
  String get unitNameMmHg => 'मिलीमीटर पारा (mmHg)';

  @override
  String get unitNameCelsius => 'सेल्सियस (°C)';

  @override
  String get unitNameFahrenheit => 'फ़ारेनहाइट (°F)';

  @override
  String get unitsNote =>
      'पहली पसंद आपके फ़ोन के क्षेत्र से आती है। बदलने से सिर्फ़ मान दिखाने का तरीका बदलता है; आपका लॉग वैसा ही रहता है।';

  @override
  String envTemperatureNow(String temperature) {
    return 'अभी का तापमान: $temperature';
  }

  @override
  String get questionnaireEnglishNote =>
      'जब तक मान्य अनुवाद नहीं जुड़ता, सवाल अपने मूल अंग्रेज़ी शब्दों में दिखाए जाते हैं, ताकि आपके स्कोर की तुलना की जा सके।';

  @override
  String get wellnessDisclaimer =>
      'सामान्य वेलनेस जानकारी, चिकित्सा सलाह नहीं। इलाज के बारे में अपने डॉक्टर से बात करें।';

  @override
  String get dataSourceWeather => 'Open-Meteo मौसम';

  @override
  String get dataSourceAirQuality => 'Open-Meteo वायु गुणवत्ता और UV (CAMS)';

  @override
  String get dataSourcePollen => 'Open-Meteo पराग (CAMS)';

  @override
  String get dataSourceGeocoding => 'Open-Meteo जियोकोडिंग';

  @override
  String get dataSourceBarometer => 'डिवाइस बैरोमीटर';

  @override
  String get dataCoverageWorldwide => 'पूरी दुनिया';

  @override
  String get dataCoverageEuropeanAqi => 'पूरी दुनिया, यूरोप में यूरोपीय AQI';

  @override
  String get dataCoverageEurope => 'सिर्फ़ यूरोप';

  @override
  String get dataCoverageBarometer => 'प्रेशर सेंसर वाले फ़ोन';
}
