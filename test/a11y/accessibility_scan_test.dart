import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/screen_walk.dart';

/// The accessibility scanner: every screen in the walk, at every scroll
/// position, in light and dark, against Flutter's built-in checks for
/// WCAG 2.2 AA text contrast, labelled controls and tap target size.
/// Writes `build/a11y/report.md` (attached to the CI run) and fails on any
/// finding.
final Map<String, AccessibilityGuideline> _guidelines = {
  'Text contrast (WCAG 1.4.3, 4.5:1 or 3:1 for large text)':
      textContrastGuideline,
  'Every control has a label (WCAG 4.1.2)': labeledTapTargetGuideline,
  'Tap targets at least 48 × 48 dp (Android)': androidTapTargetGuideline,
  'Tap targets at least 44 × 44 pt (iOS)': iOSTapTargetGuideline,
};

final _report = <String, Map<String, Set<String>>>{};

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('every screen passes the scanner in ${brightness.name}', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final findings = _report[brightness.name] = {};
      await walkScreens(
        tester,
        brightness: brightness,
        onPage: (route) async {
          final screen = findings.putIfAbsent(route, () => {});
          for (final MapEntry(key: name, value: guideline)
              in _guidelines.entries) {
            final result = await guideline.evaluate(tester);
            if (!result.passed) screen.add('$name: ${result.reason}');
          }
        },
      );
      semantics.dispose();
      final failed = {
        for (final MapEntry(:key, :value) in findings.entries)
          if (value.isNotEmpty) key: value,
      };
      expect(failed, isEmpty);
    });
  }

  // Proves the checks bite: a small unlabelled button and pale text fail.
  testWidgets('the scanner catches a bad screen', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          // Centred: targets touching the screen edge are not measured.
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: 20,
                  child: GestureDetector(onTap: () {}),
                ),
                const Text('Pale', style: TextStyle(color: Color(0xFFEEEEEE))),
              ],
            ),
          ),
        ),
      ),
    );
    for (final guideline in _guidelines.values) {
      final result = await guideline.evaluate(tester);
      expect(result.passed, isFalse, reason: guideline.description);
    }
    semantics.dispose();
  });

  tearDownAll(_writeReport);
}

void _writeReport() {
  final out = StringBuffer()
    ..writeln('# Accessibility scan')
    ..writeln()
    ..writeln('Checks on every screen, at every scroll position, on a')
    ..writeln('360 × 720 phone:')
    ..writeln();
  for (final name in _guidelines.keys) {
    out.writeln('- $name');
  }
  for (final MapEntry(key: mode, value: screens) in _report.entries) {
    out
      ..writeln()
      ..writeln('## ${mode[0].toUpperCase()}${mode.substring(1)} theme')
      ..writeln()
      ..writeln('| Screen | Result |')
      ..writeln('| ------ | ------ |');
    for (final MapEntry(key: route, value: issues) in screens.entries) {
      final result = issues.isEmpty
          ? 'pass'
          : issues.map((i) => i.replaceAll('\n', ' ')).join('<br>');
      out.writeln('| `$route` | $result |');
    }
  }
  File('build/a11y/report.md')
    ..createSync(recursive: true)
    ..writeAsStringSync(out.toString());
}
