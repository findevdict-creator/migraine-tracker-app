// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Aurawell';

  @override
  String get homeEmptyState =>
      'Aún no hay nada registrado.\nTu nivel de riesgo y tu entorno aparecerán aquí.';

  @override
  String get riskLevelLow => 'Bajo';

  @override
  String get riskLevelModerate => 'Moderado';

  @override
  String get riskLevelHigh => 'Alto';

  @override
  String get devThemeGalleryTitle => 'Galería de temas';

  @override
  String get devThemeLight => 'Tema claro';

  @override
  String get devThemeDark => 'Tema oscuro';

  @override
  String get devThemeAttack => 'Tema de crisis';

  @override
  String get devSampleBody =>
      'Texto con el tamaño predeterminado. Debe seguir siendo legible al 200 % sin cortarse.';

  @override
  String get devSamplePrimary => 'Principal';

  @override
  String get devSampleSecondary => 'Secundario';

  @override
  String get devSampleText => 'Texto';

  @override
  String get devSampleDisabled => 'Desactivado';

  @override
  String get devSampleChipOn => 'Aura';

  @override
  String get devSampleChipOff => 'Náuseas';

  @override
  String get devSampleChipIcon => 'Luz';

  @override
  String get devSampleSlider => 'Intensidad';

  @override
  String get devSampleSliderLow => 'Sin dolor';

  @override
  String get devSampleSliderHigh => 'Peor';

  @override
  String get devSampleCard => 'Una tarjeta con una insignia';

  @override
  String get attackStart => 'Iniciar crisis';

  @override
  String get attackContinue => 'Continuar crisis';

  @override
  String get attackTitleRunning => 'Crisis en curso';

  @override
  String get attackTitleEnded => 'Crisis';

  @override
  String attackStartedAt(String time) {
    return 'Empezó a las $time';
  }

  @override
  String get attackNotFound => 'Esta crisis ya no existe.';

  @override
  String get attackIntensity => 'Intensidad del dolor';

  @override
  String get durationEstimateTitle => 'Cuánto suelen durar crisis como esta';

  @override
  String durationEstimateRange(String low, String high) {
    return 'Normalmente de $low a $high h';
  }

  @override
  String durationEstimateSameMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Según $count crisis anteriores de intensidad parecida con la misma medicación',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateNoMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Según $count crisis anteriores de intensidad parecida sin medicación',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateSimilar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Según $count crisis anteriores de intensidad parecida',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Según $count de tus crisis anteriores',
    );
    return '$_temp0';
  }

  @override
  String get attackIntensityLow => 'Sin dolor';

  @override
  String get attackIntensityHigh => 'Peor';

  @override
  String get attackWhereItHurts => 'Dónde duele';

  @override
  String get attackSymptoms => 'Síntomas';

  @override
  String get attackPhases => 'Fases';

  @override
  String get attackNotes => 'Notas';

  @override
  String get attackNotesHint =>
      'Cualquier otra cosa que valga la pena recordar';

  @override
  String get attackEnd => 'Terminar crisis';

  @override
  String get attackDone => 'Listo';

  @override
  String get attackFinishLater => 'Terminar más tarde';

  @override
  String get symptomAura => 'Aura';

  @override
  String get symptomNeckTension => 'Tensión en el cuello';

  @override
  String get symptomLightSensitivity => 'Luz';

  @override
  String get symptomSoundSensitivity => 'Sonido';

  @override
  String get symptomSmellSensitivity => 'Olores';

  @override
  String get symptomNausea => 'Náuseas';

  @override
  String get phaseProdrome => 'Pródromo';

  @override
  String get phaseAura => 'Aura';

  @override
  String get phaseAttack => 'Crisis';

  @override
  String get phasePostdrome => 'Posdromo';

  @override
  String get headForehead => 'Frente';

  @override
  String get headLeftTemple => 'Sien izquierda';

  @override
  String get headRightTemple => 'Sien derecha';

  @override
  String get headBehindEyes => 'Detrás de los ojos';

  @override
  String get headLeftSide => 'Lado izquierdo';

  @override
  String get headRightSide => 'Lado derecho';

  @override
  String get headTopOfHead => 'Parte superior de la cabeza';

  @override
  String get headBackOfHead => 'Nuca';

  @override
  String get headNeck => 'Cuello';

  @override
  String get checkinTitle => 'Registro diario';

  @override
  String get checkinLoadError => 'No se pudo cargar este día.';

  @override
  String get checkinIntro => 'Tres toques. ¿Qué tal fue?';

  @override
  String get checkinComplete =>
      'Listo para este día. Toca un número para cambiarlo.';

  @override
  String get checkinAddMore => 'Añadir más (opcional)';

  @override
  String get checkinOptionalTitle => 'Opcional';

  @override
  String get checkinDone => 'Listo';

  @override
  String get checkinToday => 'Hoy';

  @override
  String get checkinSleepQuality => 'Calidad del sueño';

  @override
  String get checkinStress => 'Estrés';

  @override
  String get checkinNeckTension => 'Tensión en el cuello';

  @override
  String get checkinCaffeine => 'Cafeína';

  @override
  String get checkinHydration => 'Hidratación';

  @override
  String get checkinAlcohol => 'Alcohol';

  @override
  String get checkinLightExposure => 'Luz intensa';

  @override
  String get checkinScreenExposure => 'Tiempo de pantalla';

  @override
  String get checkinSleepLow => 'Malo';

  @override
  String get checkinSleepHigh => 'Excelente';

  @override
  String get checkinStressLow => 'Tranquilo';

  @override
  String get checkinStressHigh => 'Muy estresado';

  @override
  String get checkinNeckLow => 'Relajado';

  @override
  String get checkinNeckHigh => 'Muy tenso';

  @override
  String get checkinHydrationLow => 'Poca';

  @override
  String get checkinHydrationHigh => 'Mucha';

  @override
  String get checkinExposureLow => 'Poca';

  @override
  String get checkinExposureHigh => 'Mucha';

  @override
  String get checkinNone => 'Nada';

  @override
  String checkinCupsOrMore(int count) {
    return '$count+ tazas';
  }

  @override
  String checkinDrinksOrMore(int count) {
    return '$count+ bebidas';
  }

  @override
  String checkinValueSemantics(String field, int value, int max) {
    return '$field, $value de $max';
  }

  @override
  String get checkinReminderTooltip => 'Hora del recordatorio';

  @override
  String checkinReminderAt(String time) {
    return 'Recordatorio a las $time';
  }

  @override
  String get checkinReminderPickerTitle => 'Recordatorio del registro diario';

  @override
  String get checkinCardTitle => 'Registro diario';

  @override
  String get checkinCardDone => 'Listo por hoy';

  @override
  String get checkinCardTodo => 'Tres toques, unos 10 segundos';

  @override
  String get medicationTitle => 'Medicación';

  @override
  String get medicationAdd => 'Añadir medicación';

  @override
  String get medicationAddTitle => 'Registrar una dosis';

  @override
  String get medicationName => 'Medicamento';

  @override
  String get medicationDose => 'Dosis';

  @override
  String get medicationDoseHint => 'p. ej. 400 mg';

  @override
  String get medicationKindAcute => 'Aguda';

  @override
  String get medicationKindPreventive => 'Preventiva';

  @override
  String medicationTakenAt(String time) {
    return 'Tomada a las $time';
  }

  @override
  String get medicationLog => 'Registrar';

  @override
  String get medicationDelete => 'Eliminar';

  @override
  String get medicationThisMonth => 'Este mes';

  @override
  String get medicationEmpty => 'No hay dosis registradas este mes.';

  @override
  String get medicationReliefQuestion => '¿Alivio a las 2 h?';

  @override
  String get medicationReliefNone => 'Ninguno';

  @override
  String get medicationReliefPartial => 'Algo';

  @override
  String get medicationReliefFull => 'Total';

  @override
  String medicationAcuteDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días con medicación aguda este mes',
      one: '1 día con medicación aguda este mes',
      zero: 'Ningún día con medicación aguda este mes',
    );
    return '$_temp0';
  }

  @override
  String get medicationAcuteDaysHint =>
      'Días con al menos una dosis aguda, contados por mes natural.';

  @override
  String medicationOveruseFirstNote(int days) {
    return 'Has llegado a $days días con medicación aguda este mes. Muchos profesionales sanitarios recomiendan mantener esta cifra baja; puede valer la pena comentarlo.';
  }

  @override
  String medicationOveruseSecondNote(int days) {
    return 'Has llegado a $days días con medicación aguda este mes. Considera hablar de este patrón con tu profesional sanitario.';
  }

  @override
  String get medicationTalkToClinician => 'Habla con tu profesional sanitario';

  @override
  String get cycleTitle => 'Ciclo';

  @override
  String get cycleToggleTitle => 'Seguir mi ciclo';

  @override
  String get cycleToggleSubtitle =>
      'Desactivado por defecto. Si lo activas, el día del ciclo se guarda con cada registro y se usa como factor.';

  @override
  String get cycleNoData =>
      'Registra el inicio de un periodo para ver tu día del ciclo.';

  @override
  String cycleDayAndPhase(int day, String phase) {
    return 'Día $day del ciclo · $phase';
  }

  @override
  String cycleLength(int days) {
    return 'Según un ciclo de $days días';
  }

  @override
  String get cyclePeriodStarts => 'Inicios del periodo';

  @override
  String get cycleNoStarts => 'Aún no hay ninguno registrado.';

  @override
  String get cycleRemoveStart => 'Quitar';

  @override
  String get cyclePeriodStartedToday => 'El periodo empezó este día';

  @override
  String get cyclePhaseMenstrual => 'Menstrual';

  @override
  String get cyclePhaseFollicular => 'Folicular';

  @override
  String get cyclePhaseOvulation => 'Alrededor de la ovulación';

  @override
  String get cyclePhaseLuteal => 'Lútea';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSectionDaily => 'Diario';

  @override
  String get settingsSectionData => 'Tus datos';

  @override
  String get settingsSectionAbout => 'Información';

  @override
  String get settingsExportJson => 'Exportar como JSON';

  @override
  String get settingsExportJsonHint =>
      'Todas las tablas en un archivo que puedes volver a importar.';

  @override
  String get settingsExportCsv => 'Exportar como CSV';

  @override
  String get settingsExportCsvHint =>
      'Un archivo de hoja de cálculo por tabla.';

  @override
  String get settingsExportEmpty => 'Aún no hay nada que exportar.';

  @override
  String get settingsDeleteAll => 'Borrar todo';

  @override
  String get settingsDeleteAllHint =>
      'Elimina todos los datos de este dispositivo. No se puede deshacer.';

  @override
  String settingsDeleteAllConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Se borrarán $count registros de este dispositivo. No se puede deshacer.',
      one: 'Se borrará 1 registro de este dispositivo. No se puede deshacer.',
      zero: 'Aún no hay nada guardado. ¿Borrar de todos modos?',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeleteAllButton => 'Borrar';

  @override
  String get settingsCancel => 'Cancelar';

  @override
  String get settingsDeletedAll => 'Se han borrado todos los datos.';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsTerms => 'Condiciones de uso';

  @override
  String get settingsSupport => 'Asistencia';

  @override
  String get environmentTitle => 'Entorno';

  @override
  String get environmentCardTitle => 'Presión';

  @override
  String get environmentCardEmpty =>
      'Aún no hay datos del tiempo. Toca para elegir tu ubicación.';

  @override
  String environmentCardSummary(String pressure, String trend) {
    return '$pressure, $trend';
  }

  @override
  String get envPressureSection => 'Presión atmosférica';

  @override
  String get envPressureUnknown => 'Sin lectura para esta hora';

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
  String get envChartTitle => 'Últimas 48 horas y próximas 24';

  @override
  String get envUpdatedNever => 'Aún sin actualizar';

  @override
  String get envUpdatedJustNow => 'Actualizado ahora mismo';

  @override
  String envUpdatedMinutes(int n) {
    return 'Actualizado hace $n min';
  }

  @override
  String envUpdatedHours(int n) {
    return 'Actualizado hace $n h';
  }

  @override
  String envUpdatedDays(int n) {
    return 'Actualizado hace $n d';
  }

  @override
  String get envStale =>
      'Este pronóstico tiene unas horas. Se actualiza cuando vuelvas a tener conexión.';

  @override
  String get envOffline =>
      'No se pudo conectar con el servicio del tiempo. Se muestra lo guardado en este dispositivo.';

  @override
  String get envNoData =>
      'Aún no hay datos del tiempo. Permite la ubicación o elige una ciudad para ver la tendencia de la presión.';

  @override
  String get envRefresh => 'Actualizar';

  @override
  String get envLocationSection => 'Ubicación';

  @override
  String get envLocationGps => 'Usando tu ubicación aproximada';

  @override
  String envLocationManual(String city) {
    return 'Usando $city';
  }

  @override
  String get envLocationLast => 'Usando la última zona conocida';

  @override
  String get envLocationNone => 'Sin ubicación';

  @override
  String get envUseMyLocation => 'Usar mi ubicación';

  @override
  String get envChooseCity => 'Elegir una ciudad';

  @override
  String get envCitySearchTitle => 'Elegir una ciudad';

  @override
  String get envCitySearchHint => 'Nombre de la ciudad';

  @override
  String get envCityNoResults => 'No se encontraron lugares';

  @override
  String get envCitySearchFailed =>
      'No se puede buscar ahora. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get envPrivacyNote =>
      'Tu ubicación se redondea a unos 10 km antes de salir de este dispositivo.';

  @override
  String get envAttribution => 'Datos del tiempo de Open-Meteo';

  @override
  String get envTrendRising => 'subiendo';

  @override
  String get envTrendFalling => 'bajando';

  @override
  String get envTrendSteady => 'estable';

  @override
  String get envTrendUnknown => 'aún sin tendencia';

  @override
  String get barometerTitle => 'Barómetro';

  @override
  String get barometerOpen => 'Abrir el barómetro';

  @override
  String get barometerNoReading => 'Sin lectura';

  @override
  String get barometerFromSensor => 'Del sensor de este dispositivo';

  @override
  String get barometerFromStation => 'De la estación más cercana';

  @override
  String get barometerNoSource =>
      'Este dispositivo no tiene sensor y aún no hay pronóstico guardado';

  @override
  String get barometerCalibrationSection => 'Calibración';

  @override
  String barometerOffset(String offset, int pairs) {
    return 'Desfase del sensor $offset respecto a la estación, a partir de $pairs pares horarios.';
  }

  @override
  String barometerNotCalibrated(int pairs) {
    return 'Aún sin calibrar. Hacen falta al menos $pairs horas con una muestra del sensor y un valor de la estación.';
  }

  @override
  String get barometerTrendSection => 'Últimas 24 horas en este dispositivo';

  @override
  String get barometerTrendEmpty =>
      'Las muestras se toman mientras la app está abierta. Vuelve más tarde para ver la tendencia.';

  @override
  String barometerTrendSamples(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n muestras',
      one: '1 muestra',
    );
    return '$_temp0';
  }

  @override
  String get barometerStampNote =>
      'Cada crisis que inicias guarda la lectura del sensor y el valor de la estación de esa hora.';

  @override
  String get envFactorsTitle => 'Factores de hoy';

  @override
  String get envFactorsEmpty => 'Aún no hay factores diarios para esta zona.';

  @override
  String get factorBandLow => 'bajo';

  @override
  String get factorBandModerate => 'moderado';

  @override
  String get factorBandHigh => 'alto';

  @override
  String get factorBandVeryHigh => 'muy alto';

  @override
  String factorValueWithBand(String value, String band) {
    return '$value ($band)';
  }

  @override
  String get factorAqiUs => 'Calidad del aire (AQI de EE. UU.)';

  @override
  String get factorAqiEu => 'Calidad del aire (AQI europeo)';

  @override
  String get factorParticulates => 'Partículas PM2.5 / PM10';

  @override
  String factorParticulatesValue(String pm25, String pm10) {
    return '$pm25 / $pm10 µg/m³';
  }

  @override
  String get factorOzone => 'Ozono';

  @override
  String factorMicrograms(String value) {
    return '$value µg/m³';
  }

  @override
  String get factorPollen => 'Polen (solo Europa)';

  @override
  String factorPollenType(String type, String band) {
    return '$type $band';
  }

  @override
  String get pollenAlder => 'aliso';

  @override
  String get pollenBirch => 'abedul';

  @override
  String get pollenGrass => 'gramíneas';

  @override
  String get pollenMugwort => 'artemisa';

  @override
  String get pollenOlive => 'olivo';

  @override
  String get pollenRagweed => 'ambrosía';

  @override
  String get factorUvMax => 'Índice UV, máximo del día';

  @override
  String get factorDaylight => 'Luz del día';

  @override
  String factorDaylightValue(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get factorSun => 'Amanecer y atardecer';

  @override
  String factorSunValue(String sunrise, String sunset) {
    return '$sunrise a $sunset';
  }

  @override
  String get aboutDataTitle => 'Sobre los datos';

  @override
  String get aboutDataIntro =>
      'De dónde salen los números de esta app y qué puede y no puede decirte cada uno.';

  @override
  String get aboutDataSources => 'Fuentes';

  @override
  String aboutDataLicence(String coverage, String licence) {
    return '$coverage. Licencia: $licence.';
  }

  @override
  String get aboutDataPrivacy => 'Qué sale de tu teléfono';

  @override
  String get aboutDataPrivacyBody =>
      'Solo una ubicación redondeada a unos 10 km, para que el servicio del tiempo pueda responder para tu zona. Tus crisis, registros, medicación y datos de salud se quedan en este dispositivo salvo que elijas hacer una copia de seguridad o compartirlos.';

  @override
  String get aboutDataLimits => 'Límites';

  @override
  String get aboutDataLimitsBody =>
      'Los pronósticos son estimaciones de un modelo para una celda de la cuadrícula, no una medición en tu puerta. El polen solo está disponible en Europa. La calidad del aire puede faltar en algunas regiones. Si un factor no tiene datos para tu zona, simplemente no se muestra.';

  @override
  String get settingsHealthHint =>
      'Sueño, frecuencia cardiaca, pasos y ciclo de tu app de salud';

  @override
  String get healthTitle => 'Datos de salud';

  @override
  String healthIntro(String store) {
    return 'Elige qué leer de $store. Cada tipo tiene su propio interruptor y su propio motivo.';
  }

  @override
  String get healthPrivacyNote =>
      'Los datos importados se quedan en este teléfono. Nunca se suben, ni siquiera con la copia de seguridad, salvo que los exportes tú.';

  @override
  String get healthStoreApple => 'Apple Salud';

  @override
  String get healthStoreConnect => 'Health Connect';

  @override
  String healthUnavailable(String store) {
    return '$store no está disponible en este dispositivo.';
  }

  @override
  String get healthReadSection => 'Leer';

  @override
  String get healthTypeSleep => 'Sueño';

  @override
  String get healthReasonSleep =>
      'Rellena la calidad del sueño de tu registro diario a partir de la noche, para que tengas un toque menos.';

  @override
  String get healthTypeRestingHr => 'Frecuencia cardiaca en reposo';

  @override
  String get healthReasonRestingHr =>
      'Una frecuencia en reposo más alta de lo habitual puede reflejar cansancio el día antes de una crisis.';

  @override
  String get healthTypeHrv => 'Variabilidad de la frecuencia cardiaca';

  @override
  String get healthReasonHrv =>
      'Una variabilidad más baja de lo habitual suele ir con estrés y mala recuperación.';

  @override
  String get healthTypeSteps => 'Pasos';

  @override
  String get healthReasonSteps =>
      'Vale la pena ver los días de actividad muy baja o muy alta junto a tus crisis.';

  @override
  String get healthTypeFlow => 'Flujo menstrual';

  @override
  String get healthReasonFlow =>
      'Rellena los inicios del periodo para el seguimiento del ciclo, si lo usas.';

  @override
  String healthDenied(String store) {
    return '$store no concedió acceso. Puedes cambiarlo en sus propios ajustes.';
  }

  @override
  String get healthWriteSection => 'Escribir';

  @override
  String healthWriteHeadaches(String store) {
    return 'Escribir episodios de dolor de cabeza en $store';
  }

  @override
  String get healthWriteHeadachesHint =>
      'Cada crisis terminada se guarda como dolor de cabeza con su inicio, fin e intensidad. No se escribe nada más.';

  @override
  String get healthImportSection => 'Importar';

  @override
  String get healthImportNow => 'Importar ahora';

  @override
  String get healthImportNever => 'Aún no se ha importado nada';

  @override
  String healthImportLast(String age) {
    return '$age';
  }

  @override
  String get healthImportFailed =>
      'La importación no terminó. Inténtalo más tarde.';

  @override
  String healthImportResult(int imported, int prefilled) {
    String _temp0 = intl.Intl.pluralLogic(
      imported,
      locale: localeName,
      other: '$imported muestras nuevas.',
      one: '1 muestra nueva.',
      zero: 'Nada nuevo.',
    );
    String _temp1 = intl.Intl.pluralLogic(
      prefilled,
      locale: localeName,
      other: 'Sueño rellenado para $prefilled días.',
      one: 'Sueño rellenado para 1 día.',
      zero: '',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get checkinSourceHealthkit => 'De Apple Salud';

  @override
  String get checkinSourceHealthConnect => 'De Health Connect';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingFinish => 'Terminar';

  @override
  String onboardingStep(int step, int total) {
    return 'Paso $step de $total';
  }

  @override
  String get onboardingWelcomeTitle => 'Te damos la bienvenida';

  @override
  String get onboardingLocationTitle => 'El tiempo de tu zona';

  @override
  String get onboardingLocationBody =>
      'Los cambios de presión atmosférica son una de las cosas que más gente nota antes de una crisis. Permite una ubicación aproximada o elige una ciudad para verlos.';

  @override
  String get onboardingLocationNone =>
      'Aún no hay ubicación. También puedes elegirla más tarde en la pantalla de entorno.';

  @override
  String get onboardingHealthTitle => 'Datos de salud';

  @override
  String get onboardingHealthBody =>
      'Opcional. Cada tipo tiene su propio interruptor y su propio motivo. Puedes cambiar cualquiera más tarde en Ajustes.';

  @override
  String get onboardingHealthUnavailable =>
      'No hay ninguna app de salud disponible en este dispositivo. Puedes omitir este paso.';

  @override
  String get onboardingReminderTitle => 'Registro diario';

  @override
  String get onboardingReminderBody =>
      'Tres toques al día, unos diez segundos. Elige una hora para el recordatorio.';

  @override
  String get onboardingReminderNote =>
      'Los recordatorios empiezan cuando se configuren las notificaciones. Puedes cambiar la hora cualquier día desde el registro.';

  @override
  String get explainerTitle => 'Qué significa el nivel';

  @override
  String get explainerIntro =>
      'Cada día la app muestra un nivel basado en tu propio historial y en las condiciones de hoy.';

  @override
  String get explainerDoesTitle => 'Qué hace';

  @override
  String get explainerDoes1 =>
      'Muestra cómo se comparan el tiempo, el sueño, el estrés y la rutina de hoy con los días previos a tus crisis anteriores.';

  @override
  String get explainerDoes2 =>
      'Aprende de tu propio registro, así que se vuelve más específico cuanto más anotas.';

  @override
  String get explainerDoes3 =>
      'Te ayuda a decidir si hoy es un día para tomártelo con más calma.';

  @override
  String get explainerDoesNotTitle => 'Qué no hace';

  @override
  String get explainerDoesNot1 =>
      'No anuncia una crisis. Un nivel alto es un patrón, no una certeza, y un nivel bajo no es una promesa.';

  @override
  String get explainerDoesNot2 =>
      'No es una opinión médica ni sustituye a tu profesional sanitario.';

  @override
  String get explainerDoesNot3 =>
      'Nunca envía tu registro a ninguna parte. El nivel se calcula en este teléfono.';

  @override
  String get riskCardTitle => 'Nivel de hoy';

  @override
  String get riskCardEmpty =>
      'Aún no hay nivel. Añade un registro o deja que se cargue el tiempo.';

  @override
  String get riskScreenTitle => 'Tu nivel';

  @override
  String get riskWhyTitle => 'Por qué';

  @override
  String get riskNoDrivers => 'Nada destaca.';

  @override
  String get riskNextDays => 'Próximos días';

  @override
  String get riskDayToday => 'Hoy';

  @override
  String get riskDayTomorrow => 'Mañana';

  @override
  String riskLoad(String value) {
    return 'Carga $value de 100';
  }

  @override
  String riskConfidence(String label) {
    return 'Confianza: $label';
  }

  @override
  String get riskConfidenceLow => 'baja';

  @override
  String get riskConfidenceMedium => 'media';

  @override
  String get riskConfidenceHigh => 'alta';

  @override
  String riskStillLearning(int count, int needed) {
    return 'Aún aprendiendo: $count de $needed crisis registradas';
  }

  @override
  String get riskTuned => 'Ajustado a tu registro';

  @override
  String riskDriverPoints(String points) {
    return '$points puntos';
  }

  @override
  String riskUpdated(String time) {
    return 'Actualizado $time';
  }

  @override
  String get riskExplainerLink => 'Qué significa el nivel';

  @override
  String get riskOpenCheckin => 'Añadir el registro de hoy';

  @override
  String get riskFactorPressureDrop => 'Bajada de la presión atmosférica';

  @override
  String get riskFactorHumidity => 'Humedad alta';

  @override
  String get riskFactorTemperatureSwing => 'Cambio de temperatura';

  @override
  String get riskFactorAirQuality => 'Calidad del aire';

  @override
  String get riskFactorPollen => 'Polen';

  @override
  String get riskFactorBrightLight => 'Luz intensa';

  @override
  String get riskFactorScreenTime => 'Tiempo de pantalla';

  @override
  String get riskFactorPoorSleep => 'Mal sueño';

  @override
  String get riskFactorStress => 'Estrés';

  @override
  String get riskFactorNeckTension => 'Tensión en el cuello';

  @override
  String get riskFactorCaffeine => 'Cafeína';

  @override
  String get riskFactorAlcohol => 'Alcohol';

  @override
  String get riskFactorDehydration => 'Poca hidratación';

  @override
  String get riskFactorCyclePhase => 'Fase del ciclo';

  @override
  String get loadMeterTitle => 'Carga';

  @override
  String loadMeterSemantics(String value, String segments) {
    return 'Carga $value de 100. $segments';
  }

  @override
  String loadSegmentDetail(String name, String points) {
    return '$name: $points puntos';
  }

  @override
  String loadThresholdModerate(String value) {
    return 'Moderado desde $value';
  }

  @override
  String loadThresholdHigh(String value) {
    return 'Alto desde $value';
  }

  @override
  String get loadMeterEmpty => 'Aún no hay carga';

  @override
  String get insightsTitle => 'Tus factores';

  @override
  String get insightsIntro =>
      'Con qué frecuencia siguió una crisis a cada factor en tu propio registro, comparado con tu ritmo habitual.';

  @override
  String get insightsTriggers => 'Siguieron más crisis';

  @override
  String get insightsProtectors => 'Siguieron menos crisis';

  @override
  String get insightsNeutral => 'Sin efecto claro';

  @override
  String get insightsNotEnough => 'Aún no hay datos suficientes';

  @override
  String get insightsEmptyBucket => 'Aún no hay nada aquí.';

  @override
  String insightsSample(int days, int attacks) {
    return '$days días de exposición, $attacks seguidos de una crisis';
  }

  @override
  String insightsLift(String ratio) {
    return '$ratio× tu ritmo habitual';
  }

  @override
  String insightsNeedMore(int days, int needed) {
    return '$days de $needed días de exposición registrados';
  }

  @override
  String get insightsNoRunYet =>
      'Registra y termina una crisis para empezar a contar.';

  @override
  String get insightsMethodLink => 'Cómo se cuenta';

  @override
  String get insightsMethodTitle => 'Cómo se cuenta';

  @override
  String insightsMethod1(String pressure) {
    return 'Un día de exposición es un día en el que un factor estuvo presente en tu registro o en el tiempo, por ejemplo una respuesta de sueño de 1 o una bajada de presión de más de $pressure.';
  }

  @override
  String get insightsMethod2 =>
      'Una crisis cuenta como posterior a un día cuando empezó ese día o el siguiente, las 24 a 48 horas que mira el modelo.';

  @override
  String get insightsMethod3 =>
      'La proporción compara con qué frecuencia siguieron crisis a los días de ese factor con la frecuencia tras cualquier día de tu registro. 1,5× significa una vez y media tu ritmo habitual; 0,5×, la mitad.';

  @override
  String insightsMethod4(int needed) {
    return 'Un factor necesita $needed días de exposición antes de clasificarse. Hasta entonces queda en «Aún no hay datos suficientes». Saber que tras un factor siguen menos crisis es tan útil como saber que siguen más, por eso ambas listas tienen el mismo lugar.';
  }

  @override
  String get insightsMethod5 =>
      'Nada de esto es una causa. Un factor puede aparecer en una lista por algo que va con él, como los fines de semana o un cambio de medicación. Usa las listas para decidir qué probar, no a qué culpar.';

  @override
  String get riskInsightsLink => 'Tus factores';

  @override
  String get settingsInsightsHint =>
      'Qué factores precedieron a las crisis en tu registro';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get settingsNotificationsHint =>
      'Avisos de nivel, bajadas de presión, recordatorios';

  @override
  String get notificationsIntro =>
      'Todo se programa en este teléfono a partir del pronóstico guardado y de tu registro. Desactiva cualquier tipo que no quieras.';

  @override
  String get notificationsPermissionDenied =>
      'Las notificaciones de esta app están desactivadas en los ajustes del sistema.';

  @override
  String get notifTypeRiskRising => 'Nivel en aumento';

  @override
  String get notifTypeRiskRisingHint =>
      'La tarde anterior y la mañana de un día con nivel más alto';

  @override
  String get notifTypePressureDrop => 'Bajada de presión';

  @override
  String notifTypePressureDropHint(String pressure) {
    return 'Cuando el pronóstico muestra una bajada de $pressure o más en 24 horas';
  }

  @override
  String get notifTypeAttackOver => '¿Ha terminado tu crisis?';

  @override
  String get notifTypeAttackOverHint =>
      'A la duración habitual de tus crisis, con un botón Terminar';

  @override
  String get notifTypeCheckin => 'Recordatorio del registro';

  @override
  String get notifTypeCheckinHint => 'A la hora elegida en Diario';

  @override
  String get notifTypeMedication => 'Recordatorio preventivo';

  @override
  String get notifTypeMedicationHint =>
      'Un aviso diario para una dosis preventiva';

  @override
  String notifPressureThreshold(String pressure) {
    return 'Umbral de bajada de presión: $pressure en 24 h';
  }

  @override
  String get notifMedicationTime => 'Hora del recordatorio preventivo';

  @override
  String notifRiskEveningTitle(String level) {
    return 'Nivel de mañana: $level';
  }

  @override
  String notifRiskEveningBody(String level, String driver) {
    return 'Tu nivel para mañana es $level. Lo primero de la lista: $driver.';
  }

  @override
  String notifRiskMorningTitle(String level) {
    return 'Nivel de hoy: $level';
  }

  @override
  String notifRiskMorningBody(String level, String driver) {
    return 'Tu nivel de hoy es $level. Lo primero de la lista: $driver.';
  }

  @override
  String get notifPressureTitle => 'La presión atmosférica está bajando';

  @override
  String notifPressureBody(String pressure, String time) {
    return 'Se espera una bajada de $pressure para las $time.';
  }

  @override
  String get notifAttackOverTitle => '¿Ha terminado tu crisis?';

  @override
  String notifAttackOverBody(String duration) {
    return 'Empezó hace $duration. Termínala aquí cuando haya pasado.';
  }

  @override
  String get notifEndAttackAction => 'Terminar crisis';

  @override
  String get notifCheckinTitle => 'Tres toques por hoy';

  @override
  String get notifCheckinBody =>
      'Sueño, estrés y tensión en el cuello. Quince segundos.';

  @override
  String get notifMedicationTitle => 'Dosis preventiva';

  @override
  String get notifMedicationBody =>
      'Es la hora de tu medicación preventiva de hoy, si tomas alguna.';

  @override
  String get notifChannelAlerts => 'Avisos';

  @override
  String get notifChannelAlertsDescription =>
      'Avisos de nivel y presión a partir del pronóstico guardado';

  @override
  String get notifChannelReminders => 'Recordatorios';

  @override
  String get notifChannelRemindersDescription =>
      'Recordatorios del registro y de la dosis preventiva';

  @override
  String get notifChannelAttack => 'Crisis';

  @override
  String get notifChannelAttackDescription =>
      'Preguntas sobre una crisis en curso';

  @override
  String get reportTitle => 'Informe para el médico';

  @override
  String get settingsReportHint => 'PDF y hoja de cálculo para un periodo';

  @override
  String get reportIntro =>
      'Un resumen de lo que registraste, para tu próxima cita. Elige un periodo y comparte el PDF o las hojas de cálculo.';

  @override
  String get reportRangeLabel => 'Periodo';

  @override
  String reportRangeDays(int days) {
    return '$days días';
  }

  @override
  String get reportRangeCustom => 'Personalizado';

  @override
  String reportRangeText(String from, String to) {
    return 'Del $from al $to';
  }

  @override
  String reportPreviewAttacks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count crisis',
      one: '1 crisis',
      zero: 'Sin crisis',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewAttackDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días con crisis',
      one: '1 día con crisis',
      zero: 'ningún día con crisis',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewDoses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dosis',
      one: '1 dosis',
      zero: 'ninguna dosis',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewCheckins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros',
      one: '1 registro',
      zero: 'ningún registro',
    );
    return '$_temp0';
  }

  @override
  String get reportEmpty => 'Aún no hay nada registrado en este periodo.';

  @override
  String get reportSharePdf => 'Compartir PDF';

  @override
  String get reportShareCsv => 'Compartir hojas de cálculo';

  @override
  String get reportShareAll => 'Compartir todo';

  @override
  String get reportBuilding => 'Preparando el informe';

  @override
  String get reportFailed =>
      'No se pudo preparar el informe. Inténtalo de nuevo.';

  @override
  String get reportWhatIsIn => 'Qué contiene el PDF';

  @override
  String get reportContents =>
      'Calendario de crisis, recuentos mensuales, duración, factores con sus tamaños de muestra, días de medicación, cambios de presión, síntomas y zonas de la cabeza. Sin nombres ni notas.';

  @override
  String reportPdfTitle(String app) {
    return 'Informe de $app';
  }

  @override
  String reportPdfPeriod(String from, String to, int days) {
    return 'Periodo: del $from al $to ($days días)';
  }

  @override
  String reportPdfGenerated(String date) {
    return 'Generado el $date en el dispositivo de la persona a partir de su propio registro.';
  }

  @override
  String get reportPdfDisclaimer =>
      'Este es un resumen de un diario autorregistrado en una app de bienestar. No es una historia clínica y no sustituye una valoración clínica. Las proporciones de factores describen solo el registro de esta persona y no son causas.';

  @override
  String reportPdfPage(int page, int pages) {
    return 'Página $page de $pages';
  }

  @override
  String get reportSectionOverview => 'Resumen';

  @override
  String get reportStatAttacks => 'Crisis';

  @override
  String get reportStatAttackDays => 'Días con crisis';

  @override
  String get reportStatPerMonth => 'Crisis cada 30 días';

  @override
  String get reportStatMeanIntensity => 'Intensidad media (0-10)';

  @override
  String get reportStatAcuteDays => 'Días con medicación aguda';

  @override
  String get reportStatCheckins => 'Días con registro';

  @override
  String get reportSectionMonths => 'Por mes';

  @override
  String get reportColMonth => 'Mes';

  @override
  String get reportColAttacks => 'Crisis';

  @override
  String get reportColAttackDays => 'Días con crisis';

  @override
  String get reportColMeanIntensity => 'Intensidad media';

  @override
  String get reportColAcuteDays => 'Días agudos';

  @override
  String get reportColNote => 'Nota';

  @override
  String get reportOveruseWatch => '10+ días agudos';

  @override
  String get reportOveruseHigh => '15+ días agudos';

  @override
  String get reportSectionCalendar => 'Calendario de crisis';

  @override
  String get reportCalendarHint =>
      'Una celda por día. Las celdas sombreadas tuvieron una crisis; el número es la intensidad más alta de ese día.';

  @override
  String get reportSectionDuration => 'Duración de las crisis';

  @override
  String get reportDurationNone => 'No hay crisis terminadas en este periodo.';

  @override
  String reportDurationSummary(
    int count,
    String shortest,
    String median,
    String longest,
  ) {
    return '$count crisis terminadas. La más corta $shortest, mediana $median, la más larga $longest.';
  }

  @override
  String get reportBucketUnderFour => 'Menos de 4 h';

  @override
  String get reportBucketFourToTwelve => 'De 4 a 12 h';

  @override
  String get reportBucketTwelveToDay => 'De 12 a 24 h';

  @override
  String get reportBucketOneToThreeDays => 'De 1 a 3 días';

  @override
  String get reportBucketOverThreeDays => 'Más de 3 días';

  @override
  String get reportSectionTriggers => 'Factores en el registro de la persona';

  @override
  String reportTriggersHint(int floor) {
    return 'Proporción de crisis tras días con el factor respecto al ritmo habitual de la persona, con el número de días de exposición que la respaldan. Por debajo de $floor días de exposición no se muestra la proporción.';
  }

  @override
  String get reportTriggersNone =>
      'Aún no hay suficientes días registrados para comparar factores.';

  @override
  String get reportColFactor => 'Factor';

  @override
  String get reportColRatio => 'Proporción';

  @override
  String get reportColExposures => 'Días de exposición';

  @override
  String get reportColFollowed => 'Seguidos de crisis';

  @override
  String get reportColConfidence => 'Evidencia';

  @override
  String get reportConfidenceLow => 'baja';

  @override
  String get reportConfidenceMedium => 'moderada';

  @override
  String get reportConfidenceHigh => 'buena';

  @override
  String get reportSectionMedications => 'Medicación';

  @override
  String get reportMedicationsNone =>
      'No hay dosis registradas en este periodo.';

  @override
  String get reportColMedication => 'Medicamento';

  @override
  String get reportColKind => 'Tipo';

  @override
  String get reportColDoses => 'Dosis';

  @override
  String get reportColDays => 'Días';

  @override
  String get reportColRelief => 'Alivio a las 2 h (ninguno / parcial / total)';

  @override
  String get reportKindAcute => 'aguda';

  @override
  String get reportKindPreventive => 'preventiva';

  @override
  String get reportSectionWeather => 'Presión atmosférica';

  @override
  String reportWeatherHint(String pressure) {
    return 'Una bajada es un descenso de $pressure o más en 24 h en el momento del registro.';
  }

  @override
  String get reportWeatherNone => 'No hay datos del tiempo en este periodo.';

  @override
  String reportWeatherAttacks(int fall, int total) {
    return '$fall de $total crisis empezaron tras una bajada de presión.';
  }

  @override
  String reportWeatherDays(int fall, int total) {
    return '$fall de $total días con registro tuvieron una.';
  }

  @override
  String reportWeatherLift(String lift) {
    return 'Proporción: ${lift}x (1,0 significa sin relación).';
  }

  @override
  String get reportSectionSymptoms => 'Síntomas y zonas de la cabeza';

  @override
  String get reportSymptomsNone => 'No hay síntomas ni zonas registrados.';

  @override
  String reportCountOfAttacks(String name, int count, int total) {
    return '$name: $count de $total crisis';
  }

  @override
  String reportHoursShort(String hours) {
    return '$hours h';
  }

  @override
  String get notifTypeQuestionnaire => 'Cuestionarios trimestrales';

  @override
  String get notifTypeQuestionnaireHint =>
      'MIDAS y HIT-6, tres meses después de la última vez';

  @override
  String get notifQuestionnaireTitle =>
      'Han pasado tres meses desde tus últimos cuestionarios';

  @override
  String get notifQuestionnaireBody =>
      'Vuelve a rellenar MIDAS y HIT-6 para ver cómo se compara el último trimestre.';

  @override
  String get questionnairesTitle => 'Cuestionarios';

  @override
  String get settingsQuestionnairesHint =>
      'MIDAS y HIT-6, puntuados y en gráfico';

  @override
  String get questionnairesIntro =>
      'Dos cuestionarios breves y validados sobre los últimos tres meses. Repítelos cada trimestre: las puntuaciones se muestran aquí en un gráfico y pueden incluirse en el informe para el médico.';

  @override
  String get questionnaireMidasTitle => 'MIDAS';

  @override
  String get questionnaireMidasSubtitle =>
      'Migraine Disability Assessment: cinco recuentos de días de los últimos tres meses';

  @override
  String get questionnaireHit6Title => 'HIT-6';

  @override
  String get questionnaireHit6Subtitle =>
      'Headache Impact Test: seis preguntas sobre cómo afectan los dolores de cabeza a tu vida';

  @override
  String get questionnaireNeverDone => 'Aún sin rellenar';

  @override
  String questionnaireLatest(int score, String date) {
    return 'Última puntuación $score el $date';
  }

  @override
  String get questionnaireDueNow => 'Toca ahora';

  @override
  String questionnaireDueOn(String date) {
    return 'Próxima vez $date';
  }

  @override
  String get questionnaireStart => 'Rellenar';

  @override
  String get questionnaireRepeat => 'Rellenar de nuevo';

  @override
  String get questionnaireHistory => 'Historial de puntuaciones';

  @override
  String questionnaireChartLabel(
    int count,
    String first,
    String last,
    int latest,
  ) {
    return '$count puntuaciones del $first al $last, la última $latest';
  }

  @override
  String get questionnaireAbout => 'Sobre las puntuaciones';

  @override
  String get questionnaireAboutBody =>
      'MIDAS suma cinco recuentos de días: de 0 a 5 es grado I (poca o ninguna discapacidad), de 6 a 10 grado II (leve), de 11 a 20 grado III (moderada), 21 o más grado IV (grave). HIT-6 da 6, 8, 10, 11 o 13 puntos por respuesta, de 36 a 78 en total: hasta 49 es poco o ningún impacto, de 50 a 55 algo de impacto, de 56 a 59 impacto considerable, 60 o más impacto grave. Las franjas son las publicadas; las puntuaciones son para que las comentéis tú y tu profesional sanitario.';

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
  String get questionnaireMidasUnscored => 'No forma parte de la puntuación';

  @override
  String get questionnaireDaysField => 'Días (0 a 90)';

  @override
  String get questionnairePainField => 'Dolor (0 a 10)';

  @override
  String questionnaireDaysError(int max) {
    return 'Introduce un número de 0 a $max';
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
  String get questionnaireSave => 'Guardar y puntuar';

  @override
  String get questionnaireIncomplete =>
      'Responde todas las preguntas puntuadas para guardar.';

  @override
  String questionnaireResultTitle(int score) {
    return 'Tu puntuación: $score';
  }

  @override
  String get questionnaireResultDone => 'Listo';

  @override
  String get questionnaireResultDisclaimer =>
      'Una puntuación describe los últimos tres meses tal como los recuerdas. Es un punto de partida para hablar con tu profesional sanitario, no una valoración médica.';

  @override
  String get questionnaireMidasBandMinimal =>
      'Grado I: poca o ninguna discapacidad';

  @override
  String get questionnaireMidasBandMild => 'Grado II: discapacidad leve';

  @override
  String get questionnaireMidasBandModerate =>
      'Grado III: discapacidad moderada';

  @override
  String get questionnaireMidasBandSevere => 'Grado IV: discapacidad grave';

  @override
  String get questionnaireHit6BandMinimal => 'Poco o ningún impacto';

  @override
  String get questionnaireHit6BandMild => 'Algo de impacto';

  @override
  String get questionnaireHit6BandModerate => 'Impacto considerable';

  @override
  String get questionnaireHit6BandSevere => 'Impacto grave';

  @override
  String get reportIncludeQuestionnaires =>
      'Incluir puntuaciones de cuestionarios';

  @override
  String get reportIncludeQuestionnairesHint =>
      'Rondas de MIDAS y HIT-6 completadas en el periodo';

  @override
  String get reportSectionQuestionnaires => 'Cuestionarios';

  @override
  String get reportQuestionnairesNone =>
      'No se completaron cuestionarios en este periodo.';

  @override
  String get reportColDate => 'Fecha';

  @override
  String get reportColQuestionnaire => 'Cuestionario';

  @override
  String get reportColScore => 'Puntuación';

  @override
  String get reportColBand => 'Franja';

  @override
  String get voiceButton => 'Registrar por voz';

  @override
  String get voiceListening => 'Escuchando';

  @override
  String get voiceListeningHint =>
      'Di cómo te sientes, por ejemplo: dolor siete de diez, detrás de los ojos, náuseas, tomé ibuprofeno.';

  @override
  String get voiceStop => 'He terminado';

  @override
  String get voiceCancel => 'Cancelar';

  @override
  String get voiceTryAgain => 'Intentar de nuevo';

  @override
  String get voiceUnavailable =>
      'La voz no está disponible en este teléfono. El reconocimiento de voz necesita permiso del micrófono y un paquete de voz sin conexión para tu idioma.';

  @override
  String get voiceNoMatch =>
      'No se oyó nada. Inténtalo de nuevo más cerca del teléfono o toca los campos.';

  @override
  String get voiceReviewTitle => 'Revisa antes de guardar';

  @override
  String voiceHeard(String text) {
    return 'Se oyó: «$text»';
  }

  @override
  String get voiceNothingUnderstood =>
      'Nada de lo dicho coincidió con el formulario. Toca los campos o inténtalo de nuevo.';

  @override
  String get voiceIntensity => 'Intensidad';

  @override
  String get voiceIntensityNone => 'No se dijo';

  @override
  String get voiceSymptoms => 'Síntomas';

  @override
  String get voiceLocations => 'Dónde duele';

  @override
  String get voiceMedications => 'Medicación tomada ahora';

  @override
  String get voiceSave => 'Guardar en la crisis';

  @override
  String widgetLevel(String level) {
    return 'Nivel: $level';
  }

  @override
  String get widgetNoLevel => 'Abre la app para cargar el nivel de hoy';

  @override
  String widgetDriver(String factor) {
    return 'Factor principal: $factor';
  }

  @override
  String get widgetNoDriver => 'Ningún factor destaca';

  @override
  String widgetPressureFalling(String pressure) {
    return 'Presión bajando $pressure en 24 h';
  }

  @override
  String widgetPressureRising(String pressure) {
    return 'Presión subiendo $pressure en 24 h';
  }

  @override
  String get widgetPressureSteady => 'Presión estable';

  @override
  String get widgetPressureUnknown => 'Aún no hay pronóstico de presión';

  @override
  String widgetUpdated(String time) {
    return 'Actualizado $time';
  }

  @override
  String get widgetStartAttack => 'Iniciar crisis';

  @override
  String get widgetOpenAttack => 'Abrir crisis';

  @override
  String get watchStart => 'Iniciar crisis';

  @override
  String get watchStop => 'Terminar crisis';

  @override
  String get watchIntensity => 'Intensidad';

  @override
  String watchSince(String time) {
    return 'Desde las $time';
  }

  @override
  String get watchPending =>
      'Guardado en el reloj. Se envía cuando el teléfono esté cerca.';

  @override
  String get watchNoPhone =>
      'Abre la app en tu teléfono una vez para conectar el reloj.';

  @override
  String get routinesTitle => 'Rutinas de autocuidado';

  @override
  String get routinesIntro =>
      'Cosas sencillas que a mucha gente le ayudan en los días difíciles. Usa lo que te venga bien y omite el resto.';

  @override
  String get routineCardTitle => 'Algo que puede ayudarte hoy';

  @override
  String get routineNotToday => 'Hoy no';

  @override
  String get routineSeeAll => 'Todas las rutinas';

  @override
  String get routineStepsTitle => 'Cómo hacerlo';

  @override
  String get routineReasonHighDay => 'El nivel de hoy es alto';

  @override
  String get routineReasonNeckTension =>
      'Tu registro muestra tensión en el cuello';

  @override
  String get routineReasonStress => 'Tu registro muestra mucho estrés';

  @override
  String get routineStretchesTitle =>
      'Estiramientos suaves de cuello y hombros';

  @override
  String get routineStretchesSummary =>
      'Cinco movimientos lentos para aliviar la tensión del cuello y los hombros. Para si algo duele.';

  @override
  String get routineStretchesSteps =>
      'Siéntate recto con los hombros relajados y los pies apoyados.\nInclina despacio la oreja derecha hacia el hombro derecho. Mantén 15 segundos y cambia de lado.\nBaja la barbilla hacia el pecho y mantén 15 segundos.\nGira los hombros hacia atrás cinco veces y luego hacia delante cinco veces.\nEntrelaza las manos detrás de la espalda y abre el pecho con suavidad durante 15 segundos.';

  @override
  String get routineBreathingTitle => 'Respiración pausada';

  @override
  String get routineBreathingSummary =>
      'Inspira durante 4 segundos y espira durante 6, durante un minuto aproximadamente. Una espiración lenta ayuda a mucha gente a calmarse.';

  @override
  String get routineBreathingSteps =>
      'Siéntate o túmbate en un lugar cómodo.\nInspira por la nariz mientras el círculo crece.\nEspira despacio mientras se encoge.\nSigue durante seis rondas, o mientras te sientas bien.';

  @override
  String get routineLowLightTitle => 'Poca luz y silencio';

  @override
  String get routineLowLightSummary =>
      'La luz intensa y el ruido molestan a mucha gente en los días sensibles y durante una crisis.';

  @override
  String get routineLowLightSteps =>
      'Baja las luces o cierra las cortinas.\nActiva el modo oscuro y baja el brillo de la pantalla.\nUsa un antifaz o gafas de sol si la luz sigue molestando.\nReduce el ruido con tapones o una habitación tranquila.';

  @override
  String get routineHydrationTitle => 'Bebe un poco de agua';

  @override
  String get routineHydrationSummary =>
      'Tener agua a mano hace más fácil beber a lo largo del día.';

  @override
  String get routineHydrationSteps =>
      'Ten un vaso o una botella de agua a mano.\nToma unos sorbos cada hora.\nBebe un vaso de agua con cada comida.';

  @override
  String get routineCaffeineTitle => 'Mantén estable la cafeína';

  @override
  String get routineCaffeineSummary =>
      'Los cambios grandes en la cantidad de cafeína pueden importar a algunas personas.';

  @override
  String get routineCaffeineSteps =>
      'Toma la cafeína más o menos a las mismas horas cada día.\nEvita aumentos grandes y evita saltarte de golpe tu cantidad habitual.\nToma tu última bebida con cafeína a primera hora de la tarde.';

  @override
  String get routineSleepTitle => 'Sueño regular';

  @override
  String get routineSleepSummary =>
      'Un horario de sueño regular, también los fines de semana, ayuda a mucha gente.';

  @override
  String get routineSleepSteps =>
      'Acuéstate y levántate más o menos a la misma hora todos los días.\nMantén el dormitorio oscuro, silencioso y fresco.\nDeja las pantallas 30 minutos antes de dormir.\nEvita las siestas largas al final del día.';

  @override
  String get breathingStart => 'Empezar a respirar';

  @override
  String get breathingStop => 'Parar';

  @override
  String get breathingIn => 'Inspira';

  @override
  String get breathingOut => 'Espira';

  @override
  String breathingRound(int round, int total) {
    return 'Ronda $round de $total';
  }

  @override
  String get breathingDone => 'Listo. Tómate un momento antes de levantarte.';

  @override
  String get settingsRoutinesHint =>
      'Estiramientos, respiración y otras rutinas sencillas';

  @override
  String get experimentsTitle => 'Experimentos';

  @override
  String get settingsExperimentsHint =>
      'Prueba un cambio durante dos semanas y compara';

  @override
  String get experimentsIntro =>
      'Prueba un cambio durante dos semanas y compáralo con las dos semanas anteriores. Un experimento cada vez.';

  @override
  String get experimentsPick => 'Elige un cambio';

  @override
  String get experimentChangeCutCaffeine => 'Reducir la cafeína';

  @override
  String get experimentChangeRegularSleep =>
      'Acostarte a la misma hora cada noche';

  @override
  String get experimentChangeMoreWater => 'Beber más agua';

  @override
  String get experimentChangeDailyStretches => 'Estirar el cuello cada día';

  @override
  String get experimentChangeLessScreens => 'Menos pantallas por la noche';

  @override
  String get experimentChangeNoAlcohol => 'No beber alcohol';

  @override
  String experimentDay(int day, int total) {
    return 'Día $day de $total';
  }

  @override
  String get experimentAdherenceQuestion => '¿Lo has cumplido hoy?';

  @override
  String get experimentYes => 'Sí';

  @override
  String get experimentNo => 'No';

  @override
  String experimentAdherence(int kept, int days) {
    return 'Cumplido $kept de $days días';
  }

  @override
  String get experimentCompareTitle => 'Dos semanas antes y durante';

  @override
  String get experimentBefore => 'Antes';

  @override
  String get experimentDuring => 'Durante';

  @override
  String get experimentRowRate => 'Crisis por semana';

  @override
  String get experimentRowIntensity => 'Intensidad media';

  @override
  String get experimentRowDuration => 'Duración mediana';

  @override
  String experimentSample(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'de $count crisis',
      one: 'de 1 crisis',
      zero: 'sin crisis',
    );
    return '$_temp0';
  }

  @override
  String experimentDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get experimentNoData => 'Sin datos';

  @override
  String get experimentCaveat =>
      'Dos semanas es poco tiempo. El tiempo, las estaciones y el estrés cambian por sí solos, así que tómalo como una pista, no como una prueba.';

  @override
  String experimentSmallSample(int min) {
    return 'Menos de $min crisis en uno de los periodos, así que las cifras pueden variar mucho.';
  }

  @override
  String get experimentStop => 'Parar el experimento';

  @override
  String get experimentFinish => 'Terminar y guardar el resultado';

  @override
  String get experimentDue => 'Las dos semanas han terminado.';

  @override
  String get experimentPast => 'Experimentos anteriores';

  @override
  String experimentFinished(String date) {
    return 'Terminado el $date';
  }

  @override
  String experimentStopped(String date) {
    return 'Parado el $date';
  }

  @override
  String experimentPastSummary(String before, String during) {
    return '$before crisis por semana antes, $during durante';
  }

  @override
  String get accountTitle => 'Cuenta';

  @override
  String get settingsAccountHint =>
      'Opcional. Solo hace falta para la copia de seguridad y los enlaces';

  @override
  String get accountIntro =>
      'La cuenta es opcional. Todo en la app funciona sin ella y tus datos se quedan en este teléfono. Solo la necesitas para la copia de seguridad cifrada y los enlaces para compartir.';

  @override
  String get accountUnavailable =>
      'Las cuentas no están configuradas en esta versión.';

  @override
  String get accountApple => 'Continuar con Apple';

  @override
  String get accountGoogle => 'Continuar con Google';

  @override
  String get accountOrEmail => 'O usa tu correo electrónico';

  @override
  String get accountEmail => 'Correo electrónico';

  @override
  String get accountPassword => 'Contraseña';

  @override
  String accountPasswordHint(int min) {
    return 'Al menos $min caracteres para una cuenta nueva';
  }

  @override
  String get accountSignIn => 'Iniciar sesión';

  @override
  String get accountCreate => 'Crear cuenta';

  @override
  String get accountForgot => '¿Has olvidado la contraseña?';

  @override
  String get accountResetSent =>
      'Si ese correo tiene una cuenta, te llegará un enlace para restablecerla.';

  @override
  String accountSignedInAs(String email) {
    return 'Sesión iniciada como $email';
  }

  @override
  String accountSignedInWith(String method) {
    return 'Sesión iniciada con $method';
  }

  @override
  String get accountMethodApple => 'Apple';

  @override
  String get accountMethodGoogle => 'Google';

  @override
  String get accountMethodEmail => 'correo electrónico';

  @override
  String get accountSignedInNote =>
      'Tus datos siguen en este teléfono. Cerrar sesión no borra nada.';

  @override
  String get accountSignOut => 'Cerrar sesión';

  @override
  String get accountDelete => 'Eliminar cuenta';

  @override
  String get accountDeleteTitle => '¿Eliminar tu cuenta?';

  @override
  String accountDeleteBody(int hours) {
    return 'Esto elimina tu cuenta. En un plazo de $hours horas se borran de nuestros servidores tu copia cifrada y los enlaces compartidos. Todo lo que hay en este teléfono se queda.';
  }

  @override
  String get accountDeletePassword => 'Introduce tu contraseña para confirmar';

  @override
  String get accountDeleteSubscription =>
      'La suscripción Premium la cobra App Store o Google Play. Eliminar la cuenta no la cancela; cancélala en la tienda.';

  @override
  String get accountDeleteCancel => 'Conservar la cuenta';

  @override
  String accountDeleted(int hours) {
    return 'Cuenta eliminada. Sus datos del servidor desaparecerán en un plazo de $hours horas.';
  }

  @override
  String get accountErrorWrongCredentials =>
      'El correo y la contraseña no coinciden.';

  @override
  String get accountErrorEmailInUse =>
      'Ese correo ya tiene una cuenta. Prueba a iniciar sesión.';

  @override
  String get accountErrorWeakPassword => 'Elige una contraseña más larga.';

  @override
  String get accountErrorInvalidEmail => 'Revisa la dirección de correo.';

  @override
  String get accountErrorNetwork =>
      'Sin conexión. Inténtalo cuando estés en línea.';

  @override
  String get accountErrorRecentSignIn =>
      'Por tu seguridad, vuelve a iniciar sesión y prueba otra vez.';

  @override
  String get accountErrorUnknown => 'Algo ha fallado. Inténtalo de nuevo.';

  @override
  String get backupTitle => 'Copia de seguridad cifrada';

  @override
  String get settingsBackupHint =>
      'Protegida con una frase de contraseña que solo tú conoces';

  @override
  String get backupIntro =>
      'Tu copia se cifra en este teléfono con tu frase de contraseña antes de subirla. Solo guardamos el archivo cifrado y no podemos abrirlo.';

  @override
  String get backupForgetWarning =>
      'Si olvidas la frase de contraseña, nadie podrá abrir la copia, ni siquiera nosotros. Anótala en un lugar seguro.';

  @override
  String get backupNeedsAccount =>
      'La copia de seguridad necesita una cuenta. Todo lo demás funciona sin ella.';

  @override
  String get backupOpenAccount => 'Crear una cuenta';

  @override
  String get backupNone => 'Aún no hay copia';

  @override
  String backupLast(String date) {
    return 'Última copia: $date';
  }

  @override
  String get backupStatusUnknown =>
      'No se pudo comprobar la copia ahora mismo.';

  @override
  String get backupPassphrase => 'Frase de contraseña';

  @override
  String backupPassphraseHint(int min) {
    return 'Al menos $min caracteres. Unas cuantas palabras sin relación funcionan bien.';
  }

  @override
  String get backupPassphraseRepeat =>
      'Repite la frase de contraseña para hacer la copia';

  @override
  String get backupNow => 'Hacer copia ahora';

  @override
  String get backupDone => 'Copia hecha.';

  @override
  String get backupRestore => 'Restaurar desde la copia';

  @override
  String get backupRestoreTitle => '¿Sustituir todo lo de este teléfono?';

  @override
  String backupRestoreBody(String date) {
    return 'Todo lo de este teléfono se sustituye por la copia del $date.';
  }

  @override
  String get backupRestoreConfirm => 'Restaurar';

  @override
  String get backupRestored => 'Restaurado desde tu copia.';

  @override
  String get backupDelete => 'Eliminar copia';

  @override
  String get backupDeleteTitle => '¿Eliminar la copia?';

  @override
  String get backupDeleteBody =>
      'El archivo cifrado se borra de nuestros servidores. Todo lo que hay en este teléfono se queda.';

  @override
  String get backupDeleted => 'Copia eliminada.';

  @override
  String get backupWorking => 'En ello. Puede tardar unos segundos.';

  @override
  String get backupErrorMismatch =>
      'Las dos frases de contraseña no coinciden.';

  @override
  String backupErrorShort(int min) {
    return 'Usa al menos $min caracteres.';
  }

  @override
  String get backupErrorNoBackup => 'Aún no hay ninguna copia en esta cuenta.';

  @override
  String get backupErrorTooLarge =>
      'La copia es demasiado grande para subirla.';

  @override
  String get backupErrorNewerApp =>
      'Esta copia se hizo con una versión más reciente de la app. Actualiza la app e inténtalo de nuevo.';

  @override
  String get backupErrorWrongPassphrase =>
      'Esa frase de contraseña no abre esta copia.';

  @override
  String get backupErrorDamaged => 'El archivo de la copia está dañado.';

  @override
  String get backupErrorPinning =>
      'No se pudo verificar la conexión con el servidor de copias, así que no se envió nada. Prueba con otra red.';

  @override
  String get backupErrorNotAllowed =>
      'Tu sesión ha caducado. Vuelve a iniciar sesión e inténtalo de nuevo.';

  @override
  String get shareLinkButton => 'Compartir como enlace web';

  @override
  String get shareLinkTitle => 'Compartir con tu profesional sanitario';

  @override
  String get shareLinkExplain =>
      'Cualquiera con el enlace puede leer este informe hasta que caduque. Muestra el mismo resumen que el PDF, no tu diario. Puedes dejar de compartir en cualquier momento.';

  @override
  String get shareLinkNeedsAccount =>
      'Compartir un enlace necesita una cuenta. El PDF y el CSV funcionan sin ella.';

  @override
  String shareLinkDuration(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get shareLinkCreate => 'Crear enlace';

  @override
  String get shareLinkWorking => 'Creando el enlace.';

  @override
  String shareLinkReady(String date) {
    return 'Enlace listo. Compartido hasta el $date.';
  }

  @override
  String get shareLinkCopy => 'Copiar enlace';

  @override
  String get shareLinkCopied => 'Enlace copiado.';

  @override
  String get shareLinkShare => 'Compartir enlace';

  @override
  String shareLinkMessage(String url) {
    return 'Mi informe de migraña: $url';
  }

  @override
  String get shareLinksTitle => 'Enlaces compartidos';

  @override
  String get settingsShareLinksHint =>
      'Consulta y detén los enlaces del informe que compartiste';

  @override
  String get shareLinksEmpty =>
      'No has compartido ningún enlace. Crea uno desde el informe para el médico.';

  @override
  String shareLinkActiveUntil(String date) {
    return 'Compartido hasta el $date';
  }

  @override
  String shareLinkExpiredOn(String date) {
    return 'Caducó el $date';
  }

  @override
  String get shareLinkRevoked => 'Se dejó de compartir';

  @override
  String shareLinkCreatedOn(String date) {
    return 'Creado el $date';
  }

  @override
  String get shareLinkRevoke => 'Dejar de compartir';

  @override
  String get shareLinkRevokeTitle => '¿Dejar de compartir este informe?';

  @override
  String get shareLinkRevokeBody =>
      'El enlace deja de funcionar al instante para todas las personas que lo tengan.';

  @override
  String get shareLinkRevokedDone =>
      'Se dejó de compartir. El enlace ya no funciona.';

  @override
  String get shareLinkErrorUnavailable =>
      'Los enlaces para compartir no están configurados en esta versión.';

  @override
  String get shareLinkErrorSignedOut =>
      'Tu sesión ha caducado. Vuelve a iniciar sesión e inténtalo de nuevo.';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumIntro =>
      'Premium añade cuatro extras. Todo lo demás sigue siendo gratis, sin límite de tiempo.';

  @override
  String get premiumFreeNote =>
      'Siempre gratis: registrar crisis y registros diarios, el tiempo, el nivel de riesgo, tus factores, el registro de medicación y el informe para el médico.';

  @override
  String get premiumFeatureShareLink => 'Enlace para tu profesional sanitario';

  @override
  String get premiumFeatureShareLinkHint =>
      'Envía tu informe como un enlace web que deja de funcionar a los 7 o 30 días.';

  @override
  String get premiumFeatureExperiments => 'Experimentos';

  @override
  String get premiumFeatureExperimentsHint =>
      'Prueba un cambio durante dos semanas y compáralo con las semanas anteriores.';

  @override
  String get premiumFeatureExtendedFactors => 'Factores ambientales ampliados';

  @override
  String get premiumFeatureExtendedFactorsHint =>
      'Partículas, ozono y polen por tipo.';

  @override
  String get premiumFeatureBackup => 'Copia entre teléfonos';

  @override
  String get premiumFeatureBackupHint =>
      'Una copia cifrada que puedes restaurar en un teléfono nuevo.';

  @override
  String get premiumActive => 'Premium está activado.';

  @override
  String premiumRenews(String date) {
    return 'Se renueva el $date.';
  }

  @override
  String premiumEnds(String date) {
    return 'Termina el $date.';
  }

  @override
  String get premiumManage => 'Gestionar suscripción';

  @override
  String premiumOfferMonthly(String price) {
    return 'Mensual, $price';
  }

  @override
  String premiumOfferAnnual(String price) {
    return 'Anual, $price';
  }

  @override
  String premiumOfferOther(String price) {
    return '$price';
  }

  @override
  String get premiumRestore => 'Restaurar compras';

  @override
  String get premiumRestoredNone =>
      'No se encontró ninguna compra Premium para esta cuenta de la tienda.';

  @override
  String get premiumThanks => 'Gracias. Premium está activado.';

  @override
  String get premiumRenewalTerms =>
      'Las suscripciones se renuevan automáticamente hasta que las canceles en los ajustes de la tienda. Cancela al menos 24 horas antes de la fecha de renovación para evitar el siguiente cargo.';

  @override
  String get premiumLoadingOffers => 'Cargando precios.';

  @override
  String get premiumNoOffers =>
      'No se pudieron cargar los precios. Revisa la conexión e inténtalo de nuevo.';

  @override
  String get premiumRetry => 'Intentar de nuevo';

  @override
  String get premiumUnavailable =>
      'Las compras no están configuradas en esta versión.';

  @override
  String get premiumDevUnlocked =>
      'Versión de desarrollo: todas las funciones Premium están desbloqueadas.';

  @override
  String get premiumAccountTip =>
      '¿Usas más de un teléfono? Inicia sesión primero para que Premium siga a tu cuenta.';

  @override
  String get premiumErrorNotAllowed =>
      'Esta cuenta de la tienda no puede hacer compras.';

  @override
  String get premiumErrorPending =>
      'La compra está pendiente de aprobación. Premium se activará cuando se complete.';

  @override
  String get premiumErrorStore =>
      'La tienda ha tenido un problema. Inténtalo más tarde.';

  @override
  String premiumLockTitle(String feature) {
    return '$feature viene con Premium.';
  }

  @override
  String get premiumLockButton => 'Ver Premium';

  @override
  String get premiumLockShareLinkNote =>
      'Los enlaces que ya creaste siguen funcionando hasta que caduquen, y puedes dejar de compartirlos cuando quieras.';

  @override
  String get premiumLockExperimentsNote =>
      'Tus resultados anteriores se quedan aquí.';

  @override
  String get premiumLockBackupNote =>
      'Aún puedes restaurar o eliminar una copia que ya tengas.';

  @override
  String get premiumFactorsLocked =>
      'Partículas, ozono y polen vienen con Premium.';

  @override
  String get settingsPremiumHint =>
      'Enlace para compartir, experimentos, factores ampliados y copia';

  @override
  String get settingsPremiumActive => 'Activado';

  @override
  String get shareLinkErrorPremium =>
      'Los enlaces para compartir necesitan Premium. Si acabas de suscribirte, espera un minuto e inténtalo de nuevo.';

  @override
  String get auditTitle => 'Cómo ha funcionado el nivel de riesgo';

  @override
  String auditNotYet(int needed, int logged) {
    return 'Esta página aparece cuando hayas registrado $needed crisis. Llevas $logged.';
  }

  @override
  String auditIntro(int window) {
    String _temp0 = intl.Intl.pluralLogic(
      window,
      locale: localeName,
      other: 'los $window días anteriores',
      one: 'el día anterior',
    );
    return 'Esto compara el nivel que mostró la app cada día con cuándo empezaron tus crisis. Una crisis cuenta como posterior a un día Alto cuando el día en que empezó o $_temp0 se mostró como Alto.';
  }

  @override
  String get auditEmpty =>
      'Aún no hay nada que comparar. La app guarda desde ahora el nivel que muestra cada día, y las primeras cifras aparecerán tras tu próxima crisis o tu próximo día Alto.';

  @override
  String get auditHitsTitle => 'Crisis después de un día Alto';

  @override
  String auditHitsValue(int hits, int attacks, String share) {
    return '$hits de $attacks ($share)';
  }

  @override
  String get auditMissesTitle => 'Crisis sin un día Alto antes';

  @override
  String auditMissesValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count crisis',
      one: '1 crisis',
    );
    return '$_temp0';
  }

  @override
  String get auditFalseAlarmsTitle => 'Días Altos sin crisis';

  @override
  String auditFalseAlarmsValue(int count, int highDays) {
    return '$count de $highDays días Altos';
  }

  @override
  String get auditTrend => 'Por mes';

  @override
  String auditMonthLine(int hits, int attacks, int falseAlarms, int highDays) {
    return '$hits de $attacks crisis tras un día Alto; $falseAlarms de $highDays días Altos sin crisis';
  }

  @override
  String get auditCaveat =>
      'Con cifras pequeñas, los resultados cambian mucho de un mes a otro. Un día Alto sin crisis no es un error: significa que se juntaron más de tus desencadenantes habituales. El nivel es una guía para organizarte, no una promesa.';

  @override
  String get auditShare => 'Compartir estas cifras cada mes';

  @override
  String get auditShareHint =>
      'Ayuda a revisar la app para todo el mundo. Solo se envían las cinco cifras y la versión del modelo, nunca fechas, lugares, tu registro ni tu cuenta. Desactivado salvo que lo actives.';

  @override
  String get settingsAuditHint =>
      'Crisis tras días Altos y días Altos sin crisis';

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
  String get unitsTitle => 'Unidades';

  @override
  String get settingsUnitsHint => 'Presión y temperatura';

  @override
  String get unitsPressure => 'Presión';

  @override
  String get unitsTemperature => 'Temperatura';

  @override
  String get unitNameHpa => 'Hectopascales (hPa)';

  @override
  String get unitNameInHg => 'Pulgadas de mercurio (inHg)';

  @override
  String get unitNameMmHg => 'Milímetros de mercurio (mmHg)';

  @override
  String get unitNameCelsius => 'Celsius (°C)';

  @override
  String get unitNameFahrenheit => 'Fahrenheit (°F)';

  @override
  String get unitsNote =>
      'La primera opción viene de la región de tu teléfono. Cambiarla solo cambia cómo se muestran los valores; tu registro no cambia.';

  @override
  String envTemperatureNow(String temperature) {
    return 'Temperatura actual: $temperature';
  }

  @override
  String get questionnaireEnglishNote =>
      'Las preguntas se muestran en su redacción original en inglés hasta que se añada una traducción validada, para que tus puntuaciones sigan siendo comparables.';

  @override
  String get wellnessDisclaimer =>
      'Información general de bienestar, no consejo médico. Habla con tu profesional de salud sobre el tratamiento.';

  @override
  String get dataSourceWeather => 'Tiempo de Open-Meteo';

  @override
  String get dataSourceAirQuality =>
      'Calidad del aire y UV de Open-Meteo (CAMS)';

  @override
  String get dataSourcePollen => 'Polen de Open-Meteo (CAMS)';

  @override
  String get dataSourceGeocoding => 'Geocodificación de Open-Meteo';

  @override
  String get dataSourceBarometer => 'Barómetro del dispositivo';

  @override
  String get dataCoverageWorldwide => 'Todo el mundo';

  @override
  String get dataCoverageEuropeanAqi => 'Todo el mundo, ICA europeo en Europa';

  @override
  String get dataCoverageEurope => 'Solo Europa';

  @override
  String get dataCoverageBarometer => 'Teléfonos con sensor de presión';

  @override
  String get settingsReduceMotion => 'Reducir movimiento';

  @override
  String get settingsReduceMotionHint =>
      'Menos animaciones, aunque el ajuste del teléfono esté desactivado';
}
