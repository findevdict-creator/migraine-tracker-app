import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';

import '../support/screen_walk.dart';

/// Words allowed on screen without passing through the translation files:
/// the app's name, the support address, units, product names and what the
/// date and number formats print.
final RegExp _allowed = RegExp(
  '${RegExp.escape(AppIdentity.name)}( \\((dev|staging)\\))?|'
  r'[\w.+-]+@[\w.-]+|'
  r'\b(hPa|inHg|mmHg|PDF|CSV|Apple|Google|Premium|Health|Connect|MIDAS|HIT|'
  'AM|PM|Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|'
  'January|February|March|April|June|July|August|September|October|'
  'November|December|Mon|Tue|Wed|Thu|Fri|Sat|Sun|'
  r'Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b',
);

/// The mark tool/pseudo_arb.dart opens every pseudo message with.
const pseudoOpen = '⟦';

void main() {
  testWidgets('every screen reads in the pseudo-locale without clipping', (
    tester,
  ) async {
    final untranslated = <String>{};
    await walkScreens(
      tester,
      locale: AppLocales.pseudo,
      onPage: (route) {
        expect(find.textContaining(pseudoOpen), findsWidgets, reason: route);
        untranslated.addAll(_plainCopy(tester, route));
      },
    );
    expect(untranslated, isEmpty);
  });

  // The real translations run longer than English too (German most of all);
  // each one must fit on a small phone.
  for (final locale in AppLocales.supported.skip(1)) {
    testWidgets('every screen fits in $locale', (tester) async {
      await walkScreens(tester, locale: locale, onPage: (_) {});
    });
  }
}

/// Visible text with a plain ASCII word outside the pseudo marks: copy that
/// did not come from the translation files.
Iterable<String> _plainCopy(WidgetTester tester, String route) sync* {
  for (final element in find.byType(RichText).evaluate()) {
    final render = element.renderObject;
    if (render is! RenderParagraph || !render.attached) continue;
    final text = render.text.toPlainText();
    final outside = text
        .replaceAll(RegExp('⟦[^⟧]*⟧', dotAll: true), ' ')
        // A pseudo message split by the widget (a list of steps) leaves an
        // opening or closing half.
        .replaceAll(RegExp(r'⟦[^⟧]*$', dotAll: true), ' ')
        .replaceAll(RegExp('^[^⟦]*⟧', dotAll: true), ' ')
        .replaceAll(_allowed, ' ');
    if (RegExp('[A-Za-z]{3,}').hasMatch(outside)) yield '$route: $text';
  }
}
