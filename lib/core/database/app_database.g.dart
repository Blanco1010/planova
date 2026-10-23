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

class $ProjectMaterialSettingsTable extends ProjectMaterialSettings
    with TableInfo<$ProjectMaterialSettingsTable, MaterialSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectMaterialSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _blockLengthMetersMeta = const VerificationMeta(
    'blockLengthMeters',
  );
  @override
  late final GeneratedColumn<double> blockLengthMeters =
      GeneratedColumn<double>(
        'block_length_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.39),
      );
  static const VerificationMeta _blockHeightMetersMeta = const VerificationMeta(
    'blockHeightMeters',
  );
  @override
  late final GeneratedColumn<double> blockHeightMeters =
      GeneratedColumn<double>(
        'block_height_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.19),
      );
  static const VerificationMeta _jointMetersMeta = const VerificationMeta(
    'jointMeters',
  );
  @override
  late final GeneratedColumn<double> jointMeters = GeneratedColumn<double>(
    'joint_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.015),
  );
  static const VerificationMeta _wallThicknessMetersMeta =
      const VerificationMeta('wallThicknessMeters');
  @override
  late final GeneratedColumn<double> wallThicknessMeters =
      GeneratedColumn<double>(
        'wall_thickness_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.12),
      );
  static const VerificationMeta _masonryWastePercentMeta =
      const VerificationMeta('masonryWastePercent');
  @override
  late final GeneratedColumn<double> masonryWastePercent =
      GeneratedColumn<double>(
        'masonry_waste_percent',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(5),
      );
  static const VerificationMeta _cementBagsPerCubicMeterMeta =
      const VerificationMeta('cementBagsPerCubicMeter');
  @override
  late final GeneratedColumn<double> cementBagsPerCubicMeter =
      GeneratedColumn<double>(
        'cement_bags_per_cubic_meter',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(7.5),
      );
  static const VerificationMeta _sandCubicMetersPerCubicMeterMeta =
      const VerificationMeta('sandCubicMetersPerCubicMeter');
  @override
  late final GeneratedColumn<double> sandCubicMetersPerCubicMeter =
      GeneratedColumn<double>(
        'sand_cubic_meters_per_cubic_meter',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1.1),
      );
  static const VerificationMeta _paintCoatsMeta = const VerificationMeta(
    'paintCoats',
  );
  @override
  late final GeneratedColumn<int> paintCoats = GeneratedColumn<int>(
    'paint_coats',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _squareMetersPerLiterMeta =
      const VerificationMeta('squareMetersPerLiter');
  @override
  late final GeneratedColumn<double> squareMetersPerLiter =
      GeneratedColumn<double>(
        'square_meters_per_liter',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(10),
      );
  static const VerificationMeta _paintWastePercentMeta = const VerificationMeta(
    'paintWastePercent',
  );
  @override
  late final GeneratedColumn<double> paintWastePercent =
      GeneratedColumn<double>(
        'paint_waste_percent',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(5),
      );
  static const VerificationMeta _includeCeilingMeta = const VerificationMeta(
    'includeCeiling',
  );
  @override
  late final GeneratedColumn<bool> includeCeiling = GeneratedColumn<bool>(
    'include_ceiling',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("include_ceiling" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tileLengthMetersMeta = const VerificationMeta(
    'tileLengthMeters',
  );
  @override
  late final GeneratedColumn<double> tileLengthMeters = GeneratedColumn<double>(
    'tile_length_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.33),
  );
  static const VerificationMeta _tileWidthMetersMeta = const VerificationMeta(
    'tileWidthMeters',
  );
  @override
  late final GeneratedColumn<double> tileWidthMeters = GeneratedColumn<double>(
    'tile_width_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.33),
  );
  static const VerificationMeta _floorWastePercentMeta = const VerificationMeta(
    'floorWastePercent',
  );
  @override
  late final GeneratedColumn<double> floorWastePercent =
      GeneratedColumn<double>(
        'floor_waste_percent',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(10),
      );
  static const VerificationMeta _adhesiveKilogramsPerSquareMeterMeta =
      const VerificationMeta('adhesiveKilogramsPerSquareMeter');
  @override
  late final GeneratedColumn<double> adhesiveKilogramsPerSquareMeter =
      GeneratedColumn<double>(
        'adhesive_kilograms_per_square_meter',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(5),
      );
  @override
  List<GeneratedColumn> get $columns => [
    projectId,
    blockLengthMeters,
    blockHeightMeters,
    jointMeters,
    wallThicknessMeters,
    masonryWastePercent,
    cementBagsPerCubicMeter,
    sandCubicMetersPerCubicMeter,
    paintCoats,
    squareMetersPerLiter,
    paintWastePercent,
    includeCeiling,
    tileLengthMeters,
    tileWidthMeters,
    floorWastePercent,
    adhesiveKilogramsPerSquareMeter,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_material_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaterialSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('block_length_meters')) {
      context.handle(
        _blockLengthMetersMeta,
        blockLengthMeters.isAcceptableOrUnknown(
          data['block_length_meters']!,
          _blockLengthMetersMeta,
        ),
      );
    }
    if (data.containsKey('block_height_meters')) {
      context.handle(
        _blockHeightMetersMeta,
        blockHeightMeters.isAcceptableOrUnknown(
          data['block_height_meters']!,
          _blockHeightMetersMeta,
        ),
      );
    }
    if (data.containsKey('joint_meters')) {
      context.handle(
        _jointMetersMeta,
        jointMeters.isAcceptableOrUnknown(
          data['joint_meters']!,
          _jointMetersMeta,
        ),
      );
    }
    if (data.containsKey('wall_thickness_meters')) {
      context.handle(
        _wallThicknessMetersMeta,
        wallThicknessMeters.isAcceptableOrUnknown(
          data['wall_thickness_meters']!,
          _wallThicknessMetersMeta,
        ),
      );
    }
    if (data.containsKey('masonry_waste_percent')) {
      context.handle(
        _masonryWastePercentMeta,
        masonryWastePercent.isAcceptableOrUnknown(
          data['masonry_waste_percent']!,
          _masonryWastePercentMeta,
        ),
      );
    }
    if (data.containsKey('cement_bags_per_cubic_meter')) {
      context.handle(
        _cementBagsPerCubicMeterMeta,
        cementBagsPerCubicMeter.isAcceptableOrUnknown(
          data['cement_bags_per_cubic_meter']!,
          _cementBagsPerCubicMeterMeta,
        ),
      );
    }
    if (data.containsKey('sand_cubic_meters_per_cubic_meter')) {
      context.handle(
        _sandCubicMetersPerCubicMeterMeta,
        sandCubicMetersPerCubicMeter.isAcceptableOrUnknown(
          data['sand_cubic_meters_per_cubic_meter']!,
          _sandCubicMetersPerCubicMeterMeta,
        ),
      );
    }
    if (data.containsKey('paint_coats')) {
      context.handle(
        _paintCoatsMeta,
        paintCoats.isAcceptableOrUnknown(data['paint_coats']!, _paintCoatsMeta),
      );
    }
    if (data.containsKey('square_meters_per_liter')) {
      context.handle(
        _squareMetersPerLiterMeta,
        squareMetersPerLiter.isAcceptableOrUnknown(
          data['square_meters_per_liter']!,
          _squareMetersPerLiterMeta,
        ),
      );
    }
    if (data.containsKey('paint_waste_percent')) {
      context.handle(
        _paintWastePercentMeta,
        paintWastePercent.isAcceptableOrUnknown(
          data['paint_waste_percent']!,
          _paintWastePercentMeta,
        ),
      );
    }
    if (data.containsKey('include_ceiling')) {
      context.handle(
        _includeCeilingMeta,
        includeCeiling.isAcceptableOrUnknown(
          data['include_ceiling']!,
          _includeCeilingMeta,
        ),
      );
    }
    if (data.containsKey('tile_length_meters')) {
      context.handle(
        _tileLengthMetersMeta,
        tileLengthMeters.isAcceptableOrUnknown(
          data['tile_length_meters']!,
          _tileLengthMetersMeta,
        ),
      );
    }
    if (data.containsKey('tile_width_meters')) {
      context.handle(
        _tileWidthMetersMeta,
        tileWidthMeters.isAcceptableOrUnknown(
          data['tile_width_meters']!,
          _tileWidthMetersMeta,
        ),
      );
    }
    if (data.containsKey('floor_waste_percent')) {
      context.handle(
        _floorWastePercentMeta,
        floorWastePercent.isAcceptableOrUnknown(
          data['floor_waste_percent']!,
          _floorWastePercentMeta,
        ),
      );
    }
    if (data.containsKey('adhesive_kilograms_per_square_meter')) {
      context.handle(
        _adhesiveKilogramsPerSquareMeterMeta,
        adhesiveKilogramsPerSquareMeter.isAcceptableOrUnknown(
          data['adhesive_kilograms_per_square_meter']!,
          _adhesiveKilogramsPerSquareMeterMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {projectId};
  @override
  MaterialSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaterialSettingsRow(
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      blockLengthMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}block_length_meters'],
      )!,
      blockHeightMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}block_height_meters'],
      )!,
      jointMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}joint_meters'],
      )!,
      wallThicknessMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wall_thickness_meters'],
      )!,
      masonryWastePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}masonry_waste_percent'],
      )!,
      cementBagsPerCubicMeter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cement_bags_per_cubic_meter'],
      )!,
      sandCubicMetersPerCubicMeter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sand_cubic_meters_per_cubic_meter'],
      )!,
      paintCoats: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paint_coats'],
      )!,
      squareMetersPerLiter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}square_meters_per_liter'],
      )!,
      paintWastePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paint_waste_percent'],
      )!,
      includeCeiling: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}include_ceiling'],
      )!,
      tileLengthMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tile_length_meters'],
      )!,
      tileWidthMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tile_width_meters'],
      )!,
      floorWastePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}floor_waste_percent'],
      )!,
      adhesiveKilogramsPerSquareMeter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}adhesive_kilograms_per_square_meter'],
      )!,
    );
  }

  @override
  $ProjectMaterialSettingsTable createAlias(String alias) {
    return $ProjectMaterialSettingsTable(attachedDatabase, alias);
  }
}

