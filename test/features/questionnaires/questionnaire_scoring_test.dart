import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/features/questionnaires/domain/questionnaire.dart';

/// Worked examples follow the published scoring rules: MIDAS sums the five
/// day counts (Stewart et al., Neurology 2001; grades I-IV at 0-5, 6-10,
/// 11-20, 21+); HIT-6 sums 6/8/10/11/13 points per item (36-78; bands at
/// 49, 55 and 59 per the HIT-6 scoring sheet).
void main() {
  group('MIDAS', () {
    Map<String, int> answers(List<int> days, {int a = 0, int b = 0}) => {
      for (final (i, item) in Midas.scoredItems.indexed) item: days[i],
      Midas.headacheDays: a,
      Midas.painAverage: b,
    };

    test('sums the five day counts and ignores the two unscored items', () {
      final a = answers([0, 4, 2, 6, 3], a: 30, b: 7);
      expect(Midas.score(a), 15);
      expect(Midas.band(15), SeverityBand.moderate);
      expect(QuestionnaireKind.midas.score(answers([0, 0, 0, 0, 0])), 0);
    });

    test('grade boundaries 5/6, 10/11, 20/21', () {
      expect(Midas.band(0), SeverityBand.minimal);
      expect(Midas.band(5), SeverityBand.minimal);
      expect(Midas.band(6), SeverityBand.mild);
      expect(Midas.band(10), SeverityBand.mild);
      expect(Midas.band(11), SeverityBand.moderate);
      expect(Midas.band(20), SeverityBand.moderate);
      expect(Midas.band(21), SeverityBand.severe);
      expect(Midas.band(270), SeverityBand.severe);
    });

    test('a missing scored item throws; the unscored ones are optional', () {
      final partial = answers([1, 2, 3, 4, 5])..remove(Midas.q3);
      expect(() => Midas.score(partial), throwsStateError);
      expect(QuestionnaireKind.midas.isComplete(partial), isFalse);
      final noExtras = answers([1, 2, 3, 4, 5])
        ..remove(Midas.headacheDays)
        ..remove(Midas.painAverage);
      expect(QuestionnaireKind.midas.isComplete(noExtras), isTrue);
      expect(Midas.score(noExtras), 15);
    });

    test('day counts are capped at a quarter', () {
      expect(Midas.score(answers([99, 0, 0, 0, 0])), 90);
      expect(Midas.maxFor(Midas.painAverage), 10);
      expect(Midas.maxFor(Midas.q1), 90);
    });
  });

  group('HIT-6', () {
    Map<String, int> answers(List<Hit6Option> options) => {
      for (final (i, item) in Hit6.items.indexed) item: options[i].points,
    };

    test('all "never" is the minimum, all "always" the maximum', () {
      expect(Hit6.score(answers(List.filled(6, Hit6Option.never))), 36);
      expect(Hit6.score(answers(List.filled(6, Hit6Option.always))), 78);
    });

    test('all "sometimes" scores 60: severe impact', () {
      final s = Hit6.score(answers(List.filled(6, Hit6Option.sometimes)));
      expect(s, 60);
      expect(Hit6.band(s), SeverityBand.severe);
    });

    test('a mixed example', () {
      final s = Hit6.score(
        answers([
          Hit6Option.never,
          Hit6Option.rarely,
          Hit6Option.sometimes,
          Hit6Option.veryOften,
          Hit6Option.rarely,
          Hit6Option.never,
        ]),
      );
      expect(s, 49);
      expect(Hit6.band(s), SeverityBand.minimal);
    });

    test('band boundaries 49/50, 55/56, 59/60', () {
      expect(Hit6.band(49), SeverityBand.minimal);
      expect(Hit6.band(50), SeverityBand.mild);
      expect(Hit6.band(55), SeverityBand.mild);
      expect(Hit6.band(56), SeverityBand.moderate);
      expect(Hit6.band(59), SeverityBand.moderate);
      expect(Hit6.band(60), SeverityBand.severe);
    });

    test('answers outside the five point values do not count', () {
      final bad = answers(List.filled(6, Hit6Option.never))..['q4'] = 7;
      expect(() => Hit6.score(bad), throwsStateError);
      expect(Hit6Option.fromPoints(11), Hit6Option.veryOften);
    });
  });

  group('due date', () {
    QuestionnaireResponse r(DateTime at) => QuestionnaireResponse.scored(
      id: at.toIso8601String(),
      kind: QuestionnaireKind.hit6,
      completedAt: at,
      answers: {for (final i in Hit6.items) i: 6},
    );

    test('null before the first round', () {
      expect(QuestionnaireDue.nextDue([], const Duration(days: 90)), isNull);
    });

    test('the interval after the latest round of either kind', () {
      final due = QuestionnaireDue.nextDue([
        r(DateTime(2026, 5)),
        r(DateTime(2026, 8, 10)),
        r(DateTime(2026, 7)),
      ], const Duration(days: 90));
      expect(due, DateTime(2026, 11, 8));
    });

    test('scored responses carry their band', () {
      final x = r(DateTime(2026));
      expect(x.score, 36);
      expect(x.band, SeverityBand.minimal);
      expect(QuestionnaireKind.fromCode('hit6'), QuestionnaireKind.hit6);
      expect(QuestionnaireKind.fromCode('nope'), isNull);
    });
  });
}
