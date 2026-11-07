import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// The release files that cannot import Dart keep copies of config values
/// (phase 39). These tests keep the copies equal to `app_config.dart`.
void main() {
  String read(String path) => File(path).readAsStringSync();

  test('fastlane tracks and rollout steps match AppRelease', () {
    final fastfile = read('android/fastlane/Fastfile');
    expect(fastfile, contains('PLAY_TRACK = "${AppRelease.playTrack}"'));
    expect(
      fastfile,
      contains('WEAR_PLAY_TRACK = "${AppRelease.wearPlayTrack}"'),
    );
    // Dart and Ruby print these doubles the same way (0.05, 1.0).
    final steps = AppRelease.productionRollout.join(', ');
    expect(fastfile, contains('PRODUCTION_ROLLOUT = [$steps].freeze'));
  });

  test('rollout steps rise to everyone', () {
    const steps = AppRelease.productionRollout;
    for (var i = 1; i < steps.length; i++) {
      expect(steps[i], greaterThan(steps[i - 1]));
    }
    expect(steps.last, 1);
    expect(AppRelease.crashFreeUsersTarget, inInclusiveRange(0.99, 1));
  });

  test('bundle ids in the store files match AppIdentity', () {
    expect(
      read('android/fastlane/Appfile'),
      contains('package_name("${AppIdentity.bundleId}")'),
    );
    expect(
      read('ios/fastlane/Appfile'),
      contains('app_identifier("${AppIdentity.iosBundleId}")'),
    );
    final match = read('ios/fastlane/Matchfile');
    final export = read('ios/ExportOptions.plist');
    for (final id in RegExp(
      r'"(app\.[\w.]+)"',
    ).allMatches(match).map((m) => m[1]!)) {
      expect(id, startsWith(AppIdentity.iosBundleId));
      expect(export, contains('<key>$id</key>'), reason: id);
    }
  });

  test('the Wear OS version code offset matches', () {
    expect(
      read('wear/android/app/build.gradle.kts'),
      contains(
        'val wearVersionCodeOffset = '
        '${_grouped(AppRelease.wearVersionCodeOffset)}',
      ),
    );
  });

  test('phone and watch share one version, and the changelog has it', () {
    String version(String pubspec) => RegExp(
      r'^version: (\S+)$',
      multiLine: true,
    ).firstMatch(read(pubspec))![1]!;
    final phone = version('pubspec.yaml');
    expect(version('wear/pubspec.yaml'), phone);
    final name = phone.split('+').first;
    expect(read('CHANGELOG.md'), contains('## [$name]'));
  });

  test('launcher icons come from AppAssets and the brand colour', () {
    final pubspec = read('pubspec.yaml');
    expect(pubspec, contains('image_path: "${AppAssets.launcherIcon}"'));
    final seed = AppThemeTokens.seed
        .toARGB32()
        .toRadixString(16)
        .substring(2)
        .toUpperCase();
    expect(pubspec, contains('adaptive_icon_background: "#$seed"'));
    expect(File(AppAssets.launcherIcon).existsSync(), isTrue);
  });

  test('the iOS privacy manifest ships in the app bundle', () {
    expect(File('ios/Runner/PrivacyInfo.xcprivacy').existsSync(), isTrue);
    final project = read('ios/Runner.xcodeproj/project.pbxproj');
    expect(
      RegExp('PrivacyInfo.xcprivacy in Resources').allMatches(project),
      hasLength(2),
      reason: 'a build file and an entry in the Resources phase',
    );
    final manifest = read('ios/Runner/PrivacyInfo.xcprivacy');
    expect(manifest, contains('<key>NSPrivacyTracking</key>\n\t<false/>'));
  });
}

/// 100000000 written the way Kotlin source groups it: 100_000_000.
String _grouped(int n) =>
    n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+$)'), (_) => '_');
