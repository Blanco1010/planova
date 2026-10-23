// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects
    with TableInfo<$ProjectsTable, ProjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientMeta = const VerificationMeta('client');
  @override
  late final GeneratedColumn<String> client = GeneratedColumn<String>(
    'client',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    client,
    address,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('client')) {
      context.handle(
        _clientMeta,
        client.isAcceptableOrUnknown(data['client']!, _clientMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      client: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
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
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class ProjectRow extends DataClass implements Insertable<ProjectRow> {
  final int id;
  final String name;

  /// Cliente o propietario de la obra.
  final String? client;

  /// Dirección o ubicación de la obra.
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProjectRow({
    required this.id,
    required this.name,
    this.client,
    this.address,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || client != null) {
      map['client'] = Variable<String>(client);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      client: client == null && nullToAbsent
          ? const Value.absent()
          : Value(client),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProjectRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      client: serializer.fromJson<String?>(json['client']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'client': serializer.toJson<String?>(client),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProjectRow copyWith({
    int? id,
    String? name,
    Value<String?> client = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProjectRow(
    id: id ?? this.id,
    name: name ?? this.name,
    client: client.present ? client.value : this.client,
    address: address.present ? address.value : this.address,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProjectRow copyWithCompanion(ProjectsCompanion data) {
    return ProjectRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      client: data.client.present ? data.client.value : this.client,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('client: $client, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, client, address, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.client == this.client &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<ProjectRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> client;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.client = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.client = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ProjectRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? client,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (client != null) 'client': client,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? client,
    Value<String?>? address,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      client: client ?? this.client,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (client.present) {
      map['client'] = Variable<String>(client.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('client: $client, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRow> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String key;
  final String value;
  const AppSettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingRow copyWith({String? key, String? value}) =>
      AppSettingRow(key: key ?? this.key, value: value ?? this.value);
  AppSettingRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoomsTable extends Rooms with TableInfo<$RoomsTable, RoomRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wallHeightMetersMeta = const VerificationMeta(
    'wallHeightMeters',
  );
  @override
  late final GeneratedColumn<double> wallHeightMeters = GeneratedColumn<double>(
    'wall_height_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.4),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    wallHeightMeters,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('wall_height_meters')) {
      context.handle(
        _wallHeightMetersMeta,
        wallHeightMeters.isAcceptableOrUnknown(
          data['wall_height_meters']!,
          _wallHeightMetersMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoomRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      wallHeightMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wall_height_meters'],
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
  $RoomsTable createAlias(String alias) {
    return $RoomsTable(attachedDatabase, alias);
  }
}

class RoomRow extends DataClass implements Insertable<RoomRow> {
  final int id;
  final int projectId;
  final String name;

  /// Altura libre de las paredes, en metros.
  final double wallHeightMeters;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RoomRow({
    required this.id,
    required this.projectId,
    required this.name,
    required this.wallHeightMeters,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['name'] = Variable<String>(name);
    map['wall_height_meters'] = Variable<double>(wallHeightMeters);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoomsCompanion toCompanion(bool nullToAbsent) {
    return RoomsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      wallHeightMeters: Value(wallHeightMeters),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoomRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomRow(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      wallHeightMeters: serializer.fromJson<double>(json['wallHeightMeters']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'name': serializer.toJson<String>(name),
      'wallHeightMeters': serializer.toJson<double>(wallHeightMeters),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoomRow copyWith({
    int? id,
    int? projectId,
    String? name,
    double? wallHeightMeters,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RoomRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    wallHeightMeters: wallHeightMeters ?? this.wallHeightMeters,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoomRow copyWithCompanion(RoomsCompanion data) {
    return RoomRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      wallHeightMeters: data.wallHeightMeters.present
          ? data.wallHeightMeters.value
          : this.wallHeightMeters,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('wallHeightMeters: $wallHeightMeters, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, name, wallHeightMeters, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.wallHeightMeters == this.wallHeightMeters &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoomsCompanion extends UpdateCompanion<RoomRow> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> name;
  final Value<double> wallHeightMeters;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RoomsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.wallHeightMeters = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RoomsCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required String name,
    this.wallHeightMeters = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : projectId = Value(projectId),
       name = Value(name);
  static Insertable<RoomRow> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? name,
    Expression<double>? wallHeightMeters,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (wallHeightMeters != null) 'wall_height_meters': wallHeightMeters,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RoomsCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<String>? name,
    Value<double>? wallHeightMeters,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RoomsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      wallHeightMeters: wallHeightMeters ?? this.wallHeightMeters,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (wallHeightMeters.present) {
      map['wall_height_meters'] = Variable<double>(wallHeightMeters.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('wallHeightMeters: $wallHeightMeters, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RoomWallsTable extends RoomWalls
    with TableInfo<$RoomWallsTable, RoomWallRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomWallsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<int> roomId = GeneratedColumn<int>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rooms (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lengthMetersMeta = const VerificationMeta(
    'lengthMeters',
  );
  @override
  late final GeneratedColumn<double> lengthMeters = GeneratedColumn<double>(
    'length_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turnDegreesMeta = const VerificationMeta(
    'turnDegrees',
  );
  @override
  late final GeneratedColumn<double> turnDegrees = GeneratedColumn<double>(
    'turn_degrees',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roomId,
    position,
    lengthMeters,
    turnDegrees,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'room_walls';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomWallRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('length_meters')) {
      context.handle(
        _lengthMetersMeta,
        lengthMeters.isAcceptableOrUnknown(
          data['length_meters']!,
          _lengthMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lengthMetersMeta);
    }
    if (data.containsKey('turn_degrees')) {
      context.handle(
        _turnDegreesMeta,
        turnDegrees.isAcceptableOrUnknown(
          data['turn_degrees']!,
          _turnDegreesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoomWallRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomWallRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}room_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      lengthMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}length_meters'],
      )!,
      turnDegrees: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}turn_degrees'],
      )!,
    );
  }

  @override
  $RoomWallsTable createAlias(String alias) {
    return $RoomWallsTable(attachedDatabase, alias);
  }
}

class RoomWallRow extends DataClass implements Insertable<RoomWallRow> {
  final int id;
  final int roomId;

  /// Orden dentro del recorrido, empezando en 0.
  final int position;
  final double lengthMeters;

  /// Giro respecto a la pared anterior, en grados. La primera pared no gira.
  final double turnDegrees;
  const RoomWallRow({
    required this.id,
    required this.roomId,
    required this.position,
    required this.lengthMeters,
    required this.turnDegrees,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['room_id'] = Variable<int>(roomId);
    map['position'] = Variable<int>(position);
    map['length_meters'] = Variable<double>(lengthMeters);
    map['turn_degrees'] = Variable<double>(turnDegrees);
    return map;
  }

  RoomWallsCompanion toCompanion(bool nullToAbsent) {
    return RoomWallsCompanion(
      id: Value(id),
      roomId: Value(roomId),
      position: Value(position),
      lengthMeters: Value(lengthMeters),
      turnDegrees: Value(turnDegrees),
    );
  }

  factory RoomWallRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomWallRow(
      id: serializer.fromJson<int>(json['id']),
      roomId: serializer.fromJson<int>(json['roomId']),
      position: serializer.fromJson<int>(json['position']),
      lengthMeters: serializer.fromJson<double>(json['lengthMeters']),
      turnDegrees: serializer.fromJson<double>(json['turnDegrees']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'roomId': serializer.toJson<int>(roomId),
      'position': serializer.toJson<int>(position),
      'lengthMeters': serializer.toJson<double>(lengthMeters),
      'turnDegrees': serializer.toJson<double>(turnDegrees),
    };
  }

  RoomWallRow copyWith({
    int? id,
    int? roomId,
    int? position,
    double? lengthMeters,
    double? turnDegrees,
  }) => RoomWallRow(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    position: position ?? this.position,
    lengthMeters: lengthMeters ?? this.lengthMeters,
    turnDegrees: turnDegrees ?? this.turnDegrees,
  );
  RoomWallRow copyWithCompanion(RoomWallsCompanion data) {
    return RoomWallRow(
      id: data.id.present ? data.id.value : this.id,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      position: data.position.present ? data.position.value : this.position,
      lengthMeters: data.lengthMeters.present
          ? data.lengthMeters.value
          : this.lengthMeters,
      turnDegrees: data.turnDegrees.present
          ? data.turnDegrees.value
          : this.turnDegrees,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomWallRow(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('position: $position, ')
          ..write('lengthMeters: $lengthMeters, ')
          ..write('turnDegrees: $turnDegrees')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, roomId, position, lengthMeters, turnDegrees);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomWallRow &&
          other.id == this.id &&
          other.roomId == this.roomId &&
          other.position == this.position &&
          other.lengthMeters == this.lengthMeters &&
          other.turnDegrees == this.turnDegrees);
}

class RoomWallsCompanion extends UpdateCompanion<RoomWallRow> {
  final Value<int> id;
  final Value<int> roomId;
  final Value<int> position;
  final Value<double> lengthMeters;
  final Value<double> turnDegrees;
  const RoomWallsCompanion({
    this.id = const Value.absent(),
    this.roomId = const Value.absent(),
    this.position = const Value.absent(),
    this.lengthMeters = const Value.absent(),
    this.turnDegrees = const Value.absent(),
  });
  RoomWallsCompanion.insert({
    this.id = const Value.absent(),
    required int roomId,
    required int position,
    required double lengthMeters,
    this.turnDegrees = const Value.absent(),
  }) : roomId = Value(roomId),
       position = Value(position),
       lengthMeters = Value(lengthMeters);
  static Insertable<RoomWallRow> custom({
    Expression<int>? id,
    Expression<int>? roomId,
    Expression<int>? position,
    Expression<double>? lengthMeters,
    Expression<double>? turnDegrees,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomId != null) 'room_id': roomId,
      if (position != null) 'position': position,
      if (lengthMeters != null) 'length_meters': lengthMeters,
      if (turnDegrees != null) 'turn_degrees': turnDegrees,
    });
  }

  RoomWallsCompanion copyWith({
    Value<int>? id,
    Value<int>? roomId,
    Value<int>? position,
    Value<double>? lengthMeters,
    Value<double>? turnDegrees,
  }) {
    return RoomWallsCompanion(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      position: position ?? this.position,
      lengthMeters: lengthMeters ?? this.lengthMeters,
      turnDegrees: turnDegrees ?? this.turnDegrees,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<int>(roomId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (lengthMeters.present) {
      map['length_meters'] = Variable<double>(lengthMeters.value);
    }
    if (turnDegrees.present) {
      map['turn_degrees'] = Variable<double>(turnDegrees.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomWallsCompanion(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('position: $position, ')
          ..write('lengthMeters: $lengthMeters, ')
          ..write('turnDegrees: $turnDegrees')
          ..write(')'))
        .toString();
  }
}

class $RoomOpeningsTable extends RoomOpenings
    with TableInfo<$RoomOpeningsTable, RoomOpeningRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomOpeningsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wallIdMeta = const VerificationMeta('wallId');
  @override
  late final GeneratedColumn<int> wallId = GeneratedColumn<int>(
    'wall_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES room_walls (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<OpeningKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<OpeningKind>($RoomOpeningsTable.$converterkind);
  static const VerificationMeta _widthMetersMeta = const VerificationMeta(
    'widthMeters',
  );
  @override
  late final GeneratedColumn<double> widthMeters = GeneratedColumn<double>(
    'width_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMetersMeta = const VerificationMeta(
    'heightMeters',
  );
  @override
  late final GeneratedColumn<double> heightMeters = GeneratedColumn<double>(
    'height_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceFromStartMetersMeta =
      const VerificationMeta('distanceFromStartMeters');
  @override
  late final GeneratedColumn<double> distanceFromStartMeters =
      GeneratedColumn<double>(
        'distance_from_start_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wallId,
    kind,
    widthMeters,
    heightMeters,
    distanceFromStartMeters,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'room_openings';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomOpeningRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wall_id')) {
      context.handle(
        _wallIdMeta,
        wallId.isAcceptableOrUnknown(data['wall_id']!, _wallIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wallIdMeta);
    }
    if (data.containsKey('width_meters')) {
      context.handle(
        _widthMetersMeta,
        widthMeters.isAcceptableOrUnknown(
          data['width_meters']!,
          _widthMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_widthMetersMeta);
    }
    if (data.containsKey('height_meters')) {
      context.handle(
        _heightMetersMeta,
        heightMeters.isAcceptableOrUnknown(
          data['height_meters']!,
          _heightMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_heightMetersMeta);
    }
    if (data.containsKey('distance_from_start_meters')) {
      context.handle(
        _distanceFromStartMetersMeta,
        distanceFromStartMeters.isAcceptableOrUnknown(
          data['distance_from_start_meters']!,
          _distanceFromStartMetersMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoomOpeningRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomOpeningRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      wallId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wall_id'],
      )!,
      kind: $RoomOpeningsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      widthMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}width_meters'],
      )!,
      heightMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_meters'],
      )!,
      distanceFromStartMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_from_start_meters'],
      )!,
    );
  }

  @override
  $RoomOpeningsTable createAlias(String alias) {
    return $RoomOpeningsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OpeningKind, String, String> $converterkind =
      const EnumNameConverter<OpeningKind>(OpeningKind.values);
}

class RoomOpeningRow extends DataClass implements Insertable<RoomOpeningRow> {
  final int id;
  final int wallId;
  final OpeningKind kind;
  final double widthMeters;
  final double heightMeters;

  /// Distancia desde el inicio de la pared hasta el borde del vano.
  final double distanceFromStartMeters;
  const RoomOpeningRow({
    required this.id,
    required this.wallId,
    required this.kind,
    required this.widthMeters,
    required this.heightMeters,
    required this.distanceFromStartMeters,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wall_id'] = Variable<int>(wallId);
    {
      map['kind'] = Variable<String>(
        $RoomOpeningsTable.$converterkind.toSql(kind),
      );
    }
    map['width_meters'] = Variable<double>(widthMeters);
    map['height_meters'] = Variable<double>(heightMeters);
    map['distance_from_start_meters'] = Variable<double>(
      distanceFromStartMeters,
    );
    return map;
  }

  RoomOpeningsCompanion toCompanion(bool nullToAbsent) {
    return RoomOpeningsCompanion(
      id: Value(id),
      wallId: Value(wallId),
      kind: Value(kind),
      widthMeters: Value(widthMeters),
      heightMeters: Value(heightMeters),
      distanceFromStartMeters: Value(distanceFromStartMeters),
    );
  }

  factory RoomOpeningRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomOpeningRow(
      id: serializer.fromJson<int>(json['id']),
      wallId: serializer.fromJson<int>(json['wallId']),
      kind: $RoomOpeningsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      widthMeters: serializer.fromJson<double>(json['widthMeters']),
      heightMeters: serializer.fromJson<double>(json['heightMeters']),
      distanceFromStartMeters: serializer.fromJson<double>(
        json['distanceFromStartMeters'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wallId': serializer.toJson<int>(wallId),
      'kind': serializer.toJson<String>(
        $RoomOpeningsTable.$converterkind.toJson(kind),
      ),
      'widthMeters': serializer.toJson<double>(widthMeters),
      'heightMeters': serializer.toJson<double>(heightMeters),
      'distanceFromStartMeters': serializer.toJson<double>(
        distanceFromStartMeters,
      ),
    };
  }

  RoomOpeningRow copyWith({
    int? id,
    int? wallId,
    OpeningKind? kind,
    double? widthMeters,
    double? heightMeters,
    double? distanceFromStartMeters,
  }) => RoomOpeningRow(
    id: id ?? this.id,
    wallId: wallId ?? this.wallId,
    kind: kind ?? this.kind,
    widthMeters: widthMeters ?? this.widthMeters,
    heightMeters: heightMeters ?? this.heightMeters,
    distanceFromStartMeters:
        distanceFromStartMeters ?? this.distanceFromStartMeters,
  );
  RoomOpeningRow copyWithCompanion(RoomOpeningsCompanion data) {
    return RoomOpeningRow(
      id: data.id.present ? data.id.value : this.id,
      wallId: data.wallId.present ? data.wallId.value : this.wallId,
      kind: data.kind.present ? data.kind.value : this.kind,
      widthMeters: data.widthMeters.present
          ? data.widthMeters.value
          : this.widthMeters,
      heightMeters: data.heightMeters.present
          ? data.heightMeters.value
          : this.heightMeters,
      distanceFromStartMeters: data.distanceFromStartMeters.present
          ? data.distanceFromStartMeters.value
          : this.distanceFromStartMeters,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomOpeningRow(')
          ..write('id: $id, ')
          ..write('wallId: $wallId, ')
          ..write('kind: $kind, ')
          ..write('widthMeters: $widthMeters, ')
          ..write('heightMeters: $heightMeters, ')
          ..write('distanceFromStartMeters: $distanceFromStartMeters')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wallId,
    kind,
    widthMeters,
    heightMeters,
    distanceFromStartMeters,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomOpeningRow &&
          other.id == this.id &&
          other.wallId == this.wallId &&
          other.kind == this.kind &&
          other.widthMeters == this.widthMeters &&
          other.heightMeters == this.heightMeters &&
          other.distanceFromStartMeters == this.distanceFromStartMeters);
}

class RoomOpeningsCompanion extends UpdateCompanion<RoomOpeningRow> {
  final Value<int> id;
  final Value<int> wallId;
  final Value<OpeningKind> kind;
  final Value<double> widthMeters;
  final Value<double> heightMeters;
  final Value<double> distanceFromStartMeters;
  const RoomOpeningsCompanion({
    this.id = const Value.absent(),
    this.wallId = const Value.absent(),
    this.kind = const Value.absent(),
    this.widthMeters = const Value.absent(),
    this.heightMeters = const Value.absent(),
    this.distanceFromStartMeters = const Value.absent(),
  });
  RoomOpeningsCompanion.insert({
    this.id = const Value.absent(),
    required int wallId,
    required OpeningKind kind,
    required double widthMeters,
    required double heightMeters,
    this.distanceFromStartMeters = const Value.absent(),
  }) : wallId = Value(wallId),
       kind = Value(kind),
       widthMeters = Value(widthMeters),
       heightMeters = Value(heightMeters);
  static Insertable<RoomOpeningRow> custom({
    Expression<int>? id,
    Expression<int>? wallId,
    Expression<String>? kind,
    Expression<double>? widthMeters,
    Expression<double>? heightMeters,
    Expression<double>? distanceFromStartMeters,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wallId != null) 'wall_id': wallId,
      if (kind != null) 'kind': kind,
      if (widthMeters != null) 'width_meters': widthMeters,
      if (heightMeters != null) 'height_meters': heightMeters,
      if (distanceFromStartMeters != null)
        'distance_from_start_meters': distanceFromStartMeters,
    });
  }

  RoomOpeningsCompanion copyWith({
    Value<int>? id,
    Value<int>? wallId,
    Value<OpeningKind>? kind,
    Value<double>? widthMeters,
    Value<double>? heightMeters,
    Value<double>? distanceFromStartMeters,
  }) {
    return RoomOpeningsCompanion(
      id: id ?? this.id,
      wallId: wallId ?? this.wallId,
      kind: kind ?? this.kind,
      widthMeters: widthMeters ?? this.widthMeters,
      heightMeters: heightMeters ?? this.heightMeters,
      distanceFromStartMeters:
          distanceFromStartMeters ?? this.distanceFromStartMeters,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wallId.present) {
      map['wall_id'] = Variable<int>(wallId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $RoomOpeningsTable.$converterkind.toSql(kind.value),
      );
    }
    if (widthMeters.present) {
      map['width_meters'] = Variable<double>(widthMeters.value);
    }
    if (heightMeters.present) {
      map['height_meters'] = Variable<double>(heightMeters.value);
    }
    if (distanceFromStartMeters.present) {
      map['distance_from_start_meters'] = Variable<double>(
        distanceFromStartMeters.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomOpeningsCompanion(')
          ..write('id: $id, ')
          ..write('wallId: $wallId, ')
          ..write('kind: $kind, ')
          ..write('widthMeters: $widthMeters, ')
          ..write('heightMeters: $heightMeters, ')
          ..write('distanceFromStartMeters: $distanceFromStartMeters')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $RoomsTable rooms = $RoomsTable(this);
  late final $RoomWallsTable roomWalls = $RoomWallsTable(this);
  late final $RoomOpeningsTable roomOpenings = $RoomOpeningsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    appSettings,
    rooms,
    roomWalls,
    roomOpenings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rooms', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rooms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('room_walls', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'room_walls',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('room_openings', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> client,
  Value<String?> address,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> client,
  Value<String?> address,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, ProjectRow> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoomsTable, List<RoomRow>> _roomsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rooms,
    aliasName: 'projects__id__rooms__project_id',
  );

  $$RoomsTableProcessedTableManager get roomsRefs {
    final manager = $$RoomsTableTableManager(
      $_db,
      $_db.rooms,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_roomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get client => $composableBuilder(
    column: $table.client,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  Expression<bool> roomsRefs(
    Expression<bool> Function($$RoomsTableFilterComposer f) f,
  ) {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableFilterComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get client => $composableBuilder(
    column: $table.client,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get client =>
      $composableBuilder(column: $table.client, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> roomsRefs<T extends Object>(
    Expression<T> Function($$RoomsTableAnnotationComposer a) f,
  ) {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          ProjectRow,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (ProjectRow, $$ProjectsTableReferences),
          ProjectRow,
          PrefetchHooks Function({bool roomsRefs})
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> client = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                client: client,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> client = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                client: client,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProjectsTable, ProjectRow>(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({roomsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (roomsRefs) db.rooms],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (roomsRefs)
                    await $_getPrefetchedData<
                      ProjectRow,
                      $ProjectsTable,
                      RoomRow
                    >(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences
                          ._roomsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProjectsTableReferences(db, table, p0).roomsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.projectId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      ProjectRow,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (ProjectRow, $$ProjectsTableReferences),
      ProjectRow,
      PrefetchHooks Function({bool roomsRefs})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
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
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
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
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
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
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
          ),
          AppSettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSettingRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTable,
                    AppSettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
      ),
      AppSettingRow,
      PrefetchHooks Function()
    >;
typedef $$RoomsTableCreateCompanionBuilder = RoomsCompanion Function({
  Value<int> id,
  required int projectId,
  required String name,
  Value<double> wallHeightMeters,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$RoomsTableUpdateCompanionBuilder = RoomsCompanion Function({
  Value<int> id,
  Value<int> projectId,
  Value<String> name,
  Value<double> wallHeightMeters,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$RoomsTableReferences
    extends BaseReferences<_$AppDatabase, $RoomsTable, RoomRow> {
  $$RoomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('rooms__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RoomWallsTable, List<RoomWallRow>>
  _roomWallsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.roomWalls,
    aliasName: 'rooms__id__room_walls__room_id',
  );

  $$RoomWallsTableProcessedTableManager get roomWallsRefs {
    final manager = $$RoomWallsTableTableManager(
      $_db,
      $_db.roomWalls,
    ).filter((f) => f.roomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_roomWallsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoomsTableFilterComposer extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wallHeightMeters => $composableBuilder(
    column: $table.wallHeightMeters,
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

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> roomWallsRefs(
    Expression<bool> Function($$RoomWallsTableFilterComposer f) f,
  ) {
    final $$RoomWallsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roomWalls,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomWallsTableFilterComposer(
            $db: $db,
            $table: $db.roomWalls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wallHeightMeters => $composableBuilder(
    column: $table.wallHeightMeters,
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

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get wallHeightMeters => $composableBuilder(
    column: $table.wallHeightMeters,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> roomWallsRefs<T extends Object>(
    Expression<T> Function($$RoomWallsTableAnnotationComposer a) f,
  ) {
    final $$RoomWallsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roomWalls,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomWallsTableAnnotationComposer(
            $db: $db,
            $table: $db.roomWalls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomsTable,
          RoomRow,
          $$RoomsTableFilterComposer,
          $$RoomsTableOrderingComposer,
          $$RoomsTableAnnotationComposer,
          $$RoomsTableCreateCompanionBuilder,
          $$RoomsTableUpdateCompanionBuilder,
          (RoomRow, $$RoomsTableReferences),
          RoomRow,
          PrefetchHooks Function({bool projectId, bool roomWallsRefs})
        > {
  $$RoomsTableTableManager(_$AppDatabase db, $RoomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> wallHeightMeters = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RoomsCompanion(
                id: id,
                projectId: projectId,
                name: name,
                wallHeightMeters: wallHeightMeters,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required String name,
                Value<double> wallHeightMeters = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RoomsCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                wallHeightMeters: wallHeightMeters,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoomsTable, RoomRow>(table),
                  $$RoomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false, roomWallsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (roomWallsRefs) db.roomWalls],
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
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$RoomsTableReferences._projectIdTable(
                          db,
                        ),
                        referencedColumn: $$RoomsTableReferences
                            ._projectIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (roomWallsRefs)
                    await $_getPrefetchedData<
                      RoomRow,
                      $RoomsTable,
                      RoomWallRow
                    >(
                      currentTable: table,
                      referencedTable: $$RoomsTableReferences
                          ._roomWallsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RoomsTableReferences(db, table, p0).roomWallsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.roomId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomsTable,
      RoomRow,
      $$RoomsTableFilterComposer,
      $$RoomsTableOrderingComposer,
      $$RoomsTableAnnotationComposer,
      $$RoomsTableCreateCompanionBuilder,
      $$RoomsTableUpdateCompanionBuilder,
      (RoomRow, $$RoomsTableReferences),
      RoomRow,
      PrefetchHooks Function({bool projectId, bool roomWallsRefs})
    >;
typedef $$RoomWallsTableCreateCompanionBuilder = RoomWallsCompanion Function({
  Value<int> id,
  required int roomId,
  required int position,
  required double lengthMeters,
  Value<double> turnDegrees,
});
typedef $$RoomWallsTableUpdateCompanionBuilder = RoomWallsCompanion Function({
  Value<int> id,
  Value<int> roomId,
  Value<int> position,
  Value<double> lengthMeters,
  Value<double> turnDegrees,
});

final class $$RoomWallsTableReferences
    extends BaseReferences<_$AppDatabase, $RoomWallsTable, RoomWallRow> {
  $$RoomWallsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoomsTable _roomIdTable(_$AppDatabase db) =>
      db.rooms.createAlias('room_walls__room_id__rooms__id');

  $$RoomsTableProcessedTableManager get roomId {
    final $_column = $_itemColumn<int>('room_id')!;

    final manager = $$RoomsTableTableManager(
      $_db,
      $_db.rooms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RoomOpeningsTable, List<RoomOpeningRow>>
  _roomOpeningsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.roomOpenings,
    aliasName: 'room_walls__id__room_openings__wall_id',
  );

  $$RoomOpeningsTableProcessedTableManager get roomOpeningsRefs {
    final manager = $$RoomOpeningsTableTableManager(
      $_db,
      $_db.roomOpenings,
    ).filter((f) => f.wallId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_roomOpeningsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoomWallsTableFilterComposer
    extends Composer<_$AppDatabase, $RoomWallsTable> {
  $$RoomWallsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lengthMeters => $composableBuilder(
    column: $table.lengthMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get turnDegrees => $composableBuilder(
    column: $table.turnDegrees,
    builder: (column) => ColumnFilters(column),
  );

  $$RoomsTableFilterComposer get roomId {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableFilterComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> roomOpeningsRefs(
    Expression<bool> Function($$RoomOpeningsTableFilterComposer f) f,
  ) {
    final $$RoomOpeningsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roomOpenings,
      getReferencedColumn: (t) => t.wallId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomOpeningsTableFilterComposer(
            $db: $db,
            $table: $db.roomOpenings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoomWallsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomWallsTable> {
  $$RoomWallsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lengthMeters => $composableBuilder(
    column: $table.lengthMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get turnDegrees => $composableBuilder(
    column: $table.turnDegrees,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoomsTableOrderingComposer get roomId {
    final $$RoomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableOrderingComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoomWallsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomWallsTable> {
  $$RoomWallsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<double> get lengthMeters => $composableBuilder(
    column: $table.lengthMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get turnDegrees => $composableBuilder(
    column: $table.turnDegrees,
    builder: (column) => column,
  );

  $$RoomsTableAnnotationComposer get roomId {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> roomOpeningsRefs<T extends Object>(
    Expression<T> Function($$RoomOpeningsTableAnnotationComposer a) f,
  ) {
    final $$RoomOpeningsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.roomOpenings,
      getReferencedColumn: (t) => t.wallId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomOpeningsTableAnnotationComposer(
            $db: $db,
            $table: $db.roomOpenings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoomWallsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomWallsTable,
          RoomWallRow,
          $$RoomWallsTableFilterComposer,
          $$RoomWallsTableOrderingComposer,
          $$RoomWallsTableAnnotationComposer,
          $$RoomWallsTableCreateCompanionBuilder,
          $$RoomWallsTableUpdateCompanionBuilder,
          (RoomWallRow, $$RoomWallsTableReferences),
          RoomWallRow,
          PrefetchHooks Function({bool roomId, bool roomOpeningsRefs})
        > {
  $$RoomWallsTableTableManager(_$AppDatabase db, $RoomWallsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomWallsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomWallsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomWallsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> roomId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<double> lengthMeters = const Value.absent(),
                Value<double> turnDegrees = const Value.absent(),
              }) => RoomWallsCompanion(
                id: id,
                roomId: roomId,
                position: position,
                lengthMeters: lengthMeters,
                turnDegrees: turnDegrees,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int roomId,
                required int position,
                required double lengthMeters,
                Value<double> turnDegrees = const Value.absent(),
              }) => RoomWallsCompanion.insert(
                id: id,
                roomId: roomId,
                position: position,
                lengthMeters: lengthMeters,
                turnDegrees: turnDegrees,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoomWallsTable, RoomWallRow>(table),
                  $$RoomWallsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({roomId = false, roomOpeningsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (roomOpeningsRefs) db.roomOpenings],
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
                    if (roomId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.roomId,
                        referencedTable: $$RoomWallsTableReferences
                            ._roomIdTable(db),
                        referencedColumn: $$RoomWallsTableReferences
                            ._roomIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (roomOpeningsRefs)
                    await $_getPrefetchedData<
                      RoomWallRow,
                      $RoomWallsTable,
                      RoomOpeningRow
                    >(
                      currentTable: table,
                      referencedTable: $$RoomWallsTableReferences
                          ._roomOpeningsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RoomWallsTableReferences(
                            db,
                            table,
                            p0,
                          ).roomOpeningsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.wallId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoomWallsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomWallsTable,
      RoomWallRow,
      $$RoomWallsTableFilterComposer,
      $$RoomWallsTableOrderingComposer,
      $$RoomWallsTableAnnotationComposer,
      $$RoomWallsTableCreateCompanionBuilder,
      $$RoomWallsTableUpdateCompanionBuilder,
      (RoomWallRow, $$RoomWallsTableReferences),
      RoomWallRow,
      PrefetchHooks Function({bool roomId, bool roomOpeningsRefs})
    >;
typedef $$RoomOpeningsTableCreateCompanionBuilder =
    RoomOpeningsCompanion Function({
      Value<int> id,
      required int wallId,
      required OpeningKind kind,
      required double widthMeters,
      required double heightMeters,
      Value<double> distanceFromStartMeters,
    });
typedef $$RoomOpeningsTableUpdateCompanionBuilder =
    RoomOpeningsCompanion Function({
      Value<int> id,
      Value<int> wallId,
      Value<OpeningKind> kind,
      Value<double> widthMeters,
      Value<double> heightMeters,
      Value<double> distanceFromStartMeters,
    });

final class $$RoomOpeningsTableReferences
    extends BaseReferences<_$AppDatabase, $RoomOpeningsTable, RoomOpeningRow> {
  $$RoomOpeningsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoomWallsTable _wallIdTable(_$AppDatabase db) =>
      db.roomWalls.createAlias('room_openings__wall_id__room_walls__id');

  $$RoomWallsTableProcessedTableManager get wallId {
    final $_column = $_itemColumn<int>('wall_id')!;

    final manager = $$RoomWallsTableTableManager(
      $_db,
      $_db.roomWalls,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wallIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoomOpeningsTableFilterComposer
    extends Composer<_$AppDatabase, $RoomOpeningsTable> {
  $$RoomOpeningsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OpeningKind, OpeningKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get widthMeters => $composableBuilder(
    column: $table.widthMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightMeters => $composableBuilder(
    column: $table.heightMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceFromStartMeters => $composableBuilder(
    column: $table.distanceFromStartMeters,
    builder: (column) => ColumnFilters(column),
  );

  $$RoomWallsTableFilterComposer get wallId {
    final $$RoomWallsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wallId,
      referencedTable: $db.roomWalls,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomWallsTableFilterComposer(
            $db: $db,
            $table: $db.roomWalls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoomOpeningsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomOpeningsTable> {
  $$RoomOpeningsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get widthMeters => $composableBuilder(
    column: $table.widthMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightMeters => $composableBuilder(
    column: $table.heightMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceFromStartMeters => $composableBuilder(
    column: $table.distanceFromStartMeters,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoomWallsTableOrderingComposer get wallId {
    final $$RoomWallsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wallId,
      referencedTable: $db.roomWalls,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomWallsTableOrderingComposer(
            $db: $db,
            $table: $db.roomWalls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoomOpeningsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomOpeningsTable> {
  $$RoomOpeningsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OpeningKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get widthMeters => $composableBuilder(
    column: $table.widthMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heightMeters => $composableBuilder(
    column: $table.heightMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceFromStartMeters => $composableBuilder(
    column: $table.distanceFromStartMeters,
    builder: (column) => column,
  );

  $$RoomWallsTableAnnotationComposer get wallId {
    final $$RoomWallsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wallId,
      referencedTable: $db.roomWalls,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomWallsTableAnnotationComposer(
            $db: $db,
            $table: $db.roomWalls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoomOpeningsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomOpeningsTable,
          RoomOpeningRow,
          $$RoomOpeningsTableFilterComposer,
          $$RoomOpeningsTableOrderingComposer,
          $$RoomOpeningsTableAnnotationComposer,
          $$RoomOpeningsTableCreateCompanionBuilder,
          $$RoomOpeningsTableUpdateCompanionBuilder,
          (RoomOpeningRow, $$RoomOpeningsTableReferences),
          RoomOpeningRow,
          PrefetchHooks Function({bool wallId})
        > {
  $$RoomOpeningsTableTableManager(_$AppDatabase db, $RoomOpeningsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomOpeningsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomOpeningsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomOpeningsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wallId = const Value.absent(),
                Value<OpeningKind> kind = const Value.absent(),
                Value<double> widthMeters = const Value.absent(),
                Value<double> heightMeters = const Value.absent(),
                Value<double> distanceFromStartMeters = const Value.absent(),
              }) => RoomOpeningsCompanion(
                id: id,
                wallId: wallId,
                kind: kind,
                widthMeters: widthMeters,
                heightMeters: heightMeters,
                distanceFromStartMeters: distanceFromStartMeters,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int wallId,
                required OpeningKind kind,
                required double widthMeters,
                required double heightMeters,
                Value<double> distanceFromStartMeters = const Value.absent(),
              }) => RoomOpeningsCompanion.insert(
                id: id,
                wallId: wallId,
                kind: kind,
                widthMeters: widthMeters,
                heightMeters: heightMeters,
                distanceFromStartMeters: distanceFromStartMeters,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoomOpeningsTable, RoomOpeningRow>(table),
                  $$RoomOpeningsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wallId = false}) {
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
                    if (wallId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wallId,
                        referencedTable: $$RoomOpeningsTableReferences
                            ._wallIdTable(db),
                        referencedColumn: $$RoomOpeningsTableReferences
                            ._wallIdTable(db)
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

typedef $$RoomOpeningsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomOpeningsTable,
      RoomOpeningRow,
      $$RoomOpeningsTableFilterComposer,
      $$RoomOpeningsTableOrderingComposer,
      $$RoomOpeningsTableAnnotationComposer,
      $$RoomOpeningsTableCreateCompanionBuilder,
      $$RoomOpeningsTableUpdateCompanionBuilder,
      (RoomOpeningRow, $$RoomOpeningsTableReferences),
      RoomOpeningRow,
      PrefetchHooks Function({bool wallId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db, _db.rooms);
  $$RoomWallsTableTableManager get roomWalls =>
      $$RoomWallsTableTableManager(_db, _db.roomWalls);
  $$RoomOpeningsTableTableManager get roomOpenings =>
      $$RoomOpeningsTableTableManager(_db, _db.roomOpenings);
}
