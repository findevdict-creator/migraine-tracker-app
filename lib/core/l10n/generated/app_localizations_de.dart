// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Migraine Tracker';

  @override
  String get homeEmptyState =>
      'Noch nichts eingetragen.\nDein Risikoniveau und deine Umgebung erscheinen hier.';

  @override
  String get riskLevelLow => 'Niedrig';

  @override
  String get riskLevelModerate => 'Mittel';

  @override
  String get riskLevelHigh => 'Hoch';

  @override
  String get devThemeGalleryTitle => 'Theme-Galerie';

  @override
  String get devThemeLight => 'Helles Theme';

  @override
  String get devThemeDark => 'Dunkles Theme';

  @override
  String get devThemeAttack => 'Attacken-Theme';

  @override
  String get devSampleBody =>
      'Fließtext in Standardgröße. Er muss bei 200 % Textgröße ohne Abschneiden lesbar bleiben.';

  @override
  String get devSamplePrimary => 'Primär';

  @override
  String get devSampleSecondary => 'Sekundär';

  @override
  String get devSampleText => 'Text';

  @override
  String get devSampleDisabled => 'Deaktiviert';

  @override
  String get devSampleChipOn => 'Aura';

  @override
  String get devSampleChipOff => 'Übelkeit';

  @override
  String get devSampleChipIcon => 'Licht';

  @override
  String get devSampleSlider => 'Stärke';

  @override
  String get devSampleSliderLow => 'Kein Schmerz';

  @override
  String get devSampleSliderHigh => 'Am schlimmsten';

  @override
  String get devSampleCard => 'Eine Karte mit Abzeichen';

  @override
  String get attackStart => 'Attacke starten';

  @override
  String get attackContinue => 'Attacke fortsetzen';

  @override
  String get attackTitleRunning => 'Attacke läuft';

  @override
  String get attackTitleEnded => 'Attacke';

  @override
  String attackStartedAt(String time) {
    return 'Begonnen um $time';
  }

  @override
  String get attackNotFound => 'Diese Attacke gibt es nicht mehr.';

  @override
  String get attackIntensity => 'Schmerzstärke';

  @override
  String get durationEstimateTitle => 'Wie lange solche Attacken meist dauern';

  @override
  String durationEstimateRange(String low, String high) {
    return 'Meist $low bis $high h';
  }

  @override
  String durationEstimateSameMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Auf Grundlage von $count früheren Attacken ähnlicher Stärke mit demselben Medikament',
      one: 'Auf Grundlage von 1 früheren Attacke ähnlicher Stärke mit demselben Medikament',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateNoMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Auf Grundlage von $count früheren Attacken ähnlicher Stärke ohne Medikament',
      one: 'Auf Grundlage von 1 früheren Attacke ähnlicher Stärke ohne Medikament',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateSimilar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Auf Grundlage von $count früheren Attacken ähnlicher Stärke',
      one: 'Auf Grundlage von 1 früheren Attacke ähnlicher Stärke',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Auf Grundlage von $count deiner früheren Attacken',
      one: 'Auf Grundlage von 1 deiner früheren Attacken',
    );
    return '$_temp0';
  }

  @override
  String get attackIntensityLow => 'Kein Schmerz';

  @override
  String get attackIntensityHigh => 'Am schlimmsten';

  @override
  String get attackWhereItHurts => 'Wo es wehtut';

  @override
  String get attackSymptoms => 'Symptome';

  @override
  String get attackPhases => 'Phasen';

  @override
  String get attackNotes => 'Notizen';

  @override
  String get attackNotesHint => 'Alles andere, was du dir merken möchtest';

  @override
  String get attackEnd => 'Attacke beenden';

  @override
  String get attackDone => 'Fertig';

  @override
  String get attackFinishLater => 'Später abschließen';

  @override
  String get symptomAura => 'Aura';

  @override
  String get symptomNeckTension => 'Nackenverspannung';

  @override
  String get symptomLightSensitivity => 'Licht';

  @override
  String get symptomSoundSensitivity => 'Geräusche';

  @override
  String get symptomSmellSensitivity => 'Gerüche';

  @override
  String get symptomNausea => 'Übelkeit';

  @override
  String get phaseProdrome => 'Vorbotenphase';

  @override
  String get phaseAura => 'Aura';

  @override
  String get phaseAttack => 'Kopfschmerzphase';

  @override
  String get phasePostdrome => 'Rückbildungsphase';

  @override
  String get headForehead => 'Stirn';

  @override
  String get headLeftTemple => 'Linke Schläfe';

  @override
  String get headRightTemple => 'Rechte Schläfe';

  @override
  String get headBehindEyes => 'Hinter den Augen';

  @override
  String get headLeftSide => 'Linke Seite';

  @override
  String get headRightSide => 'Rechte Seite';

  @override
  String get headTopOfHead => 'Scheitel';

  @override
  String get headBackOfHead => 'Hinterkopf';

  @override
  String get headNeck => 'Nacken';

  @override
  String get checkinTitle => 'Täglicher Check-in';

  @override
  String get checkinLoadError => 'Dieser Tag konnte nicht geladen werden.';

  @override
  String get checkinIntro => 'Drei Tipps. Wie war es?';

  @override
  String get checkinComplete =>
      'Für diesen Tag erledigt. Tippe auf eine Zahl, um sie zu ändern.';

  @override
  String get checkinAddMore => 'Mehr hinzufügen (optional)';

  @override
  String get checkinOptionalTitle => 'Optional';

  @override
  String get checkinDone => 'Fertig';

  @override
  String get checkinToday => 'Heute';

  @override
  String get checkinSleepQuality => 'Schlafqualität';

  @override
  String get checkinStress => 'Stress';

  @override
  String get checkinNeckTension => 'Nackenverspannung';

  @override
  String get checkinCaffeine => 'Koffein';

  @override
  String get checkinHydration => 'Trinkmenge';

  @override
  String get checkinAlcohol => 'Alkohol';

  @override
  String get checkinLightExposure => 'Helles Licht';

  @override
  String get checkinScreenExposure => 'Bildschirmzeit';

  @override
  String get checkinSleepLow => 'Schlecht';

  @override
  String get checkinSleepHigh => 'Sehr gut';

  @override
  String get checkinStressLow => 'Ruhig';

  @override
  String get checkinStressHigh => 'Sehr gestresst';

  @override
  String get checkinNeckLow => 'Locker';

  @override
  String get checkinNeckHigh => 'Sehr verspannt';

  @override
  String get checkinHydrationLow => 'Wenig';

  @override
  String get checkinHydrationHigh => 'Viel';

  @override
  String get checkinExposureLow => 'Wenig';

  @override
  String get checkinExposureHigh => 'Viel';

  @override
  String get checkinNone => 'Keine';

  @override
  String checkinCupsOrMore(int count) {
    return '$count+ Tassen';
  }

  @override
  String checkinDrinksOrMore(int count) {
    return '$count+ Getränke';
  }

  @override
  String checkinValueSemantics(String field, int value, int max) {
    return '$field, $value von $max';
  }

  @override
  String get checkinReminderTooltip => 'Erinnerungszeit';

  @override
  String checkinReminderAt(String time) {
    return 'Erinnerung um $time';
  }

  @override
  String get checkinReminderPickerTitle =>
      'Erinnerung an den täglichen Check-in';

  @override
  String get checkinCardTitle => 'Täglicher Check-in';

  @override
  String get checkinCardDone => 'Für heute erledigt';

  @override
  String get checkinCardTodo => 'Drei Tipps, etwa 10 Sekunden';

  @override
  String get medicationTitle => 'Medikamente';

  @override
  String get medicationAdd => 'Medikament hinzufügen';

  @override
  String get medicationAddTitle => 'Einnahme eintragen';

  @override
  String get medicationName => 'Medikament';

  @override
  String get medicationDose => 'Dosis';

  @override
  String get medicationDoseHint => 'z. B. 400 mg';

  @override
  String get medicationKindAcute => 'Akut';

  @override
  String get medicationKindPreventive => 'Vorbeugend';

  @override
  String medicationTakenAt(String time) {
    return 'Eingenommen um $time';
  }

  @override
  String get medicationLog => 'Eintragen';

  @override
  String get medicationDelete => 'Löschen';

  @override
  String get medicationThisMonth => 'Diesen Monat';

  @override
  String get medicationEmpty => 'Diesen Monat keine Einnahmen eingetragen.';

  @override
  String get medicationReliefQuestion => 'Linderung nach 2 h?';

  @override
  String get medicationReliefNone => 'Keine';

  @override
  String get medicationReliefPartial => 'Etwas';

  @override
  String get medicationReliefFull => 'Vollständig';

  @override
  String medicationAcuteDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage mit Akutmedikation diesen Monat',
      one: '1 Tag mit Akutmedikation diesen Monat',
      zero: 'Diesen Monat keine Tage mit Akutmedikation',
    );
    return '$_temp0';
  }

  @override
  String get medicationAcuteDaysHint =>
      'Tage mit mindestens einer Akuteinnahme, gezählt pro Kalendermonat.';

  @override
  String medicationOveruseFirstNote(int days) {
    return 'Du hast diesen Monat $days Tage mit Akutmedikation erreicht. Viele Fachleute empfehlen, diese Zahl niedrig zu halten; ein Gespräch darüber kann sich lohnen.';
  }

  @override
  String medicationOveruseSecondNote(int days) {
    return 'Du hast diesen Monat $days Tage mit Akutmedikation erreicht. Bitte sprich mit deiner Ärztin oder deinem Arzt über dieses Muster.';
  }

  @override
  String get medicationTalkToClinician => 'Mit Ärztin oder Arzt sprechen';

  @override
  String get cycleTitle => 'Zyklus';

  @override
  String get cycleToggleTitle => 'Meinen Zyklus erfassen';

  @override
  String get cycleToggleSubtitle =>
      'Standardmäßig aus. Wenn an, wird der Zyklustag mit jedem Check-in gespeichert und als Faktor verwendet.';

  @override
  String get cycleNoData =>
      'Trage einen Periodenbeginn ein, um deinen Zyklustag zu sehen.';

  @override
  String cycleDayAndPhase(int day, String phase) {
    return 'Zyklustag $day · $phase';
  }

  @override
  String cycleLength(int days) {
    return 'Bei einem Zyklus von $days Tagen';
  }

  @override
  String get cyclePeriodStarts => 'Periodenbeginne';

  @override
  String get cycleNoStarts => 'Noch keine eingetragen.';

  @override
  String get cycleRemoveStart => 'Entfernen';

  @override
  String get cyclePeriodStartedToday => 'Periode hat an diesem Tag begonnen';

  @override
  String get cyclePhaseMenstrual => 'Menstruation';

  @override
  String get cyclePhaseFollicular => 'Follikelphase';

  @override
  String get cyclePhaseOvulation => 'Rund um den Eisprung';

  @override
  String get cyclePhaseLuteal => 'Lutealphase';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionDaily => 'Täglich';

  @override
  String get settingsSectionData => 'Deine Daten';

  @override
  String get settingsSectionAbout => 'Info';

  @override
  String get settingsExportJson => 'Als JSON exportieren';

  @override
  String get settingsExportJsonHint =>
      'Alle Tabellen in einer Datei, die du wieder importieren kannst.';

  @override
  String get settingsExportCsv => 'Als CSV exportieren';

  @override
  String get settingsExportCsvHint => 'Eine Tabellendatei pro Tabelle.';

  @override
  String get settingsExportEmpty => 'Noch nichts zu exportieren.';

  @override
  String get settingsDeleteAll => 'Alles löschen';

  @override
  String get settingsDeleteAllHint =>
      'Entfernt alle Daten von diesem Gerät. Kann nicht rückgängig gemacht werden.';

  @override
  String settingsDeleteAllConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Damit werden $count Einträge von diesem Gerät gelöscht. Das kann nicht rückgängig gemacht werden.',
      one: 'Damit wird 1 Eintrag von diesem Gerät gelöscht. Das kann nicht rückgängig gemacht werden.',
      zero: 'Es ist noch nichts gespeichert. Trotzdem löschen?',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeleteAllButton => 'Löschen';

  @override
  String get settingsCancel => 'Abbrechen';

  @override
  String get settingsDeletedAll => 'Alle Daten gelöscht.';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get settingsTerms => 'Nutzungsbedingungen';

  @override
  String get settingsSupport => 'Support';

  @override
  String get environmentTitle => 'Umgebung';

  @override
  String get environmentCardTitle => 'Luftdruck';

  @override
  String get environmentCardEmpty =>
      'Noch keine Wetterdaten gespeichert. Tippe, um deinen Standort festzulegen.';

  @override
  String environmentCardSummary(String pressure, String trend) {
    return '$pressure, $trend';
  }

  @override
  String get envPressureSection => 'Luftdruck';

  @override
  String get envPressureUnknown => 'Kein Wert für diese Stunde';

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
  String get envChartTitle => 'Letzte 48 Stunden und nächste 24';

  @override
  String get envUpdatedNever => 'Noch nicht aktualisiert';

  @override
  String get envUpdatedJustNow => 'Gerade aktualisiert';

  @override
  String envUpdatedMinutes(int n) {
    return 'Vor $n Min. aktualisiert';
  }

  @override
  String envUpdatedHours(int n) {
    return 'Vor $n h aktualisiert';
  }

  @override
  String envUpdatedDays(int n) {
    return 'Vor $n T. aktualisiert';
  }

  @override
  String get envStale =>
      'Diese Vorhersage ist einige Stunden alt. Sie wird aktualisiert, sobald du wieder online bist.';

  @override
  String get envOffline =>
      'Der Wetterdienst ist nicht erreichbar. Angezeigt wird, was auf diesem Gerät gespeichert ist.';

  @override
  String get envNoData =>
      'Noch keine Wetterdaten gespeichert. Erlaube den Standort oder wähle eine Stadt, um den Luftdrucktrend zu sehen.';

  @override
  String get envRefresh => 'Aktualisieren';

  @override
  String get envLocationSection => 'Standort';

  @override
  String get envLocationGps => 'Ungefährer Standort wird verwendet';

  @override
  String envLocationManual(String city) {
    return '$city wird verwendet';
  }

  @override
  String get envLocationLast => 'Letztes bekanntes Gebiet wird verwendet';

  @override
  String get envLocationNone => 'Kein Standort festgelegt';

  @override
  String get envUseMyLocation => 'Meinen Standort verwenden';

  @override
  String get envChooseCity => 'Stadt wählen';

  @override
  String get envCitySearchTitle => 'Stadt wählen';

  @override
  String get envCitySearchHint => 'Name der Stadt';

  @override
  String get envCityNoResults => 'Keine Orte gefunden';

  @override
  String get envCitySearchFailed =>
      'Die Suche ist gerade nicht möglich. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String get envPrivacyNote =>
      'Dein Standort wird auf etwa 10 km gerundet, bevor er dieses Gerät verlässt.';

  @override
  String get envAttribution => 'Wetterdaten von Open-Meteo';

  @override
  String get envTrendRising => 'steigend';

  @override
  String get envTrendFalling => 'fallend';

  @override
  String get envTrendSteady => 'gleichbleibend';

  @override
  String get envTrendUnknown => 'noch kein Trend';

  @override
  String get barometerTitle => 'Barometer';

  @override
  String get barometerOpen => 'Barometer öffnen';

  @override
  String get barometerNoReading => 'Kein Wert';

  @override
  String get barometerFromSensor => 'Vom Sensor dieses Geräts';

  @override
  String get barometerFromStation => 'Von der nächsten Station';

  @override
  String get barometerNoSource =>
      'Kein Sensor auf diesem Gerät und noch keine Vorhersage gespeichert';

  @override
  String get barometerCalibrationSection => 'Kalibrierung';

  @override
  String barometerOffset(String offset, int pairs) {
    return 'Sensorabweichung $offset gegenüber der Station, aus $pairs stündlichen Paaren.';
  }

  @override
  String barometerNotCalibrated(int pairs) {
    return 'Noch nicht kalibriert. Nötig sind mindestens $pairs Stunden mit einem Sensorwert und einem Stationswert.';
  }

  @override
  String get barometerTrendSection => 'Letzte 24 Stunden auf diesem Gerät';

  @override
  String get barometerTrendEmpty =>
      'Werte werden gemessen, solange die App geöffnet ist. Schau später wieder vorbei, um den Trend zu sehen.';

  @override
  String barometerTrendSamples(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Messwerte',
      one: '1 Messwert',
    );
    return '$_temp0';
  }

  @override
  String get barometerStampNote =>
      'Jede Attacke, die du startest, speichert den Sensorwert und den Stationswert dieser Stunde.';

  @override
  String get envFactorsTitle => 'Faktoren heute';

  @override
  String get envFactorsEmpty =>
      'Für dieses Gebiet gibt es noch keine Tagesfaktoren.';

  @override
  String get factorBandLow => 'niedrig';

  @override
  String get factorBandModerate => 'mäßig';

  @override
  String get factorBandHigh => 'hoch';

  @override
  String get factorBandVeryHigh => 'sehr hoch';

  @override
  String factorValueWithBand(String value, String band) {
    return '$value ($band)';
  }

  @override
  String get factorAqiUs => 'Luftqualität (US-AQI)';

  @override
  String get factorAqiEu => 'Luftqualität (Europäischer AQI)';

  @override
  String get factorParticulates => 'Feinstaub PM2,5 / PM10';

  @override
  String factorParticulatesValue(String pm25, String pm10) {
    return '$pm25 / $pm10 µg/m³';
  }

  @override
  String get factorOzone => 'Ozon';

  @override
  String factorMicrograms(String value) {
    return '$value µg/m³';
  }

  @override
  String get factorPollen => 'Pollen (nur Europa)';

  @override
  String factorPollenType(String type, String band) {
    return '$type $band';
  }

  @override
  String get pollenAlder => 'Erle';

  @override
  String get pollenBirch => 'Birke';

  @override
  String get pollenGrass => 'Gräser';

  @override
  String get pollenMugwort => 'Beifuß';

  @override
  String get pollenOlive => 'Olive';

  @override
  String get pollenRagweed => 'Ambrosia';

  @override
  String get factorUvMax => 'UV-Index, Tageshöchstwert';

  @override
  String get factorDaylight => 'Tageslicht';

  @override
  String factorDaylightValue(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get factorSun => 'Sonnenauf- und -untergang';

  @override
  String factorSunValue(String sunrise, String sunset) {
    return '$sunrise bis $sunset';
  }

  @override
  String get aboutDataTitle => 'Über die Daten';

  @override
  String get aboutDataIntro =>
      'Woher die Zahlen in dieser App kommen und was jede davon aussagen kann und was nicht.';

  @override
  String get aboutDataSources => 'Quellen';

  @override
  String aboutDataLicence(String coverage, String licence) {
    return '$coverage. Lizenz: $licence.';
  }

  @override
  String get aboutDataPrivacy => 'Was dein Telefon verlässt';

  @override
  String get aboutDataPrivacyBody =>
      'Nur ein auf etwa 10 km gerundeter Standort, damit der Wetterdienst für dein Gebiet antworten kann. Deine Attacken, Check-ins, Medikamente und Gesundheitsdaten bleiben auf diesem Gerät, außer du entscheidest dich für ein Backup oder teilst sie.';

  @override
  String get aboutDataLimits => 'Grenzen';

  @override
  String get aboutDataLimitsBody =>
      'Vorhersagen sind Modellschätzungen für ein Rasterfeld, keine Messung vor deiner Tür. Pollen gibt es nur für Europa. Luftqualität kann in manchen Regionen fehlen. Hat ein Faktor keine Daten für dein Gebiet, wird er einfach nicht angezeigt.';

  @override
  String get settingsHealthHint =>
      'Schlaf, Herzfrequenz, Schritte und Zyklus aus deiner Gesundheits-App';

  @override
  String get healthTitle => 'Gesundheitsdaten';

  @override
  String healthIntro(String store) {
    return 'Wähle, was aus $store gelesen wird. Jeder Typ hat seinen eigenen Schalter und seinen eigenen Grund.';
  }

  @override
  String get healthPrivacyNote =>
      'Importierte Daten bleiben auf diesem Telefon. Sie werden nie hochgeladen, auch nicht mit dem Backup, außer du exportierst sie selbst.';

  @override
  String get healthStoreApple => 'Apple Health';

  @override
  String get healthStoreConnect => 'Health Connect';

  @override
  String healthUnavailable(String store) {
    return '$store ist auf diesem Gerät nicht verfügbar.';
  }

  @override
  String get healthReadSection => 'Lesen';

  @override
  String get healthTypeSleep => 'Schlaf';

  @override
  String get healthReasonSleep =>
      'Trägt die Schlafqualität im täglichen Check-in aus der Nacht ein, damit du einen Tipp weniger hast.';

  @override
  String get healthTypeRestingHr => 'Ruhepuls';

  @override
  String get healthReasonRestingHr =>
      'Ein höherer Ruhepuls als sonst kann am Tag vor einer Attacke Belastung zeigen.';

  @override
  String get healthTypeHrv => 'Herzfrequenzvariabilität';

  @override
  String get healthReasonHrv =>
      'Eine niedrigere Variabilität als sonst geht oft mit Stress und schlechter Erholung einher.';

  @override
  String get healthTypeSteps => 'Schritte';

  @override
  String get healthReasonSteps =>
      'Tage mit sehr wenig oder sehr viel Bewegung lohnen einen Blick neben deinen Attacken.';

  @override
  String get healthTypeFlow => 'Menstruationsblutung';

  @override
  String get healthReasonFlow =>
      'Trägt Periodenbeginne für die Zykluserfassung ein, falls du sie nutzt.';

  @override
  String healthDenied(String store) {
    return '$store hat keinen Zugriff gewährt. Du kannst das in den Einstellungen von $store ändern.';
  }

  @override
  String get healthWriteSection => 'Schreiben';

  @override
  String healthWriteHeadaches(String store) {
    return 'Kopfschmerzereignisse in $store schreiben';
  }

  @override
  String get healthWriteHeadachesHint =>
      'Jede beendete Attacke wird als Kopfschmerz mit Beginn, Ende und Stärke gespeichert. Sonst wird nichts geschrieben.';

  @override
  String get healthImportSection => 'Import';

  @override
  String get healthImportNow => 'Jetzt importieren';

  @override
  String get healthImportNever => 'Noch nichts importiert';

  @override
  String healthImportLast(String age) {
    return '$age';
  }

  @override
  String get healthImportFailed =>
      'Der Import wurde nicht abgeschlossen. Versuche es später erneut.';

  @override
  String healthImportResult(int imported, int prefilled) {
    String _temp0 = intl.Intl.pluralLogic(
      imported,
      locale: localeName,
      other: '$imported neue Messwerte.',
      one: '1 neuer Messwert.',
      zero: 'Nichts Neues.',
    );
    String _temp1 = intl.Intl.pluralLogic(
      prefilled,
      locale: localeName,
      other: 'Schlaf für $prefilled Tage eingetragen.',
      one: 'Schlaf für 1 Tag eingetragen.',
      zero: '',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get checkinSourceHealthkit => 'Aus Apple Health';

  @override
  String get checkinSourceHealthConnect => 'Aus Health Connect';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingFinish => 'Fertig';

  @override
  String onboardingStep(int step, int total) {
    return 'Schritt $step von $total';
  }

  @override
  String get onboardingWelcomeTitle => 'Willkommen';

  @override
  String get onboardingLocationTitle => 'Das Wetter in deiner Gegend';

  @override
  String get onboardingLocationBody =>
      'Luftdruckänderungen gehören zu dem, was Menschen am häufigsten vor einer Attacke bemerken. Erlaube einen ungefähren Standort oder wähle eine Stadt, um sie zu sehen.';

  @override
  String get onboardingLocationNone =>
      'Noch kein Standort. Du kannst ihn auch später auf dem Umgebungsbildschirm festlegen.';

  @override
  String get onboardingHealthTitle => 'Gesundheitsdaten';

  @override
  String get onboardingHealthBody =>
      'Optional. Jeder Typ hat seinen eigenen Schalter und seinen eigenen Grund. Du kannst alles später in den Einstellungen ändern.';

  @override
  String get onboardingHealthUnavailable =>
      'Auf diesem Gerät ist keine Gesundheits-App verfügbar. Du kannst diesen Schritt überspringen.';

  @override
  String get onboardingReminderTitle => 'Täglicher Check-in';

  @override
  String get onboardingReminderBody =>
      'Drei Tipps am Tag, etwa zehn Sekunden. Wähle eine Uhrzeit für die Erinnerung.';

  @override
  String get onboardingReminderNote =>
      'Erinnerungen starten, sobald Benachrichtigungen eingerichtet sind. Die Uhrzeit kannst du jeden Tag im Check-in ändern.';

  @override
  String get explainerTitle => 'Was das Niveau bedeutet';

  @override
  String get explainerIntro =>
      'Jeden Tag zeigt die App ein Niveau aus deinem eigenen Verlauf und den heutigen Bedingungen.';

  @override
  String get explainerDoesTitle => 'Was es tut';

  @override
  String get explainerDoes1 =>
      'Zeigt, wie Wetter, Schlaf, Stress und Alltag heute im Vergleich zu den Tagen vor deinen früheren Attacken aussehen.';

  @override
  String get explainerDoes2 =>
      'Lernt aus deinem eigenen Tagebuch und wird umso genauer, je mehr du einträgst.';

  @override
  String get explainerDoes3 =>
      'Hilft dir zu entscheiden, ob du es heute ruhiger angehen lassen möchtest.';

  @override
  String get explainerDoesNotTitle => 'Was es nicht tut';

  @override
  String get explainerDoesNot1 =>
      'Es kündigt keine Attacke an. Ein hohes Niveau ist ein Muster, keine Gewissheit, und ein niedriges Niveau ist kein Versprechen.';

  @override
  String get explainerDoesNot2 =>
      'Es ist keine ärztliche Einschätzung und ersetzt nicht deine Ärztin oder deinen Arzt.';

  @override
  String get explainerDoesNot3 =>
      'Es schickt dein Tagebuch nirgendwohin. Das Niveau wird auf diesem Telefon berechnet.';

  @override
  String get riskCardTitle => 'Niveau heute';

  @override
  String get riskCardEmpty =>
      'Noch kein Niveau. Mach einen Check-in oder lass das Wetter laden.';

  @override
  String get riskScreenTitle => 'Dein Niveau';

  @override
  String get riskWhyTitle => 'Warum';

  @override
  String get riskNoDrivers => 'Nichts sticht hervor.';

  @override
  String get riskNextDays => 'Nächste Tage';

  @override
  String get riskDayToday => 'Heute';

  @override
  String get riskDayTomorrow => 'Morgen';

  @override
  String riskLoad(String value) {
    return 'Belastung $value von 100';
  }

  @override
  String riskConfidence(String label) {
    return 'Sicherheit: $label';
  }

  @override
  String get riskConfidenceLow => 'gering';

  @override
  String get riskConfidenceMedium => 'mittel';

  @override
  String get riskConfidenceHigh => 'hoch';

  @override
  String riskStillLearning(int count, int needed) {
    return 'Lernt noch: $count von $needed Attacken eingetragen';
  }

  @override
  String get riskTuned => 'An dein Tagebuch angepasst';

  @override
  String riskDriverPoints(String points) {
    return '$points Punkte';
  }

  @override
  String riskUpdated(String time) {
    return 'Aktualisiert $time';
  }

  @override
  String get riskExplainerLink => 'Was das Niveau bedeutet';

  @override
  String get riskOpenCheckin => 'Heutigen Check-in machen';

  @override
  String get riskFactorPressureDrop => 'Fallender Luftdruck';

  @override
  String get riskFactorHumidity => 'Hohe Luftfeuchtigkeit';

  @override
  String get riskFactorTemperatureSwing => 'Temperaturwechsel';

  @override
  String get riskFactorAirQuality => 'Luftqualität';

  @override
  String get riskFactorPollen => 'Pollen';

  @override
  String get riskFactorBrightLight => 'Helles Licht';

  @override
  String get riskFactorScreenTime => 'Bildschirmzeit';

  @override
  String get riskFactorPoorSleep => 'Schlechter Schlaf';

  @override
  String get riskFactorStress => 'Stress';

  @override
  String get riskFactorNeckTension => 'Nackenverspannung';

  @override
  String get riskFactorCaffeine => 'Koffein';

  @override
  String get riskFactorAlcohol => 'Alkohol';

  @override
  String get riskFactorDehydration => 'Wenig getrunken';

  @override
  String get riskFactorCyclePhase => 'Zyklusphase';

  @override
  String get loadMeterTitle => 'Belastung';

  @override
  String loadMeterSemantics(String value, String segments) {
    return 'Belastung $value von 100. $segments';
  }

  @override
  String loadSegmentDetail(String name, String points) {
    return '$name: $points Punkte';
  }

  @override
  String loadThresholdModerate(String value) {
    return 'Mittel ab $value';
  }

  @override
  String loadThresholdHigh(String value) {
    return 'Hoch ab $value';
  }

  @override
  String get loadMeterEmpty => 'Noch keine Belastung';

  @override
  String get insightsTitle => 'Deine Faktoren';

  @override
  String get insightsIntro =>
      'Wie oft in deinem eigenen Tagebuch eine Attacke auf jeden Faktor folgte, verglichen mit deiner üblichen Rate.';

  @override
  String get insightsTriggers => 'Häufiger Attacken danach';

  @override
  String get insightsProtectors => 'Seltener Attacken danach';

  @override
  String get insightsNeutral => 'Kein klarer Effekt';

  @override
  String get insightsNotEnough => 'Noch nicht genug Daten';

  @override
  String get insightsEmptyBucket => 'Hier ist noch nichts.';

  @override
  String insightsSample(int days, int attacks) {
    return '$days Tage mit dem Faktor, $attacks davon mit Attacke danach';
  }

  @override
  String insightsLift(String ratio) {
    return '$ratio× deine übliche Rate';
  }

  @override
  String insightsNeedMore(int days, int needed) {
    return '$days von $needed Tagen mit dem Faktor eingetragen';
  }

  @override
  String get insightsNoRunYet =>
      'Trage eine Attacke ein und beende sie, um mit dem Zählen zu beginnen.';

  @override
  String get insightsMethodLink => 'Wie gezählt wird';

  @override
  String get insightsMethodTitle => 'Wie gezählt wird';

  @override
  String insightsMethod1(String pressure) {
    return 'Ein Tag mit dem Faktor ist ein Tag, an dem der Faktor in deinem Tagebuch oder im Wetter vorkam, zum Beispiel eine Schlafantwort von 1 oder ein Luftdruckabfall von mehr als $pressure.';
  }

  @override
  String get insightsMethod2 =>
      'Eine Attacke gilt als Folge eines Tages, wenn sie an diesem oder am nächsten Tag begann, also in den 24 bis 48 Stunden, die das Modell betrachtet.';

  @override
  String get insightsMethod3 =>
      'Das Verhältnis vergleicht, wie oft Attacken auf die Tage dieses Faktors folgten, mit der Häufigkeit nach irgendeinem Tag in deinem Tagebuch. 1,5× heißt eineinhalbmal deine übliche Rate; 0,5× heißt halb so oft.';

  @override
  String insightsMethod4(int needed) {
    return 'Ein Faktor braucht $needed Tage, bevor er eingeordnet wird. Bis dahin steht er unter „Noch nicht genug Daten“. Seltener Attacken nach einem Faktor sind genauso wissenswert wie häufiger, daher stehen beide Listen gleichrangig.';
  }

  @override
  String get insightsMethod5 =>
      'Nichts davon ist eine Ursache. Ein Faktor kann in einer Liste stehen, weil er mit etwas anderem zusammen auftritt, etwa Wochenenden oder einem Medikamentenwechsel. Nutze die Listen, um zu entscheiden, was du ausprobierst, nicht, wem du die Schuld gibst.';

  @override
  String get riskInsightsLink => 'Deine Faktoren';

  @override
  String get settingsInsightsHint =>
      'Auf welche Faktoren in deinem Tagebuch Attacken folgten';

  @override
  String get notificationsTitle => 'Benachrichtigungen';

  @override
  String get settingsNotificationsHint =>
      'Niveau-Hinweise, Luftdruckabfall, Erinnerungen';

  @override
  String get notificationsIntro =>
      'Alles wird auf diesem Telefon aus der gespeicherten Vorhersage und deinem Tagebuch geplant. Schalte jeden Typ aus, den du nicht möchtest.';

  @override
  String get notificationsPermissionDenied =>
      'Benachrichtigungen sind für diese App in den Systemeinstellungen ausgeschaltet.';

  @override
  String get notifTypeRiskRising => 'Niveau steigt';

  @override
  String get notifTypeRiskRisingHint =>
      'Am Abend davor und am Morgen eines Tages mit höherem Niveau';

  @override
  String get notifTypePressureDrop => 'Luftdruckabfall';

  @override
  String notifTypePressureDropHint(String pressure) {
    return 'Wenn die Vorhersage einen Abfall von $pressure oder mehr in 24 Stunden zeigt';
  }

  @override
  String get notifTypeAttackOver => 'Ist deine Attacke vorbei?';

  @override
  String get notifTypeAttackOverHint =>
      'Nach deiner typischen Attackendauer, mit einer Beenden-Schaltfläche';

  @override
  String get notifTypeCheckin => 'Check-in-Erinnerung';

  @override
  String get notifTypeCheckinHint => 'Zur unter „Täglich“ eingestellten Zeit';

  @override
  String get notifTypeMedication => 'Erinnerung an die Vorbeugung';

  @override
  String get notifTypeMedicationHint =>
      'Ein täglicher Hinweis für eine vorbeugende Einnahme';

  @override
  String notifPressureThreshold(String pressure) {
    return 'Schwelle für Luftdruckabfall: $pressure in 24 h';
  }

  @override
  String get notifMedicationTime => 'Uhrzeit der Vorbeugungs-Erinnerung';

  @override
  String notifRiskEveningTitle(String level) {
    return 'Niveau morgen: $level';
  }

  @override
  String notifRiskEveningBody(String level, String driver) {
    return 'Dein Niveau für morgen ist $level. Ganz oben auf der Liste: $driver.';
  }

  @override
  String notifRiskMorningTitle(String level) {
    return 'Niveau heute: $level';
  }

  @override
  String notifRiskMorningBody(String level, String driver) {
    return 'Dein Niveau heute ist $level. Ganz oben auf der Liste: $driver.';
  }

  @override
  String get notifPressureTitle => 'Der Luftdruck fällt';

  @override
  String notifPressureBody(String pressure, String time) {
    return 'Bis $time wird ein Abfall um $pressure erwartet.';
  }

  @override
  String get notifAttackOverTitle => 'Ist deine Attacke vorbei?';

  @override
  String notifAttackOverBody(String duration) {
    return 'Sie hat vor $duration begonnen. Beende sie hier, wenn sie vorüber ist.';
  }

  @override
  String get notifEndAttackAction => 'Attacke beenden';

  @override
  String get notifCheckinTitle => 'Drei Tipps für heute';

  @override
  String get notifCheckinBody =>
      'Schlaf, Stress und Nackenverspannung. Fünfzehn Sekunden.';

  @override
  String get notifMedicationTitle => 'Vorbeugende Einnahme';

  @override
  String get notifMedicationBody =>
      'Zeit für dein heutiges vorbeugendes Medikament, falls du eins nimmst.';

  @override
  String get notifChannelAlerts => 'Hinweise';

  @override
  String get notifChannelAlertsDescription =>
      'Niveau- und Luftdruck-Hinweise aus der gespeicherten Vorhersage';

  @override
  String get notifChannelReminders => 'Erinnerungen';

  @override
  String get notifChannelRemindersDescription =>
      'Erinnerungen an Check-in und vorbeugende Einnahme';

  @override
  String get notifChannelAttack => 'Attacke';

  @override
  String get notifChannelAttackDescription =>
      'Fragen zu einer laufenden Attacke';

  @override
  String get reportTitle => 'Bericht für die Praxis';

  @override
  String get settingsReportHint => 'PDF und Tabelle für einen Zeitraum';

  @override
  String get reportIntro =>
      'Eine Zusammenfassung deiner Einträge für den nächsten Termin. Wähle einen Zeitraum und teile dann das PDF oder die Tabellen.';

  @override
  String get reportRangeLabel => 'Zeitraum';

  @override
  String reportRangeDays(int days) {
    return '$days Tage';
  }

  @override
  String get reportRangeCustom => 'Eigener';

  @override
  String reportRangeText(String from, String to) {
    return '$from bis $to';
  }

  @override
  String reportPreviewAttacks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Attacken',
      one: '1 Attacke',
      zero: 'Keine Attacken',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewAttackDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Attackentage',
      one: '1 Attackentag',
      zero: 'keine Attackentage',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewDoses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einnahmen',
      one: '1 Einnahme',
      zero: 'keine Einnahmen',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewCheckins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Check-ins',
      one: '1 Check-in',
      zero: 'keine Check-ins',
    );
    return '$_temp0';
  }

  @override
  String get reportEmpty => 'In diesem Zeitraum ist noch nichts eingetragen.';

  @override
  String get reportSharePdf => 'PDF teilen';

  @override
  String get reportShareCsv => 'Tabellen teilen';

  @override
  String get reportShareAll => 'Alles teilen';

  @override
  String get reportBuilding => 'Bericht wird erstellt';

  @override
  String get reportFailed =>
      'Der Bericht konnte nicht erstellt werden. Versuche es erneut.';

  @override
  String get reportWhatIsIn => 'Was das PDF enthält';

  @override
  String get reportContents =>
      'Attackenkalender, Monatszahlen, Dauer, Faktoren mit ihren Stichprobengrößen, Medikamententage, Luftdruckänderungen, Symptome und Schmerzorte. Keine Namen, keine Notizen.';

  @override
  String reportPdfTitle(String app) {
    return '$app-Bericht';
  }

  @override
  String reportPdfPeriod(String from, String to, int days) {
    return 'Zeitraum: $from bis $to ($days Tage)';
  }

  @override
  String reportPdfGenerated(String date) {
    return 'Erstellt am $date auf dem Gerät der Person aus ihrem eigenen Tagebuch.';
  }

  @override
  String get reportPdfDisclaimer =>
      'Dies ist die Zusammenfassung eines selbst geführten Tagebuchs aus einer Wellness-App. Es ist keine Patientenakte und ersetzt keine ärztliche Beurteilung. Die Faktor-Verhältnisse beschreiben nur das Tagebuch dieser Person und sind keine Ursachen.';

  @override
  String reportPdfPage(int page, int pages) {
    return 'Seite $page von $pages';
  }

  @override
  String get reportSectionOverview => 'Überblick';

  @override
  String get reportStatAttacks => 'Attacken';

  @override
  String get reportStatAttackDays => 'Attackentage';

  @override
  String get reportStatPerMonth => 'Attacken pro 30 Tage';

  @override
  String get reportStatMeanIntensity => 'Mittlere Stärke (0-10)';

  @override
  String get reportStatAcuteDays => 'Tage mit Akutmedikation';

  @override
  String get reportStatCheckins => 'Tage mit Check-in';

  @override
  String get reportSectionMonths => 'Nach Monat';

  @override
  String get reportColMonth => 'Monat';

  @override
  String get reportColAttacks => 'Attacken';

  @override
  String get reportColAttackDays => 'Attackentage';

  @override
  String get reportColMeanIntensity => 'Mittlere Stärke';

  @override
  String get reportColAcuteDays => 'Akuttage';

  @override
  String get reportColNote => 'Hinweis';

  @override
  String get reportOveruseWatch => '10+ Akuttage';

  @override
  String get reportOveruseHigh => '15+ Akuttage';

  @override
  String get reportSectionCalendar => 'Attackenkalender';

  @override
  String get reportCalendarHint =>
      'Ein Feld pro Tag. Schattierte Felder hatten eine Attacke; die Zahl ist die höchste Stärke an diesem Tag.';

  @override
  String get reportSectionDuration => 'Attackendauer';

  @override
  String get reportDurationNone =>
      'Keine beendeten Attacken in diesem Zeitraum.';

  @override
  String reportDurationSummary(
    int count,
    String shortest,
    String median,
    String longest,
  ) {
    return '$count beendete Attacken. Kürzeste $shortest, Median $median, längste $longest.';
  }

  @override
  String get reportBucketUnderFour => 'Unter 4 h';

  @override
  String get reportBucketFourToTwelve => '4 bis 12 h';

  @override
  String get reportBucketTwelveToDay => '12 bis 24 h';

  @override
  String get reportBucketOneToThreeDays => '1 bis 3 Tage';

  @override
  String get reportBucketOverThreeDays => 'Über 3 Tage';

  @override
  String get reportSectionTriggers => 'Faktoren im Tagebuch der Person';

  @override
  String reportTriggersHint(int floor) {
    return 'Verhältnis der Attacken nach Tagen mit dem Faktor zur üblichen Rate der Person, mit der Zahl der zugrunde liegenden Tage. Unter $floor Tagen wird kein Verhältnis gezeigt.';
  }

  @override
  String get reportTriggersNone =>
      'Noch nicht genug eingetragene Tage, um Faktoren zu vergleichen.';

  @override
  String get reportColFactor => 'Faktor';

  @override
  String get reportColRatio => 'Verhältnis';

  @override
  String get reportColExposures => 'Tage mit Faktor';

  @override
  String get reportColFollowed => 'Mit Attacke danach';

  @override
  String get reportColConfidence => 'Datenlage';

  @override
  String get reportConfidenceLow => 'schwach';

  @override
  String get reportConfidenceMedium => 'mittel';

  @override
  String get reportConfidenceHigh => 'gut';

  @override
  String get reportSectionMedications => 'Medikamente';

  @override
  String get reportMedicationsNone =>
      'In diesem Zeitraum keine Einnahmen eingetragen.';

  @override
  String get reportColMedication => 'Medikament';

  @override
  String get reportColKind => 'Art';

  @override
  String get reportColDoses => 'Einnahmen';

  @override
  String get reportColDays => 'Tage';

  @override
  String get reportColRelief =>
      'Linderung nach 2 h (keine / teilweise / vollständig)';

  @override
  String get reportKindAcute => 'akut';

  @override
  String get reportKindPreventive => 'vorbeugend';

  @override
  String get reportSectionWeather => 'Luftdruck';

  @override
  String reportWeatherHint(String pressure) {
    return 'Ein Abfall ist ein Rückgang um $pressure oder mehr in 24 h zum Zeitpunkt des Eintrags.';
  }

  @override
  String get reportWeatherNone => 'Keine Wetterdaten in diesem Zeitraum.';

  @override
  String reportWeatherAttacks(int fall, int total) {
    return '$fall von $total Attacken begannen nach einem Luftdruckabfall.';
  }

  @override
  String reportWeatherDays(int fall, int total) {
    return '$fall von $total Check-in-Tagen hatten einen.';
  }

  @override
  String reportWeatherLift(String lift) {
    return 'Verhältnis: ${lift}x (1,0 bedeutet kein Zusammenhang).';
  }

  @override
  String get reportSectionSymptoms => 'Symptome und Schmerzorte';

  @override
  String get reportSymptomsNone =>
      'Keine Symptome oder Schmerzorte eingetragen.';

  @override
  String reportCountOfAttacks(String name, int count, int total) {
    return '$name: $count von $total Attacken';
  }

  @override
  String reportHoursShort(String hours) {
    return '$hours h';
  }

  @override
  String get notifTypeQuestionnaire => 'Fragebögen alle drei Monate';

  @override
  String get notifTypeQuestionnaireHint =>
      'MIDAS und HIT-6, drei Monate nach der letzten Runde';

  @override
  String get notifQuestionnaireTitle =>
      'Drei Monate seit deinen letzten Fragebögen';

  @override
  String get notifQuestionnaireBody =>
      'Fülle MIDAS und HIT-6 erneut aus, um das letzte Quartal zu vergleichen.';

  @override
  String get questionnairesTitle => 'Fragebögen';

  @override
  String get settingsQuestionnairesHint =>
      'MIDAS und HIT-6, ausgewertet und als Diagramm';

  @override
  String get questionnairesIntro =>
      'Zwei kurze, validierte Fragebögen zu den letzten drei Monaten. Wiederhole sie jedes Quartal: Die Werte erscheinen hier als Diagramm und können in den Bericht für die Praxis aufgenommen werden.';

  @override
  String get questionnaireMidasTitle => 'MIDAS';

  @override
  String get questionnaireMidasSubtitle =>
      'Migraine Disability Assessment: fünf Tageszählungen über die letzten drei Monate';

  @override
  String get questionnaireHit6Title => 'HIT-6';

  @override
  String get questionnaireHit6Subtitle =>
      'Headache Impact Test: sechs Fragen dazu, wie Kopfschmerzen dein Leben beeinflussen';

  @override
  String get questionnaireNeverDone => 'Noch nicht ausgefüllt';

  @override
  String questionnaireLatest(int score, String date) {
    return 'Letzter Wert $score am $date';
  }

  @override
  String get questionnaireDueNow => 'Jetzt fällig';

  @override
  String questionnaireDueOn(String date) {
    return 'Nächste Runde $date';
  }

  @override
  String get questionnaireStart => 'Ausfüllen';

  @override
  String get questionnaireRepeat => 'Erneut ausfüllen';

  @override
  String get questionnaireHistory => 'Verlauf der Werte';

  @override
  String questionnaireChartLabel(
    int count,
    String first,
    String last,
    int latest,
  ) {
    return '$count Werte von $first bis $last, zuletzt $latest';
  }

  @override
  String get questionnaireAbout => 'Zu den Werten';

  @override
  String get questionnaireAboutBody =>
      'MIDAS addiert fünf Tageszählungen: 0 bis 5 ist Grad I (geringe oder keine Beeinträchtigung), 6 bis 10 Grad II (leicht), 11 bis 20 Grad III (mäßig), ab 21 Grad IV (schwer). HIT-6 gibt 6, 8, 10, 11 oder 13 Punkte pro Antwort, insgesamt 36 bis 78: bis 49 geringe oder keine Auswirkung, 50 bis 55 einige Auswirkung, 56 bis 59 deutliche Auswirkung, ab 60 schwere Auswirkung. Die Bereiche sind die veröffentlichten; die Werte sind zum Besprechen mit deiner Ärztin oder deinem Arzt gedacht.';

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
  String get questionnaireMidasUnscored => 'Geht nicht in den Wert ein';

  @override
  String get questionnaireDaysField => 'Tage (0 bis 90)';

  @override
  String get questionnairePainField => 'Schmerz (0 bis 10)';

  @override
  String questionnaireDaysError(int max) {
    return 'Gib eine Zahl von 0 bis $max ein';
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
  String get questionnaireSave => 'Speichern und auswerten';

  @override
  String get questionnaireIncomplete =>
      'Beantworte alle gewerteten Fragen, um zu speichern.';

  @override
  String questionnaireResultTitle(int score) {
    return 'Dein Wert: $score';
  }

  @override
  String get questionnaireResultDone => 'Fertig';

  @override
  String get questionnaireResultDisclaimer =>
      'Ein Wert beschreibt die letzten drei Monate so, wie du sie in Erinnerung hast. Er ist ein Ausgangspunkt für ein Gespräch mit deiner Ärztin oder deinem Arzt, keine ärztliche Beurteilung.';

  @override
  String get questionnaireMidasBandMinimal =>
      'Grad I: geringe oder keine Beeinträchtigung';

  @override
  String get questionnaireMidasBandMild => 'Grad II: leichte Beeinträchtigung';

  @override
  String get questionnaireMidasBandModerate =>
      'Grad III: mäßige Beeinträchtigung';

  @override
  String get questionnaireMidasBandSevere =>
      'Grad IV: schwere Beeinträchtigung';

  @override
  String get questionnaireHit6BandMinimal => 'Geringe oder keine Auswirkung';

  @override
  String get questionnaireHit6BandMild => 'Einige Auswirkung';

  @override
  String get questionnaireHit6BandModerate => 'Deutliche Auswirkung';

  @override
  String get questionnaireHit6BandSevere => 'Schwere Auswirkung';

  @override
  String get reportIncludeQuestionnaires => 'Fragebogenwerte aufnehmen';

  @override
  String get reportIncludeQuestionnairesHint =>
      'Im Zeitraum abgeschlossene MIDAS- und HIT-6-Runden';

  @override
  String get reportSectionQuestionnaires => 'Fragebögen';

  @override
  String get reportQuestionnairesNone =>
      'In diesem Zeitraum keine Fragebögen abgeschlossen.';

  @override
  String get reportColDate => 'Datum';

  @override
  String get reportColQuestionnaire => 'Fragebogen';

  @override
  String get reportColScore => 'Wert';

  @override
  String get reportColBand => 'Bereich';

  @override
  String get voiceButton => 'Per Sprache eintragen';

  @override
  String get voiceListening => 'Hört zu';

  @override
  String get voiceListeningHint =>
      'Sag, wie es sich anfühlt, zum Beispiel: Schmerz sieben von zehn, hinter den Augen, Übelkeit, Ibuprofen genommen.';

  @override
  String get voiceStop => 'Fertig gesprochen';

  @override
  String get voiceCancel => 'Abbrechen';

  @override
  String get voiceTryAgain => 'Erneut versuchen';

  @override
  String get voiceUnavailable =>
      'Spracheingabe ist auf diesem Telefon nicht verfügbar. Die Spracherkennung braucht die Mikrofon-Berechtigung und ein Offline-Sprachpaket für deine Sprache.';

  @override
  String get voiceNoMatch =>
      'Es wurde nichts gehört. Versuche es näher am Telefon oder tippe stattdessen auf die Felder.';

  @override
  String get voiceReviewTitle => 'Vor dem Speichern prüfen';

  @override
  String voiceHeard(String text) {
    return 'Gehört: „$text“';
  }

  @override
  String get voiceNothingUnderstood =>
      'Nichts im Formular passte zum Gesagten. Tippe auf die Felder oder versuche es erneut.';

  @override
  String get voiceIntensity => 'Stärke';

  @override
  String get voiceIntensityNone => 'Nicht gesagt';

  @override
  String get voiceSymptoms => 'Symptome';

  @override
  String get voiceLocations => 'Wo es wehtut';

  @override
  String get voiceMedications => 'Jetzt eingenommene Medikamente';

  @override
  String get voiceSave => 'In Attacke speichern';

  @override
  String widgetLevel(String level) {
    return 'Niveau: $level';
  }

  @override
  String get widgetNoLevel => 'Öffne die App, um das heutige Niveau zu laden';

  @override
  String widgetDriver(String factor) {
    return 'Wichtigster Faktor: $factor';
  }

  @override
  String get widgetNoDriver => 'Kein einzelner Faktor sticht hervor';

  @override
  String widgetPressureFalling(String pressure) {
    return 'Luftdruck fällt um $pressure in 24 h';
  }

  @override
  String widgetPressureRising(String pressure) {
    return 'Luftdruck steigt um $pressure in 24 h';
  }

  @override
  String get widgetPressureSteady => 'Luftdruck gleichbleibend';

  @override
  String get widgetPressureUnknown => 'Noch keine Luftdruckvorhersage';

  @override
  String widgetUpdated(String time) {
    return 'Aktualisiert $time';
  }

  @override
  String get widgetStartAttack => 'Attacke starten';

  @override
  String get widgetOpenAttack => 'Attacke öffnen';

  @override
  String get watchStart => 'Attacke starten';

  @override
  String get watchStop => 'Attacke beenden';

  @override
  String get watchIntensity => 'Stärke';

  @override
  String watchSince(String time) {
    return 'Seit $time';
  }

  @override
  String get watchPending =>
      'Auf der Uhr gespeichert. Wird gesendet, sobald dein Telefon in der Nähe ist.';

  @override
  String get watchNoPhone =>
      'Öffne die App einmal auf deinem Telefon, um die Uhr zu verbinden.';

  @override
  String get routinesTitle => 'Routinen zur Selbstfürsorge';

  @override
  String get routinesIntro =>
      'Einfache Dinge, die vielen Menschen an schweren Tagen helfen. Nutze, was zu dir passt, und lass den Rest weg.';

  @override
  String get routineCardTitle => 'Etwas, das heute helfen könnte';

  @override
  String get routineNotToday => 'Heute nicht';

  @override
  String get routineSeeAll => 'Alle Routinen';

  @override
  String get routineStepsTitle => 'So geht\'s';

  @override
  String get routineReasonHighDay => 'Das heutige Niveau ist hoch';

  @override
  String get routineReasonNeckTension =>
      'Dein Check-in zeigt Nackenverspannung';

  @override
  String get routineReasonStress => 'Dein Check-in zeigt hohen Stress';

  @override
  String get routineStretchesTitle =>
      'Sanfte Dehnungen für Nacken und Schultern';

  @override
  String get routineStretchesSummary =>
      'Fünf langsame Bewegungen gegen Verspannungen in Nacken und Schultern. Hör auf, wenn etwas wehtut.';

  @override
  String get routineStretchesSteps =>
      'Setz dich aufrecht hin, die Schultern locker, die Füße flach auf dem Boden.\nNeige das rechte Ohr langsam zur rechten Schulter. Halte 15 Sekunden, dann wechsle die Seite.\nSenke das Kinn zur Brust und halte 15 Sekunden.\nKreise die Schultern fünfmal nach hinten, dann fünfmal nach vorn.\nVerschränke die Hände hinter dem Rücken und öffne die Brust sanft für 15 Sekunden.';

  @override
  String get routineBreathingTitle => 'Ruhiges Atmen';

  @override
  String get routineBreathingSummary =>
      'Atme etwa eine Minute lang 4 Sekunden ein und 6 Sekunden aus. Langsames Ausatmen hilft vielen, zur Ruhe zu kommen.';

  @override
  String get routineBreathingSteps =>
      'Setz oder leg dich bequem hin.\nAtme durch die Nase ein, während der Kreis wächst.\nAtme langsam aus, während er schrumpft.\nMach sechs Runden weiter oder so lange, wie es dir guttut.';

  @override
  String get routineLowLightTitle => 'Wenig Licht und Ruhe';

  @override
  String get routineLowLightSummary =>
      'Helles Licht und Lärm stören viele Menschen an empfindlichen Tagen und während einer Attacke.';

  @override
  String get routineLowLightSteps =>
      'Dimme das Licht oder zieh die Vorhänge zu.\nSchalte den Dunkelmodus ein und verringere die Bildschirmhelligkeit.\nTrag eine Schlafmaske oder Sonnenbrille, wenn dich das Licht noch stört.\nVerringere Lärm mit Ohrstöpseln oder einem ruhigen Raum.';

  @override
  String get routineHydrationTitle => 'Etwas Wasser trinken';

  @override
  String get routineHydrationSummary =>
      'Wenn Wasser in Reichweite steht, fällt es leichter, über den Tag verteilt zu trinken.';

  @override
  String get routineHydrationSteps =>
      'Stell dir ein Glas oder eine Flasche Wasser in Reichweite.\nTrink jede Stunde ein paar Schlucke.\nTrink zu jeder Mahlzeit ein Glas Wasser.';

  @override
  String get routineCaffeineTitle => 'Koffein gleichmäßig halten';

  @override
  String get routineCaffeineSummary =>
      'Große Änderungen der Koffeinmenge können für manche Menschen eine Rolle spielen.';

  @override
  String get routineCaffeineSteps =>
      'Nimm Koffein jeden Tag ungefähr zu denselben Zeiten zu dir.\nVermeide große Steigerungen und lass deine übliche Menge nicht plötzlich weg.\nTrink dein letztes koffeinhaltiges Getränk bis zum frühen Nachmittag.';

  @override
  String get routineSleepTitle => 'Regelmäßiger Schlaf';

  @override
  String get routineSleepSummary =>
      'Ein regelmäßiger Schlafrhythmus, auch am Wochenende, hilft vielen Menschen.';

  @override
  String get routineSleepSteps =>
      'Geh jeden Tag ungefähr zur selben Zeit ins Bett und steh zur selben Zeit auf.\nHalte das Schlafzimmer dunkel, ruhig und kühl.\nLeg Bildschirme 30 Minuten vor dem Schlafen weg.\nVermeide lange Nickerchen am späten Tag.';

  @override
  String get breathingStart => 'Atmen beginnen';

  @override
  String get breathingStop => 'Stopp';

  @override
  String get breathingIn => 'Einatmen';

  @override
  String get breathingOut => 'Ausatmen';

  @override
  String breathingRound(int round, int total) {
    return 'Runde $round von $total';
  }

  @override
  String get breathingDone =>
      'Fertig. Nimm dir einen Moment, bevor du aufstehst.';

  @override
  String get settingsRoutinesHint =>
      'Dehnungen, Atmen und andere einfache Routinen';

  @override
  String get experimentsTitle => 'Experimente';

  @override
  String get settingsExperimentsHint =>
      'Eine Änderung zwei Wochen lang testen und vergleichen';

  @override
  String get experimentsIntro =>
      'Teste eine Änderung zwei Wochen lang und vergleiche sie mit den zwei Wochen davor. Immer nur ein Experiment.';

  @override
  String get experimentsPick => 'Wähle eine Änderung';

  @override
  String get experimentChangeCutCaffeine => 'Weniger Koffein';

  @override
  String get experimentChangeRegularSleep =>
      'Jeden Abend zur gleichen Zeit schlafen gehen';

  @override
  String get experimentChangeMoreWater => 'Mehr Wasser trinken';

  @override
  String get experimentChangeDailyStretches => 'Täglich den Nacken dehnen';

  @override
  String get experimentChangeLessScreens => 'Abends weniger Bildschirmzeit';

  @override
  String get experimentChangeNoAlcohol => 'Auf Alkohol verzichten';

  @override
  String experimentDay(int day, int total) {
    return 'Tag $day von $total';
  }

  @override
  String get experimentAdherenceQuestion => 'Hast du es heute eingehalten?';

  @override
  String get experimentYes => 'Ja';

  @override
  String get experimentNo => 'Nein';

  @override
  String experimentAdherence(int kept, int days) {
    return 'An $kept von $days Tagen eingehalten';
  }

  @override
  String get experimentCompareTitle => 'Zwei Wochen davor und währenddessen';

  @override
  String get experimentBefore => 'Davor';

  @override
  String get experimentDuring => 'Während';

  @override
  String get experimentRowRate => 'Attacken pro Woche';

  @override
  String get experimentRowIntensity => 'Durchschnittliche Stärke';

  @override
  String get experimentRowDuration => 'Mittlere Dauer';

  @override
  String experimentSample(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aus $count Attacken',
      one: 'aus 1 Attacke',
      zero: 'keine Attacken',
    );
    return '$_temp0';
  }

  @override
  String experimentDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get experimentNoData => 'Keine Daten';

  @override
  String get experimentCaveat =>
      'Zwei Wochen sind kurz. Wetter, Jahreszeit und Stress ändern sich von selbst, also sieh das als Hinweis, nicht als Beweis.';

  @override
  String experimentSmallSample(int min) {
    return 'In einem der Zeiträume weniger als $min Attacken, die Zahlen können also stark schwanken.';
  }

  @override
  String get experimentStop => 'Experiment beenden';

  @override
  String get experimentFinish => 'Abschließen und Ergebnis speichern';

  @override
  String get experimentDue => 'Die zwei Wochen sind vorbei.';

  @override
  String get experimentPast => 'Frühere Experimente';

  @override
  String experimentFinished(String date) {
    return 'Abgeschlossen am $date';
  }

  @override
  String experimentStopped(String date) {
    return 'Beendet am $date';
  }

  @override
  String experimentPastSummary(String before, String during) {
    return '$before Attacken pro Woche davor, $during währenddessen';
  }

  @override
  String get accountTitle => 'Konto';

  @override
  String get settingsAccountHint => 'Optional. Nur für Backup und Links nötig';

  @override
  String get accountIntro =>
      'Ein Konto ist optional. Alles in der App funktioniert ohne, und deine Einträge bleiben auf diesem Handy. Es wird nur für das verschlüsselte Backup und Freigabelinks gebraucht.';

  @override
  String get accountUnavailable =>
      'Konten sind in dieser Version nicht eingerichtet.';

  @override
  String get accountApple => 'Weiter mit Apple';

  @override
  String get accountGoogle => 'Weiter mit Google';

  @override
  String get accountOrEmail => 'Oder mit deiner E-Mail-Adresse';

  @override
  String get accountEmail => 'E-Mail';

  @override
  String get accountPassword => 'Passwort';

  @override
  String accountPasswordHint(int min) {
    return 'Mindestens $min Zeichen für ein neues Konto';
  }

  @override
  String get accountSignIn => 'Anmelden';

  @override
  String get accountCreate => 'Konto erstellen';

  @override
  String get accountForgot => 'Passwort vergessen?';

  @override
  String get accountResetSent =>
      'Wenn zu dieser E-Mail ein Konto gehört, ist ein Link zum Zurücksetzen unterwegs.';

  @override
  String accountSignedInAs(String email) {
    return 'Angemeldet als $email';
  }

  @override
  String accountSignedInWith(String method) {
    return 'Angemeldet mit $method';
  }

  @override
  String get accountMethodApple => 'Apple';

  @override
  String get accountMethodGoogle => 'Google';

  @override
  String get accountMethodEmail => 'E-Mail';

  @override
  String get accountSignedInNote =>
      'Deine Einträge bleiben auf diesem Handy. Abmelden löscht nichts.';

  @override
  String get accountSignOut => 'Abmelden';

  @override
  String get accountDelete => 'Konto löschen';

  @override
  String get accountDeleteTitle => 'Konto löschen?';

  @override
  String accountDeleteBody(int hours) {
    return 'Damit wird dein Konto gelöscht. Innerhalb von $hours Stunden werden dein verschlüsseltes Backup und geteilte Links von unseren Servern entfernt. Alles auf diesem Handy bleibt erhalten.';
  }

  @override
  String get accountDeletePassword => 'Gib zur Bestätigung dein Passwort ein';

  @override
  String get accountDeleteSubscription =>
      'Premium wird über den App Store oder Google Play abgerechnet. Das Löschen des Kontos beendet es nicht; kündige es im Store.';

  @override
  String get accountDeleteCancel => 'Konto behalten';

  @override
  String accountDeleted(int hours) {
    return 'Konto gelöscht. Die Daten auf dem Server werden innerhalb von $hours Stunden gelöscht.';
  }

  @override
  String get accountErrorWrongCredentials =>
      'E-Mail und Passwort passen nicht zusammen.';

  @override
  String get accountErrorEmailInUse =>
      'Zu dieser E-Mail gibt es schon ein Konto. Versuch dich anzumelden.';

  @override
  String get accountErrorWeakPassword => 'Wähle ein längeres Passwort.';

  @override
  String get accountErrorInvalidEmail => 'Prüfe die E-Mail-Adresse.';

  @override
  String get accountErrorNetwork =>
      'Keine Verbindung. Versuch es erneut, wenn du online bist.';

  @override
  String get accountErrorRecentSignIn =>
      'Zur Sicherheit melde dich erneut an und versuch es noch einmal.';

  @override
  String get accountErrorUnknown =>
      'Etwas ist schiefgelaufen. Versuch es erneut.';

  @override
  String get backupTitle => 'Verschlüsseltes Backup';

  @override
  String get settingsBackupHint =>
      'Geschützt durch eine Passphrase, die nur du kennst';

  @override
  String get backupIntro =>
      'Dein Backup wird auf diesem Handy mit deiner Passphrase verschlüsselt, bevor es hochgeladen wird. Wir speichern nur die verschlüsselte Datei und können sie nicht öffnen.';

  @override
  String get backupForgetWarning =>
      'Wenn du die Passphrase vergisst, kann niemand das Backup öffnen, auch wir nicht. Schreib sie an einem sicheren Ort auf.';

  @override
  String get backupNeedsAccount =>
      'Für das Backup brauchst du ein Konto. Alles andere funktioniert ohne.';

  @override
  String get backupOpenAccount => 'Konto erstellen';

  @override
  String get backupNone => 'Noch kein Backup';

  @override
  String backupLast(String date) {
    return 'Letztes Backup: $date';
  }

  @override
  String get backupStatusUnknown =>
      'Das Backup konnte gerade nicht geprüft werden.';

  @override
  String get backupPassphrase => 'Passphrase';

  @override
  String backupPassphraseHint(int min) {
    return 'Mindestens $min Zeichen. Ein paar zusammenhanglose Wörter funktionieren gut.';
  }

  @override
  String get backupPassphraseRepeat => 'Passphrase für das Backup wiederholen';

  @override
  String get backupNow => 'Jetzt sichern';

  @override
  String get backupDone => 'Gesichert.';

  @override
  String get backupRestore => 'Aus Backup wiederherstellen';

  @override
  String get backupRestoreTitle => 'Alles auf diesem Handy ersetzen?';

  @override
  String backupRestoreBody(String date) {
    return 'Alles auf diesem Handy wird durch das Backup vom $date ersetzt.';
  }

  @override
  String get backupRestoreConfirm => 'Wiederherstellen';

  @override
  String get backupRestored => 'Aus deinem Backup wiederhergestellt.';

  @override
  String get backupDelete => 'Backup löschen';

  @override
  String get backupDeleteTitle => 'Backup löschen?';

  @override
  String get backupDeleteBody =>
      'Die verschlüsselte Datei wird von unseren Servern entfernt. Alles auf diesem Handy bleibt erhalten.';

  @override
  String get backupDeleted => 'Backup gelöscht.';

  @override
  String get backupWorking =>
      'Wird bearbeitet. Das kann ein paar Sekunden dauern.';

  @override
  String get backupErrorMismatch =>
      'Die beiden Passphrasen stimmen nicht überein.';

  @override
  String backupErrorShort(int min) {
    return 'Verwende mindestens $min Zeichen.';
  }

  @override
  String get backupErrorNoBackup =>
      'Für dieses Konto gibt es noch kein Backup.';

  @override
  String get backupErrorTooLarge => 'Das Backup ist zu groß zum Hochladen.';

  @override
  String get backupErrorNewerApp =>
      'Dieses Backup stammt aus einer neueren App-Version. Aktualisiere die App und versuch es erneut.';

  @override
  String get backupErrorWrongPassphrase =>
      'Mit dieser Passphrase lässt sich das Backup nicht öffnen.';

  @override
  String get backupErrorDamaged => 'Die Backup-Datei ist beschädigt.';

  @override
  String get backupErrorPinning =>
      'Die Verbindung zum Backup-Server ließ sich nicht überprüfen, deshalb wurde nichts gesendet. Versuch ein anderes Netzwerk.';

  @override
  String get backupErrorNotAllowed =>
      'Deine Anmeldung ist abgelaufen. Melde dich erneut an und versuch es noch einmal.';

  @override
  String get shareLinkButton => 'Als Link teilen';

  @override
  String get shareLinkTitle => 'Mit deiner Ärztin oder deinem Arzt teilen';

  @override
  String get shareLinkExplain =>
      'Wer den Link hat, kann diesen Bericht lesen, bis er abläuft. Er zeigt dieselbe Zusammenfassung wie das PDF, nicht dein Tagebuch. Du kannst das Teilen jederzeit beenden.';

  @override
  String get shareLinkNeedsAccount =>
      'Zum Teilen eines Links brauchst du ein Konto. PDF und CSV funktionieren ohne.';

  @override
  String shareLinkDuration(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get shareLinkCreate => 'Link erstellen';

  @override
  String get shareLinkWorking => 'Link wird erstellt.';

  @override
  String shareLinkReady(String date) {
    return 'Link fertig. Geteilt bis $date.';
  }

  @override
  String get shareLinkCopy => 'Link kopieren';

  @override
  String get shareLinkCopied => 'Link kopiert.';

  @override
  String get shareLinkShare => 'Link teilen';

  @override
  String shareLinkMessage(String url) {
    return 'Mein Migränebericht: $url';
  }

  @override
  String get shareLinksTitle => 'Geteilte Links';

  @override
  String get settingsShareLinksHint =>
      'Geteilte Berichtslinks ansehen und beenden';

  @override
  String get shareLinksEmpty =>
      'Du hast keine Links geteilt. Erstelle einen im Arztbericht.';

  @override
  String shareLinkActiveUntil(String date) {
    return 'Geteilt bis $date';
  }

  @override
  String shareLinkExpiredOn(String date) {
    return 'Abgelaufen am $date';
  }

  @override
  String get shareLinkRevoked => 'Teilen beendet';

  @override
  String shareLinkCreatedOn(String date) {
    return 'Erstellt am $date';
  }

  @override
  String get shareLinkRevoke => 'Teilen beenden';

  @override
  String get shareLinkRevokeTitle => 'Teilen dieses Berichts beenden?';

  @override
  String get shareLinkRevokeBody =>
      'Der Link funktioniert sofort nicht mehr, für alle, die ihn haben.';

  @override
  String get shareLinkRevokedDone =>
      'Teilen beendet. Der Link funktioniert nicht mehr.';

  @override
  String get shareLinkErrorUnavailable =>
      'Freigabelinks sind in dieser Version nicht eingerichtet.';

  @override
  String get shareLinkErrorSignedOut =>
      'Deine Anmeldung ist abgelaufen. Melde dich erneut an und versuch es noch einmal.';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumIntro =>
      'Premium bietet vier Extras. Alles andere bleibt kostenlos, ohne Zeitlimit.';

  @override
  String get premiumFreeNote =>
      'Immer kostenlos: Attacken und Tageseinträge erfassen, das Wetter, die Risikostufe, deine Faktoren, das Medikamentenprotokoll und der Arztbericht.';

  @override
  String get premiumFeatureShareLink => 'Link für die Ärztin oder den Arzt';

  @override
  String get premiumFeatureShareLinkHint =>
      'Sende deinen Bericht als Link, der nach 7 oder 30 Tagen nicht mehr funktioniert.';

  @override
  String get premiumFeatureExperiments => 'Experimente';

  @override
  String get premiumFeatureExperimentsHint =>
      'Teste eine Änderung zwei Wochen lang und vergleiche sie mit den Wochen davor.';

  @override
  String get premiumFeatureExtendedFactors => 'Erweiterte Umweltfaktoren';

  @override
  String get premiumFeatureExtendedFactorsHint =>
      'Feinstaub, Ozon und Pollen nach Art.';

  @override
  String get premiumFeatureBackup => 'Backup für mehrere Handys';

  @override
  String get premiumFeatureBackupHint =>
      'Ein verschlüsseltes Backup, das du auf einem neuen Handy wiederherstellen kannst.';

  @override
  String get premiumActive => 'Premium ist aktiv.';

  @override
  String premiumRenews(String date) {
    return 'Verlängert sich am $date.';
  }

  @override
  String premiumEnds(String date) {
    return 'Endet am $date.';
  }

  @override
  String get premiumManage => 'Abo verwalten';

  @override
  String premiumOfferMonthly(String price) {
    return 'Monatlich, $price';
  }

  @override
  String premiumOfferAnnual(String price) {
    return 'Jährlich, $price';
  }

  @override
  String premiumOfferOther(String price) {
    return '$price';
  }

  @override
  String get premiumRestore => 'Käufe wiederherstellen';

  @override
  String get premiumRestoredNone =>
      'Für dieses Store-Konto wurde kein Premium-Kauf gefunden.';

  @override
  String get premiumThanks => 'Danke. Premium ist aktiv.';

  @override
  String get premiumRenewalTerms =>
      'Abos verlängern sich automatisch, bis du sie in den Store-Einstellungen kündigst. Kündige mindestens 24 Stunden vor dem Verlängerungsdatum, um die nächste Abbuchung zu vermeiden.';

  @override
  String get premiumLoadingOffers => 'Preise werden geladen.';

  @override
  String get premiumNoOffers =>
      'Die Preise konnten nicht geladen werden. Prüfe deine Verbindung und versuch es erneut.';

  @override
  String get premiumRetry => 'Erneut versuchen';

  @override
  String get premiumUnavailable =>
      'Käufe sind in dieser Version nicht eingerichtet.';

  @override
  String get premiumDevUnlocked =>
      'Entwicklungsversion: Alle Premium-Funktionen sind freigeschaltet.';

  @override
  String get premiumAccountTip =>
      'Nutzt du mehr als ein Handy? Melde dich zuerst an, damit Premium an dein Konto gebunden ist.';

  @override
  String get premiumErrorNotAllowed =>
      'Mit diesem Store-Konto sind keine Käufe möglich.';

  @override
  String get premiumErrorPending =>
      'Der Kauf wartet auf Freigabe. Premium wird aktiviert, sobald er abgeschlossen ist.';

  @override
  String get premiumErrorStore =>
      'Beim Store ist ein Problem aufgetreten. Versuch es später erneut.';

  @override
  String premiumLockTitle(String feature) {
    return '$feature ist Teil von Premium.';
  }

  @override
  String get premiumLockButton => 'Premium ansehen';

  @override
  String get premiumLockShareLinkNote =>
      'Bereits erstellte Links funktionieren weiter, bis sie ablaufen, und du kannst das Teilen jederzeit beenden.';

  @override
  String get premiumLockExperimentsNote =>
      'Deine früheren Ergebnisse bleiben erhalten.';

  @override
  String get premiumLockBackupNote =>
      'Ein vorhandenes Backup kannst du weiterhin wiederherstellen oder löschen.';

  @override
  String get premiumFactorsLocked =>
      'Feinstaub, Ozon und Pollen sind Teil von Premium.';

  @override
  String get settingsPremiumHint =>
      'Freigabelink, Experimente, erweiterte Faktoren und Backup';

  @override
  String get settingsPremiumActive => 'Aktiv';

  @override
  String get shareLinkErrorPremium =>
      'Freigabelinks brauchen Premium. Wenn du gerade abonniert hast, warte eine Minute und versuch es erneut.';

  @override
  String get auditTitle => 'Wie sich die Risikostufe geschlagen hat';

  @override
  String auditNotYet(int needed, int logged) {
    return 'Diese Seite erscheint, sobald du $needed Attacken erfasst hast. Bisher sind es $logged.';
  }

  @override
  String auditIntro(int window) {
    String _temp0 = intl.Intl.pluralLogic(
      window,
      locale: localeName,
      other: 'die $window Tage davor',
      one: 'der Tag davor',
    );
    return 'Hier wird die Stufe, die die App an jedem Tag gezeigt hat, damit verglichen, wann deine Attacken begannen. Eine Attacke zählt als nach einem hohen Tag, wenn ihr Starttag oder $_temp0 als Hoch angezeigt wurde.';
  }

  @override
  String get auditEmpty =>
      'Noch nichts zu vergleichen. Ab jetzt speichert die App die Stufe, die sie jeden Tag zeigt, und die ersten Zahlen erscheinen nach deiner nächsten Attacke oder dem nächsten hohen Tag.';

  @override
  String get auditHitsTitle => 'Attacken nach einem hohen Tag';

  @override
  String auditHitsValue(int hits, int attacks, String share) {
    return '$hits von $attacks ($share)';
  }

  @override
  String get auditMissesTitle => 'Attacken ohne vorherigen hohen Tag';

  @override
  String auditMissesValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Attacken',
      one: '1 Attacke',
    );
    return '$_temp0';
  }

  @override
  String get auditFalseAlarmsTitle => 'Hohe Tage ohne Attacke';

  @override
  String auditFalseAlarmsValue(int count, int highDays) {
    return '$count von $highDays hohen Tagen';
  }

  @override
  String get auditTrend => 'Nach Monat';

  @override
  String auditMonthLine(int hits, int attacks, int falseAlarms, int highDays) {
    return '$hits von $attacks Attacken nach einem hohen Tag; $falseAlarms von $highDays hohen Tagen ohne Attacke';
  }

  @override
  String get auditCaveat =>
      'Kleine Zahlen schwanken von Monat zu Monat stark. Ein hoher Tag ohne Attacke ist kein Fehler: Es bedeutet, dass mehr deiner üblichen Auslöser zusammenkamen. Die Stufe ist eine Planungshilfe, kein Versprechen.';

  @override
  String get auditShare => 'Diese Zahlen monatlich teilen';

  @override
  String get auditShareHint =>
      'Das hilft, die App für alle zu bewerten. Gesendet werden nur die fünf Zahlen und die Modellversion, niemals Daten, Orte, dein Protokoll oder dein Konto. Aus, solange du es nicht einschaltest.';

  @override
  String get settingsAuditHint =>
      'Attacken nach hohen Tagen und hohe Tage ohne Attacke';

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
  String get unitsTitle => 'Einheiten';

  @override
  String get settingsUnitsHint => 'Luftdruck und Temperatur';

  @override
  String get unitsPressure => 'Luftdruck';

  @override
  String get unitsTemperature => 'Temperatur';

  @override
  String get unitNameHpa => 'Hektopascal (hPa)';

  @override
  String get unitNameInHg => 'Zoll Quecksilbersäule (inHg)';

  @override
  String get unitNameMmHg => 'Millimeter Quecksilbersäule (mmHg)';

  @override
  String get unitNameCelsius => 'Celsius (°C)';

  @override
  String get unitNameFahrenheit => 'Fahrenheit (°F)';

  @override
  String get unitsNote =>
      'Die erste Auswahl richtet sich nach der Region deines Handys. Eine Änderung betrifft nur die Anzeige; dein Protokoll bleibt gleich.';

  @override
  String envTemperatureNow(String temperature) {
    return 'Temperatur jetzt: $temperature';
  }

  @override
  String get questionnaireEnglishNote =>
      'Die Fragen werden im englischen Originalwortlaut angezeigt, bis eine validierte Übersetzung vorliegt, damit deine Werte vergleichbar bleiben.';

  @override
  String get wellnessDisclaimer =>
      'Allgemeine Wellness-Informationen, keine medizinische Beratung. Sprich mit deiner Ärztin oder deinem Arzt über die Behandlung.';

  @override
  String get dataSourceWeather => 'Open-Meteo Wetter';

  @override
  String get dataSourceAirQuality => 'Open-Meteo Luftqualität und UV (CAMS)';

  @override
  String get dataSourcePollen => 'Open-Meteo Pollen (CAMS)';

  @override
  String get dataSourceGeocoding => 'Open-Meteo Geokodierung';

  @override
  String get dataSourceBarometer => 'Barometer des Geräts';

  @override
  String get dataCoverageWorldwide => 'Weltweit';

  @override
  String get dataCoverageEuropeanAqi => 'Weltweit, europäischer AQI in Europa';

  @override
  String get dataCoverageEurope => 'Nur Europa';

  @override
  String get dataCoverageBarometer => 'Handys mit Drucksensor';
}
