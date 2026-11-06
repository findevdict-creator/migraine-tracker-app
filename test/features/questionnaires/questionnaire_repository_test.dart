import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/features/questionnaires/data/questionnaire_repository_impl.dart';
import 'package:migraine_tracker/features/questionnaires/domain/questionnaire.dart';

import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftQuestionnaireRepository repo;

  setUp(() {
    db = newTestDatabase();
    repo = DriftQuestionnaireRepository(db);
  });
  tearDown(() => db.close());

  QuestionnaireResponse midas(String id, DateTime at, int q1) =>
      QuestionnaireResponse.scored(
        id: id,
        kind: QuestionnaireKind.midas,
        completedAt: at,
        answers: {
          Midas.q1: q1,
          Midas.q2: 0,
          Midas.q3: 0,
          Midas.q4: 0,
          Midas.q5: 0,
          Midas.painAverage: 6,
        },
      );

  test('round-trips answers and score, oldest first per kind', () async {
    await repo.save(midas('b', DateTime(2026, 8), 12));
    await repo.save(midas('a', DateTime(2026, 5), 3));
    await repo.save(
      QuestionnaireResponse.scored(
        id: 'h',
        kind: QuestionnaireKind.hit6,
        completedAt: DateTime(2026, 6),
        answers: {for (final i in Hit6.items) i: 10},
      ),
    );
    final history = await repo.history(QuestionnaireKind.midas);
    expect(history.map((r) => r.id), ['a', 'b']);
    expect(history.last.score, 12);
    expect(history.last.answers[Midas.painAverage], 6);
    expect(history.last, midas('b', DateTime(2026, 8), 12));
    expect((await repo.latest(QuestionnaireKind.hit6))!.score, 60);
    expect((await repo.all()).map((r) => r.id), ['a', 'h', 'b']);
    expect(
      (await repo.inRange(
        DateTime(2026, 5, 2),
        DateTime(2026, 8),
      )).map((r) => r.id),
      ['h'],
    );
  });

  test('saving the same id again replaces it', () async {
    await repo.save(midas('a', DateTime(2026, 5), 3));
    await repo.save(midas('a', DateTime(2026, 5), 30));
    expect((await repo.all()).single.score, 30);
  });
}