class MaterialSettingsRow extends DataClass
    implements Insertable<MaterialSettingsRow> {
  final int projectId;
  final double blockLengthMeters;
  final double blockHeightMeters;
  final double jointMeters;
  final double wallThicknessMeters;
  final double masonryWastePercent;
  final double cementBagsPerCubicMeter;
  final double sandCubicMetersPerCubicMeter;
  final int paintCoats;
  final double squareMetersPerLiter;
  final double paintWastePercent;
  final bool includeCeiling;
  final double tileLengthMeters;
  final double tileWidthMeters;
  final double floorWastePercent;
  final double adhesiveKilogramsPerSquareMeter;
  const MaterialSettingsRow({
    required this.projectId,
    required this.blockLengthMeters,
    required this.blockHeightMeters,
    required this.jointMeters,
    required this.wallThicknessMeters,
    required this.masonryWastePercent,
    required this.cementBagsPerCubicMeter,
    required this.sandCubicMetersPerCubicMeter,
    required this.paintCoats,
    required this.squareMetersPerLiter,
    required this.paintWastePercent,
    required this.includeCeiling,
    required this.tileLengthMeters,
    required this.tileWidthMeters,
    required this.floorWastePercent,
    required this.adhesiveKilogramsPerSquareMeter,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['project_id'] = Variable<int>(projectId);
    map['block_length_meters'] = Variable<double>(blockLengthMeters);
    map['block_height_meters'] = Variable<double>(blockHeightMeters);
    map['joint_meters'] = Variable<double>(jointMeters);
    map['wall_thickness_meters'] = Variable<double>(wallThicknessMeters);
    map['masonry_waste_percent'] = Variable<double>(masonryWastePercent);
    map['cement_bags_per_cubic_meter'] = Variable<double>(
      cementBagsPerCubicMeter,
    );
    map['sand_cubic_meters_per_cubic_meter'] = Variable<double>(
      sandCubicMetersPerCubicMeter,
    );
    map['paint_coats'] = Variable<int>(paintCoats);
    map['square_meters_per_liter'] = Variable<double>(squareMetersPerLiter);
    map['paint_waste_percent'] = Variable<double>(paintWastePercent);
    map['include_ceiling'] = Variable<bool>(includeCeiling);
    map['tile_length_meters'] = Variable<double>(tileLengthMeters);
    map['tile_width_meters'] = Variable<double>(tileWidthMeters);
    map['floor_waste_percent'] = Variable<double>(floorWastePercent);
    map['adhesive_kilograms_per_square_meter'] = Variable<double>(
      adhesiveKilogramsPerSquareMeter,
    );
    return map;
  }

  ProjectMaterialSettingsCompanion toCompanion(bool nullToAbsent) {
    return ProjectMaterialSettingsCompanion(
      projectId: Value(projectId),
      blockLengthMeters: Value(blockLengthMeters),
      blockHeightMeters: Value(blockHeightMeters),
      jointMeters: Value(jointMeters),
      wallThicknessMeters: Value(wallThicknessMeters),
      masonryWastePercent: Value(masonryWastePercent),
      cementBagsPerCubicMeter: Value(cementBagsPerCubicMeter),
      sandCubicMetersPerCubicMeter: Value(sandCubicMetersPerCubicMeter),
      paintCoats: Value(paintCoats),
      squareMetersPerLiter: Value(squareMetersPerLiter),
      paintWastePercent: Value(paintWastePercent),
      includeCeiling: Value(includeCeiling),
      tileLengthMeters: Value(tileLengthMeters),
      tileWidthMeters: Value(tileWidthMeters),
      floorWastePercent: Value(floorWastePercent),
      adhesiveKilogramsPerSquareMeter: Value(adhesiveKilogramsPerSquareMeter),
    );
  }

  factory MaterialSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaterialSettingsRow(
      projectId: serializer.fromJson<int>(json['projectId']),
      blockLengthMeters: serializer.fromJson<double>(json['blockLengthMeters']),
      blockHeightMeters: serializer.fromJson<double>(json['blockHeightMeters']),
      jointMeters: serializer.fromJson<double>(json['jointMeters']),
      wallThicknessMeters: serializer.fromJson<double>(
        json['wallThicknessMeters'],
      ),
      masonryWastePercent: serializer.fromJson<double>(
        json['masonryWastePercent'],
      ),
      cementBagsPerCubicMeter: serializer.fromJson<double>(
        json['cementBagsPerCubicMeter'],
      ),
      sandCubicMetersPerCubicMeter: serializer.fromJson<double>(
        json['sandCubicMetersPerCubicMeter'],
      ),
      paintCoats: serializer.fromJson<int>(json['paintCoats']),
      squareMetersPerLiter: serializer.fromJson<double>(
        json['squareMetersPerLiter'],
      ),
      paintWastePercent: serializer.fromJson<double>(json['paintWastePercent']),
      includeCeiling: serializer.fromJson<bool>(json['includeCeiling']),
      tileLengthMeters: serializer.fromJson<double>(json['tileLengthMeters']),
      tileWidthMeters: serializer.fromJson<double>(json['tileWidthMeters']),
      floorWastePercent: serializer.fromJson<double>(json['floorWastePercent']),
      adhesiveKilogramsPerSquareMeter: serializer.fromJson<double>(
        json['adhesiveKilogramsPerSquareMeter'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'projectId': serializer.toJson<int>(projectId),
      'blockLengthMeters': serializer.toJson<double>(blockLengthMeters),
      'blockHeightMeters': serializer.toJson<double>(blockHeightMeters),
      'jointMeters': serializer.toJson<double>(jointMeters),
      'wallThicknessMeters': serializer.toJson<double>(wallThicknessMeters),
      'masonryWastePercent': serializer.toJson<double>(masonryWastePercent),
      'cementBagsPerCubicMeter': serializer.toJson<double>(
        cementBagsPerCubicMeter,
      ),
      'sandCubicMetersPerCubicMeter': serializer.toJson<double>(
        sandCubicMetersPerCubicMeter,
      ),
      'paintCoats': serializer.toJson<int>(paintCoats),
      'squareMetersPerLiter': serializer.toJson<double>(squareMetersPerLiter),
      'paintWastePercent': serializer.toJson<double>(paintWastePercent),
      'includeCeiling': serializer.toJson<bool>(includeCeiling),
      'tileLengthMeters': serializer.toJson<double>(tileLengthMeters),
      'tileWidthMeters': serializer.toJson<double>(tileWidthMeters),
      'floorWastePercent': serializer.toJson<double>(floorWastePercent),
      'adhesiveKilogramsPerSquareMeter': serializer.toJson<double>(
        adhesiveKilogramsPerSquareMeter,
      ),
    };
  }

  MaterialSettingsRow copyWith({
    int? projectId,
    double? blockLengthMeters,
    double? blockHeightMeters,
    double? jointMeters,
    double? wallThicknessMeters,
    double? masonryWastePercent,
    double? cementBagsPerCubicMeter,
    double? sandCubicMetersPerCubicMeter,
    int? paintCoats,
    double? squareMetersPerLiter,
    double? paintWastePercent,
    bool? includeCeiling,
    double? tileLengthMeters,
    double? tileWidthMeters,
    double? floorWastePercent,
    double? adhesiveKilogramsPerSquareMeter,
  }) => MaterialSettingsRow(
    projectId: projectId ?? this.projectId,
    blockLengthMeters: blockLengthMeters ?? this.blockLengthMeters,
    blockHeightMeters: blockHeightMeters ?? this.blockHeightMeters,
    jointMeters: jointMeters ?? this.jointMeters,
    wallThicknessMeters: wallThicknessMeters ?? this.wallThicknessMeters,
    masonryWastePercent: masonryWastePercent ?? this.masonryWastePercent,
    cementBagsPerCubicMeter:
        cementBagsPerCubicMeter ?? this.cementBagsPerCubicMeter,
    sandCubicMetersPerCubicMeter:
        sandCubicMetersPerCubicMeter ?? this.sandCubicMetersPerCubicMeter,
    paintCoats: paintCoats ?? this.paintCoats,
    squareMetersPerLiter: squareMetersPerLiter ?? this.squareMetersPerLiter,
    paintWastePercent: paintWastePercent ?? this.paintWastePercent,
    includeCeiling: includeCeiling ?? this.includeCeiling,
    tileLengthMeters: tileLengthMeters ?? this.tileLengthMeters,
    tileWidthMeters: tileWidthMeters ?? this.tileWidthMeters,
    floorWastePercent: floorWastePercent ?? this.floorWastePercent,
    adhesiveKilogramsPerSquareMeter:
        adhesiveKilogramsPerSquareMeter ?? this.adhesiveKilogramsPerSquareMeter,
  );
  MaterialSettingsRow copyWithCompanion(ProjectMaterialSettingsCompanion data) {
    return MaterialSettingsRow(
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      blockLengthMeters: data.blockLengthMeters.present
          ? data.blockLengthMeters.value
          : this.blockLengthMeters,
      blockHeightMeters: data.blockHeightMeters.present
          ? data.blockHeightMeters.value
          : this.blockHeightMeters,
      jointMeters: data.jointMeters.present
          ? data.jointMeters.value
          : this.jointMeters,
      wallThicknessMeters: data.wallThicknessMeters.present
          ? data.wallThicknessMeters.value
          : this.wallThicknessMeters,
      masonryWastePercent: data.masonryWastePercent.present
          ? data.masonryWastePercent.value
          : this.masonryWastePercent,
      cementBagsPerCubicMeter: data.cementBagsPerCubicMeter.present
          ? data.cementBagsPerCubicMeter.value
          : this.cementBagsPerCubicMeter,
      sandCubicMetersPerCubicMeter: data.sandCubicMetersPerCubicMeter.present
          ? data.sandCubicMetersPerCubicMeter.value
          : this.sandCubicMetersPerCubicMeter,
      paintCoats: data.paintCoats.present
          ? data.paintCoats.value
          : this.paintCoats,
      squareMetersPerLiter: data.squareMetersPerLiter.present
          ? data.squareMetersPerLiter.value
          : this.squareMetersPerLiter,
      paintWastePercent: data.paintWastePercent.present
          ? data.paintWastePercent.value
          : this.paintWastePercent,
      includeCeiling: data.includeCeiling.present
          ? data.includeCeiling.value
          : this.includeCeiling,
      tileLengthMeters: data.tileLengthMeters.present
          ? data.tileLengthMeters.value
          : this.tileLengthMeters,
      tileWidthMeters: data.tileWidthMeters.present
          ? data.tileWidthMeters.value
          : this.tileWidthMeters,
      floorWastePercent: data.floorWastePercent.present
          ? data.floorWastePercent.value
          : this.floorWastePercent,
      adhesiveKilogramsPerSquareMeter:
          data.adhesiveKilogramsPerSquareMeter.present
          ? data.adhesiveKilogramsPerSquareMeter.value
          : this.adhesiveKilogramsPerSquareMeter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaterialSettingsRow(')
          ..write('projectId: $projectId, ')
          ..write('blockLengthMeters: $blockLengthMeters, ')
          ..write('blockHeightMeters: $blockHeightMeters, ')
          ..write('jointMeters: $jointMeters, ')
          ..write('wallThicknessMeters: $wallThicknessMeters, ')
          ..write('masonryWastePercent: $masonryWastePercent, ')
          ..write('cementBagsPerCubicMeter: $cementBagsPerCubicMeter, ')
          ..write(
            'sandCubicMetersPerCubicMeter: $sandCubicMetersPerCubicMeter, ',
          )
          ..write('paintCoats: $paintCoats, ')
          ..write('squareMetersPerLiter: $squareMetersPerLiter, ')
          ..write('paintWastePercent: $paintWastePercent, ')
          ..write('includeCeiling: $includeCeiling, ')
          ..write('tileLengthMeters: $tileLengthMeters, ')
          ..write('tileWidthMeters: $tileWidthMeters, ')
          ..write('floorWastePercent: $floorWastePercent, ')
          ..write(
            'adhesiveKilogramsPerSquareMeter: $adhesiveKilogramsPerSquareMeter',
          )
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    projectId,
    blockLengthMeters,
    blockHeightMeters,
    jointMeters,
    wallThicknessMeters,
    masonryWastePercent,
    cementBagsPerCubicMeter,
    sandCubicMetersPerCubicMeter,
    paintCoats,
    squareMetersPerLiter,
    paintWastePercent,
    includeCeiling,
    tileLengthMeters,
    tileWidthMeters,
    floorWastePercent,
    adhesiveKilogramsPerSquareMeter,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaterialSettingsRow &&
          other.projectId == this.projectId &&
          other.blockLengthMeters == this.blockLengthMeters &&
          other.blockHeightMeters == this.blockHeightMeters &&
          other.jointMeters == this.jointMeters &&
          other.wallThicknessMeters == this.wallThicknessMeters &&
          other.masonryWastePercent == this.masonryWastePercent &&
          other.cementBagsPerCubicMeter == this.cementBagsPerCubicMeter &&
          other.sandCubicMetersPerCubicMeter ==
              this.sandCubicMetersPerCubicMeter &&
          other.paintCoats == this.paintCoats &&
          other.squareMetersPerLiter == this.squareMetersPerLiter &&
          other.paintWastePercent == this.paintWastePercent &&
          other.includeCeiling == this.includeCeiling &&
          other.tileLengthMeters == this.tileLengthMeters &&
          other.tileWidthMeters == this.tileWidthMeters &&
          other.floorWastePercent == this.floorWastePercent &&
          other.adhesiveKilogramsPerSquareMeter ==
              this.adhesiveKilogramsPerSquareMeter);
}

class ProjectMaterialSettingsCompanion
    extends UpdateCompanion<MaterialSettingsRow> {
  final Value<int> projectId;
  final Value<double> blockLengthMeters;
  final Value<double> blockHeightMeters;
  final Value<double> jointMeters;
  final Value<double> wallThicknessMeters;
  final Value<double> masonryWastePercent;
  final Value<double> cementBagsPerCubicMeter;
  final Value<double> sandCubicMetersPerCubicMeter;
  final Value<int> paintCoats;
  final Value<double> squareMetersPerLiter;
  final Value<double> paintWastePercent;
  final Value<bool> includeCeiling;
  final Value<double> tileLengthMeters;
  final Value<double> tileWidthMeters;
  final Value<double> floorWastePercent;
  final Value<double> adhesiveKilogramsPerSquareMeter;
  const ProjectMaterialSettingsCompanion({
    this.projectId = const Value.absent(),
    this.blockLengthMeters = const Value.absent(),
    this.blockHeightMeters = const Value.absent(),
    this.jointMeters = const Value.absent(),
    this.wallThicknessMeters = const Value.absent(),
    this.masonryWastePercent = const Value.absent(),
    this.cementBagsPerCubicMeter = const Value.absent(),
    this.sandCubicMetersPerCubicMeter = const Value.absent(),
    this.paintCoats = const Value.absent(),
    this.squareMetersPerLiter = const Value.absent(),
    this.paintWastePercent = const Value.absent(),
    this.includeCeiling = const Value.absent(),
    this.tileLengthMeters = const Value.absent(),
    this.tileWidthMeters = const Value.absent(),
    this.floorWastePercent = const Value.absent(),
    this.adhesiveKilogramsPerSquareMeter = const Value.absent(),
  });
  ProjectMaterialSettingsCompanion.insert({
    this.projectId = const Value.absent(),
    this.blockLengthMeters = const Value.absent(),
    this.blockHeightMeters = const Value.absent(),
    this.jointMeters = const Value.absent(),
    this.wallThicknessMeters = const Value.absent(),
    this.masonryWastePercent = const Value.absent(),
    this.cementBagsPerCubicMeter = const Value.absent(),
    this.sandCubicMetersPerCubicMeter = const Value.absent(),
    this.paintCoats = const Value.absent(),
    this.squareMetersPerLiter = const Value.absent(),
    this.paintWastePercent = const Value.absent(),
    this.includeCeiling = const Value.absent(),
    this.tileLengthMeters = const Value.absent(),
    this.tileWidthMeters = const Value.absent(),
    this.floorWastePercent = const Value.absent(),
    this.adhesiveKilogramsPerSquareMeter = const Value.absent(),
  });
  static Insertable<MaterialSettingsRow> custom({
    Expression<int>? projectId,
    Expression<double>? blockLengthMeters,
    Expression<double>? blockHeightMeters,
    Expression<double>? jointMeters,
    Expression<double>? wallThicknessMeters,
    Expression<double>? masonryWastePercent,
    Expression<double>? cementBagsPerCubicMeter,
    Expression<double>? sandCubicMetersPerCubicMeter,
    Expression<int>? paintCoats,
    Expression<double>? squareMetersPerLiter,
    Expression<double>? paintWastePercent,
    Expression<bool>? includeCeiling,
    Expression<double>? tileLengthMeters,
    Expression<double>? tileWidthMeters,
    Expression<double>? floorWastePercent,
    Expression<double>? adhesiveKilogramsPerSquareMeter,
  }) {
    return RawValuesInsertable({
      if (projectId != null) 'project_id': projectId,
      if (blockLengthMeters != null) 'block_length_meters': blockLengthMeters,
      if (blockHeightMeters != null) 'block_height_meters': blockHeightMeters,
      if (jointMeters != null) 'joint_meters': jointMeters,
      if (wallThicknessMeters != null)
        'wall_thickness_meters': wallThicknessMeters,
      if (masonryWastePercent != null)
        'masonry_waste_percent': masonryWastePercent,
      if (cementBagsPerCubicMeter != null)
        'cement_bags_per_cubic_meter': cementBagsPerCubicMeter,
      if (sandCubicMetersPerCubicMeter != null)
        'sand_cubic_meters_per_cubic_meter': sandCubicMetersPerCubicMeter,
      if (paintCoats != null) 'paint_coats': paintCoats,
      if (squareMetersPerLiter != null)
        'square_meters_per_liter': squareMetersPerLiter,
      if (paintWastePercent != null) 'paint_waste_percent': paintWastePercent,
      if (includeCeiling != null) 'include_ceiling': includeCeiling,
      if (tileLengthMeters != null) 'tile_length_meters': tileLengthMeters,
      if (tileWidthMeters != null) 'tile_width_meters': tileWidthMeters,
      if (floorWastePercent != null) 'floor_waste_percent': floorWastePercent,
      if (adhesiveKilogramsPerSquareMeter != null)
        'adhesive_kilograms_per_square_meter': adhesiveKilogramsPerSquareMeter,
    });
  }

  ProjectMaterialSettingsCompanion copyWith({
    Value<int>? projectId,
    Value<double>? blockLengthMeters,
    Value<double>? blockHeightMeters,
    Value<double>? jointMeters,
    Value<double>? wallThicknessMeters,
    Value<double>? masonryWastePercent,
    Value<double>? cementBagsPerCubicMeter,
    Value<double>? sandCubicMetersPerCubicMeter,
    Value<int>? paintCoats,
    Value<double>? squareMetersPerLiter,
    Value<double>? paintWastePercent,
    Value<bool>? includeCeiling,
    Value<double>? tileLengthMeters,
    Value<double>? tileWidthMeters,
    Value<double>? floorWastePercent,
    Value<double>? adhesiveKilogramsPerSquareMeter,
  }) {
    return ProjectMaterialSettingsCompanion(
      projectId: projectId ?? this.projectId,
      blockLengthMeters: blockLengthMeters ?? this.blockLengthMeters,
      blockHeightMeters: blockHeightMeters ?? this.blockHeightMeters,
      jointMeters: jointMeters ?? this.jointMeters,
      wallThicknessMeters: wallThicknessMeters ?? this.wallThicknessMeters,
      masonryWastePercent: masonryWastePercent ?? this.masonryWastePercent,
      cementBagsPerCubicMeter:
          cementBagsPerCubicMeter ?? this.cementBagsPerCubicMeter,
      sandCubicMetersPerCubicMeter:
          sandCubicMetersPerCubicMeter ?? this.sandCubicMetersPerCubicMeter,
      paintCoats: paintCoats ?? this.paintCoats,
      squareMetersPerLiter: squareMetersPerLiter ?? this.squareMetersPerLiter,
      paintWastePercent: paintWastePercent ?? this.paintWastePercent,
      includeCeiling: includeCeiling ?? this.includeCeiling,
      tileLengthMeters: tileLengthMeters ?? this.tileLengthMeters,
      tileWidthMeters: tileWidthMeters ?? this.tileWidthMeters,
      floorWastePercent: floorWastePercent ?? this.floorWastePercent,
      adhesiveKilogramsPerSquareMeter:
          adhesiveKilogramsPerSquareMeter ??
          this.adhesiveKilogramsPerSquareMeter,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (blockLengthMeters.present) {
      map['block_length_meters'] = Variable<double>(blockLengthMeters.value);
    }
    if (blockHeightMeters.present) {
      map['block_height_meters'] = Variable<double>(blockHeightMeters.value);
    }
    if (jointMeters.present) {
      map['joint_meters'] = Variable<double>(jointMeters.value);
    }
    if (wallThicknessMeters.present) {
      map['wall_thickness_meters'] = Variable<double>(
        wallThicknessMeters.value,
      );
    }
    if (masonryWastePercent.present) {
      map['masonry_waste_percent'] = Variable<double>(
        masonryWastePercent.value,
      );
    }
    if (cementBagsPerCubicMeter.present) {
      map['cement_bags_per_cubic_meter'] = Variable<double>(
        cementBagsPerCubicMeter.value,
      );
    }
    if (sandCubicMetersPerCubicMeter.present) {
      map['sand_cubic_meters_per_cubic_meter'] = Variable<double>(
        sandCubicMetersPerCubicMeter.value,
      );
    }
    if (paintCoats.present) {
      map['paint_coats'] = Variable<int>(paintCoats.value);
    }
    if (squareMetersPerLiter.present) {
      map['square_meters_per_liter'] = Variable<double>(
        squareMetersPerLiter.value,
      );
    }
    if (paintWastePercent.present) {
      map['paint_waste_percent'] = Variable<double>(paintWastePercent.value);
    }
    if (includeCeiling.present) {
      map['include_ceiling'] = Variable<bool>(includeCeiling.value);
    }
    if (tileLengthMeters.present) {
      map['tile_length_meters'] = Variable<double>(tileLengthMeters.value);
    }
    if (tileWidthMeters.present) {
      map['tile_width_meters'] = Variable<double>(tileWidthMeters.value);
    }
    if (floorWastePercent.present) {
      map['floor_waste_percent'] = Variable<double>(floorWastePercent.value);
    }
    if (adhesiveKilogramsPerSquareMeter.present) {
      map['adhesive_kilograms_per_square_meter'] = Variable<double>(
        adhesiveKilogramsPerSquareMeter.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectMaterialSettingsCompanion(')
          ..write('projectId: $projectId, ')
          ..write('blockLengthMeters: $blockLengthMeters, ')
          ..write('blockHeightMeters: $blockHeightMeters, ')
          ..write('jointMeters: $jointMeters, ')
          ..write('wallThicknessMeters: $wallThicknessMeters, ')
          ..write('masonryWastePercent: $masonryWastePercent, ')
          ..write('cementBagsPerCubicMeter: $cementBagsPerCubicMeter, ')
          ..write(
            'sandCubicMetersPerCubicMeter: $sandCubicMetersPerCubicMeter, ',
          )
          ..write('paintCoats: $paintCoats, ')
          ..write('squareMetersPerLiter: $squareMetersPerLiter, ')
          ..write('paintWastePercent: $paintWastePercent, ')
          ..write('includeCeiling: $includeCeiling, ')
          ..write('tileLengthMeters: $tileLengthMeters, ')
          ..write('tileWidthMeters: $tileWidthMeters, ')
          ..write('floorWastePercent: $floorWastePercent, ')
          ..write(
            'adhesiveKilogramsPerSquareMeter: $adhesiveKilogramsPerSquareMeter',
          )
          ..write(')'))
        .toString();
  }
}

class $MaterialPricesTable extends MaterialPrices
    with TableInfo<$MaterialPricesTable, MaterialPriceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaterialPricesTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<MaterialKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MaterialKind>($MaterialPricesTable.$converterkind);
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [projectId, kind, unitPrice];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'material_prices';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaterialPriceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {projectId, kind};
  @override
  MaterialPriceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaterialPriceRow(
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      kind: $MaterialPricesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
    );
  }

  @override
  $MaterialPricesTable createAlias(String alias) {
    return $MaterialPricesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MaterialKind, String, String> $converterkind =
      const EnumNameConverter<MaterialKind>(MaterialKind.values);
}

class MaterialPriceRow extends DataClass
    implements Insertable<MaterialPriceRow> {
  final int projectId;
  final MaterialKind kind;
  final double unitPrice;
  const MaterialPriceRow({
    required this.projectId,
    required this.kind,
    required this.unitPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['project_id'] = Variable<int>(projectId);
    {
      map['kind'] = Variable<String>(
        $MaterialPricesTable.$converterkind.toSql(kind),
      );
    }
    map['unit_price'] = Variable<double>(unitPrice);
    return map;
  }

  MaterialPricesCompanion toCompanion(bool nullToAbsent) {
    return MaterialPricesCompanion(
      projectId: Value(projectId),
      kind: Value(kind),
      unitPrice: Value(unitPrice),
    );
  }

  factory MaterialPriceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaterialPriceRow(
      projectId: serializer.fromJson<int>(json['projectId']),
      kind: $MaterialPricesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'projectId': serializer.toJson<int>(projectId),
      'kind': serializer.toJson<String>(
        $MaterialPricesTable.$converterkind.toJson(kind),
      ),
      'unitPrice': serializer.toJson<double>(unitPrice),
    };
  }

  MaterialPriceRow copyWith({
    int? projectId,
    MaterialKind? kind,
    double? unitPrice,
  }) => MaterialPriceRow(
    projectId: projectId ?? this.projectId,
    kind: kind ?? this.kind,
    unitPrice: unitPrice ?? this.unitPrice,
  );
  MaterialPriceRow copyWithCompanion(MaterialPricesCompanion data) {
    return MaterialPriceRow(
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      kind: data.kind.present ? data.kind.value : this.kind,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaterialPriceRow(')
          ..write('projectId: $projectId, ')
          ..write('kind: $kind, ')
          ..write('unitPrice: $unitPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(projectId, kind, unitPrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaterialPriceRow &&
          other.projectId == this.projectId &&
          other.kind == this.kind &&
          other.unitPrice == this.unitPrice);
}

class MaterialPricesCompanion extends UpdateCompanion<MaterialPriceRow> {
  final Value<int> projectId;
  final Value<MaterialKind> kind;
  final Value<double> unitPrice;
  final Value<int> rowid;
  const MaterialPricesCompanion({
    this.projectId = const Value.absent(),
    this.kind = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaterialPricesCompanion.insert({
    required int projectId,
    required MaterialKind kind,
    required double unitPrice,
    this.rowid = const Value.absent(),
  }) : projectId = Value(projectId),
       kind = Value(kind),
       unitPrice = Value(unitPrice);
  static Insertable<MaterialPriceRow> custom({
    Expression<int>? projectId,
    Expression<String>? kind,
    Expression<double>? unitPrice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (projectId != null) 'project_id': projectId,
      if (kind != null) 'kind': kind,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaterialPricesCompanion copyWith({
    Value<int>? projectId,
    Value<MaterialKind>? kind,
    Value<double>? unitPrice,
    Value<int>? rowid,
  }) {
    return MaterialPricesCompanion(
      projectId: projectId ?? this.projectId,
      kind: kind ?? this.kind,
      unitPrice: unitPrice ?? this.unitPrice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $MaterialPricesTable.$converterkind.toSql(kind.value),
      );
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaterialPricesCompanion(')
          ..write('projectId: $projectId, ')
          ..write('kind: $kind, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetItemsTable extends BudgetItems
    with TableInfo<$BudgetItemsTable, BudgetItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<int> roomId = GeneratedColumn<int>(
    'room_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rooms (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<BudgetCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BudgetCategory>($BudgetItemsTable.$convertercategory);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 160,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 24,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    roomId,
    category,
    description,
    unit,
    quantity,
    unitPrice,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetItemRow> instance, {
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
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}room_id'],
      ),
      category: $BudgetItemsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BudgetItemsTable createAlias(String alias) {
    return $BudgetItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BudgetCategory, String, String> $convertercategory =
      const EnumNameConverter<BudgetCategory>(BudgetCategory.values);
}

class BudgetItemRow extends DataClass implements Insertable<BudgetItemRow> {
  final int id;
  final int projectId;

  /// Habitación a la que se carga la partida, si es de una sola.
  final int? roomId;
  final BudgetCategory category;
  final String description;
  final String unit;
  final double quantity;
  final double unitPrice;
  final DateTime createdAt;
  const BudgetItemRow({
    required this.id,
    required this.projectId,
    this.roomId,
    required this.category,
    required this.description,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    if (!nullToAbsent || roomId != null) {
      map['room_id'] = Variable<int>(roomId);
    }
    {
      map['category'] = Variable<String>(
        $BudgetItemsTable.$convertercategory.toSql(category),
      );
    }
    map['description'] = Variable<String>(description);
    map['unit'] = Variable<String>(unit);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetItemsCompanion toCompanion(bool nullToAbsent) {
    return BudgetItemsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      roomId: roomId == null && nullToAbsent
          ? const Value.absent()
          : Value(roomId),
      category: Value(category),
      description: Value(description),
      unit: Value(unit),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      createdAt: Value(createdAt),
    );
  }

  factory BudgetItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetItemRow(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      roomId: serializer.fromJson<int?>(json['roomId']),
      category: $BudgetItemsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      description: serializer.fromJson<String>(json['description']),
      unit: serializer.fromJson<String>(json['unit']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'roomId': serializer.toJson<int?>(roomId),
      'category': serializer.toJson<String>(
        $BudgetItemsTable.$convertercategory.toJson(category),
      ),
      'description': serializer.toJson<String>(description),
      'unit': serializer.toJson<String>(unit),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BudgetItemRow copyWith({
    int? id,
    int? projectId,
    Value<int?> roomId = const Value.absent(),
    BudgetCategory? category,
    String? description,
    String? unit,
    double? quantity,
    double? unitPrice,
    DateTime? createdAt,
  }) => BudgetItemRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    roomId: roomId.present ? roomId.value : this.roomId,
    category: category ?? this.category,
    description: description ?? this.description,
    unit: unit ?? this.unit,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    createdAt: createdAt ?? this.createdAt,
  );
  BudgetItemRow copyWithCompanion(BudgetItemsCompanion data) {
    return BudgetItemRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      unit: data.unit.present ? data.unit.value : this.unit,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetItemRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('roomId: $roomId, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    roomId,
    category,
    description,
    unit,
    quantity,
    unitPrice,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetItemRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.roomId == this.roomId &&
          other.category == this.category &&
          other.description == this.description &&
          other.unit == this.unit &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.createdAt == this.createdAt);
}

class BudgetItemsCompanion extends UpdateCompanion<BudgetItemRow> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<int?> roomId;
  final Value<BudgetCategory> category;
  final Value<String> description;
  final Value<String> unit;
  final Value<double> quantity;
  final Value<double> unitPrice;
  final Value<DateTime> createdAt;
  const BudgetItemsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.roomId = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BudgetItemsCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    this.roomId = const Value.absent(),
    required BudgetCategory category,
    required String description,
    required String unit,
    required double quantity,
    required double unitPrice,
    this.createdAt = const Value.absent(),
  }) : projectId = Value(projectId),
       category = Value(category),
       description = Value(description),
       unit = Value(unit),
       quantity = Value(quantity),
       unitPrice = Value(unitPrice);
  static Insertable<BudgetItemRow> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<int>? roomId,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? unit,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (roomId != null) 'room_id': roomId,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (unit != null) 'unit': unit,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BudgetItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<int?>? roomId,
    Value<BudgetCategory>? category,
    Value<String>? description,
    Value<String>? unit,
    Value<double>? quantity,
    Value<double>? unitPrice,
    Value<DateTime>? createdAt,
  }) {
    return BudgetItemsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      roomId: roomId ?? this.roomId,
      category: category ?? this.category,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      createdAt: createdAt ?? this.createdAt,
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
    if (roomId.present) {
      map['room_id'] = Variable<int>(roomId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $BudgetItemsTable.$convertercategory.toSql(category.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetItemsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('roomId: $roomId, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FinishesTable extends Finishes
    with TableInfo<$FinishesTable, FinishRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinishesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 160,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    description,
    unitPrice,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finishes';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinishRow> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinishRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinishRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FinishesTable createAlias(String alias) {
    return $FinishesTable(attachedDatabase, alias);
  }
}

class FinishRow extends DataClass implements Insertable<FinishRow> {
  final int id;
  final int projectId;
  final String description;

  /// Precio por metro cuadrado.
  final double unitPrice;
  final DateTime createdAt;
  const FinishRow({
    required this.id,
    required this.projectId,
    required this.description,
    required this.unitPrice,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['description'] = Variable<String>(description);
    map['unit_price'] = Variable<double>(unitPrice);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FinishesCompanion toCompanion(bool nullToAbsent) {
    return FinishesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      description: Value(description),
      unitPrice: Value(unitPrice),
      createdAt: Value(createdAt),
    );
  }

  factory FinishRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinishRow(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      description: serializer.fromJson<String>(json['description']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'description': serializer.toJson<String>(description),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FinishRow copyWith({
    int? id,
    int? projectId,
    String? description,
    double? unitPrice,
    DateTime? createdAt,
  }) => FinishRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    description: description ?? this.description,
    unitPrice: unitPrice ?? this.unitPrice,
    createdAt: createdAt ?? this.createdAt,
  );
  FinishRow copyWithCompanion(FinishesCompanion data) {
    return FinishRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      description: data.description.present
          ? data.description.value
          : this.description,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinishRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('description: $description, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, description, unitPrice, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinishRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.description == this.description &&
          other.unitPrice == this.unitPrice &&
          other.createdAt == this.createdAt);
}

class FinishesCompanion extends UpdateCompanion<FinishRow> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> description;
  final Value<double> unitPrice;
  final Value<DateTime> createdAt;
  const FinishesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.description = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FinishesCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required String description,
    required double unitPrice,
    this.createdAt = const Value.absent(),
  }) : projectId = Value(projectId),
       description = Value(description),
       unitPrice = Value(unitPrice);
  static Insertable<FinishRow> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? description,
    Expression<double>? unitPrice,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (description != null) 'description': description,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FinishesCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<String>? description,
    Value<double>? unitPrice,
    Value<DateTime>? createdAt,
  }) {
    return FinishesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      description: description ?? this.description,
      unitPrice: unitPrice ?? this.unitPrice,
      createdAt: createdAt ?? this.createdAt,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinishesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('description: $description, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FinishSurfacesTable extends FinishSurfaces
    with TableInfo<$FinishSurfacesTable, FinishSurfaceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinishSurfacesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _finishIdMeta = const VerificationMeta(
    'finishId',
  );
  @override
  late final GeneratedColumn<int> finishId = GeneratedColumn<int>(
    'finish_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES finishes (id) ON DELETE CASCADE',
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
  static const VerificationMeta _wallIdMeta = const VerificationMeta('wallId');
  @override
  late final GeneratedColumn<int> wallId = GeneratedColumn<int>(
    'wall_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES room_walls (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, finishId, roomId, wallId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finish_surfaces';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinishSurfaceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('finish_id')) {
      context.handle(
        _finishIdMeta,
        finishId.isAcceptableOrUnknown(data['finish_id']!, _finishIdMeta),
      );
    } else if (isInserting) {
      context.missing(_finishIdMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('wall_id')) {
      context.handle(
        _wallIdMeta,
        wallId.isAcceptableOrUnknown(data['wall_id']!, _wallIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinishSurfaceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinishSurfaceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      finishId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}finish_id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}room_id'],
      )!,
      wallId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wall_id'],
      ),
    );
  }

  @override
  $FinishSurfacesTable createAlias(String alias) {
    return $FinishSurfacesTable(attachedDatabase, alias);
  }
}

class FinishSurfaceRow extends DataClass
    implements Insertable<FinishSurfaceRow> {
  final int id;
  final int finishId;
  final int roomId;

  /// `null` cuando la superficie es el piso de esa habitación.
  final int? wallId;
  const FinishSurfaceRow({
    required this.id,
    required this.finishId,
    required this.roomId,
    this.wallId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['finish_id'] = Variable<int>(finishId);
    map['room_id'] = Variable<int>(roomId);
    if (!nullToAbsent || wallId != null) {
      map['wall_id'] = Variable<int>(wallId);
    }
    return map;
  }

  FinishSurfacesCompanion toCompanion(bool nullToAbsent) {
    return FinishSurfacesCompanion(
      id: Value(id),
      finishId: Value(finishId),
      roomId: Value(roomId),
      wallId: wallId == null && nullToAbsent
          ? const Value.absent()
          : Value(wallId),
    );
  }

  factory FinishSurfaceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinishSurfaceRow(
      id: serializer.fromJson<int>(json['id']),
      finishId: serializer.fromJson<int>(json['finishId']),
      roomId: serializer.fromJson<int>(json['roomId']),
      wallId: serializer.fromJson<int?>(json['wallId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'finishId': serializer.toJson<int>(finishId),
      'roomId': serializer.toJson<int>(roomId),
      'wallId': serializer.toJson<int?>(wallId),
    };
  }

  FinishSurfaceRow copyWith({
    int? id,
    int? finishId,
    int? roomId,
    Value<int?> wallId = const Value.absent(),
  }) => FinishSurfaceRow(
    id: id ?? this.id,
    finishId: finishId ?? this.finishId,
    roomId: roomId ?? this.roomId,
    wallId: wallId.present ? wallId.value : this.wallId,
  );
  FinishSurfaceRow copyWithCompanion(FinishSurfacesCompanion data) {
    return FinishSurfaceRow(
      id: data.id.present ? data.id.value : this.id,
      finishId: data.finishId.present ? data.finishId.value : this.finishId,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      wallId: data.wallId.present ? data.wallId.value : this.wallId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinishSurfaceRow(')
          ..write('id: $id, ')
          ..write('finishId: $finishId, ')
          ..write('roomId: $roomId, ')
          ..write('wallId: $wallId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, finishId, roomId, wallId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinishSurfaceRow &&
          other.id == this.id &&
          other.finishId == this.finishId &&
          other.roomId == this.roomId &&
          other.wallId == this.wallId);
}

class FinishSurfacesCompanion extends UpdateCompanion<FinishSurfaceRow> {
  final Value<int> id;
  final Value<int> finishId;
  final Value<int> roomId;
  final Value<int?> wallId;
  const FinishSurfacesCompanion({
    this.id = const Value.absent(),
    this.finishId = const Value.absent(),
    this.roomId = const Value.absent(),
    this.wallId = const Value.absent(),
  });
  FinishSurfacesCompanion.insert({
    this.id = const Value.absent(),
    required int finishId,
    required int roomId,
    this.wallId = const Value.absent(),
  }) : finishId = Value(finishId),
       roomId = Value(roomId);
  static Insertable<FinishSurfaceRow> custom({
    Expression<int>? id,
    Expression<int>? finishId,
    Expression<int>? roomId,
    Expression<int>? wallId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (finishId != null) 'finish_id': finishId,
      if (roomId != null) 'room_id': roomId,
      if (wallId != null) 'wall_id': wallId,
    });
  }

  FinishSurfacesCompanion copyWith({
    Value<int>? id,
    Value<int>? finishId,
    Value<int>? roomId,
    Value<int?>? wallId,
  }) {
    return FinishSurfacesCompanion(
      id: id ?? this.id,
      finishId: finishId ?? this.finishId,
      roomId: roomId ?? this.roomId,
      wallId: wallId ?? this.wallId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (finishId.present) {
      map['finish_id'] = Variable<int>(finishId.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<int>(roomId.value);
    }
    if (wallId.present) {
      map['wall_id'] = Variable<int>(wallId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinishSurfacesCompanion(')
          ..write('id: $id, ')
          ..write('finishId: $finishId, ')
          ..write('roomId: $roomId, ')
          ..write('wallId: $wallId')
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
  late final $ProjectMaterialSettingsTable projectMaterialSettings =
      $ProjectMaterialSettingsTable(this);
  late final $MaterialPricesTable materialPrices = $MaterialPricesTable(this);
  late final $BudgetItemsTable budgetItems = $BudgetItemsTable(this);
  late final $FinishesTable finishes = $FinishesTable(this);
  late final $FinishSurfacesTable finishSurfaces = $FinishSurfacesTable(this);
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
    projectMaterialSettings,
    materialPrices,
    budgetItems,
    finishes,
    finishSurfaces,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('project_material_settings', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('material_prices', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rooms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('finishes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'finishes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('finish_surfaces', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rooms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('finish_surfaces', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'room_walls',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('finish_surfaces', kind: UpdateKind.delete)],
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

  static MultiTypedResultKey<
    $ProjectMaterialSettingsTable,
    List<MaterialSettingsRow>
  >
  _projectMaterialSettingsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.projectMaterialSettings,
        aliasName: 'projects__id__project_material_settings__project_id',
      );

  $$ProjectMaterialSettingsTableProcessedTableManager
  get projectMaterialSettingsRefs {
    final manager = $$ProjectMaterialSettingsTableTableManager(
      $_db,
      $_db.projectMaterialSettings,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectMaterialSettingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MaterialPricesTable, List<MaterialPriceRow>>
  _materialPricesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.materialPrices,
    aliasName: 'projects__id__material_prices__project_id',
  );

  $$MaterialPricesTableProcessedTableManager get materialPricesRefs {
    final manager = $$MaterialPricesTableTableManager(
      $_db,
      $_db.materialPrices,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_materialPricesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetItemsTable, List<BudgetItemRow>>
  _budgetItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetItems,
    aliasName: 'projects__id__budget_items__project_id',
  );

  $$BudgetItemsTableProcessedTableManager get budgetItemsRefs {
    final manager = $$BudgetItemsTableTableManager(
      $_db,
      $_db.budgetItems,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FinishesTable, List<FinishRow>>
  _finishesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.finishes,
    aliasName: 'projects__id__finishes__project_id',
  );

  $$FinishesTableProcessedTableManager get finishesRefs {
    final manager = $$FinishesTableTableManager(
      $_db,
      $_db.finishes,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_finishesRefsTable($_db));
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

  Expression<bool> projectMaterialSettingsRefs(
    Expression<bool> Function($$ProjectMaterialSettingsTableFilterComposer f) f,
  ) {
    final $$ProjectMaterialSettingsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectMaterialSettings,
          getReferencedColumn: (t) => t.projectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectMaterialSettingsTableFilterComposer(
                $db: $db,
                $table: $db.projectMaterialSettings,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> materialPricesRefs(
    Expression<bool> Function($$MaterialPricesTableFilterComposer f) f,
  ) {
    final $$MaterialPricesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materialPrices,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialPricesTableFilterComposer(
            $db: $db,
            $table: $db.materialPrices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetItemsRefs(
    Expression<bool> Function($$BudgetItemsTableFilterComposer f) f,
  ) {
    final $$BudgetItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItems,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableFilterComposer(
            $db: $db,
            $table: $db.budgetItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> finishesRefs(
    Expression<bool> Function($$FinishesTableFilterComposer f) f,
  ) {
    final $$FinishesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishes,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishesTableFilterComposer(
            $db: $db,
            $table: $db.finishes,
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

  Expression<T> projectMaterialSettingsRefs<T extends Object>(
    Expression<T> Function($$ProjectMaterialSettingsTableAnnotationComposer a)
    f,
  ) {
    final $$ProjectMaterialSettingsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectMaterialSettings,
          getReferencedColumn: (t) => t.projectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectMaterialSettingsTableAnnotationComposer(
                $db: $db,
                $table: $db.projectMaterialSettings,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> materialPricesRefs<T extends Object>(
    Expression<T> Function($$MaterialPricesTableAnnotationComposer a) f,
  ) {
    final $$MaterialPricesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materialPrices,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialPricesTableAnnotationComposer(
            $db: $db,
            $table: $db.materialPrices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetItemsRefs<T extends Object>(
    Expression<T> Function($$BudgetItemsTableAnnotationComposer a) f,
  ) {
    final $$BudgetItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItems,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> finishesRefs<T extends Object>(
    Expression<T> Function($$FinishesTableAnnotationComposer a) f,
  ) {
    final $$FinishesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishes,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishesTableAnnotationComposer(
            $db: $db,
            $table: $db.finishes,
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
          PrefetchHooks Function({
            bool roomsRefs,
            bool projectMaterialSettingsRefs,
            bool materialPricesRefs,
            bool budgetItemsRefs,
            bool finishesRefs,
          })
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
          prefetchHooksCallback:
              ({
                roomsRefs = false,
                projectMaterialSettingsRefs = false,
                materialPricesRefs = false,
                budgetItemsRefs = false,
                finishesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (roomsRefs) db.rooms,
                    if (projectMaterialSettingsRefs) db.projectMaterialSettings,
                    if (materialPricesRefs) db.materialPrices,
                    if (budgetItemsRefs) db.budgetItems,
                    if (finishesRefs) db.finishes,
                  ],
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
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).roomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectMaterialSettingsRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          MaterialSettingsRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._projectMaterialSettingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectMaterialSettingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (materialPricesRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          MaterialPriceRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._materialPricesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).materialPricesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetItemsRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          BudgetItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._budgetItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (finishesRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          FinishRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._finishesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).finishesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
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
      PrefetchHooks Function({
        bool roomsRefs,
        bool projectMaterialSettingsRefs,
        bool materialPricesRefs,
        bool budgetItemsRefs,
        bool finishesRefs,
      })
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

  static MultiTypedResultKey<$BudgetItemsTable, List<BudgetItemRow>>
  _budgetItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetItems,
    aliasName: 'rooms__id__budget_items__room_id',
  );

  $$BudgetItemsTableProcessedTableManager get budgetItemsRefs {
    final manager = $$BudgetItemsTableTableManager(
      $_db,
      $_db.budgetItems,
    ).filter((f) => f.roomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FinishSurfacesTable, List<FinishSurfaceRow>>
  _finishSurfacesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.finishSurfaces,
    aliasName: 'rooms__id__finish_surfaces__room_id',
  );

  $$FinishSurfacesTableProcessedTableManager get finishSurfacesRefs {
    final manager = $$FinishSurfacesTableTableManager(
      $_db,
      $_db.finishSurfaces,
    ).filter((f) => f.roomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_finishSurfacesRefsTable($_db));
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

  Expression<bool> budgetItemsRefs(
    Expression<bool> Function($$BudgetItemsTableFilterComposer f) f,
  ) {
    final $$BudgetItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItems,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableFilterComposer(
            $db: $db,
            $table: $db.budgetItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> finishSurfacesRefs(
    Expression<bool> Function($$FinishSurfacesTableFilterComposer f) f,
  ) {
    final $$FinishSurfacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishSurfaces,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishSurfacesTableFilterComposer(
            $db: $db,
            $table: $db.finishSurfaces,
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

  Expression<T> budgetItemsRefs<T extends Object>(
    Expression<T> Function($$BudgetItemsTableAnnotationComposer a) f,
  ) {
    final $$BudgetItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItems,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> finishSurfacesRefs<T extends Object>(
    Expression<T> Function($$FinishSurfacesTableAnnotationComposer a) f,
  ) {
    final $$FinishSurfacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishSurfaces,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishSurfacesTableAnnotationComposer(
            $db: $db,
            $table: $db.finishSurfaces,
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
          PrefetchHooks Function({
            bool projectId,
            bool roomWallsRefs,
            bool budgetItemsRefs,
            bool finishSurfacesRefs,
          })
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
          prefetchHooksCallback:
              ({
                projectId = false,
                roomWallsRefs = false,
                budgetItemsRefs = false,
                finishSurfacesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (roomWallsRefs) db.roomWalls,
                    if (budgetItemsRefs) db.budgetItems,
                    if (finishSurfacesRefs) db.finishSurfaces,
                  ],
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
                            referencedTable: $$RoomsTableReferences
                                ._projectIdTable(db),
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
                              $$RoomsTableReferences(
                                db,
                                table,
                                p0,
                              ).roomWallsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetItemsRefs)
                        await $_getPrefetchedData<
                          RoomRow,
                          $RoomsTable,
                          BudgetItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$RoomsTableReferences
                              ._budgetItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoomsTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (finishSurfacesRefs)
                        await $_getPrefetchedData<
                          RoomRow,
                          $RoomsTable,
                          FinishSurfaceRow
                        >(
                          currentTable: table,
                          referencedTable: $$RoomsTableReferences
                              ._finishSurfacesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoomsTableReferences(
                                db,
                                table,
                                p0,
                              ).finishSurfacesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roomId == item.id,
                              ),
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
      PrefetchHooks Function({
        bool projectId,
        bool roomWallsRefs,
        bool budgetItemsRefs,
        bool finishSurfacesRefs,
      })
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

  static MultiTypedResultKey<$FinishSurfacesTable, List<FinishSurfaceRow>>
  _finishSurfacesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.finishSurfaces,
    aliasName: 'room_walls__id__finish_surfaces__wall_id',
  );

  $$FinishSurfacesTableProcessedTableManager get finishSurfacesRefs {
    final manager = $$FinishSurfacesTableTableManager(
      $_db,
      $_db.finishSurfaces,
    ).filter((f) => f.wallId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_finishSurfacesRefsTable($_db));
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

  Expression<bool> finishSurfacesRefs(
    Expression<bool> Function($$FinishSurfacesTableFilterComposer f) f,
  ) {
    final $$FinishSurfacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishSurfaces,
      getReferencedColumn: (t) => t.wallId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishSurfacesTableFilterComposer(
            $db: $db,
            $table: $db.finishSurfaces,
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

  Expression<T> finishSurfacesRefs<T extends Object>(
    Expression<T> Function($$FinishSurfacesTableAnnotationComposer a) f,
  ) {
    final $$FinishSurfacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishSurfaces,
      getReferencedColumn: (t) => t.wallId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishSurfacesTableAnnotationComposer(
            $db: $db,
            $table: $db.finishSurfaces,
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
          PrefetchHooks Function({
            bool roomId,
            bool roomOpeningsRefs,
            bool finishSurfacesRefs,
          })
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
          prefetchHooksCallback:
              ({
                roomId = false,
                roomOpeningsRefs = false,
                finishSurfacesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (roomOpeningsRefs) db.roomOpenings,
                    if (finishSurfacesRefs) db.finishSurfaces,
                  ],
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
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.wallId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (finishSurfacesRefs)
                        await $_getPrefetchedData<
                          RoomWallRow,
                          $RoomWallsTable,
                          FinishSurfaceRow
                        >(
                          currentTable: table,
                          referencedTable: $$RoomWallsTableReferences
                              ._finishSurfacesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoomWallsTableReferences(
                                db,
                                table,
                                p0,
                              ).finishSurfacesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.wallId == item.id,
                              ),
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
      PrefetchHooks Function({
        bool roomId,
        bool roomOpeningsRefs,
        bool finishSurfacesRefs,
      })
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
typedef $$ProjectMaterialSettingsTableCreateCompanionBuilder =
    ProjectMaterialSettingsCompanion Function({
      Value<int> projectId,
      Value<double> blockLengthMeters,
      Value<double> blockHeightMeters,
      Value<double> jointMeters,
      Value<double> wallThicknessMeters,
      Value<double> masonryWastePercent,
      Value<double> cementBagsPerCubicMeter,
      Value<double> sandCubicMetersPerCubicMeter,
      Value<int> paintCoats,
      Value<double> squareMetersPerLiter,
      Value<double> paintWastePercent,
      Value<bool> includeCeiling,
      Value<double> tileLengthMeters,
      Value<double> tileWidthMeters,
      Value<double> floorWastePercent,
      Value<double> adhesiveKilogramsPerSquareMeter,
    });
typedef $$ProjectMaterialSettingsTableUpdateCompanionBuilder =
    ProjectMaterialSettingsCompanion Function({
      Value<int> projectId,
      Value<double> blockLengthMeters,
      Value<double> blockHeightMeters,
      Value<double> jointMeters,
      Value<double> wallThicknessMeters,
      Value<double> masonryWastePercent,
      Value<double> cementBagsPerCubicMeter,
      Value<double> sandCubicMetersPerCubicMeter,
      Value<int> paintCoats,
      Value<double> squareMetersPerLiter,
      Value<double> paintWastePercent,
      Value<bool> includeCeiling,
      Value<double> tileLengthMeters,
      Value<double> tileWidthMeters,
      Value<double> floorWastePercent,
      Value<double> adhesiveKilogramsPerSquareMeter,
    });

final class $$ProjectMaterialSettingsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProjectMaterialSettingsTable,
          MaterialSettingsRow
        > {
  $$ProjectMaterialSettingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias('project_material_settings__project_id__projects__id');

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
}

class $$ProjectMaterialSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectMaterialSettingsTable> {
  $$ProjectMaterialSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get blockLengthMeters => $composableBuilder(
    column: $table.blockLengthMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get blockHeightMeters => $composableBuilder(
    column: $table.blockHeightMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get jointMeters => $composableBuilder(
    column: $table.jointMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wallThicknessMeters => $composableBuilder(
    column: $table.wallThicknessMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get masonryWastePercent => $composableBuilder(
    column: $table.masonryWastePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cementBagsPerCubicMeter => $composableBuilder(
    column: $table.cementBagsPerCubicMeter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sandCubicMetersPerCubicMeter => $composableBuilder(
    column: $table.sandCubicMetersPerCubicMeter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paintCoats => $composableBuilder(
    column: $table.paintCoats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get squareMetersPerLiter => $composableBuilder(
    column: $table.squareMetersPerLiter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paintWastePercent => $composableBuilder(
    column: $table.paintWastePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get includeCeiling => $composableBuilder(
    column: $table.includeCeiling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tileLengthMeters => $composableBuilder(
    column: $table.tileLengthMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tileWidthMeters => $composableBuilder(
    column: $table.tileWidthMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get floorWastePercent => $composableBuilder(
    column: $table.floorWastePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get adhesiveKilogramsPerSquareMeter =>
      $composableBuilder(
        column: $table.adhesiveKilogramsPerSquareMeter,
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
}

class $$ProjectMaterialSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectMaterialSettingsTable> {
  $$ProjectMaterialSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get blockLengthMeters => $composableBuilder(
    column: $table.blockLengthMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get blockHeightMeters => $composableBuilder(
    column: $table.blockHeightMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get jointMeters => $composableBuilder(
    column: $table.jointMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wallThicknessMeters => $composableBuilder(
    column: $table.wallThicknessMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get masonryWastePercent => $composableBuilder(
    column: $table.masonryWastePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cementBagsPerCubicMeter => $composableBuilder(
    column: $table.cementBagsPerCubicMeter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sandCubicMetersPerCubicMeter =>
      $composableBuilder(
        column: $table.sandCubicMetersPerCubicMeter,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get paintCoats => $composableBuilder(
    column: $table.paintCoats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get squareMetersPerLiter => $composableBuilder(
    column: $table.squareMetersPerLiter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paintWastePercent => $composableBuilder(
    column: $table.paintWastePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get includeCeiling => $composableBuilder(
    column: $table.includeCeiling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tileLengthMeters => $composableBuilder(
    column: $table.tileLengthMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tileWidthMeters => $composableBuilder(
    column: $table.tileWidthMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get floorWastePercent => $composableBuilder(
    column: $table.floorWastePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get adhesiveKilogramsPerSquareMeter =>
      $composableBuilder(
        column: $table.adhesiveKilogramsPerSquareMeter,
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

class $$ProjectMaterialSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectMaterialSettingsTable> {
  $$ProjectMaterialSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get blockLengthMeters => $composableBuilder(
    column: $table.blockLengthMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get blockHeightMeters => $composableBuilder(
    column: $table.blockHeightMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get jointMeters => $composableBuilder(
    column: $table.jointMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get wallThicknessMeters => $composableBuilder(
    column: $table.wallThicknessMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get masonryWastePercent => $composableBuilder(
    column: $table.masonryWastePercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cementBagsPerCubicMeter => $composableBuilder(
    column: $table.cementBagsPerCubicMeter,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sandCubicMetersPerCubicMeter =>
      $composableBuilder(
        column: $table.sandCubicMetersPerCubicMeter,
        builder: (column) => column,
      );

  GeneratedColumn<int> get paintCoats => $composableBuilder(
    column: $table.paintCoats,
    builder: (column) => column,
  );

  GeneratedColumn<double> get squareMetersPerLiter => $composableBuilder(
    column: $table.squareMetersPerLiter,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paintWastePercent => $composableBuilder(
    column: $table.paintWastePercent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get includeCeiling => $composableBuilder(
    column: $table.includeCeiling,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tileLengthMeters => $composableBuilder(
    column: $table.tileLengthMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tileWidthMeters => $composableBuilder(
    column: $table.tileWidthMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get floorWastePercent => $composableBuilder(
    column: $table.floorWastePercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get adhesiveKilogramsPerSquareMeter =>
      $composableBuilder(
        column: $table.adhesiveKilogramsPerSquareMeter,
        builder: (column) => column,
      );

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
}

class $$ProjectMaterialSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectMaterialSettingsTable,
          MaterialSettingsRow,
          $$ProjectMaterialSettingsTableFilterComposer,
          $$ProjectMaterialSettingsTableOrderingComposer,
          $$ProjectMaterialSettingsTableAnnotationComposer,
          $$ProjectMaterialSettingsTableCreateCompanionBuilder,
          $$ProjectMaterialSettingsTableUpdateCompanionBuilder,
          (MaterialSettingsRow, $$ProjectMaterialSettingsTableReferences),
          MaterialSettingsRow,
          PrefetchHooks Function({bool projectId})
        > {
  $$ProjectMaterialSettingsTableTableManager(
    _$AppDatabase db,
    $ProjectMaterialSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectMaterialSettingsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ProjectMaterialSettingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProjectMaterialSettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> projectId = const Value.absent(),
                Value<double> blockLengthMeters = const Value.absent(),
                Value<double> blockHeightMeters = const Value.absent(),
                Value<double> jointMeters = const Value.absent(),
                Value<double> wallThicknessMeters = const Value.absent(),
                Value<double> masonryWastePercent = const Value.absent(),
                Value<double> cementBagsPerCubicMeter = const Value.absent(),
                Value<double> sandCubicMetersPerCubicMeter =
                    const Value.absent(),
                Value<int> paintCoats = const Value.absent(),
                Value<double> squareMetersPerLiter = const Value.absent(),
                Value<double> paintWastePercent = const Value.absent(),
                Value<bool> includeCeiling = const Value.absent(),
                Value<double> tileLengthMeters = const Value.absent(),
                Value<double> tileWidthMeters = const Value.absent(),
                Value<double> floorWastePercent = const Value.absent(),
                Value<double> adhesiveKilogramsPerSquareMeter =
                    const Value.absent(),
              }) => ProjectMaterialSettingsCompanion(
                projectId: projectId,
                blockLengthMeters: blockLengthMeters,
                blockHeightMeters: blockHeightMeters,
                jointMeters: jointMeters,
                wallThicknessMeters: wallThicknessMeters,
                masonryWastePercent: masonryWastePercent,
                cementBagsPerCubicMeter: cementBagsPerCubicMeter,
                sandCubicMetersPerCubicMeter: sandCubicMetersPerCubicMeter,
                paintCoats: paintCoats,
                squareMetersPerLiter: squareMetersPerLiter,
                paintWastePercent: paintWastePercent,
                includeCeiling: includeCeiling,
                tileLengthMeters: tileLengthMeters,
                tileWidthMeters: tileWidthMeters,
                floorWastePercent: floorWastePercent,
                adhesiveKilogramsPerSquareMeter:
                    adhesiveKilogramsPerSquareMeter,
              ),
          createCompanionCallback:
              ({
                Value<int> projectId = const Value.absent(),
                Value<double> blockLengthMeters = const Value.absent(),
                Value<double> blockHeightMeters = const Value.absent(),
                Value<double> jointMeters = const Value.absent(),
                Value<double> wallThicknessMeters = const Value.absent(),
                Value<double> masonryWastePercent = const Value.absent(),
                Value<double> cementBagsPerCubicMeter = const Value.absent(),
                Value<double> sandCubicMetersPerCubicMeter =
                    const Value.absent(),
                Value<int> paintCoats = const Value.absent(),
                Value<double> squareMetersPerLiter = const Value.absent(),
                Value<double> paintWastePercent = const Value.absent(),
                Value<bool> includeCeiling = const Value.absent(),
                Value<double> tileLengthMeters = const Value.absent(),
                Value<double> tileWidthMeters = const Value.absent(),
                Value<double> floorWastePercent = const Value.absent(),
                Value<double> adhesiveKilogramsPerSquareMeter =
                    const Value.absent(),
              }) => ProjectMaterialSettingsCompanion.insert(
                projectId: projectId,
                blockLengthMeters: blockLengthMeters,
                blockHeightMeters: blockHeightMeters,
                jointMeters: jointMeters,
                wallThicknessMeters: wallThicknessMeters,
                masonryWastePercent: masonryWastePercent,
                cementBagsPerCubicMeter: cementBagsPerCubicMeter,
                sandCubicMetersPerCubicMeter: sandCubicMetersPerCubicMeter,
                paintCoats: paintCoats,
                squareMetersPerLiter: squareMetersPerLiter,
                paintWastePercent: paintWastePercent,
                includeCeiling: includeCeiling,
                tileLengthMeters: tileLengthMeters,
                tileWidthMeters: tileWidthMeters,
                floorWastePercent: floorWastePercent,
                adhesiveKilogramsPerSquareMeter:
                    adhesiveKilogramsPerSquareMeter,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ProjectMaterialSettingsTable,
                    MaterialSettingsRow
                  >(table),
                  $$ProjectMaterialSettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
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
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable:
                            $$ProjectMaterialSettingsTableReferences
                                ._projectIdTable(db),
                        referencedColumn:
                            $$ProjectMaterialSettingsTableReferences
                                ._projectIdTable(db)
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

typedef $$ProjectMaterialSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectMaterialSettingsTable,
      MaterialSettingsRow,
      $$ProjectMaterialSettingsTableFilterComposer,
      $$ProjectMaterialSettingsTableOrderingComposer,
      $$ProjectMaterialSettingsTableAnnotationComposer,
      $$ProjectMaterialSettingsTableCreateCompanionBuilder,
      $$ProjectMaterialSettingsTableUpdateCompanionBuilder,
      (MaterialSettingsRow, $$ProjectMaterialSettingsTableReferences),
      MaterialSettingsRow,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$MaterialPricesTableCreateCompanionBuilder =
    MaterialPricesCompanion Function({
      required int projectId,
      required MaterialKind kind,
      required double unitPrice,
      Value<int> rowid,
    });
typedef $$MaterialPricesTableUpdateCompanionBuilder =
    MaterialPricesCompanion Function({
      Value<int> projectId,
      Value<MaterialKind> kind,
      Value<double> unitPrice,
      Value<int> rowid,
    });

final class $$MaterialPricesTableReferences
    extends
        BaseReferences<_$AppDatabase, $MaterialPricesTable, MaterialPriceRow> {
  $$MaterialPricesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('material_prices__project_id__projects__id');

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
}

class $$MaterialPricesTableFilterComposer
    extends Composer<_$AppDatabase, $MaterialPricesTable> {
  $$MaterialPricesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<MaterialKind, MaterialKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
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
}

class $$MaterialPricesTableOrderingComposer
    extends Composer<_$AppDatabase, $MaterialPricesTable> {
  $$MaterialPricesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
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

class $$MaterialPricesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaterialPricesTable> {
  $$MaterialPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<MaterialKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

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
}

class $$MaterialPricesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaterialPricesTable,
          MaterialPriceRow,
          $$MaterialPricesTableFilterComposer,
          $$MaterialPricesTableOrderingComposer,
          $$MaterialPricesTableAnnotationComposer,
          $$MaterialPricesTableCreateCompanionBuilder,
          $$MaterialPricesTableUpdateCompanionBuilder,
          (MaterialPriceRow, $$MaterialPricesTableReferences),
          MaterialPriceRow,
          PrefetchHooks Function({bool projectId})
        > {
  $$MaterialPricesTableTableManager(
    _$AppDatabase db,
    $MaterialPricesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaterialPricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaterialPricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaterialPricesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> projectId = const Value.absent(),
                Value<MaterialKind> kind = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaterialPricesCompanion(
                projectId: projectId,
                kind: kind,
                unitPrice: unitPrice,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int projectId,
                required MaterialKind kind,
                required double unitPrice,
                Value<int> rowid = const Value.absent(),
              }) => MaterialPricesCompanion.insert(
                projectId: projectId,
                kind: kind,
                unitPrice: unitPrice,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MaterialPricesTable, MaterialPriceRow>(table),
                  $$MaterialPricesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
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
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$MaterialPricesTableReferences
                            ._projectIdTable(db),
                        referencedColumn: $$MaterialPricesTableReferences
                            ._projectIdTable(db)
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

typedef $$MaterialPricesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaterialPricesTable,
      MaterialPriceRow,
      $$MaterialPricesTableFilterComposer,
      $$MaterialPricesTableOrderingComposer,
      $$MaterialPricesTableAnnotationComposer,
      $$MaterialPricesTableCreateCompanionBuilder,
      $$MaterialPricesTableUpdateCompanionBuilder,
      (MaterialPriceRow, $$MaterialPricesTableReferences),
      MaterialPriceRow,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$BudgetItemsTableCreateCompanionBuilder =
    BudgetItemsCompanion Function({
      Value<int> id,
      required int projectId,
      Value<int?> roomId,
      required BudgetCategory category,
      required String description,
      required String unit,
      required double quantity,
      required double unitPrice,
      Value<DateTime> createdAt,
    });
typedef $$BudgetItemsTableUpdateCompanionBuilder =
    BudgetItemsCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<int?> roomId,
      Value<BudgetCategory> category,
      Value<String> description,
      Value<String> unit,
      Value<double> quantity,
      Value<double> unitPrice,
      Value<DateTime> createdAt,
    });

final class $$BudgetItemsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetItemsTable, BudgetItemRow> {
  $$BudgetItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('budget_items__project_id__projects__id');

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

  static $RoomsTable _roomIdTable(_$AppDatabase db) =>
      db.rooms.createAlias('budget_items__room_id__rooms__id');

  $$RoomsTableProcessedTableManager? get roomId {
    final $_column = $_itemColumn<int>('room_id');
    if ($_column == null) return null;
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
}

class $$BudgetItemsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetItemsTable> {
  $$BudgetItemsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<BudgetCategory, BudgetCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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
}

class $$BudgetItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetItemsTable> {
  $$BudgetItemsTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

class $$BudgetItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetItemsTable> {
  $$BudgetItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BudgetCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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
}

class $$BudgetItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetItemsTable,
          BudgetItemRow,
          $$BudgetItemsTableFilterComposer,
          $$BudgetItemsTableOrderingComposer,
          $$BudgetItemsTableAnnotationComposer,
          $$BudgetItemsTableCreateCompanionBuilder,
          $$BudgetItemsTableUpdateCompanionBuilder,
          (BudgetItemRow, $$BudgetItemsTableReferences),
          BudgetItemRow,
          PrefetchHooks Function({bool projectId, bool roomId})
        > {
  $$BudgetItemsTableTableManager(_$AppDatabase db, $BudgetItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<int?> roomId = const Value.absent(),
                Value<BudgetCategory> category = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BudgetItemsCompanion(
                id: id,
                projectId: projectId,
                roomId: roomId,
                category: category,
                description: description,
                unit: unit,
                quantity: quantity,
                unitPrice: unitPrice,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                Value<int?> roomId = const Value.absent(),
                required BudgetCategory category,
                required String description,
                required String unit,
                required double quantity,
                required double unitPrice,
                Value<DateTime> createdAt = const Value.absent(),
              }) => BudgetItemsCompanion.insert(
                id: id,
                projectId: projectId,
                roomId: roomId,
                category: category,
                description: description,
                unit: unit,
                quantity: quantity,
                unitPrice: unitPrice,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetItemsTable, BudgetItemRow>(table),
                  $$BudgetItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false, roomId = false}) {
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
                    if (projectId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.projectId,
                        referencedTable: $$BudgetItemsTableReferences
                            ._projectIdTable(db),
                        referencedColumn: $$BudgetItemsTableReferences
                            ._projectIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (roomId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.roomId,
                        referencedTable: $$BudgetItemsTableReferences
                            ._roomIdTable(db),
                        referencedColumn: $$BudgetItemsTableReferences
                            ._roomIdTable(db)
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

typedef $$BudgetItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetItemsTable,
      BudgetItemRow,
      $$BudgetItemsTableFilterComposer,
      $$BudgetItemsTableOrderingComposer,
      $$BudgetItemsTableAnnotationComposer,
      $$BudgetItemsTableCreateCompanionBuilder,
      $$BudgetItemsTableUpdateCompanionBuilder,
      (BudgetItemRow, $$BudgetItemsTableReferences),
      BudgetItemRow,
      PrefetchHooks Function({bool projectId, bool roomId})
    >;
typedef $$FinishesTableCreateCompanionBuilder = FinishesCompanion Function({
  Value<int> id,
  required int projectId,
  required String description,
  required double unitPrice,
  Value<DateTime> createdAt,
});
typedef $$FinishesTableUpdateCompanionBuilder = FinishesCompanion Function({
  Value<int> id,
  Value<int> projectId,
  Value<String> description,
  Value<double> unitPrice,
  Value<DateTime> createdAt,
});

final class $$FinishesTableReferences
    extends BaseReferences<_$AppDatabase, $FinishesTable, FinishRow> {
  $$FinishesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('finishes__project_id__projects__id');

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

  static MultiTypedResultKey<$FinishSurfacesTable, List<FinishSurfaceRow>>
  _finishSurfacesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.finishSurfaces,
    aliasName: 'finishes__id__finish_surfaces__finish_id',
  );

  $$FinishSurfacesTableProcessedTableManager get finishSurfacesRefs {
    final manager = $$FinishSurfacesTableTableManager(
      $_db,
      $_db.finishSurfaces,
    ).filter((f) => f.finishId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_finishSurfacesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FinishesTableFilterComposer
    extends Composer<_$AppDatabase, $FinishesTable> {
  $$FinishesTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

  Expression<bool> finishSurfacesRefs(
    Expression<bool> Function($$FinishSurfacesTableFilterComposer f) f,
  ) {
    final $$FinishSurfacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishSurfaces,
      getReferencedColumn: (t) => t.finishId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishSurfacesTableFilterComposer(
            $db: $db,
            $table: $db.finishSurfaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FinishesTableOrderingComposer
    extends Composer<_$AppDatabase, $FinishesTable> {
  $$FinishesTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

class $$FinishesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinishesTable> {
  $$FinishesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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

  Expression<T> finishSurfacesRefs<T extends Object>(
    Expression<T> Function($$FinishSurfacesTableAnnotationComposer a) f,
  ) {
    final $$FinishSurfacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finishSurfaces,
      getReferencedColumn: (t) => t.finishId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishSurfacesTableAnnotationComposer(
            $db: $db,
            $table: $db.finishSurfaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FinishesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinishesTable,
          FinishRow,
          $$FinishesTableFilterComposer,
          $$FinishesTableOrderingComposer,
          $$FinishesTableAnnotationComposer,
          $$FinishesTableCreateCompanionBuilder,
          $$FinishesTableUpdateCompanionBuilder,
          (FinishRow, $$FinishesTableReferences),
          FinishRow,
          PrefetchHooks Function({bool projectId, bool finishSurfacesRefs})
        > {
  $$FinishesTableTableManager(_$AppDatabase db, $FinishesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinishesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinishesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinishesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FinishesCompanion(
                id: id,
                projectId: projectId,
                description: description,
                unitPrice: unitPrice,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required String description,
                required double unitPrice,
                Value<DateTime> createdAt = const Value.absent(),
              }) => FinishesCompanion.insert(
                id: id,
                projectId: projectId,
                description: description,
                unitPrice: unitPrice,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FinishesTable, FinishRow>(table),
                  $$FinishesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectId = false, finishSurfacesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (finishSurfacesRefs) db.finishSurfaces,
                  ],
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
                            referencedTable: $$FinishesTableReferences
                                ._projectIdTable(db),
                            referencedColumn: $$FinishesTableReferences
                                ._projectIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (finishSurfacesRefs)
                        await $_getPrefetchedData<
                          FinishRow,
                          $FinishesTable,
                          FinishSurfaceRow
                        >(
                          currentTable: table,
                          referencedTable: $$FinishesTableReferences
                              ._finishSurfacesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FinishesTableReferences(
                                db,
                                table,
                                p0,
                              ).finishSurfacesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.finishId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FinishesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinishesTable,
      FinishRow,
      $$FinishesTableFilterComposer,
      $$FinishesTableOrderingComposer,
      $$FinishesTableAnnotationComposer,
      $$FinishesTableCreateCompanionBuilder,
      $$FinishesTableUpdateCompanionBuilder,
      (FinishRow, $$FinishesTableReferences),
      FinishRow,
      PrefetchHooks Function({bool projectId, bool finishSurfacesRefs})
    >;
typedef $$FinishSurfacesTableCreateCompanionBuilder =
    FinishSurfacesCompanion Function({
      Value<int> id,
      required int finishId,
      required int roomId,
      Value<int?> wallId,
    });
typedef $$FinishSurfacesTableUpdateCompanionBuilder =
    FinishSurfacesCompanion Function({
      Value<int> id,
      Value<int> finishId,
      Value<int> roomId,
      Value<int?> wallId,
    });

final class $$FinishSurfacesTableReferences
    extends
        BaseReferences<_$AppDatabase, $FinishSurfacesTable, FinishSurfaceRow> {
  $$FinishSurfacesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FinishesTable _finishIdTable(_$AppDatabase db) =>
      db.finishes.createAlias('finish_surfaces__finish_id__finishes__id');

  $$FinishesTableProcessedTableManager get finishId {
    final $_column = $_itemColumn<int>('finish_id')!;

    final manager = $$FinishesTableTableManager(
      $_db,
      $_db.finishes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_finishIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RoomsTable _roomIdTable(_$AppDatabase db) =>
      db.rooms.createAlias('finish_surfaces__room_id__rooms__id');

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

  static $RoomWallsTable _wallIdTable(_$AppDatabase db) =>
      db.roomWalls.createAlias('finish_surfaces__wall_id__room_walls__id');

  $$RoomWallsTableProcessedTableManager? get wallId {
    final $_column = $_itemColumn<int>('wall_id');
    if ($_column == null) return null;
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

class $$FinishSurfacesTableFilterComposer
    extends Composer<_$AppDatabase, $FinishSurfacesTable> {
  $$FinishSurfacesTableFilterComposer({
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

  $$FinishesTableFilterComposer get finishId {
    final $$FinishesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.finishId,
      referencedTable: $db.finishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishesTableFilterComposer(
            $db: $db,
            $table: $db.finishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

class $$FinishSurfacesTableOrderingComposer
    extends Composer<_$AppDatabase, $FinishSurfacesTable> {
  $$FinishSurfacesTableOrderingComposer({
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

  $$FinishesTableOrderingComposer get finishId {
    final $$FinishesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.finishId,
      referencedTable: $db.finishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishesTableOrderingComposer(
            $db: $db,
            $table: $db.finishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

class $$FinishSurfacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinishSurfacesTable> {
  $$FinishSurfacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$FinishesTableAnnotationComposer get finishId {
    final $$FinishesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.finishId,
      referencedTable: $db.finishes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinishesTableAnnotationComposer(
            $db: $db,
            $table: $db.finishes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

class $$FinishSurfacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinishSurfacesTable,
          FinishSurfaceRow,
          $$FinishSurfacesTableFilterComposer,
          $$FinishSurfacesTableOrderingComposer,
          $$FinishSurfacesTableAnnotationComposer,
          $$FinishSurfacesTableCreateCompanionBuilder,
          $$FinishSurfacesTableUpdateCompanionBuilder,
          (FinishSurfaceRow, $$FinishSurfacesTableReferences),
          FinishSurfaceRow,
          PrefetchHooks Function({bool finishId, bool roomId, bool wallId})
        > {
  $$FinishSurfacesTableTableManager(
    _$AppDatabase db,
    $FinishSurfacesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinishSurfacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinishSurfacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinishSurfacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> finishId = const Value.absent(),
                Value<int> roomId = const Value.absent(),
                Value<int?> wallId = const Value.absent(),
              }) => FinishSurfacesCompanion(
                id: id,
                finishId: finishId,
                roomId: roomId,
                wallId: wallId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int finishId,
                required int roomId,
                Value<int?> wallId = const Value.absent(),
              }) => FinishSurfacesCompanion.insert(
                id: id,
                finishId: finishId,
                roomId: roomId,
                wallId: wallId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FinishSurfacesTable, FinishSurfaceRow>(table),
                  $$FinishSurfacesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({finishId = false, roomId = false, wallId = false}) {
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
                        if (finishId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.finishId,
                            referencedTable: $$FinishSurfacesTableReferences
                                ._finishIdTable(db),
                            referencedColumn: $$FinishSurfacesTableReferences
                                ._finishIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (roomId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.roomId,
                            referencedTable: $$FinishSurfacesTableReferences
                                ._roomIdTable(db),
                            referencedColumn: $$FinishSurfacesTableReferences
                                ._roomIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (wallId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.wallId,
                            referencedTable: $$FinishSurfacesTableReferences
                                ._wallIdTable(db),
                            referencedColumn: $$FinishSurfacesTableReferences
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

typedef $$FinishSurfacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinishSurfacesTable,
      FinishSurfaceRow,
      $$FinishSurfacesTableFilterComposer,
      $$FinishSurfacesTableOrderingComposer,
      $$FinishSurfacesTableAnnotationComposer,
      $$FinishSurfacesTableCreateCompanionBuilder,
      $$FinishSurfacesTableUpdateCompanionBuilder,
      (FinishSurfaceRow, $$FinishSurfacesTableReferences),
      FinishSurfaceRow,
      PrefetchHooks Function({bool finishId, bool roomId, bool wallId})
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
  $$ProjectMaterialSettingsTableTableManager get projectMaterialSettings =>
      $$ProjectMaterialSettingsTableTableManager(
        _db,
        _db.projectMaterialSettings,
      );
  $$MaterialPricesTableTableManager get materialPrices =>
      $$MaterialPricesTableTableManager(_db, _db.materialPrices);
  $$BudgetItemsTableTableManager get budgetItems =>
      $$BudgetItemsTableTableManager(_db, _db.budgetItems);
  $$FinishesTableTableManager get finishes =>
      $$FinishesTableTableManager(_db, _db.finishes);
  $$FinishSurfacesTableTableManager get finishSurfaces =>
      $$FinishSurfacesTableTableManager(_db, _db.finishSurfaces);
}
