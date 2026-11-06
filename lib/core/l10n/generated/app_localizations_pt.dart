// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Migraine Tracker';

  @override
  String get homeEmptyState =>
      'Nada registrado ainda.\nSeu nível de risco e seu ambiente aparecerão aqui.';

  @override
  String get riskLevelLow => 'Baixo';

  @override
  String get riskLevelModerate => 'Moderado';

  @override
  String get riskLevelHigh => 'Alto';

  @override
  String get devThemeGalleryTitle => 'Galeria de temas';

  @override
  String get devThemeLight => 'Tema claro';

  @override
  String get devThemeDark => 'Tema escuro';

  @override
  String get devThemeAttack => 'Tema de crise';

  @override
  String get devSampleBody =>
      'Texto no tamanho padrão. Deve continuar legível com texto a 200% sem cortes.';

  @override
  String get devSamplePrimary => 'Principal';

  @override
  String get devSampleSecondary => 'Secundário';

  @override
  String get devSampleText => 'Texto';

  @override
  String get devSampleDisabled => 'Desativado';

  @override
  String get devSampleChipOn => 'Aura';

  @override
  String get devSampleChipOff => 'Náusea';

  @override
  String get devSampleChipIcon => 'Luz';

  @override
  String get devSampleSlider => 'Intensidade';

  @override
  String get devSampleSliderLow => 'Sem dor';

  @override
  String get devSampleSliderHigh => 'Pior';

  @override
  String get devSampleCard => 'Um cartão com um selo';

  @override
  String get attackStart => 'Iniciar crise';

  @override
  String get attackContinue => 'Continuar crise';

  @override
  String get attackTitleRunning => 'Crise em andamento';

  @override
  String get attackTitleEnded => 'Crise';

  @override
  String attackStartedAt(String time) {
    return 'Começou às $time';
  }

  @override
  String get attackNotFound => 'Esta crise não existe mais.';

  @override
  String get attackIntensity => 'Intensidade da dor';

  @override
  String get durationEstimateTitle => 'Quanto crises como esta costumam durar';

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
          'Com base em $count crises anteriores de intensidade parecida com a mesma medicação',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateNoMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Com base em $count crises anteriores de intensidade parecida sem medicação',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateSimilar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Com base em $count crises anteriores de intensidade parecida',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Com base em $count das suas crises anteriores',
    );
    return '$_temp0';
  }

  @override
  String get attackIntensityLow => 'Sem dor';

  @override
  String get attackIntensityHigh => 'Pior';

  @override
  String get attackWhereItHurts => 'Onde dói';

  @override
  String get attackSymptoms => 'Sintomas';

  @override
  String get attackPhases => 'Fases';

  @override
  String get attackNotes => 'Anotações';

  @override
  String get attackNotesHint => 'Qualquer outra coisa que valha lembrar';

  @override
  String get attackEnd => 'Encerrar crise';

  @override
  String get attackDone => 'Concluído';

  @override
  String get attackFinishLater => 'Terminar depois';

  @override
  String get symptomAura => 'Aura';

  @override
  String get symptomNeckTension => 'Tensão no pescoço';

  @override
  String get symptomLightSensitivity => 'Luz';

  @override
  String get symptomSoundSensitivity => 'Som';

  @override
  String get symptomSmellSensitivity => 'Cheiro';

  @override
  String get symptomNausea => 'Náusea';

  @override
  String get phaseProdrome => 'Pródromo';

  @override
  String get phaseAura => 'Aura';

  @override
  String get phaseAttack => 'Crise';

  @override
  String get phasePostdrome => 'Pósdromo';

  @override
  String get headForehead => 'Testa';

  @override
  String get headLeftTemple => 'Têmpora esquerda';

  @override
  String get headRightTemple => 'Têmpora direita';

  @override
  String get headBehindEyes => 'Atrás dos olhos';

  @override
  String get headLeftSide => 'Lado esquerdo';

  @override
  String get headRightSide => 'Lado direito';

  @override
  String get headTopOfHead => 'Topo da cabeça';

  @override
  String get headBackOfHead => 'Parte de trás da cabeça';

  @override
  String get headNeck => 'Pescoço';

  @override
  String get checkinTitle => 'Registro diário';

  @override
  String get checkinLoadError => 'Não foi possível carregar este dia.';

  @override
  String get checkinIntro => 'Três toques. Como foi?';

  @override
  String get checkinComplete =>
      'Pronto para este dia. Toque em um número para mudar.';

  @override
  String get checkinAddMore => 'Adicionar mais (opcional)';

  @override
  String get checkinOptionalTitle => 'Opcional';

  @override
  String get checkinDone => 'Concluído';

  @override
  String get checkinToday => 'Hoje';

  @override
  String get checkinSleepQuality => 'Qualidade do sono';

  @override
  String get checkinStress => 'Estresse';

  @override
  String get checkinNeckTension => 'Tensão no pescoço';

  @override
  String get checkinCaffeine => 'Cafeína';

  @override
  String get checkinHydration => 'Hidratação';

  @override
  String get checkinAlcohol => 'Álcool';

  @override
  String get checkinLightExposure => 'Luz forte';

  @override
  String get checkinScreenExposure => 'Tempo de tela';

  @override
  String get checkinSleepLow => 'Ruim';

  @override
  String get checkinSleepHigh => 'Ótimo';

  @override
  String get checkinStressLow => 'Calmo';

  @override
  String get checkinStressHigh => 'Muito estressado';

  @override
  String get checkinNeckLow => 'Relaxado';

  @override
  String get checkinNeckHigh => 'Muito tenso';

  @override
  String get checkinHydrationLow => 'Pouca';

  @override
  String get checkinHydrationHigh => 'Bastante';

  @override
  String get checkinExposureLow => 'Pouca';

  @override
  String get checkinExposureHigh => 'Muita';

  @override
  String get checkinNone => 'Nenhum';

  @override
  String checkinCupsOrMore(int count) {
    return '$count+ xícaras';
  }

  @override
  String checkinDrinksOrMore(int count) {
    return '$count+ doses';
  }

  @override
  String checkinValueSemantics(String field, int value, int max) {
    return '$field, $value de $max';
  }

  @override
  String get checkinReminderTooltip => 'Horário do lembrete';

  @override
  String checkinReminderAt(String time) {
    return 'Lembrete às $time';
  }

  @override
  String get checkinReminderPickerTitle => 'Lembrete do registro diário';

  @override
  String get checkinCardTitle => 'Registro diário';

  @override
  String get checkinCardDone => 'Pronto por hoje';

  @override
  String get checkinCardTodo => 'Três toques, cerca de 10 segundos';

  @override
  String get medicationTitle => 'Medicação';

  @override
  String get medicationAdd => 'Adicionar medicação';

  @override
  String get medicationAddTitle => 'Registrar uma dose';

  @override
  String get medicationName => 'Medicamento';

  @override
  String get medicationDose => 'Dose';

  @override
  String get medicationDoseHint => 'ex.: 400 mg';

  @override
  String get medicationKindAcute => 'Aguda';

  @override
  String get medicationKindPreventive => 'Preventiva';

  @override
  String medicationTakenAt(String time) {
    return 'Tomada às $time';
  }

  @override
  String get medicationLog => 'Registrar';

  @override
  String get medicationDelete => 'Excluir';

  @override
  String get medicationThisMonth => 'Este mês';

  @override
  String get medicationEmpty => 'Nenhuma dose registrada este mês.';

  @override
  String get medicationReliefQuestion => 'Alívio após 2 h?';

  @override
  String get medicationReliefNone => 'Nenhum';

  @override
  String get medicationReliefPartial => 'Algum';

  @override
  String get medicationReliefFull => 'Total';

  @override
  String medicationAcuteDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias com medicação aguda este mês',
      one: '1 dia com medicação aguda este mês',
      zero: 'Nenhum dia com medicação aguda este mês',
    );
    return '$_temp0';
  }

  @override
  String get medicationAcuteDaysHint =>
      'Dias com pelo menos uma dose aguda, contados por mês do calendário.';

  @override
  String medicationOveruseFirstNote(int days) {
    return 'Você chegou a $days dias com medicação aguda este mês. Muitos profissionais de saúde sugerem manter esse número baixo; pode valer uma conversa.';
  }

  @override
  String medicationOveruseSecondNote(int days) {
    return 'Você chegou a $days dias com medicação aguda este mês. Considere conversar com seu profissional de saúde sobre esse padrão.';
  }

  @override
  String get medicationTalkToClinician =>
      'Converse com seu profissional de saúde';

  @override
  String get cycleTitle => 'Ciclo';

  @override
  String get cycleToggleTitle => 'Acompanhar meu ciclo';

  @override
  String get cycleToggleSubtitle =>
      'Desativado por padrão. Quando ativado, o dia do ciclo é guardado com cada registro e usado como fator.';

  @override
  String get cycleNoData =>
      'Registre o início de uma menstruação para ver o dia do ciclo.';

  @override
  String cycleDayAndPhase(int day, String phase) {
    return 'Dia $day do ciclo · $phase';
  }

  @override
  String cycleLength(int days) {
    return 'Com base em um ciclo de $days dias';
  }

  @override
  String get cyclePeriodStarts => 'Inícios da menstruação';

  @override
  String get cycleNoStarts => 'Nenhum registrado ainda.';

  @override
  String get cycleRemoveStart => 'Remover';

  @override
  String get cyclePeriodStartedToday => 'A menstruação começou neste dia';

  @override
  String get cyclePhaseMenstrual => 'Menstrual';

  @override
  String get cyclePhaseFollicular => 'Folicular';

  @override
  String get cyclePhaseOvulation => 'Perto da ovulação';

  @override
  String get cyclePhaseLuteal => 'Lútea';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSectionDaily => 'Diário';

  @override
  String get settingsSectionData => 'Seus dados';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get settingsExportJson => 'Exportar como JSON';

  @override
  String get settingsExportJsonHint =>
      'Todas as tabelas em um arquivo que pode ser importado de novo.';

  @override
  String get settingsExportCsv => 'Exportar como CSV';

  @override
  String get settingsExportCsvHint => 'Um arquivo de planilha por tabela.';

  @override
  String get settingsExportEmpty => 'Nada para exportar ainda.';

  @override
  String get settingsDeleteAll => 'Apagar tudo';

  @override
  String get settingsDeleteAllHint =>
      'Remove todos os dados deste aparelho. Não pode ser desfeito.';

  @override
  String settingsDeleteAllConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Isto apaga $count registros deste aparelho. Não pode ser desfeito.',
      one: 'Isto apaga 1 registro deste aparelho. Não pode ser desfeito.',
      zero: 'Nada foi guardado ainda. Apagar mesmo assim?',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeleteAllButton => 'Apagar';

  @override
  String get settingsCancel => 'Cancelar';

  @override
  String get settingsDeletedAll => 'Todos os dados foram apagados.';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidade';

  @override
  String get settingsTerms => 'Termos de uso';

  @override
  String get settingsSupport => 'Suporte';

  @override
  String get environmentTitle => 'Ambiente';

  @override
  String get environmentCardTitle => 'Pressão';

  @override
  String get environmentCardEmpty =>
      'Nenhum dado do tempo salvo ainda. Toque para definir sua localização.';

  @override
  String environmentCardSummary(String pressure, String trend) {
    return '$pressure, $trend';
  }

  @override
  String get envPressureSection => 'Pressão atmosférica';

  @override
  String get envPressureUnknown => 'Sem leitura para esta hora';

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
  String get envChartTitle => 'Últimas 48 horas e próximas 24';

  @override
  String get envUpdatedNever => 'Ainda não atualizado';

  @override
  String get envUpdatedJustNow => 'Atualizado agora';

  @override
  String envUpdatedMinutes(int n) {
    return 'Atualizado há $n min';
  }

  @override
  String envUpdatedHours(int n) {
    return 'Atualizado há $n h';
  }

  @override
  String envUpdatedDays(int n) {
    return 'Atualizado há $n d';
  }

  @override
  String get envStale =>
      'Esta previsão tem algumas horas. Ela é atualizada quando você voltar a ficar on-line.';

  @override
  String get envOffline =>
      'Não foi possível acessar o serviço do tempo. Mostrando o que está salvo neste aparelho.';

  @override
  String get envNoData =>
      'Nenhum dado do tempo salvo ainda. Permita a localização ou escolha uma cidade para ver a tendência da pressão.';

  @override
  String get envRefresh => 'Atualizar';

  @override
  String get envLocationSection => 'Localização';

  @override
  String get envLocationGps => 'Usando sua localização aproximada';

  @override
  String envLocationManual(String city) {
    return 'Usando $city';
  }

  @override
  String get envLocationLast => 'Usando a última área conhecida';

  @override
  String get envLocationNone => 'Nenhuma localização definida';

  @override
  String get envUseMyLocation => 'Usar minha localização';

  @override
  String get envChooseCity => 'Escolher uma cidade';

  @override
  String get envCitySearchTitle => 'Escolher uma cidade';

  @override
  String get envCitySearchHint => 'Nome da cidade';

  @override
  String get envCityNoResults => 'Nenhum lugar encontrado';

  @override
  String get envCitySearchFailed =>
      'Não foi possível pesquisar agora. Verifique a conexão e tente de novo.';

  @override
  String get envPrivacyNote =>
      'Sua localização é arredondada para cerca de 10 km antes de sair deste aparelho.';

  @override
  String get envAttribution => 'Dados do tempo por Open-Meteo';

  @override
  String get envTrendRising => 'subindo';

  @override
  String get envTrendFalling => 'caindo';

  @override
  String get envTrendSteady => 'estável';

  @override
  String get envTrendUnknown => 'ainda sem tendência';

  @override
  String get barometerTitle => 'Barômetro';

  @override
  String get barometerOpen => 'Abrir o barômetro';

  @override
  String get barometerNoReading => 'Sem leitura';

  @override
  String get barometerFromSensor => 'Do sensor deste aparelho';

  @override
  String get barometerFromStation => 'Da estação mais próxima';

  @override
  String get barometerNoSource =>
      'Este aparelho não tem sensor e ainda não há previsão salva';

  @override
  String get barometerCalibrationSection => 'Calibração';

  @override
  String barometerOffset(String offset, int pairs) {
    return 'Diferença do sensor de $offset em relação à estação, a partir de $pairs pares por hora.';
  }

  @override
  String barometerNotCalibrated(int pairs) {
    return 'Ainda não calibrado. São necessárias pelo menos $pairs horas com uma amostra do sensor e um valor da estação.';
  }

  @override
  String get barometerTrendSection => 'Últimas 24 horas neste aparelho';

  @override
  String get barometerTrendEmpty =>
      'As amostras são coletadas enquanto o app está aberto. Volte mais tarde para ver a tendência.';

  @override
  String barometerTrendSamples(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n amostras',
      one: '1 amostra',
    );
    return '$_temp0';
  }

  @override
  String get barometerStampNote =>
      'Cada crise iniciada guarda a leitura do sensor e o valor da estação daquela hora.';

  @override
  String get envFactorsTitle => 'Fatores de hoje';

  @override
  String get envFactorsEmpty => 'Ainda não há fatores diários para esta área.';

  @override
  String get factorBandLow => 'baixo';

  @override
  String get factorBandModerate => 'moderado';

  @override
  String get factorBandHigh => 'alto';

  @override
  String get factorBandVeryHigh => 'muito alto';

  @override
  String factorValueWithBand(String value, String band) {
    return '$value ($band)';
  }

  @override
  String get factorAqiUs => 'Qualidade do ar (AQI dos EUA)';

  @override
  String get factorAqiEu => 'Qualidade do ar (AQI europeu)';

  @override
  String get factorParticulates => 'Partículas PM2.5 / PM10';

  @override
  String factorParticulatesValue(String pm25, String pm10) {
    return '$pm25 / $pm10 µg/m³';
  }

  @override
  String get factorOzone => 'Ozônio';

  @override
  String factorMicrograms(String value) {
    return '$value µg/m³';
  }

  @override
  String get factorPollen => 'Pólen (só Europa)';

  @override
  String factorPollenType(String type, String band) {
    return '$type $band';
  }

  @override
  String get pollenAlder => 'amieiro';

  @override
  String get pollenBirch => 'bétula';

  @override
  String get pollenGrass => 'gramíneas';

  @override
  String get pollenMugwort => 'artemísia';

  @override
  String get pollenOlive => 'oliveira';

  @override
  String get pollenRagweed => 'ambrósia';

  @override
  String get factorUvMax => 'Índice UV, máximo do dia';

  @override
  String get factorDaylight => 'Luz do dia';

  @override
  String factorDaylightValue(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get factorSun => 'Nascer e pôr do sol';

  @override
  String factorSunValue(String sunrise, String sunset) {
    return '$sunrise a $sunset';
  }

  @override
  String get aboutDataTitle => 'Sobre os dados';

  @override
  String get aboutDataIntro =>
      'De onde vêm os números deste app e o que cada um pode e não pode dizer.';

  @override
  String get aboutDataSources => 'Fontes';

  @override
  String aboutDataLicence(String coverage, String licence) {
    return '$coverage. Licença: $licence.';
  }

  @override
  String get aboutDataPrivacy => 'O que sai do seu celular';

  @override
  String get aboutDataPrivacyBody =>
      'Só uma localização arredondada para cerca de 10 km, para que o serviço do tempo responda para a sua área. Suas crises, registros, medicação e dados de saúde ficam neste aparelho, a menos que você escolha fazer backup ou compartilhar.';

  @override
  String get aboutDataLimits => 'Limites';

  @override
  String get aboutDataLimitsBody =>
      'As previsões são estimativas de um modelo para uma célula da grade, não uma medição na sua porta. O pólen só está disponível na Europa. A qualidade do ar pode faltar em algumas regiões. Quando um fator não tem dados para a sua área, ele simplesmente não aparece.';

  @override
  String get settingsHealthHint =>
      'Sono, frequência cardíaca, passos e ciclo do seu app de saúde';

  @override
  String get healthTitle => 'Dados de saúde';

  @override
  String healthIntro(String store) {
    return 'Escolha o que ler de $store. Cada tipo tem seu próprio botão e seu próprio motivo.';
  }

  @override
  String get healthPrivacyNote =>
      'Os dados importados ficam neste celular. Nunca são enviados, nem com o backup, a menos que você mesmo os exporte.';

  @override
  String get healthStoreApple => 'Apple Saúde';

  @override
  String get healthStoreConnect => 'Health Connect';

  @override
  String healthUnavailable(String store) {
    return '$store não está disponível neste aparelho.';
  }

  @override
  String get healthReadSection => 'Ler';

  @override
  String get healthTypeSleep => 'Sono';

  @override
  String get healthReasonSleep =>
      'Preenche a qualidade do sono no registro diário a partir da noite, para você ter um toque a menos.';

  @override
  String get healthTypeRestingHr => 'Frequência cardíaca em repouso';

  @override
  String get healthReasonRestingHr =>
      'Uma frequência em repouso mais alta que o normal pode mostrar desgaste no dia anterior a uma crise.';

  @override
  String get healthTypeHrv => 'Variabilidade da frequência cardíaca';

  @override
  String get healthReasonHrv =>
      'Uma variabilidade mais baixa que o normal costuma vir com estresse e má recuperação.';

  @override
  String get healthTypeSteps => 'Passos';

  @override
  String get healthReasonSteps =>
      'Vale ver os dias de atividade muito baixa ou muito alta ao lado das suas crises.';

  @override
  String get healthTypeFlow => 'Fluxo menstrual';

  @override
  String get healthReasonFlow =>
      'Preenche os inícios da menstruação para o acompanhamento do ciclo, se você usar.';

  @override
  String healthDenied(String store) {
    return '$store não concedeu acesso. Você pode mudar isso nas configurações dele.';
  }

  @override
  String get healthWriteSection => 'Gravar';

  @override
  String healthWriteHeadaches(String store) {
    return 'Gravar episódios de dor de cabeça em $store';
  }

  @override
  String get healthWriteHeadachesHint =>
      'Cada crise encerrada é salva como dor de cabeça com início, fim e intensidade. Nada mais é gravado.';

  @override
  String get healthImportSection => 'Importar';

  @override
  String get healthImportNow => 'Importar agora';

  @override
  String get healthImportNever => 'Nada importado ainda';

  @override
  String healthImportLast(String age) {
    return '$age';
  }

  @override
  String get healthImportFailed =>
      'A importação não terminou. Tente de novo mais tarde.';

  @override
  String healthImportResult(int imported, int prefilled) {
    String _temp0 = intl.Intl.pluralLogic(
      imported,
      locale: localeName,
      other: '$imported amostras novas.',
      one: '1 amostra nova.',
      zero: 'Nada novo.',
    );
    String _temp1 = intl.Intl.pluralLogic(
      prefilled,
      locale: localeName,
      other: 'Sono preenchido para $prefilled dias.',
      one: 'Sono preenchido para 1 dia.',
      zero: '',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get checkinSourceHealthkit => 'Do Apple Saúde';

  @override
  String get checkinSourceHealthConnect => 'Do Health Connect';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingFinish => 'Concluir';

  @override
  String onboardingStep(int step, int total) {
    return 'Etapa $step de $total';
  }

  @override
  String get onboardingWelcomeTitle => 'Boas-vindas';

  @override
  String get onboardingLocationTitle => 'O tempo na sua área';

  @override
  String get onboardingLocationBody =>
      'Mudanças na pressão atmosférica estão entre as coisas que as pessoas mais notam antes de uma crise. Permita uma localização aproximada ou escolha uma cidade para vê-las.';

  @override
  String get onboardingLocationNone =>
      'Ainda sem localização. Você também pode definir isso depois na tela de ambiente.';

  @override
  String get onboardingHealthTitle => 'Dados de saúde';

  @override
  String get onboardingHealthBody =>
      'Opcional. Cada tipo tem seu próprio botão e seu próprio motivo. Você pode mudar qualquer um depois em Configurações.';

  @override
  String get onboardingHealthUnavailable =>
      'Nenhum app de saúde está disponível neste aparelho. Você pode pular esta etapa.';

  @override
  String get onboardingReminderTitle => 'Registro diário';

  @override
  String get onboardingReminderBody =>
      'Três toques por dia, cerca de dez segundos. Escolha um horário para o lembrete.';

  @override
  String get onboardingReminderNote =>
      'Os lembretes começam quando as notificações forem configuradas. Você pode mudar o horário em qualquer dia pelo registro.';

  @override
  String get explainerTitle => 'O que o nível significa';

  @override
  String get explainerIntro =>
      'Todo dia o app mostra um nível criado a partir do seu próprio histórico e das condições de hoje.';

  @override
  String get explainerDoesTitle => 'O que ele faz';

  @override
  String get explainerDoes1 =>
      'Mostra como o tempo, o sono, o estresse e a rotina de hoje se comparam com os dias anteriores às suas crises passadas.';

  @override
  String get explainerDoes2 =>
      'Aprende com o seu próprio registro, então fica mais específico quanto mais você anota.';

  @override
  String get explainerDoes3 =>
      'Ajuda você a decidir se hoje é um dia para pegar mais leve.';

  @override
  String get explainerDoesNotTitle => 'O que ele não faz';

  @override
  String get explainerDoesNot1 =>
      'Não é um aviso de crise. Um nível alto é um padrão, não uma certeza, e um nível baixo não é uma promessa.';

  @override
  String get explainerDoesNot2 =>
      'Não é uma opinião médica e não substitui seu profissional de saúde.';

  @override
  String get explainerDoesNot3 =>
      'Nunca envia seu registro para lugar nenhum. O nível é calculado neste celular.';

  @override
  String get riskCardTitle => 'Nível de hoje';

  @override
  String get riskCardEmpty =>
      'Ainda sem nível. Adicione um registro ou deixe o tempo carregar.';

  @override
  String get riskScreenTitle => 'Seu nível';

  @override
  String get riskWhyTitle => 'Por quê';

  @override
  String get riskNoDrivers => 'Nada se destaca.';

  @override
  String get riskNextDays => 'Próximos dias';

  @override
  String get riskDayToday => 'Hoje';

  @override
  String get riskDayTomorrow => 'Amanhã';

  @override
  String riskLoad(String value) {
    return 'Carga $value de 100';
  }

  @override
  String riskConfidence(String label) {
    return 'Confiança: $label';
  }

  @override
  String get riskConfidenceLow => 'baixa';

  @override
  String get riskConfidenceMedium => 'média';

  @override
  String get riskConfidenceHigh => 'alta';

  @override
  String riskStillLearning(int count, int needed) {
    return 'Ainda aprendendo: $count de $needed crises registradas';
  }

  @override
  String get riskTuned => 'Ajustado ao seu registro';

  @override
  String riskDriverPoints(String points) {
    return '$points pontos';
  }

  @override
  String riskUpdated(String time) {
    return 'Atualizado $time';
  }

  @override
  String get riskExplainerLink => 'O que o nível significa';

  @override
  String get riskOpenCheckin => 'Adicionar o registro de hoje';

  @override
  String get riskFactorPressureDrop => 'Queda da pressão atmosférica';

  @override
  String get riskFactorHumidity => 'Umidade alta';

  @override
  String get riskFactorTemperatureSwing => 'Mudança de temperatura';

  @override
  String get riskFactorAirQuality => 'Qualidade do ar';

  @override
  String get riskFactorPollen => 'Pólen';

  @override
  String get riskFactorBrightLight => 'Luz forte';

  @override
  String get riskFactorScreenTime => 'Tempo de tela';

  @override
  String get riskFactorPoorSleep => 'Sono ruim';

  @override
  String get riskFactorStress => 'Estresse';

  @override
  String get riskFactorNeckTension => 'Tensão no pescoço';

  @override
  String get riskFactorCaffeine => 'Cafeína';

  @override
  String get riskFactorAlcohol => 'Álcool';

  @override
  String get riskFactorDehydration => 'Pouca hidratação';

  @override
  String get riskFactorCyclePhase => 'Fase do ciclo';

  @override
  String get loadMeterTitle => 'Carga';

  @override
  String loadMeterSemantics(String value, String segments) {
    return 'Carga $value de 100. $segments';
  }

  @override
  String loadSegmentDetail(String name, String points) {
    return '$name: $points pontos';
  }

  @override
  String loadThresholdModerate(String value) {
    return 'Moderado a partir de $value';
  }

  @override
  String loadThresholdHigh(String value) {
    return 'Alto a partir de $value';
  }

  @override
  String get loadMeterEmpty => 'Ainda sem carga';

  @override
  String get insightsTitle => 'Seus fatores';

  @override
  String get insightsIntro =>
      'Com que frequência uma crise veio depois de cada fator no seu próprio registro, comparado com a sua taxa habitual.';

  @override
  String get insightsTriggers => 'Vieram mais crises depois';

  @override
  String get insightsProtectors => 'Vieram menos crises depois';

  @override
  String get insightsNeutral => 'Sem efeito claro';

  @override
  String get insightsNotEnough => 'Ainda não há dados suficientes';

  @override
  String get insightsEmptyBucket => 'Nada aqui ainda.';

  @override
  String insightsSample(int days, int attacks) {
    return '$days dias de exposição, $attacks seguidos de crise';
  }

  @override
  String insightsLift(String ratio) {
    return '$ratio× a sua taxa habitual';
  }

  @override
  String insightsNeedMore(int days, int needed) {
    return '$days de $needed dias de exposição registrados';
  }

  @override
  String get insightsNoRunYet =>
      'Registre e encerre uma crise para começar a contar.';

  @override
  String get insightsMethodLink => 'Como isto é contado';

  @override
  String get insightsMethodTitle => 'Como isto é contado';

  @override
  String insightsMethod1(String pressure) {
    return 'Um dia de exposição é um dia em que um fator esteve presente no seu registro ou no tempo, por exemplo uma resposta de sono 1 ou uma queda de pressão de mais de $pressure.';
  }

  @override
  String get insightsMethod2 =>
      'Uma crise conta como posterior a um dia quando começou nesse dia ou no seguinte, as 24 a 48 horas que o modelo considera.';

  @override
  String get insightsMethod3 =>
      'A razão compara com que frequência crises vieram depois dos dias desse fator com a frequência depois de qualquer dia do seu registro. 1,5× significa uma vez e meia a sua taxa habitual; 0,5×, metade.';

  @override
  String insightsMethod4(int needed) {
    return 'Um fator precisa de $needed dias de exposição antes de ser classificado. Até lá ele fica em \"Ainda não há dados suficientes\". Saber que menos crises vêm depois de um fator é tão útil quanto saber que vêm mais, por isso as duas listas têm o mesmo lugar.';
  }

  @override
  String get insightsMethod5 =>
      'Nada disso é uma causa. Um fator pode estar numa lista por causa de algo que vem junto com ele, como fins de semana ou uma mudança de medicação. Use as listas para decidir o que testar, não o que culpar.';

  @override
  String get riskInsightsLink => 'Seus fatores';

  @override
  String get settingsInsightsHint =>
      'Depois de quais fatores vieram crises no seu registro';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get settingsNotificationsHint =>
      'Alertas de nível, quedas de pressão, lembretes';

  @override
  String get notificationsIntro =>
      'Tudo é agendado neste celular a partir da previsão salva e do seu registro. Desative qualquer tipo que não quiser.';

  @override
  String get notificationsPermissionDenied =>
      'As notificações deste app estão desativadas nas configurações do sistema.';

  @override
  String get notifTypeRiskRising => 'Nível subindo';

  @override
  String get notifTypeRiskRisingHint =>
      'Na noite anterior e na manhã de um dia de nível mais alto';

  @override
  String get notifTypePressureDrop => 'Queda de pressão';

  @override
  String notifTypePressureDropHint(String pressure) {
    return 'Quando a previsão mostra uma queda de $pressure ou mais em 24 horas';
  }

  @override
  String get notifTypeAttackOver => 'Sua crise terminou?';

  @override
  String get notifTypeAttackOverHint =>
      'Na duração típica das suas crises, com um botão Encerrar';

  @override
  String get notifTypeCheckin => 'Lembrete do registro';

  @override
  String get notifTypeCheckinHint => 'No horário definido em Diário';

  @override
  String get notifTypeMedication => 'Lembrete preventivo';

  @override
  String get notifTypeMedicationHint =>
      'Um aviso diário para uma dose preventiva';

  @override
  String notifPressureThreshold(String pressure) {
    return 'Limite de queda de pressão: $pressure em 24 h';
  }

  @override
  String get notifMedicationTime => 'Horário do lembrete preventivo';

  @override
  String notifRiskEveningTitle(String level) {
    return 'Nível de amanhã: $level';
  }

  @override
  String notifRiskEveningBody(String level, String driver) {
    return 'Seu nível para amanhã é $level. Primeiro da lista: $driver.';
  }

  @override
  String notifRiskMorningTitle(String level) {
    return 'Nível de hoje: $level';
  }

  @override
  String notifRiskMorningBody(String level, String driver) {
    return 'Seu nível hoje é $level. Primeiro da lista: $driver.';
  }

  @override
  String get notifPressureTitle => 'A pressão atmosférica está caindo';

  @override
  String notifPressureBody(String pressure, String time) {
    return 'Uma queda de $pressure é esperada até $time.';
  }

  @override
  String get notifAttackOverTitle => 'Sua crise terminou?';

  @override
  String notifAttackOverBody(String duration) {
    return 'Começou há $duration. Encerre aqui quando tiver passado.';
  }

  @override
  String get notifEndAttackAction => 'Encerrar crise';

  @override
  String get notifCheckinTitle => 'Três toques por hoje';

  @override
  String get notifCheckinBody =>
      'Sono, estresse e tensão no pescoço. Quinze segundos.';

  @override
  String get notifMedicationTitle => 'Dose preventiva';

  @override
  String get notifMedicationBody =>
      'Hora da medicação preventiva de hoje, se você toma alguma.';

  @override
  String get notifChannelAlerts => 'Alertas';

  @override
  String get notifChannelAlertsDescription =>
      'Alertas de nível e de pressão a partir da previsão salva';

  @override
  String get notifChannelReminders => 'Lembretes';

  @override
  String get notifChannelRemindersDescription =>
      'Lembretes do registro e da dose preventiva';

  @override
  String get notifChannelAttack => 'Crise';

  @override
  String get notifChannelAttackDescription =>
      'Perguntas sobre uma crise em andamento';

  @override
  String get reportTitle => 'Relatório para o médico';

  @override
  String get settingsReportHint => 'PDF e planilha para um período';

  @override
  String get reportIntro =>
      'Um resumo do que você registrou, para a próxima consulta. Escolha um período e compartilhe o PDF ou as planilhas.';

  @override
  String get reportRangeLabel => 'Período';

  @override
  String reportRangeDays(int days) {
    return '$days dias';
  }

  @override
  String get reportRangeCustom => 'Personalizado';

  @override
  String reportRangeText(String from, String to) {
    return '$from a $to';
  }

  @override
  String reportPreviewAttacks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count crises',
      one: '1 crise',
      zero: 'Nenhuma crise',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewAttackDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias de crise',
      one: '1 dia de crise',
      zero: 'nenhum dia de crise',
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
      zero: 'nenhuma dose',
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
      zero: 'nenhum registro',
    );
    return '$_temp0';
  }

  @override
  String get reportEmpty => 'Nada registrado neste período ainda.';

  @override
  String get reportSharePdf => 'Compartilhar PDF';

  @override
  String get reportShareCsv => 'Compartilhar planilhas';

  @override
  String get reportShareAll => 'Compartilhar tudo';

  @override
  String get reportBuilding => 'Preparando o relatório';

  @override
  String get reportFailed =>
      'Não foi possível preparar o relatório. Tente de novo.';

  @override
  String get reportWhatIsIn => 'O que o PDF contém';

  @override
  String get reportContents =>
      'Calendário de crises, contagens mensais, duração, fatores com o tamanho das amostras, dias de medicação, mudanças de pressão, sintomas e locais da dor. Sem nomes, sem anotações.';

  @override
  String reportPdfTitle(String app) {
    return 'Relatório do $app';
  }

  @override
  String reportPdfPeriod(String from, String to, int days) {
    return 'Período: $from a $to ($days dias)';
  }

  @override
  String reportPdfGenerated(String date) {
    return 'Gerado em $date no aparelho da pessoa a partir do próprio registro.';
  }

  @override
  String get reportPdfDisclaimer =>
      'Este é um resumo de um diário preenchido pela própria pessoa em um app de bem-estar. Não é um prontuário médico e não substitui uma avaliação clínica. As razões dos fatores descrevem apenas o registro desta pessoa e não são causas.';

  @override
  String reportPdfPage(int page, int pages) {
    return 'Página $page de $pages';
  }

  @override
  String get reportSectionOverview => 'Visão geral';

  @override
  String get reportStatAttacks => 'Crises';

  @override
  String get reportStatAttackDays => 'Dias de crise';

  @override
  String get reportStatPerMonth => 'Crises a cada 30 dias';

  @override
  String get reportStatMeanIntensity => 'Intensidade média (0-10)';

  @override
  String get reportStatAcuteDays => 'Dias com medicação aguda';

  @override
  String get reportStatCheckins => 'Dias com registro';

  @override
  String get reportSectionMonths => 'Por mês';

  @override
  String get reportColMonth => 'Mês';

  @override
  String get reportColAttacks => 'Crises';

  @override
  String get reportColAttackDays => 'Dias de crise';

  @override
  String get reportColMeanIntensity => 'Intensidade média';

  @override
  String get reportColAcuteDays => 'Dias agudos';

  @override
  String get reportColNote => 'Observação';

  @override
  String get reportOveruseWatch => '10+ dias agudos';

  @override
  String get reportOveruseHigh => '15+ dias agudos';

  @override
  String get reportSectionCalendar => 'Calendário de crises';

  @override
  String get reportCalendarHint =>
      'Uma célula por dia. Células sombreadas tiveram crise; o número é a maior intensidade do dia.';

  @override
  String get reportSectionDuration => 'Duração das crises';

  @override
  String get reportDurationNone => 'Nenhuma crise encerrada neste período.';

  @override
  String reportDurationSummary(
    int count,
    String shortest,
    String median,
    String longest,
  ) {
    return '$count crises encerradas. Mais curta $shortest, mediana $median, mais longa $longest.';
  }

  @override
  String get reportBucketUnderFour => 'Menos de 4 h';

  @override
  String get reportBucketFourToTwelve => '4 a 12 h';

  @override
  String get reportBucketTwelveToDay => '12 a 24 h';

  @override
  String get reportBucketOneToThreeDays => '1 a 3 dias';

  @override
  String get reportBucketOverThreeDays => 'Mais de 3 dias';

  @override
  String get reportSectionTriggers => 'Fatores no registro da pessoa';

  @override
  String reportTriggersHint(int floor) {
    return 'Razão entre as crises após dias com o fator e a taxa habitual da pessoa, com o número de dias de exposição por trás. Abaixo de $floor dias de exposição a razão não é mostrada.';
  }

  @override
  String get reportTriggersNone =>
      'Ainda não há dias registrados suficientes para comparar fatores.';

  @override
  String get reportColFactor => 'Fator';

  @override
  String get reportColRatio => 'Razão';

  @override
  String get reportColExposures => 'Dias de exposição';

  @override
  String get reportColFollowed => 'Seguidos de crise';

  @override
  String get reportColConfidence => 'Evidência';

  @override
  String get reportConfidenceLow => 'baixa';

  @override
  String get reportConfidenceMedium => 'moderada';

  @override
  String get reportConfidenceHigh => 'boa';

  @override
  String get reportSectionMedications => 'Medicação';

  @override
  String get reportMedicationsNone => 'Nenhuma dose registrada neste período.';

  @override
  String get reportColMedication => 'Medicamento';

  @override
  String get reportColKind => 'Tipo';

  @override
  String get reportColDoses => 'Doses';

  @override
  String get reportColDays => 'Dias';

  @override
  String get reportColRelief => 'Alívio em 2 h (nenhum / parcial / total)';

  @override
  String get reportKindAcute => 'aguda';

  @override
  String get reportKindPreventive => 'preventiva';

  @override
  String get reportSectionWeather => 'Pressão atmosférica';

  @override
  String reportWeatherHint(String pressure) {
    return 'Uma queda é uma redução de $pressure ou mais em 24 h no momento do registro.';
  }

  @override
  String get reportWeatherNone => 'Nenhum dado do tempo neste período.';

  @override
  String reportWeatherAttacks(int fall, int total) {
    return '$fall de $total crises começaram após uma queda de pressão.';
  }

  @override
  String reportWeatherDays(int fall, int total) {
    return '$fall de $total dias com registro tiveram uma.';
  }

  @override
  String reportWeatherLift(String lift) {
    return 'Razão: ${lift}x (1,0 significa sem relação).';
  }

  @override
  String get reportSectionSymptoms => 'Sintomas e locais da dor';

  @override
  String get reportSymptomsNone => 'Nenhum sintoma ou local registrado.';

  @override
  String reportCountOfAttacks(String name, int count, int total) {
    return '$name: $count de $total crises';
  }

  @override
  String reportHoursShort(String hours) {
    return '$hours h';
  }

  @override
  String get notifTypeQuestionnaire => 'Questionários trimestrais';

  @override
  String get notifTypeQuestionnaireHint =>
      'MIDAS e HIT-6, três meses após a última rodada';

  @override
  String get notifQuestionnaireTitle =>
      'Três meses desde os últimos questionários';

  @override
  String get notifQuestionnaireBody =>
      'Preencha MIDAS e HIT-6 de novo para comparar o último trimestre.';

  @override
  String get questionnairesTitle => 'Questionários';

  @override
  String get settingsQuestionnairesHint =>
      'MIDAS e HIT-6, com pontuação e gráfico';

  @override
  String get questionnairesIntro =>
      'Dois questionários curtos e validados sobre os últimos três meses. Repita a cada trimestre: as pontuações aparecem aqui em gráfico e podem entrar no relatório para o médico.';

  @override
  String get questionnaireMidasTitle => 'MIDAS';

  @override
  String get questionnaireMidasSubtitle =>
      'Migraine Disability Assessment: cinco contagens de dias dos últimos três meses';

  @override
  String get questionnaireHit6Title => 'HIT-6';

  @override
  String get questionnaireHit6Subtitle =>
      'Headache Impact Test: seis perguntas sobre como as dores de cabeça afetam sua vida';

  @override
  String get questionnaireNeverDone => 'Ainda não preenchido';

  @override
  String questionnaireLatest(int score, String date) {
    return 'Última pontuação $score em $date';
  }

  @override
  String get questionnaireDueNow => 'Pendente agora';

  @override
  String questionnaireDueOn(String date) {
    return 'Próxima rodada $date';
  }

  @override
  String get questionnaireStart => 'Preencher';

  @override
  String get questionnaireRepeat => 'Preencher de novo';

  @override
  String get questionnaireHistory => 'Histórico de pontuações';

  @override
  String questionnaireChartLabel(
    int count,
    String first,
    String last,
    int latest,
  ) {
    return '$count pontuações de $first a $last, a mais recente $latest';
  }

  @override
  String get questionnaireAbout => 'Sobre as pontuações';

  @override
  String get questionnaireAboutBody =>
      'O MIDAS soma cinco contagens de dias: 0 a 5 é grau I (pouca ou nenhuma incapacidade), 6 a 10 grau II (leve), 11 a 20 grau III (moderada), 21 ou mais grau IV (grave). O HIT-6 dá 6, 8, 10, 11 ou 13 pontos por resposta, de 36 a 78 no total: até 49 é pouco ou nenhum impacto, 50 a 55 algum impacto, 56 a 59 impacto considerável, 60 ou mais impacto grave. As faixas são as publicadas; as pontuações são para você discutir com seu profissional de saúde.';

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
  String get questionnaireMidasUnscored => 'Não faz parte da pontuação';

  @override
  String get questionnaireDaysField => 'Dias (0 a 90)';

  @override
  String get questionnairePainField => 'Dor (0 a 10)';

  @override
  String questionnaireDaysError(int max) {
    return 'Digite um número de 0 a $max';
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
  String get questionnaireSave => 'Salvar e pontuar';

  @override
  String get questionnaireIncomplete =>
      'Responda todas as perguntas pontuadas para salvar.';

  @override
  String questionnaireResultTitle(int score) {
    return 'Sua pontuação: $score';
  }

  @override
  String get questionnaireResultDone => 'Concluído';

  @override
  String get questionnaireResultDisclaimer =>
      'Uma pontuação descreve os últimos três meses como você se lembra deles. É um ponto de partida para conversar com seu profissional de saúde, não uma avaliação médica.';

  @override
  String get questionnaireMidasBandMinimal =>
      'Grau I: pouca ou nenhuma incapacidade';

  @override
  String get questionnaireMidasBandMild => 'Grau II: incapacidade leve';

  @override
  String get questionnaireMidasBandModerate =>
      'Grau III: incapacidade moderada';

  @override
  String get questionnaireMidasBandSevere => 'Grau IV: incapacidade grave';

  @override
  String get questionnaireHit6BandMinimal => 'Pouco ou nenhum impacto';

  @override
  String get questionnaireHit6BandMild => 'Algum impacto';

  @override
  String get questionnaireHit6BandModerate => 'Impacto considerável';

  @override
  String get questionnaireHit6BandSevere => 'Impacto grave';

  @override
  String get reportIncludeQuestionnaires =>
      'Incluir pontuações dos questionários';

  @override
  String get reportIncludeQuestionnairesHint =>
      'Rodadas de MIDAS e HIT-6 concluídas no período';

  @override
  String get reportSectionQuestionnaires => 'Questionários';

  @override
  String get reportQuestionnairesNone =>
      'Nenhum questionário concluído neste período.';

  @override
  String get reportColDate => 'Data';

  @override
  String get reportColQuestionnaire => 'Questionário';

  @override
  String get reportColScore => 'Pontuação';

  @override
  String get reportColBand => 'Faixa';

  @override
  String get voiceButton => 'Registrar por voz';

  @override
  String get voiceListening => 'Ouvindo';

  @override
  String get voiceListeningHint =>
      'Diga como está, por exemplo: dor sete de dez, atrás dos olhos, náusea, tomei ibuprofeno.';

  @override
  String get voiceStop => 'Terminei de falar';

  @override
  String get voiceCancel => 'Cancelar';

  @override
  String get voiceTryAgain => 'Tentar de novo';

  @override
  String get voiceUnavailable =>
      'A voz não está disponível neste celular. O reconhecimento de fala precisa da permissão do microfone e de um pacote de fala off-line para o seu idioma.';

  @override
  String get voiceNoMatch =>
      'Nada foi ouvido. Tente de novo mais perto do celular ou toque nos campos.';

  @override
  String get voiceReviewTitle => 'Confira antes de salvar';

  @override
  String voiceHeard(String text) {
    return 'Ouvido: \"$text\"';
  }

  @override
  String get voiceNothingUnderstood =>
      'Nada do que foi dito correspondeu ao formulário. Toque nos campos ou tente de novo.';

  @override
  String get voiceIntensity => 'Intensidade';

  @override
  String get voiceIntensityNone => 'Não dito';

  @override
  String get voiceSymptoms => 'Sintomas';

  @override
  String get voiceLocations => 'Onde dói';

  @override
  String get voiceMedications => 'Medicação tomada agora';

  @override
  String get voiceSave => 'Salvar na crise';

  @override
  String widgetLevel(String level) {
    return 'Nível: $level';
  }

  @override
  String get widgetNoLevel => 'Abra o app para carregar o nível de hoje';

  @override
  String widgetDriver(String factor) {
    return 'Principal fator: $factor';
  }

  @override
  String get widgetNoDriver => 'Nenhum fator se destaca';

  @override
  String widgetPressureFalling(String pressure) {
    return 'Pressão caindo $pressure em 24 h';
  }

  @override
  String widgetPressureRising(String pressure) {
    return 'Pressão subindo $pressure em 24 h';
  }

  @override
  String get widgetPressureSteady => 'Pressão estável';

  @override
  String get widgetPressureUnknown => 'Ainda sem previsão de pressão';

  @override
  String widgetUpdated(String time) {
    return 'Atualizado $time';
  }

  @override
  String get widgetStartAttack => 'Iniciar crise';

  @override
  String get widgetOpenAttack => 'Abrir crise';

  @override
  String get watchStart => 'Iniciar crise';

  @override
  String get watchStop => 'Encerrar crise';

  @override
  String get watchIntensity => 'Intensidade';

  @override
  String watchSince(String time) {
    return 'Desde $time';
  }

  @override
  String get watchPending =>
      'Salvo no relógio. Será enviado quando o celular estiver perto.';

  @override
  String get watchNoPhone =>
      'Abra o app no celular uma vez para conectar o relógio.';

  @override
  String get routinesTitle => 'Rotinas de autocuidado';

  @override
  String get routinesIntro =>
      'Coisas simples que muitas pessoas acham úteis nos dias difíceis. Use o que fizer sentido para você e pule o resto.';

  @override
  String get routineCardTitle => 'Algo que pode ajudar hoje';

  @override
  String get routineNotToday => 'Hoje não';

  @override
  String get routineSeeAll => 'Todas as rotinas';

  @override
  String get routineStepsTitle => 'Como fazer';

  @override
  String get routineReasonHighDay => 'O nível de hoje está alto';

  @override
  String get routineReasonNeckTension =>
      'Seu registro mostra tensão no pescoço';

  @override
  String get routineReasonStress => 'Seu registro mostra estresse alto';

  @override
  String get routineStretchesTitle => 'Alongamentos leves de pescoço e ombros';

  @override
  String get routineStretchesSummary =>
      'Cinco movimentos lentos para aliviar a tensão no pescoço e nos ombros. Pare se algo doer.';

  @override
  String get routineStretchesSteps =>
      'Sente-se com a coluna ereta, os ombros relaxados e os pés apoiados.\nIncline devagar a orelha direita em direção ao ombro direito. Segure por 15 segundos e troque de lado.\nAbaixe o queixo em direção ao peito e segure por 15 segundos.\nGire os ombros para trás cinco vezes e depois para a frente cinco vezes.\nEntrelace as mãos atrás das costas e abra o peito com suavidade por 15 segundos.';

  @override
  String get routineBreathingTitle => 'Respiração ritmada';

  @override
  String get routineBreathingSummary =>
      'Inspire por 4 segundos e expire por 6, por cerca de um minuto. Uma expiração lenta ajuda muitas pessoas a se acalmar.';

  @override
  String get routineBreathingSteps =>
      'Sente-se ou deite-se em um lugar confortável.\nInspire pelo nariz enquanto o círculo cresce.\nExpire devagar enquanto ele diminui.\nContinue por seis rodadas, ou pelo tempo que for bom.';

  @override
  String get routineLowLightTitle => 'Pouca luz e silêncio';

  @override
  String get routineLowLightSummary =>
      'Luz forte e barulho incomodam muitas pessoas em dias sensíveis e durante uma crise.';

  @override
  String get routineLowLightSteps =>
      'Diminua as luzes ou feche as cortinas.\nAtive o modo escuro e reduza o brilho da tela.\nUse uma máscara de dormir ou óculos de sol se a luz ainda incomodar.\nReduza o barulho com protetores de ouvido ou um cômodo silencioso.';

  @override
  String get routineHydrationTitle => 'Beba um pouco de água';

  @override
  String get routineHydrationSummary =>
      'Deixar água por perto facilita beber ao longo do dia.';

  @override
  String get routineHydrationSteps =>
      'Deixe um copo ou uma garrafa de água por perto.\nTome alguns goles a cada hora.\nBeba um copo de água em cada refeição.';

  @override
  String get routineCaffeineTitle => 'Mantenha a cafeína estável';

  @override
  String get routineCaffeineSummary =>
      'Grandes mudanças na quantidade de cafeína podem fazer diferença para algumas pessoas.';

  @override
  String get routineCaffeineSteps =>
      'Consuma cafeína mais ou menos nos mesmos horários todos os dias.\nEvite grandes aumentos e evite pular de repente a quantidade habitual.\nTome a última bebida com cafeína até o começo da tarde.';

  @override
  String get routineSleepTitle => 'Sono regular';

  @override
  String get routineSleepSummary =>
      'Um horário de sono regular, inclusive nos fins de semana, ajuda muitas pessoas.';

  @override
  String get routineSleepSteps =>
      'Deite-se e levante-se mais ou menos no mesmo horário todos os dias.\nMantenha o quarto escuro, silencioso e fresco.\nGuarde as telas 30 minutos antes de dormir.\nEvite cochilos longos no fim do dia.';

  @override
  String get breathingStart => 'Começar a respirar';

  @override
  String get breathingStop => 'Parar';

  @override
  String get breathingIn => 'Inspire';

  @override
  String get breathingOut => 'Expire';

  @override
  String breathingRound(int round, int total) {
    return 'Rodada $round de $total';
  }

  @override
  String get breathingDone => 'Pronto. Espere um momento antes de se levantar.';

  @override
  String get settingsRoutinesHint =>
      'Alongamentos, respiração e outras rotinas simples';

  @override
  String get experimentsTitle => 'Experimentos';

  @override
  String get settingsExperimentsHint =>
      'Teste uma mudança por duas semanas e compare';

  @override
  String get experimentsIntro =>
      'Teste uma mudança por duas semanas e compare com as duas semanas anteriores. Um experimento por vez.';

  @override
  String get experimentsPick => 'Escolha uma mudança';

  @override
  String get experimentChangeCutCaffeine => 'Reduzir a cafeína';

  @override
  String get experimentChangeRegularSleep =>
      'Deitar no mesmo horário toda noite';

  @override
  String get experimentChangeMoreWater => 'Beber mais água';

  @override
  String get experimentChangeDailyStretches => 'Alongar o pescoço todo dia';

  @override
  String get experimentChangeLessScreens => 'Menos telas à noite';

  @override
  String get experimentChangeNoAlcohol => 'Ficar sem álcool';

  @override
  String experimentDay(int day, int total) {
    return 'Dia $day de $total';
  }

  @override
  String get experimentAdherenceQuestion => 'Você conseguiu seguir hoje?';

  @override
  String get experimentYes => 'Sim';

  @override
  String get experimentNo => 'Não';

  @override
  String experimentAdherence(int kept, int days) {
    return 'Seguiu em $kept de $days dias';
  }

  @override
  String get experimentCompareTitle => 'Duas semanas antes e durante';

  @override
  String get experimentBefore => 'Antes';

  @override
  String get experimentDuring => 'Durante';

  @override
  String get experimentRowRate => 'Crises por semana';

  @override
  String get experimentRowIntensity => 'Intensidade média';

  @override
  String get experimentRowDuration => 'Duração mediana';

  @override
  String experimentSample(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'de $count crises',
      one: 'de 1 crise',
      zero: 'nenhuma crise',
    );
    return '$_temp0';
  }

  @override
  String experimentDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String get experimentNoData => 'Sem dados';

  @override
  String get experimentCaveat =>
      'Duas semanas é pouco tempo. O tempo, as estações e o estresse mudam sozinhos, então veja isto como uma pista, não uma prova.';

  @override
  String experimentSmallSample(int min) {
    return 'Menos de $min crises em um dos períodos, então os números podem variar muito.';
  }

  @override
  String get experimentStop => 'Parar experimento';

  @override
  String get experimentFinish => 'Concluir e salvar o resultado';

  @override
  String get experimentDue => 'As duas semanas terminaram.';

  @override
  String get experimentPast => 'Experimentos anteriores';

  @override
  String experimentFinished(String date) {
    return 'Concluído em $date';
  }

  @override
  String experimentStopped(String date) {
    return 'Parado em $date';
  }

  @override
  String experimentPastSummary(String before, String during) {
    return '$before crises por semana antes, $during durante';
  }

  @override
  String get accountTitle => 'Conta';

  @override
  String get settingsAccountHint =>
      'Opcional. Só é necessária para backup e links';

  @override
  String get accountIntro =>
      'A conta é opcional. Tudo no app funciona sem ela, e seus registros ficam neste celular. Ela só é necessária para o backup criptografado e os links de compartilhamento.';

  @override
  String get accountUnavailable =>
      'As contas não estão configuradas nesta versão.';

  @override
  String get accountApple => 'Continuar com a Apple';

  @override
  String get accountGoogle => 'Continuar com o Google';

  @override
  String get accountOrEmail => 'Ou use seu e-mail';

  @override
  String get accountEmail => 'E-mail';

  @override
  String get accountPassword => 'Senha';

  @override
  String accountPasswordHint(int min) {
    return 'Pelo menos $min caracteres para uma conta nova';
  }

  @override
  String get accountSignIn => 'Entrar';

  @override
  String get accountCreate => 'Criar conta';

  @override
  String get accountForgot => 'Esqueceu a senha?';

  @override
  String get accountResetSent =>
      'Se esse e-mail tiver uma conta, um link de redefinição está a caminho.';

  @override
  String accountSignedInAs(String email) {
    return 'Conectado como $email';
  }

  @override
  String accountSignedInWith(String method) {
    return 'Conectado com $method';
  }

  @override
  String get accountMethodApple => 'Apple';

  @override
  String get accountMethodGoogle => 'Google';

  @override
  String get accountMethodEmail => 'e-mail';

  @override
  String get accountSignedInNote =>
      'Seus registros continuam neste celular. Sair não apaga nada.';

  @override
  String get accountSignOut => 'Sair';

  @override
  String get accountDelete => 'Excluir conta';

  @override
  String get accountDeleteTitle => 'Excluir sua conta?';

  @override
  String accountDeleteBody(int hours) {
    return 'Isto exclui sua conta. Em até $hours horas, seu backup criptografado e os links compartilhados são removidos dos nossos servidores. Tudo neste celular continua aqui.';
  }

  @override
  String get accountDeletePassword => 'Digite sua senha para confirmar';

  @override
  String get accountDeleteSubscription =>
      'A assinatura Premium é cobrada pela App Store ou pelo Google Play. Excluir a conta não a cancela; cancele na loja.';

  @override
  String get accountDeleteCancel => 'Manter conta';

  @override
  String accountDeleted(int hours) {
    return 'Conta excluída. Os dados no servidor serão apagados em até $hours horas.';
  }

  @override
  String get accountErrorWrongCredentials =>
      'Esse e-mail e essa senha não conferem.';

  @override
  String get accountErrorEmailInUse =>
      'Esse e-mail já tem uma conta. Tente entrar.';

  @override
  String get accountErrorWeakPassword => 'Escolha uma senha mais longa.';

  @override
  String get accountErrorInvalidEmail => 'Verifique o endereço de e-mail.';

  @override
  String get accountErrorNetwork =>
      'Sem conexão. Tente de novo quando estiver on-line.';

  @override
  String get accountErrorRecentSignIn =>
      'Por segurança, entre de novo e tente mais uma vez.';

  @override
  String get accountErrorUnknown => 'Algo deu errado. Tente de novo.';

  @override
  String get backupTitle => 'Backup criptografado';

  @override
  String get settingsBackupHint =>
      'Protegido por uma frase-senha que só você conhece';

  @override
  String get backupIntro =>
      'Seu backup é criptografado neste celular com sua frase-senha antes de ser enviado. Guardamos só o arquivo criptografado e não conseguimos abri-lo.';

  @override
  String get backupForgetWarning =>
      'Se você esquecer a frase-senha, ninguém conseguirá abrir o backup, nem nós. Anote-a em um lugar seguro.';

  @override
  String get backupNeedsAccount =>
      'O backup precisa de uma conta. Todo o resto funciona sem ela.';

  @override
  String get backupOpenAccount => 'Criar uma conta';

  @override
  String get backupNone => 'Nenhum backup ainda';

  @override
  String backupLast(String date) {
    return 'Último backup: $date';
  }

  @override
  String get backupStatusUnknown =>
      'Não foi possível verificar o backup agora.';

  @override
  String get backupPassphrase => 'Frase-senha';

  @override
  String backupPassphraseHint(int min) {
    return 'Pelo menos $min caracteres. Algumas palavras sem relação entre si funcionam bem.';
  }

  @override
  String get backupPassphraseRepeat =>
      'Repita a frase-senha para fazer o backup';

  @override
  String get backupNow => 'Fazer backup agora';

  @override
  String get backupDone => 'Backup feito.';

  @override
  String get backupRestore => 'Restaurar do backup';

  @override
  String get backupRestoreTitle => 'Substituir tudo neste celular?';

  @override
  String backupRestoreBody(String date) {
    return 'Tudo neste celular será substituído pelo backup de $date.';
  }

  @override
  String get backupRestoreConfirm => 'Restaurar';

  @override
  String get backupRestored => 'Restaurado do seu backup.';

  @override
  String get backupDelete => 'Excluir backup';

  @override
  String get backupDeleteTitle => 'Excluir o backup?';

  @override
  String get backupDeleteBody =>
      'O arquivo criptografado é removido dos nossos servidores. Tudo neste celular continua aqui.';

  @override
  String get backupDeleted => 'Backup excluído.';

  @override
  String get backupWorking => 'Trabalhando nisso. Pode levar alguns segundos.';

  @override
  String get backupErrorMismatch => 'As duas frases-senha não conferem.';

  @override
  String backupErrorShort(int min) {
    return 'Use pelo menos $min caracteres.';
  }

  @override
  String get backupErrorNoBackup => 'Ainda não há backup nesta conta.';

  @override
  String get backupErrorTooLarge => 'O backup é grande demais para enviar.';

  @override
  String get backupErrorNewerApp =>
      'Este backup foi feito por uma versão mais nova do app. Atualize o app e tente de novo.';

  @override
  String get backupErrorWrongPassphrase =>
      'Essa frase-senha não abre este backup.';

  @override
  String get backupErrorDamaged => 'O arquivo de backup está danificado.';

  @override
  String get backupErrorPinning =>
      'Não foi possível verificar a conexão com o servidor de backup, então nada foi enviado. Tente outra rede.';

  @override
  String get backupErrorNotAllowed =>
      'Sua sessão expirou. Entre de novo e tente outra vez.';

  @override
  String get shareLinkButton => 'Compartilhar como link';

  @override
  String get shareLinkTitle => 'Compartilhar com seu profissional de saúde';

  @override
  String get shareLinkExplain =>
      'Qualquer pessoa com o link pode ler este relatório até ele expirar. Ele mostra o mesmo resumo do PDF, não o seu diário. Você pode parar de compartilhar a qualquer momento.';

  @override
  String get shareLinkNeedsAccount =>
      'Compartilhar um link precisa de uma conta. O PDF e o CSV funcionam sem ela.';

  @override
  String shareLinkDuration(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String get shareLinkCreate => 'Criar link';

  @override
  String get shareLinkWorking => 'Criando o link.';

  @override
  String shareLinkReady(String date) {
    return 'Link pronto. Compartilhado até $date.';
  }

  @override
  String get shareLinkCopy => 'Copiar link';

  @override
  String get shareLinkCopied => 'Link copiado.';

  @override
  String get shareLinkShare => 'Compartilhar link';

  @override
  String shareLinkMessage(String url) {
    return 'Meu relatório de enxaqueca: $url';
  }

  @override
  String get shareLinksTitle => 'Links compartilhados';

  @override
  String get settingsShareLinksHint =>
      'Veja e interrompa os links de relatório que você compartilhou';

  @override
  String get shareLinksEmpty =>
      'Você não compartilhou nenhum link. Crie um no relatório para o médico.';

  @override
  String shareLinkActiveUntil(String date) {
    return 'Compartilhado até $date';
  }

  @override
  String shareLinkExpiredOn(String date) {
    return 'Expirou em $date';
  }

  @override
  String get shareLinkRevoked => 'Compartilhamento interrompido';

  @override
  String shareLinkCreatedOn(String date) {
    return 'Criado em $date';
  }

  @override
  String get shareLinkRevoke => 'Parar de compartilhar';

  @override
  String get shareLinkRevokeTitle => 'Parar de compartilhar este relatório?';

  @override
  String get shareLinkRevokeBody =>
      'O link para de funcionar na hora, para todos que o têm.';

  @override
  String get shareLinkRevokedDone =>
      'Compartilhamento interrompido. O link não funciona mais.';

  @override
  String get shareLinkErrorUnavailable =>
      'Os links de compartilhamento não estão configurados nesta versão.';

  @override
  String get shareLinkErrorSignedOut =>
      'Sua sessão expirou. Entre de novo e tente outra vez.';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumIntro =>
      'O Premium adiciona quatro extras. Todo o resto continua gratuito, sem limite de tempo.';

  @override
  String get premiumFreeNote =>
      'Sempre gratuito: registrar crises e registros diários, o tempo, o nível de risco, seus fatores, o registro de medicação e o relatório para o médico.';

  @override
  String get premiumFeatureShareLink => 'Link para o profissional de saúde';

  @override
  String get premiumFeatureShareLinkHint =>
      'Envie seu relatório como um link que para de funcionar após 7 ou 30 dias.';

  @override
  String get premiumFeatureExperiments => 'Experimentos';

  @override
  String get premiumFeatureExperimentsHint =>
      'Teste uma mudança por duas semanas e compare com as semanas anteriores.';

  @override
  String get premiumFeatureExtendedFactors => 'Fatores ambientais ampliados';

  @override
  String get premiumFeatureExtendedFactorsHint =>
      'Partículas, ozônio e pólen por tipo.';

  @override
  String get premiumFeatureBackup => 'Backup entre celulares';

  @override
  String get premiumFeatureBackupHint =>
      'Um backup criptografado que você pode restaurar em um celular novo.';

  @override
  String get premiumActive => 'O Premium está ativo.';

  @override
  String premiumRenews(String date) {
    return 'Renova em $date.';
  }

  @override
  String premiumEnds(String date) {
    return 'Termina em $date.';
  }

  @override
  String get premiumManage => 'Gerenciar assinatura';

  @override
  String premiumOfferMonthly(String price) {
    return 'Mensal, $price';
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
      'Nenhuma compra Premium foi encontrada para esta conta da loja.';

  @override
  String get premiumThanks => 'Obrigado. O Premium está ativo.';

  @override
  String get premiumRenewalTerms =>
      'As assinaturas são renovadas automaticamente até você cancelar nas configurações da loja. Cancele pelo menos 24 horas antes da data de renovação para evitar a próxima cobrança.';

  @override
  String get premiumLoadingOffers => 'Carregando preços.';

  @override
  String get premiumNoOffers =>
      'Não foi possível carregar os preços. Verifique a conexão e tente de novo.';

  @override
  String get premiumRetry => 'Tentar de novo';

  @override
  String get premiumUnavailable =>
      'As compras não estão configuradas nesta versão.';

  @override
  String get premiumDevUnlocked =>
      'Versão de desenvolvimento: todos os recursos Premium estão liberados.';

  @override
  String get premiumAccountTip =>
      'Usa mais de um celular? Entre primeiro, para o Premium acompanhar sua conta.';

  @override
  String get premiumErrorNotAllowed =>
      'Esta conta da loja não pode fazer compras.';

  @override
  String get premiumErrorPending =>
      'A compra está aguardando aprovação. O Premium será ativado quando ela for concluída.';

  @override
  String get premiumErrorStore =>
      'A loja teve um problema. Tente de novo mais tarde.';

  @override
  String premiumLockTitle(String feature) {
    return '$feature vem com o Premium.';
  }

  @override
  String get premiumLockButton => 'Ver o Premium';

  @override
  String get premiumLockShareLinkNote =>
      'Os links que você já criou continuam funcionando até expirar, e você pode parar de compartilhá-los a qualquer momento.';

  @override
  String get premiumLockExperimentsNote =>
      'Seus resultados anteriores continuam aqui.';

  @override
  String get premiumLockBackupNote =>
      'Você ainda pode restaurar ou excluir um backup que já tenha.';

  @override
  String get premiumFactorsLocked =>
      'Partículas, ozônio e pólen vêm com o Premium.';

  @override
  String get settingsPremiumHint =>
      'Link de compartilhamento, experimentos, fatores ampliados e backup';

  @override
  String get settingsPremiumActive => 'Ativo';

  @override
  String get shareLinkErrorPremium =>
      'Links de compartilhamento precisam do Premium. Se você acabou de assinar, espere um minuto e tente de novo.';

  @override
  String get auditTitle => 'Como o nível de risco se saiu';

  @override
  String auditNotYet(int needed, int logged) {
    return 'Esta página aparece quando você tiver registrado $needed crises. Até agora você registrou $logged.';
  }

  @override
  String auditIntro(int window) {
    String _temp0 = intl.Intl.pluralLogic(
      window,
      locale: localeName,
      other: 'os $window dias anteriores',
      one: 'o dia anterior',
    );
    return 'Isto compara o nível que o app mostrou em cada dia com o momento em que suas crises começaram. Uma crise conta como posterior a um dia Alto quando o dia em que começou ou $_temp0 foi mostrado como Alto.';
  }

  @override
  String get auditEmpty =>
      'Nada para comparar ainda. A partir de agora o app guarda o nível que mostra em cada dia, e os primeiros números aparecem depois da sua próxima crise ou do próximo dia Alto.';

  @override
  String get auditHitsTitle => 'Crises que vieram depois de um dia Alto';

  @override
  String auditHitsValue(int hits, int attacks, String share) {
    return '$hits de $attacks ($share)';
  }

  @override
  String get auditMissesTitle => 'Crises sem um dia Alto antes';

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
  String get auditFalseAlarmsTitle => 'Dias Altos sem crise';

  @override
  String auditFalseAlarmsValue(int count, int highDays) {
    return '$count de $highDays dias Altos';
  }

  @override
  String get auditTrend => 'Por mês';

  @override
  String auditMonthLine(int hits, int attacks, int falseAlarms, int highDays) {
    return '$hits de $attacks crises depois de um dia Alto; $falseAlarms de $highDays dias Altos sem crise';
  }

  @override
  String get auditCaveat =>
      'Números pequenos variam muito de um mês para outro. Um dia Alto sem crise não é um erro: significa que mais dos seus gatilhos habituais se juntaram. O nível é um guia para se planejar, não uma promessa.';

  @override
  String get auditShare => 'Compartilhar estes números todo mês';

  @override
  String get auditShareHint =>
      'Ajuda a avaliar o app para todos. Só os cinco números e a versão do modelo são enviados, nunca datas, lugares, seu registro ou sua conta. Desativado a menos que você ative.';

  @override
  String get settingsAuditHint =>
      'Crises depois de dias Altos e dias Altos sem crise';

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
  String get settingsUnitsHint => 'Pressão e temperatura';

  @override
  String get unitsPressure => 'Pressão';

  @override
  String get unitsTemperature => 'Temperatura';

  @override
  String get unitNameHpa => 'Hectopascais (hPa)';

  @override
  String get unitNameInHg => 'Polegadas de mercúrio (inHg)';

  @override
  String get unitNameMmHg => 'Milímetros de mercúrio (mmHg)';

  @override
  String get unitNameCelsius => 'Celsius (°C)';

  @override
  String get unitNameFahrenheit => 'Fahrenheit (°F)';

  @override
  String get unitsNote =>
      'A primeira escolha vem da região do seu celular. Mudar só altera como os valores aparecem; seu registro continua igual.';

  @override
  String envTemperatureNow(String temperature) {
    return 'Temperatura agora: $temperature';
  }

  @override
  String get questionnaireEnglishNote =>
      'As perguntas aparecem no texto original em inglês até que uma tradução validada seja adicionada, para que suas pontuações continuem comparáveis.';

  @override
  String get wellnessDisclaimer =>
      'Informações gerais de bem-estar, não aconselhamento médico. Fale com seu profissional de saúde sobre o tratamento.';

  @override
  String get dataSourceWeather => 'Tempo do Open-Meteo';

  @override
  String get dataSourceAirQuality =>
      'Qualidade do ar e UV do Open-Meteo (CAMS)';

  @override
  String get dataSourcePollen => 'Pólen do Open-Meteo (CAMS)';

  @override
  String get dataSourceGeocoding => 'Geocodificação do Open-Meteo';

  @override
  String get dataSourceBarometer => 'Barômetro do aparelho';

  @override
  String get dataCoverageWorldwide => 'Mundo todo';

  @override
  String get dataCoverageEuropeanAqi => 'Mundo todo, IQA europeu na Europa';

  @override
  String get dataCoverageEurope => 'Só na Europa';

  @override
  String get dataCoverageBarometer => 'Celulares com sensor de pressão';

  @override
  String get settingsReduceMotion => 'Reduzir movimento';

  @override
  String get settingsReduceMotionHint =>
      'Menos animações, mesmo com a opção do celular desativada';
}
