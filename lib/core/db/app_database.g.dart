// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AttacksTable extends Attacks with TableInfo<$AttacksTable, Attack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  headLocations = GeneratedColumn<String>(
    'head_locations',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($AttacksTable.$converterheadLocations);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  phases = GeneratedColumn<String>(
    'phases',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, dynamic>>($AttacksTable.$converterphases);
  @override
  late final GeneratedColumnWithTypeConverter<
    List<Map<String, dynamic>>,
    String
  >
  symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<Map<String, dynamic>>>($AttacksTable.$convertersymptoms);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pressureSensorHpaMeta = const VerificationMeta(
    'pressureSensorHpa',
  );
  @override
  late final GeneratedColumn<double> pressureSensorHpa =
      GeneratedColumn<double>(
        'pressure_sensor_hpa',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _pressureStationHpaMeta =
      const VerificationMeta('pressureStationHpa');
  @override
  late final GeneratedColumn<double> pressureStationHpa =
      GeneratedColumn<double>(
        'pressure_station_hpa',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  weather = GeneratedColumn<String>(
    'weather',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($AttacksTable.$converterweathern);
  static const VerificationMeta _finishLaterMeta = const VerificationMeta(
    'finishLater',
  );
  @override
  late final GeneratedColumn<bool> finishLater = GeneratedColumn<bool>(
    'finish_later',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("finish_later" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    endedAt,
    intensity,
    headLocations,
    phases,
    symptoms,
    notes,
    pressureSensorHpa,
    pressureStationHpa,
    weather,
    finishLater,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attacks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('pressure_sensor_hpa')) {
      context.handle(
        _pressureSensorHpaMeta,
        pressureSensorHpa.isAcceptableOrUnknown(
          data['pressure_sensor_hpa']!,
          _pressureSensorHpaMeta,
        ),
      );
    }
    if (data.containsKey('pressure_station_hpa')) {
      context.handle(
        _pressureStationHpaMeta,
        pressureStationHpa.isAcceptableOrUnknown(
          data['pressure_station_hpa']!,
          _pressureStationHpaMeta,
        ),
      );
    }
    if (data.containsKey('finish_later')) {
      context.handle(
        _finishLaterMeta,
        finishLater.isAcceptableOrUnknown(
          data['finish_later']!,
          _finishLaterMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attack(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      ),
      headLocations: $AttacksTable.$converterheadLocations.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}head_locations'],
        )!,
      ),
      phases: $AttacksTable.$converterphases.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}phases'],
        )!,
      ),
      symptoms: $AttacksTable.$convertersymptoms.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}symptoms'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      pressureSensorHpa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pressure_sensor_hpa'],
      ),
      pressureStationHpa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pressure_station_hpa'],
      ),
      weather: $AttacksTable.$converterweathern.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}weather'],
        ),
      ),
      finishLater: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}finish_later'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AttacksTable createAlias(String alias) {
    return $AttacksTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterheadLocations =
      const StringListConverter();
  static TypeConverter<Map<String, dynamic>, String> $converterphases =
      const JsonMapConverter();
  static TypeConverter<List<Map<String, dynamic>>, String> $convertersymptoms =
      const JsonListConverter();
  static TypeConverter<Map<String, dynamic>, String> $converterweather =
      const JsonMapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterweathern =
      NullAwareTypeConverter.wrap($converterweather);
}

class Attack extends DataClass implements Insertable<Attack> {
  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;

  /// 0 to 10. Null until the user answers.
  final int? intensity;

  /// Head map region codes, for example `["left_temple", "behind_eyes"]`.
  final List<String> headLocations;

  /// Phase timestamps as ISO-8601 strings keyed by phase name
  /// (`prodrome`, `aura`, `attack`, `postdrome`).
  final Map<String, dynamic> phases;

  /// Symptom chips with their own tap timestamps:
  /// `[{"code": "aura", "at": "2026-11-06T08:00:00Z"}]`.
  final List<Map<String, dynamic>> symptoms;
  final String? notes;

  /// Phone barometer reading at start, hPa. Null without a sensor.
  final double? pressureSensorHpa;

  /// Nearest-station (feed) pressure at start, hPa.
  final double? pressureStationHpa;

  /// Snapshot of the hour's weather attached at save time.
  final Map<String, dynamic>? weather;

