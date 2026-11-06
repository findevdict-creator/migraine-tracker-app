// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Migraine Tracker';

  @override
  String get homeEmptyState =>
      'Rien n\'est encore enregistré.\nVotre niveau de risque et votre environnement apparaîtront ici.';

  @override
  String get riskLevelLow => 'Faible';

  @override
  String get riskLevelModerate => 'Modéré';

  @override
  String get riskLevelHigh => 'Élevé';

  @override
  String get devThemeGalleryTitle => 'Galerie de thèmes';

  @override
  String get devThemeLight => 'Thème clair';

  @override
  String get devThemeDark => 'Thème sombre';

  @override
  String get devThemeAttack => 'Thème crise';

  @override
  String get devSampleBody =>
      'Texte à la taille par défaut. Il doit rester lisible à 200 % sans être tronqué.';

  @override
  String get devSamplePrimary => 'Principal';

  @override
  String get devSampleSecondary => 'Secondaire';

  @override
  String get devSampleText => 'Texte';

  @override
  String get devSampleDisabled => 'Désactivé';

  @override
  String get devSampleChipOn => 'Aura';

  @override
  String get devSampleChipOff => 'Nausées';

  @override
  String get devSampleChipIcon => 'Lumière';

  @override
  String get devSampleSlider => 'Intensité';

  @override
  String get devSampleSliderLow => 'Aucune douleur';

  @override
  String get devSampleSliderHigh => 'Pire';

  @override
  String get devSampleCard => 'Une carte avec un badge';

  @override
  String get attackStart => 'Démarrer une crise';

  @override
  String get attackContinue => 'Reprendre la crise';

  @override
  String get attackTitleRunning => 'Crise en cours';

  @override
  String get attackTitleEnded => 'Crise';

  @override
  String attackStartedAt(String time) {
    return 'Commencée à $time';
  }

  @override
  String get attackNotFound => 'Cette crise n\'existe plus.';

  @override
  String get attackIntensity => 'Intensité de la douleur';

  @override
  String get durationEstimateTitle => 'Durée habituelle des crises de ce type';

  @override
  String durationEstimateRange(String low, String high) {
    return 'En général de $low à $high h';
  }

  @override
  String durationEstimateSameMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'D\'après $count crises passées d\'intensité proche avec le même médicament',
      one:
          'D\'après 1 crise passée d\'intensité proche avec le même médicament',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateNoMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'D\'après $count crises passées d\'intensité proche sans médicament',
      one: 'D\'après 1 crise passée d\'intensité proche sans médicament',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateSimilar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'D\'après $count crises passées d\'intensité proche',
      one: 'D\'après 1 crise passée d\'intensité proche',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'D\'après $count de vos crises passées',
      one: 'D\'après 1 de vos crises passées',
    );
    return '$_temp0';
  }

  @override
  String get attackIntensityLow => 'Aucune douleur';

  @override
  String get attackIntensityHigh => 'Pire';

  @override
  String get attackWhereItHurts => 'Où ça fait mal';

  @override
  String get attackSymptoms => 'Symptômes';

  @override
  String get attackPhases => 'Phases';

  @override
  String get attackNotes => 'Notes';

  @override
  String get attackNotesHint => 'Tout ce qui mérite d\'être retenu';

  @override
  String get attackEnd => 'Terminer la crise';

  @override
  String get attackDone => 'Terminé';

  @override
  String get attackFinishLater => 'Terminer plus tard';

  @override
  String get symptomAura => 'Aura';

  @override
  String get symptomNeckTension => 'Tension dans la nuque';

  @override
  String get symptomLightSensitivity => 'Lumière';

  @override
  String get symptomSoundSensitivity => 'Bruit';

  @override
  String get symptomSmellSensitivity => 'Odeurs';

  @override
  String get symptomNausea => 'Nausées';

  @override
  String get phaseProdrome => 'Prodrome';

  @override
  String get phaseAura => 'Aura';

  @override
  String get phaseAttack => 'Crise';

  @override
  String get phasePostdrome => 'Postdrome';

  @override
  String get headForehead => 'Front';

  @override
  String get headLeftTemple => 'Tempe gauche';

  @override
  String get headRightTemple => 'Tempe droite';

  @override
  String get headBehindEyes => 'Derrière les yeux';

  @override
  String get headLeftSide => 'Côté gauche';

  @override
  String get headRightSide => 'Côté droit';

  @override
  String get headTopOfHead => 'Sommet du crâne';

  @override
  String get headBackOfHead => 'Arrière de la tête';

  @override
  String get headNeck => 'Nuque';

  @override
  String get checkinTitle => 'Bilan du jour';

  @override
  String get checkinLoadError => 'Impossible de charger ce jour.';

  @override
  String get checkinIntro => 'Trois touches. Comment ça s\'est passé ?';

  @override
  String get checkinComplete =>
      'Terminé pour ce jour. Touchez un chiffre pour le modifier.';

  @override
  String get checkinAddMore => 'Ajouter plus (facultatif)';

  @override
  String get checkinOptionalTitle => 'Facultatif';

  @override
  String get checkinDone => 'Terminé';

  @override
  String get checkinToday => 'Aujourd\'hui';

  @override
  String get checkinSleepQuality => 'Qualité du sommeil';

  @override
  String get checkinStress => 'Stress';

  @override
  String get checkinNeckTension => 'Tension dans la nuque';

  @override
  String get checkinCaffeine => 'Caféine';

  @override
  String get checkinHydration => 'Hydratation';

  @override
  String get checkinAlcohol => 'Alcool';

  @override
  String get checkinLightExposure => 'Lumière vive';

  @override
  String get checkinScreenExposure => 'Temps d\'écran';

  @override
  String get checkinSleepLow => 'Mauvais';

  @override
  String get checkinSleepHigh => 'Excellent';

  @override
  String get checkinStressLow => 'Calme';

  @override
  String get checkinStressHigh => 'Très stressé';

  @override
  String get checkinNeckLow => 'Détendue';

  @override
  String get checkinNeckHigh => 'Très tendue';

  @override
  String get checkinHydrationLow => 'Peu';

  @override
  String get checkinHydrationHigh => 'Beaucoup';

  @override
  String get checkinExposureLow => 'Peu';

  @override
  String get checkinExposureHigh => 'Beaucoup';

  @override
  String get checkinNone => 'Aucun';

  @override
  String checkinCupsOrMore(int count) {
    return '$count+ tasses';
  }

  @override
  String checkinDrinksOrMore(int count) {
    return '$count+ verres';
  }

  @override
  String checkinValueSemantics(String field, int value, int max) {
    return '$field, $value sur $max';
  }

  @override
  String get checkinReminderTooltip => 'Heure du rappel';

  @override
  String checkinReminderAt(String time) {
    return 'Rappel à $time';
  }

  @override
  String get checkinReminderPickerTitle => 'Rappel du bilan du jour';

  @override
  String get checkinCardTitle => 'Bilan du jour';

  @override
  String get checkinCardDone => 'Terminé pour aujourd\'hui';

  @override
  String get checkinCardTodo => 'Trois touches, environ 10 secondes';

  @override
  String get medicationTitle => 'Médicaments';

  @override
  String get medicationAdd => 'Ajouter un médicament';

  @override
  String get medicationAddTitle => 'Enregistrer une prise';

  @override
  String get medicationName => 'Médicament';

  @override
  String get medicationDose => 'Dose';

  @override
  String get medicationDoseHint => 'ex. 400 mg';

  @override
  String get medicationKindAcute => 'De crise';

  @override
  String get medicationKindPreventive => 'De fond';

  @override
  String medicationTakenAt(String time) {
    return 'Pris à $time';
  }

  @override
  String get medicationLog => 'Enregistrer';

  @override
  String get medicationDelete => 'Supprimer';

  @override
  String get medicationThisMonth => 'Ce mois-ci';

  @override
  String get medicationEmpty => 'Aucune prise enregistrée ce mois-ci.';

  @override
  String get medicationReliefQuestion => 'Soulagement après 2 h ?';

  @override
  String get medicationReliefNone => 'Aucun';

  @override
  String get medicationReliefPartial => 'Partiel';

  @override
  String get medicationReliefFull => 'Complet';

  @override
  String medicationAcuteDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours avec traitement de crise ce mois-ci',
      one: '1 jour avec traitement de crise ce mois-ci',
      zero: 'Aucun jour avec traitement de crise ce mois-ci',
    );
    return '$_temp0';
  }

  @override
  String get medicationAcuteDaysHint =>
      'Jours avec au moins une prise de traitement de crise, comptés par mois civil.';

  @override
  String medicationOveruseFirstNote(int days) {
    return 'Vous avez atteint $days jours avec traitement de crise ce mois-ci. Beaucoup de soignants conseillent de garder ce nombre bas ; il peut être utile d\'en parler.';
  }

  @override
  String medicationOveruseSecondNote(int days) {
    return 'Vous avez atteint $days jours avec traitement de crise ce mois-ci. Pensez à en parler avec votre soignant.';
  }

  @override
  String get medicationTalkToClinician => 'Parlez-en à votre soignant';

  @override
  String get cycleTitle => 'Cycle';

  @override
  String get cycleToggleTitle => 'Suivre mon cycle';

  @override
  String get cycleToggleSubtitle =>
      'Désactivé par défaut. Une fois activé, le jour du cycle est enregistré avec chaque bilan et utilisé comme facteur.';

  @override
  String get cycleNoData =>
      'Enregistrez un début de règles pour voir votre jour de cycle.';

  @override
  String cycleDayAndPhase(int day, String phase) {
    return 'Jour $day du cycle · $phase';
  }

  @override
  String cycleLength(int days) {
    return 'D\'après un cycle de $days jours';
  }

  @override
  String get cyclePeriodStarts => 'Débuts des règles';

  @override
  String get cycleNoStarts => 'Aucun enregistré pour l\'instant.';

  @override
  String get cycleRemoveStart => 'Retirer';

  @override
  String get cyclePeriodStartedToday => 'Les règles ont commencé ce jour-là';

  @override
  String get cyclePhaseMenstrual => 'Menstruelle';

  @override
  String get cyclePhaseFollicular => 'Folliculaire';

  @override
  String get cyclePhaseOvulation => 'Autour de l\'ovulation';

  @override
  String get cyclePhaseLuteal => 'Lutéale';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsSectionDaily => 'Quotidien';

  @override
  String get settingsSectionData => 'Vos données';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String get settingsExportJson => 'Exporter en JSON';

  @override
  String get settingsExportJsonHint =>
      'Toutes les tables dans un fichier que vous pouvez réimporter.';

  @override
  String get settingsExportCsv => 'Exporter en CSV';

  @override
  String get settingsExportCsvHint => 'Un fichier tableur par table.';

  @override
  String get settingsExportEmpty => 'Rien à exporter pour l\'instant.';

  @override
  String get settingsDeleteAll => 'Tout supprimer';

  @override
  String get settingsDeleteAllHint =>
      'Supprime toutes les données de cet appareil. Action irréversible.';

  @override
  String settingsDeleteAllConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Cela supprime $count enregistrements de cet appareil. Action irréversible.',
      one: 'Cela supprime 1 enregistrement de cet appareil. Action irréversible.',
      zero: 'Rien n\'est encore enregistré. Supprimer quand même ?',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeleteAllButton => 'Supprimer';

  @override
  String get settingsCancel => 'Annuler';

  @override
  String get settingsDeletedAll => 'Toutes les données ont été supprimées.';

  @override
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingsTerms => 'Conditions d\'utilisation';

  @override
  String get settingsSupport => 'Assistance';

  @override
  String get environmentTitle => 'Environnement';

  @override
  String get environmentCardTitle => 'Pression';

  @override
  String get environmentCardEmpty =>
      'Aucune donnée météo enregistrée. Touchez pour choisir votre position.';

  @override
  String environmentCardSummary(String pressure, String trend) {
    return '$pressure, $trend';
  }

  @override
  String get envPressureSection => 'Pression atmosphérique';

  @override
  String get envPressureUnknown => 'Aucune mesure pour cette heure';

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
  String get envChartTitle => '48 dernières heures et 24 prochaines';

  @override
  String get envUpdatedNever => 'Pas encore mis à jour';

  @override
  String get envUpdatedJustNow => 'Mis à jour à l\'instant';

  @override
  String envUpdatedMinutes(int n) {
    return 'Mis à jour il y a $n min';
  }

  @override
  String envUpdatedHours(int n) {
    return 'Mis à jour il y a $n h';
  }

  @override
  String envUpdatedDays(int n) {
    return 'Mis à jour il y a $n j';
  }

  @override
  String get envStale =>
      'Cette prévision date de quelques heures. Elle sera actualisée dès votre retour en ligne.';

  @override
  String get envOffline =>
      'Service météo injoignable. Affichage des données enregistrées sur cet appareil.';

  @override
  String get envNoData =>
      'Aucune donnée météo enregistrée. Autorisez la localisation ou choisissez une ville pour voir la tendance de la pression.';

  @override
  String get envRefresh => 'Actualiser';

  @override
  String get envLocationSection => 'Position';

  @override
  String get envLocationGps => 'Position approximative utilisée';

  @override
  String envLocationManual(String city) {
    return '$city utilisée';
  }

  @override
  String get envLocationLast => 'Dernière zone connue utilisée';

  @override
  String get envLocationNone => 'Aucune position définie';

  @override
  String get envUseMyLocation => 'Utiliser ma position';

  @override
  String get envChooseCity => 'Choisir une ville';

  @override
  String get envCitySearchTitle => 'Choisir une ville';

  @override
  String get envCitySearchHint => 'Nom de la ville';

  @override
  String get envCityNoResults => 'Aucun lieu trouvé';

  @override
  String get envCitySearchFailed =>
      'Recherche impossible pour le moment. Vérifiez votre connexion et réessayez.';

  @override
  String get envPrivacyNote =>
      'Votre position est arrondie à environ 10 km avant de quitter cet appareil.';

  @override
  String get envAttribution => 'Données météo par Open-Meteo';

  @override
  String get envTrendRising => 'en hausse';

  @override
  String get envTrendFalling => 'en baisse';

  @override
  String get envTrendSteady => 'stable';

  @override
  String get envTrendUnknown => 'pas encore de tendance';

  @override
  String get barometerTitle => 'Baromètre';

  @override
  String get barometerOpen => 'Ouvrir le baromètre';

  @override
  String get barometerNoReading => 'Aucune mesure';

  @override
  String get barometerFromSensor => 'Du capteur de cet appareil';

  @override
  String get barometerFromStation => 'De la station la plus proche';

  @override
  String get barometerNoSource =>
      'Aucun capteur sur cet appareil et aucune prévision enregistrée';

  @override
  String get barometerCalibrationSection => 'Étalonnage';

  @override
  String barometerOffset(String offset, int pairs) {
    return 'Écart du capteur de $offset par rapport à la station, sur $pairs paires horaires.';
  }

  @override
  String barometerNotCalibrated(int pairs) {
    return 'Pas encore étalonné. Il faut au moins $pairs heures avec une mesure du capteur et une valeur de la station.';
  }

  @override
  String get barometerTrendSection => '24 dernières heures sur cet appareil';

  @override
  String get barometerTrendEmpty =>
      'Les mesures sont prises quand l\'app est ouverte. Revenez plus tard pour voir la tendance.';

  @override
  String barometerTrendSamples(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mesures',
      one: '1 mesure',
    );
    return '$_temp0';
  }

  @override
  String get barometerStampNote =>
      'Chaque crise démarrée enregistre la mesure du capteur et la valeur de la station pour cette heure.';

  @override
  String get envFactorsTitle => 'Facteurs du jour';

  @override
  String get envFactorsEmpty =>
      'Pas encore de facteurs quotidiens pour cette zone.';

  @override
  String get factorBandLow => 'faible';

  @override
  String get factorBandModerate => 'modéré';

  @override
  String get factorBandHigh => 'élevé';

  @override
  String get factorBandVeryHigh => 'très élevé';

  @override
  String factorValueWithBand(String value, String band) {
    return '$value ($band)';
  }

  @override
  String get factorAqiUs => 'Qualité de l\'air (AQI américain)';

  @override
  String get factorAqiEu => 'Qualité de l\'air (AQI européen)';

  @override
  String get factorParticulates => 'Particules PM2,5 / PM10';

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
  String get factorPollen => 'Pollen (Europe uniquement)';

  @override
  String factorPollenType(String type, String band) {
    return '$type $band';
  }

  @override
  String get pollenAlder => 'aulne';

  @override
  String get pollenBirch => 'bouleau';

  @override
  String get pollenGrass => 'graminées';

  @override
  String get pollenMugwort => 'armoise';

  @override
  String get pollenOlive => 'olivier';

  @override
  String get pollenRagweed => 'ambroisie';

  @override
  String get factorUvMax => 'Indice UV, maximum du jour';

  @override
  String get factorDaylight => 'Durée du jour';

  @override
  String factorDaylightValue(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get factorSun => 'Lever et coucher du soleil';

  @override
  String factorSunValue(String sunrise, String sunset) {
    return '$sunrise à $sunset';
  }

  @override
  String get aboutDataTitle => 'À propos des données';

  @override
  String get aboutDataIntro =>
      'D\'où viennent les chiffres de cette app, et ce que chacun peut et ne peut pas vous dire.';

  @override
  String get aboutDataSources => 'Sources';

  @override
  String aboutDataLicence(String coverage, String licence) {
    return '$coverage. Licence : $licence.';
  }

  @override
  String get aboutDataPrivacy => 'Ce qui quitte votre téléphone';

  @override
  String get aboutDataPrivacyBody =>
      'Seulement une position arrondie à environ 10 km, pour que le service météo puisse répondre pour votre zone. Vos crises, bilans, médicaments et données de santé restent sur cet appareil, sauf si vous choisissez de les sauvegarder ou de les partager.';

  @override
  String get aboutDataLimits => 'Limites';

  @override
  String get aboutDataLimitsBody =>
      'Les prévisions sont des estimations d\'un modèle pour une maille de grille, pas une mesure devant chez vous. Le pollen n\'est disponible qu\'en Europe. La qualité de l\'air peut manquer dans certaines régions. Lorsqu\'un facteur n\'a pas de données pour votre zone, il n\'est simplement pas affiché.';

  @override
  String get settingsHealthHint =>
      'Sommeil, fréquence cardiaque, pas et cycle de votre app santé';

  @override
  String get healthTitle => 'Données de santé';

  @override
  String healthIntro(String store) {
    return 'Choisissez ce qui est lu depuis $store. Chaque type a son propre interrupteur et sa propre raison.';
  }

  @override
  String get healthPrivacyNote =>
      'Les données importées restent sur ce téléphone. Elles ne sont jamais envoyées, même avec la sauvegarde, sauf si vous les exportez vous-même.';

  @override
  String get healthStoreApple => 'Apple Santé';

  @override
  String get healthStoreConnect => 'Health Connect';

  @override
  String healthUnavailable(String store) {
    return '$store n\'est pas disponible sur cet appareil.';
  }

  @override
  String get healthReadSection => 'Lecture';

  @override
  String get healthTypeSleep => 'Sommeil';

  @override
  String get healthReasonSleep =>
      'Remplit la qualité du sommeil de votre bilan du jour à partir de la nuit, pour une touche de moins.';

  @override
  String get healthTypeRestingHr => 'Fréquence cardiaque au repos';

  @override
  String get healthReasonRestingHr =>
      'Une fréquence au repos plus élevée que d\'habitude peut traduire une fatigue la veille d\'une crise.';

  @override
  String get healthTypeHrv => 'Variabilité de la fréquence cardiaque';

  @override
  String get healthReasonHrv =>
      'Une variabilité plus basse que d\'habitude va souvent avec le stress et une mauvaise récupération.';

  @override
  String get healthTypeSteps => 'Pas';

  @override
  String get healthReasonSteps =>
      'Les jours de très faible ou de très forte activité méritent d\'être vus à côté de vos crises.';

  @override
  String get healthTypeFlow => 'Flux menstruel';

  @override
  String get healthReasonFlow =>
      'Remplit les débuts de règles pour le suivi du cycle, si vous l\'utilisez.';

  @override
  String healthDenied(String store) {
    return '$store n\'a pas accordé l\'accès. Vous pouvez le modifier dans ses propres réglages.';
  }

  @override
  String get healthWriteSection => 'Écriture';

  @override
  String healthWriteHeadaches(String store) {
    return 'Écrire les maux de tête dans $store';
  }

  @override
  String get healthWriteHeadachesHint =>
      'Chaque crise terminée est enregistrée comme mal de tête avec son début, sa fin et son intensité. Rien d\'autre n\'est écrit.';

  @override
  String get healthImportSection => 'Importation';

  @override
  String get healthImportNow => 'Importer maintenant';

  @override
  String get healthImportNever => 'Rien d\'importé pour l\'instant';

  @override
  String healthImportLast(String age) {
    return '$age';
  }

  @override
  String get healthImportFailed =>
      'L\'importation n\'a pas abouti. Réessayez plus tard.';

  @override
  String healthImportResult(int imported, int prefilled) {
    String _temp0 = intl.Intl.pluralLogic(
      imported,
      locale: localeName,
      other: '$imported nouvelles mesures.',
      one: '1 nouvelle mesure.',
      zero: 'Rien de nouveau.',
    );
    String _temp1 = intl.Intl.pluralLogic(
      prefilled,
      locale: localeName,
      other: 'Sommeil rempli pour $prefilled jours.',
      one: 'Sommeil rempli pour 1 jour.',
      zero: '',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get checkinSourceHealthkit => 'Depuis Apple Santé';

  @override
  String get checkinSourceHealthConnect => 'Depuis Health Connect';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingFinish => 'Terminer';

  @override
  String onboardingStep(int step, int total) {
    return 'Étape $step sur $total';
  }

  @override
  String get onboardingWelcomeTitle => 'Bienvenue';

  @override
  String get onboardingLocationTitle => 'La météo de votre zone';

  @override
  String get onboardingLocationBody =>
      'Les variations de pression atmosphérique font partie de ce que l\'on remarque le plus souvent avant une crise. Autorisez une position approximative ou choisissez une ville pour les voir.';

  @override
  String get onboardingLocationNone =>
      'Pas encore de position. Vous pourrez aussi la définir plus tard depuis l\'écran environnement.';

  @override
  String get onboardingHealthTitle => 'Données de santé';

  @override
  String get onboardingHealthBody =>
      'Facultatif. Chaque type a son propre interrupteur et sa propre raison. Vous pourrez tout modifier plus tard dans Réglages.';

  @override
  String get onboardingHealthUnavailable =>
      'Aucune app santé n\'est disponible sur cet appareil. Vous pouvez passer cette étape.';

  @override
  String get onboardingReminderTitle => 'Bilan du jour';

  @override
  String get onboardingReminderBody =>
      'Trois touches par jour, environ dix secondes. Choisissez une heure pour le rappel.';

  @override
  String get onboardingReminderNote =>
      'Les rappels commenceront une fois les notifications configurées. Vous pouvez changer l\'heure n\'importe quel jour depuis le bilan.';

  @override
  String get explainerTitle => 'Ce que signifie le niveau';

  @override
  String get explainerIntro =>
      'Chaque jour, l\'app affiche un niveau construit à partir de votre propre historique et des conditions du jour.';

  @override
  String get explainerDoesTitle => 'Ce qu\'il fait';

  @override
  String get explainerDoes1 =>
      'Montre comment la météo, le sommeil, le stress et le quotidien d\'aujourd\'hui se comparent aux jours qui ont précédé vos crises passées.';

  @override
  String get explainerDoes2 =>
      'Apprend de votre propre journal, et devient donc plus précis à mesure que vous notez.';

  @override
  String get explainerDoes3 =>
      'Vous aide à décider si aujourd\'hui est un jour pour vous ménager.';

  @override
  String get explainerDoesNotTitle => 'Ce qu\'il ne fait pas';

  @override
  String get explainerDoesNot1 =>
      'Il n\'annonce pas de crise. Un niveau élevé est une tendance, pas une certitude, et un niveau faible n\'est pas une promesse.';

  @override
  String get explainerDoesNot2 =>
      'Ce n\'est pas un avis médical et cela ne remplace pas votre soignant.';

  @override
  String get explainerDoesNot3 =>
      'Votre journal n\'est jamais envoyé nulle part. Le niveau est calculé sur ce téléphone.';

  @override
  String get riskCardTitle => 'Niveau du jour';

  @override
  String get riskCardEmpty =>
      'Pas encore de niveau. Faites un bilan ou laissez la météo se charger.';

  @override
  String get riskScreenTitle => 'Votre niveau';

  @override
  String get riskWhyTitle => 'Pourquoi';

  @override
  String get riskNoDrivers => 'Rien ne ressort.';

  @override
  String get riskNextDays => 'Prochains jours';

  @override
  String get riskDayToday => 'Aujourd\'hui';

  @override
  String get riskDayTomorrow => 'Demain';

  @override
  String riskLoad(String value) {
    return 'Charge $value sur 100';
  }

  @override
  String riskConfidence(String label) {
    return 'Fiabilité : $label';
  }

  @override
  String get riskConfidenceLow => 'faible';

  @override
  String get riskConfidenceMedium => 'moyenne';

  @override
  String get riskConfidenceHigh => 'élevée';

  @override
  String riskStillLearning(int count, int needed) {
    return 'Apprentissage en cours : $count crises enregistrées sur $needed';
  }

  @override
  String get riskTuned => 'Ajusté à votre journal';

  @override
  String riskDriverPoints(String points) {
    return '$points points';
  }

  @override
  String riskUpdated(String time) {
    return 'Mis à jour $time';
  }

  @override
  String get riskExplainerLink => 'Ce que signifie le niveau';

  @override
  String get riskOpenCheckin => 'Faire le bilan du jour';

  @override
  String get riskFactorPressureDrop => 'Baisse de la pression atmosphérique';

  @override
  String get riskFactorHumidity => 'Humidité élevée';

  @override
  String get riskFactorTemperatureSwing => 'Variation de température';

  @override
  String get riskFactorAirQuality => 'Qualité de l\'air';

  @override
  String get riskFactorPollen => 'Pollen';

  @override
  String get riskFactorBrightLight => 'Lumière vive';

  @override
  String get riskFactorScreenTime => 'Temps d\'écran';

  @override
  String get riskFactorPoorSleep => 'Mauvais sommeil';

  @override
  String get riskFactorStress => 'Stress';

  @override
  String get riskFactorNeckTension => 'Tension dans la nuque';

  @override
  String get riskFactorCaffeine => 'Caféine';

  @override
  String get riskFactorAlcohol => 'Alcool';

  @override
  String get riskFactorDehydration => 'Hydratation faible';

  @override
  String get riskFactorCyclePhase => 'Phase du cycle';

  @override
  String get loadMeterTitle => 'Charge';

  @override
  String loadMeterSemantics(String value, String segments) {
    return 'Charge $value sur 100. $segments';
  }

  @override
  String loadSegmentDetail(String name, String points) {
    return '$name : $points points';
  }

  @override
  String loadThresholdModerate(String value) {
    return 'Modéré à partir de $value';
  }

  @override
  String loadThresholdHigh(String value) {
    return 'Élevé à partir de $value';
  }

  @override
  String get loadMeterEmpty => 'Pas encore de charge';

  @override
  String get insightsTitle => 'Vos facteurs';

  @override
  String get insightsIntro =>
      'À quelle fréquence une crise a suivi chaque facteur dans votre propre journal, par rapport à votre fréquence habituelle.';

  @override
  String get insightsTriggers => 'Plus de crises ensuite';

  @override
  String get insightsProtectors => 'Moins de crises ensuite';

  @override
  String get insightsNeutral => 'Pas d\'effet net';

  @override
  String get insightsNotEnough => 'Pas encore assez de données';

  @override
  String get insightsEmptyBucket => 'Rien ici pour l\'instant.';

  @override
  String insightsSample(int days, int attacks) {
    return '$days jours d\'exposition, dont $attacks suivis d\'une crise';
  }

  @override
  String insightsLift(String ratio) {
    return '$ratio× votre fréquence habituelle';
  }

  @override
  String insightsNeedMore(int days, int needed) {
    return '$days jours d\'exposition enregistrés sur $needed';
  }

  @override
  String get insightsNoRunYet =>
      'Enregistrez et terminez une crise pour commencer le décompte.';

  @override
  String get insightsMethodLink => 'Comment c\'est calculé';

  @override
  String get insightsMethodTitle => 'Comment c\'est calculé';

  @override
  String insightsMethod1(String pressure) {
    return 'Un jour d\'exposition est un jour où un facteur était présent dans votre journal ou dans la météo, par exemple une réponse sommeil de 1 ou une baisse de pression de plus de $pressure.';
  }

  @override
  String get insightsMethod2 =>
      'Une crise compte comme ayant suivi un jour si elle a commencé ce jour-là ou le lendemain, soit les 24 à 48 heures examinées par le modèle.';

  @override
  String get insightsMethod3 =>
      'Le rapport compare la fréquence des crises après les jours de ce facteur à leur fréquence après n\'importe quel jour de votre journal. 1,5× signifie une fois et demie votre fréquence habituelle ; 0,5× signifie la moitié.';

  @override
  String insightsMethod4(int needed) {
    return 'Un facteur a besoin de $needed jours d\'exposition avant d\'être classé. D\'ici là, il reste sous « Pas encore assez de données ». Savoir qu\'un facteur est suivi de moins de crises est aussi utile que l\'inverse, donc les deux listes ont la même place.';
  }

  @override
  String get insightsMethod5 =>
      'Rien de tout cela n\'est une cause. Un facteur peut figurer dans une liste à cause de quelque chose qui l\'accompagne, comme les week-ends ou un changement de traitement. Servez-vous des listes pour choisir quoi essayer, pas quoi accuser.';

  @override
  String get riskInsightsLink => 'Vos facteurs';

  @override
  String get settingsInsightsHint =>
      'Quels facteurs ont précédé les crises dans votre journal';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsHint =>
      'Alertes de niveau, baisses de pression, rappels';

  @override
  String get notificationsIntro =>
      'Tout est programmé sur ce téléphone à partir de la prévision enregistrée et de votre journal. Désactivez les types que vous ne voulez pas.';

  @override
  String get notificationsPermissionDenied =>
      'Les notifications de cette app sont désactivées dans les réglages du système.';

  @override
  String get notifTypeRiskRising => 'Niveau en hausse';

  @override
  String get notifTypeRiskRisingHint =>
      'La veille au soir et le matin d\'un jour de niveau plus élevé';

  @override
  String get notifTypePressureDrop => 'Baisse de pression';

  @override
  String notifTypePressureDropHint(String pressure) {
    return 'Quand la prévision montre une baisse de $pressure ou plus en 24 heures';
  }

  @override
  String get notifTypeAttackOver => 'Votre crise est-elle terminée ?';

  @override
  String get notifTypeAttackOverHint =>
      'À la durée habituelle de vos crises, avec un bouton Terminer';

  @override
  String get notifTypeCheckin => 'Rappel du bilan';

  @override
  String get notifTypeCheckinHint => 'À l\'heure choisie sous Quotidien';

  @override
  String get notifTypeMedication => 'Rappel du traitement de fond';

  @override
  String get notifTypeMedicationHint =>
      'Un rappel quotidien pour une prise de traitement de fond';

  @override
  String notifPressureThreshold(String pressure) {
    return 'Seuil de baisse de pression : $pressure en 24 h';
  }

  @override
  String get notifMedicationTime => 'Heure du rappel du traitement de fond';

  @override
  String notifRiskEveningTitle(String level) {
    return 'Niveau de demain : $level';
  }

  @override
  String notifRiskEveningBody(String level, String driver) {
    return 'Votre niveau pour demain est $level. En tête de liste : $driver.';
  }

  @override
  String notifRiskMorningTitle(String level) {
    return 'Niveau du jour : $level';
  }

  @override
  String notifRiskMorningBody(String level, String driver) {
    return 'Votre niveau aujourd\'hui est $level. En tête de liste : $driver.';
  }

  @override
  String get notifPressureTitle => 'La pression atmosphérique baisse';

  @override
  String notifPressureBody(String pressure, String time) {
    return 'Une baisse de $pressure est attendue d\'ici $time.';
  }

  @override
  String get notifAttackOverTitle => 'Votre crise est-elle terminée ?';

  @override
  String notifAttackOverBody(String duration) {
    return 'Elle a commencé il y a $duration. Terminez-la ici quand elle est passée.';
  }

  @override
  String get notifEndAttackAction => 'Terminer la crise';

  @override
  String get notifCheckinTitle => 'Trois touches pour aujourd\'hui';

  @override
  String get notifCheckinBody =>
      'Sommeil, stress et tension dans la nuque. Quinze secondes.';

  @override
  String get notifMedicationTitle => 'Traitement de fond';

  @override
  String get notifMedicationBody =>
      'C\'est l\'heure de votre traitement de fond du jour, si vous en prenez un.';

  @override
  String get notifChannelAlerts => 'Alertes';

  @override
  String get notifChannelAlertsDescription =>
      'Alertes de niveau et de pression issues de la prévision enregistrée';

  @override
  String get notifChannelReminders => 'Rappels';

  @override
  String get notifChannelRemindersDescription =>
      'Rappels du bilan et du traitement de fond';

  @override
  String get notifChannelAttack => 'Crise';

  @override
  String get notifChannelAttackDescription =>
      'Questions sur une crise en cours';

  @override
  String get reportTitle => 'Rapport pour le médecin';

  @override
  String get settingsReportHint => 'PDF et tableur pour une période';

  @override
  String get reportIntro =>
      'Un résumé de ce que vous avez noté, pour votre prochain rendez-vous. Choisissez une période, puis partagez le PDF ou les tableurs.';

  @override
  String get reportRangeLabel => 'Période';

  @override
  String reportRangeDays(int days) {
    return '$days jours';
  }

  @override
  String get reportRangeCustom => 'Personnalisée';

  @override
  String reportRangeText(String from, String to) {
    return 'Du $from au $to';
  }

  @override
  String reportPreviewAttacks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count crises',
      one: '1 crise',
      zero: 'Aucune crise',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewAttackDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours de crise',
      one: '1 jour de crise',
      zero: 'aucun jour de crise',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewDoses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prises',
      one: '1 prise',
      zero: 'aucune prise',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewCheckins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bilans',
      one: '1 bilan',
      zero: 'aucun bilan',
    );
    return '$_temp0';
  }

  @override
  String get reportEmpty => 'Rien n\'a encore été noté sur cette période.';

  @override
  String get reportSharePdf => 'Partager le PDF';

  @override
  String get reportShareCsv => 'Partager les tableurs';

  @override
  String get reportShareAll => 'Tout partager';

  @override
  String get reportBuilding => 'Préparation du rapport';

  @override
  String get reportFailed => 'Le rapport n\'a pas pu être préparé. Réessayez.';

  @override
  String get reportWhatIsIn => 'Contenu du PDF';

  @override
  String get reportContents =>
      'Calendrier des crises, totaux mensuels, durée, facteurs avec la taille de leurs échantillons, jours de médicaments, variations de pression, symptômes et zones de douleur. Aucun nom, aucune note.';

  @override
  String reportPdfTitle(String app) {
    return 'Rapport $app';
  }

  @override
  String reportPdfPeriod(String from, String to, int days) {
    return 'Période : du $from au $to ($days jours)';
  }

  @override
  String reportPdfGenerated(String date) {
    return 'Généré le $date sur l\'appareil de la personne à partir de son propre journal.';
  }

  @override
  String get reportPdfDisclaimer =>
      'Ceci est le résumé d\'un journal tenu par la personne dans une app de bien-être. Ce n\'est pas un dossier médical et cela ne remplace pas une évaluation clinique. Les rapports des facteurs décrivent uniquement le journal de cette personne et ne sont pas des causes.';

  @override
  String reportPdfPage(int page, int pages) {
    return 'Page $page sur $pages';
  }

  @override
  String get reportSectionOverview => 'Vue d\'ensemble';

  @override
  String get reportStatAttacks => 'Crises';

  @override
  String get reportStatAttackDays => 'Jours de crise';

  @override
  String get reportStatPerMonth => 'Crises par 30 jours';

  @override
  String get reportStatMeanIntensity => 'Intensité moyenne (0-10)';

  @override
  String get reportStatAcuteDays => 'Jours avec traitement de crise';

  @override
  String get reportStatCheckins => 'Jours avec un bilan';

  @override
  String get reportSectionMonths => 'Par mois';

  @override
  String get reportColMonth => 'Mois';

  @override
  String get reportColAttacks => 'Crises';

  @override
  String get reportColAttackDays => 'Jours de crise';

  @override
  String get reportColMeanIntensity => 'Intensité moyenne';

  @override
  String get reportColAcuteDays => 'Jours de traitement';

  @override
  String get reportColNote => 'Remarque';

  @override
  String get reportOveruseWatch => '10+ jours de traitement';

  @override
  String get reportOveruseHigh => '15+ jours de traitement';

  @override
  String get reportSectionCalendar => 'Calendrier des crises';

  @override
  String get reportCalendarHint =>
      'Une case par jour. Les cases grisées ont eu une crise ; le chiffre est l\'intensité la plus forte du jour.';

  @override
  String get reportSectionDuration => 'Durée des crises';

  @override
  String get reportDurationNone => 'Aucune crise terminée sur cette période.';

  @override
  String reportDurationSummary(
    int count,
    String shortest,
    String median,
    String longest,
  ) {
    return '$count crises terminées. La plus courte $shortest, médiane $median, la plus longue $longest.';
  }

  @override
  String get reportBucketUnderFour => 'Moins de 4 h';

  @override
  String get reportBucketFourToTwelve => '4 à 12 h';

  @override
  String get reportBucketTwelveToDay => '12 à 24 h';

  @override
  String get reportBucketOneToThreeDays => '1 à 3 jours';

  @override
  String get reportBucketOverThreeDays => 'Plus de 3 jours';

  @override
  String get reportSectionTriggers => 'Facteurs dans le journal de la personne';

  @override
  String reportTriggersHint(int floor) {
    return 'Rapport entre les crises après les jours avec le facteur et la fréquence habituelle de la personne, avec le nombre de jours d\'exposition correspondant. En dessous de $floor jours d\'exposition, le rapport n\'est pas affiché.';
  }

  @override
  String get reportTriggersNone =>
      'Pas encore assez de jours enregistrés pour comparer les facteurs.';

  @override
  String get reportColFactor => 'Facteur';

  @override
  String get reportColRatio => 'Rapport';

  @override
  String get reportColExposures => 'Jours d\'exposition';

  @override
  String get reportColFollowed => 'Suivis d\'une crise';

  @override
  String get reportColConfidence => 'Données';

  @override
  String get reportConfidenceLow => 'faibles';

  @override
  String get reportConfidenceMedium => 'moyennes';

  @override
  String get reportConfidenceHigh => 'bonnes';

  @override
  String get reportSectionMedications => 'Médicaments';

  @override
  String get reportMedicationsNone =>
      'Aucune prise enregistrée sur cette période.';

  @override
  String get reportColMedication => 'Médicament';

  @override
  String get reportColKind => 'Type';

  @override
  String get reportColDoses => 'Prises';

  @override
  String get reportColDays => 'Jours';

  @override
  String get reportColRelief => 'Soulagement à 2 h (aucun / partiel / complet)';

  @override
  String get reportKindAcute => 'de crise';

  @override
  String get reportKindPreventive => 'de fond';

  @override
  String get reportSectionWeather => 'Pression atmosphérique';

  @override
  String reportWeatherHint(String pressure) {
    return 'Une baisse correspond à une chute de $pressure ou plus en 24 h au moment de la saisie.';
  }

  @override
  String get reportWeatherNone => 'Aucune donnée météo sur cette période.';

  @override
  String reportWeatherAttacks(int fall, int total) {
    return '$fall crises sur $total ont commencé après une baisse de pression.';
  }

  @override
  String reportWeatherDays(int fall, int total) {
    return '$fall jours de bilan sur $total en ont eu une.';
  }

  @override
  String reportWeatherLift(String lift) {
    return 'Rapport : ${lift}x (1,0 signifie aucun lien).';
  }

  @override
  String get reportSectionSymptoms => 'Symptômes et zones de douleur';

  @override
  String get reportSymptomsNone => 'Aucun symptôme ni zone enregistrés.';

  @override
  String reportCountOfAttacks(String name, int count, int total) {
    return '$name : $count crises sur $total';
  }

  @override
  String reportHoursShort(String hours) {
    return '$hours h';
  }

  @override
  String get notifTypeQuestionnaire => 'Questionnaires trimestriels';

  @override
  String get notifTypeQuestionnaireHint =>
      'MIDAS et HIT-6, trois mois après la dernière fois';

  @override
  String get notifQuestionnaireTitle =>
      'Trois mois depuis vos derniers questionnaires';

  @override
  String get notifQuestionnaireBody =>
      'Remplissez à nouveau MIDAS et HIT-6 pour comparer le dernier trimestre.';

  @override
  String get questionnairesTitle => 'Questionnaires';

  @override
  String get settingsQuestionnairesHint =>
      'MIDAS et HIT-6, notés et en graphique';

  @override
  String get questionnairesIntro =>
      'Deux questionnaires courts et validés sur les trois derniers mois. Refaites-les chaque trimestre : les scores sont affichés ici en graphique et peuvent figurer dans le rapport pour le médecin.';

  @override
  String get questionnaireMidasTitle => 'MIDAS';

  @override
  String get questionnaireMidasSubtitle =>
      'Migraine Disability Assessment : cinq décomptes de jours sur les trois derniers mois';

  @override
  String get questionnaireHit6Title => 'HIT-6';

  @override
  String get questionnaireHit6Subtitle =>
      'Headache Impact Test : six questions sur l\'effet des maux de tête sur votre vie';

  @override
  String get questionnaireNeverDone => 'Pas encore rempli';

  @override
  String questionnaireLatest(int score, String date) {
    return 'Dernier score $score le $date';
  }

  @override
  String get questionnaireDueNow => 'À faire maintenant';

  @override
  String questionnaireDueOn(String date) {
    return 'Prochaine fois le $date';
  }

  @override
  String get questionnaireStart => 'Remplir';

  @override
  String get questionnaireRepeat => 'Remplir à nouveau';

  @override
  String get questionnaireHistory => 'Historique des scores';

  @override
  String questionnaireChartLabel(
    int count,
    String first,
    String last,
    int latest,
  ) {
    return '$count scores du $first au $last, dernier $latest';
  }

  @override
  String get questionnaireAbout => 'À propos des scores';

  @override
  String get questionnaireAboutBody =>
      'MIDAS additionne cinq décomptes de jours : de 0 à 5 c\'est le grade I (peu ou pas de handicap), de 6 à 10 le grade II (léger), de 11 à 20 le grade III (modéré), 21 et plus le grade IV (sévère). HIT-6 donne 6, 8, 10, 11 ou 13 points par réponse, de 36 à 78 au total : jusqu\'à 49 peu ou pas d\'impact, de 50 à 55 un certain impact, de 56 à 59 un impact important, 60 et plus un impact sévère. Les tranches sont celles publiées ; les scores sont à discuter avec votre soignant.';

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
  String get questionnaireMidasUnscored => 'Ne compte pas dans le score';

  @override
  String get questionnaireDaysField => 'Jours (0 à 90)';

  @override
  String get questionnairePainField => 'Douleur (0 à 10)';

  @override
  String questionnaireDaysError(int max) {
    return 'Saisissez un nombre de 0 à $max';
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
  String get questionnaireSave => 'Enregistrer et calculer';

  @override
  String get questionnaireIncomplete =>
      'Répondez à toutes les questions notées pour enregistrer.';

  @override
  String questionnaireResultTitle(int score) {
    return 'Votre score : $score';
  }

  @override
  String get questionnaireResultDone => 'Terminé';

  @override
  String get questionnaireResultDisclaimer =>
      'Un score décrit les trois derniers mois tels que vous vous en souvenez. C\'est un point de départ pour en parler avec votre soignant, pas une évaluation médicale.';

  @override
  String get questionnaireMidasBandMinimal =>
      'Grade I : peu ou pas de handicap';

  @override
  String get questionnaireMidasBandMild => 'Grade II : handicap léger';

  @override
  String get questionnaireMidasBandModerate => 'Grade III : handicap modéré';

  @override
  String get questionnaireMidasBandSevere => 'Grade IV : handicap sévère';

  @override
  String get questionnaireHit6BandMinimal => 'Peu ou pas d\'impact';

  @override
  String get questionnaireHit6BandMild => 'Un certain impact';

  @override
  String get questionnaireHit6BandModerate => 'Impact important';

  @override
  String get questionnaireHit6BandSevere => 'Impact sévère';

  @override
  String get reportIncludeQuestionnaires =>
      'Inclure les scores des questionnaires';

  @override
  String get reportIncludeQuestionnairesHint =>
      'Questionnaires MIDAS et HIT-6 remplis pendant la période';

  @override
  String get reportSectionQuestionnaires => 'Questionnaires';

  @override
  String get reportQuestionnairesNone =>
      'Aucun questionnaire rempli sur cette période.';

  @override
  String get reportColDate => 'Date';

  @override
  String get reportColQuestionnaire => 'Questionnaire';

  @override
  String get reportColScore => 'Score';

  @override
  String get reportColBand => 'Tranche';

  @override
  String get voiceButton => 'Noter à la voix';

  @override
  String get voiceListening => 'Écoute en cours';

  @override
  String get voiceListeningHint =>
      'Dites comment ça va, par exemple : douleur sept sur dix, derrière les yeux, nausées, pris de l\'ibuprofène.';

  @override
  String get voiceStop => 'J\'ai fini';

  @override
  String get voiceCancel => 'Annuler';

  @override
  String get voiceTryAgain => 'Réessayer';

  @override
  String get voiceUnavailable =>
      'La voix n\'est pas disponible sur ce téléphone. La reconnaissance vocale nécessite l\'autorisation du micro et un pack vocal hors ligne pour votre langue.';

  @override
  String get voiceNoMatch =>
      'Rien n\'a été entendu. Réessayez plus près du téléphone ou touchez plutôt les champs.';

  @override
  String get voiceReviewTitle => 'Vérifiez avant d\'enregistrer';

  @override
  String voiceHeard(String text) {
    return 'Entendu : « $text »';
  }

  @override
  String get voiceNothingUnderstood =>
      'Rien de ce qui a été dit ne correspond au formulaire. Touchez les champs ou réessayez.';

  @override
  String get voiceIntensity => 'Intensité';

  @override
  String get voiceIntensityNone => 'Non précisé';

  @override
  String get voiceSymptoms => 'Symptômes';

  @override
  String get voiceLocations => 'Où ça fait mal';

  @override
  String get voiceMedications => 'Médicaments pris maintenant';

  @override
  String get voiceSave => 'Enregistrer dans la crise';

  @override
  String widgetLevel(String level) {
    return 'Niveau : $level';
  }

  @override
  String get widgetNoLevel => 'Ouvrez l\'app pour charger le niveau du jour';

  @override
  String widgetDriver(String factor) {
    return 'Facteur principal : $factor';
  }

  @override
  String get widgetNoDriver => 'Aucun facteur ne ressort';

  @override
  String widgetPressureFalling(String pressure) {
    return 'Pression en baisse de $pressure en 24 h';
  }

  @override
  String widgetPressureRising(String pressure) {
    return 'Pression en hausse de $pressure en 24 h';
  }

  @override
  String get widgetPressureSteady => 'Pression stable';

  @override
  String get widgetPressureUnknown => 'Pas encore de prévision de pression';

  @override
  String widgetUpdated(String time) {
    return 'Mis à jour $time';
  }

  @override
  String get widgetStartAttack => 'Démarrer une crise';

  @override
  String get widgetOpenAttack => 'Ouvrir la crise';

  @override
  String get watchStart => 'Démarrer une crise';

  @override
  String get watchStop => 'Terminer la crise';

  @override
  String get watchIntensity => 'Intensité';

  @override
  String watchSince(String time) {
    return 'Depuis $time';
  }

  @override
  String get watchPending =>
      'Enregistré sur la montre. Envoi quand le téléphone sera proche.';

  @override
  String get watchNoPhone =>
      'Ouvrez l\'app une fois sur votre téléphone pour connecter la montre.';

  @override
  String get routinesTitle => 'Routines de soin de soi';

  @override
  String get routinesIntro =>
      'Des choses simples que beaucoup trouvent utiles les jours difficiles. Prenez ce qui vous convient et laissez le reste.';

  @override
  String get routineCardTitle => 'Quelque chose qui peut aider aujourd\'hui';

  @override
  String get routineNotToday => 'Pas aujourd\'hui';

  @override
  String get routineSeeAll => 'Toutes les routines';

  @override
  String get routineStepsTitle => 'Comment faire';

  @override
  String get routineReasonHighDay => 'Le niveau du jour est élevé';

  @override
  String get routineReasonNeckTension =>
      'Votre bilan indique une tension dans la nuque';

  @override
  String get routineReasonStress => 'Votre bilan indique un stress élevé';

  @override
  String get routineStretchesTitle =>
      'Étirements doux de la nuque et des épaules';

  @override
  String get routineStretchesSummary =>
      'Cinq mouvements lents pour relâcher la nuque et les épaules. Arrêtez si quelque chose fait mal.';

  @override
  String get routineStretchesSteps =>
      'Asseyez-vous droit, les épaules détendues et les pieds à plat.\nInclinez lentement l\'oreille droite vers l\'épaule droite. Tenez 15 secondes, puis changez de côté.\nBaissez le menton vers la poitrine et tenez 15 secondes.\nFaites rouler les épaules vers l\'arrière cinq fois, puis vers l\'avant cinq fois.\nCroisez les mains derrière le dos et ouvrez doucement la poitrine pendant 15 secondes.';

  @override
  String get routineBreathingTitle => 'Respiration rythmée';

  @override
  String get routineBreathingSummary =>
      'Inspirez pendant 4 secondes et expirez pendant 6, pendant environ une minute. Une expiration lente aide beaucoup de gens à se calmer.';

  @override
  String get routineBreathingSteps =>
      'Asseyez-vous ou allongez-vous confortablement.\nInspirez par le nez pendant que le cercle grandit.\nExpirez lentement pendant qu\'il rétrécit.\nContinuez pendant six cycles, ou aussi longtemps que cela vous fait du bien.';

  @override
  String get routineLowLightTitle => 'Peu de lumière et du calme';

  @override
  String get routineLowLightSummary =>
      'La lumière vive et le bruit gênent beaucoup de gens les jours sensibles et pendant une crise.';

  @override
  String get routineLowLightSteps =>
      'Baissez la lumière ou fermez les rideaux.\nActivez le mode sombre et baissez la luminosité de l\'écran.\nPortez un masque de nuit ou des lunettes de soleil si la lumière gêne encore.\nRéduisez le bruit avec des bouchons d\'oreille ou une pièce calme.';

  @override
  String get routineHydrationTitle => 'Buvez un peu d\'eau';

  @override
  String get routineHydrationSummary =>
      'Garder de l\'eau à portée de main aide à boire tout au long de la journée.';

  @override
  String get routineHydrationSteps =>
      'Gardez un verre ou une bouteille d\'eau à portée de main.\nBuvez quelques gorgées toutes les heures.\nBuvez un verre d\'eau à chaque repas.';

  @override
  String get routineCaffeineTitle => 'Une caféine régulière';

  @override
  String get routineCaffeineSummary =>
      'De grands changements dans la quantité de caféine peuvent compter pour certaines personnes.';

  @override
  String get routineCaffeineSteps =>
      'Prenez la caféine à peu près aux mêmes heures chaque jour.\nÉvitez les fortes hausses, et évitez de sauter d\'un coup votre quantité habituelle.\nPrenez votre dernière boisson caféinée en début d\'après-midi.';

  @override
  String get routineSleepTitle => 'Un sommeil régulier';

  @override
  String get routineSleepSummary =>
      'Des horaires de sommeil réguliers, week-ends compris, aident beaucoup de gens.';

  @override
  String get routineSleepSteps =>
      'Couchez-vous et levez-vous à peu près à la même heure chaque jour.\nGardez la chambre sombre, calme et fraîche.\nRangez les écrans 30 minutes avant de dormir.\nÉvitez les longues siestes en fin de journée.';

  @override
  String get breathingStart => 'Commencer';

  @override
  String get breathingStop => 'Arrêter';

  @override
  String get breathingIn => 'Inspirez';

  @override
  String get breathingOut => 'Expirez';

  @override
  String breathingRound(int round, int total) {
    return 'Cycle $round sur $total';
  }

  @override
  String get breathingDone => 'Terminé. Prenez un moment avant de vous lever.';

  @override
  String get settingsRoutinesHint =>
      'Étirements, respiration et autres routines simples';

  @override
  String get experimentsTitle => 'Expériences';

  @override
  String get settingsExperimentsHint =>
      'Testez un changement pendant deux semaines et comparez';

  @override
  String get experimentsIntro =>
      'Testez un changement pendant deux semaines et comparez avec les deux semaines précédentes. Une expérience à la fois.';

  @override
  String get experimentsPick => 'Choisissez un changement';

  @override
  String get experimentChangeCutCaffeine => 'Réduire la caféine';

  @override
  String get experimentChangeRegularSleep =>
      'Se coucher à la même heure chaque soir';

  @override
  String get experimentChangeMoreWater => 'Boire plus d\'eau';

  @override
  String get experimentChangeDailyStretches => 'Étirer la nuque chaque jour';

  @override
  String get experimentChangeLessScreens => 'Moins d\'écrans le soir';

  @override
  String get experimentChangeNoAlcohol => 'Se passer d\'alcool';

  @override
  String experimentDay(int day, int total) {
    return 'Jour $day sur $total';
  }

  @override
  String get experimentAdherenceQuestion => 'Avez-vous tenu aujourd\'hui ?';

  @override
  String get experimentYes => 'Oui';

  @override
  String get experimentNo => 'Non';

  @override
  String experimentAdherence(int kept, int days) {
    return 'Tenu $kept jours sur $days';
  }

  @override
  String get experimentCompareTitle => 'Deux semaines avant et pendant';

  @override
  String get experimentBefore => 'Avant';

  @override
  String get experimentDuring => 'Pendant';

  @override
  String get experimentRowRate => 'Crises par semaine';

  @override
  String get experimentRowIntensity => 'Intensité moyenne';

  @override
  String get experimentRowDuration => 'Durée médiane';

  @override
  String experimentSample(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sur $count crises',
      one: 'sur 1 crise',
      zero: 'aucune crise',
    );
    return '$_temp0';
  }

  @override
  String experimentDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get experimentNoData => 'Pas de données';

  @override
  String get experimentCaveat =>
      'Deux semaines, c\'est court. La météo, les saisons et le stress changent d\'eux-mêmes : voyez cela comme une piste, pas comme une preuve.';

  @override
  String experimentSmallSample(int min) {
    return 'Moins de $min crises sur l\'une des périodes, les chiffres peuvent donc varier beaucoup.';
  }

  @override
  String get experimentStop => 'Arrêter l\'expérience';

  @override
  String get experimentFinish => 'Terminer et enregistrer le résultat';

  @override
  String get experimentDue => 'Les deux semaines sont écoulées.';

  @override
  String get experimentPast => 'Expériences passées';

  @override
  String experimentFinished(String date) {
    return 'Terminée le $date';
  }

  @override
  String experimentStopped(String date) {
    return 'Arrêtée le $date';
  }

  @override
  String experimentPastSummary(String before, String during) {
    return '$before crises par semaine avant, $during pendant';
  }

  @override
  String get accountTitle => 'Compte';

  @override
  String get settingsAccountHint =>
      'Facultatif. Nécessaire seulement pour la sauvegarde et les liens';

  @override
  String get accountIntro =>
      'Un compte est facultatif. Tout fonctionne sans, et vos données restent sur ce téléphone. Il ne sert qu\'à la sauvegarde chiffrée et aux liens de partage.';

  @override
  String get accountUnavailable =>
      'Les comptes ne sont pas configurés dans cette version.';

  @override
  String get accountApple => 'Continuer avec Apple';

  @override
  String get accountGoogle => 'Continuer avec Google';

  @override
  String get accountOrEmail => 'Ou utilisez votre e-mail';

  @override
  String get accountEmail => 'E-mail';

  @override
  String get accountPassword => 'Mot de passe';

  @override
  String accountPasswordHint(int min) {
    return 'Au moins $min caractères pour un nouveau compte';
  }

  @override
  String get accountSignIn => 'Se connecter';

  @override
  String get accountCreate => 'Créer un compte';

  @override
  String get accountForgot => 'Mot de passe oublié ?';

  @override
  String get accountResetSent =>
      'Si cet e-mail a un compte, un lien de réinitialisation est en route.';

  @override
  String accountSignedInAs(String email) {
    return 'Connecté en tant que $email';
  }

  @override
  String accountSignedInWith(String method) {
    return 'Connecté avec $method';
  }

  @override
  String get accountMethodApple => 'Apple';

  @override
  String get accountMethodGoogle => 'Google';

  @override
  String get accountMethodEmail => 'e-mail';

  @override
  String get accountSignedInNote =>
      'Vos données restent sur ce téléphone. Se déconnecter n\'efface rien.';

  @override
  String get accountSignOut => 'Se déconnecter';

  @override
  String get accountDelete => 'Supprimer le compte';

  @override
  String get accountDeleteTitle => 'Supprimer votre compte ?';

  @override
  String accountDeleteBody(int hours) {
    return 'Cela supprime votre compte. Sous $hours heures, votre sauvegarde chiffrée et vos liens partagés sont retirés de nos serveurs. Tout ce qui est sur ce téléphone reste.';
  }

  @override
  String get accountDeletePassword =>
      'Saisissez votre mot de passe pour confirmer';

  @override
  String get accountDeleteSubscription =>
      'Premium est facturé par l\'App Store ou Google Play. Supprimer le compte ne l\'arrête pas ; résiliez-le dans la boutique.';

  @override
  String get accountDeleteCancel => 'Garder le compte';

  @override
  String accountDeleted(int hours) {
    return 'Compte supprimé. Les données sur le serveur seront effacées sous $hours heures.';
  }

  @override
  String get accountErrorWrongCredentials =>
      'Cet e-mail et ce mot de passe ne correspondent pas.';

  @override
  String get accountErrorEmailInUse =>
      'Cet e-mail a déjà un compte. Essayez de vous connecter.';

  @override
  String get accountErrorWeakPassword =>
      'Choisissez un mot de passe plus long.';

  @override
  String get accountErrorInvalidEmail => 'Vérifiez l\'adresse e-mail.';

  @override
  String get accountErrorNetwork =>
      'Pas de connexion. Réessayez une fois en ligne.';

  @override
  String get accountErrorRecentSignIn =>
      'Par sécurité, reconnectez-vous puis réessayez.';

  @override
  String get accountErrorUnknown => 'Un problème est survenu. Réessayez.';

  @override
  String get backupTitle => 'Sauvegarde chiffrée';

  @override
  String get settingsBackupHint =>
      'Protégée par une phrase secrète que vous seul connaissez';

  @override
  String get backupIntro =>
      'Votre sauvegarde est chiffrée sur ce téléphone avec votre phrase secrète avant l\'envoi. Nous ne stockons que le fichier chiffré et ne pouvons pas l\'ouvrir.';

  @override
  String get backupForgetWarning =>
      'Si vous oubliez la phrase secrète, personne ne pourra ouvrir la sauvegarde, pas même nous. Notez-la dans un endroit sûr.';

  @override
  String get backupNeedsAccount =>
      'La sauvegarde nécessite un compte. Tout le reste fonctionne sans.';

  @override
  String get backupOpenAccount => 'Créer un compte';

  @override
  String get backupNone => 'Pas encore de sauvegarde';

  @override
  String backupLast(String date) {
    return 'Dernière sauvegarde : $date';
  }

  @override
  String get backupStatusUnknown =>
      'Impossible de vérifier la sauvegarde pour le moment.';

  @override
  String get backupPassphrase => 'Phrase secrète';

  @override
  String backupPassphraseHint(int min) {
    return 'Au moins $min caractères. Quelques mots sans rapport entre eux fonctionnent bien.';
  }

  @override
  String get backupPassphraseRepeat =>
      'Répétez la phrase secrète pour sauvegarder';

  @override
  String get backupNow => 'Sauvegarder maintenant';

  @override
  String get backupDone => 'Sauvegardé.';

  @override
  String get backupRestore => 'Restaurer depuis la sauvegarde';

  @override
  String get backupRestoreTitle => 'Tout remplacer sur ce téléphone ?';

  @override
  String backupRestoreBody(String date) {
    return 'Tout ce qui est sur ce téléphone sera remplacé par la sauvegarde du $date.';
  }

  @override
  String get backupRestoreConfirm => 'Restaurer';

  @override
  String get backupRestored => 'Restauré depuis votre sauvegarde.';

  @override
  String get backupDelete => 'Supprimer la sauvegarde';

  @override
  String get backupDeleteTitle => 'Supprimer la sauvegarde ?';

  @override
  String get backupDeleteBody =>
      'Le fichier chiffré est retiré de nos serveurs. Tout ce qui est sur ce téléphone reste.';

  @override
  String get backupDeleted => 'Sauvegarde supprimée.';

  @override
  String get backupWorking => 'En cours. Cela peut prendre quelques secondes.';

  @override
  String get backupErrorMismatch =>
      'Les deux phrases secrètes ne correspondent pas.';

  @override
  String backupErrorShort(int min) {
    return 'Utilisez au moins $min caractères.';
  }

  @override
  String get backupErrorNoBackup =>
      'Il n\'y a pas encore de sauvegarde sur ce compte.';

  @override
  String get backupErrorTooLarge =>
      'La sauvegarde est trop volumineuse pour être envoyée.';

  @override
  String get backupErrorNewerApp =>
      'Cette sauvegarde vient d\'une version plus récente de l\'app. Mettez l\'app à jour et réessayez.';

  @override
  String get backupErrorWrongPassphrase =>
      'Cette phrase secrète n\'ouvre pas cette sauvegarde.';

  @override
  String get backupErrorDamaged => 'Le fichier de sauvegarde est endommagé.';

  @override
  String get backupErrorPinning =>
      'Impossible de vérifier la connexion au serveur de sauvegarde, rien n\'a donc été envoyé. Essayez un autre réseau.';

  @override
  String get backupErrorNotAllowed =>
      'Votre session a expiré. Reconnectez-vous puis réessayez.';

  @override
  String get shareLinkButton => 'Partager par lien';

  @override
  String get shareLinkTitle => 'Partager avec votre médecin';

  @override
  String get shareLinkExplain =>
      'Toute personne ayant le lien peut lire ce rapport jusqu\'à son expiration. Il montre le même résumé que le PDF, pas votre journal. Vous pouvez arrêter le partage à tout moment.';

  @override
  String get shareLinkNeedsAccount =>
      'Partager un lien nécessite un compte. Le PDF et le CSV fonctionnent sans.';

  @override
  String shareLinkDuration(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get shareLinkCreate => 'Créer le lien';

  @override
  String get shareLinkWorking => 'Création du lien.';

  @override
  String shareLinkReady(String date) {
    return 'Lien prêt. Partagé jusqu\'au $date.';
  }

  @override
  String get shareLinkCopy => 'Copier le lien';

  @override
  String get shareLinkCopied => 'Lien copié.';

  @override
  String get shareLinkShare => 'Partager le lien';

  @override
  String shareLinkMessage(String url) {
    return 'Mon rapport de migraine : $url';
  }

  @override
  String get shareLinksTitle => 'Liens partagés';

  @override
  String get settingsShareLinksHint =>
      'Voir et arrêter les liens de rapport que vous avez partagés';

  @override
  String get shareLinksEmpty =>
      'Vous n\'avez partagé aucun lien. Créez-en un depuis le rapport pour le médecin.';

  @override
  String shareLinkActiveUntil(String date) {
    return 'Partagé jusqu\'au $date';
  }

  @override
  String shareLinkExpiredOn(String date) {
    return 'Expiré le $date';
  }

  @override
  String get shareLinkRevoked => 'Partage arrêté';

  @override
  String shareLinkCreatedOn(String date) {
    return 'Créé le $date';
  }

  @override
  String get shareLinkRevoke => 'Arrêter le partage';

  @override
  String get shareLinkRevokeTitle => 'Arrêter de partager ce rapport ?';

  @override
  String get shareLinkRevokeBody =>
      'Le lien cesse de fonctionner immédiatement, pour tous ceux qui l\'ont.';

  @override
  String get shareLinkRevokedDone =>
      'Partage arrêté. Le lien ne fonctionne plus.';

  @override
  String get shareLinkErrorUnavailable =>
      'Les liens de partage ne sont pas configurés dans cette version.';

  @override
  String get shareLinkErrorSignedOut =>
      'Votre session a expiré. Reconnectez-vous puis réessayez.';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumIntro =>
      'Premium ajoute quatre extras. Tout le reste reste gratuit, sans limite de durée.';

  @override
  String get premiumFreeNote =>
      'Toujours gratuit : noter les crises et le suivi quotidien, la météo, le niveau de risque, vos facteurs, le journal des médicaments et le rapport pour le médecin.';

  @override
  String get premiumFeatureShareLink => 'Lien pour votre médecin';

  @override
  String get premiumFeatureShareLinkHint =>
      'Envoyez votre rapport sous forme de lien qui cesse de fonctionner après 7 ou 30 jours.';

  @override
  String get premiumFeatureExperiments => 'Expériences';

  @override
  String get premiumFeatureExperimentsHint =>
      'Testez un changement pendant deux semaines et comparez avec les semaines précédentes.';

  @override
  String get premiumFeatureExtendedFactors =>
      'Facteurs environnementaux étendus';

  @override
  String get premiumFeatureExtendedFactorsHint =>
      'Particules, ozone et pollens par type.';

  @override
  String get premiumFeatureBackup => 'Sauvegarde entre téléphones';

  @override
  String get premiumFeatureBackupHint =>
      'Une sauvegarde chiffrée que vous pouvez restaurer sur un nouveau téléphone.';

  @override
  String get premiumActive => 'Premium est actif.';

  @override
  String premiumRenews(String date) {
    return 'Renouvellement le $date.';
  }

  @override
  String premiumEnds(String date) {
    return 'Se termine le $date.';
  }

  @override
  String get premiumManage => 'Gérer l\'abonnement';

  @override
  String premiumOfferMonthly(String price) {
    return 'Mensuel, $price';
  }

  @override
  String premiumOfferAnnual(String price) {
    return 'Annuel, $price';
  }

  @override
  String premiumOfferOther(String price) {
    return '$price';
  }

  @override
  String get premiumRestore => 'Restaurer les achats';

  @override
  String get premiumRestoredNone =>
      'Aucun achat Premium trouvé pour ce compte de boutique.';

  @override
  String get premiumThanks => 'Merci. Premium est actif.';

  @override
  String get premiumRenewalTerms =>
      'Les abonnements se renouvellent automatiquement jusqu\'à leur résiliation dans les réglages de la boutique. Résiliez au moins 24 heures avant la date de renouvellement pour éviter le prochain prélèvement.';

  @override
  String get premiumLoadingOffers => 'Chargement des prix.';

  @override
  String get premiumNoOffers =>
      'Impossible de charger les prix. Vérifiez votre connexion et réessayez.';

  @override
  String get premiumRetry => 'Réessayer';

  @override
  String get premiumUnavailable =>
      'Les achats ne sont pas configurés dans cette version.';

  @override
  String get premiumDevUnlocked =>
      'Version de développement : toutes les fonctions Premium sont débloquées.';

  @override
  String get premiumAccountTip =>
      'Vous utilisez plusieurs téléphones ? Connectez-vous d\'abord pour que Premium suive votre compte.';

  @override
  String get premiumErrorNotAllowed =>
      'Ce compte de boutique ne peut pas effectuer d\'achats.';

  @override
  String get premiumErrorPending =>
      'L\'achat attend une approbation. Premium s\'activera une fois l\'achat terminé.';

  @override
  String get premiumErrorStore =>
      'La boutique a rencontré un problème. Réessayez plus tard.';

  @override
  String premiumLockTitle(String feature) {
    return '$feature fait partie de Premium.';
  }

  @override
  String get premiumLockButton => 'Voir Premium';

  @override
  String get premiumLockShareLinkNote =>
      'Les liens déjà créés fonctionnent jusqu\'à leur expiration, et vous pouvez arrêter de les partager à tout moment.';

  @override
  String get premiumLockExperimentsNote => 'Vos résultats passés restent ici.';

  @override
  String get premiumLockBackupNote =>
      'Vous pouvez toujours restaurer ou supprimer une sauvegarde existante.';

  @override
  String get premiumFactorsLocked =>
      'Les particules, l\'ozone et les pollens font partie de Premium.';

  @override
  String get settingsPremiumHint =>
      'Lien de partage, expériences, facteurs étendus et sauvegarde';

  @override
  String get settingsPremiumActive => 'Actif';

  @override
  String get shareLinkErrorPremium =>
      'Les liens de partage nécessitent Premium. Si vous venez de vous abonner, attendez une minute et réessayez.';

  @override
  String get auditTitle => 'Comment le niveau de risque s\'en est sorti';

  @override
  String auditNotYet(int needed, int logged) {
    return 'Cette page apparaît une fois $needed crises notées. Vous en avez noté $logged jusqu\'ici.';
  }

  @override
  String auditIntro(int window) {
    String _temp0 = intl.Intl.pluralLogic(
      window,
      locale: localeName,
      other: 'les $window jours précédents',
      one: 'la veille',
    );
    return 'Ceci compare le niveau affiché par l\'app chaque jour avec le début de vos crises. Une crise compte comme suivant un jour Élevé quand le jour où elle a commencé ou $_temp0 était affiché Élevé.';
  }

  @override
  String get auditEmpty =>
      'Rien à comparer pour l\'instant. Désormais, l\'app garde le niveau affiché chaque jour, et les premiers chiffres apparaîtront après votre prochaine crise ou le prochain jour Élevé.';

  @override
  String get auditHitsTitle => 'Crises survenues après un jour Élevé';

  @override
  String auditHitsValue(int hits, int attacks, String share) {
    return '$hits sur $attacks ($share)';
  }

  @override
  String get auditMissesTitle => 'Crises sans jour Élevé avant';

  @override
  String auditMissesValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count crises',
      one: '1 crise',
    );
    return '$_temp0';
  }

  @override
  String get auditFalseAlarmsTitle => 'Jours Élevés sans crise';

  @override
  String auditFalseAlarmsValue(int count, int highDays) {
    return '$count sur $highDays jours Élevés';
  }

  @override
  String get auditTrend => 'Par mois';

  @override
  String auditMonthLine(int hits, int attacks, int falseAlarms, int highDays) {
    return '$hits crises sur $attacks après un jour Élevé ; $falseAlarms jours Élevés sur $highDays sans crise';
  }

  @override
  String get auditCaveat =>
      'Les petits nombres varient beaucoup d\'un mois à l\'autre. Un jour Élevé sans crise n\'est pas une erreur : cela signifie que davantage de vos déclencheurs habituels se sont cumulés. Le niveau est un repère pour s\'organiser, pas une promesse.';

  @override
  String get auditShare => 'Partager ces chiffres chaque mois';

  @override
  String get auditShareHint =>
      'Cela aide à évaluer l\'app pour tout le monde. Seuls les cinq chiffres et la version du modèle sont envoyés, jamais de dates, de lieux, votre journal ou votre compte. Désactivé tant que vous ne l\'activez pas.';

  @override
  String get settingsAuditHint =>
      'Crises après des jours Élevés et jours Élevés sans crise';

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
  String get unitsTitle => 'Unités';

  @override
  String get settingsUnitsHint => 'Pression et température';

  @override
  String get unitsPressure => 'Pression';

  @override
  String get unitsTemperature => 'Température';

  @override
  String get unitNameHpa => 'Hectopascals (hPa)';

  @override
  String get unitNameInHg => 'Pouces de mercure (inHg)';

  @override
  String get unitNameMmHg => 'Millimètres de mercure (mmHg)';

  @override
  String get unitNameCelsius => 'Celsius (°C)';

  @override
  String get unitNameFahrenheit => 'Fahrenheit (°F)';

  @override
  String get unitsNote =>
      'Le premier choix vient de la région de votre téléphone. Le modifier change seulement l\'affichage ; votre journal reste identique.';

  @override
  String envTemperatureNow(String temperature) {
    return 'Température actuelle : $temperature';
  }

  @override
  String get questionnaireEnglishNote =>
      'Les questions sont affichées dans leur formulation anglaise d\'origine jusqu\'à l\'ajout d\'une traduction validée, afin que vos scores restent comparables.';

  @override
  String get wellnessDisclaimer =>
      'Informations générales de bien-être, pas un avis médical. Parlez du traitement avec votre médecin.';

  @override
  String get dataSourceWeather => 'Météo Open-Meteo';

  @override
  String get dataSourceAirQuality =>
      'Qualité de l\'air et UV Open-Meteo (CAMS)';

  @override
  String get dataSourcePollen => 'Pollens Open-Meteo (CAMS)';

  @override
  String get dataSourceGeocoding => 'Géocodage Open-Meteo';

  @override
  String get dataSourceBarometer => 'Baromètre de l\'appareil';

  @override
  String get dataCoverageWorldwide => 'Monde entier';

  @override
  String get dataCoverageEuropeanAqi => 'Monde entier, IQA européen en Europe';

  @override
  String get dataCoverageEurope => 'Europe uniquement';

  @override
  String get dataCoverageBarometer => 'Téléphones avec capteur de pression';
}
