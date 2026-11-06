import 'package:flutter/foundation.dart';

/// The two validated instruments. Scoring tables are the published ones
/// and live here, not in config: changing them changes stored results.
enum QuestionnaireKind {
  /// Migraine Disability Assessment (Stewart, Lipton et al., 1999). Five
  /// day-count items over the last three months, summed; two unscored
  /// items (headache days, average pain).
  midas('midas'),

  /// Headache Impact Test, six items on a five-step scale, summed.
  hit6('hit6');

  QuestionnaireKind(this.code);

  final String code;

  static QuestionnaireKind? fromCode(String code) =>
      values.where((k) => k.code == code).firstOrNull;

  /// Scored item ids, in the order asked.
  List<String> get scoredItems => switch (this) {
    QuestionnaireKind.midas => Midas.scoredItems,
    QuestionnaireKind.hit6 => Hit6.items,
  };

  /// Every item id, scored or not.
  List<String> get items => switch (this) {
    QuestionnaireKind.midas => Midas.items,
    QuestionnaireKind.hit6 => Hit6.items,
  };

  int get minScore => switch (this) {
    QuestionnaireKind.midas => 0,
    QuestionnaireKind.hit6 => Hit6.minScore,
  };

  int get maxScore => switch (this) {
    QuestionnaireKind.midas => Midas.maxScore,
    QuestionnaireKind.hit6 => Hit6.maxScore,
  };

  bool isComplete(Map<String, int> answers) =>
      scoredItems.every(answers.containsKey);

  /// Sum of the scored items. Throws [StateError] when one is missing.
  int score(Map<String, int> answers) => switch (this) {
    QuestionnaireKind.midas => Midas.score(answers),
    QuestionnaireKind.hit6 => Hit6.score(answers),
  };

  SeverityBand band(int score) => switch (this) {
    QuestionnaireKind.midas => Midas.band(score),
    QuestionnaireKind.hit6 => Hit6.band(score),
  };
}

/// Four published bands, lowest to highest. MIDAS calls them grades I to
/// IV; HIT-6 calls them little or no, some, substantial and severe impact.
enum SeverityBand { minimal, mild, moderate, severe }

abstract final class Midas {
  /// Days missed at work or school.
  static const String q1 = 'q1';

  /// Days at work or school with output cut by half or more.
  static const String q2 = 'q2';

  /// Days of household work not done.
  static const String q3 = 'q3';

  /// Days of household work with output cut by half or more.
  static const String q4 = 'q4';

  /// Days of family, social or leisure activities missed.
  static const String q5 = 'q5';

  /// Unscored: days with any headache in the three months.
  static const String headacheDays = 'a';

  /// Unscored: average pain of those headaches, 0 to 10.
  static const String painAverage = 'b';

  static const List<String> scoredItems = [q1, q2, q3, q4, q5];
  static const List<String> items = [...scoredItems, headacheDays, painAverage];

  /// Each day-count item runs 0 to 90 (a quarter).
  static const int maxDays = 90;
  static const int maxPain = 10;
  static const int maxScore = maxDays * 5;

  static int maxFor(String item) => item == painAverage ? maxPain : maxDays;

  static int score(Map<String, int> answers) {
    var total = 0;
    for (final item in scoredItems) {
      final v = answers[item];
      if (v == null) throw StateError('MIDAS item $item missing');
      total += v.clamp(0, maxDays);
    }
    return total;
  }

  /// Grade I 0-5, II 6-10, III 11-20, IV 21 and over.
  static SeverityBand band(int score) {
    if (score <= 5) return SeverityBand.minimal;
    if (score <= 10) return SeverityBand.mild;
    if (score <= 20) return SeverityBand.moderate;
    return SeverityBand.severe;
  }
}

/// One of the five HIT-6 answers and its published point value.
enum Hit6Option {
  never(6),
  rarely(8),
  sometimes(10),
  veryOften(11),
  always(13);

  Hit6Option(this.points);

  final int points;

  static Hit6Option? fromPoints(int points) =>
      values.where((o) => o.points == points).firstOrNull;
}

abstract final class Hit6 {
  static const List<String> items = ['q1', 'q2', 'q3', 'q4', 'q5', 'q6'];

  static const int minScore = 36;
  static const int maxScore = 78;

  /// Answers are stored as the option's points.
  static int score(Map<String, int> answers) {
    var total = 0;
    for (final item in items) {
      final v = answers[item];
      final option = v == null ? null : Hit6Option.fromPoints(v);
      if (option == null) throw StateError('HIT-6 item $item missing');
      total += option.points;
    }
    return total;
  }

  /// 36-49 little or no impact, 50-55 some, 56-59 substantial, 60-78
  /// severe.
  static SeverityBand band(int score) {
    if (score <= 49) return SeverityBand.minimal;
    if (score <= 55) return SeverityBand.mild;
    if (score <= 59) return SeverityBand.moderate;
    return SeverityBand.severe;
  }
}

/// One completed questionnaire.
@immutable
class QuestionnaireResponse {
  const QuestionnaireResponse({
    required this.id,
    required this.kind,
    required this.completedAt,
    required this.answers,
    required this.score,
  });

  /// Scores the answers; throws when a scored item is missing.
  factory QuestionnaireResponse.scored({
    required String id,
    required QuestionnaireKind kind,
    required DateTime completedAt,
    required Map<String, int> answers,
  }) => QuestionnaireResponse(
    id: id,
    kind: kind,
    completedAt: completedAt,
    answers: Map.unmodifiable(answers),
    score: kind.score(answers),
  );

  final String id;
  final QuestionnaireKind kind;
  final DateTime completedAt;
  final Map<String, int> answers;
  final int score;

  SeverityBand get band => kind.band(score);

  @override
  bool operator ==(Object other) =>
      other is QuestionnaireResponse &&
      other.id == id &&
      other.kind == kind &&
      other.completedAt == completedAt &&
      other.score == score &&
      mapEquals(other.answers, answers);

  @override
  int get hashCode => Object.hash(id, kind, completedAt, score);
}

/// When the next round is due: the configured interval after the most
/// recent completion of either instrument. Null until one was completed.
abstract final class QuestionnaireDue {
  static DateTime? nextDue(
    Iterable<QuestionnaireResponse> responses,
    Duration interval,
  ) {
    DateTime? latest;
    for (final r in responses) {
      if (latest == null || r.completedAt.isAfter(latest)) {
        latest = r.completedAt;
      }
    }
    return latest?.add(interval);
  }
}