  /// True while the user chose "finish later" and has not completed the log.
  final bool finishLater;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Attack({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.intensity,
    required this.headLocations,
    required this.phases,
    required this.symptoms,
    this.notes,
    this.pressureSensorHpa,
    this.pressureStationHpa,
    this.weather,
    required this.finishLater,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || intensity != null) {
      map['intensity'] = Variable<int>(intensity);
    }
    {
      map['head_locations'] = Variable<String>(
        $AttacksTable.$converterheadLocations.toSql(headLocations),
      );
    }
    {
      map['phases'] = Variable<String>(
        $AttacksTable.$converterphases.toSql(phases),
      );
    }
    {
      map['symptoms'] = Variable<String>(
        $AttacksTable.$convertersymptoms.toSql(symptoms),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || pressureSensorHpa != null) {
      map['pressure_sensor_hpa'] = Variable<double>(pressureSensorHpa);
    }
    if (!nullToAbsent || pressureStationHpa != null) {
      map['pressure_station_hpa'] = Variable<double>(pressureStationHpa);
    }
    if (!nullToAbsent || weather != null) {
      map['weather'] = Variable<String>(
        $AttacksTable.$converterweathern.toSql(weather),
      );
    }
    map['finish_later'] = Variable<bool>(finishLater);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AttacksCompanion toCompanion(bool nullToAbsent) {
    return AttacksCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      intensity: intensity == null && nullToAbsent
          ? const Value.absent()
          : Value(intensity),
      headLocations: Value(headLocations),
      phases: Value(phases),
      symptoms: Value(symptoms),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      pressureSensorHpa: pressureSensorHpa == null && nullToAbsent
          ? const Value.absent()
          : Value(pressureSensorHpa),
      pressureStationHpa: pressureStationHpa == null && nullToAbsent
          ? const Value.absent()
          : Value(pressureStationHpa),
      weather: weather == null && nullToAbsent
          ? const Value.absent()
          : Value(weather),
      finishLater: Value(finishLater),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Attack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attack(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      intensity: serializer.fromJson<int?>(json['intensity']),
      headLocations: serializer.fromJson<List<String>>(json['headLocations']),
      phases: serializer.fromJson<Map<String, dynamic>>(json['phases']),
      symptoms: serializer.fromJson<List<Map<String, dynamic>>>(
        json['symptoms'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      pressureSensorHpa: serializer.fromJson<double?>(
        json['pressureSensorHpa'],
      ),
      pressureStationHpa: serializer.fromJson<double?>(
        json['pressureStationHpa'],
      ),
      weather: serializer.fromJson<Map<String, dynamic>?>(json['weather']),
      finishLater: serializer.fromJson<bool>(json['finishLater']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'intensity': serializer.toJson<int?>(intensity),
      'headLocations': serializer.toJson<List<String>>(headLocations),
      'phases': serializer.toJson<Map<String, dynamic>>(phases),
      'symptoms': serializer.toJson<List<Map<String, dynamic>>>(symptoms),
      'notes': serializer.toJson<String?>(notes),
      'pressureSensorHpa': serializer.toJson<double?>(pressureSensorHpa),
      'pressureStationHpa': serializer.toJson<double?>(pressureStationHpa),
      'weather': serializer.toJson<Map<String, dynamic>?>(weather),
      'finishLater': serializer.toJson<bool>(finishLater),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Attack copyWith({
    String? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<int?> intensity = const Value.absent(),
    List<String>? headLocations,
    Map<String, dynamic>? phases,
    List<Map<String, dynamic>>? symptoms,
    Value<String?> notes = const Value.absent(),
    Value<double?> pressureSensorHpa = const Value.absent(),
    Value<double?> pressureStationHpa = const Value.absent(),
    Value<Map<String, dynamic>?> weather = const Value.absent(),
    bool? finishLater,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Attack(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    intensity: intensity.present ? intensity.value : this.intensity,
    headLocations: headLocations ?? this.headLocations,
    phases: phases ?? this.phases,
    symptoms: symptoms ?? this.symptoms,
    notes: notes.present ? notes.value : this.notes,
    pressureSensorHpa: pressureSensorHpa.present
        ? pressureSensorHpa.value
        : this.pressureSensorHpa,
    pressureStationHpa: pressureStationHpa.present
        ? pressureStationHpa.value
        : this.pressureStationHpa,
    weather: weather.present ? weather.value : this.weather,
    finishLater: finishLater ?? this.finishLater,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Attack copyWithCompanion(AttacksCompanion data) {
    return Attack(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      headLocations: data.headLocations.present
          ? data.headLocations.value
          : this.headLocations,
      phases: data.phases.present ? data.phases.value : this.phases,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      notes: data.notes.present ? data.notes.value : this.notes,
      pressureSensorHpa: data.pressureSensorHpa.present
          ? data.pressureSensorHpa.value
          : this.pressureSensorHpa,
      pressureStationHpa: data.pressureStationHpa.present
          ? data.pressureStationHpa.value
          : this.pressureStationHpa,
      weather: data.weather.present ? data.weather.value : this.weather,
      finishLater: data.finishLater.present
          ? data.finishLater.value
          : this.finishLater,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attack(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('intensity: $intensity, ')
          ..write('headLocations: $headLocations, ')
          ..write('phases: $phases, ')
          ..write('symptoms: $symptoms, ')
          ..write('notes: $notes, ')
          ..write('pressureSensorHpa: $pressureSensorHpa, ')
          ..write('pressureStationHpa: $pressureStationHpa, ')
          ..write('weather: $weather, ')
          ..write('finishLater: $finishLater, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    endedAt,
    intensity,
    headLocations,
    phases,
    symptoms,
    notes,
    pressureSensorHpa,
    pressureStationHpa,
    weather,
    finishLater,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attack &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.intensity == this.intensity &&
          other.headLocations == this.headLocations &&
          other.phases == this.phases &&
          other.symptoms == this.symptoms &&
          other.notes == this.notes &&
          other.pressureSensorHpa == this.pressureSensorHpa &&
          other.pressureStationHpa == this.pressureStationHpa &&
          other.weather == this.weather &&
          other.finishLater == this.finishLater &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AttacksCompanion extends UpdateCompanion<Attack> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int?> intensity;
  final Value<List<String>> headLocations;
  final Value<Map<String, dynamic>> phases;
  final Value<List<Map<String, dynamic>>> symptoms;
  final Value<String?> notes;
  final Value<double?> pressureSensorHpa;
  final Value<double?> pressureStationHpa;
  final Value<Map<String, dynamic>?> weather;
  final Value<bool> finishLater;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AttacksCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.intensity = const Value.absent(),
    this.headLocations = const Value.absent(),
    this.phases = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.notes = const Value.absent(),
    this.pressureSensorHpa = const Value.absent(),
    this.pressureStationHpa = const Value.absent(),
    this.weather = const Value.absent(),
    this.finishLater = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttacksCompanion.insert({
    required String id,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.intensity = const Value.absent(),
    this.headLocations = const Value.absent(),
    this.phases = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.notes = const Value.absent(),
    this.pressureSensorHpa = const Value.absent(),
    this.pressureStationHpa = const Value.absent(),
    this.weather = const Value.absent(),
    this.finishLater = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Attack> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? intensity,
    Expression<String>? headLocations,
    Expression<String>? phases,
    Expression<String>? symptoms,
    Expression<String>? notes,
    Expression<double>? pressureSensorHpa,
    Expression<double>? pressureStationHpa,
    Expression<String>? weather,
    Expression<bool>? finishLater,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (intensity != null) 'intensity': intensity,
      if (headLocations != null) 'head_locations': headLocations,
      if (phases != null) 'phases': phases,
      if (symptoms != null) 'symptoms': symptoms,
      if (notes != null) 'notes': notes,
      if (pressureSensorHpa != null) 'pressure_sensor_hpa': pressureSensorHpa,
      if (pressureStationHpa != null)
        'pressure_station_hpa': pressureStationHpa,
      if (weather != null) 'weather': weather,
      if (finishLater != null) 'finish_later': finishLater,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttacksCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int?>? intensity,
    Value<List<String>>? headLocations,
    Value<Map<String, dynamic>>? phases,
    Value<List<Map<String, dynamic>>>? symptoms,
    Value<String?>? notes,
    Value<double?>? pressureSensorHpa,
    Value<double?>? pressureStationHpa,
    Value<Map<String, dynamic>?>? weather,
    Value<bool>? finishLater,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AttacksCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      intensity: intensity ?? this.intensity,
      headLocations: headLocations ?? this.headLocations,
      phases: phases ?? this.phases,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
      pressureSensorHpa: pressureSensorHpa ?? this.pressureSensorHpa,
      pressureStationHpa: pressureStationHpa ?? this.pressureStationHpa,
      weather: weather ?? this.weather,
      finishLater: finishLater ?? this.finishLater,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (headLocations.present) {
      map['head_locations'] = Variable<String>(
        $AttacksTable.$converterheadLocations.toSql(headLocations.value),
      );
    }
    if (phases.present) {
      map['phases'] = Variable<String>(
        $AttacksTable.$converterphases.toSql(phases.value),
      );
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(
        $AttacksTable.$convertersymptoms.toSql(symptoms.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (pressureSensorHpa.present) {
      map['pressure_sensor_hpa'] = Variable<double>(pressureSensorHpa.value);
    }
    if (pressureStationHpa.present) {
      map['pressure_station_hpa'] = Variable<double>(pressureStationHpa.value);
    }
    if (weather.present) {
      map['weather'] = Variable<String>(
        $AttacksTable.$converterweathern.toSql(weather.value),
      );
    }
    if (finishLater.present) {
      map['finish_later'] = Variable<bool>(finishLater.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttacksCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('intensity: $intensity, ')
          ..write('headLocations: $headLocations, ')
          ..write('phases: $phases, ')
          ..write('symptoms: $symptoms, ')
          ..write('notes: $notes, ')
          ..write('pressureSensorHpa: $pressureSensorHpa, ')
          ..write('pressureStationHpa: $pressureStationHpa, ')
          ..write('weather: $weather, ')
          ..write('finishLater: $finishLater, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckinsTable extends Checkins with TableInfo<$CheckinsTable, Checkin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 10,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sleepQualityMeta = const VerificationMeta(
    'sleepQuality',
  );
  @override
  late final GeneratedColumn<int> sleepQuality = GeneratedColumn<int>(
    'sleep_quality',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stressMeta = const VerificationMeta('stress');
  @override
  late final GeneratedColumn<int> stress = GeneratedColumn<int>(
    'stress',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _neckTensionMeta = const VerificationMeta(
    'neckTension',
  );
  @override
  late final GeneratedColumn<int> neckTension = GeneratedColumn<int>(
    'neck_tension',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caffeineMeta = const VerificationMeta(
    'caffeine',
  );
  @override
  late final GeneratedColumn<int> caffeine = GeneratedColumn<int>(
    'caffeine',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hydrationMeta = const VerificationMeta(
    'hydration',
  );
  @override
  late final GeneratedColumn<int> hydration = GeneratedColumn<int>(
    'hydration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alcoholMeta = const VerificationMeta(
    'alcohol',
  );
  @override
  late final GeneratedColumn<int> alcohol = GeneratedColumn<int>(
    'alcohol',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cycleDayMeta = const VerificationMeta(
    'cycleDay',
  );
  @override
  late final GeneratedColumn<int> cycleDay = GeneratedColumn<int>(
    'cycle_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lightExposureMeta = const VerificationMeta(
    'lightExposure',
  );
  @override
  late final GeneratedColumn<int> lightExposure = GeneratedColumn<int>(
    'light_exposure',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _screenExposureMeta = const VerificationMeta(
    'screenExposure',
  );
  @override
  late final GeneratedColumn<int> screenExposure = GeneratedColumn<int>(
    'screen_exposure',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  sources = GeneratedColumn<String>(
    'sources',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, dynamic>>($CheckinsTable.$convertersources);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  weather = GeneratedColumn<String>(
    'weather',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($CheckinsTable.$converterweathern);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    sleepQuality,
    stress,
    neckTension,
    caffeine,
    hydration,
    alcohol,
    cycleDay,
    lightExposure,
    screenExposure,
    sources,
    weather,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checkins';
  @override
  VerificationContext validateIntegrity(
    Insertable<Checkin> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('sleep_quality')) {
      context.handle(
        _sleepQualityMeta,
        sleepQuality.isAcceptableOrUnknown(
          data['sleep_quality']!,
          _sleepQualityMeta,
        ),
      );
    }
    if (data.containsKey('stress')) {
      context.handle(
        _stressMeta,
        stress.isAcceptableOrUnknown(data['stress']!, _stressMeta),
      );
    }
    if (data.containsKey('neck_tension')) {
      context.handle(
        _neckTensionMeta,
        neckTension.isAcceptableOrUnknown(
          data['neck_tension']!,
          _neckTensionMeta,
        ),
      );
    }
    if (data.containsKey('caffeine')) {
      context.handle(
        _caffeineMeta,
        caffeine.isAcceptableOrUnknown(data['caffeine']!, _caffeineMeta),
      );
    }
    if (data.containsKey('hydration')) {
      context.handle(
        _hydrationMeta,
        hydration.isAcceptableOrUnknown(data['hydration']!, _hydrationMeta),
      );
    }
    if (data.containsKey('alcohol')) {
      context.handle(
        _alcoholMeta,
        alcohol.isAcceptableOrUnknown(data['alcohol']!, _alcoholMeta),
      );
    }
    if (data.containsKey('cycle_day')) {
      context.handle(
        _cycleDayMeta,
        cycleDay.isAcceptableOrUnknown(data['cycle_day']!, _cycleDayMeta),
      );
    }
    if (data.containsKey('light_exposure')) {
      context.handle(
        _lightExposureMeta,
        lightExposure.isAcceptableOrUnknown(
          data['light_exposure']!,
          _lightExposureMeta,
        ),
      );
    }
    if (data.containsKey('screen_exposure')) {
      context.handle(
        _screenExposureMeta,
        screenExposure.isAcceptableOrUnknown(
          data['screen_exposure']!,
          _screenExposureMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  Checkin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Checkin(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      sleepQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_quality'],
      ),
      stress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stress'],
      ),
      neckTension: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}neck_tension'],
      ),
      caffeine: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}caffeine'],
      ),
      hydration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hydration'],
      ),
      alcohol: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alcohol'],
      ),
      cycleDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_day'],
      ),
      lightExposure: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}light_exposure'],
      ),
      screenExposure: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}screen_exposure'],
      ),
      sources: $CheckinsTable.$convertersources.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sources'],
        )!,
      ),
      weather: $CheckinsTable.$converterweathern.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}weather'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CheckinsTable createAlias(String alias) {
    return $CheckinsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $convertersources =
      const JsonMapConverter();
  static TypeConverter<Map<String, dynamic>, String> $converterweather =
      const JsonMapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterweathern =
      NullAwareTypeConverter.wrap($converterweather);
}

class Checkin extends DataClass implements Insertable<Checkin> {
  /// Local calendar date as `yyyy-MM-dd`.
  final String date;
  final int? sleepQuality;
  final int? stress;
  final int? neckTension;
  final int? caffeine;
  final int? hydration;
  final int? alcohol;
  final int? cycleDay;
  final int? lightExposure;
  final int? screenExposure;

  /// Field name to source (`typed`, `healthkit`, `health_connect`).
  final Map<String, dynamic> sources;

  /// Snapshot of the hour's weather attached at save time.
  final Map<String, dynamic>? weather;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Checkin({
    required this.date,
    this.sleepQuality,
    this.stress,
    this.neckTension,
    this.caffeine,
    this.hydration,
    this.alcohol,
    this.cycleDay,
    this.lightExposure,
    this.screenExposure,
    required this.sources,
    this.weather,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || sleepQuality != null) {
      map['sleep_quality'] = Variable<int>(sleepQuality);
    }
    if (!nullToAbsent || stress != null) {
      map['stress'] = Variable<int>(stress);
    }
    if (!nullToAbsent || neckTension != null) {
      map['neck_tension'] = Variable<int>(neckTension);
    }
    if (!nullToAbsent || caffeine != null) {
      map['caffeine'] = Variable<int>(caffeine);
    }
    if (!nullToAbsent || hydration != null) {
      map['hydration'] = Variable<int>(hydration);
    }
    if (!nullToAbsent || alcohol != null) {
      map['alcohol'] = Variable<int>(alcohol);
    }
    if (!nullToAbsent || cycleDay != null) {
      map['cycle_day'] = Variable<int>(cycleDay);
    }
    if (!nullToAbsent || lightExposure != null) {
      map['light_exposure'] = Variable<int>(lightExposure);
    }
    if (!nullToAbsent || screenExposure != null) {
      map['screen_exposure'] = Variable<int>(screenExposure);
    }
    {
      map['sources'] = Variable<String>(
        $CheckinsTable.$convertersources.toSql(sources),
      );
    }
    if (!nullToAbsent || weather != null) {
      map['weather'] = Variable<String>(
        $CheckinsTable.$converterweathern.toSql(weather),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CheckinsCompanion toCompanion(bool nullToAbsent) {
    return CheckinsCompanion(
      date: Value(date),
      sleepQuality: sleepQuality == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepQuality),
      stress: stress == null && nullToAbsent
          ? const Value.absent()
          : Value(stress),
      neckTension: neckTension == null && nullToAbsent
          ? const Value.absent()
          : Value(neckTension),
      caffeine: caffeine == null && nullToAbsent
          ? const Value.absent()
          : Value(caffeine),
      hydration: hydration == null && nullToAbsent
          ? const Value.absent()
          : Value(hydration),
      alcohol: alcohol == null && nullToAbsent
          ? const Value.absent()
          : Value(alcohol),
      cycleDay: cycleDay == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleDay),
      lightExposure: lightExposure == null && nullToAbsent
          ? const Value.absent()
          : Value(lightExposure),
      screenExposure: screenExposure == null && nullToAbsent
          ? const Value.absent()
          : Value(screenExposure),
      sources: Value(sources),
      weather: weather == null && nullToAbsent
          ? const Value.absent()
          : Value(weather),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Checkin.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Checkin(
      date: serializer.fromJson<String>(json['date']),
      sleepQuality: serializer.fromJson<int?>(json['sleepQuality']),
      stress: serializer.fromJson<int?>(json['stress']),
      neckTension: serializer.fromJson<int?>(json['neckTension']),
      caffeine: serializer.fromJson<int?>(json['caffeine']),
      hydration: serializer.fromJson<int?>(json['hydration']),
      alcohol: serializer.fromJson<int?>(json['alcohol']),
      cycleDay: serializer.fromJson<int?>(json['cycleDay']),
      lightExposure: serializer.fromJson<int?>(json['lightExposure']),
      screenExposure: serializer.fromJson<int?>(json['screenExposure']),
      sources: serializer.fromJson<Map<String, dynamic>>(json['sources']),
      weather: serializer.fromJson<Map<String, dynamic>?>(json['weather']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'sleepQuality': serializer.toJson<int?>(sleepQuality),
      'stress': serializer.toJson<int?>(stress),
      'neckTension': serializer.toJson<int?>(neckTension),
      'caffeine': serializer.toJson<int?>(caffeine),
      'hydration': serializer.toJson<int?>(hydration),
      'alcohol': serializer.toJson<int?>(alcohol),
      'cycleDay': serializer.toJson<int?>(cycleDay),
      'lightExposure': serializer.toJson<int?>(lightExposure),
      'screenExposure': serializer.toJson<int?>(screenExposure),
      'sources': serializer.toJson<Map<String, dynamic>>(sources),
      'weather': serializer.toJson<Map<String, dynamic>?>(weather),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Checkin copyWith({
    String? date,
    Value<int?> sleepQuality = const Value.absent(),
    Value<int?> stress = const Value.absent(),
    Value<int?> neckTension = const Value.absent(),
    Value<int?> caffeine = const Value.absent(),
    Value<int?> hydration = const Value.absent(),
    Value<int?> alcohol = const Value.absent(),
    Value<int?> cycleDay = const Value.absent(),
    Value<int?> lightExposure = const Value.absent(),
    Value<int?> screenExposure = const Value.absent(),
    Map<String, dynamic>? sources,
    Value<Map<String, dynamic>?> weather = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Checkin(
    date: date ?? this.date,
    sleepQuality: sleepQuality.present ? sleepQuality.value : this.sleepQuality,
    stress: stress.present ? stress.value : this.stress,
    neckTension: neckTension.present ? neckTension.value : this.neckTension,
    caffeine: caffeine.present ? caffeine.value : this.caffeine,
    hydration: hydration.present ? hydration.value : this.hydration,
    alcohol: alcohol.present ? alcohol.value : this.alcohol,
    cycleDay: cycleDay.present ? cycleDay.value : this.cycleDay,
    lightExposure: lightExposure.present
        ? lightExposure.value
        : this.lightExposure,
    screenExposure: screenExposure.present
        ? screenExposure.value
        : this.screenExposure,
    sources: sources ?? this.sources,
    weather: weather.present ? weather.value : this.weather,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Checkin copyWithCompanion(CheckinsCompanion data) {
    return Checkin(
      date: data.date.present ? data.date.value : this.date,
      sleepQuality: data.sleepQuality.present
          ? data.sleepQuality.value
          : this.sleepQuality,
      stress: data.stress.present ? data.stress.value : this.stress,
      neckTension: data.neckTension.present
          ? data.neckTension.value
          : this.neckTension,
      caffeine: data.caffeine.present ? data.caffeine.value : this.caffeine,
      hydration: data.hydration.present ? data.hydration.value : this.hydration,
      alcohol: data.alcohol.present ? data.alcohol.value : this.alcohol,
      cycleDay: data.cycleDay.present ? data.cycleDay.value : this.cycleDay,
      lightExposure: data.lightExposure.present
          ? data.lightExposure.value
          : this.lightExposure,
      screenExposure: data.screenExposure.present
          ? data.screenExposure.value
          : this.screenExposure,
      sources: data.sources.present ? data.sources.value : this.sources,
      weather: data.weather.present ? data.weather.value : this.weather,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Checkin(')
          ..write('date: $date, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('stress: $stress, ')
          ..write('neckTension: $neckTension, ')
          ..write('caffeine: $caffeine, ')
          ..write('hydration: $hydration, ')
          ..write('alcohol: $alcohol, ')
          ..write('cycleDay: $cycleDay, ')
          ..write('lightExposure: $lightExposure, ')
          ..write('screenExposure: $screenExposure, ')
          ..write('sources: $sources, ')
          ..write('weather: $weather, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    sleepQuality,
    stress,
    neckTension,
    caffeine,
    hydration,
    alcohol,
    cycleDay,
    lightExposure,
    screenExposure,
    sources,
    weather,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Checkin &&
          other.date == this.date &&
          other.sleepQuality == this.sleepQuality &&
          other.stress == this.stress &&
          other.neckTension == this.neckTension &&
          other.caffeine == this.caffeine &&
          other.hydration == this.hydration &&
          other.alcohol == this.alcohol &&
          other.cycleDay == this.cycleDay &&
          other.lightExposure == this.lightExposure &&
          other.screenExposure == this.screenExposure &&
          other.sources == this.sources &&
          other.weather == this.weather &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CheckinsCompanion extends UpdateCompanion<Checkin> {
  final Value<String> date;
  final Value<int?> sleepQuality;
  final Value<int?> stress;
  final Value<int?> neckTension;
  final Value<int?> caffeine;
  final Value<int?> hydration;
  final Value<int?> alcohol;
  final Value<int?> cycleDay;
  final Value<int?> lightExposure;
  final Value<int?> screenExposure;
  final Value<Map<String, dynamic>> sources;
  final Value<Map<String, dynamic>?> weather;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CheckinsCompanion({
    this.date = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.stress = const Value.absent(),
    this.neckTension = const Value.absent(),
    this.caffeine = const Value.absent(),
    this.hydration = const Value.absent(),
    this.alcohol = const Value.absent(),
    this.cycleDay = const Value.absent(),
    this.lightExposure = const Value.absent(),
    this.screenExposure = const Value.absent(),
    this.sources = const Value.absent(),
    this.weather = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckinsCompanion.insert({
    required String date,
    this.sleepQuality = const Value.absent(),
    this.stress = const Value.absent(),
    this.neckTension = const Value.absent(),
    this.caffeine = const Value.absent(),
    this.hydration = const Value.absent(),
    this.alcohol = const Value.absent(),
    this.cycleDay = const Value.absent(),
    this.lightExposure = const Value.absent(),
    this.screenExposure = const Value.absent(),
    this.sources = const Value.absent(),
    this.weather = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Checkin> custom({
    Expression<String>? date,
    Expression<int>? sleepQuality,
    Expression<int>? stress,
    Expression<int>? neckTension,
    Expression<int>? caffeine,
    Expression<int>? hydration,
    Expression<int>? alcohol,
    Expression<int>? cycleDay,
    Expression<int>? lightExposure,
    Expression<int>? screenExposure,
    Expression<String>? sources,
    Expression<String>? weather,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (sleepQuality != null) 'sleep_quality': sleepQuality,
      if (stress != null) 'stress': stress,
      if (neckTension != null) 'neck_tension': neckTension,
      if (caffeine != null) 'caffeine': caffeine,
      if (hydration != null) 'hydration': hydration,
      if (alcohol != null) 'alcohol': alcohol,
      if (cycleDay != null) 'cycle_day': cycleDay,
      if (lightExposure != null) 'light_exposure': lightExposure,
      if (screenExposure != null) 'screen_exposure': screenExposure,
      if (sources != null) 'sources': sources,
      if (weather != null) 'weather': weather,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckinsCompanion copyWith({
    Value<String>? date,
    Value<int?>? sleepQuality,
    Value<int?>? stress,
    Value<int?>? neckTension,
    Value<int?>? caffeine,
    Value<int?>? hydration,
    Value<int?>? alcohol,
    Value<int?>? cycleDay,
    Value<int?>? lightExposure,
    Value<int?>? screenExposure,
    Value<Map<String, dynamic>>? sources,
    Value<Map<String, dynamic>?>? weather,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CheckinsCompanion(
      date: date ?? this.date,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      stress: stress ?? this.stress,
      neckTension: neckTension ?? this.neckTension,
      caffeine: caffeine ?? this.caffeine,
      hydration: hydration ?? this.hydration,
      alcohol: alcohol ?? this.alcohol,
      cycleDay: cycleDay ?? this.cycleDay,
      lightExposure: lightExposure ?? this.lightExposure,
      screenExposure: screenExposure ?? this.screenExposure,
      sources: sources ?? this.sources,
      weather: weather ?? this.weather,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (sleepQuality.present) {
      map['sleep_quality'] = Variable<int>(sleepQuality.value);
    }
    if (stress.present) {
      map['stress'] = Variable<int>(stress.value);
    }
    if (neckTension.present) {
      map['neck_tension'] = Variable<int>(neckTension.value);
    }
    if (caffeine.present) {
      map['caffeine'] = Variable<int>(caffeine.value);
    }
    if (hydration.present) {
      map['hydration'] = Variable<int>(hydration.value);
    }
    if (alcohol.present) {
      map['alcohol'] = Variable<int>(alcohol.value);
    }
    if (cycleDay.present) {
      map['cycle_day'] = Variable<int>(cycleDay.value);
    }
    if (lightExposure.present) {
      map['light_exposure'] = Variable<int>(lightExposure.value);
    }
    if (screenExposure.present) {
      map['screen_exposure'] = Variable<int>(screenExposure.value);
    }
    if (sources.present) {
      map['sources'] = Variable<String>(
        $CheckinsTable.$convertersources.toSql(sources.value),
      );
    }
    if (weather.present) {
      map['weather'] = Variable<String>(
        $CheckinsTable.$converterweathern.toSql(weather.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckinsCompanion(')
          ..write('date: $date, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('stress: $stress, ')
          ..write('neckTension: $neckTension, ')
          ..write('caffeine: $caffeine, ')
          ..write('hydration: $hydration, ')
          ..write('alcohol: $alcohol, ')
          ..write('cycleDay: $cycleDay, ')
          ..write('lightExposure: $lightExposure, ')
          ..write('screenExposure: $screenExposure, ')
          ..write('sources: $sources, ')
          ..write('weather: $weather, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationEventsTable extends MedicationEvents
    with TableInfo<$MedicationEventsTable, MedicationEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attackIdMeta = const VerificationMeta(
    'attackId',
  );
  @override
  late final GeneratedColumn<String> attackId = GeneratedColumn<String>(
    'attack_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES attacks (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
    'dose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reliefAt2hMeta = const VerificationMeta(
    'reliefAt2h',
  );
  @override
  late final GeneratedColumn<int> reliefAt2h = GeneratedColumn<int>(
    'relief_at2h',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    attackId,
    name,
    dose,
    takenAt,
    reliefAt2h,
    kind,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('attack_id')) {
      context.handle(
        _attackIdMeta,
        attackId.isAcceptableOrUnknown(data['attack_id']!, _attackIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('relief_at2h')) {
      context.handle(
        _reliefAt2hMeta,
        reliefAt2h.isAcceptableOrUnknown(data['relief_at2h']!, _reliefAt2hMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      attackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attack_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose'],
      ),
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      reliefAt2h: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}relief_at2h'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MedicationEventsTable createAlias(String alias) {
    return $MedicationEventsTable(attachedDatabase, alias);
  }
}

class MedicationEvent extends DataClass implements Insertable<MedicationEvent> {
  final String id;
  final String? attackId;
  final String name;
  final String? dose;
  final DateTime takenAt;

  /// Relief at 2 hours: 0 none, 1 partial, 2 full. Null until answered.
  final int? reliefAt2h;

  /// `acute` or `preventive`.
  final String kind;
  final DateTime createdAt;
  const MedicationEvent({
    required this.id,
    this.attackId,
    required this.name,
    this.dose,
    required this.takenAt,
    this.reliefAt2h,
    required this.kind,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || attackId != null) {
      map['attack_id'] = Variable<String>(attackId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dose != null) {
      map['dose'] = Variable<String>(dose);
    }
    map['taken_at'] = Variable<DateTime>(takenAt);
    if (!nullToAbsent || reliefAt2h != null) {
      map['relief_at2h'] = Variable<int>(reliefAt2h);
    }
    map['kind'] = Variable<String>(kind);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MedicationEventsCompanion toCompanion(bool nullToAbsent) {
    return MedicationEventsCompanion(
      id: Value(id),
      attackId: attackId == null && nullToAbsent
          ? const Value.absent()
          : Value(attackId),
      name: Value(name),
      dose: dose == null && nullToAbsent ? const Value.absent() : Value(dose),
      takenAt: Value(takenAt),
      reliefAt2h: reliefAt2h == null && nullToAbsent
          ? const Value.absent()
          : Value(reliefAt2h),
      kind: Value(kind),
      createdAt: Value(createdAt),
    );
  }

  factory MedicationEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationEvent(
      id: serializer.fromJson<String>(json['id']),
      attackId: serializer.fromJson<String?>(json['attackId']),
      name: serializer.fromJson<String>(json['name']),
      dose: serializer.fromJson<String?>(json['dose']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      reliefAt2h: serializer.fromJson<int?>(json['reliefAt2h']),
      kind: serializer.fromJson<String>(json['kind']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'attackId': serializer.toJson<String?>(attackId),
      'name': serializer.toJson<String>(name),
      'dose': serializer.toJson<String?>(dose),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'reliefAt2h': serializer.toJson<int?>(reliefAt2h),
      'kind': serializer.toJson<String>(kind),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MedicationEvent copyWith({
    String? id,
    Value<String?> attackId = const Value.absent(),
    String? name,
    Value<String?> dose = const Value.absent(),
    DateTime? takenAt,
    Value<int?> reliefAt2h = const Value.absent(),
    String? kind,
    DateTime? createdAt,
  }) => MedicationEvent(
    id: id ?? this.id,
    attackId: attackId.present ? attackId.value : this.attackId,
    name: name ?? this.name,
    dose: dose.present ? dose.value : this.dose,
    takenAt: takenAt ?? this.takenAt,
    reliefAt2h: reliefAt2h.present ? reliefAt2h.value : this.reliefAt2h,
    kind: kind ?? this.kind,
    createdAt: createdAt ?? this.createdAt,
  );
  MedicationEvent copyWithCompanion(MedicationEventsCompanion data) {
    return MedicationEvent(
      id: data.id.present ? data.id.value : this.id,
      attackId: data.attackId.present ? data.attackId.value : this.attackId,
      name: data.name.present ? data.name.value : this.name,
      dose: data.dose.present ? data.dose.value : this.dose,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      reliefAt2h: data.reliefAt2h.present
          ? data.reliefAt2h.value
          : this.reliefAt2h,
      kind: data.kind.present ? data.kind.value : this.kind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationEvent(')
          ..write('id: $id, ')
          ..write('attackId: $attackId, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('takenAt: $takenAt, ')
          ..write('reliefAt2h: $reliefAt2h, ')
          ..write('kind: $kind, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    attackId,
    name,
    dose,
    takenAt,
    reliefAt2h,
    kind,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationEvent &&
          other.id == this.id &&
          other.attackId == this.attackId &&
          other.name == this.name &&
          other.dose == this.dose &&
          other.takenAt == this.takenAt &&
          other.reliefAt2h == this.reliefAt2h &&
          other.kind == this.kind &&
          other.createdAt == this.createdAt);
}

class MedicationEventsCompanion extends UpdateCompanion<MedicationEvent> {
  final Value<String> id;
  final Value<String?> attackId;
  final Value<String> name;
  final Value<String?> dose;
  final Value<DateTime> takenAt;
  final Value<int?> reliefAt2h;
  final Value<String> kind;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MedicationEventsCompanion({
    this.id = const Value.absent(),
    this.attackId = const Value.absent(),
    this.name = const Value.absent(),
    this.dose = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.reliefAt2h = const Value.absent(),
    this.kind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationEventsCompanion.insert({
    required String id,
    this.attackId = const Value.absent(),
    required String name,
    this.dose = const Value.absent(),
    required DateTime takenAt,
    this.reliefAt2h = const Value.absent(),
    required String kind,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       takenAt = Value(takenAt),
       kind = Value(kind),
       createdAt = Value(createdAt);
  static Insertable<MedicationEvent> custom({
    Expression<String>? id,
    Expression<String>? attackId,
    Expression<String>? name,
    Expression<String>? dose,
    Expression<DateTime>? takenAt,
    Expression<int>? reliefAt2h,
    Expression<String>? kind,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (attackId != null) 'attack_id': attackId,
      if (name != null) 'name': name,
      if (dose != null) 'dose': dose,
      if (takenAt != null) 'taken_at': takenAt,
      if (reliefAt2h != null) 'relief_at2h': reliefAt2h,
      if (kind != null) 'kind': kind,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationEventsCompanion copyWith({
    Value<String>? id,
    Value<String?>? attackId,
    Value<String>? name,
    Value<String?>? dose,
    Value<DateTime>? takenAt,
    Value<int?>? reliefAt2h,
    Value<String>? kind,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MedicationEventsCompanion(
      id: id ?? this.id,
      attackId: attackId ?? this.attackId,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      takenAt: takenAt ?? this.takenAt,
      reliefAt2h: reliefAt2h ?? this.reliefAt2h,
      kind: kind ?? this.kind,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (attackId.present) {
      map['attack_id'] = Variable<String>(attackId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (reliefAt2h.present) {
      map['relief_at2h'] = Variable<int>(reliefAt2h.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationEventsCompanion(')
          ..write('id: $id, ')
          ..write('attackId: $attackId, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('takenAt: $takenAt, ')
          ..write('reliefAt2h: $reliefAt2h, ')
          ..write('kind: $kind, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeatherHoursTable extends WeatherHours
    with TableInfo<$WeatherHoursTable, WeatherHour> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherHoursTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cellMeta = const VerificationMeta('cell');
  @override
  late final GeneratedColumn<String> cell = GeneratedColumn<String>(
    'cell',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hourUtcMeta = const VerificationMeta(
    'hourUtc',
  );
  @override
  late final GeneratedColumn<DateTime> hourUtc = GeneratedColumn<DateTime>(
    'hour_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pressureMslMeta = const VerificationMeta(
    'pressureMsl',
  );
  @override
  late final GeneratedColumn<double> pressureMsl = GeneratedColumn<double>(
    'pressure_msl',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _surfacePressureMeta = const VerificationMeta(
    'surfacePressure',
  );
  @override
  late final GeneratedColumn<double> surfacePressure = GeneratedColumn<double>(
    'surface_pressure',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _humidityMeta = const VerificationMeta(
    'humidity',
  );
  @override
  late final GeneratedColumn<double> humidity = GeneratedColumn<double>(
    'humidity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _precipitationMeta = const VerificationMeta(
    'precipitation',
  );
  @override
  late final GeneratedColumn<double> precipitation = GeneratedColumn<double>(
    'precipitation',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windMeta = const VerificationMeta('wind');
  @override
  late final GeneratedColumn<double> wind = GeneratedColumn<double>(
    'wind',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cloudMeta = const VerificationMeta('cloud');
  @override
  late final GeneratedColumn<double> cloud = GeneratedColumn<double>(
    'cloud',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherCodeMeta = const VerificationMeta(
    'weatherCode',
  );
  @override
  late final GeneratedColumn<int> weatherCode = GeneratedColumn<int>(
    'weather_code',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uvMeta = const VerificationMeta('uv');
  @override
  late final GeneratedColumn<double> uv = GeneratedColumn<double>(
    'uv',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open-meteo'),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
    'pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    cell,
    hourUtc,
    pressureMsl,
    surfacePressure,
    temperature,
    humidity,
    precipitation,
    wind,
    cloud,
    weatherCode,
    uv,
    source,
    fetchedAt,
    pinned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_hours';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeatherHour> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cell')) {
      context.handle(
        _cellMeta,
        cell.isAcceptableOrUnknown(data['cell']!, _cellMeta),
      );
    } else if (isInserting) {
      context.missing(_cellMeta);
    }
    if (data.containsKey('hour_utc')) {
      context.handle(
        _hourUtcMeta,
        hourUtc.isAcceptableOrUnknown(data['hour_utc']!, _hourUtcMeta),
      );
    } else if (isInserting) {
      context.missing(_hourUtcMeta);
    }
    if (data.containsKey('pressure_msl')) {
      context.handle(
        _pressureMslMeta,
        pressureMsl.isAcceptableOrUnknown(
          data['pressure_msl']!,
          _pressureMslMeta,
        ),
      );
    }
    if (data.containsKey('surface_pressure')) {
      context.handle(
        _surfacePressureMeta,
        surfacePressure.isAcceptableOrUnknown(
          data['surface_pressure']!,
          _surfacePressureMeta,
        ),
      );
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('humidity')) {
      context.handle(
        _humidityMeta,
        humidity.isAcceptableOrUnknown(data['humidity']!, _humidityMeta),
      );
    }
    if (data.containsKey('precipitation')) {
      context.handle(
        _precipitationMeta,
        precipitation.isAcceptableOrUnknown(
          data['precipitation']!,
          _precipitationMeta,
        ),
      );
    }
    if (data.containsKey('wind')) {
      context.handle(
        _windMeta,
        wind.isAcceptableOrUnknown(data['wind']!, _windMeta),
      );
    }
    if (data.containsKey('cloud')) {
      context.handle(
        _cloudMeta,
        cloud.isAcceptableOrUnknown(data['cloud']!, _cloudMeta),
      );
    }
    if (data.containsKey('weather_code')) {
      context.handle(
        _weatherCodeMeta,
        weatherCode.isAcceptableOrUnknown(
          data['weather_code']!,
          _weatherCodeMeta,
        ),
      );
    }
    if (data.containsKey('uv')) {
      context.handle(_uvMeta, uv.isAcceptableOrUnknown(data['uv']!, _uvMeta));
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('pinned')) {
      context.handle(
        _pinnedMeta,
        pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cell, hourUtc};
  @override
  WeatherHour map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherHour(
      cell: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cell'],
      )!,
      hourUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}hour_utc'],
      )!,
      pressureMsl: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pressure_msl'],
      ),
      surfacePressure: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}surface_pressure'],
      ),
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      humidity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}humidity'],
      ),
      precipitation: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precipitation'],
      ),
      wind: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wind'],
      ),
      cloud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cloud'],
      ),
      weatherCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weather_code'],
      ),
      uv: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}uv'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      pinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pinned'],
      )!,
    );
  }

  @override
  $WeatherHoursTable createAlias(String alias) {
    return $WeatherHoursTable(attachedDatabase, alias);
  }
}

class WeatherHour extends DataClass implements Insertable<WeatherHour> {
  /// Cell key, for example `51.5,-0.1`.
  final String cell;
  final DateTime hourUtc;
  final double? pressureMsl;
  final double? surfacePressure;
  final double? temperature;
  final double? humidity;
  final double? precipitation;
  final double? wind;
  final double? cloud;
  final int? weatherCode;
  final double? uv;
  final String source;
  final DateTime fetchedAt;
  final bool pinned;
  const WeatherHour({
    required this.cell,
    required this.hourUtc,
    this.pressureMsl,
    this.surfacePressure,
    this.temperature,
    this.humidity,
    this.precipitation,
    this.wind,
    this.cloud,
    this.weatherCode,
    this.uv,
    required this.source,
    required this.fetchedAt,
    required this.pinned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cell'] = Variable<String>(cell);
    map['hour_utc'] = Variable<DateTime>(hourUtc);
    if (!nullToAbsent || pressureMsl != null) {
      map['pressure_msl'] = Variable<double>(pressureMsl);
    }
    if (!nullToAbsent || surfacePressure != null) {
      map['surface_pressure'] = Variable<double>(surfacePressure);
    }
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    if (!nullToAbsent || humidity != null) {
      map['humidity'] = Variable<double>(humidity);
    }
    if (!nullToAbsent || precipitation != null) {
      map['precipitation'] = Variable<double>(precipitation);
    }
    if (!nullToAbsent || wind != null) {
      map['wind'] = Variable<double>(wind);
    }
    if (!nullToAbsent || cloud != null) {
      map['cloud'] = Variable<double>(cloud);
    }
    if (!nullToAbsent || weatherCode != null) {
      map['weather_code'] = Variable<int>(weatherCode);
    }
    if (!nullToAbsent || uv != null) {
      map['uv'] = Variable<double>(uv);
    }
    map['source'] = Variable<String>(source);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['pinned'] = Variable<bool>(pinned);
    return map;
  }

  WeatherHoursCompanion toCompanion(bool nullToAbsent) {
    return WeatherHoursCompanion(
      cell: Value(cell),
      hourUtc: Value(hourUtc),
      pressureMsl: pressureMsl == null && nullToAbsent
          ? const Value.absent()
          : Value(pressureMsl),
      surfacePressure: surfacePressure == null && nullToAbsent
          ? const Value.absent()
          : Value(surfacePressure),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      humidity: humidity == null && nullToAbsent
          ? const Value.absent()
          : Value(humidity),
      precipitation: precipitation == null && nullToAbsent
          ? const Value.absent()
          : Value(precipitation),
      wind: wind == null && nullToAbsent ? const Value.absent() : Value(wind),
      cloud: cloud == null && nullToAbsent
          ? const Value.absent()
          : Value(cloud),
      weatherCode: weatherCode == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherCode),
      uv: uv == null && nullToAbsent ? const Value.absent() : Value(uv),
      source: Value(source),
      fetchedAt: Value(fetchedAt),
      pinned: Value(pinned),
    );
  }

  factory WeatherHour.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherHour(
      cell: serializer.fromJson<String>(json['cell']),
      hourUtc: serializer.fromJson<DateTime>(json['hourUtc']),
      pressureMsl: serializer.fromJson<double?>(json['pressureMsl']),
      surfacePressure: serializer.fromJson<double?>(json['surfacePressure']),
      temperature: serializer.fromJson<double?>(json['temperature']),
      humidity: serializer.fromJson<double?>(json['humidity']),
      precipitation: serializer.fromJson<double?>(json['precipitation']),
      wind: serializer.fromJson<double?>(json['wind']),
      cloud: serializer.fromJson<double?>(json['cloud']),
      weatherCode: serializer.fromJson<int?>(json['weatherCode']),
      uv: serializer.fromJson<double?>(json['uv']),
      source: serializer.fromJson<String>(json['source']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      pinned: serializer.fromJson<bool>(json['pinned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cell': serializer.toJson<String>(cell),
      'hourUtc': serializer.toJson<DateTime>(hourUtc),
      'pressureMsl': serializer.toJson<double?>(pressureMsl),
      'surfacePressure': serializer.toJson<double?>(surfacePressure),
      'temperature': serializer.toJson<double?>(temperature),
      'humidity': serializer.toJson<double?>(humidity),
      'precipitation': serializer.toJson<double?>(precipitation),
      'wind': serializer.toJson<double?>(wind),
      'cloud': serializer.toJson<double?>(cloud),
      'weatherCode': serializer.toJson<int?>(weatherCode),
      'uv': serializer.toJson<double?>(uv),
      'source': serializer.toJson<String>(source),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'pinned': serializer.toJson<bool>(pinned),
    };
  }

  WeatherHour copyWith({
    String? cell,
    DateTime? hourUtc,
    Value<double?> pressureMsl = const Value.absent(),
    Value<double?> surfacePressure = const Value.absent(),
    Value<double?> temperature = const Value.absent(),
    Value<double?> humidity = const Value.absent(),
    Value<double?> precipitation = const Value.absent(),
    Value<double?> wind = const Value.absent(),
    Value<double?> cloud = const Value.absent(),
    Value<int?> weatherCode = const Value.absent(),
    Value<double?> uv = const Value.absent(),
    String? source,
    DateTime? fetchedAt,
    bool? pinned,
  }) => WeatherHour(
    cell: cell ?? this.cell,
    hourUtc: hourUtc ?? this.hourUtc,
    pressureMsl: pressureMsl.present ? pressureMsl.value : this.pressureMsl,
    surfacePressure: surfacePressure.present
        ? surfacePressure.value
        : this.surfacePressure,
    temperature: temperature.present ? temperature.value : this.temperature,
    humidity: humidity.present ? humidity.value : this.humidity,
    precipitation: precipitation.present
        ? precipitation.value
        : this.precipitation,
    wind: wind.present ? wind.value : this.wind,
    cloud: cloud.present ? cloud.value : this.cloud,
    weatherCode: weatherCode.present ? weatherCode.value : this.weatherCode,
    uv: uv.present ? uv.value : this.uv,
    source: source ?? this.source,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    pinned: pinned ?? this.pinned,
  );
  WeatherHour copyWithCompanion(WeatherHoursCompanion data) {
    return WeatherHour(
      cell: data.cell.present ? data.cell.value : this.cell,
      hourUtc: data.hourUtc.present ? data.hourUtc.value : this.hourUtc,
      pressureMsl: data.pressureMsl.present
          ? data.pressureMsl.value
          : this.pressureMsl,
      surfacePressure: data.surfacePressure.present
          ? data.surfacePressure.value
          : this.surfacePressure,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      humidity: data.humidity.present ? data.humidity.value : this.humidity,
      precipitation: data.precipitation.present
          ? data.precipitation.value
          : this.precipitation,
      wind: data.wind.present ? data.wind.value : this.wind,
      cloud: data.cloud.present ? data.cloud.value : this.cloud,
      weatherCode: data.weatherCode.present
          ? data.weatherCode.value
          : this.weatherCode,
      uv: data.uv.present ? data.uv.value : this.uv,
      source: data.source.present ? data.source.value : this.source,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeatherHour(')
          ..write('cell: $cell, ')
          ..write('hourUtc: $hourUtc, ')
          ..write('pressureMsl: $pressureMsl, ')
          ..write('surfacePressure: $surfacePressure, ')
          ..write('temperature: $temperature, ')
          ..write('humidity: $humidity, ')
          ..write('precipitation: $precipitation, ')
          ..write('wind: $wind, ')
          ..write('cloud: $cloud, ')
          ..write('weatherCode: $weatherCode, ')
          ..write('uv: $uv, ')
          ..write('source: $source, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('pinned: $pinned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    cell,
    hourUtc,
    pressureMsl,
    surfacePressure,
    temperature,
    humidity,
    precipitation,
    wind,
    cloud,
    weatherCode,
    uv,
    source,
    fetchedAt,
    pinned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherHour &&
          other.cell == this.cell &&
          other.hourUtc == this.hourUtc &&
          other.pressureMsl == this.pressureMsl &&
          other.surfacePressure == this.surfacePressure &&
          other.temperature == this.temperature &&
          other.humidity == this.humidity &&
          other.precipitation == this.precipitation &&
          other.wind == this.wind &&
          other.cloud == this.cloud &&
          other.weatherCode == this.weatherCode &&
          other.uv == this.uv &&
          other.source == this.source &&
          other.fetchedAt == this.fetchedAt &&
          other.pinned == this.pinned);
}

class WeatherHoursCompanion extends UpdateCompanion<WeatherHour> {
  final Value<String> cell;
  final Value<DateTime> hourUtc;
  final Value<double?> pressureMsl;
  final Value<double?> surfacePressure;
  final Value<double?> temperature;
  final Value<double?> humidity;
  final Value<double?> precipitation;
  final Value<double?> wind;
  final Value<double?> cloud;
  final Value<int?> weatherCode;
  final Value<double?> uv;
  final Value<String> source;
  final Value<DateTime> fetchedAt;
  final Value<bool> pinned;
  final Value<int> rowid;
  const WeatherHoursCompanion({
    this.cell = const Value.absent(),
    this.hourUtc = const Value.absent(),
    this.pressureMsl = const Value.absent(),
    this.surfacePressure = const Value.absent(),
    this.temperature = const Value.absent(),
    this.humidity = const Value.absent(),
    this.precipitation = const Value.absent(),
    this.wind = const Value.absent(),
    this.cloud = const Value.absent(),
    this.weatherCode = const Value.absent(),
    this.uv = const Value.absent(),
    this.source = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.pinned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeatherHoursCompanion.insert({
    required String cell,
    required DateTime hourUtc,
    this.pressureMsl = const Value.absent(),
    this.surfacePressure = const Value.absent(),
    this.temperature = const Value.absent(),
    this.humidity = const Value.absent(),
    this.precipitation = const Value.absent(),
    this.wind = const Value.absent(),
    this.cloud = const Value.absent(),
    this.weatherCode = const Value.absent(),
    this.uv = const Value.absent(),
    this.source = const Value.absent(),
    required DateTime fetchedAt,
    this.pinned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : cell = Value(cell),
       hourUtc = Value(hourUtc),
       fetchedAt = Value(fetchedAt);
  static Insertable<WeatherHour> custom({
    Expression<String>? cell,
    Expression<DateTime>? hourUtc,
    Expression<double>? pressureMsl,
    Expression<double>? surfacePressure,
    Expression<double>? temperature,
    Expression<double>? humidity,
    Expression<double>? precipitation,
    Expression<double>? wind,
    Expression<double>? cloud,
    Expression<int>? weatherCode,
    Expression<double>? uv,
    Expression<String>? source,
    Expression<DateTime>? fetchedAt,
    Expression<bool>? pinned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cell != null) 'cell': cell,
      if (hourUtc != null) 'hour_utc': hourUtc,
      if (pressureMsl != null) 'pressure_msl': pressureMsl,
      if (surfacePressure != null) 'surface_pressure': surfacePressure,
      if (temperature != null) 'temperature': temperature,
      if (humidity != null) 'humidity': humidity,
      if (precipitation != null) 'precipitation': precipitation,
      if (wind != null) 'wind': wind,
      if (cloud != null) 'cloud': cloud,
      if (weatherCode != null) 'weather_code': weatherCode,
      if (uv != null) 'uv': uv,
      if (source != null) 'source': source,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (pinned != null) 'pinned': pinned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeatherHoursCompanion copyWith({
    Value<String>? cell,
    Value<DateTime>? hourUtc,
    Value<double?>? pressureMsl,
    Value<double?>? surfacePressure,
    Value<double?>? temperature,
    Value<double?>? humidity,
    Value<double?>? precipitation,
    Value<double?>? wind,
    Value<double?>? cloud,
    Value<int?>? weatherCode,
    Value<double?>? uv,
    Value<String>? source,
    Value<DateTime>? fetchedAt,
    Value<bool>? pinned,
    Value<int>? rowid,
  }) {
    return WeatherHoursCompanion(
      cell: cell ?? this.cell,
      hourUtc: hourUtc ?? this.hourUtc,
      pressureMsl: pressureMsl ?? this.pressureMsl,
      surfacePressure: surfacePressure ?? this.surfacePressure,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      precipitation: precipitation ?? this.precipitation,
      wind: wind ?? this.wind,
      cloud: cloud ?? this.cloud,
      weatherCode: weatherCode ?? this.weatherCode,
      uv: uv ?? this.uv,
      source: source ?? this.source,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      pinned: pinned ?? this.pinned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cell.present) {
      map['cell'] = Variable<String>(cell.value);
    }
    if (hourUtc.present) {
      map['hour_utc'] = Variable<DateTime>(hourUtc.value);
    }
    if (pressureMsl.present) {
      map['pressure_msl'] = Variable<double>(pressureMsl.value);
    }
    if (surfacePressure.present) {
      map['surface_pressure'] = Variable<double>(surfacePressure.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (humidity.present) {
      map['humidity'] = Variable<double>(humidity.value);
    }
    if (precipitation.present) {
      map['precipitation'] = Variable<double>(precipitation.value);
    }
    if (wind.present) {
      map['wind'] = Variable<double>(wind.value);
    }
    if (cloud.present) {
      map['cloud'] = Variable<double>(cloud.value);
    }
    if (weatherCode.present) {
      map['weather_code'] = Variable<int>(weatherCode.value);
    }
    if (uv.present) {
      map['uv'] = Variable<double>(uv.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherHoursCompanion(')
          ..write('cell: $cell, ')
          ..write('hourUtc: $hourUtc, ')
          ..write('pressureMsl: $pressureMsl, ')
          ..write('surfacePressure: $surfacePressure, ')
          ..write('temperature: $temperature, ')
          ..write('humidity: $humidity, ')
          ..write('precipitation: $precipitation, ')
          ..write('wind: $wind, ')
          ..write('cloud: $cloud, ')
          ..write('weatherCode: $weatherCode, ')
          ..write('uv: $uv, ')
          ..write('source: $source, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('pinned: $pinned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EnvironmentDaysTable extends EnvironmentDays
    with TableInfo<$EnvironmentDaysTable, EnvironmentDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvironmentDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 10,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cellMeta = const VerificationMeta('cell');
  @override
  late final GeneratedColumn<String> cell = GeneratedColumn<String>(
    'cell',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aqiUsMeta = const VerificationMeta('aqiUs');
  @override
  late final GeneratedColumn<double> aqiUs = GeneratedColumn<double>(
    'aqi_us',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aqiEuMeta = const VerificationMeta('aqiEu');
  @override
  late final GeneratedColumn<double> aqiEu = GeneratedColumn<double>(
    'aqi_eu',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pm25Meta = const VerificationMeta('pm25');
  @override
  late final GeneratedColumn<double> pm25 = GeneratedColumn<double>(
    'pm25',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pm10Meta = const VerificationMeta('pm10');
  @override
  late final GeneratedColumn<double> pm10 = GeneratedColumn<double>(
    'pm10',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ozoneMeta = const VerificationMeta('ozone');
  @override
  late final GeneratedColumn<double> ozone = GeneratedColumn<double>(
    'ozone',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  pollen =
      GeneratedColumn<String>(
        'pollen',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Map<String, dynamic>?>(
        $EnvironmentDaysTable.$converterpollenn,
      );
  static const VerificationMeta _uvMaxMeta = const VerificationMeta('uvMax');
  @override
  late final GeneratedColumn<double> uvMax = GeneratedColumn<double>(
    'uv_max',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _daylightMinutesMeta = const VerificationMeta(
    'daylightMinutes',
  );
  @override
  late final GeneratedColumn<int> daylightMinutes = GeneratedColumn<int>(
    'daylight_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sunriseMeta = const VerificationMeta(
    'sunrise',
  );
  @override
  late final GeneratedColumn<DateTime> sunrise = GeneratedColumn<DateTime>(
    'sunrise',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sunsetMeta = const VerificationMeta('sunset');
  @override
  late final GeneratedColumn<DateTime> sunset = GeneratedColumn<DateTime>(
    'sunset',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    cell,
    aqiUs,
    aqiEu,
    pm25,
    pm10,
    ozone,
    pollen,
    uvMax,
    daylightMinutes,
    sunrise,
    sunset,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'environment_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnvironmentDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('cell')) {
      context.handle(
        _cellMeta,
        cell.isAcceptableOrUnknown(data['cell']!, _cellMeta),
      );
    } else if (isInserting) {
      context.missing(_cellMeta);
    }
    if (data.containsKey('aqi_us')) {
      context.handle(
        _aqiUsMeta,
        aqiUs.isAcceptableOrUnknown(data['aqi_us']!, _aqiUsMeta),
      );
    }
    if (data.containsKey('aqi_eu')) {
      context.handle(
        _aqiEuMeta,
        aqiEu.isAcceptableOrUnknown(data['aqi_eu']!, _aqiEuMeta),
      );
    }
    if (data.containsKey('pm25')) {
      context.handle(
        _pm25Meta,
        pm25.isAcceptableOrUnknown(data['pm25']!, _pm25Meta),
      );
    }
    if (data.containsKey('pm10')) {
      context.handle(
        _pm10Meta,
        pm10.isAcceptableOrUnknown(data['pm10']!, _pm10Meta),
      );
    }
    if (data.containsKey('ozone')) {
      context.handle(
        _ozoneMeta,
        ozone.isAcceptableOrUnknown(data['ozone']!, _ozoneMeta),
      );
    }
    if (data.containsKey('uv_max')) {
      context.handle(
        _uvMaxMeta,
        uvMax.isAcceptableOrUnknown(data['uv_max']!, _uvMaxMeta),
      );
    }
    if (data.containsKey('daylight_minutes')) {
      context.handle(
        _daylightMinutesMeta,
        daylightMinutes.isAcceptableOrUnknown(
          data['daylight_minutes']!,
          _daylightMinutesMeta,
        ),
      );
    }
    if (data.containsKey('sunrise')) {
      context.handle(
        _sunriseMeta,
        sunrise.isAcceptableOrUnknown(data['sunrise']!, _sunriseMeta),
      );
    }
    if (data.containsKey('sunset')) {
      context.handle(
        _sunsetMeta,
        sunset.isAcceptableOrUnknown(data['sunset']!, _sunsetMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  EnvironmentDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvironmentDay(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      cell: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cell'],
      )!,
      aqiUs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}aqi_us'],
      ),
      aqiEu: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}aqi_eu'],
      ),
      pm25: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pm25'],
      ),
      pm10: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pm10'],
      ),
      ozone: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ozone'],
      ),
      pollen: $EnvironmentDaysTable.$converterpollenn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}pollen'],
        ),
      ),
      uvMax: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}uv_max'],
      ),
      daylightMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daylight_minutes'],
      ),
      sunrise: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sunrise'],
      ),
      sunset: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sunset'],
      ),
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $EnvironmentDaysTable createAlias(String alias) {
    return $EnvironmentDaysTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterpollen =
      const JsonMapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterpollenn =
      NullAwareTypeConverter.wrap($converterpollen);
}

class EnvironmentDay extends DataClass implements Insertable<EnvironmentDay> {
  /// Local calendar date as `yyyy-MM-dd`.
  final String date;
  final String cell;
  final double? aqiUs;
  final double? aqiEu;
  final double? pm25;
  final double? pm10;
  final double? ozone;

  /// Pollen counts keyed by species; null outside Europe.
  final Map<String, dynamic>? pollen;
  final double? uvMax;
  final int? daylightMinutes;
  final DateTime? sunrise;
  final DateTime? sunset;
  final DateTime fetchedAt;
  const EnvironmentDay({
    required this.date,
    required this.cell,
    this.aqiUs,
    this.aqiEu,
    this.pm25,
    this.pm10,
    this.ozone,
    this.pollen,
    this.uvMax,
    this.daylightMinutes,
    this.sunrise,
    this.sunset,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['cell'] = Variable<String>(cell);
    if (!nullToAbsent || aqiUs != null) {
      map['aqi_us'] = Variable<double>(aqiUs);
    }
    if (!nullToAbsent || aqiEu != null) {
      map['aqi_eu'] = Variable<double>(aqiEu);
    }
    if (!nullToAbsent || pm25 != null) {
      map['pm25'] = Variable<double>(pm25);
    }
    if (!nullToAbsent || pm10 != null) {
      map['pm10'] = Variable<double>(pm10);
    }
    if (!nullToAbsent || ozone != null) {
      map['ozone'] = Variable<double>(ozone);
    }
    if (!nullToAbsent || pollen != null) {
      map['pollen'] = Variable<String>(
        $EnvironmentDaysTable.$converterpollenn.toSql(pollen),
      );
    }
    if (!nullToAbsent || uvMax != null) {
      map['uv_max'] = Variable<double>(uvMax);
    }
    if (!nullToAbsent || daylightMinutes != null) {
      map['daylight_minutes'] = Variable<int>(daylightMinutes);
    }
    if (!nullToAbsent || sunrise != null) {
      map['sunrise'] = Variable<DateTime>(sunrise);
    }
    if (!nullToAbsent || sunset != null) {
      map['sunset'] = Variable<DateTime>(sunset);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  EnvironmentDaysCompanion toCompanion(bool nullToAbsent) {
    return EnvironmentDaysCompanion(
      date: Value(date),
      cell: Value(cell),
      aqiUs: aqiUs == null && nullToAbsent
          ? const Value.absent()
          : Value(aqiUs),
      aqiEu: aqiEu == null && nullToAbsent
          ? const Value.absent()
          : Value(aqiEu),
      pm25: pm25 == null && nullToAbsent ? const Value.absent() : Value(pm25),
      pm10: pm10 == null && nullToAbsent ? const Value.absent() : Value(pm10),
      ozone: ozone == null && nullToAbsent
          ? const Value.absent()
          : Value(ozone),
      pollen: pollen == null && nullToAbsent
          ? const Value.absent()
          : Value(pollen),
      uvMax: uvMax == null && nullToAbsent
          ? const Value.absent()
          : Value(uvMax),
      daylightMinutes: daylightMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(daylightMinutes),
      sunrise: sunrise == null && nullToAbsent
          ? const Value.absent()
          : Value(sunrise),
      sunset: sunset == null && nullToAbsent
          ? const Value.absent()
          : Value(sunset),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory EnvironmentDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvironmentDay(
      date: serializer.fromJson<String>(json['date']),
      cell: serializer.fromJson<String>(json['cell']),
      aqiUs: serializer.fromJson<double?>(json['aqiUs']),
      aqiEu: serializer.fromJson<double?>(json['aqiEu']),
      pm25: serializer.fromJson<double?>(json['pm25']),
      pm10: serializer.fromJson<double?>(json['pm10']),
      ozone: serializer.fromJson<double?>(json['ozone']),
      pollen: serializer.fromJson<Map<String, dynamic>?>(json['pollen']),
      uvMax: serializer.fromJson<double?>(json['uvMax']),
      daylightMinutes: serializer.fromJson<int?>(json['daylightMinutes']),
      sunrise: serializer.fromJson<DateTime?>(json['sunrise']),
      sunset: serializer.fromJson<DateTime?>(json['sunset']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'cell': serializer.toJson<String>(cell),
      'aqiUs': serializer.toJson<double?>(aqiUs),
      'aqiEu': serializer.toJson<double?>(aqiEu),
      'pm25': serializer.toJson<double?>(pm25),
      'pm10': serializer.toJson<double?>(pm10),
      'ozone': serializer.toJson<double?>(ozone),
      'pollen': serializer.toJson<Map<String, dynamic>?>(pollen),
      'uvMax': serializer.toJson<double?>(uvMax),
      'daylightMinutes': serializer.toJson<int?>(daylightMinutes),
      'sunrise': serializer.toJson<DateTime?>(sunrise),
      'sunset': serializer.toJson<DateTime?>(sunset),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  EnvironmentDay copyWith({
    String? date,
    String? cell,
    Value<double?> aqiUs = const Value.absent(),
    Value<double?> aqiEu = const Value.absent(),
    Value<double?> pm25 = const Value.absent(),
    Value<double?> pm10 = const Value.absent(),
    Value<double?> ozone = const Value.absent(),
    Value<Map<String, dynamic>?> pollen = const Value.absent(),
    Value<double?> uvMax = const Value.absent(),
    Value<int?> daylightMinutes = const Value.absent(),
    Value<DateTime?> sunrise = const Value.absent(),
    Value<DateTime?> sunset = const Value.absent(),
    DateTime? fetchedAt,
  }) => EnvironmentDay(
    date: date ?? this.date,
    cell: cell ?? this.cell,
    aqiUs: aqiUs.present ? aqiUs.value : this.aqiUs,
    aqiEu: aqiEu.present ? aqiEu.value : this.aqiEu,
    pm25: pm25.present ? pm25.value : this.pm25,
    pm10: pm10.present ? pm10.value : this.pm10,
    ozone: ozone.present ? ozone.value : this.ozone,
    pollen: pollen.present ? pollen.value : this.pollen,
    uvMax: uvMax.present ? uvMax.value : this.uvMax,
    daylightMinutes: daylightMinutes.present
        ? daylightMinutes.value
        : this.daylightMinutes,
    sunrise: sunrise.present ? sunrise.value : this.sunrise,
    sunset: sunset.present ? sunset.value : this.sunset,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  EnvironmentDay copyWithCompanion(EnvironmentDaysCompanion data) {
    return EnvironmentDay(
      date: data.date.present ? data.date.value : this.date,
      cell: data.cell.present ? data.cell.value : this.cell,
      aqiUs: data.aqiUs.present ? data.aqiUs.value : this.aqiUs,
      aqiEu: data.aqiEu.present ? data.aqiEu.value : this.aqiEu,
      pm25: data.pm25.present ? data.pm25.value : this.pm25,
      pm10: data.pm10.present ? data.pm10.value : this.pm10,
      ozone: data.ozone.present ? data.ozone.value : this.ozone,
      pollen: data.pollen.present ? data.pollen.value : this.pollen,
      uvMax: data.uvMax.present ? data.uvMax.value : this.uvMax,
      daylightMinutes: data.daylightMinutes.present
          ? data.daylightMinutes.value
          : this.daylightMinutes,
      sunrise: data.sunrise.present ? data.sunrise.value : this.sunrise,
      sunset: data.sunset.present ? data.sunset.value : this.sunset,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvironmentDay(')
          ..write('date: $date, ')
          ..write('cell: $cell, ')
          ..write('aqiUs: $aqiUs, ')
          ..write('aqiEu: $aqiEu, ')
          ..write('pm25: $pm25, ')
          ..write('pm10: $pm10, ')
          ..write('ozone: $ozone, ')
          ..write('pollen: $pollen, ')
          ..write('uvMax: $uvMax, ')
          ..write('daylightMinutes: $daylightMinutes, ')
          ..write('sunrise: $sunrise, ')
          ..write('sunset: $sunset, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    cell,
    aqiUs,
    aqiEu,
    pm25,
    pm10,
    ozone,
    pollen,
    uvMax,
    daylightMinutes,
    sunrise,
    sunset,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvironmentDay &&
          other.date == this.date &&
          other.cell == this.cell &&
          other.aqiUs == this.aqiUs &&
          other.aqiEu == this.aqiEu &&
          other.pm25 == this.pm25 &&
          other.pm10 == this.pm10 &&
          other.ozone == this.ozone &&
          other.pollen == this.pollen &&
          other.uvMax == this.uvMax &&
          other.daylightMinutes == this.daylightMinutes &&
          other.sunrise == this.sunrise &&
          other.sunset == this.sunset &&
          other.fetchedAt == this.fetchedAt);
}

class EnvironmentDaysCompanion extends UpdateCompanion<EnvironmentDay> {
  final Value<String> date;
  final Value<String> cell;
  final Value<double?> aqiUs;
  final Value<double?> aqiEu;
  final Value<double?> pm25;
  final Value<double?> pm10;
  final Value<double?> ozone;
  final Value<Map<String, dynamic>?> pollen;
  final Value<double?> uvMax;
  final Value<int?> daylightMinutes;
  final Value<DateTime?> sunrise;
  final Value<DateTime?> sunset;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const EnvironmentDaysCompanion({
    this.date = const Value.absent(),
    this.cell = const Value.absent(),
    this.aqiUs = const Value.absent(),
    this.aqiEu = const Value.absent(),
    this.pm25 = const Value.absent(),
    this.pm10 = const Value.absent(),
    this.ozone = const Value.absent(),
    this.pollen = const Value.absent(),
    this.uvMax = const Value.absent(),
    this.daylightMinutes = const Value.absent(),
    this.sunrise = const Value.absent(),
    this.sunset = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnvironmentDaysCompanion.insert({
    required String date,
    required String cell,
    this.aqiUs = const Value.absent(),
    this.aqiEu = const Value.absent(),
    this.pm25 = const Value.absent(),
    this.pm10 = const Value.absent(),
    this.ozone = const Value.absent(),
    this.pollen = const Value.absent(),
    this.uvMax = const Value.absent(),
    this.daylightMinutes = const Value.absent(),
    this.sunrise = const Value.absent(),
    this.sunset = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       cell = Value(cell),
       fetchedAt = Value(fetchedAt);
  static Insertable<EnvironmentDay> custom({
    Expression<String>? date,
    Expression<String>? cell,
    Expression<double>? aqiUs,
    Expression<double>? aqiEu,
    Expression<double>? pm25,
    Expression<double>? pm10,
    Expression<double>? ozone,
    Expression<String>? pollen,
    Expression<double>? uvMax,
    Expression<int>? daylightMinutes,
    Expression<DateTime>? sunrise,
    Expression<DateTime>? sunset,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (cell != null) 'cell': cell,
      if (aqiUs != null) 'aqi_us': aqiUs,
      if (aqiEu != null) 'aqi_eu': aqiEu,
      if (pm25 != null) 'pm25': pm25,
      if (pm10 != null) 'pm10': pm10,
      if (ozone != null) 'ozone': ozone,
      if (pollen != null) 'pollen': pollen,
      if (uvMax != null) 'uv_max': uvMax,
      if (daylightMinutes != null) 'daylight_minutes': daylightMinutes,
      if (sunrise != null) 'sunrise': sunrise,
      if (sunset != null) 'sunset': sunset,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnvironmentDaysCompanion copyWith({
    Value<String>? date,
    Value<String>? cell,
    Value<double?>? aqiUs,
    Value<double?>? aqiEu,
    Value<double?>? pm25,
    Value<double?>? pm10,
    Value<double?>? ozone,
    Value<Map<String, dynamic>?>? pollen,
    Value<double?>? uvMax,
    Value<int?>? daylightMinutes,
    Value<DateTime?>? sunrise,
    Value<DateTime?>? sunset,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return EnvironmentDaysCompanion(
      date: date ?? this.date,
      cell: cell ?? this.cell,
      aqiUs: aqiUs ?? this.aqiUs,
      aqiEu: aqiEu ?? this.aqiEu,
      pm25: pm25 ?? this.pm25,
      pm10: pm10 ?? this.pm10,
      ozone: ozone ?? this.ozone,
      pollen: pollen ?? this.pollen,
      uvMax: uvMax ?? this.uvMax,
      daylightMinutes: daylightMinutes ?? this.daylightMinutes,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (cell.present) {
      map['cell'] = Variable<String>(cell.value);
    }
    if (aqiUs.present) {
      map['aqi_us'] = Variable<double>(aqiUs.value);
    }
    if (aqiEu.present) {
      map['aqi_eu'] = Variable<double>(aqiEu.value);
    }
    if (pm25.present) {
      map['pm25'] = Variable<double>(pm25.value);
    }
    if (pm10.present) {
      map['pm10'] = Variable<double>(pm10.value);
    }
    if (ozone.present) {
      map['ozone'] = Variable<double>(ozone.value);
    }
    if (pollen.present) {
      map['pollen'] = Variable<String>(
        $EnvironmentDaysTable.$converterpollenn.toSql(pollen.value),
      );
    }
    if (uvMax.present) {
      map['uv_max'] = Variable<double>(uvMax.value);
    }
    if (daylightMinutes.present) {
      map['daylight_minutes'] = Variable<int>(daylightMinutes.value);
    }
    if (sunrise.present) {
      map['sunrise'] = Variable<DateTime>(sunrise.value);
    }
    if (sunset.present) {
      map['sunset'] = Variable<DateTime>(sunset.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvironmentDaysCompanion(')
          ..write('date: $date, ')
          ..write('cell: $cell, ')
          ..write('aqiUs: $aqiUs, ')
          ..write('aqiEu: $aqiEu, ')
          ..write('pm25: $pm25, ')
          ..write('pm10: $pm10, ')
          ..write('ozone: $ozone, ')
          ..write('pollen: $pollen, ')
          ..write('uvMax: $uvMax, ')
          ..write('daylightMinutes: $daylightMinutes, ')
          ..write('sunrise: $sunrise, ')
          ..write('sunset: $sunset, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthSamplesTable extends HealthSamples
    with TableInfo<$HealthSamplesTable, HealthSample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
    'start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
    'end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceStoreMeta = const VerificationMeta(
    'sourceStore',
  );
  @override
  late final GeneratedColumn<String> sourceStore = GeneratedColumn<String>(
    'source_store',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    start,
    end,
    value,
    unit,
    sourceStore,
    sourceName,
    importedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_samples';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthSample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('source_store')) {
      context.handle(
        _sourceStoreMeta,
        sourceStore.isAcceptableOrUnknown(
          data['source_store']!,
          _sourceStoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceStoreMeta);
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {type, start, end, sourceStore},
  ];
  @override
  HealthSample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthSample(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start'],
      )!,
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      sourceStore: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_store'],
      )!,
      sourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_name'],
      ),
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
    );
  }

  @override
  $HealthSamplesTable createAlias(String alias) {
    return $HealthSamplesTable(attachedDatabase, alias);
  }
}

class HealthSample extends DataClass implements Insertable<HealthSample> {
  final String id;

  /// `sleep`, `resting_hr`, `hrv`, `steps`, `menstrual_flow`.
  final String type;
  final DateTime start;
  final DateTime end;
  final double value;
  final String unit;

  /// `healthkit` or `health_connect`.
  final String sourceStore;

  /// Writing app or device, when the store reports it.
  final String? sourceName;
  final DateTime importedAt;
  const HealthSample({
    required this.id,
    required this.type,
    required this.start,
    required this.end,
    required this.value,
    required this.unit,
    required this.sourceStore,
    this.sourceName,
    required this.importedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['start'] = Variable<DateTime>(start);
    map['end'] = Variable<DateTime>(end);
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['source_store'] = Variable<String>(sourceStore);
    if (!nullToAbsent || sourceName != null) {
      map['source_name'] = Variable<String>(sourceName);
    }
    map['imported_at'] = Variable<DateTime>(importedAt);
    return map;
  }

  HealthSamplesCompanion toCompanion(bool nullToAbsent) {
    return HealthSamplesCompanion(
      id: Value(id),
      type: Value(type),
      start: Value(start),
      end: Value(end),
      value: Value(value),
      unit: Value(unit),
      sourceStore: Value(sourceStore),
      sourceName: sourceName == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceName),
      importedAt: Value(importedAt),
    );
  }

  factory HealthSample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthSample(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      start: serializer.fromJson<DateTime>(json['start']),
      end: serializer.fromJson<DateTime>(json['end']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      sourceStore: serializer.fromJson<String>(json['sourceStore']),
      sourceName: serializer.fromJson<String?>(json['sourceName']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'start': serializer.toJson<DateTime>(start),
      'end': serializer.toJson<DateTime>(end),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'sourceStore': serializer.toJson<String>(sourceStore),
      'sourceName': serializer.toJson<String?>(sourceName),
      'importedAt': serializer.toJson<DateTime>(importedAt),
    };
  }

  HealthSample copyWith({
    String? id,
    String? type,
    DateTime? start,
    DateTime? end,
    double? value,
    String? unit,
    String? sourceStore,
    Value<String?> sourceName = const Value.absent(),
    DateTime? importedAt,
  }) => HealthSample(
    id: id ?? this.id,
    type: type ?? this.type,
    start: start ?? this.start,
    end: end ?? this.end,
    value: value ?? this.value,
    unit: unit ?? this.unit,
    sourceStore: sourceStore ?? this.sourceStore,
    sourceName: sourceName.present ? sourceName.value : this.sourceName,
    importedAt: importedAt ?? this.importedAt,
  );
  HealthSample copyWithCompanion(HealthSamplesCompanion data) {
    return HealthSample(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      sourceStore: data.sourceStore.present
          ? data.sourceStore.value
          : this.sourceStore,
      sourceName: data.sourceName.present
          ? data.sourceName.value
          : this.sourceName,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthSample(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('sourceStore: $sourceStore, ')
          ..write('sourceName: $sourceName, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    start,
    end,
    value,
    unit,
    sourceStore,
    sourceName,
    importedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthSample &&
          other.id == this.id &&
          other.type == this.type &&
          other.start == this.start &&
          other.end == this.end &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.sourceStore == this.sourceStore &&
          other.sourceName == this.sourceName &&
          other.importedAt == this.importedAt);
}

class HealthSamplesCompanion extends UpdateCompanion<HealthSample> {
  final Value<String> id;
  final Value<String> type;
  final Value<DateTime> start;
  final Value<DateTime> end;
  final Value<double> value;
  final Value<String> unit;
  final Value<String> sourceStore;
  final Value<String?> sourceName;
  final Value<DateTime> importedAt;
  final Value<int> rowid;
  const HealthSamplesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.sourceStore = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthSamplesCompanion.insert({
    required String id,
    required String type,
    required DateTime start,
    required DateTime end,
    required double value,
    required String unit,
    required String sourceStore,
    this.sourceName = const Value.absent(),
    required DateTime importedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       start = Value(start),
       end = Value(end),
       value = Value(value),
       unit = Value(unit),
       sourceStore = Value(sourceStore),
       importedAt = Value(importedAt);
  static Insertable<HealthSample> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<DateTime>? start,
    Expression<DateTime>? end,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<String>? sourceStore,
    Expression<String>? sourceName,
    Expression<DateTime>? importedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (sourceStore != null) 'source_store': sourceStore,
      if (sourceName != null) 'source_name': sourceName,
      if (importedAt != null) 'imported_at': importedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthSamplesCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<DateTime>? start,
    Value<DateTime>? end,
    Value<double>? value,
    Value<String>? unit,
    Value<String>? sourceStore,
    Value<String?>? sourceName,
    Value<DateTime>? importedAt,
    Value<int>? rowid,
  }) {
    return HealthSamplesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      start: start ?? this.start,
      end: end ?? this.end,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      sourceStore: sourceStore ?? this.sourceStore,
      sourceName: sourceName ?? this.sourceName,
      importedAt: importedAt ?? this.importedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (sourceStore.present) {
      map['source_store'] = Variable<String>(sourceStore.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthSamplesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('sourceStore: $sourceStore, ')
          ..write('sourceName: $sourceName, ')
          ..write('importedAt: $importedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FactorWeightsTable extends FactorWeights
    with TableInfo<$FactorWeightsTable, FactorWeight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FactorWeightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _factorMeta = const VerificationMeta('factor');
  @override
  late final GeneratedColumn<String> factor = GeneratedColumn<String>(
    'factor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _populationWeightMeta = const VerificationMeta(
    'populationWeight',
  );
  @override
  late final GeneratedColumn<double> populationWeight = GeneratedColumn<double>(
    'population_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personalWeightMeta = const VerificationMeta(
    'personalWeight',
  );
  @override
  late final GeneratedColumn<double> personalWeight = GeneratedColumn<double>(
    'personal_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nExposuresMeta = const VerificationMeta(
    'nExposures',
  );
  @override
  late final GeneratedColumn<int> nExposures = GeneratedColumn<int>(
    'n_exposures',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nAttacksAfterMeta = const VerificationMeta(
    'nAttacksAfter',
  );
  @override
  late final GeneratedColumn<int> nAttacksAfter = GeneratedColumn<int>(
    'n_attacks_after',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    factor,
    populationWeight,
    personalWeight,
    confidence,
    nExposures,
    nAttacksAfter,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'factor_weights';
  @override
  VerificationContext validateIntegrity(
    Insertable<FactorWeight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('factor')) {
      context.handle(
        _factorMeta,
        factor.isAcceptableOrUnknown(data['factor']!, _factorMeta),
      );
    } else if (isInserting) {
      context.missing(_factorMeta);
    }
    if (data.containsKey('population_weight')) {
      context.handle(
        _populationWeightMeta,
        populationWeight.isAcceptableOrUnknown(
          data['population_weight']!,
          _populationWeightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_populationWeightMeta);
    }
    if (data.containsKey('personal_weight')) {
      context.handle(
        _personalWeightMeta,
        personalWeight.isAcceptableOrUnknown(
          data['personal_weight']!,
          _personalWeightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personalWeightMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('n_exposures')) {
      context.handle(
        _nExposuresMeta,
        nExposures.isAcceptableOrUnknown(data['n_exposures']!, _nExposuresMeta),
      );
    }
    if (data.containsKey('n_attacks_after')) {
      context.handle(
        _nAttacksAfterMeta,
        nAttacksAfter.isAcceptableOrUnknown(
          data['n_attacks_after']!,
          _nAttacksAfterMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {factor};
  @override
  FactorWeight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FactorWeight(
      factor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}factor'],
      )!,
      populationWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}population_weight'],
      )!,
      personalWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}personal_weight'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      nExposures: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}n_exposures'],
      )!,
      nAttacksAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}n_attacks_after'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FactorWeightsTable createAlias(String alias) {
    return $FactorWeightsTable(attachedDatabase, alias);
  }
}

class FactorWeight extends DataClass implements Insertable<FactorWeight> {
  final String factor;
  final double populationWeight;
  final double personalWeight;
  final double confidence;
  final int nExposures;
  final int nAttacksAfter;
  final DateTime updatedAt;
  const FactorWeight({
    required this.factor,
    required this.populationWeight,
    required this.personalWeight,
    required this.confidence,
    required this.nExposures,
    required this.nAttacksAfter,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['factor'] = Variable<String>(factor);
    map['population_weight'] = Variable<double>(populationWeight);
    map['personal_weight'] = Variable<double>(personalWeight);
    map['confidence'] = Variable<double>(confidence);
    map['n_exposures'] = Variable<int>(nExposures);
    map['n_attacks_after'] = Variable<int>(nAttacksAfter);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FactorWeightsCompanion toCompanion(bool nullToAbsent) {
    return FactorWeightsCompanion(
      factor: Value(factor),
      populationWeight: Value(populationWeight),
      personalWeight: Value(personalWeight),
      confidence: Value(confidence),
      nExposures: Value(nExposures),
      nAttacksAfter: Value(nAttacksAfter),
      updatedAt: Value(updatedAt),
    );
  }

  factory FactorWeight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FactorWeight(
      factor: serializer.fromJson<String>(json['factor']),
      populationWeight: serializer.fromJson<double>(json['populationWeight']),
      personalWeight: serializer.fromJson<double>(json['personalWeight']),
      confidence: serializer.fromJson<double>(json['confidence']),
      nExposures: serializer.fromJson<int>(json['nExposures']),
      nAttacksAfter: serializer.fromJson<int>(json['nAttacksAfter']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'factor': serializer.toJson<String>(factor),
      'populationWeight': serializer.toJson<double>(populationWeight),
      'personalWeight': serializer.toJson<double>(personalWeight),
      'confidence': serializer.toJson<double>(confidence),
      'nExposures': serializer.toJson<int>(nExposures),
      'nAttacksAfter': serializer.toJson<int>(nAttacksAfter),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FactorWeight copyWith({
    String? factor,
    double? populationWeight,
    double? personalWeight,
    double? confidence,
    int? nExposures,
    int? nAttacksAfter,
    DateTime? updatedAt,
  }) => FactorWeight(
    factor: factor ?? this.factor,
    populationWeight: populationWeight ?? this.populationWeight,
    personalWeight: personalWeight ?? this.personalWeight,
    confidence: confidence ?? this.confidence,
    nExposures: nExposures ?? this.nExposures,
    nAttacksAfter: nAttacksAfter ?? this.nAttacksAfter,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FactorWeight copyWithCompanion(FactorWeightsCompanion data) {
    return FactorWeight(
      factor: data.factor.present ? data.factor.value : this.factor,
      populationWeight: data.populationWeight.present
          ? data.populationWeight.value
          : this.populationWeight,
      personalWeight: data.personalWeight.present
          ? data.personalWeight.value
          : this.personalWeight,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      nExposures: data.nExposures.present
          ? data.nExposures.value
          : this.nExposures,
      nAttacksAfter: data.nAttacksAfter.present
          ? data.nAttacksAfter.value
          : this.nAttacksAfter,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FactorWeight(')
          ..write('factor: $factor, ')
          ..write('populationWeight: $populationWeight, ')
          ..write('personalWeight: $personalWeight, ')
          ..write('confidence: $confidence, ')
          ..write('nExposures: $nExposures, ')
          ..write('nAttacksAfter: $nAttacksAfter, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    factor,
    populationWeight,
    personalWeight,
    confidence,
    nExposures,
    nAttacksAfter,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FactorWeight &&
          other.factor == this.factor &&
          other.populationWeight == this.populationWeight &&
          other.personalWeight == this.personalWeight &&
          other.confidence == this.confidence &&
          other.nExposures == this.nExposures &&
          other.nAttacksAfter == this.nAttacksAfter &&
          other.updatedAt == this.updatedAt);
}

class FactorWeightsCompanion extends UpdateCompanion<FactorWeight> {
  final Value<String> factor;
  final Value<double> populationWeight;
  final Value<double> personalWeight;
  final Value<double> confidence;
  final Value<int> nExposures;
  final Value<int> nAttacksAfter;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FactorWeightsCompanion({
    this.factor = const Value.absent(),
    this.populationWeight = const Value.absent(),
    this.personalWeight = const Value.absent(),
    this.confidence = const Value.absent(),
    this.nExposures = const Value.absent(),
    this.nAttacksAfter = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FactorWeightsCompanion.insert({
    required String factor,
    required double populationWeight,
    required double personalWeight,
    required double confidence,
    this.nExposures = const Value.absent(),
    this.nAttacksAfter = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : factor = Value(factor),
       populationWeight = Value(populationWeight),
       personalWeight = Value(personalWeight),
       confidence = Value(confidence),
       updatedAt = Value(updatedAt);
  static Insertable<FactorWeight> custom({
    Expression<String>? factor,
    Expression<double>? populationWeight,
    Expression<double>? personalWeight,
    Expression<double>? confidence,
    Expression<int>? nExposures,
    Expression<int>? nAttacksAfter,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (factor != null) 'factor': factor,
      if (populationWeight != null) 'population_weight': populationWeight,
      if (personalWeight != null) 'personal_weight': personalWeight,
      if (confidence != null) 'confidence': confidence,
      if (nExposures != null) 'n_exposures': nExposures,
      if (nAttacksAfter != null) 'n_attacks_after': nAttacksAfter,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FactorWeightsCompanion copyWith({
    Value<String>? factor,
    Value<double>? populationWeight,
    Value<double>? personalWeight,
    Value<double>? confidence,
    Value<int>? nExposures,
    Value<int>? nAttacksAfter,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FactorWeightsCompanion(
      factor: factor ?? this.factor,
      populationWeight: populationWeight ?? this.populationWeight,
      personalWeight: personalWeight ?? this.personalWeight,
      confidence: confidence ?? this.confidence,
      nExposures: nExposures ?? this.nExposures,
      nAttacksAfter: nAttacksAfter ?? this.nAttacksAfter,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (factor.present) {
      map['factor'] = Variable<String>(factor.value);
    }
    if (populationWeight.present) {
      map['population_weight'] = Variable<double>(populationWeight.value);
    }
    if (personalWeight.present) {
      map['personal_weight'] = Variable<double>(personalWeight.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (nExposures.present) {
      map['n_exposures'] = Variable<int>(nExposures.value);
    }
    if (nAttacksAfter.present) {
      map['n_attacks_after'] = Variable<int>(nAttacksAfter.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FactorWeightsCompanion(')
          ..write('factor: $factor, ')
          ..write('populationWeight: $populationWeight, ')
          ..write('personalWeight: $personalWeight, ')
          ..write('confidence: $confidence, ')
          ..write('nExposures: $nExposures, ')
          ..write('nAttacksAfter: $nAttacksAfter, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RiskDaysTable extends RiskDays with TableInfo<$RiskDaysTable, RiskDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RiskDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 10,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<
    List<Map<String, dynamic>>,
    String
  >
  drivers = GeneratedColumn<String>(
    'drivers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<Map<String, dynamic>>>($RiskDaysTable.$converterdrivers);
  static const VerificationMeta _modelVersionMeta = const VerificationMeta(
    'modelVersion',
  );
  @override
  late final GeneratedColumn<String> modelVersion = GeneratedColumn<String>(
    'model_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _computedAtMeta = const VerificationMeta(
    'computedAt',
  );
  @override
  late final GeneratedColumn<DateTime> computedAt = GeneratedColumn<DateTime>(
    'computed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    level,
    score,
    drivers,
    modelVersion,
    computedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'risk_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<RiskDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('model_version')) {
      context.handle(
        _modelVersionMeta,
        modelVersion.isAcceptableOrUnknown(
          data['model_version']!,
          _modelVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modelVersionMeta);
    }
    if (data.containsKey('computed_at')) {
      context.handle(
        _computedAtMeta,
        computedAt.isAcceptableOrUnknown(data['computed_at']!, _computedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_computedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  RiskDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RiskDay(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      drivers: $RiskDaysTable.$converterdrivers.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}drivers'],
        )!,
      ),
      modelVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_version'],
      )!,
      computedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}computed_at'],
      )!,
    );
  }

  @override
  $RiskDaysTable createAlias(String alias) {
    return $RiskDaysTable(attachedDatabase, alias);
  }

  static TypeConverter<List<Map<String, dynamic>>, String> $converterdrivers =
      const JsonListConverter();
}

class RiskDay extends DataClass implements Insertable<RiskDay> {
  /// Local calendar date as `yyyy-MM-dd`.
  final String date;

  /// `low`, `moderate` or `high`.
  final String level;
  final double score;

  /// Top drivers: `[{"factor": "pressure_drop", "contribution": 62}]`.
  final List<Map<String, dynamic>> drivers;
  final String modelVersion;
  final DateTime computedAt;
  const RiskDay({
    required this.date,
    required this.level,
    required this.score,
    required this.drivers,
    required this.modelVersion,
    required this.computedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['level'] = Variable<String>(level);
    map['score'] = Variable<double>(score);
    {
      map['drivers'] = Variable<String>(
        $RiskDaysTable.$converterdrivers.toSql(drivers),
      );
    }
    map['model_version'] = Variable<String>(modelVersion);
    map['computed_at'] = Variable<DateTime>(computedAt);
    return map;
  }

  RiskDaysCompanion toCompanion(bool nullToAbsent) {
    return RiskDaysCompanion(
      date: Value(date),
      level: Value(level),
      score: Value(score),
      drivers: Value(drivers),
      modelVersion: Value(modelVersion),
      computedAt: Value(computedAt),
    );
  }

  factory RiskDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RiskDay(
      date: serializer.fromJson<String>(json['date']),
      level: serializer.fromJson<String>(json['level']),
      score: serializer.fromJson<double>(json['score']),
      drivers: serializer.fromJson<List<Map<String, dynamic>>>(json['drivers']),
      modelVersion: serializer.fromJson<String>(json['modelVersion']),
      computedAt: serializer.fromJson<DateTime>(json['computedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'level': serializer.toJson<String>(level),
      'score': serializer.toJson<double>(score),
      'drivers': serializer.toJson<List<Map<String, dynamic>>>(drivers),
      'modelVersion': serializer.toJson<String>(modelVersion),
      'computedAt': serializer.toJson<DateTime>(computedAt),
    };
  }

  RiskDay copyWith({
    String? date,
    String? level,
    double? score,
    List<Map<String, dynamic>>? drivers,
    String? modelVersion,
    DateTime? computedAt,
  }) => RiskDay(
    date: date ?? this.date,
    level: level ?? this.level,
    score: score ?? this.score,
    drivers: drivers ?? this.drivers,
    modelVersion: modelVersion ?? this.modelVersion,
    computedAt: computedAt ?? this.computedAt,
  );
  RiskDay copyWithCompanion(RiskDaysCompanion data) {
    return RiskDay(
      date: data.date.present ? data.date.value : this.date,
      level: data.level.present ? data.level.value : this.level,
      score: data.score.present ? data.score.value : this.score,
      drivers: data.drivers.present ? data.drivers.value : this.drivers,
      modelVersion: data.modelVersion.present
          ? data.modelVersion.value
          : this.modelVersion,
      computedAt: data.computedAt.present
          ? data.computedAt.value
          : this.computedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RiskDay(')
          ..write('date: $date, ')
          ..write('level: $level, ')
          ..write('score: $score, ')
          ..write('drivers: $drivers, ')
          ..write('modelVersion: $modelVersion, ')
          ..write('computedAt: $computedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, level, score, drivers, modelVersion, computedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RiskDay &&
          other.date == this.date &&
          other.level == this.level &&
          other.score == this.score &&
          other.drivers == this.drivers &&
          other.modelVersion == this.modelVersion &&
          other.computedAt == this.computedAt);
}

class RiskDaysCompanion extends UpdateCompanion<RiskDay> {
  final Value<String> date;
  final Value<String> level;
  final Value<double> score;
  final Value<List<Map<String, dynamic>>> drivers;
  final Value<String> modelVersion;
  final Value<DateTime> computedAt;
  final Value<int> rowid;
  const RiskDaysCompanion({
    this.date = const Value.absent(),
    this.level = const Value.absent(),
    this.score = const Value.absent(),
    this.drivers = const Value.absent(),
    this.modelVersion = const Value.absent(),
    this.computedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RiskDaysCompanion.insert({
    required String date,
    required String level,
    required double score,
    this.drivers = const Value.absent(),
    required String modelVersion,
    required DateTime computedAt,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       level = Value(level),
       score = Value(score),
       modelVersion = Value(modelVersion),
       computedAt = Value(computedAt);
  static Insertable<RiskDay> custom({
    Expression<String>? date,
    Expression<String>? level,
    Expression<double>? score,
    Expression<String>? drivers,
    Expression<String>? modelVersion,
    Expression<DateTime>? computedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (level != null) 'level': level,
      if (score != null) 'score': score,
      if (drivers != null) 'drivers': drivers,
      if (modelVersion != null) 'model_version': modelVersion,
      if (computedAt != null) 'computed_at': computedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RiskDaysCompanion copyWith({
    Value<String>? date,
    Value<String>? level,
    Value<double>? score,
    Value<List<Map<String, dynamic>>>? drivers,
    Value<String>? modelVersion,
    Value<DateTime>? computedAt,
    Value<int>? rowid,
  }) {
    return RiskDaysCompanion(
      date: date ?? this.date,
      level: level ?? this.level,
      score: score ?? this.score,
      drivers: drivers ?? this.drivers,
      modelVersion: modelVersion ?? this.modelVersion,
      computedAt: computedAt ?? this.computedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (drivers.present) {
      map['drivers'] = Variable<String>(
        $RiskDaysTable.$converterdrivers.toSql(drivers.value),
      );
    }
    if (modelVersion.present) {
      map['model_version'] = Variable<String>(modelVersion.value);
    }
    if (computedAt.present) {
      map['computed_at'] = Variable<DateTime>(computedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RiskDaysCompanion(')
          ..write('date: $date, ')
          ..write('level: $level, ')
          ..write('score: $score, ')
          ..write('drivers: $drivers, ')
          ..write('modelVersion: $modelVersion, ')
          ..write('computedAt: $computedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExperimentsTable extends Experiments
    with TableInfo<$ExperimentsTable, Experiment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExperimentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changeMeta = const VerificationMeta('change');
  @override
  late final GeneratedColumn<String> change = GeneratedColumn<String>(
    'change',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
    'start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
    'end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  adherence = GeneratedColumn<String>(
    'adherence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, dynamic>>($ExperimentsTable.$converteradherence);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  result = GeneratedColumn<String>(
    'result',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($ExperimentsTable.$converterresultn);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    change,
    start,
    end,
    adherence,
    result,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'experiments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Experiment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('change')) {
      context.handle(
        _changeMeta,
        change.isAcceptableOrUnknown(data['change']!, _changeMeta),
      );
    } else if (isInserting) {
      context.missing(_changeMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Experiment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Experiment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      change: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change'],
      )!,
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start'],
      )!,
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end'],
      ),
      adherence: $ExperimentsTable.$converteradherence.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}adherence'],
        )!,
      ),
      result: $ExperimentsTable.$converterresultn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}result'],
        ),
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $ExperimentsTable createAlias(String alias) {
    return $ExperimentsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converteradherence =
      const JsonMapConverter();
  static TypeConverter<Map<String, dynamic>, String> $converterresult =
      const JsonMapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterresultn =
      NullAwareTypeConverter.wrap($converterresult);
}

class Experiment extends DataClass implements Insertable<Experiment> {
  final String id;

  /// The single change under test, for example `cut_caffeine`.
  final String change;
  final DateTime start;
  final DateTime? end;

  /// Date to adherence (`true`/`false`).
  final Map<String, dynamic> adherence;
  final Map<String, dynamic>? result;

  /// `active`, `completed` or `abandoned`.
  final String status;
  const Experiment({
    required this.id,
    required this.change,
    required this.start,
    this.end,
    required this.adherence,
    this.result,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['change'] = Variable<String>(change);
    map['start'] = Variable<DateTime>(start);
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<DateTime>(end);
    }
    {
      map['adherence'] = Variable<String>(
        $ExperimentsTable.$converteradherence.toSql(adherence),
      );
    }
    if (!nullToAbsent || result != null) {
      map['result'] = Variable<String>(
        $ExperimentsTable.$converterresultn.toSql(result),
      );
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  ExperimentsCompanion toCompanion(bool nullToAbsent) {
    return ExperimentsCompanion(
      id: Value(id),
      change: Value(change),
      start: Value(start),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      adherence: Value(adherence),
      result: result == null && nullToAbsent
          ? const Value.absent()
          : Value(result),
      status: Value(status),
    );
  }

  factory Experiment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Experiment(
      id: serializer.fromJson<String>(json['id']),
      change: serializer.fromJson<String>(json['change']),
      start: serializer.fromJson<DateTime>(json['start']),
      end: serializer.fromJson<DateTime?>(json['end']),
      adherence: serializer.fromJson<Map<String, dynamic>>(json['adherence']),
      result: serializer.fromJson<Map<String, dynamic>?>(json['result']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'change': serializer.toJson<String>(change),
      'start': serializer.toJson<DateTime>(start),
      'end': serializer.toJson<DateTime?>(end),
      'adherence': serializer.toJson<Map<String, dynamic>>(adherence),
      'result': serializer.toJson<Map<String, dynamic>?>(result),
      'status': serializer.toJson<String>(status),
    };
  }

  Experiment copyWith({
    String? id,
    String? change,
    DateTime? start,
    Value<DateTime?> end = const Value.absent(),
    Map<String, dynamic>? adherence,
    Value<Map<String, dynamic>?> result = const Value.absent(),
    String? status,
  }) => Experiment(
    id: id ?? this.id,
    change: change ?? this.change,
    start: start ?? this.start,
    end: end.present ? end.value : this.end,
    adherence: adherence ?? this.adherence,
    result: result.present ? result.value : this.result,
    status: status ?? this.status,
  );
  Experiment copyWithCompanion(ExperimentsCompanion data) {
    return Experiment(
      id: data.id.present ? data.id.value : this.id,
      change: data.change.present ? data.change.value : this.change,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      adherence: data.adherence.present ? data.adherence.value : this.adherence,
      result: data.result.present ? data.result.value : this.result,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Experiment(')
          ..write('id: $id, ')
          ..write('change: $change, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('adherence: $adherence, ')
          ..write('result: $result, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, change, start, end, adherence, result, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Experiment &&
          other.id == this.id &&
          other.change == this.change &&
          other.start == this.start &&
          other.end == this.end &&
          other.adherence == this.adherence &&
          other.result == this.result &&
          other.status == this.status);
}

class ExperimentsCompanion extends UpdateCompanion<Experiment> {
  final Value<String> id;
  final Value<String> change;
  final Value<DateTime> start;
  final Value<DateTime?> end;
  final Value<Map<String, dynamic>> adherence;
  final Value<Map<String, dynamic>?> result;
  final Value<String> status;
  final Value<int> rowid;
  const ExperimentsCompanion({
    this.id = const Value.absent(),
    this.change = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.adherence = const Value.absent(),
    this.result = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExperimentsCompanion.insert({
    required String id,
    required String change,
    required DateTime start,
    this.end = const Value.absent(),
    this.adherence = const Value.absent(),
    this.result = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       change = Value(change),
       start = Value(start);
  static Insertable<Experiment> custom({
    Expression<String>? id,
    Expression<String>? change,
    Expression<DateTime>? start,
    Expression<DateTime>? end,
    Expression<String>? adherence,
    Expression<String>? result,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (change != null) 'change': change,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (adherence != null) 'adherence': adherence,
      if (result != null) 'result': result,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExperimentsCompanion copyWith({
    Value<String>? id,
    Value<String>? change,
    Value<DateTime>? start,
    Value<DateTime?>? end,
    Value<Map<String, dynamic>>? adherence,
    Value<Map<String, dynamic>?>? result,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return ExperimentsCompanion(
      id: id ?? this.id,
      change: change ?? this.change,
      start: start ?? this.start,
      end: end ?? this.end,
      adherence: adherence ?? this.adherence,
      result: result ?? this.result,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (change.present) {
      map['change'] = Variable<String>(change.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (adherence.present) {
      map['adherence'] = Variable<String>(
        $ExperimentsTable.$converteradherence.toSql(adherence.value),
      );
    }
    if (result.present) {
      map['result'] = Variable<String>(
        $ExperimentsTable.$converterresultn.toSql(result.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExperimentsCompanion(')
          ..write('id: $id, ')
          ..write('change: $change, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('adherence: $adherence, ')
          ..write('result: $result, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionnairesTable extends Questionnaires
    with TableInfo<$QuestionnairesTable, Questionnaire> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionnairesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  answers = GeneratedColumn<String>(
    'answers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, dynamic>>($QuestionnairesTable.$converteranswers);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, type, date, answers, score];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questionnaires';
  @override
  VerificationContext validateIntegrity(
    Insertable<Questionnaire> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Questionnaire map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Questionnaire(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      answers: $QuestionnairesTable.$converteranswers.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}answers'],
        )!,
      ),
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
    );
  }

  @override
  $QuestionnairesTable createAlias(String alias) {
    return $QuestionnairesTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converteranswers =
      const JsonMapConverter();
}

class Questionnaire extends DataClass implements Insertable<Questionnaire> {
  final String id;

  /// `midas` or `hit6`.
  final String type;
  final DateTime date;
  final Map<String, dynamic> answers;
  final int score;
  const Questionnaire({
    required this.id,
    required this.type,
    required this.date,
    required this.answers,
    required this.score,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['date'] = Variable<DateTime>(date);
    {
      map['answers'] = Variable<String>(
        $QuestionnairesTable.$converteranswers.toSql(answers),
      );
    }
    map['score'] = Variable<int>(score);
    return map;
  }

  QuestionnairesCompanion toCompanion(bool nullToAbsent) {
    return QuestionnairesCompanion(
      id: Value(id),
      type: Value(type),
      date: Value(date),
      answers: Value(answers),
      score: Value(score),
    );
  }

  factory Questionnaire.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Questionnaire(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      date: serializer.fromJson<DateTime>(json['date']),
      answers: serializer.fromJson<Map<String, dynamic>>(json['answers']),
      score: serializer.fromJson<int>(json['score']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'date': serializer.toJson<DateTime>(date),
      'answers': serializer.toJson<Map<String, dynamic>>(answers),
      'score': serializer.toJson<int>(score),
    };
  }

  Questionnaire copyWith({
    String? id,
    String? type,
    DateTime? date,
    Map<String, dynamic>? answers,
    int? score,
  }) => Questionnaire(
    id: id ?? this.id,
    type: type ?? this.type,
    date: date ?? this.date,
    answers: answers ?? this.answers,
    score: score ?? this.score,
  );
  Questionnaire copyWithCompanion(QuestionnairesCompanion data) {
    return Questionnaire(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      answers: data.answers.present ? data.answers.value : this.answers,
      score: data.score.present ? data.score.value : this.score,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Questionnaire(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('answers: $answers, ')
          ..write('score: $score')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, date, answers, score);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Questionnaire &&
          other.id == this.id &&
          other.type == this.type &&
          other.date == this.date &&
          other.answers == this.answers &&
          other.score == this.score);
}

class QuestionnairesCompanion extends UpdateCompanion<Questionnaire> {
  final Value<String> id;
  final Value<String> type;
  final Value<DateTime> date;
  final Value<Map<String, dynamic>> answers;
  final Value<int> score;
  final Value<int> rowid;
  const QuestionnairesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.answers = const Value.absent(),
    this.score = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionnairesCompanion.insert({
    required String id,
    required String type,
    required DateTime date,
    required Map<String, dynamic> answers,
    required int score,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       date = Value(date),
       answers = Value(answers),
       score = Value(score);
  static Insertable<Questionnaire> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<DateTime>? date,
    Expression<String>? answers,
    Expression<int>? score,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (answers != null) 'answers': answers,
      if (score != null) 'score': score,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionnairesCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<DateTime>? date,
    Value<Map<String, dynamic>>? answers,
    Value<int>? score,
    Value<int>? rowid,
  }) {
    return QuestionnairesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (answers.present) {
      map['answers'] = Variable<String>(
        $QuestionnairesTable.$converteranswers.toSql(answers.value),
      );
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionnairesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('answers: $answers, ')
          ..write('score: $score, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShareLinksTable extends ShareLinks
    with TableInfo<$ShareLinksTable, ShareLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShareLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revokedMeta = const VerificationMeta(
    'revoked',
  );
  @override
  late final GeneratedColumn<bool> revoked = GeneratedColumn<bool>(
    'revoked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("revoked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [token, createdAt, expiresAt, revoked];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'share_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShareLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('revoked')) {
      context.handle(
        _revokedMeta,
        revoked.isAcceptableOrUnknown(data['revoked']!, _revokedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {token};
  @override
  ShareLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShareLink(
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      revoked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}revoked'],
      )!,
    );
  }

  @override
  $ShareLinksTable createAlias(String alias) {
    return $ShareLinksTable(attachedDatabase, alias);
  }
}

class ShareLink extends DataClass implements Insertable<ShareLink> {
  final String token;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool revoked;
  const ShareLink({
    required this.token,
    required this.createdAt,
    required this.expiresAt,
    required this.revoked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['token'] = Variable<String>(token);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    map['revoked'] = Variable<bool>(revoked);
    return map;
  }

  ShareLinksCompanion toCompanion(bool nullToAbsent) {
    return ShareLinksCompanion(
      token: Value(token),
      createdAt: Value(createdAt),
      expiresAt: Value(expiresAt),
      revoked: Value(revoked),
    );
  }

  factory ShareLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShareLink(
      token: serializer.fromJson<String>(json['token']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      revoked: serializer.fromJson<bool>(json['revoked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'token': serializer.toJson<String>(token),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'revoked': serializer.toJson<bool>(revoked),
    };
  }

  ShareLink copyWith({
    String? token,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? revoked,
  }) => ShareLink(
    token: token ?? this.token,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt ?? this.expiresAt,
    revoked: revoked ?? this.revoked,
  );
  ShareLink copyWithCompanion(ShareLinksCompanion data) {
    return ShareLink(
      token: data.token.present ? data.token.value : this.token,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      revoked: data.revoked.present ? data.revoked.value : this.revoked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShareLink(')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('revoked: $revoked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(token, createdAt, expiresAt, revoked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShareLink &&
          other.token == this.token &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt &&
          other.revoked == this.revoked);
}

class ShareLinksCompanion extends UpdateCompanion<ShareLink> {
  final Value<String> token;
  final Value<DateTime> createdAt;
  final Value<DateTime> expiresAt;
  final Value<bool> revoked;
  final Value<int> rowid;
  const ShareLinksCompanion({
    this.token = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.revoked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShareLinksCompanion.insert({
    required String token,
    required DateTime createdAt,
    required DateTime expiresAt,
    this.revoked = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : token = Value(token),
       createdAt = Value(createdAt),
       expiresAt = Value(expiresAt);
  static Insertable<ShareLink> custom({
    Expression<String>? token,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
    Expression<bool>? revoked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (token != null) 'token': token,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (revoked != null) 'revoked': revoked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShareLinksCompanion copyWith({
    Value<String>? token,
    Value<DateTime>? createdAt,
    Value<DateTime>? expiresAt,
    Value<bool>? revoked,
    Value<int>? rowid,
  }) {
    return ShareLinksCompanion(
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      revoked: revoked ?? this.revoked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (revoked.present) {
      map['revoked'] = Variable<bool>(revoked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShareLinksCompanion(')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('revoked: $revoked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const Setting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Setting copyWith({String? key, String? value, DateTime? updatedAt}) =>
      Setting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BarometerReadingsTable extends BarometerReadings
    with TableInfo<$BarometerReadingsTable, BarometerReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BarometerReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hpaMeta = const VerificationMeta('hpa');
  @override
  late final GeneratedColumn<double> hpa = GeneratedColumn<double>(
    'hpa',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [at, hpa];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'barometer_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<BarometerReading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('hpa')) {
      context.handle(
        _hpaMeta,
        hpa.isAcceptableOrUnknown(data['hpa']!, _hpaMeta),
      );
    } else if (isInserting) {
      context.missing(_hpaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {at};
  @override
  BarometerReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BarometerReading(
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      hpa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hpa'],
      )!,
    );
  }

  @override
  $BarometerReadingsTable createAlias(String alias) {
    return $BarometerReadingsTable(attachedDatabase, alias);
  }
}

class BarometerReading extends DataClass
    implements Insertable<BarometerReading> {
  final DateTime at;

  /// Raw sensor value in hPa, before calibration.
  final double hpa;
  const BarometerReading({required this.at, required this.hpa});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['at'] = Variable<DateTime>(at);
    map['hpa'] = Variable<double>(hpa);
    return map;
  }

  BarometerReadingsCompanion toCompanion(bool nullToAbsent) {
    return BarometerReadingsCompanion(at: Value(at), hpa: Value(hpa));
  }

  factory BarometerReading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BarometerReading(
      at: serializer.fromJson<DateTime>(json['at']),
      hpa: serializer.fromJson<double>(json['hpa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'at': serializer.toJson<DateTime>(at),
      'hpa': serializer.toJson<double>(hpa),
    };
  }

  BarometerReading copyWith({DateTime? at, double? hpa}) =>
      BarometerReading(at: at ?? this.at, hpa: hpa ?? this.hpa);
  BarometerReading copyWithCompanion(BarometerReadingsCompanion data) {
    return BarometerReading(
      at: data.at.present ? data.at.value : this.at,
      hpa: data.hpa.present ? data.hpa.value : this.hpa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BarometerReading(')
          ..write('at: $at, ')
          ..write('hpa: $hpa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(at, hpa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BarometerReading &&
          other.at == this.at &&
          other.hpa == this.hpa);
}

class BarometerReadingsCompanion extends UpdateCompanion<BarometerReading> {
  final Value<DateTime> at;
  final Value<double> hpa;
  final Value<int> rowid;
  const BarometerReadingsCompanion({
    this.at = const Value.absent(),
    this.hpa = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BarometerReadingsCompanion.insert({
    required DateTime at,
    required double hpa,
    this.rowid = const Value.absent(),
  }) : at = Value(at),
       hpa = Value(hpa);
  static Insertable<BarometerReading> custom({
    Expression<DateTime>? at,
    Expression<double>? hpa,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (at != null) 'at': at,
      if (hpa != null) 'hpa': hpa,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BarometerReadingsCompanion copyWith({
    Value<DateTime>? at,
    Value<double>? hpa,
    Value<int>? rowid,
  }) {
    return BarometerReadingsCompanion(
      at: at ?? this.at,
      hpa: hpa ?? this.hpa,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (hpa.present) {
      map['hpa'] = Variable<double>(hpa.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BarometerReadingsCompanion(')
          ..write('at: $at, ')
          ..write('hpa: $hpa, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AttacksTable attacks = $AttacksTable(this);
  late final $CheckinsTable checkins = $CheckinsTable(this);
  late final $MedicationEventsTable medicationEvents = $MedicationEventsTable(
    this,
  );
  late final $WeatherHoursTable weatherHours = $WeatherHoursTable(this);
  late final $EnvironmentDaysTable environmentDays = $EnvironmentDaysTable(
    this,
  );
  late final $HealthSamplesTable healthSamples = $HealthSamplesTable(this);
  late final $FactorWeightsTable factorWeights = $FactorWeightsTable(this);
  late final $RiskDaysTable riskDays = $RiskDaysTable(this);
  late final $ExperimentsTable experiments = $ExperimentsTable(this);
  late final $QuestionnairesTable questionnaires = $QuestionnairesTable(this);
  late final $ShareLinksTable shareLinks = $ShareLinksTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $BarometerReadingsTable barometerReadings =
      $BarometerReadingsTable(this);
  late final AttackDao attackDao = AttackDao(this as AppDatabase);
  late final CheckinDao checkinDao = CheckinDao(this as AppDatabase);
  late final MedicationDao medicationDao = MedicationDao(this as AppDatabase);
  late final WeatherDao weatherDao = WeatherDao(this as AppDatabase);
  late final EnvironmentDao environmentDao = EnvironmentDao(
    this as AppDatabase,
  );
  late final HealthDao healthDao = HealthDao(this as AppDatabase);
  late final RiskDao riskDao = RiskDao(this as AppDatabase);
  late final ExperimentDao experimentDao = ExperimentDao(this as AppDatabase);
  late final QuestionnaireDao questionnaireDao = QuestionnaireDao(
    this as AppDatabase,
  );
  late final ShareLinkDao shareLinkDao = ShareLinkDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final BarometerDao barometerDao = BarometerDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    attacks,
    checkins,
    medicationEvents,
    weatherHours,
    environmentDays,
    healthSamples,
    factorWeights,
    riskDays,
    experiments,
    questionnaires,
    shareLinks,
    settings,
    barometerReadings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'attacks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('medication_events', kind: UpdateKind.update)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$AttacksTableCreateCompanionBuilder = AttacksCompanion Function({
  required String id,
  required DateTime startedAt,
  Value<DateTime?> endedAt,
  Value<int?> intensity,
  Value<List<String>> headLocations,
  Value<Map<String, dynamic>> phases,
  Value<List<Map<String, dynamic>>> symptoms,
  Value<String?> notes,
  Value<double?> pressureSensorHpa,
  Value<double?> pressureStationHpa,
  Value<Map<String, dynamic>?> weather,
  Value<bool> finishLater,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$AttacksTableUpdateCompanionBuilder = AttacksCompanion Function({
  Value<String> id,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int?> intensity,
  Value<List<String>> headLocations,
  Value<Map<String, dynamic>> phases,
  Value<List<Map<String, dynamic>>> symptoms,
  Value<String?> notes,
  Value<double?> pressureSensorHpa,
  Value<double?> pressureStationHpa,
  Value<Map<String, dynamic>?> weather,
  Value<bool> finishLater,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$AttacksTableReferences
    extends BaseReferences<_$AppDatabase, $AttacksTable, Attack> {
  $$AttacksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicationEventsTable, List<MedicationEvent>>
  _medicationEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicationEvents,
    aliasName: 'attacks__id__medication_events__attack_id',
  );

  $$MedicationEventsTableProcessedTableManager get medicationEventsRefs {
    final manager = $$MedicationEventsTableTableManager(
      $_db,
      $_db.medicationEvents,
    ).filter((f) => f.attackId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _medicationEventsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AttacksTableFilterComposer
    extends Composer<_$AppDatabase, $AttacksTable> {
  $$AttacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get headLocations => $composableBuilder(
    column: $table.headLocations,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get phases => $composableBuilder(
    column: $table.phases,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<Map<String, dynamic>>,
    List<Map<String, dynamic>>,
    String
  >
  get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pressureSensorHpa => $composableBuilder(
    column: $table.pressureSensorHpa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pressureStationHpa => $composableBuilder(
    column: $table.pressureStationHpa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get finishLater => $composableBuilder(
    column: $table.finishLater,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> medicationEventsRefs(
    Expression<bool> Function($$MedicationEventsTableFilterComposer f) f,
  ) {
    final $$MedicationEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationEvents,
      getReferencedColumn: (t) => t.attackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationEventsTableFilterComposer(
            $db: $db,
            $table: $db.medicationEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AttacksTableOrderingComposer
    extends Composer<_$AppDatabase, $AttacksTable> {
  $$AttacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headLocations => $composableBuilder(
    column: $table.headLocations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phases => $composableBuilder(
    column: $table.phases,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pressureSensorHpa => $composableBuilder(
    column: $table.pressureSensorHpa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pressureStationHpa => $composableBuilder(
    column: $table.pressureStationHpa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get finishLater => $composableBuilder(
    column: $table.finishLater,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttacksTable> {
  $$AttacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get headLocations =>
      $composableBuilder(
        column: $table.headLocations,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get phases =>
      $composableBuilder(column: $table.phases, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>, String>
  get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get pressureSensorHpa => $composableBuilder(
    column: $table.pressureSensorHpa,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pressureStationHpa => $composableBuilder(
    column: $table.pressureStationHpa,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get weather =>
      $composableBuilder(column: $table.weather, builder: (column) => column);

  GeneratedColumn<bool> get finishLater => $composableBuilder(
    column: $table.finishLater,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> medicationEventsRefs<T extends Object>(
    Expression<T> Function($$MedicationEventsTableAnnotationComposer a) f,
  ) {
    final $$MedicationEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationEvents,
      getReferencedColumn: (t) => t.attackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AttacksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttacksTable,
          Attack,
          $$AttacksTableFilterComposer,
          $$AttacksTableOrderingComposer,
          $$AttacksTableAnnotationComposer,
          $$AttacksTableCreateCompanionBuilder,
          $$AttacksTableUpdateCompanionBuilder,
          (Attack, $$AttacksTableReferences),
          Attack,
          PrefetchHooks Function({bool medicationEventsRefs})
        > {
  $$AttacksTableTableManager(_$AppDatabase db, $AttacksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> intensity = const Value.absent(),
                Value<List<String>> headLocations = const Value.absent(),
                Value<Map<String, dynamic>> phases = const Value.absent(),
                Value<List<Map<String, dynamic>>> symptoms =
                    const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> pressureSensorHpa = const Value.absent(),
                Value<double?> pressureStationHpa = const Value.absent(),
                Value<Map<String, dynamic>?> weather = const Value.absent(),
                Value<bool> finishLater = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttacksCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                intensity: intensity,
                headLocations: headLocations,
                phases: phases,
                symptoms: symptoms,
                notes: notes,
                pressureSensorHpa: pressureSensorHpa,
                pressureStationHpa: pressureStationHpa,
                weather: weather,
                finishLater: finishLater,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> intensity = const Value.absent(),
                Value<List<String>> headLocations = const Value.absent(),
                Value<Map<String, dynamic>> phases = const Value.absent(),
                Value<List<Map<String, dynamic>>> symptoms =
                    const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> pressureSensorHpa = const Value.absent(),
                Value<double?> pressureStationHpa = const Value.absent(),
                Value<Map<String, dynamic>?> weather = const Value.absent(),
                Value<bool> finishLater = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AttacksCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                intensity: intensity,
                headLocations: headLocations,
                phases: phases,
                symptoms: symptoms,
                notes: notes,
                pressureSensorHpa: pressureSensorHpa,
                pressureStationHpa: pressureStationHpa,
                weather: weather,
                finishLater: finishLater,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AttacksTable, Attack>(table),
                  $$AttacksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicationEventsRefs) db.medicationEvents,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicationEventsRefs)
                    await $_getPrefetchedDataByColumns<
                      Attack,
                      $AttacksTable,
                      MedicationEvent,
                      $MedicationEventsTable
                    >(
                      currentTable: table,
                      referencedTable: $$AttacksTableReferences
                          ._medicationEventsRefsTable(db),
                      managerFromTypedResult: (p0) => $$AttacksTableReferences(
                        db,
                        table,
                        p0,
                      ).medicationEventsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'attack_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AttacksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttacksTable,
      Attack,
      $$AttacksTableFilterComposer,
      $$AttacksTableOrderingComposer,
      $$AttacksTableAnnotationComposer,
      $$AttacksTableCreateCompanionBuilder,
      $$AttacksTableUpdateCompanionBuilder,
      (Attack, $$AttacksTableReferences),
      Attack,
      PrefetchHooks Function({bool medicationEventsRefs})
    >;
typedef $$CheckinsTableCreateCompanionBuilder = CheckinsCompanion Function({
  required String date,
  Value<int?> sleepQuality,
  Value<int?> stress,
  Value<int?> neckTension,
  Value<int?> caffeine,
  Value<int?> hydration,
  Value<int?> alcohol,
  Value<int?> cycleDay,
  Value<int?> lightExposure,
  Value<int?> screenExposure,
  Value<Map<String, dynamic>> sources,
  Value<Map<String, dynamic>?> weather,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CheckinsTableUpdateCompanionBuilder = CheckinsCompanion Function({
  Value<String> date,
  Value<int?> sleepQuality,
  Value<int?> stress,
  Value<int?> neckTension,
  Value<int?> caffeine,
  Value<int?> hydration,
  Value<int?> alcohol,
  Value<int?> cycleDay,
  Value<int?> lightExposure,
  Value<int?> screenExposure,
  Value<Map<String, dynamic>> sources,
  Value<Map<String, dynamic>?> weather,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CheckinsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckinsTable> {
  $$CheckinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stress => $composableBuilder(
    column: $table.stress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get neckTension => $composableBuilder(
    column: $table.neckTension,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get caffeine => $composableBuilder(
    column: $table.caffeine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hydration => $composableBuilder(
    column: $table.hydration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alcohol => $composableBuilder(
    column: $table.alcohol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleDay => $composableBuilder(
    column: $table.cycleDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lightExposure => $composableBuilder(
    column: $table.lightExposure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get screenExposure => $composableBuilder(
    column: $table.screenExposure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get sources => $composableBuilder(
    column: $table.sources,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CheckinsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckinsTable> {
  $$CheckinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stress => $composableBuilder(
    column: $table.stress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get neckTension => $composableBuilder(
    column: $table.neckTension,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get caffeine => $composableBuilder(
    column: $table.caffeine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hydration => $composableBuilder(
    column: $table.hydration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alcohol => $composableBuilder(
    column: $table.alcohol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleDay => $composableBuilder(
    column: $table.cycleDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lightExposure => $composableBuilder(
    column: $table.lightExposure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get screenExposure => $composableBuilder(
    column: $table.screenExposure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sources => $composableBuilder(
    column: $table.sources,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CheckinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckinsTable> {
  $$CheckinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stress =>
      $composableBuilder(column: $table.stress, builder: (column) => column);

  GeneratedColumn<int> get neckTension => $composableBuilder(
    column: $table.neckTension,
    builder: (column) => column,
  );

  GeneratedColumn<int> get caffeine =>
      $composableBuilder(column: $table.caffeine, builder: (column) => column);

  GeneratedColumn<int> get hydration =>
      $composableBuilder(column: $table.hydration, builder: (column) => column);

  GeneratedColumn<int> get alcohol =>
      $composableBuilder(column: $table.alcohol, builder: (column) => column);

  GeneratedColumn<int> get cycleDay =>
      $composableBuilder(column: $table.cycleDay, builder: (column) => column);

  GeneratedColumn<int> get lightExposure => $composableBuilder(
    column: $table.lightExposure,
    builder: (column) => column,
  );

  GeneratedColumn<int> get screenExposure => $composableBuilder(
    column: $table.screenExposure,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get sources =>
      $composableBuilder(column: $table.sources, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get weather =>
      $composableBuilder(column: $table.weather, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CheckinsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckinsTable,
          Checkin,
          $$CheckinsTableFilterComposer,
          $$CheckinsTableOrderingComposer,
          $$CheckinsTableAnnotationComposer,
          $$CheckinsTableCreateCompanionBuilder,
          $$CheckinsTableUpdateCompanionBuilder,
          (Checkin, BaseReferences<_$AppDatabase, $CheckinsTable, Checkin>),
          Checkin,
          PrefetchHooks Function()
        > {
  $$CheckinsTableTableManager(_$AppDatabase db, $CheckinsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int?> sleepQuality = const Value.absent(),
                Value<int?> stress = const Value.absent(),
                Value<int?> neckTension = const Value.absent(),
                Value<int?> caffeine = const Value.absent(),
                Value<int?> hydration = const Value.absent(),
                Value<int?> alcohol = const Value.absent(),
                Value<int?> cycleDay = const Value.absent(),
                Value<int?> lightExposure = const Value.absent(),
                Value<int?> screenExposure = const Value.absent(),
                Value<Map<String, dynamic>> sources = const Value.absent(),
                Value<Map<String, dynamic>?> weather = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CheckinsCompanion(
                date: date,
                sleepQuality: sleepQuality,
                stress: stress,
                neckTension: neckTension,
                caffeine: caffeine,
                hydration: hydration,
                alcohol: alcohol,
                cycleDay: cycleDay,
                lightExposure: lightExposure,
                screenExposure: screenExposure,
                sources: sources,
                weather: weather,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<int?> sleepQuality = const Value.absent(),
                Value<int?> stress = const Value.absent(),
                Value<int?> neckTension = const Value.absent(),
                Value<int?> caffeine = const Value.absent(),
                Value<int?> hydration = const Value.absent(),
                Value<int?> alcohol = const Value.absent(),
                Value<int?> cycleDay = const Value.absent(),
                Value<int?> lightExposure = const Value.absent(),
                Value<int?> screenExposure = const Value.absent(),
                Value<Map<String, dynamic>> sources = const Value.absent(),
                Value<Map<String, dynamic>?> weather = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CheckinsCompanion.insert(
                date: date,
                sleepQuality: sleepQuality,
                stress: stress,
                neckTension: neckTension,
                caffeine: caffeine,
                hydration: hydration,
                alcohol: alcohol,
                cycleDay: cycleDay,
                lightExposure: lightExposure,
                screenExposure: screenExposure,
                sources: sources,
                weather: weather,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CheckinsTable, Checkin>(table),
                  BaseReferences<_$AppDatabase, $CheckinsTable, Checkin>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CheckinsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckinsTable,
      Checkin,
      $$CheckinsTableFilterComposer,
      $$CheckinsTableOrderingComposer,
      $$CheckinsTableAnnotationComposer,
      $$CheckinsTableCreateCompanionBuilder,
      $$CheckinsTableUpdateCompanionBuilder,
      (Checkin, BaseReferences<_$AppDatabase, $CheckinsTable, Checkin>),
      Checkin,
      PrefetchHooks Function()
    >;
typedef $$MedicationEventsTableCreateCompanionBuilder =
    MedicationEventsCompanion Function({
      required String id,
      Value<String?> attackId,
      required String name,
      Value<String?> dose,
      required DateTime takenAt,
      Value<int?> reliefAt2h,
      required String kind,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MedicationEventsTableUpdateCompanionBuilder =
    MedicationEventsCompanion Function({
      Value<String> id,
      Value<String?> attackId,
      Value<String> name,
      Value<String?> dose,
      Value<DateTime> takenAt,
      Value<int?> reliefAt2h,
      Value<String> kind,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$MedicationEventsTableReferences
    extends
        BaseReferences<_$AppDatabase, $MedicationEventsTable, MedicationEvent> {
  $$MedicationEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AttacksTable _attackIdTable(_$AppDatabase db) =>
      db.attacks.createAlias('medication_events__attack_id__attacks__id');

  $$AttacksTableProcessedTableManager? get attackId {
    final $_column = $_itemColumn<String>('attack_id');
    if ($_column == null) return null;
    final manager = $$AttacksTableTableManager(
      $_db,
      $_db.attacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_attackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationEventsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationEventsTable> {
  $$MedicationEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reliefAt2h => $composableBuilder(
    column: $table.reliefAt2h,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AttacksTableFilterComposer get attackId {
    final $$AttacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attackId,
      referencedTable: $db.attacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttacksTableFilterComposer(
            $db: $db,
            $table: $db.attacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationEventsTable> {
  $$MedicationEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reliefAt2h => $composableBuilder(
    column: $table.reliefAt2h,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AttacksTableOrderingComposer get attackId {
    final $$AttacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attackId,
      referencedTable: $db.attacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttacksTableOrderingComposer(
            $db: $db,
            $table: $db.attacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationEventsTable> {
  $$MedicationEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<int> get reliefAt2h => $composableBuilder(
    column: $table.reliefAt2h,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AttacksTableAnnotationComposer get attackId {
    final $$AttacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attackId,
      referencedTable: $db.attacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttacksTableAnnotationComposer(
            $db: $db,
            $table: $db.attacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationEventsTable,
          MedicationEvent,
          $$MedicationEventsTableFilterComposer,
          $$MedicationEventsTableOrderingComposer,
          $$MedicationEventsTableAnnotationComposer,
          $$MedicationEventsTableCreateCompanionBuilder,
          $$MedicationEventsTableUpdateCompanionBuilder,
          (MedicationEvent, $$MedicationEventsTableReferences),
          MedicationEvent,
          PrefetchHooks Function({bool attackId})
        > {
  $$MedicationEventsTableTableManager(
    _$AppDatabase db,
    $MedicationEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> attackId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> dose = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<int?> reliefAt2h = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationEventsCompanion(
                id: id,
                attackId: attackId,
                name: name,
                dose: dose,
                takenAt: takenAt,
                reliefAt2h: reliefAt2h,
                kind: kind,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> attackId = const Value.absent(),
                required String name,
                Value<String?> dose = const Value.absent(),
                required DateTime takenAt,
                Value<int?> reliefAt2h = const Value.absent(),
                required String kind,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MedicationEventsCompanion.insert(
                id: id,
                attackId: attackId,
                name: name,
                dose: dose,
                takenAt: takenAt,
                reliefAt2h: reliefAt2h,
                kind: kind,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationEventsTable, MedicationEvent>(table),
                  $$MedicationEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (attackId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.attackId,
                        referencedTable: $$MedicationEventsTableReferences
                            ._attackIdTable(db),
                        referencedColumn: $$MedicationEventsTableReferences
                            ._attackIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicationEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationEventsTable,
      MedicationEvent,
      $$MedicationEventsTableFilterComposer,
      $$MedicationEventsTableOrderingComposer,
      $$MedicationEventsTableAnnotationComposer,
      $$MedicationEventsTableCreateCompanionBuilder,
      $$MedicationEventsTableUpdateCompanionBuilder,
      (MedicationEvent, $$MedicationEventsTableReferences),
      MedicationEvent,
      PrefetchHooks Function({bool attackId})
    >;
typedef $$WeatherHoursTableCreateCompanionBuilder =
    WeatherHoursCompanion Function({
      required String cell,
      required DateTime hourUtc,
      Value<double?> pressureMsl,
      Value<double?> surfacePressure,
      Value<double?> temperature,
      Value<double?> humidity,
      Value<double?> precipitation,
      Value<double?> wind,
      Value<double?> cloud,
      Value<int?> weatherCode,
      Value<double?> uv,
      Value<String> source,
      required DateTime fetchedAt,
      Value<bool> pinned,
      Value<int> rowid,
    });
typedef $$WeatherHoursTableUpdateCompanionBuilder =
    WeatherHoursCompanion Function({
      Value<String> cell,
      Value<DateTime> hourUtc,
      Value<double?> pressureMsl,
      Value<double?> surfacePressure,
      Value<double?> temperature,
      Value<double?> humidity,
      Value<double?> precipitation,
      Value<double?> wind,
      Value<double?> cloud,
      Value<int?> weatherCode,
      Value<double?> uv,
      Value<String> source,
      Value<DateTime> fetchedAt,
      Value<bool> pinned,
      Value<int> rowid,
    });

class $$WeatherHoursTableFilterComposer
    extends Composer<_$AppDatabase, $WeatherHoursTable> {
  $$WeatherHoursTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cell => $composableBuilder(
    column: $table.cell,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get hourUtc => $composableBuilder(
    column: $table.hourUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pressureMsl => $composableBuilder(
    column: $table.pressureMsl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get surfacePressure => $composableBuilder(
    column: $table.surfacePressure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get humidity => $composableBuilder(
    column: $table.humidity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precipitation => $composableBuilder(
    column: $table.precipitation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wind => $composableBuilder(
    column: $table.wind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cloud => $composableBuilder(
    column: $table.cloud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weatherCode => $composableBuilder(
    column: $table.weatherCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get uv => $composableBuilder(
    column: $table.uv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeatherHoursTableOrderingComposer
    extends Composer<_$AppDatabase, $WeatherHoursTable> {
  $$WeatherHoursTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cell => $composableBuilder(
    column: $table.cell,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get hourUtc => $composableBuilder(
    column: $table.hourUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pressureMsl => $composableBuilder(
    column: $table.pressureMsl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get surfacePressure => $composableBuilder(
    column: $table.surfacePressure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get humidity => $composableBuilder(
    column: $table.humidity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precipitation => $composableBuilder(
    column: $table.precipitation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wind => $composableBuilder(
    column: $table.wind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cloud => $composableBuilder(
    column: $table.cloud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weatherCode => $composableBuilder(
    column: $table.weatherCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get uv => $composableBuilder(
    column: $table.uv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeatherHoursTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeatherHoursTable> {
  $$WeatherHoursTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cell =>
      $composableBuilder(column: $table.cell, builder: (column) => column);

  GeneratedColumn<DateTime> get hourUtc =>
      $composableBuilder(column: $table.hourUtc, builder: (column) => column);

  GeneratedColumn<double> get pressureMsl => $composableBuilder(
    column: $table.pressureMsl,
    builder: (column) => column,
  );

  GeneratedColumn<double> get surfacePressure => $composableBuilder(
    column: $table.surfacePressure,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<double> get humidity =>
      $composableBuilder(column: $table.humidity, builder: (column) => column);

  GeneratedColumn<double> get precipitation => $composableBuilder(
    column: $table.precipitation,
    builder: (column) => column,
  );

  GeneratedColumn<double> get wind =>
      $composableBuilder(column: $table.wind, builder: (column) => column);

  GeneratedColumn<double> get cloud =>
      $composableBuilder(column: $table.cloud, builder: (column) => column);

  GeneratedColumn<int> get weatherCode => $composableBuilder(
    column: $table.weatherCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get uv =>
      $composableBuilder(column: $table.uv, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);
}

class $$WeatherHoursTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeatherHoursTable,
          WeatherHour,
          $$WeatherHoursTableFilterComposer,
          $$WeatherHoursTableOrderingComposer,
          $$WeatherHoursTableAnnotationComposer,
          $$WeatherHoursTableCreateCompanionBuilder,
          $$WeatherHoursTableUpdateCompanionBuilder,
          (
            WeatherHour,
            BaseReferences<_$AppDatabase, $WeatherHoursTable, WeatherHour>,
          ),
          WeatherHour,
          PrefetchHooks Function()
        > {
  $$WeatherHoursTableTableManager(_$AppDatabase db, $WeatherHoursTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeatherHoursTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeatherHoursTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeatherHoursTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cell = const Value.absent(),
                Value<DateTime> hourUtc = const Value.absent(),
                Value<double?> pressureMsl = const Value.absent(),
                Value<double?> surfacePressure = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> humidity = const Value.absent(),
                Value<double?> precipitation = const Value.absent(),
                Value<double?> wind = const Value.absent(),
                Value<double?> cloud = const Value.absent(),
                Value<int?> weatherCode = const Value.absent(),
                Value<double?> uv = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<bool> pinned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeatherHoursCompanion(
                cell: cell,
                hourUtc: hourUtc,
                pressureMsl: pressureMsl,
                surfacePressure: surfacePressure,
                temperature: temperature,
                humidity: humidity,
                precipitation: precipitation,
                wind: wind,
                cloud: cloud,
                weatherCode: weatherCode,
                uv: uv,
                source: source,
                fetchedAt: fetchedAt,
                pinned: pinned,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cell,
                required DateTime hourUtc,
                Value<double?> pressureMsl = const Value.absent(),
                Value<double?> surfacePressure = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> humidity = const Value.absent(),
                Value<double?> precipitation = const Value.absent(),
                Value<double?> wind = const Value.absent(),
                Value<double?> cloud = const Value.absent(),
                Value<int?> weatherCode = const Value.absent(),
                Value<double?> uv = const Value.absent(),
                Value<String> source = const Value.absent(),
                required DateTime fetchedAt,
                Value<bool> pinned = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeatherHoursCompanion.insert(
                cell: cell,
                hourUtc: hourUtc,
                pressureMsl: pressureMsl,
                surfacePressure: surfacePressure,
                temperature: temperature,
                humidity: humidity,
                precipitation: precipitation,
                wind: wind,
                cloud: cloud,
                weatherCode: weatherCode,
                uv: uv,
                source: source,
                fetchedAt: fetchedAt,
                pinned: pinned,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeatherHoursTable, WeatherHour>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WeatherHoursTable,
                    WeatherHour
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeatherHoursTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeatherHoursTable,
      WeatherHour,
      $$WeatherHoursTableFilterComposer,
      $$WeatherHoursTableOrderingComposer,
      $$WeatherHoursTableAnnotationComposer,
      $$WeatherHoursTableCreateCompanionBuilder,
      $$WeatherHoursTableUpdateCompanionBuilder,
      (
        WeatherHour,
        BaseReferences<_$AppDatabase, $WeatherHoursTable, WeatherHour>,
      ),
      WeatherHour,
      PrefetchHooks Function()
    >;
typedef $$EnvironmentDaysTableCreateCompanionBuilder =
    EnvironmentDaysCompanion Function({
      required String date,
      required String cell,
      Value<double?> aqiUs,
      Value<double?> aqiEu,
      Value<double?> pm25,
      Value<double?> pm10,
      Value<double?> ozone,
      Value<Map<String, dynamic>?> pollen,
      Value<double?> uvMax,
      Value<int?> daylightMinutes,
      Value<DateTime?> sunrise,
      Value<DateTime?> sunset,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$EnvironmentDaysTableUpdateCompanionBuilder =
    EnvironmentDaysCompanion Function({
      Value<String> date,
      Value<String> cell,
      Value<double?> aqiUs,
      Value<double?> aqiEu,
      Value<double?> pm25,
      Value<double?> pm10,
      Value<double?> ozone,
      Value<Map<String, dynamic>?> pollen,
      Value<double?> uvMax,
      Value<int?> daylightMinutes,
      Value<DateTime?> sunrise,
      Value<DateTime?> sunset,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$EnvironmentDaysTableFilterComposer
    extends Composer<_$AppDatabase, $EnvironmentDaysTable> {
  $$EnvironmentDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cell => $composableBuilder(
    column: $table.cell,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get aqiUs => $composableBuilder(
    column: $table.aqiUs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get aqiEu => $composableBuilder(
    column: $table.aqiEu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pm25 => $composableBuilder(
    column: $table.pm25,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pm10 => $composableBuilder(
    column: $table.pm10,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ozone => $composableBuilder(
    column: $table.ozone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get pollen => $composableBuilder(
    column: $table.pollen,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get uvMax => $composableBuilder(
    column: $table.uvMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daylightMinutes => $composableBuilder(
    column: $table.daylightMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sunrise => $composableBuilder(
    column: $table.sunrise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sunset => $composableBuilder(
    column: $table.sunset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EnvironmentDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvironmentDaysTable> {
  $$EnvironmentDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cell => $composableBuilder(
    column: $table.cell,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get aqiUs => $composableBuilder(
    column: $table.aqiUs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get aqiEu => $composableBuilder(
    column: $table.aqiEu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pm25 => $composableBuilder(
    column: $table.pm25,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pm10 => $composableBuilder(
    column: $table.pm10,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ozone => $composableBuilder(
    column: $table.ozone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pollen => $composableBuilder(
    column: $table.pollen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get uvMax => $composableBuilder(
    column: $table.uvMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daylightMinutes => $composableBuilder(
    column: $table.daylightMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sunrise => $composableBuilder(
    column: $table.sunrise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sunset => $composableBuilder(
    column: $table.sunset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EnvironmentDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvironmentDaysTable> {
  $$EnvironmentDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get cell =>
      $composableBuilder(column: $table.cell, builder: (column) => column);

  GeneratedColumn<double> get aqiUs =>
      $composableBuilder(column: $table.aqiUs, builder: (column) => column);

  GeneratedColumn<double> get aqiEu =>
      $composableBuilder(column: $table.aqiEu, builder: (column) => column);

  GeneratedColumn<double> get pm25 =>
      $composableBuilder(column: $table.pm25, builder: (column) => column);

  GeneratedColumn<double> get pm10 =>
      $composableBuilder(column: $table.pm10, builder: (column) => column);

  GeneratedColumn<double> get ozone =>
      $composableBuilder(column: $table.ozone, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get pollen =>
      $composableBuilder(column: $table.pollen, builder: (column) => column);

  GeneratedColumn<double> get uvMax =>
      $composableBuilder(column: $table.uvMax, builder: (column) => column);

  GeneratedColumn<int> get daylightMinutes => $composableBuilder(
    column: $table.daylightMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sunrise =>
      $composableBuilder(column: $table.sunrise, builder: (column) => column);

  GeneratedColumn<DateTime> get sunset =>
      $composableBuilder(column: $table.sunset, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$EnvironmentDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnvironmentDaysTable,
          EnvironmentDay,
          $$EnvironmentDaysTableFilterComposer,
          $$EnvironmentDaysTableOrderingComposer,
          $$EnvironmentDaysTableAnnotationComposer,
          $$EnvironmentDaysTableCreateCompanionBuilder,
          $$EnvironmentDaysTableUpdateCompanionBuilder,
          (
            EnvironmentDay,
            BaseReferences<
              _$AppDatabase,
              $EnvironmentDaysTable,
              EnvironmentDay
            >,
          ),
          EnvironmentDay,
          PrefetchHooks Function()
        > {
  $$EnvironmentDaysTableTableManager(
    _$AppDatabase db,
    $EnvironmentDaysTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvironmentDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvironmentDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnvironmentDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> cell = const Value.absent(),
                Value<double?> aqiUs = const Value.absent(),
                Value<double?> aqiEu = const Value.absent(),
                Value<double?> pm25 = const Value.absent(),
                Value<double?> pm10 = const Value.absent(),
                Value<double?> ozone = const Value.absent(),
                Value<Map<String, dynamic>?> pollen = const Value.absent(),
                Value<double?> uvMax = const Value.absent(),
                Value<int?> daylightMinutes = const Value.absent(),
                Value<DateTime?> sunrise = const Value.absent(),
                Value<DateTime?> sunset = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnvironmentDaysCompanion(
                date: date,
                cell: cell,
                aqiUs: aqiUs,
                aqiEu: aqiEu,
                pm25: pm25,
                pm10: pm10,
                ozone: ozone,
                pollen: pollen,
                uvMax: uvMax,
                daylightMinutes: daylightMinutes,
                sunrise: sunrise,
                sunset: sunset,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String cell,
                Value<double?> aqiUs = const Value.absent(),
                Value<double?> aqiEu = const Value.absent(),
                Value<double?> pm25 = const Value.absent(),
                Value<double?> pm10 = const Value.absent(),
                Value<double?> ozone = const Value.absent(),
                Value<Map<String, dynamic>?> pollen = const Value.absent(),
                Value<double?> uvMax = const Value.absent(),
                Value<int?> daylightMinutes = const Value.absent(),
                Value<DateTime?> sunrise = const Value.absent(),
                Value<DateTime?> sunset = const Value.absent(),
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => EnvironmentDaysCompanion.insert(
                date: date,
                cell: cell,
                aqiUs: aqiUs,
                aqiEu: aqiEu,
                pm25: pm25,
                pm10: pm10,
                ozone: ozone,
                pollen: pollen,
                uvMax: uvMax,
                daylightMinutes: daylightMinutes,
                sunrise: sunrise,
                sunset: sunset,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EnvironmentDaysTable, EnvironmentDay>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EnvironmentDaysTable,
                    EnvironmentDay
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EnvironmentDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnvironmentDaysTable,
      EnvironmentDay,
      $$EnvironmentDaysTableFilterComposer,
      $$EnvironmentDaysTableOrderingComposer,
      $$EnvironmentDaysTableAnnotationComposer,
      $$EnvironmentDaysTableCreateCompanionBuilder,
      $$EnvironmentDaysTableUpdateCompanionBuilder,
      (
        EnvironmentDay,
        BaseReferences<_$AppDatabase, $EnvironmentDaysTable, EnvironmentDay>,
      ),
      EnvironmentDay,
      PrefetchHooks Function()
    >;
typedef $$HealthSamplesTableCreateCompanionBuilder =
    HealthSamplesCompanion Function({
      required String id,
      required String type,
      required DateTime start,
      required DateTime end,
      required double value,
      required String unit,
      required String sourceStore,
      Value<String?> sourceName,
      required DateTime importedAt,
      Value<int> rowid,
    });
typedef $$HealthSamplesTableUpdateCompanionBuilder =
    HealthSamplesCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<DateTime> start,
      Value<DateTime> end,
      Value<double> value,
      Value<String> unit,
      Value<String> sourceStore,
      Value<String?> sourceName,
      Value<DateTime> importedAt,
      Value<int> rowid,
    });

class $$HealthSamplesTableFilterComposer
    extends Composer<_$AppDatabase, $HealthSamplesTable> {
  $$HealthSamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceStore => $composableBuilder(
    column: $table.sourceStore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HealthSamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthSamplesTable> {
  $$HealthSamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceStore => $composableBuilder(
    column: $table.sourceStore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HealthSamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthSamplesTable> {
  $$HealthSamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<DateTime> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get sourceStore => $composableBuilder(
    column: $table.sourceStore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );
}

class $$HealthSamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthSamplesTable,
          HealthSample,
          $$HealthSamplesTableFilterComposer,
          $$HealthSamplesTableOrderingComposer,
          $$HealthSamplesTableAnnotationComposer,
          $$HealthSamplesTableCreateCompanionBuilder,
          $$HealthSamplesTableUpdateCompanionBuilder,
          (
            HealthSample,
            BaseReferences<_$AppDatabase, $HealthSamplesTable, HealthSample>,
          ),
          HealthSample,
          PrefetchHooks Function()
        > {
  $$HealthSamplesTableTableManager(_$AppDatabase db, $HealthSamplesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthSamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthSamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthSamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> start = const Value.absent(),
                Value<DateTime> end = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> sourceStore = const Value.absent(),
                Value<String?> sourceName = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HealthSamplesCompanion(
                id: id,
                type: type,
                start: start,
                end: end,
                value: value,
                unit: unit,
                sourceStore: sourceStore,
                sourceName: sourceName,
                importedAt: importedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required DateTime start,
                required DateTime end,
                required double value,
                required String unit,
                required String sourceStore,
                Value<String?> sourceName = const Value.absent(),
                required DateTime importedAt,
                Value<int> rowid = const Value.absent(),
              }) => HealthSamplesCompanion.insert(
                id: id,
                type: type,
                start: start,
                end: end,
                value: value,
                unit: unit,
                sourceStore: sourceStore,
                sourceName: sourceName,
                importedAt: importedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HealthSamplesTable, HealthSample>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $HealthSamplesTable,
                    HealthSample
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HealthSamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthSamplesTable,
      HealthSample,
      $$HealthSamplesTableFilterComposer,
      $$HealthSamplesTableOrderingComposer,
      $$HealthSamplesTableAnnotationComposer,
      $$HealthSamplesTableCreateCompanionBuilder,
      $$HealthSamplesTableUpdateCompanionBuilder,
      (
        HealthSample,
        BaseReferences<_$AppDatabase, $HealthSamplesTable, HealthSample>,
      ),
      HealthSample,
      PrefetchHooks Function()
    >;
typedef $$FactorWeightsTableCreateCompanionBuilder =
    FactorWeightsCompanion Function({
      required String factor,
      required double populationWeight,
      required double personalWeight,
      required double confidence,
      Value<int> nExposures,
      Value<int> nAttacksAfter,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FactorWeightsTableUpdateCompanionBuilder =
    FactorWeightsCompanion Function({
      Value<String> factor,
      Value<double> populationWeight,
      Value<double> personalWeight,
      Value<double> confidence,
      Value<int> nExposures,
      Value<int> nAttacksAfter,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$FactorWeightsTableFilterComposer
    extends Composer<_$AppDatabase, $FactorWeightsTable> {
  $$FactorWeightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get factor => $composableBuilder(
    column: $table.factor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get populationWeight => $composableBuilder(
    column: $table.populationWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get personalWeight => $composableBuilder(
    column: $table.personalWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nExposures => $composableBuilder(
    column: $table.nExposures,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nAttacksAfter => $composableBuilder(
    column: $table.nAttacksAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FactorWeightsTableOrderingComposer
    extends Composer<_$AppDatabase, $FactorWeightsTable> {
  $$FactorWeightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get factor => $composableBuilder(
    column: $table.factor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get populationWeight => $composableBuilder(
    column: $table.populationWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get personalWeight => $composableBuilder(
    column: $table.personalWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nExposures => $composableBuilder(
    column: $table.nExposures,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nAttacksAfter => $composableBuilder(
    column: $table.nAttacksAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FactorWeightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FactorWeightsTable> {
  $$FactorWeightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get factor =>
      $composableBuilder(column: $table.factor, builder: (column) => column);

  GeneratedColumn<double> get populationWeight => $composableBuilder(
    column: $table.populationWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get personalWeight => $composableBuilder(
    column: $table.personalWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nExposures => $composableBuilder(
    column: $table.nExposures,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nAttacksAfter => $composableBuilder(
    column: $table.nAttacksAfter,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FactorWeightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FactorWeightsTable,
          FactorWeight,
          $$FactorWeightsTableFilterComposer,
          $$FactorWeightsTableOrderingComposer,
          $$FactorWeightsTableAnnotationComposer,
          $$FactorWeightsTableCreateCompanionBuilder,
          $$FactorWeightsTableUpdateCompanionBuilder,
          (
            FactorWeight,
            BaseReferences<_$AppDatabase, $FactorWeightsTable, FactorWeight>,
          ),
          FactorWeight,
          PrefetchHooks Function()
        > {
  $$FactorWeightsTableTableManager(_$AppDatabase db, $FactorWeightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FactorWeightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FactorWeightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FactorWeightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> factor = const Value.absent(),
                Value<double> populationWeight = const Value.absent(),
                Value<double> personalWeight = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<int> nExposures = const Value.absent(),
                Value<int> nAttacksAfter = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FactorWeightsCompanion(
                factor: factor,
                populationWeight: populationWeight,
                personalWeight: personalWeight,
                confidence: confidence,
                nExposures: nExposures,
                nAttacksAfter: nAttacksAfter,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String factor,
                required double populationWeight,
                required double personalWeight,
                required double confidence,
                Value<int> nExposures = const Value.absent(),
                Value<int> nAttacksAfter = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FactorWeightsCompanion.insert(
                factor: factor,
                populationWeight: populationWeight,
                personalWeight: personalWeight,
                confidence: confidence,
                nExposures: nExposures,
                nAttacksAfter: nAttacksAfter,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FactorWeightsTable, FactorWeight>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FactorWeightsTable,
                    FactorWeight
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FactorWeightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FactorWeightsTable,
      FactorWeight,
      $$FactorWeightsTableFilterComposer,
      $$FactorWeightsTableOrderingComposer,
      $$FactorWeightsTableAnnotationComposer,
      $$FactorWeightsTableCreateCompanionBuilder,
      $$FactorWeightsTableUpdateCompanionBuilder,
      (
        FactorWeight,
        BaseReferences<_$AppDatabase, $FactorWeightsTable, FactorWeight>,
      ),
      FactorWeight,
      PrefetchHooks Function()
    >;
typedef $$RiskDaysTableCreateCompanionBuilder = RiskDaysCompanion Function({
  required String date,
  required String level,
  required double score,
  Value<List<Map<String, dynamic>>> drivers,
  required String modelVersion,
  required DateTime computedAt,
  Value<int> rowid,
});
typedef $$RiskDaysTableUpdateCompanionBuilder = RiskDaysCompanion Function({
  Value<String> date,
  Value<String> level,
  Value<double> score,
  Value<List<Map<String, dynamic>>> drivers,
  Value<String> modelVersion,
  Value<DateTime> computedAt,
  Value<int> rowid,
});

class $$RiskDaysTableFilterComposer
    extends Composer<_$AppDatabase, $RiskDaysTable> {
  $$RiskDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<Map<String, dynamic>>,
    List<Map<String, dynamic>>,
    String
  >
  get drivers => $composableBuilder(
    column: $table.drivers,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RiskDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $RiskDaysTable> {
  $$RiskDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get drivers => $composableBuilder(
    column: $table.drivers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RiskDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $RiskDaysTable> {
  $$RiskDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>, String>
  get drivers =>
      $composableBuilder(column: $table.drivers, builder: (column) => column);

  GeneratedColumn<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => column,
  );
}

class $$RiskDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RiskDaysTable,
          RiskDay,
          $$RiskDaysTableFilterComposer,
          $$RiskDaysTableOrderingComposer,
          $$RiskDaysTableAnnotationComposer,
          $$RiskDaysTableCreateCompanionBuilder,
          $$RiskDaysTableUpdateCompanionBuilder,
          (RiskDay, BaseReferences<_$AppDatabase, $RiskDaysTable, RiskDay>),
          RiskDay,
          PrefetchHooks Function()
        > {
  $$RiskDaysTableTableManager(_$AppDatabase db, $RiskDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RiskDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RiskDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RiskDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<List<Map<String, dynamic>>> drivers =
                    const Value.absent(),
                Value<String> modelVersion = const Value.absent(),
                Value<DateTime> computedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiskDaysCompanion(
                date: date,
                level: level,
                score: score,
                drivers: drivers,
                modelVersion: modelVersion,
                computedAt: computedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String level,
                required double score,
                Value<List<Map<String, dynamic>>> drivers =
                    const Value.absent(),
                required String modelVersion,
                required DateTime computedAt,
                Value<int> rowid = const Value.absent(),
              }) => RiskDaysCompanion.insert(
                date: date,
                level: level,
                score: score,
                drivers: drivers,
                modelVersion: modelVersion,
                computedAt: computedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RiskDaysTable, RiskDay>(table),
                  BaseReferences<_$AppDatabase, $RiskDaysTable, RiskDay>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RiskDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RiskDaysTable,
      RiskDay,
      $$RiskDaysTableFilterComposer,
      $$RiskDaysTableOrderingComposer,
      $$RiskDaysTableAnnotationComposer,
      $$RiskDaysTableCreateCompanionBuilder,
      $$RiskDaysTableUpdateCompanionBuilder,
      (RiskDay, BaseReferences<_$AppDatabase, $RiskDaysTable, RiskDay>),
      RiskDay,
      PrefetchHooks Function()
    >;
typedef $$ExperimentsTableCreateCompanionBuilder =
    ExperimentsCompanion Function({
      required String id,
      required String change,
      required DateTime start,
      Value<DateTime?> end,
      Value<Map<String, dynamic>> adherence,
      Value<Map<String, dynamic>?> result,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$ExperimentsTableUpdateCompanionBuilder =
    ExperimentsCompanion Function({
      Value<String> id,
      Value<String> change,
      Value<DateTime> start,
      Value<DateTime?> end,
      Value<Map<String, dynamic>> adherence,
      Value<Map<String, dynamic>?> result,
      Value<String> status,
      Value<int> rowid,
    });

class $$ExperimentsTableFilterComposer
    extends Composer<_$AppDatabase, $ExperimentsTable> {
  $$ExperimentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get change => $composableBuilder(
    column: $table.change,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get adherence => $composableBuilder(
    column: $table.adherence,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExperimentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExperimentsTable> {
  $$ExperimentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get change => $composableBuilder(
    column: $table.change,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adherence => $composableBuilder(
    column: $table.adherence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExperimentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExperimentsTable> {
  $$ExperimentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get change =>
      $composableBuilder(column: $table.change, builder: (column) => column);

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<DateTime> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  get adherence =>
      $composableBuilder(column: $table.adherence, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$ExperimentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExperimentsTable,
          Experiment,
          $$ExperimentsTableFilterComposer,
          $$ExperimentsTableOrderingComposer,
          $$ExperimentsTableAnnotationComposer,
          $$ExperimentsTableCreateCompanionBuilder,
          $$ExperimentsTableUpdateCompanionBuilder,
          (
            Experiment,
            BaseReferences<_$AppDatabase, $ExperimentsTable, Experiment>,
          ),
          Experiment,
          PrefetchHooks Function()
        > {
  $$ExperimentsTableTableManager(_$AppDatabase db, $ExperimentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExperimentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExperimentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExperimentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> change = const Value.absent(),
                Value<DateTime> start = const Value.absent(),
                Value<DateTime?> end = const Value.absent(),
                Value<Map<String, dynamic>> adherence = const Value.absent(),
                Value<Map<String, dynamic>?> result = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExperimentsCompanion(
                id: id,
                change: change,
                start: start,
                end: end,
                adherence: adherence,
                result: result,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String change,
                required DateTime start,
                Value<DateTime?> end = const Value.absent(),
                Value<Map<String, dynamic>> adherence = const Value.absent(),
                Value<Map<String, dynamic>?> result = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExperimentsCompanion.insert(
                id: id,
                change: change,
                start: start,
                end: end,
                adherence: adherence,
                result: result,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExperimentsTable, Experiment>(table),
                  BaseReferences<_$AppDatabase, $ExperimentsTable, Experiment>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExperimentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExperimentsTable,
      Experiment,
      $$ExperimentsTableFilterComposer,
      $$ExperimentsTableOrderingComposer,
      $$ExperimentsTableAnnotationComposer,
      $$ExperimentsTableCreateCompanionBuilder,
      $$ExperimentsTableUpdateCompanionBuilder,
      (
        Experiment,
        BaseReferences<_$AppDatabase, $ExperimentsTable, Experiment>,
      ),
      Experiment,
      PrefetchHooks Function()
    >;
typedef $$QuestionnairesTableCreateCompanionBuilder =
    QuestionnairesCompanion Function({
      required String id,
      required String type,
      required DateTime date,
      required Map<String, dynamic> answers,
      required int score,
      Value<int> rowid,
    });
typedef $$QuestionnairesTableUpdateCompanionBuilder =
    QuestionnairesCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<DateTime> date,
      Value<Map<String, dynamic>> answers,
      Value<int> score,
      Value<int> rowid,
    });

class $$QuestionnairesTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionnairesTable> {
  $$QuestionnairesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionnairesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionnairesTable> {
  $$QuestionnairesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionnairesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionnairesTable> {
  $$QuestionnairesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get answers =>
      $composableBuilder(column: $table.answers, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);
}

class $$QuestionnairesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionnairesTable,
          Questionnaire,
          $$QuestionnairesTableFilterComposer,
          $$QuestionnairesTableOrderingComposer,
          $$QuestionnairesTableAnnotationComposer,
          $$QuestionnairesTableCreateCompanionBuilder,
          $$QuestionnairesTableUpdateCompanionBuilder,
          (
            Questionnaire,
            BaseReferences<_$AppDatabase, $QuestionnairesTable, Questionnaire>,
          ),
          Questionnaire,
          PrefetchHooks Function()
        > {
  $$QuestionnairesTableTableManager(
    _$AppDatabase db,
    $QuestionnairesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionnairesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionnairesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionnairesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<Map<String, dynamic>> answers = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionnairesCompanion(
                id: id,
                type: type,
                date: date,
                answers: answers,
                score: score,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required DateTime date,
                required Map<String, dynamic> answers,
                required int score,
                Value<int> rowid = const Value.absent(),
              }) => QuestionnairesCompanion.insert(
                id: id,
                type: type,
                date: date,
                answers: answers,
                score: score,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuestionnairesTable, Questionnaire>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $QuestionnairesTable,
                    Questionnaire
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionnairesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionnairesTable,
      Questionnaire,
      $$QuestionnairesTableFilterComposer,
      $$QuestionnairesTableOrderingComposer,
      $$QuestionnairesTableAnnotationComposer,
      $$QuestionnairesTableCreateCompanionBuilder,
      $$QuestionnairesTableUpdateCompanionBuilder,
      (
        Questionnaire,
        BaseReferences<_$AppDatabase, $QuestionnairesTable, Questionnaire>,
      ),
      Questionnaire,
      PrefetchHooks Function()
    >;
typedef $$ShareLinksTableCreateCompanionBuilder = ShareLinksCompanion Function({
  required String token,
  required DateTime createdAt,
  required DateTime expiresAt,
  Value<bool> revoked,
  Value<int> rowid,
});
typedef $$ShareLinksTableUpdateCompanionBuilder = ShareLinksCompanion Function({
  Value<String> token,
  Value<DateTime> createdAt,
  Value<DateTime> expiresAt,
  Value<bool> revoked,
  Value<int> rowid,
});

class $$ShareLinksTableFilterComposer
    extends Composer<_$AppDatabase, $ShareLinksTable> {
  $$ShareLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get revoked => $composableBuilder(
    column: $table.revoked,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShareLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $ShareLinksTable> {
  $$ShareLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get revoked => $composableBuilder(
    column: $table.revoked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShareLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShareLinksTable> {
  $$ShareLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<bool> get revoked =>
      $composableBuilder(column: $table.revoked, builder: (column) => column);
}

class $$ShareLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShareLinksTable,
          ShareLink,
          $$ShareLinksTableFilterComposer,
          $$ShareLinksTableOrderingComposer,
          $$ShareLinksTableAnnotationComposer,
          $$ShareLinksTableCreateCompanionBuilder,
          $$ShareLinksTableUpdateCompanionBuilder,
          (
            ShareLink,
            BaseReferences<_$AppDatabase, $ShareLinksTable, ShareLink>,
          ),
          ShareLink,
          PrefetchHooks Function()
        > {
  $$ShareLinksTableTableManager(_$AppDatabase db, $ShareLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShareLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShareLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShareLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> token = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<bool> revoked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShareLinksCompanion(
                token: token,
                createdAt: createdAt,
                expiresAt: expiresAt,
                revoked: revoked,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String token,
                required DateTime createdAt,
                required DateTime expiresAt,
                Value<bool> revoked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShareLinksCompanion.insert(
                token: token,
                createdAt: createdAt,
                expiresAt: expiresAt,
                revoked: revoked,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShareLinksTable, ShareLink>(table),
                  BaseReferences<_$AppDatabase, $ShareLinksTable, ShareLink>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShareLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShareLinksTable,
      ShareLink,
      $$ShareLinksTableFilterComposer,
      $$ShareLinksTableOrderingComposer,
      $$ShareLinksTableAnnotationComposer,
      $$ShareLinksTableCreateCompanionBuilder,
      $$ShareLinksTableUpdateCompanionBuilder,
      (ShareLink, BaseReferences<_$AppDatabase, $ShareLinksTable, ShareLink>),
      ShareLink,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$BarometerReadingsTableCreateCompanionBuilder =
    BarometerReadingsCompanion Function({
      required DateTime at,
      required double hpa,
      Value<int> rowid,
    });
typedef $$BarometerReadingsTableUpdateCompanionBuilder =
    BarometerReadingsCompanion Function({
      Value<DateTime> at,
      Value<double> hpa,
      Value<int> rowid,
    });

class $$BarometerReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $BarometerReadingsTable> {
  $$BarometerReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hpa => $composableBuilder(
    column: $table.hpa,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BarometerReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $BarometerReadingsTable> {
  $$BarometerReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hpa => $composableBuilder(
    column: $table.hpa,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BarometerReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BarometerReadingsTable> {
  $$BarometerReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<double> get hpa =>
      $composableBuilder(column: $table.hpa, builder: (column) => column);
}

class $$BarometerReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BarometerReadingsTable,
          BarometerReading,
          $$BarometerReadingsTableFilterComposer,
          $$BarometerReadingsTableOrderingComposer,
          $$BarometerReadingsTableAnnotationComposer,
          $$BarometerReadingsTableCreateCompanionBuilder,
          $$BarometerReadingsTableUpdateCompanionBuilder,
          (
            BarometerReading,
            BaseReferences<
              _$AppDatabase,
              $BarometerReadingsTable,
              BarometerReading
            >,
          ),
          BarometerReading,
          PrefetchHooks Function()
        > {
  $$BarometerReadingsTableTableManager(
    _$AppDatabase db,
    $BarometerReadingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BarometerReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BarometerReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BarometerReadingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback: ({
            Value<DateTime> at = const Value.absent(),
            Value<double> hpa = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => BarometerReadingsCompanion(at: at, hpa: hpa, rowid: rowid),
          createCompanionCallback:
              ({
                required DateTime at,
                required double hpa,
                Value<int> rowid = const Value.absent(),
              }) => BarometerReadingsCompanion.insert(
                at: at,
                hpa: hpa,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BarometerReadingsTable, BarometerReading>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BarometerReadingsTable,
                    BarometerReading
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BarometerReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BarometerReadingsTable,
      BarometerReading,
      $$BarometerReadingsTableFilterComposer,
      $$BarometerReadingsTableOrderingComposer,
      $$BarometerReadingsTableAnnotationComposer,
      $$BarometerReadingsTableCreateCompanionBuilder,
      $$BarometerReadingsTableUpdateCompanionBuilder,
      (
        BarometerReading,
        BaseReferences<
          _$AppDatabase,
          $BarometerReadingsTable,
          BarometerReading
        >,
      ),
      BarometerReading,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AttacksTableTableManager get attacks =>
      $$AttacksTableTableManager(_db, _db.attacks);
  $$CheckinsTableTableManager get checkins =>
      $$CheckinsTableTableManager(_db, _db.checkins);
  $$MedicationEventsTableTableManager get medicationEvents =>
      $$MedicationEventsTableTableManager(_db, _db.medicationEvents);
  $$WeatherHoursTableTableManager get weatherHours =>
      $$WeatherHoursTableTableManager(_db, _db.weatherHours);
  $$EnvironmentDaysTableTableManager get environmentDays =>
      $$EnvironmentDaysTableTableManager(_db, _db.environmentDays);
  $$HealthSamplesTableTableManager get healthSamples =>
      $$HealthSamplesTableTableManager(_db, _db.healthSamples);
  $$FactorWeightsTableTableManager get factorWeights =>
      $$FactorWeightsTableTableManager(_db, _db.factorWeights);
  $$RiskDaysTableTableManager get riskDays =>
      $$RiskDaysTableTableManager(_db, _db.riskDays);
  $$ExperimentsTableTableManager get experiments =>
      $$ExperimentsTableTableManager(_db, _db.experiments);
  $$QuestionnairesTableTableManager get questionnaires =>
      $$QuestionnairesTableTableManager(_db, _db.questionnaires);
  $$ShareLinksTableTableManager get shareLinks =>
      $$ShareLinksTableTableManager(_db, _db.shareLinks);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$BarometerReadingsTableTableManager get barometerReadings =>
      $$BarometerReadingsTableTableManager(_db, _db.barometerReadings);
}
