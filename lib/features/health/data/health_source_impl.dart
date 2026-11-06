import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/health/domain/health_entities.dart';
import 'package:migraine_tracker/features/health/domain/health_source.dart';

/// The platform store on phones, nothing elsewhere.
final healthSourceProvider = Provider<HealthSource>((ref) {
  if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
    return const NoHealthSource();
  }
  return PackageHealthSource(clock: ref.watch(clockProvider));
});

/// `health` package adapter. Raw samples stay on the device; only the
/// derived check-in values and the cycle days are ever shown.
class PackageHealthSource implements HealthSource {
  PackageHealthSource({required this.clock, Health? health})
    : _health = health ?? Health();

  final DateTime Function() clock;
  final Health _health;
  bool _configured = false;

  Future<void> _ensureConfigured() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  @override
  HealthStore get store =>
      Platform.isIOS ? HealthStore.healthkit : HealthStore.healthConnect;

  /// HRV is SDNN on Apple Health and RMSSD on Health Connect.
  HealthDataType _dataType(HealthType type) => switch (type) {
    HealthType.sleep => HealthDataType.SLEEP_ASLEEP,
    HealthType.restingHr => HealthDataType.RESTING_HEART_RATE,
    HealthType.hrv =>
      Platform.isIOS
          ? HealthDataType.HEART_RATE_VARIABILITY_SDNN
          : HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
    HealthType.steps => HealthDataType.STEPS,
    HealthType.menstrualFlow => HealthDataType.MENSTRUATION_FLOW,
  };

  @override
  Future<bool> isAvailable() async {
    try {
      await _ensureConfigured();
      if (Platform.isAndroid) return await _health.isHealthConnectAvailable();
      return true;
    } on Object {
      return false;
    }
  }

  @override
  Future<bool> requestRead(Set<HealthType> types) async {
    if (types.isEmpty) return false;
    try {
      await _ensureConfigured();
      final dataTypes = types.map(_dataType).toList();
      final granted = await _health.hasPermissions(dataTypes) ?? false;
      if (granted) return true;
      return await _health.requestAuthorization(dataTypes);
    } on Object {
      return false;
    }
  }

  @override
  Future<bool> requestHistory() async {
    if (!Platform.isAndroid) return true;
    try {
      await _ensureConfigured();
      if (await _health.isHealthDataHistoryAuthorized()) return true;
      return await _health.requestHealthDataHistoryAuthorization();
    } on Object {
      return false;
    }
  }

  @override
  Future<List<HealthSampleEntity>> read(
    Set<HealthType> types,
    DateTime from,
    DateTime to,
  ) async {
    if (types.isEmpty) return const [];
    await _ensureConfigured();
    final byDataType = {for (final t in types) _dataType(t): t};
    final points = await _health.getHealthDataFromTypes(
      types: byDataType.keys.toList(),
      startTime: from,
      endTime: to,
    );
    final now = clock().toUtc();
    return [
      for (final p in _health.removeDuplicates(points))
        if (byDataType[p.type] case final type?)
          if (_value(type, p.value) case final value?)
            HealthSampleEntity(
              id: p.uuid.isEmpty
                  ? '${type.code}-${p.dateFrom.toUtc()}'
                  : p.uuid,
              type: type,
              start: p.dateFrom.toUtc(),
              end: p.dateTo.toUtc(),
              value: value,
              store: store,
              sourceName: p.sourceName.isEmpty ? null : p.sourceName,
              importedAt: now,
            ),
    ];
  }

  static double? _value(HealthType type, HealthValue value) {
    if (type == HealthType.menstrualFlow) {
      if (value is! MenstruationFlowHealthValue) return null;
      return switch (value.flow) {
        null ||
        MenstrualFlow.unspecified ||
        MenstrualFlow.none => FlowLevel.none.value,
        MenstrualFlow.spotting => FlowLevel.spotting.value,
        MenstrualFlow.light => FlowLevel.light.value,
        MenstrualFlow.medium => FlowLevel.medium.value,
        MenstrualFlow.heavy => FlowLevel.heavy.value,
      }.toDouble();
    }
    if (value is NumericHealthValue) return value.numericValue.toDouble();
    return null;
  }

  static const List<HealthDataType> _headacheTypes = [
    HealthDataType.HEADACHE_MILD,
    HealthDataType.HEADACHE_MODERATE,
    HealthDataType.HEADACHE_SEVERE,
    HealthDataType.HEADACHE_UNSPECIFIED,
  ];

  @override
  Future<bool> requestWriteHeadache() async {
    try {
      await _ensureConfigured();
      return await _health.requestAuthorization(
        _headacheTypes,
        permissions: [for (final _ in _headacheTypes) HealthDataAccess.WRITE],
      );
    } on Object {
      return false;
    }
  }

  @override
  Future<bool> writeHeadache({
    required DateTime start,
    required DateTime end,
    required int? intensity,
  }) async {
    final type = switch (intensity) {
      null => HealthDataType.HEADACHE_UNSPECIFIED,
      <= 3 => HealthDataType.HEADACHE_MILD,
      <= 6 => HealthDataType.HEADACHE_MODERATE,
      _ => HealthDataType.HEADACHE_SEVERE,
    };
    try {
      await _ensureConfigured();
      return await _health.writeHealthData(
        value: 0,
        type: type,
        startTime: start,
        endTime: end,
        recordingMethod: RecordingMethod.manual,
      );
    } on Object {
      return false;
    }
  }
}
