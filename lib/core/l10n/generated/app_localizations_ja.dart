// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Migraine Tracker';

  @override
  String get homeEmptyState => 'まだ記録がありません。\nリスクレベルと周囲の環境がここに表示されます。';

  @override
  String get riskLevelLow => '低';

  @override
  String get riskLevelModerate => '中';

  @override
  String get riskLevelHigh => '高';

  @override
  String get devThemeGalleryTitle => 'テーマギャラリー';

  @override
  String get devThemeLight => 'ライトテーマ';

  @override
  String get devThemeDark => 'ダークテーマ';

  @override
  String get devThemeAttack => '発作中テーマ';

  @override
  String get devSampleBody => '標準サイズの本文です。文字サイズ200%でも切れずに読める必要があります。';

  @override
  String get devSamplePrimary => 'メイン';

  @override
  String get devSampleSecondary => 'サブ';

  @override
  String get devSampleText => 'テキスト';

  @override
  String get devSampleDisabled => '無効';

  @override
  String get devSampleChipOn => '前兆';

  @override
  String get devSampleChipOff => '吐き気';

  @override
  String get devSampleChipIcon => '光';

  @override
  String get devSampleSlider => '強さ';

  @override
  String get devSampleSliderLow => '痛みなし';

  @override
  String get devSampleSliderHigh => '最悪';

  @override
  String get devSampleCard => 'バッジ付きのカード';

  @override
  String get attackStart => '発作を記録';

  @override
  String get attackContinue => '発作の記録を続ける';

  @override
  String get attackTitleRunning => '発作中';

  @override
  String get attackTitleEnded => '発作';

  @override
  String attackStartedAt(String time) {
    return '$timeに開始';
  }

  @override
  String get attackNotFound => 'この発作の記録はもうありません。';

  @override
  String get attackIntensity => '痛みの強さ';

  @override
  String get durationEstimateTitle => 'このような発作の通常の長さ';

  @override
  String durationEstimateRange(String low, String high) {
    return '通常$low〜$high時間';
  }

  @override
  String durationEstimateSameMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '同じ薬を使った同程度の強さの過去の発作$count回に基づく',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateNoMedication(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '薬を使わなかった同程度の強さの過去の発作$count回に基づく',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateSimilar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '同程度の強さの過去の発作$count回に基づく',
    );
    return '$_temp0';
  }

  @override
  String durationEstimateAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '過去の発作$count回に基づく',
    );
    return '$_temp0';
  }

  @override
  String get attackIntensityLow => '痛みなし';

  @override
  String get attackIntensityHigh => '最悪';

  @override
  String get attackWhereItHurts => '痛む場所';

  @override
  String get attackSymptoms => '症状';

  @override
  String get attackPhases => '段階';

  @override
  String get attackNotes => 'メモ';

  @override
  String get attackNotesHint => 'ほかに覚えておきたいこと';

  @override
  String get attackEnd => '発作を終了';

  @override
  String get attackDone => '完了';

  @override
  String get attackFinishLater => 'あとで入力';

  @override
  String get symptomAura => '前兆（オーラ）';

  @override
  String get symptomNeckTension => '首のこり';

  @override
  String get symptomLightSensitivity => '光';

  @override
  String get symptomSoundSensitivity => '音';

  @override
  String get symptomSmellSensitivity => 'におい';

  @override
  String get symptomNausea => '吐き気';

  @override
  String get phaseProdrome => '予兆期';

  @override
  String get phaseAura => '前兆期';

  @override
  String get phaseAttack => '頭痛期';

  @override
  String get phasePostdrome => '回復期';

  @override
  String get headForehead => '額';

  @override
  String get headLeftTemple => '左のこめかみ';

  @override
  String get headRightTemple => '右のこめかみ';

  @override
  String get headBehindEyes => '目の奥';

  @override
  String get headLeftSide => '左側';

  @override
  String get headRightSide => '右側';

  @override
  String get headTopOfHead => '頭頂部';

  @override
  String get headBackOfHead => '後頭部';

  @override
  String get headNeck => '首';

  @override
  String get checkinTitle => '毎日のチェックイン';

  @override
  String get checkinLoadError => 'この日を読み込めませんでした。';

  @override
  String get checkinIntro => '3回タップ。どうでしたか？';

  @override
  String get checkinComplete => 'この日は入力済みです。変更するには数字をタップしてください。';

  @override
  String get checkinAddMore => 'さらに追加（任意）';

  @override
  String get checkinOptionalTitle => '任意';

  @override
  String get checkinDone => '完了';

  @override
  String get checkinToday => '今日';

  @override
  String get checkinSleepQuality => '睡眠の質';

  @override
  String get checkinStress => 'ストレス';

  @override
  String get checkinNeckTension => '首のこり';

  @override
  String get checkinCaffeine => 'カフェイン';

  @override
  String get checkinHydration => '水分';

  @override
  String get checkinAlcohol => 'アルコール';

  @override
  String get checkinLightExposure => '強い光';

  @override
  String get checkinScreenExposure => '画面を見た時間';

  @override
  String get checkinSleepLow => '悪い';

  @override
  String get checkinSleepHigh => 'とても良い';

  @override
  String get checkinStressLow => '落ち着いている';

  @override
  String get checkinStressHigh => 'とても強い';

  @override
  String get checkinNeckLow => '楽';

  @override
  String get checkinNeckHigh => 'とても硬い';

  @override
  String get checkinHydrationLow => '少ない';

  @override
  String get checkinHydrationHigh => '十分';

  @override
  String get checkinExposureLow => '少ない';

  @override
  String get checkinExposureHigh => '多い';

  @override
  String get checkinNone => 'なし';

  @override
  String checkinCupsOrMore(int count) {
    return '$count杯以上';
  }

  @override
  String checkinDrinksOrMore(int count) {
    return '$count杯以上';
  }

  @override
  String checkinValueSemantics(String field, int value, int max) {
    return '$field、$max中$value';
  }

  @override
  String get checkinReminderTooltip => 'リマインダーの時刻';

  @override
  String checkinReminderAt(String time) {
    return '$timeにリマインド';
  }

  @override
  String get checkinReminderPickerTitle => '毎日のチェックインのリマインダー';

  @override
  String get checkinCardTitle => '毎日のチェックイン';

  @override
  String get checkinCardDone => '今日は入力済み';

  @override
  String get checkinCardTodo => '3回タップ、約10秒';

  @override
  String get medicationTitle => '薬';

  @override
  String get medicationAdd => '薬を追加';

  @override
  String get medicationAddTitle => '服用を記録';

  @override
  String get medicationName => '薬';

  @override
  String get medicationDose => '用量';

  @override
  String get medicationDoseHint => '例：400 mg';

  @override
  String get medicationKindAcute => '頓服';

  @override
  String get medicationKindPreventive => '予防';

  @override
  String medicationTakenAt(String time) {
    return '$timeに服用';
  }

  @override
  String get medicationLog => '記録';

  @override
  String get medicationDelete => '削除';

  @override
  String get medicationThisMonth => '今月';

  @override
  String get medicationEmpty => '今月の服用記録はありません。';

  @override
  String get medicationReliefQuestion => '2時間後に楽になりましたか？';

  @override
  String get medicationReliefNone => 'なし';

  @override
  String get medicationReliefPartial => '少し';

  @override
  String get medicationReliefFull => '完全に';

  @override
  String medicationAcuteDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '今月の頓服薬の日：$count日',
      zero: '今月の頓服薬の日はありません',
    );
    return '$_temp0';
  }

  @override
  String get medicationAcuteDaysHint => '頓服薬を1回以上服用した日数を、暦月ごとに数えます。';

  @override
  String medicationOveruseFirstNote(int days) {
    return '今月、頓服薬を使った日が$days日になりました。この日数を少なく保つことを勧める医療者は多く、相談してみる価値があるかもしれません。';
  }

  @override
  String medicationOveruseSecondNote(int days) {
    return '今月、頓服薬を使った日が$days日になりました。このパターンについて医師に相談することを検討してください。';
  }

  @override
  String get medicationTalkToClinician => '医師に相談する';

  @override
  String get cycleTitle => '月経周期';

  @override
  String get cycleToggleTitle => '周期を記録する';

  @override
  String get cycleToggleSubtitle =>
      '初期設定はオフです。オンにすると、周期の日がチェックインごとに保存され、要因として使われます。';

  @override
  String get cycleNoData => '周期の日を見るには月経の開始日を記録してください。';

  @override
  String cycleDayAndPhase(int day, String phase) {
    return '周期$day日目・$phase';
  }

  @override
  String cycleLength(int days) {
    return '$days日周期に基づく';
  }

  @override
  String get cyclePeriodStarts => '月経の開始日';

  @override
  String get cycleNoStarts => 'まだ記録がありません。';

  @override
  String get cycleRemoveStart => '削除';

  @override
  String get cyclePeriodStartedToday => 'この日に月経が始まった';

  @override
  String get cyclePhaseMenstrual => '月経期';

  @override
  String get cyclePhaseFollicular => '卵胞期';

  @override
  String get cyclePhaseOvulation => '排卵期の前後';

  @override
  String get cyclePhaseLuteal => '黄体期';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSectionDaily => '毎日';

  @override
  String get settingsSectionData => 'あなたのデータ';

  @override
  String get settingsSectionAbout => '情報';

  @override
  String get settingsExportJson => 'JSONで書き出す';

  @override
  String get settingsExportJsonHint => 'すべての表を、再度読み込める1つのファイルにまとめます。';

  @override
  String get settingsExportCsv => 'CSVで書き出す';

  @override
  String get settingsExportCsvHint => '表ごとに1つのスプレッドシートファイル。';

  @override
  String get settingsExportEmpty => '書き出すデータはまだありません。';

  @override
  String get settingsDeleteAll => 'すべて削除';

  @override
  String get settingsDeleteAllHint => 'この端末からすべてのデータを削除します。元に戻せません。';

  @override
  String settingsDeleteAllConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'この端末から$count件の記録を削除します。元に戻せません。',
      zero: 'まだ何も保存されていません。それでも削除しますか？',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeleteAllButton => '削除';

  @override
  String get settingsCancel => 'キャンセル';

  @override
  String get settingsDeletedAll => 'すべてのデータを削除しました。';

  @override
  String get settingsPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get settingsTerms => '利用規約';

  @override
  String get settingsSupport => 'サポート';

  @override
  String get environmentTitle => '環境';

  @override
  String get environmentCardTitle => '気圧';

  @override
  String get environmentCardEmpty => '天気データがまだありません。タップして場所を設定してください。';

  @override
  String environmentCardSummary(String pressure, String trend) {
    return '$pressure、$trend';
  }

  @override
  String get envPressureSection => '気圧';

  @override
  String get envPressureUnknown => 'この時間の値はありません';

  @override
  String get envDelta3h => '3時間';

  @override
  String get envDelta6h => '6時間';

  @override
  String get envDelta12h => '12時間';

  @override
  String get envDelta24h => '24時間';

  @override
  String get envDeltaUnknown => '–';

  @override
  String get envChartTitle => '過去48時間と今後24時間';

  @override
  String get envUpdatedNever => 'まだ更新されていません';

  @override
  String get envUpdatedJustNow => 'たった今更新';

  @override
  String envUpdatedMinutes(int n) {
    return '$n分前に更新';
  }

  @override
  String envUpdatedHours(int n) {
    return '$n時間前に更新';
  }

  @override
  String envUpdatedDays(int n) {
    return '$n日前に更新';
  }

  @override
  String get envStale => 'この予報は数時間前のものです。オンラインに戻ると更新されます。';

  @override
  String get envOffline => '天気サービスに接続できませんでした。この端末に保存されたデータを表示しています。';

  @override
  String get envNoData => '天気データがまだありません。気圧の傾向を見るには、位置情報を許可するか都市を選んでください。';

  @override
  String get envRefresh => '更新';

  @override
  String get envLocationSection => '場所';

  @override
  String get envLocationGps => 'おおよその現在地を使用中';

  @override
  String envLocationManual(String city) {
    return '$cityを使用中';
  }

  @override
  String get envLocationLast => '最後にわかった地域を使用中';

  @override
  String get envLocationNone => '場所が設定されていません';

  @override
  String get envUseMyLocation => '現在地を使う';

  @override
  String get envChooseCity => '都市を選ぶ';

  @override
  String get envCitySearchTitle => '都市を選ぶ';

  @override
  String get envCitySearchHint => '都市名';

  @override
  String get envCityNoResults => '場所が見つかりません';

  @override
  String get envCitySearchFailed => '今は検索できません。接続を確認してもう一度お試しください。';

  @override
  String get envPrivacyNote => '位置情報は約10 km単位に丸めてから端末の外に送られます。';

  @override
  String get envAttribution => '天気データ：Open-Meteo';

  @override
  String get envTrendRising => '上昇中';

  @override
  String get envTrendFalling => '下降中';

  @override
  String get envTrendSteady => '安定';

  @override
  String get envTrendUnknown => '傾向はまだありません';

  @override
  String get barometerTitle => '気圧計';

  @override
  String get barometerOpen => '気圧計を開く';

  @override
  String get barometerNoReading => '値なし';

  @override
  String get barometerFromSensor => 'この端末のセンサーから';

  @override
  String get barometerFromStation => '最寄りの観測点から';

  @override
  String get barometerNoSource => 'この端末にはセンサーがなく、保存された予報もまだありません';

  @override
  String get barometerCalibrationSection => '補正';

  @override
  String barometerOffset(String offset, int pairs) {
    return '観測点との差は$offset（$pairs時間分のデータから算出）。';
  }

  @override
  String barometerNotCalibrated(int pairs) {
    return 'まだ補正されていません。センサーの値と観測点の値がそろった時間が少なくとも$pairs時間必要です。';
  }

  @override
  String get barometerTrendSection => 'この端末での過去24時間';

  @override
  String get barometerTrendEmpty => '測定はアプリを開いている間に行われます。傾向を見るには後でもう一度開いてください。';

  @override
  String barometerTrendSamples(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n件の測定',
    );
    return '$_temp0';
  }

  @override
  String get barometerStampNote => '発作を記録するたびに、その時間のセンサーの値と観測点の値が保存されます。';

  @override
  String get envFactorsTitle => '今日の要因';

  @override
  String get envFactorsEmpty => 'この地域の日ごとの要因はまだありません。';

  @override
  String get factorBandLow => '低い';

  @override
  String get factorBandModerate => 'やや高い';

  @override
  String get factorBandHigh => '高い';

  @override
  String get factorBandVeryHigh => '非常に高い';

  @override
  String factorValueWithBand(String value, String band) {
    return '$value（$band）';
  }

  @override
  String get factorAqiUs => '大気質（米国AQI）';

  @override
  String get factorAqiEu => '大気質（欧州AQI）';

  @override
  String get factorParticulates => '粒子状物質 PM2.5 / PM10';

  @override
  String factorParticulatesValue(String pm25, String pm10) {
    return '$pm25 / $pm10 µg/m³';
  }

  @override
  String get factorOzone => 'オゾン';

  @override
  String factorMicrograms(String value) {
    return '$value µg/m³';
  }

  @override
  String get factorPollen => '花粉（ヨーロッパのみ）';

  @override
  String factorPollenType(String type, String band) {
    return '$type $band';
  }

  @override
  String get pollenAlder => 'ハンノキ';

  @override
  String get pollenBirch => 'シラカバ';

  @override
  String get pollenGrass => 'イネ科';

  @override
  String get pollenMugwort => 'ヨモギ';

  @override
  String get pollenOlive => 'オリーブ';

  @override
  String get pollenRagweed => 'ブタクサ';

  @override
  String get factorUvMax => 'UV指数（1日の最大）';

  @override
  String get factorDaylight => '日照時間';

  @override
  String factorDaylightValue(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String get factorSun => '日の出と日の入り';

  @override
  String factorSunValue(String sunrise, String sunset) {
    return '$sunrise〜$sunset';
  }

  @override
  String get aboutDataTitle => 'データについて';

  @override
  String get aboutDataIntro => 'このアプリの数値がどこから来ているか、それぞれの数値から何がわかり、何がわからないか。';

  @override
  String get aboutDataSources => 'データ元';

  @override
  String aboutDataLicence(String coverage, String licence) {
    return '$coverage。ライセンス：$licence。';
  }

  @override
  String get aboutDataPrivacy => '端末の外に送られるもの';

  @override
  String get aboutDataPrivacyBody =>
      '天気サービスがあなたの地域について答えられるよう、約10 km単位に丸めた位置情報だけです。発作、チェックイン、薬、健康データは、バックアップや共有を選ばない限りこの端末に残ります。';

  @override
  String get aboutDataLimits => '限界';

  @override
  String get aboutDataLimitsBody =>
      '予報はグリッドの区画ごとのモデルによる推定値で、玄関先での実測ではありません。花粉はヨーロッパでのみ利用できます。大気質のデータがない地域もあります。あなたの地域にデータがない要因は表示されません。';

  @override
  String get settingsHealthHint => 'ヘルスケアアプリの睡眠、心拍数、歩数、周期';

  @override
  String get healthTitle => '健康データ';

  @override
  String healthIntro(String store) {
    return '$storeから読み取る項目を選んでください。項目ごとにスイッチと理由があります。';
  }

  @override
  String get healthPrivacyNote =>
      '読み込んだデータはこの端末に残ります。自分で書き出さない限り、バックアップも含めてアップロードされることはありません。';

  @override
  String get healthStoreApple => 'Appleヘルスケア';

  @override
  String get healthStoreConnect => 'ヘルスコネクト';

  @override
  String healthUnavailable(String store) {
    return 'この端末では$storeを利用できません。';
  }

  @override
  String get healthReadSection => '読み取り';

  @override
  String get healthTypeSleep => '睡眠';

  @override
  String get healthReasonSleep => '前夜の睡眠から毎日のチェックインの睡眠の質を入力し、タップを1回減らします。';

  @override
  String get healthTypeRestingHr => '安静時心拍数';

  @override
  String get healthReasonRestingHr => '安静時心拍数がいつもより高いと、発作の前日の負担を示していることがあります。';

  @override
  String get healthTypeHrv => '心拍変動';

  @override
  String get healthReasonHrv => '心拍変動がいつもより低いときは、ストレスや回復不足を伴うことが多いです。';

  @override
  String get healthTypeSteps => '歩数';

  @override
  String get healthReasonSteps => '活動量がとても少ない日や多い日は、発作と並べて見る価値があります。';

  @override
  String get healthTypeFlow => '月経の出血';

  @override
  String get healthReasonFlow => '周期の記録を使っている場合、月経の開始日を入力します。';

  @override
  String healthDenied(String store) {
    return '$storeへのアクセスが許可されませんでした。$storeの設定で変更できます。';
  }

  @override
  String get healthWriteSection => '書き込み';

  @override
  String healthWriteHeadaches(String store) {
    return '頭痛の記録を$storeに書き込む';
  }

  @override
  String get healthWriteHeadachesHint =>
      '終了した発作は、開始・終了・強さを含む頭痛として保存されます。それ以外は書き込まれません。';

  @override
  String get healthImportSection => '読み込み';

  @override
  String get healthImportNow => '今すぐ読み込む';

  @override
  String get healthImportNever => 'まだ何も読み込んでいません';

  @override
  String healthImportLast(String age) {
    return '$age';
  }

  @override
  String get healthImportFailed => '読み込みが完了しませんでした。後でもう一度お試しください。';

  @override
  String healthImportResult(int imported, int prefilled) {
    String _temp0 = intl.Intl.pluralLogic(
      imported,
      locale: localeName,
      other: '新しいデータ$imported件。',
      zero: '新しいデータはありません。',
    );
    String _temp1 = intl.Intl.pluralLogic(
      prefilled,
      locale: localeName,
      other: '$prefilled日分の睡眠を入力しました。',
      zero: '',
    );
    return '$_temp0$_temp1';
  }

  @override
  String get checkinSourceHealthkit => 'Appleヘルスケアから';

  @override
  String get checkinSourceHealthConnect => 'ヘルスコネクトから';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingFinish => '完了';

  @override
  String onboardingStep(int step, int total) {
    return 'ステップ $step/$total';
  }

  @override
  String get onboardingWelcomeTitle => 'ようこそ';

  @override
  String get onboardingLocationTitle => 'あなたの地域の天気';

  @override
  String get onboardingLocationBody =>
      '気圧の変化は、発作の前に気づく人が最も多いことのひとつです。おおよその位置情報を許可するか、都市を選んで確認しましょう。';

  @override
  String get onboardingLocationNone => '場所はまだ設定されていません。あとで環境画面から設定することもできます。';

  @override
  String get onboardingHealthTitle => '健康データ';

  @override
  String get onboardingHealthBody => '任意です。項目ごとにスイッチと理由があります。どれもあとで設定から変更できます。';

  @override
  String get onboardingHealthUnavailable =>
      'この端末で使えるヘルスケアアプリがありません。このステップはスキップできます。';

  @override
  String get onboardingReminderTitle => '毎日のチェックイン';

  @override
  String get onboardingReminderBody => '1日3回タップ、約10秒。リマインダーの時刻を選んでください。';

  @override
  String get onboardingReminderNote =>
      '通知の設定が済むとリマインダーが始まります。時刻はチェックイン画面からいつでも変更できます。';

  @override
  String get explainerTitle => 'レベルの意味';

  @override
  String get explainerIntro => 'アプリは毎日、あなた自身の記録と今日の状況からレベルを表示します。';

  @override
  String get explainerDoesTitle => 'できること';

  @override
  String get explainerDoes1 => '今日の天気、睡眠、ストレス、生活リズムが、過去の発作の前の日々と比べてどうかを示します。';

  @override
  String get explainerDoes2 => 'あなた自身の記録から学ぶので、記録するほど具体的になります。';

  @override
  String get explainerDoes3 => '今日は無理をしない日にするかどうか、判断の助けになります。';

  @override
  String get explainerDoesNotTitle => 'できないこと';

  @override
  String get explainerDoesNot1 =>
      '発作を知らせるものではありません。高いレベルは傾向であって確実ではなく、低いレベルも約束ではありません。';

  @override
  String get explainerDoesNot2 => '医学的な意見ではなく、医師の代わりにはなりません。';

  @override
  String get explainerDoesNot3 => '記録をどこにも送りません。レベルはこの端末で計算されます。';

  @override
  String get riskCardTitle => '今日のレベル';

  @override
  String get riskCardEmpty => 'レベルはまだありません。チェックインを追加するか、天気の読み込みを待ってください。';

  @override
  String get riskScreenTitle => 'あなたのレベル';

  @override
  String get riskWhyTitle => '理由';

  @override
  String get riskNoDrivers => '目立つ要因はありません。';

  @override
  String get riskNextDays => '今後の日々';

  @override
  String get riskDayToday => '今日';

  @override
  String get riskDayTomorrow => '明日';

  @override
  String riskLoad(String value) {
    return '負荷 $value/100';
  }

  @override
  String riskConfidence(String label) {
    return '確からしさ：$label';
  }

  @override
  String get riskConfidenceLow => '低';

  @override
  String get riskConfidenceMedium => '中';

  @override
  String get riskConfidenceHigh => '高';

  @override
  String riskStillLearning(int count, int needed) {
    return '学習中：発作の記録 $count/$needed回';
  }

  @override
  String get riskTuned => 'あなたの記録に合わせて調整済み';

  @override
  String riskDriverPoints(String points) {
    return '$pointsポイント';
  }

  @override
  String riskUpdated(String time) {
    return '$timeに更新';
  }

  @override
  String get riskExplainerLink => 'レベルの意味';

  @override
  String get riskOpenCheckin => '今日のチェックインを追加';

  @override
  String get riskFactorPressureDrop => '気圧の低下';

  @override
  String get riskFactorHumidity => '高い湿度';

  @override
  String get riskFactorTemperatureSwing => '気温の変化';

  @override
  String get riskFactorAirQuality => '大気質';

  @override
  String get riskFactorPollen => '花粉';

  @override
  String get riskFactorBrightLight => '強い光';

  @override
  String get riskFactorScreenTime => '画面を見た時間';

  @override
  String get riskFactorPoorSleep => '睡眠不足';

  @override
  String get riskFactorStress => 'ストレス';

  @override
  String get riskFactorNeckTension => '首のこり';

  @override
  String get riskFactorCaffeine => 'カフェイン';

  @override
  String get riskFactorAlcohol => 'アルコール';

  @override
  String get riskFactorDehydration => '水分不足';

  @override
  String get riskFactorCyclePhase => '周期の時期';

  @override
  String get loadMeterTitle => '負荷';

  @override
  String loadMeterSemantics(String value, String segments) {
    return '負荷 $value/100。$segments';
  }

  @override
  String loadSegmentDetail(String name, String points) {
    return '$name：$pointsポイント';
  }

  @override
  String loadThresholdModerate(String value) {
    return '$valueから中';
  }

  @override
  String loadThresholdHigh(String value) {
    return '$valueから高';
  }

  @override
  String get loadMeterEmpty => '負荷はまだありません';

  @override
  String get insightsTitle => 'あなたの要因';

  @override
  String get insightsIntro => 'あなた自身の記録で、各要因のあとに発作が起きた頻度を、ふだんの頻度と比べて示します。';

  @override
  String get insightsTriggers => 'あとに発作が多かった';

  @override
  String get insightsProtectors => 'あとに発作が少なかった';

  @override
  String get insightsNeutral => 'はっきりした影響なし';

  @override
  String get insightsNotEnough => 'まだデータが足りません';

  @override
  String get insightsEmptyBucket => 'まだ何もありません。';

  @override
  String insightsSample(int days, int attacks) {
    return '該当日$days日、そのうち$attacks日のあとに発作';
  }

  @override
  String insightsLift(String ratio) {
    return 'ふだんの$ratio倍';
  }

  @override
  String insightsNeedMore(int days, int needed) {
    return '該当日 $days/$needed日を記録';
  }

  @override
  String get insightsNoRunYet => '数え始めるには、発作を記録して終了してください。';

  @override
  String get insightsMethodLink => '数え方';

  @override
  String get insightsMethodTitle => '数え方';

  @override
  String insightsMethod1(String pressure) {
    return '該当日とは、記録や天気にその要因があった日のことです。たとえば睡眠の回答が1だった日や、気圧が$pressure以上下がった日です。';
  }

  @override
  String get insightsMethod2 =>
      '発作がその日か翌日に始まった場合、その日のあとに起きたと数えます。モデルが見る24〜48時間です。';

  @override
  String get insightsMethod3 =>
      '比は、その要因の該当日のあとに発作が起きた頻度を、記録のどの日のあとでも発作が起きた頻度と比べたものです。1.5倍はふだんの1.5倍、0.5倍は半分という意味です。';

  @override
  String insightsMethod4(int needed) {
    return '要因が分類されるには該当日が$needed日必要です。それまでは「まだデータが足りません」に入ります。あとに発作が少ない要因も、多い要因と同じくらい役に立つので、両方のリストを同じ扱いにしています。';
  }

  @override
  String get insightsMethod5 =>
      'どれも原因を示すものではありません。週末や薬の変更など、一緒に起きる別の何かのせいでリストに入ることもあります。リストは何を試すかを決めるために使い、何かのせいにするためには使わないでください。';

  @override
  String get riskInsightsLink => 'あなたの要因';

  @override
  String get settingsInsightsHint => '記録の中で発作の前にあった要因';

  @override
  String get notificationsTitle => '通知';

  @override
  String get settingsNotificationsHint => 'レベルの通知、気圧の低下、リマインダー';

  @override
  String get notificationsIntro =>
      '保存された予報とあなたの記録をもとに、すべてこの端末でスケジュールされます。不要な種類はオフにしてください。';

  @override
  String get notificationsPermissionDenied => 'システム設定でこのアプリの通知がオフになっています。';

  @override
  String get notifTypeRiskRising => 'レベルの上昇';

  @override
  String get notifTypeRiskRisingHint => 'レベルが高い日の前夜と当日の朝';

  @override
  String get notifTypePressureDrop => '気圧の低下';

  @override
  String notifTypePressureDropHint(String pressure) {
    return '24時間で$pressure以上下がる予報のとき';
  }

  @override
  String get notifTypeAttackOver => '発作は治まりましたか？';

  @override
  String get notifTypeAttackOverHint => 'いつもの発作の長さが経ったときに、終了ボタン付きで';

  @override
  String get notifTypeCheckin => 'チェックインのリマインダー';

  @override
  String get notifTypeCheckinHint => '「毎日」で設定した時刻に';

  @override
  String get notifTypeMedication => '予防薬のリマインダー';

  @override
  String get notifTypeMedicationHint => '予防薬の服用を毎日お知らせ';

  @override
  String notifPressureThreshold(String pressure) {
    return '気圧低下のしきい値：24時間で$pressure';
  }

  @override
  String get notifMedicationTime => '予防薬のリマインダーの時刻';

  @override
  String notifRiskEveningTitle(String level) {
    return '明日のレベル：$level';
  }

  @override
  String notifRiskEveningBody(String level, String driver) {
    return '明日のレベルは$levelです。いちばんの要因：$driver。';
  }

  @override
  String notifRiskMorningTitle(String level) {
    return '今日のレベル：$level';
  }

  @override
  String notifRiskMorningBody(String level, String driver) {
    return '今日のレベルは$levelです。いちばんの要因：$driver。';
  }

  @override
  String get notifPressureTitle => '気圧が下がっています';

  @override
  String notifPressureBody(String pressure, String time) {
    return '$timeまでに$pressure下がる見込みです。';
  }

  @override
  String get notifAttackOverTitle => '発作は治まりましたか？';

  @override
  String notifAttackOverBody(String duration) {
    return '$duration前に始まりました。治まったらここで終了してください。';
  }

  @override
  String get notifEndAttackAction => '発作を終了';

  @override
  String get notifCheckinTitle => '今日の3タップ';

  @override
  String get notifCheckinBody => '睡眠、ストレス、首のこり。15秒です。';

  @override
  String get notifMedicationTitle => '予防薬';

  @override
  String get notifMedicationBody => '予防薬を飲んでいる場合は、今日の服用の時間です。';

  @override
  String get notifChannelAlerts => 'お知らせ';

  @override
  String get notifChannelAlertsDescription => '保存された予報にもとづくレベルと気圧のお知らせ';

  @override
  String get notifChannelReminders => 'リマインダー';

  @override
  String get notifChannelRemindersDescription => 'チェックインと予防薬のリマインダー';

  @override
  String get notifChannelAttack => '発作';

  @override
  String get notifChannelAttackDescription => '記録中の発作についての質問';

  @override
  String get reportTitle => '医師向けレポート';

  @override
  String get settingsReportHint => '期間を選んでPDFとスプレッドシート';

  @override
  String get reportIntro => '次の受診のための記録のまとめです。期間を選んで、PDFまたはスプレッドシートを共有してください。';

  @override
  String get reportRangeLabel => '期間';

  @override
  String reportRangeDays(int days) {
    return '$days日';
  }

  @override
  String get reportRangeCustom => 'カスタム';

  @override
  String reportRangeText(String from, String to) {
    return '$from〜$to';
  }

  @override
  String reportPreviewAttacks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '発作$count回',
      zero: '発作なし',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewAttackDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '発作の日$count日',
      zero: '発作の日なし',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewDoses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '服用$count回',
      zero: '服用なし',
    );
    return '$_temp0';
  }

  @override
  String reportPreviewCheckins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'チェックイン$count回',
      zero: 'チェックインなし',
    );
    return '$_temp0';
  }

  @override
  String get reportEmpty => 'この期間の記録はまだありません。';

  @override
  String get reportSharePdf => 'PDFを共有';

  @override
  String get reportShareCsv => 'スプレッドシートを共有';

  @override
  String get reportShareAll => 'すべて共有';

  @override
  String get reportBuilding => 'レポートを準備中';

  @override
  String get reportFailed => 'レポートを準備できませんでした。もう一度お試しください。';

  @override
  String get reportWhatIsIn => 'PDFの内容';

  @override
  String get reportContents =>
      '発作カレンダー、月ごとの回数、持続時間、サンプル数付きの要因、服薬日、気圧の変化、症状と痛む場所。名前やメモは含みません。';

  @override
  String reportPdfTitle(String app) {
    return '$app レポート';
  }

  @override
  String reportPdfPeriod(String from, String to, int days) {
    return '期間：$from〜$to（$days日間）';
  }

  @override
  String reportPdfGenerated(String date) {
    return '$dateに本人の端末で本人の記録から作成。';
  }

  @override
  String get reportPdfDisclaimer =>
      'これはウェルネスアプリで本人が記録した日誌の要約です。診療録ではなく、臨床的な評価の代わりにはなりません。要因の比はこの人の記録のみを表すもので、原因を示すものではありません。';

  @override
  String reportPdfPage(int page, int pages) {
    return '$page/$pagesページ';
  }

  @override
  String get reportSectionOverview => '概要';

  @override
  String get reportStatAttacks => '発作';

  @override
  String get reportStatAttackDays => '発作の日';

  @override
  String get reportStatPerMonth => '30日あたりの発作';

  @override
  String get reportStatMeanIntensity => '平均の強さ（0-10）';

  @override
  String get reportStatAcuteDays => '頓服薬を使った日';

  @override
  String get reportStatCheckins => 'チェックインした日';

  @override
  String get reportSectionMonths => '月別';

  @override
  String get reportColMonth => '月';

  @override
  String get reportColAttacks => '発作';

  @override
  String get reportColAttackDays => '発作の日';

  @override
  String get reportColMeanIntensity => '平均の強さ';

  @override
  String get reportColAcuteDays => '頓服の日';

  @override
  String get reportColNote => '備考';

  @override
  String get reportOveruseWatch => '頓服10日以上';

  @override
  String get reportOveruseHigh => '頓服15日以上';

  @override
  String get reportSectionCalendar => '発作カレンダー';

  @override
  String get reportCalendarHint => '1日1マス。色付きのマスは発作があった日で、数字はその日の最大の強さです。';

  @override
  String get reportSectionDuration => '発作の持続時間';

  @override
  String get reportDurationNone => 'この期間に終了した発作はありません。';

  @override
  String reportDurationSummary(
    int count,
    String shortest,
    String median,
    String longest,
  ) {
    return '終了した発作$count回。最短$shortest、中央値$median、最長$longest。';
  }

  @override
  String get reportBucketUnderFour => '4時間未満';

  @override
  String get reportBucketFourToTwelve => '4〜12時間';

  @override
  String get reportBucketTwelveToDay => '12〜24時間';

  @override
  String get reportBucketOneToThreeDays => '1〜3日';

  @override
  String get reportBucketOverThreeDays => '3日超';

  @override
  String get reportSectionTriggers => '本人の記録にある要因';

  @override
  String reportTriggersHint(int floor) {
    return '要因があった日のあとの発作の、本人のふだんの頻度に対する比と、その根拠となる該当日数。該当日が$floor日未満の場合は比を表示しません。';
  }

  @override
  String get reportTriggersNone => '要因を比べるには記録した日数がまだ足りません。';

  @override
  String get reportColFactor => '要因';

  @override
  String get reportColRatio => '比';

  @override
  String get reportColExposures => '該当日';

  @override
  String get reportColFollowed => 'あとに発作';

  @override
  String get reportColConfidence => '根拠';

  @override
  String get reportConfidenceLow => '弱い';

  @override
  String get reportConfidenceMedium => '中程度';

  @override
  String get reportConfidenceHigh => '十分';

  @override
  String get reportSectionMedications => '薬';

  @override
  String get reportMedicationsNone => 'この期間の服用記録はありません。';

  @override
  String get reportColMedication => '薬';

  @override
  String get reportColKind => '種類';

  @override
  String get reportColDoses => '服用回数';

  @override
  String get reportColDays => '日数';

  @override
  String get reportColRelief => '2時間後の改善（なし / 一部 / 完全）';

  @override
  String get reportKindAcute => '頓服';

  @override
  String get reportKindPreventive => '予防';

  @override
  String get reportSectionWeather => '気圧';

  @override
  String reportWeatherHint(String pressure) {
    return '低下とは、記録時点で24時間に$pressure以上下がったことを指します。';
  }

  @override
  String get reportWeatherNone => 'この期間の天気データはありません。';

  @override
  String reportWeatherAttacks(int fall, int total) {
    return '発作$total回のうち$fall回が気圧低下のあとに始まりました。';
  }

  @override
  String reportWeatherDays(int fall, int total) {
    return 'チェックインした$total日のうち$fall日に低下がありました。';
  }

  @override
  String reportWeatherLift(String lift) {
    return '比：$lift倍（1.0は関係なしを意味します）。';
  }

  @override
  String get reportSectionSymptoms => '症状と痛む場所';

  @override
  String get reportSymptomsNone => '記録された症状や場所はありません。';

  @override
  String reportCountOfAttacks(String name, int count, int total) {
    return '$name：発作$total回中$count回';
  }

  @override
  String reportHoursShort(String hours) {
    return '$hours時間';
  }

  @override
  String get notifTypeQuestionnaire => '3か月ごとの質問票';

  @override
  String get notifTypeQuestionnaireHint => '前回から3か月後にMIDASとHIT-6';

  @override
  String get notifQuestionnaireTitle => '前回の質問票から3か月が経ちました';

  @override
  String get notifQuestionnaireBody => 'MIDASとHIT-6にもう一度回答して、この3か月を比べましょう。';

  @override
  String get questionnairesTitle => '質問票';

  @override
  String get settingsQuestionnairesHint => 'MIDASとHIT-6の採点とグラフ';

  @override
  String get questionnairesIntro =>
      '過去3か月についての、短く妥当性が確認された質問票が2つあります。3か月ごとに繰り返すと、スコアがここにグラフで表示され、医師向けレポートに含めることもできます。';

  @override
  String get questionnaireMidasTitle => 'MIDAS';

  @override
  String get questionnaireMidasSubtitle =>
      'Migraine Disability Assessment：過去3か月の5つの日数';

  @override
  String get questionnaireHit6Title => 'HIT-6';

  @override
  String get questionnaireHit6Subtitle =>
      'Headache Impact Test：頭痛が生活に与える影響についての6つの質問';

  @override
  String get questionnaireNeverDone => 'まだ回答していません';

  @override
  String questionnaireLatest(int score, String date) {
    return '前回のスコア $score（$date）';
  }

  @override
  String get questionnaireDueNow => '回答の時期です';

  @override
  String questionnaireDueOn(String date) {
    return '次回 $date';
  }

  @override
  String get questionnaireStart => '回答する';

  @override
  String get questionnaireRepeat => 'もう一度回答する';

  @override
  String get questionnaireHistory => 'スコアの履歴';

  @override
  String questionnaireChartLabel(
    int count,
    String first,
    String last,
    int latest,
  ) {
    return '$first〜$lastのスコア$count件、最新$latest';
  }

  @override
  String get questionnaireAbout => 'スコアについて';

  @override
  String get questionnaireAboutBody =>
      'MIDASは5つの日数を合計します。0〜5はグレードI（支障はほとんどまたはまったくない）、6〜10はグレードII（軽度）、11〜20はグレードIII（中等度）、21以上はグレードIV（重度）です。HIT-6は回答ごとに6、8、10、11、13点で、合計36〜78点です。49点以下は影響がほとんどまたはまったくない、50〜55点はいくらか影響がある、56〜59点はかなりの影響がある、60点以上は重い影響があるです。区分は公表されているもので、スコアはあなたと医師が話し合うためのものです。';

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
  String get questionnaireMidasUnscored => 'スコアには含まれません';

  @override
  String get questionnaireDaysField => '日数（0〜90）';

  @override
  String get questionnairePainField => '痛み（0〜10）';

  @override
  String questionnaireDaysError(int max) {
    return '0〜$maxの数字を入力してください';
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
  String get questionnaireSave => '保存して採点';

  @override
  String get questionnaireIncomplete => '保存するには、採点対象の質問すべてに回答してください。';

  @override
  String questionnaireResultTitle(int score) {
    return 'あなたのスコア：$score';
  }

  @override
  String get questionnaireResultDone => '完了';

  @override
  String get questionnaireResultDisclaimer =>
      'スコアは、あなたが覚えている過去3か月を表します。医師と話すきっかけであり、医学的な評価ではありません。';

  @override
  String get questionnaireMidasBandMinimal => 'グレードI：支障はほとんどまたはまったくない';

  @override
  String get questionnaireMidasBandMild => 'グレードII：軽度の支障';

  @override
  String get questionnaireMidasBandModerate => 'グレードIII：中等度の支障';

  @override
  String get questionnaireMidasBandSevere => 'グレードIV：重度の支障';

  @override
  String get questionnaireHit6BandMinimal => '影響はほとんどまたはまったくない';

  @override
  String get questionnaireHit6BandMild => 'いくらか影響がある';

  @override
  String get questionnaireHit6BandModerate => 'かなりの影響がある';

  @override
  String get questionnaireHit6BandSevere => '重い影響がある';

  @override
  String get reportIncludeQuestionnaires => '質問票のスコアを含める';

  @override
  String get reportIncludeQuestionnairesHint => '期間内に回答したMIDASとHIT-6';

  @override
  String get reportSectionQuestionnaires => '質問票';

  @override
  String get reportQuestionnairesNone => 'この期間に回答した質問票はありません。';

  @override
  String get reportColDate => '日付';

  @override
  String get reportColQuestionnaire => '質問票';

  @override
  String get reportColScore => 'スコア';

  @override
  String get reportColBand => '区分';

  @override
  String get voiceButton => '音声で記録';

  @override
  String get voiceListening => '聞き取り中';

  @override
  String get voiceListeningHint =>
      '今の状態を話してください。例：痛みは10のうち7、目の奥、吐き気、イブプロフェンを飲んだ。';

  @override
  String get voiceStop => '話し終えた';

  @override
  String get voiceCancel => 'キャンセル';

  @override
  String get voiceTryAgain => 'もう一度';

  @override
  String get voiceUnavailable =>
      'この端末では音声入力を使えません。音声認識にはマイクの許可と、使用する言語のオフライン音声パックが必要です。';

  @override
  String get voiceNoMatch => '何も聞き取れませんでした。端末に近づいてもう一度試すか、項目をタップしてください。';

  @override
  String get voiceReviewTitle => '保存する前に確認';

  @override
  String voiceHeard(String text) {
    return '聞き取った内容：「$text」';
  }

  @override
  String get voiceNothingUnderstood =>
      '話した内容に一致する項目がありませんでした。項目をタップするか、もう一度お試しください。';

  @override
  String get voiceIntensity => '強さ';

  @override
  String get voiceIntensityNone => '言及なし';

  @override
  String get voiceSymptoms => '症状';

  @override
  String get voiceLocations => '痛む場所';

  @override
  String get voiceMedications => '今飲んだ薬';

  @override
  String get voiceSave => '発作に保存';

  @override
  String widgetLevel(String level) {
    return 'レベル：$level';
  }

  @override
  String get widgetNoLevel => 'アプリを開いて今日のレベルを読み込む';

  @override
  String widgetDriver(String factor) {
    return '主な要因：$factor';
  }

  @override
  String get widgetNoDriver => '目立つ要因はありません';

  @override
  String widgetPressureFalling(String pressure) {
    return '24時間で気圧が$pressure低下';
  }

  @override
  String widgetPressureRising(String pressure) {
    return '24時間で気圧が$pressure上昇';
  }

  @override
  String get widgetPressureSteady => '気圧は安定';

  @override
  String get widgetPressureUnknown => '気圧の予報はまだありません';

  @override
  String widgetUpdated(String time) {
    return '$timeに更新';
  }

  @override
  String get widgetStartAttack => '発作を記録';

  @override
  String get widgetOpenAttack => '発作を開く';

  @override
  String get watchStart => '発作を記録';

  @override
  String get watchStop => '発作を終了';

  @override
  String get watchIntensity => '強さ';

  @override
  String watchSince(String time) {
    return '$timeから';
  }

  @override
  String get watchPending => '時計に保存しました。スマートフォンが近くにあるときに送信されます。';

  @override
  String get watchNoPhone => '時計を接続するには、スマートフォンでアプリを一度開いてください。';

  @override
  String get routinesTitle => 'セルフケア';

  @override
  String get routinesIntro => 'つらい日に役立つと感じる人が多い、簡単なことです。合うものだけ使い、ほかは飛ばしてください。';

  @override
  String get routineCardTitle => '今日役立つかもしれないこと';

  @override
  String get routineNotToday => '今日はしない';

  @override
  String get routineSeeAll => 'すべてのセルフケア';

  @override
  String get routineStepsTitle => 'やり方';

  @override
  String get routineReasonHighDay => '今日のレベルは高です';

  @override
  String get routineReasonNeckTension => 'チェックインで首のこりがありました';

  @override
  String get routineReasonStress => 'チェックインでストレスが強めでした';

  @override
  String get routineStretchesTitle => '首と肩のやさしいストレッチ';

  @override
  String get routineStretchesSummary => '首と肩のこりをほぐす5つのゆっくりした動き。痛みがあれば中止してください。';

  @override
  String get routineStretchesSteps =>
      '肩の力を抜き、足を床につけて背筋を伸ばして座ります。\n右耳をゆっくり右肩に近づけます。15秒保ち、反対側も行います。\nあごを胸のほうへ下げ、15秒保ちます。\n肩を後ろに5回、前に5回回します。\n背中の後ろで手を組み、15秒間やさしく胸を開きます。';

  @override
  String get routineBreathingTitle => 'ゆっくり呼吸';

  @override
  String get routineBreathingSummary =>
      '4秒吸って6秒吐く呼吸を1分ほど続けます。ゆっくり吐くと落ち着く人が多いです。';

  @override
  String get routineBreathingSteps =>
      '楽な場所に座るか横になります。\n円が大きくなる間、鼻から息を吸います。\n円が小さくなる間、ゆっくり息を吐きます。\n6回、または心地よい間続けます。';

  @override
  String get routineLowLightTitle => '暗めの明かりと静けさ';

  @override
  String get routineLowLightSummary => '敏感な日や発作中は、強い光や音がつらいと感じる人が多いです。';

  @override
  String get routineLowLightSteps =>
      '照明を暗くするか、カーテンを閉めます。\nダークモードにして画面の明るさを下げます。\nそれでも光がつらいときは、アイマスクやサングラスを使います。\n耳栓や静かな部屋で音を減らします。';

  @override
  String get routineHydrationTitle => '水を少し飲む';

  @override
  String get routineHydrationSummary => '水を手の届くところに置いておくと、1日を通して飲みやすくなります。';

  @override
  String get routineHydrationSteps =>
      'コップやボトルの水を手の届くところに置きます。\n1時間ごとに数口飲みます。\n食事のたびにコップ1杯の水を飲みます。';

  @override
  String get routineCaffeineTitle => 'カフェインを一定に';

  @override
  String get routineCaffeineSummary => 'カフェインの量が大きく変わることが影響する人もいます。';

  @override
  String get routineCaffeineSteps =>
      '毎日だいたい同じ時間にカフェインをとります。\n急に増やすことも、いつもの量を急にやめることも避けます。\nカフェイン入りの飲み物は昼過ぎまでにします。';

  @override
  String get routineSleepTitle => '規則正しい睡眠';

  @override
  String get routineSleepSummary => '週末も含めて睡眠の時間をそろえることが、多くの人に役立っています。';

  @override
  String get routineSleepSteps =>
      '毎日だいたい同じ時間に寝て、同じ時間に起きます。\n寝室を暗く、静かで、涼しく保ちます。\n寝る30分前には画面を見るのをやめます。\n夕方以降の長い昼寝は避けます。';

  @override
  String get breathingStart => '呼吸を始める';

  @override
  String get breathingStop => '止める';

  @override
  String get breathingIn => '吸って';

  @override
  String get breathingOut => '吐いて';

  @override
  String breathingRound(int round, int total) {
    return '$round/$total回目';
  }

  @override
  String get breathingDone => '終わりです。立ち上がる前に少し休みましょう。';

  @override
  String get settingsRoutinesHint => 'ストレッチ、呼吸、そのほかの簡単なセルフケア';

  @override
  String get experimentsTitle => '試してみる';

  @override
  String get settingsExperimentsHint => 'ひとつの変化を2週間試して比べます';

  @override
  String get experimentsIntro => 'ひとつの変化を2週間試して、その前の2週間と比べます。一度に試せるのはひとつだけです。';

  @override
  String get experimentsPick => '変化をひとつ選ぶ';

  @override
  String get experimentChangeCutCaffeine => 'カフェインを減らす';

  @override
  String get experimentChangeRegularSleep => '毎晩同じ時間に寝る';

  @override
  String get experimentChangeMoreWater => '水を多めに飲む';

  @override
  String get experimentChangeDailyStretches => '毎日首のストレッチをする';

  @override
  String get experimentChangeLessScreens => '夜の画面時間を減らす';

  @override
  String get experimentChangeNoAlcohol => 'お酒を控える';

  @override
  String experimentDay(int day, int total) {
    return '$total日中$day日目';
  }

  @override
  String get experimentAdherenceQuestion => '今日は続けられましたか？';

  @override
  String get experimentYes => 'はい';

  @override
  String get experimentNo => 'いいえ';

  @override
  String experimentAdherence(int kept, int days) {
    return '$days日中$kept日続けました';
  }

  @override
  String get experimentCompareTitle => '前の2週間と試した期間';

  @override
  String get experimentBefore => '前';

  @override
  String get experimentDuring => '期間中';

  @override
  String get experimentRowRate => '1週間あたりの発作';

  @override
  String get experimentRowIntensity => '平均の強さ';

  @override
  String get experimentRowDuration => '持続時間の中央値';

  @override
  String experimentSample(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count回の発作から',
      zero: '発作なし',
    );
    return '$_temp0';
  }

  @override
  String experimentDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count日',
    );
    return '$_temp0';
  }

  @override
  String get experimentNoData => 'データなし';

  @override
  String get experimentCaveat =>
      '2週間は短い期間です。天気や季節、ストレスは自然に変わるので、証拠ではなく手がかりとして見てください。';

  @override
  String experimentSmallSample(int min) {
    return 'どちらかの期間の発作が$min回未満なので、数字が大きくぶれることがあります。';
  }

  @override
  String get experimentStop => 'やめる';

  @override
  String get experimentFinish => '終えて結果を保存';

  @override
  String get experimentDue => '2週間が終わりました。';

  @override
  String get experimentPast => 'これまでの試み';

  @override
  String experimentFinished(String date) {
    return '$dateに完了';
  }

  @override
  String experimentStopped(String date) {
    return '$dateに中止';
  }

  @override
  String experimentPastSummary(String before, String during) {
    return '前は1週間に$before回、期間中は$during回';
  }

  @override
  String get accountTitle => 'アカウント';

  @override
  String get settingsAccountHint => '任意。バックアップとリンクにのみ必要です';

  @override
  String get accountIntro =>
      'アカウントは任意です。アプリの機能はすべてアカウントなしで使え、記録はこのスマートフォンに残ります。必要なのは暗号化バックアップと共有リンクだけです。';

  @override
  String get accountUnavailable => 'このビルドではアカウントが設定されていません。';

  @override
  String get accountApple => 'Appleで続ける';

  @override
  String get accountGoogle => 'Googleで続ける';

  @override
  String get accountOrEmail => 'またはメールアドレスを使う';

  @override
  String get accountEmail => 'メールアドレス';

  @override
  String get accountPassword => 'パスワード';

  @override
  String accountPasswordHint(int min) {
    return '新しいアカウントは$min文字以上';
  }

  @override
  String get accountSignIn => 'サインイン';

  @override
  String get accountCreate => 'アカウントを作成';

  @override
  String get accountForgot => 'パスワードをお忘れですか？';

  @override
  String get accountResetSent => 'このメールアドレスのアカウントがあれば、再設定リンクを送信しました。';

  @override
  String accountSignedInAs(String email) {
    return '$emailでサインイン中';
  }

  @override
  String accountSignedInWith(String method) {
    return '$methodでサインイン中';
  }

  @override
  String get accountMethodApple => 'Apple';

  @override
  String get accountMethodGoogle => 'Google';

  @override
  String get accountMethodEmail => 'メール';

  @override
  String get accountSignedInNote => '記録はこのスマートフォンに残ります。サインアウトしても何も消えません。';

  @override
  String get accountSignOut => 'サインアウト';

  @override
  String get accountDelete => 'アカウントを削除';

  @override
  String get accountDeleteTitle => 'アカウントを削除しますか？';

  @override
  String accountDeleteBody(int hours) {
    return 'アカウントを削除します。$hours時間以内に、暗号化バックアップと共有リンクがサーバーから削除されます。このスマートフォンのデータはそのまま残ります。';
  }

  @override
  String get accountDeletePassword => '確認のためパスワードを入力してください';

  @override
  String get accountDeleteSubscription =>
      'PremiumはApp StoreまたはGoogle Playで請求されます。アカウントを削除しても解約にはならないので、ストアで解約してください。';

  @override
  String get accountDeleteCancel => 'アカウントを残す';

  @override
  String accountDeleted(int hours) {
    return 'アカウントを削除しました。サーバーのデータは$hours時間以内に消去されます。';
  }

  @override
  String get accountErrorWrongCredentials => 'メールアドレスとパスワードが一致しません。';

  @override
  String get accountErrorEmailInUse => 'このメールアドレスはすでに登録されています。サインインしてください。';

  @override
  String get accountErrorWeakPassword => 'もっと長いパスワードを選んでください。';

  @override
  String get accountErrorInvalidEmail => 'メールアドレスを確認してください。';

  @override
  String get accountErrorNetwork => '接続できません。オンラインになってからもう一度お試しください。';

  @override
  String get accountErrorRecentSignIn => '安全のため、もう一度サインインしてからお試しください。';

  @override
  String get accountErrorUnknown => '問題が発生しました。もう一度お試しください。';

  @override
  String get backupTitle => '暗号化バックアップ';

  @override
  String get settingsBackupHint => 'あなただけが知るパスフレーズで保護';

  @override
  String get backupIntro =>
      'バックアップはアップロード前に、このスマートフォン上であなたのパスフレーズで暗号化されます。保存するのは暗号化されたファイルだけで、私たちには開けません。';

  @override
  String get backupForgetWarning =>
      'パスフレーズを忘れると、誰もバックアップを開けません。私たちも同じです。安全な場所に書き留めてください。';

  @override
  String get backupNeedsAccount => 'バックアップにはアカウントが必要です。ほかの機能はすべてアカウントなしで使えます。';

  @override
  String get backupOpenAccount => 'アカウントを作成';

  @override
  String get backupNone => 'バックアップはまだありません';

  @override
  String backupLast(String date) {
    return '前回のバックアップ：$date';
  }

  @override
  String get backupStatusUnknown => '現在バックアップを確認できません。';

  @override
  String get backupPassphrase => 'パスフレーズ';

  @override
  String backupPassphraseHint(int min) {
    return '$min文字以上。関係のない単語をいくつか並べるのがおすすめです。';
  }

  @override
  String get backupPassphraseRepeat => 'バックアップするにはパスフレーズをもう一度入力';

  @override
  String get backupNow => '今すぐバックアップ';

  @override
  String get backupDone => 'バックアップしました。';

  @override
  String get backupRestore => 'バックアップから復元';

  @override
  String get backupRestoreTitle => 'このスマートフォンのデータをすべて置き換えますか？';

  @override
  String backupRestoreBody(String date) {
    return 'このスマートフォンのデータはすべて$dateのバックアップに置き換わります。';
  }

  @override
  String get backupRestoreConfirm => '復元';

  @override
  String get backupRestored => 'バックアップから復元しました。';

  @override
  String get backupDelete => 'バックアップを削除';

  @override
  String get backupDeleteTitle => 'バックアップを削除しますか？';

  @override
  String get backupDeleteBody =>
      '暗号化されたファイルがサーバーから削除されます。このスマートフォンのデータはそのまま残ります。';

  @override
  String get backupDeleted => 'バックアップを削除しました。';

  @override
  String get backupWorking => '処理中です。数秒かかることがあります。';

  @override
  String get backupErrorMismatch => '2つのパスフレーズが一致しません。';

  @override
  String backupErrorShort(int min) {
    return '$min文字以上にしてください。';
  }

  @override
  String get backupErrorNoBackup => 'このアカウントにはまだバックアップがありません。';

  @override
  String get backupErrorTooLarge => 'バックアップが大きすぎてアップロードできません。';

  @override
  String get backupErrorNewerApp =>
      'このバックアップは新しいバージョンのアプリで作成されています。アプリを更新してからもう一度お試しください。';

  @override
  String get backupErrorWrongPassphrase => 'このパスフレーズではバックアップを開けません。';

  @override
  String get backupErrorDamaged => 'バックアップファイルが破損しています。';

  @override
  String get backupErrorPinning =>
      'バックアップサーバーとの接続を確認できなかったため、何も送信していません。別のネットワークでお試しください。';

  @override
  String get backupErrorNotAllowed => 'サインインの有効期限が切れました。もう一度サインインしてお試しください。';

  @override
  String get shareLinkButton => 'リンクで共有';

  @override
  String get shareLinkTitle => '医師と共有';

  @override
  String get shareLinkExplain =>
      'リンクを知っている人は、期限が切れるまでこのレポートを読めます。表示されるのはPDFと同じ要約で、日記ではありません。共有はいつでも止められます。';

  @override
  String get shareLinkNeedsAccount =>
      'リンクの共有にはアカウントが必要です。PDFとCSVはアカウントなしで使えます。';

  @override
  String shareLinkDuration(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
    );
    return '$_temp0';
  }

  @override
  String get shareLinkCreate => 'リンクを作成';

  @override
  String get shareLinkWorking => 'リンクを作成しています。';

  @override
  String shareLinkReady(String date) {
    return 'リンクができました。$dateまで共有されます。';
  }

  @override
  String get shareLinkCopy => 'リンクをコピー';

  @override
  String get shareLinkCopied => 'リンクをコピーしました。';

  @override
  String get shareLinkShare => 'リンクを共有';

  @override
  String shareLinkMessage(String url) {
    return '私の片頭痛レポート：$url';
  }

  @override
  String get shareLinksTitle => '共有中のリンク';

  @override
  String get settingsShareLinksHint => '共有したレポートのリンクを確認して停止';

  @override
  String get shareLinksEmpty => '共有したリンクはありません。医師向けレポートから作成できます。';

  @override
  String shareLinkActiveUntil(String date) {
    return '$dateまで共有';
  }

  @override
  String shareLinkExpiredOn(String date) {
    return '$dateに期限切れ';
  }

  @override
  String get shareLinkRevoked => '共有を停止しました';

  @override
  String shareLinkCreatedOn(String date) {
    return '$dateに作成';
  }

  @override
  String get shareLinkRevoke => '共有を停止';

  @override
  String get shareLinkRevokeTitle => 'このレポートの共有を停止しますか？';

  @override
  String get shareLinkRevokeBody => 'リンクを持っているすべての人に対して、すぐに使えなくなります。';

  @override
  String get shareLinkRevokedDone => '共有を停止しました。リンクはもう使えません。';

  @override
  String get shareLinkErrorUnavailable => 'このビルドでは共有リンクが設定されていません。';

  @override
  String get shareLinkErrorSignedOut => 'サインインの有効期限が切れました。もう一度サインインしてお試しください。';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumIntro => 'Premiumでは4つの機能が追加されます。それ以外はすべて期限なしで無料です。';

  @override
  String get premiumFreeNote =>
      'ずっと無料：発作と毎日の記録、天気、リスクレベル、あなたの要因、服薬記録、医師向けレポート。';

  @override
  String get premiumFeatureShareLink => '医師に送るリンク';

  @override
  String get premiumFeatureShareLinkHint => '7日または30日で使えなくなるリンクとしてレポートを送れます。';

  @override
  String get premiumFeatureExperiments => '試してみる';

  @override
  String get premiumFeatureExperimentsHint => 'ひとつの変化を2週間試して、その前の期間と比べます。';

  @override
  String get premiumFeatureExtendedFactors => '詳しい環境要因';

  @override
  String get premiumFeatureExtendedFactorsHint => '粒子状物質、オゾン、種類別の花粉。';

  @override
  String get premiumFeatureBackup => '機種変更用バックアップ';

  @override
  String get premiumFeatureBackupHint => '新しいスマートフォンに復元できる暗号化バックアップ。';

  @override
  String get premiumActive => 'Premiumが有効です。';

  @override
  String premiumRenews(String date) {
    return '$dateに更新されます。';
  }

  @override
  String premiumEnds(String date) {
    return '$dateに終了します。';
  }

  @override
  String get premiumManage => 'サブスクリプションを管理';

  @override
  String premiumOfferMonthly(String price) {
    return '月額 $price';
  }

  @override
  String premiumOfferAnnual(String price) {
    return '年額 $price';
  }

  @override
  String premiumOfferOther(String price) {
    return '$price';
  }

  @override
  String get premiumRestore => '購入を復元';

  @override
  String get premiumRestoredNone => 'このストアアカウントにPremiumの購入は見つかりませんでした。';

  @override
  String get premiumThanks => 'ありがとうございます。Premiumが有効になりました。';

  @override
  String get premiumRenewalTerms =>
      'サブスクリプションはストアの設定で解約するまで自動更新されます。次回の請求を避けるには、更新日の24時間前までに解約してください。';

  @override
  String get premiumLoadingOffers => '価格を読み込んでいます。';

  @override
  String get premiumNoOffers => '価格を読み込めませんでした。接続を確認してもう一度お試しください。';

  @override
  String get premiumRetry => '再試行';

  @override
  String get premiumUnavailable => 'このビルドでは購入が設定されていません。';

  @override
  String get premiumDevUnlocked => '開発ビルド：Premiumの機能はすべて使えます。';

  @override
  String get premiumAccountTip =>
      '複数のスマートフォンを使いますか？先にサインインすると、Premiumがアカウントに紐づきます。';

  @override
  String get premiumErrorNotAllowed => 'このストアアカウントでは購入できません。';

  @override
  String get premiumErrorPending => '購入は承認待ちです。完了するとPremiumが有効になります。';

  @override
  String get premiumErrorStore => 'ストアで問題が発生しました。しばらくしてからもう一度お試しください。';

  @override
  String premiumLockTitle(String feature) {
    return '$featureはPremiumの機能です。';
  }

  @override
  String get premiumLockButton => 'Premiumを見る';

  @override
  String get premiumLockShareLinkNote => '作成済みのリンクは期限が切れるまで使え、共有はいつでも止められます。';

  @override
  String get premiumLockExperimentsNote => 'これまでの結果はそのまま残ります。';

  @override
  String get premiumLockBackupNote => '既存のバックアップは引き続き復元または削除できます。';

  @override
  String get premiumFactorsLocked => '粒子状物質、オゾン、花粉はPremiumの機能です。';

  @override
  String get settingsPremiumHint => '共有リンク、試してみる、詳しい要因、バックアップ';

  @override
  String get settingsPremiumActive => '有効';

  @override
  String get shareLinkErrorPremium =>
      '共有リンクにはPremiumが必要です。登録したばかりの場合は、1分ほど待ってからお試しください。';

  @override
  String get auditTitle => 'リスクレベルの振り返り';

  @override
  String auditNotYet(int needed, int logged) {
    return 'このページは発作を$needed回記録すると表示されます。これまでの記録は$logged回です。';
  }

  @override
  String auditIntro(int window) {
    String _temp0 = intl.Intl.pluralLogic(
      window,
      locale: localeName,
      other: 'その前の$window日間',
      one: 'その前日',
    );
    return 'アプリが毎日表示したレベルと、発作が始まった日を比べます。発作が始まった日、または$_temp0に「高」が表示されていた場合、「高」の日のあとの発作として数えます。';
  }

  @override
  String get auditEmpty =>
      'まだ比べるものがありません。これからアプリは毎日表示したレベルを保存し、次の発作か次の「高」の日のあとに最初の数字が表示されます。';

  @override
  String get auditHitsTitle => '「高」の日のあとに起きた発作';

  @override
  String auditHitsValue(int hits, int attacks, String share) {
    return '$attacks回中$hits回（$share）';
  }

  @override
  String get auditMissesTitle => '前に「高」の日がなかった発作';

  @override
  String auditMissesValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count回',
    );
    return '$_temp0';
  }

  @override
  String get auditFalseAlarmsTitle => '発作がなかった「高」の日';

  @override
  String auditFalseAlarmsValue(int count, int highDays) {
    return '「高」の$highDays日中$count日';
  }

  @override
  String get auditTrend => '月別';

  @override
  String auditMonthLine(int hits, int attacks, int falseAlarms, int highDays) {
    return '発作$attacks回中$hits回が「高」の日のあと、「高」の$highDays日中$falseAlarms日は発作なし';
  }

  @override
  String get auditCaveat =>
      '数が少ないと月ごとに大きく変わります。発作のない「高」の日は誤りではなく、いつものきっかけが重なっていたことを意味します。レベルは予定を立てるための目安で、約束ではありません。';

  @override
  String get auditShare => 'この数字を毎月共有する';

  @override
  String get auditShareHint =>
      'みんなのためにアプリを評価する助けになります。送るのは5つの数字とモデルのバージョンだけで、日付、場所、記録、アカウントは送りません。オンにしない限りオフです。';

  @override
  String get settingsAuditHint => '「高」の日のあとの発作と、発作のない「高」の日';

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
    return '$value°C';
  }

  @override
  String unitFahrenheit(String value) {
    return '$value°F';
  }

  @override
  String get unitsTitle => '単位';

  @override
  String get settingsUnitsHint => '気圧と気温';

  @override
  String get unitsPressure => '気圧';

  @override
  String get unitsTemperature => '気温';

  @override
  String get unitNameHpa => 'ヘクトパスカル（hPa）';

  @override
  String get unitNameInHg => '水銀柱インチ（inHg）';

  @override
  String get unitNameMmHg => '水銀柱ミリメートル（mmHg）';

  @override
  String get unitNameCelsius => '摂氏（°C）';

  @override
  String get unitNameFahrenheit => '華氏（°F）';

  @override
  String get unitsNote => '最初の設定はスマートフォンの地域から決まります。変更しても表示が変わるだけで、記録はそのままです。';

  @override
  String envTemperatureNow(String temperature) {
    return '現在の気温：$temperature';
  }

  @override
  String get questionnaireEnglishNote =>
      '検証済みの翻訳が追加されるまで、質問は元の英語のまま表示されます。スコアを比較できるようにするためです。';

  @override
  String get wellnessDisclaimer =>
      '一般的な健康情報であり、医療上の助言ではありません。治療については医師に相談してください。';

  @override
  String get dataSourceWeather => 'Open-Meteo 天気';

  @override
  String get dataSourceAirQuality => 'Open-Meteo 大気質とUV（CAMS）';

  @override
  String get dataSourcePollen => 'Open-Meteo 花粉（CAMS）';

  @override
  String get dataSourceGeocoding => 'Open-Meteo ジオコーディング';

  @override
  String get dataSourceBarometer => '端末の気圧計';

  @override
  String get dataCoverageWorldwide => '全世界';

  @override
  String get dataCoverageEuropeanAqi => '全世界、ヨーロッパでは欧州AQI';

  @override
  String get dataCoverageEurope => 'ヨーロッパのみ';

  @override
  String get dataCoverageBarometer => '気圧センサー搭載のスマートフォン';
}
