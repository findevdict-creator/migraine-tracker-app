import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/screen_walk.dart';

void main() {
  // The app allows text up to AppThemeTokens.maxTextScale (200%). Every
  // screen must still fit a small phone with nothing clipped.
  testWidgets('every screen fits at 200% text', (tester) async {
    await walkScreens(
      tester,
      textScale: 2,
      onPage: (route) {
        // The setting reached the screens (the app clamps at 200%).
        final context = tester.element(find.byType(Scaffold).last);
        expect(MediaQuery.textScalerOf(context).scale(10), 20, reason: route);
      },
    );
  });
}
