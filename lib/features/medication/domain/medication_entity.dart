import 'package:flutter/foundation.dart';

/// Acute (taken for an attack) or preventive (daily) medication.
enum MedicationKind {
  acute,
  preventive;

  static MedicationKind fromCode(String code) =>
      values.where((v) => v.name == code).firstOrNull ?? MedicationKind.acute;
}

/// Relief two hours after taking an acute medication.
enum Relief {
  none(0),
  partial(1),
  full(2);

  Relief(this.code);

  final int code;

  static Relief? fromCode(int? code) =>
      code == null ? null : values.where((v) => v.code == code).firstOrNull;
}

/// One dose of one medication.
@immutable
class MedicationEntity {
  const MedicationEntity({
    required this.id,
    required this.name,
    required this.takenAt,
    required this.kind,
    this.attackId,
    this.dose,
    this.reliefAt2h,
  });

  final String id;
  final String? attackId;
  final String name;
  final String? dose;
  final DateTime takenAt;
  final Relief? reliefAt2h;
  final MedicationKind kind;

  bool get isAcute => kind == MedicationKind.acute;

  /// Whether two hours have passed, so the relief question is due.
  bool reliefDue(DateTime now) =>
      isAcute && now.difference(takenAt) >= const Duration(hours: 2);

  MedicationEntity copyWith({
    String? name,
    String? dose,
    bool clearDose = false,
    DateTime? takenAt,
    Relief? reliefAt2h,
    bool clearRelief = false,
    MedicationKind? kind,
    String? attackId,
    bool clearAttackId = false,
  }) => MedicationEntity(
    id: id,
    attackId: clearAttackId ? null : (attackId ?? this.attackId),
    name: name ?? this.name,
    dose: clearDose ? null : (dose ?? this.dose),
    takenAt: takenAt ?? this.takenAt,
    reliefAt2h: clearRelief ? null : (reliefAt2h ?? this.reliefAt2h),
    kind: kind ?? this.kind,
  );

  @override
  bool operator ==(Object other) =>
      other is MedicationEntity &&
      other.id == id &&
      other.attackId == attackId &&
      other.name == name &&
      other.dose == dose &&
      other.takenAt == takenAt &&
      other.reliefAt2h == reliefAt2h &&
      other.kind == kind;

  @override
  int get hashCode =>
      Object.hash(id, attackId, name, dose, takenAt, reliefAt2h, kind);
}
