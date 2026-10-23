// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gridSizeMeta = const VerificationMeta(
    'gridSize',
  );
  @override
  late final GeneratedColumn<int> gridSize = GeneratedColumn<int>(
    'grid_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _phraseBarEnabledMeta = const VerificationMeta(
    'phraseBarEnabled',
  );
  @override
  late final GeneratedColumn<bool> phraseBarEnabled = GeneratedColumn<bool>(
    'phrase_bar_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("phrase_bar_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nestedCategoriesMeta = const VerificationMeta(
    'nestedCategories',
  );
  @override
  late final GeneratedColumn<bool> nestedCategories = GeneratedColumn<bool>(
    'nested_categories',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("nested_categories" IN (0, 1))',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    gridSize,
    phraseBarEnabled,
    nestedCategories,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
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
    if (data.containsKey('grid_size')) {
      context.handle(
        _gridSizeMeta,
        gridSize.isAcceptableOrUnknown(data['grid_size']!, _gridSizeMeta),
      );
    }
    if (data.containsKey('phrase_bar_enabled')) {
      context.handle(
        _phraseBarEnabledMeta,
        phraseBarEnabled.isAcceptableOrUnknown(
          data['phrase_bar_enabled']!,
          _phraseBarEnabledMeta,
        ),
      );
    }
    if (data.containsKey('nested_categories')) {
      context.handle(
        _nestedCategoriesMeta,
        nestedCategories.isAcceptableOrUnknown(
          data['nested_categories']!,
          _nestedCategoriesMeta,
        ),
      );
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
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gridSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grid_size'],
      )!,
      phraseBarEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}phrase_bar_enabled'],
      )!,
      nestedCategories: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}nested_categories'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String name;
  final int gridSize;
  final bool phraseBarEnabled;
  final bool nestedCategories;
  final DateTime createdAt;
  const Profile({
    required this.id,
    required this.name,
    required this.gridSize,
    required this.phraseBarEnabled,
    required this.nestedCategories,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['grid_size'] = Variable<int>(gridSize);
    map['phrase_bar_enabled'] = Variable<bool>(phraseBarEnabled);
    map['nested_categories'] = Variable<bool>(nestedCategories);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      gridSize: Value(gridSize),
      phraseBarEnabled: Value(phraseBarEnabled),
      nestedCategories: Value(nestedCategories),
      createdAt: Value(createdAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gridSize: serializer.fromJson<int>(json['gridSize']),
      phraseBarEnabled: serializer.fromJson<bool>(json['phraseBarEnabled']),
      nestedCategories: serializer.fromJson<bool>(json['nestedCategories']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'gridSize': serializer.toJson<int>(gridSize),
      'phraseBarEnabled': serializer.toJson<bool>(phraseBarEnabled),
      'nestedCategories': serializer.toJson<bool>(nestedCategories),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Profile copyWith({
    int? id,
    String? name,
    int? gridSize,
    bool? phraseBarEnabled,
    bool? nestedCategories,
    DateTime? createdAt,
  }) => Profile(
    id: id ?? this.id,
    name: name ?? this.name,
    gridSize: gridSize ?? this.gridSize,
    phraseBarEnabled: phraseBarEnabled ?? this.phraseBarEnabled,
    nestedCategories: nestedCategories ?? this.nestedCategories,
    createdAt: createdAt ?? this.createdAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gridSize: data.gridSize.present ? data.gridSize.value : this.gridSize,
      phraseBarEnabled: data.phraseBarEnabled.present
          ? data.phraseBarEnabled.value
          : this.phraseBarEnabled,
      nestedCategories: data.nestedCategories.present
          ? data.nestedCategories.value
          : this.nestedCategories,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gridSize: $gridSize, ')
          ..write('phraseBarEnabled: $phraseBarEnabled, ')
          ..write('nestedCategories: $nestedCategories, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    gridSize,
    phraseBarEnabled,
    nestedCategories,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.name == this.name &&
          other.gridSize == this.gridSize &&
          other.phraseBarEnabled == this.phraseBarEnabled &&
          other.nestedCategories == this.nestedCategories &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> gridSize;
  final Value<bool> phraseBarEnabled;
  final Value<bool> nestedCategories;
  final Value<DateTime> createdAt;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gridSize = const Value.absent(),
    this.phraseBarEnabled = const Value.absent(),
    this.nestedCategories = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.gridSize = const Value.absent(),
    this.phraseBarEnabled = const Value.absent(),
    this.nestedCategories = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? gridSize,
    Expression<bool>? phraseBarEnabled,
    Expression<bool>? nestedCategories,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gridSize != null) 'grid_size': gridSize,
      if (phraseBarEnabled != null) 'phrase_bar_enabled': phraseBarEnabled,
      if (nestedCategories != null) 'nested_categories': nestedCategories,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? gridSize,
    Value<bool>? phraseBarEnabled,
    Value<bool>? nestedCategories,
    Value<DateTime>? createdAt,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gridSize: gridSize ?? this.gridSize,
      phraseBarEnabled: phraseBarEnabled ?? this.phraseBarEnabled,
      nestedCategories: nestedCategories ?? this.nestedCategories,
      createdAt: createdAt ?? this.createdAt,
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
    if (gridSize.present) {
      map['grid_size'] = Variable<int>(gridSize.value);
    }
    if (phraseBarEnabled.present) {
      map['phrase_bar_enabled'] = Variable<bool>(phraseBarEnabled.value);
    }
    if (nestedCategories.present) {
      map['nested_categories'] = Variable<bool>(nestedCategories.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gridSize: $gridSize, ')
          ..write('phraseBarEnabled: $phraseBarEnabled, ')
          ..write('nestedCategories: $nestedCategories, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameEsMeta = const VerificationMeta('nameEs');
  @override
  late final GeneratedColumn<String> nameEs = GeneratedColumn<String>(
    'name_es',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, nameEs, colorHex, isCustom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('name_es')) {
      context.handle(
        _nameEsMeta,
        nameEs.isAcceptableOrUnknown(data['name_es']!, _nameEsMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEsMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      nameEs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_es'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String key;
  final String nameEs;
  final String colorHex;
  final bool isCustom;
  const Category({
    required this.id,
    required this.key,
    required this.nameEs,
    required this.colorHex,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['name_es'] = Variable<String>(nameEs);
    map['color_hex'] = Variable<String>(colorHex);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      key: Value(key),
      nameEs: Value(nameEs),
      colorHex: Value(colorHex),
      isCustom: Value(isCustom),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      nameEs: serializer.fromJson<String>(json['nameEs']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'nameEs': serializer.toJson<String>(nameEs),
      'colorHex': serializer.toJson<String>(colorHex),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  Category copyWith({
    int? id,
    String? key,
    String? nameEs,
    String? colorHex,
    bool? isCustom,
  }) => Category(
    id: id ?? this.id,
    key: key ?? this.key,
    nameEs: nameEs ?? this.nameEs,
    colorHex: colorHex ?? this.colorHex,
    isCustom: isCustom ?? this.isCustom,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      nameEs: data.nameEs.present ? data.nameEs.value : this.nameEs,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('nameEs: $nameEs, ')
          ..write('colorHex: $colorHex, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, nameEs, colorHex, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.key == this.key &&
          other.nameEs == this.nameEs &&
          other.colorHex == this.colorHex &&
          other.isCustom == this.isCustom);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> nameEs;
  final Value<String> colorHex;
  final Value<bool> isCustom;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.nameEs = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String nameEs,
    required String colorHex,
    this.isCustom = const Value.absent(),
  }) : key = Value(key),
       nameEs = Value(nameEs),
       colorHex = Value(colorHex);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? nameEs,
    Expression<String>? colorHex,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (nameEs != null) 'name_es': nameEs,
      if (colorHex != null) 'color_hex': colorHex,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? nameEs,
    Value<String>? colorHex,
    Value<bool>? isCustom,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      nameEs: nameEs ?? this.nameEs,
      colorHex: colorHex ?? this.colorHex,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (nameEs.present) {
      map['name_es'] = Variable<String>(nameEs.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('nameEs: $nameEs, ')
          ..write('colorHex: $colorHex, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $PictogramsTable extends Pictograms
    with TableInfo<$PictogramsTable, Pictogram> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PictogramsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _arasaacIdMeta = const VerificationMeta(
    'arasaacId',
  );
  @override
  late final GeneratedColumn<int> arasaacId = GeneratedColumn<int>(
    'arasaac_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labelEsMeta = const VerificationMeta(
    'labelEs',
  );
  @override
  late final GeneratedColumn<String> labelEs = GeneratedColumn<String>(
    'label_es',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _assetPathMeta = const VerificationMeta(
    'assetPath',
  );
  @override
  late final GeneratedColumn<String> assetPath = GeneratedColumn<String>(
    'asset_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    arasaacId,
    labelEs,
    categoryId,
    assetPath,
    photoPath,
    audioPath,
    colorHex,
    isCustom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pictograms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pictogram> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('arasaac_id')) {
      context.handle(
        _arasaacIdMeta,
        arasaacId.isAcceptableOrUnknown(data['arasaac_id']!, _arasaacIdMeta),
      );
    }
    if (data.containsKey('label_es')) {
      context.handle(
        _labelEsMeta,
        labelEs.isAcceptableOrUnknown(data['label_es']!, _labelEsMeta),
      );
    } else if (isInserting) {
      context.missing(_labelEsMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('asset_path')) {
      context.handle(
        _assetPathMeta,
        assetPath.isAcceptableOrUnknown(data['asset_path']!, _assetPathMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pictogram map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pictogram(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      arasaacId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}arasaac_id'],
      ),
      labelEs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label_es'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      assetPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_path'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $PictogramsTable createAlias(String alias) {
    return $PictogramsTable(attachedDatabase, alias);
  }
}

class Pictogram extends DataClass implements Insertable<Pictogram> {
  final int id;
  final int? arasaacId;
  final String labelEs;
  final int categoryId;
  final String? assetPath;
  final String? photoPath;
  final String? audioPath;
  final String? colorHex;
  final bool isCustom;
  const Pictogram({
    required this.id,
    this.arasaacId,
    required this.labelEs,
    required this.categoryId,
    this.assetPath,
    this.photoPath,
    this.audioPath,
    this.colorHex,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || arasaacId != null) {
      map['arasaac_id'] = Variable<int>(arasaacId);
    }
    map['label_es'] = Variable<String>(labelEs);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || assetPath != null) {
      map['asset_path'] = Variable<String>(assetPath);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  PictogramsCompanion toCompanion(bool nullToAbsent) {
    return PictogramsCompanion(
      id: Value(id),
      arasaacId: arasaacId == null && nullToAbsent
          ? const Value.absent()
          : Value(arasaacId),
      labelEs: Value(labelEs),
      categoryId: Value(categoryId),
      assetPath: assetPath == null && nullToAbsent
          ? const Value.absent()
          : Value(assetPath),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      isCustom: Value(isCustom),
    );
  }

  factory Pictogram.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pictogram(
      id: serializer.fromJson<int>(json['id']),
      arasaacId: serializer.fromJson<int?>(json['arasaacId']),
      labelEs: serializer.fromJson<String>(json['labelEs']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      assetPath: serializer.fromJson<String?>(json['assetPath']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'arasaacId': serializer.toJson<int?>(arasaacId),
      'labelEs': serializer.toJson<String>(labelEs),
      'categoryId': serializer.toJson<int>(categoryId),
      'assetPath': serializer.toJson<String?>(assetPath),
      'photoPath': serializer.toJson<String?>(photoPath),
      'audioPath': serializer.toJson<String?>(audioPath),
      'colorHex': serializer.toJson<String?>(colorHex),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  Pictogram copyWith({
    int? id,
    Value<int?> arasaacId = const Value.absent(),
    String? labelEs,
    int? categoryId,
    Value<String?> assetPath = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
    Value<String?> colorHex = const Value.absent(),
    bool? isCustom,
  }) => Pictogram(
    id: id ?? this.id,
    arasaacId: arasaacId.present ? arasaacId.value : this.arasaacId,
    labelEs: labelEs ?? this.labelEs,
    categoryId: categoryId ?? this.categoryId,
    assetPath: assetPath.present ? assetPath.value : this.assetPath,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    isCustom: isCustom ?? this.isCustom,
  );
  Pictogram copyWithCompanion(PictogramsCompanion data) {
    return Pictogram(
      id: data.id.present ? data.id.value : this.id,
      arasaacId: data.arasaacId.present ? data.arasaacId.value : this.arasaacId,
      labelEs: data.labelEs.present ? data.labelEs.value : this.labelEs,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      assetPath: data.assetPath.present ? data.assetPath.value : this.assetPath,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pictogram(')
          ..write('id: $id, ')
          ..write('arasaacId: $arasaacId, ')
          ..write('labelEs: $labelEs, ')
          ..write('categoryId: $categoryId, ')
          ..write('assetPath: $assetPath, ')
          ..write('photoPath: $photoPath, ')
          ..write('audioPath: $audioPath, ')
          ..write('colorHex: $colorHex, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    arasaacId,
    labelEs,
    categoryId,
    assetPath,
    photoPath,
    audioPath,
    colorHex,
    isCustom,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pictogram &&
          other.id == this.id &&
          other.arasaacId == this.arasaacId &&
          other.labelEs == this.labelEs &&
          other.categoryId == this.categoryId &&
          other.assetPath == this.assetPath &&
          other.photoPath == this.photoPath &&
          other.audioPath == this.audioPath &&
          other.colorHex == this.colorHex &&
          other.isCustom == this.isCustom);
}

class PictogramsCompanion extends UpdateCompanion<Pictogram> {
  final Value<int> id;
  final Value<int?> arasaacId;
  final Value<String> labelEs;
  final Value<int> categoryId;
  final Value<String?> assetPath;
  final Value<String?> photoPath;
  final Value<String?> audioPath;
  final Value<String?> colorHex;
  final Value<bool> isCustom;
  const PictogramsCompanion({
    this.id = const Value.absent(),
    this.arasaacId = const Value.absent(),
    this.labelEs = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.assetPath = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  PictogramsCompanion.insert({
    this.id = const Value.absent(),
    this.arasaacId = const Value.absent(),
    required String labelEs,
    required int categoryId,
    this.assetPath = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isCustom = const Value.absent(),
  }) : labelEs = Value(labelEs),
       categoryId = Value(categoryId);
  static Insertable<Pictogram> custom({
    Expression<int>? id,
    Expression<int>? arasaacId,
    Expression<String>? labelEs,
    Expression<int>? categoryId,
    Expression<String>? assetPath,
    Expression<String>? photoPath,
    Expression<String>? audioPath,
    Expression<String>? colorHex,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (arasaacId != null) 'arasaac_id': arasaacId,
      if (labelEs != null) 'label_es': labelEs,
      if (categoryId != null) 'category_id': categoryId,
      if (assetPath != null) 'asset_path': assetPath,
      if (photoPath != null) 'photo_path': photoPath,
      if (audioPath != null) 'audio_path': audioPath,
      if (colorHex != null) 'color_hex': colorHex,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  PictogramsCompanion copyWith({
    Value<int>? id,
    Value<int?>? arasaacId,
    Value<String>? labelEs,
    Value<int>? categoryId,
    Value<String?>? assetPath,
    Value<String?>? photoPath,
    Value<String?>? audioPath,
    Value<String?>? colorHex,
    Value<bool>? isCustom,
  }) {
    return PictogramsCompanion(
      id: id ?? this.id,
      arasaacId: arasaacId ?? this.arasaacId,
      labelEs: labelEs ?? this.labelEs,
      categoryId: categoryId ?? this.categoryId,
      assetPath: assetPath ?? this.assetPath,
      photoPath: photoPath ?? this.photoPath,
      audioPath: audioPath ?? this.audioPath,
      colorHex: colorHex ?? this.colorHex,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (arasaacId.present) {
      map['arasaac_id'] = Variable<int>(arasaacId.value);
    }
    if (labelEs.present) {
      map['label_es'] = Variable<String>(labelEs.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (assetPath.present) {
      map['asset_path'] = Variable<String>(assetPath.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PictogramsCompanion(')
          ..write('id: $id, ')
          ..write('arasaacId: $arasaacId, ')
          ..write('labelEs: $labelEs, ')
          ..write('categoryId: $categoryId, ')
          ..write('assetPath: $assetPath, ')
          ..write('photoPath: $photoPath, ')
          ..write('audioPath: $audioPath, ')
          ..write('colorHex: $colorHex, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $BoardItemsTable extends BoardItems
    with TableInfo<$BoardItemsTable, BoardItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BoardItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _pictogramIdMeta = const VerificationMeta(
    'pictogramId',
  );
  @override
  late final GeneratedColumn<int> pictogramId = GeneratedColumn<int>(
    'pictogram_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pictograms (id)',
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
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("hidden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    categoryId,
    pictogramId,
    position,
    hidden,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'board_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<BoardItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('pictogram_id')) {
      context.handle(
        _pictogramIdMeta,
        pictogramId.isAcceptableOrUnknown(
          data['pictogram_id']!,
          _pictogramIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pictogramIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('hidden')) {
      context.handle(
        _hiddenMeta,
        hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, categoryId, position},
  ];
  @override
  BoardItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BoardItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      pictogramId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pictogram_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hidden'],
      )!,
    );
  }

  @override
  $BoardItemsTable createAlias(String alias) {
    return $BoardItemsTable(attachedDatabase, alias);
  }
}

class BoardItem extends DataClass implements Insertable<BoardItem> {
  final int id;
  final int profileId;
  final int? categoryId;
  final int pictogramId;
  final int position;
  final bool hidden;
  const BoardItem({
    required this.id,
    required this.profileId,
    this.categoryId,
    required this.pictogramId,
    required this.position,
    required this.hidden,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['pictogram_id'] = Variable<int>(pictogramId);
    map['position'] = Variable<int>(position);
    map['hidden'] = Variable<bool>(hidden);
    return map;
  }

  BoardItemsCompanion toCompanion(bool nullToAbsent) {
    return BoardItemsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      pictogramId: Value(pictogramId),
      position: Value(position),
      hidden: Value(hidden),
    );
  }

  factory BoardItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BoardItem(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      pictogramId: serializer.fromJson<int>(json['pictogramId']),
      position: serializer.fromJson<int>(json['position']),
      hidden: serializer.fromJson<bool>(json['hidden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'pictogramId': serializer.toJson<int>(pictogramId),
      'position': serializer.toJson<int>(position),
      'hidden': serializer.toJson<bool>(hidden),
    };
  }

  BoardItem copyWith({
    int? id,
    int? profileId,
    Value<int?> categoryId = const Value.absent(),
    int? pictogramId,
    int? position,
    bool? hidden,
  }) => BoardItem(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    pictogramId: pictogramId ?? this.pictogramId,
    position: position ?? this.position,
    hidden: hidden ?? this.hidden,
  );
  BoardItem copyWithCompanion(BoardItemsCompanion data) {
    return BoardItem(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      pictogramId: data.pictogramId.present
          ? data.pictogramId.value
          : this.pictogramId,
      position: data.position.present ? data.position.value : this.position,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BoardItem(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('categoryId: $categoryId, ')
          ..write('pictogramId: $pictogramId, ')
          ..write('position: $position, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, categoryId, pictogramId, position, hidden);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BoardItem &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.categoryId == this.categoryId &&
          other.pictogramId == this.pictogramId &&
          other.position == this.position &&
          other.hidden == this.hidden);
}

class BoardItemsCompanion extends UpdateCompanion<BoardItem> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<int?> categoryId;
  final Value<int> pictogramId;
  final Value<int> position;
  final Value<bool> hidden;
  const BoardItemsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.pictogramId = const Value.absent(),
    this.position = const Value.absent(),
    this.hidden = const Value.absent(),
  });
  BoardItemsCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    this.categoryId = const Value.absent(),
    required int pictogramId,
    required int position,
    this.hidden = const Value.absent(),
  }) : profileId = Value(profileId),
       pictogramId = Value(pictogramId),
       position = Value(position);
  static Insertable<BoardItem> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<int>? categoryId,
    Expression<int>? pictogramId,
    Expression<int>? position,
    Expression<bool>? hidden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (categoryId != null) 'category_id': categoryId,
      if (pictogramId != null) 'pictogram_id': pictogramId,
      if (position != null) 'position': position,
      if (hidden != null) 'hidden': hidden,
    });
  }

  BoardItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<int?>? categoryId,
    Value<int>? pictogramId,
    Value<int>? position,
    Value<bool>? hidden,
  }) {
    return BoardItemsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      categoryId: categoryId ?? this.categoryId,
      pictogramId: pictogramId ?? this.pictogramId,
      position: position ?? this.position,
      hidden: hidden ?? this.hidden,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (pictogramId.present) {
      map['pictogram_id'] = Variable<int>(pictogramId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BoardItemsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('categoryId: $categoryId, ')
          ..write('pictogramId: $pictogramId, ')
          ..write('position: $position, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }
}

class $ProfileCategoriesTable extends ProfileCategories
    with TableInfo<$ProfileCategoriesTable, ProfileCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileCategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
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
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("hidden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    categoryId,
    position,
    hidden,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('hidden')) {
      context.handle(
        _hiddenMeta,
        hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {profileId, categoryId},
  ];
  @override
  ProfileCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hidden'],
      )!,
    );
  }

  @override
  $ProfileCategoriesTable createAlias(String alias) {
    return $ProfileCategoriesTable(attachedDatabase, alias);
  }
}

class ProfileCategory extends DataClass implements Insertable<ProfileCategory> {
  final int id;
  final int profileId;
  final int categoryId;
  final int position;
  final bool hidden;
  const ProfileCategory({
    required this.id,
    required this.profileId,
    required this.categoryId,
    required this.position,
    required this.hidden,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['category_id'] = Variable<int>(categoryId);
    map['position'] = Variable<int>(position);
    map['hidden'] = Variable<bool>(hidden);
    return map;
  }

  ProfileCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ProfileCategoriesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      categoryId: Value(categoryId),
      position: Value(position),
      hidden: Value(hidden),
    );
  }

  factory ProfileCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileCategory(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      position: serializer.fromJson<int>(json['position']),
      hidden: serializer.fromJson<bool>(json['hidden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<int>(profileId),
      'categoryId': serializer.toJson<int>(categoryId),
      'position': serializer.toJson<int>(position),
      'hidden': serializer.toJson<bool>(hidden),
    };
  }

  ProfileCategory copyWith({
    int? id,
    int? profileId,
    int? categoryId,
    int? position,
    bool? hidden,
  }) => ProfileCategory(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    categoryId: categoryId ?? this.categoryId,
    position: position ?? this.position,
    hidden: hidden ?? this.hidden,
  );
  ProfileCategory copyWithCompanion(ProfileCategoriesCompanion data) {
    return ProfileCategory(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      position: data.position.present ? data.position.value : this.position,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileCategory(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('categoryId: $categoryId, ')
          ..write('position: $position, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, categoryId, position, hidden);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileCategory &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.categoryId == this.categoryId &&
          other.position == this.position &&
          other.hidden == this.hidden);
}

class ProfileCategoriesCompanion extends UpdateCompanion<ProfileCategory> {
  final Value<int> id;
  final Value<int> profileId;
  final Value<int> categoryId;
  final Value<int> position;
  final Value<bool> hidden;
  const ProfileCategoriesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.position = const Value.absent(),
    this.hidden = const Value.absent(),
  });
  ProfileCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int profileId,
    required int categoryId,
    required int position,
    this.hidden = const Value.absent(),
  }) : profileId = Value(profileId),
       categoryId = Value(categoryId),
       position = Value(position);
  static Insertable<ProfileCategory> custom({
    Expression<int>? id,
    Expression<int>? profileId,
    Expression<int>? categoryId,
    Expression<int>? position,
    Expression<bool>? hidden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (categoryId != null) 'category_id': categoryId,
      if (position != null) 'position': position,
      if (hidden != null) 'hidden': hidden,
    });
  }

  ProfileCategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? profileId,
    Value<int>? categoryId,
    Value<int>? position,
    Value<bool>? hidden,
  }) {
    return ProfileCategoriesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      categoryId: categoryId ?? this.categoryId,
      position: position ?? this.position,
      hidden: hidden ?? this.hidden,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('categoryId: $categoryId, ')
          ..write('position: $position, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $PictogramsTable pictograms = $PictogramsTable(this);
  late final $BoardItemsTable boardItems = $BoardItemsTable(this);
  late final $ProfileCategoriesTable profileCategories =
      $ProfileCategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    categories,
    pictograms,
    boardItems,
    profileCategories,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  required String name,
  Value<int> gridSize,
  Value<bool> phraseBarEnabled,
  Value<bool> nestedCategories,
  Value<DateTime> createdAt,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> gridSize,
  Value<bool> phraseBarEnabled,
  Value<bool> nestedCategories,
  Value<DateTime> createdAt,
});

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, Profile> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BoardItemsTable, List<BoardItem>>
  _boardItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.boardItems,
    aliasName: 'profiles__id__board_items__profile_id',
  );

  $$BoardItemsTableProcessedTableManager get boardItemsRefs {
    final manager = $$BoardItemsTableTableManager(
      $_db,
      $_db.boardItems,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_boardItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProfileCategoriesTable, List<ProfileCategory>>
  _profileCategoriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.profileCategories,
        aliasName: 'profiles__id__profile_categories__profile_id',
      );

  $$ProfileCategoriesTableProcessedTableManager get profileCategoriesRefs {
    final manager = $$ProfileCategoriesTableTableManager(
      $_db,
      $_db.profileCategories,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _profileCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
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

  ColumnFilters<int> get gridSize => $composableBuilder(
    column: $table.gridSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get phraseBarEnabled => $composableBuilder(
    column: $table.phraseBarEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get nestedCategories => $composableBuilder(
    column: $table.nestedCategories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> boardItemsRefs(
    Expression<bool> Function($$BoardItemsTableFilterComposer f) f,
  ) {
    final $$BoardItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.boardItems,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardItemsTableFilterComposer(
            $db: $db,
            $table: $db.boardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> profileCategoriesRefs(
    Expression<bool> Function($$ProfileCategoriesTableFilterComposer f) f,
  ) {
    final $$ProfileCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.profileCategories,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.profileCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
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

  ColumnOrderings<int> get gridSize => $composableBuilder(
    column: $table.gridSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get phraseBarEnabled => $composableBuilder(
    column: $table.phraseBarEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get nestedCategories => $composableBuilder(
    column: $table.nestedCategories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
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

  GeneratedColumn<int> get gridSize =>
      $composableBuilder(column: $table.gridSize, builder: (column) => column);

  GeneratedColumn<bool> get phraseBarEnabled => $composableBuilder(
    column: $table.phraseBarEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get nestedCategories => $composableBuilder(
    column: $table.nestedCategories,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> boardItemsRefs<T extends Object>(
    Expression<T> Function($$BoardItemsTableAnnotationComposer a) f,
  ) {
    final $$BoardItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.boardItems,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.boardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> profileCategoriesRefs<T extends Object>(
    Expression<T> Function($$ProfileCategoriesTableAnnotationComposer a) f,
  ) {
    final $$ProfileCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.profileCategories,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProfileCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.profileCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, $$ProfilesTableReferences),
          Profile,
          PrefetchHooks Function({
            bool boardItemsRefs,
            bool profileCategoriesRefs,
          })
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> gridSize = const Value.absent(),
                Value<bool> phraseBarEnabled = const Value.absent(),
                Value<bool> nestedCategories = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                gridSize: gridSize,
                phraseBarEnabled: phraseBarEnabled,
                nestedCategories: nestedCategories,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> gridSize = const Value.absent(),
                Value<bool> phraseBarEnabled = const Value.absent(),
                Value<bool> nestedCategories = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                gridSize: gridSize,
                phraseBarEnabled: phraseBarEnabled,
                nestedCategories: nestedCategories,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({boardItemsRefs = false, profileCategoriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (boardItemsRefs) db.boardItems,
                    if (profileCategoriesRefs) db.profileCategories,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (boardItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          Profile,
                          $ProfilesTable,
                          BoardItem,
                          $BoardItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._boardItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).boardItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (profileCategoriesRefs)
                        await $_getPrefetchedDataByColumns<
                          Profile,
                          $ProfilesTable,
                          ProfileCategory,
                          $ProfileCategoriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._profileCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).profileCategoriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, $$ProfilesTableReferences),
      Profile,
      PrefetchHooks Function({bool boardItemsRefs, bool profileCategoriesRefs})
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String key,
  required String nameEs,
  required String colorHex,
  Value<bool> isCustom,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> key,
  Value<String> nameEs,
  Value<String> colorHex,
  Value<bool> isCustom,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PictogramsTable, List<Pictogram>>
  _pictogramsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pictograms,
    aliasName: 'categories__id__pictograms__category_id',
  );

  $$PictogramsTableProcessedTableManager get pictogramsRefs {
    final manager = $$PictogramsTableTableManager(
      $_db,
      $_db.pictograms,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pictogramsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BoardItemsTable, List<BoardItem>>
  _boardItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.boardItems,
    aliasName: 'categories__id__board_items__category_id',
  );

  $$BoardItemsTableProcessedTableManager get boardItemsRefs {
    final manager = $$BoardItemsTableTableManager(
      $_db,
      $_db.boardItems,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_boardItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProfileCategoriesTable, List<ProfileCategory>>
  _profileCategoriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.profileCategories,
        aliasName: 'categories__id__profile_categories__category_id',
      );

  $$ProfileCategoriesTableProcessedTableManager get profileCategoriesRefs {
    final manager = $$ProfileCategoriesTableTableManager(
      $_db,
      $_db.profileCategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _profileCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEs => $composableBuilder(
    column: $table.nameEs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> pictogramsRefs(
    Expression<bool> Function($$PictogramsTableFilterComposer f) f,
  ) {
    final $$PictogramsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pictograms,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PictogramsTableFilterComposer(
            $db: $db,
            $table: $db.pictograms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> boardItemsRefs(
    Expression<bool> Function($$BoardItemsTableFilterComposer f) f,
  ) {
    final $$BoardItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.boardItems,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardItemsTableFilterComposer(
            $db: $db,
            $table: $db.boardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> profileCategoriesRefs(
    Expression<bool> Function($$ProfileCategoriesTableFilterComposer f) f,
  ) {
    final $$ProfileCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.profileCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.profileCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEs => $composableBuilder(
    column: $table.nameEs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get nameEs =>
      $composableBuilder(column: $table.nameEs, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  Expression<T> pictogramsRefs<T extends Object>(
    Expression<T> Function($$PictogramsTableAnnotationComposer a) f,
  ) {
    final $$PictogramsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pictograms,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PictogramsTableAnnotationComposer(
            $db: $db,
            $table: $db.pictograms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> boardItemsRefs<T extends Object>(
    Expression<T> Function($$BoardItemsTableAnnotationComposer a) f,
  ) {
    final $$BoardItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.boardItems,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.boardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> profileCategoriesRefs<T extends Object>(
    Expression<T> Function($$ProfileCategoriesTableAnnotationComposer a) f,
  ) {
    final $$ProfileCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.profileCategories,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProfileCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.profileCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({
            bool pictogramsRefs,
            bool boardItemsRefs,
            bool profileCategoriesRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> nameEs = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                key: key,
                nameEs: nameEs,
                colorHex: colorHex,
                isCustom: isCustom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String nameEs,
                required String colorHex,
                Value<bool> isCustom = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                key: key,
                nameEs: nameEs,
                colorHex: colorHex,
                isCustom: isCustom,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                pictogramsRefs = false,
                boardItemsRefs = false,
                profileCategoriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (pictogramsRefs) db.pictograms,
                    if (boardItemsRefs) db.boardItems,
                    if (profileCategoriesRefs) db.profileCategories,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (pictogramsRefs)
                        await $_getPrefetchedDataByColumns<
                          Category,
                          $CategoriesTable,
                          Pictogram,
                          $PictogramsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._pictogramsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).pictogramsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (boardItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          Category,
                          $CategoriesTable,
                          BoardItem,
                          $BoardItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._boardItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).boardItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (profileCategoriesRefs)
                        await $_getPrefetchedDataByColumns<
                          Category,
                          $CategoriesTable,
                          ProfileCategory,
                          $ProfileCategoriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._profileCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).profileCategoriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({
        bool pictogramsRefs,
        bool boardItemsRefs,
        bool profileCategoriesRefs,
      })
    >;
typedef $$PictogramsTableCreateCompanionBuilder = PictogramsCompanion Function({
  Value<int> id,
  Value<int?> arasaacId,
  required String labelEs,
  required int categoryId,
  Value<String?> assetPath,
  Value<String?> photoPath,
  Value<String?> audioPath,
  Value<String?> colorHex,
  Value<bool> isCustom,
});
typedef $$PictogramsTableUpdateCompanionBuilder = PictogramsCompanion Function({
  Value<int> id,
  Value<int?> arasaacId,
  Value<String> labelEs,
  Value<int> categoryId,
  Value<String?> assetPath,
  Value<String?> photoPath,
  Value<String?> audioPath,
  Value<String?> colorHex,
  Value<bool> isCustom,
});

final class $$PictogramsTableReferences
    extends BaseReferences<_$AppDatabase, $PictogramsTable, Pictogram> {
  $$PictogramsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('pictograms__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BoardItemsTable, List<BoardItem>>
  _boardItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.boardItems,
    aliasName: 'pictograms__id__board_items__pictogram_id',
  );

  $$BoardItemsTableProcessedTableManager get boardItemsRefs {
    final manager = $$BoardItemsTableTableManager(
      $_db,
      $_db.boardItems,
    ).filter((f) => f.pictogramId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_boardItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PictogramsTableFilterComposer
    extends Composer<_$AppDatabase, $PictogramsTable> {
  $$PictogramsTableFilterComposer({
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

  ColumnFilters<int> get arasaacId => $composableBuilder(
    column: $table.arasaacId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get labelEs => $composableBuilder(
    column: $table.labelEs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetPath => $composableBuilder(
    column: $table.assetPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> boardItemsRefs(
    Expression<bool> Function($$BoardItemsTableFilterComposer f) f,
  ) {
    final $$BoardItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.boardItems,
      getReferencedColumn: (t) => t.pictogramId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardItemsTableFilterComposer(
            $db: $db,
            $table: $db.boardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PictogramsTableOrderingComposer
    extends Composer<_$AppDatabase, $PictogramsTable> {
  $$PictogramsTableOrderingComposer({
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

  ColumnOrderings<int> get arasaacId => $composableBuilder(
    column: $table.arasaacId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labelEs => $composableBuilder(
    column: $table.labelEs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetPath => $composableBuilder(
    column: $table.assetPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PictogramsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PictogramsTable> {
  $$PictogramsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get arasaacId =>
      $composableBuilder(column: $table.arasaacId, builder: (column) => column);

  GeneratedColumn<String> get labelEs =>
      $composableBuilder(column: $table.labelEs, builder: (column) => column);

  GeneratedColumn<String> get assetPath =>
      $composableBuilder(column: $table.assetPath, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> boardItemsRefs<T extends Object>(
    Expression<T> Function($$BoardItemsTableAnnotationComposer a) f,
  ) {
    final $$BoardItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.boardItems,
      getReferencedColumn: (t) => t.pictogramId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.boardItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PictogramsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PictogramsTable,
          Pictogram,
          $$PictogramsTableFilterComposer,
          $$PictogramsTableOrderingComposer,
          $$PictogramsTableAnnotationComposer,
          $$PictogramsTableCreateCompanionBuilder,
          $$PictogramsTableUpdateCompanionBuilder,
          (Pictogram, $$PictogramsTableReferences),
          Pictogram,
          PrefetchHooks Function({bool categoryId, bool boardItemsRefs})
        > {
  $$PictogramsTableTableManager(_$AppDatabase db, $PictogramsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PictogramsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PictogramsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PictogramsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> arasaacId = const Value.absent(),
                Value<String> labelEs = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String?> assetPath = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => PictogramsCompanion(
                id: id,
                arasaacId: arasaacId,
                labelEs: labelEs,
                categoryId: categoryId,
                assetPath: assetPath,
                photoPath: photoPath,
                audioPath: audioPath,
                colorHex: colorHex,
                isCustom: isCustom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> arasaacId = const Value.absent(),
                required String labelEs,
                required int categoryId,
                Value<String?> assetPath = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => PictogramsCompanion.insert(
                id: id,
                arasaacId: arasaacId,
                labelEs: labelEs,
                categoryId: categoryId,
                assetPath: assetPath,
                photoPath: photoPath,
                audioPath: audioPath,
                colorHex: colorHex,
                isCustom: isCustom,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PictogramsTable, Pictogram>(table),
                  $$PictogramsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, boardItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (boardItemsRefs) db.boardItems],
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
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$PictogramsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$PictogramsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (boardItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          Pictogram,
                          $PictogramsTable,
                          BoardItem,
                          $BoardItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PictogramsTableReferences
                              ._boardItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PictogramsTableReferences(
                                db,
                                table,
                                p0,
                              ).boardItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'pictogram_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PictogramsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PictogramsTable,
      Pictogram,
      $$PictogramsTableFilterComposer,
      $$PictogramsTableOrderingComposer,
      $$PictogramsTableAnnotationComposer,
      $$PictogramsTableCreateCompanionBuilder,
      $$PictogramsTableUpdateCompanionBuilder,
      (Pictogram, $$PictogramsTableReferences),
      Pictogram,
      PrefetchHooks Function({bool categoryId, bool boardItemsRefs})
    >;
typedef $$BoardItemsTableCreateCompanionBuilder = BoardItemsCompanion Function({
  Value<int> id,
  required int profileId,
  Value<int?> categoryId,
  required int pictogramId,
  required int position,
  Value<bool> hidden,
});
typedef $$BoardItemsTableUpdateCompanionBuilder = BoardItemsCompanion Function({
  Value<int> id,
  Value<int> profileId,
  Value<int?> categoryId,
  Value<int> pictogramId,
  Value<int> position,
  Value<bool> hidden,
});

final class $$BoardItemsTableReferences
    extends BaseReferences<_$AppDatabase, $BoardItemsTable, BoardItem> {
  $$BoardItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('board_items__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('board_items__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PictogramsTable _pictogramIdTable(_$AppDatabase db) =>
      db.pictograms.createAlias('board_items__pictogram_id__pictograms__id');

  $$PictogramsTableProcessedTableManager get pictogramId {
    final $_column = $_itemColumn<int>('pictogram_id')!;

    final manager = $$PictogramsTableTableManager(
      $_db,
      $_db.pictograms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pictogramIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BoardItemsTableFilterComposer
    extends Composer<_$AppDatabase, $BoardItemsTable> {
  $$BoardItemsTableFilterComposer({
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

  ColumnFilters<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PictogramsTableFilterComposer get pictogramId {
    final $$PictogramsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pictogramId,
      referencedTable: $db.pictograms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PictogramsTableFilterComposer(
            $db: $db,
            $table: $db.pictograms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BoardItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $BoardItemsTable> {
  $$BoardItemsTableOrderingComposer({
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

  ColumnOrderings<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PictogramsTableOrderingComposer get pictogramId {
    final $$PictogramsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pictogramId,
      referencedTable: $db.pictograms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PictogramsTableOrderingComposer(
            $db: $db,
            $table: $db.pictograms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BoardItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BoardItemsTable> {
  $$BoardItemsTableAnnotationComposer({
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

  GeneratedColumn<bool> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PictogramsTableAnnotationComposer get pictogramId {
    final $$PictogramsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pictogramId,
      referencedTable: $db.pictograms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PictogramsTableAnnotationComposer(
            $db: $db,
            $table: $db.pictograms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BoardItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BoardItemsTable,
          BoardItem,
          $$BoardItemsTableFilterComposer,
          $$BoardItemsTableOrderingComposer,
          $$BoardItemsTableAnnotationComposer,
          $$BoardItemsTableCreateCompanionBuilder,
          $$BoardItemsTableUpdateCompanionBuilder,
          (BoardItem, $$BoardItemsTableReferences),
          BoardItem,
          PrefetchHooks Function({
            bool profileId,
            bool categoryId,
            bool pictogramId,
          })
        > {
  $$BoardItemsTableTableManager(_$AppDatabase db, $BoardItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BoardItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BoardItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BoardItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int> pictogramId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
              }) => BoardItemsCompanion(
                id: id,
                profileId: profileId,
                categoryId: categoryId,
                pictogramId: pictogramId,
                position: position,
                hidden: hidden,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                Value<int?> categoryId = const Value.absent(),
                required int pictogramId,
                required int position,
                Value<bool> hidden = const Value.absent(),
              }) => BoardItemsCompanion.insert(
                id: id,
                profileId: profileId,
                categoryId: categoryId,
                pictogramId: pictogramId,
                position: position,
                hidden: hidden,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BoardItemsTable, BoardItem>(table),
                  $$BoardItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({profileId = false, categoryId = false, pictogramId = false}) {
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
                        if (profileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.profileId,
                            referencedTable: $$BoardItemsTableReferences
                                ._profileIdTable(db),
                            referencedColumn: $$BoardItemsTableReferences
                                ._profileIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$BoardItemsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$BoardItemsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (pictogramId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.pictogramId,
                            referencedTable: $$BoardItemsTableReferences
                                ._pictogramIdTable(db),
                            referencedColumn: $$BoardItemsTableReferences
                                ._pictogramIdTable(db)
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

typedef $$BoardItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BoardItemsTable,
      BoardItem,
      $$BoardItemsTableFilterComposer,
      $$BoardItemsTableOrderingComposer,
      $$BoardItemsTableAnnotationComposer,
      $$BoardItemsTableCreateCompanionBuilder,
      $$BoardItemsTableUpdateCompanionBuilder,
      (BoardItem, $$BoardItemsTableReferences),
      BoardItem,
      PrefetchHooks Function({
        bool profileId,
        bool categoryId,
        bool pictogramId,
      })
    >;
typedef $$ProfileCategoriesTableCreateCompanionBuilder =
    ProfileCategoriesCompanion Function({
      Value<int> id,
      required int profileId,
      required int categoryId,
      required int position,
      Value<bool> hidden,
    });
typedef $$ProfileCategoriesTableUpdateCompanionBuilder =
    ProfileCategoriesCompanion Function({
      Value<int> id,
      Value<int> profileId,
      Value<int> categoryId,
      Value<int> position,
      Value<bool> hidden,
    });

final class $$ProfileCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProfileCategoriesTable,
          ProfileCategory
        > {
  $$ProfileCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('profile_categories__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) => db.categories
      .createAlias('profile_categories__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProfileCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileCategoriesTable> {
  $$ProfileCategoriesTableFilterComposer({
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

  ColumnFilters<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileCategoriesTable> {
  $$ProfileCategoriesTableOrderingComposer({
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

  ColumnOrderings<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileCategoriesTable> {
  $$ProfileCategoriesTableAnnotationComposer({
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

  GeneratedColumn<bool> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileCategoriesTable,
          ProfileCategory,
          $$ProfileCategoriesTableFilterComposer,
          $$ProfileCategoriesTableOrderingComposer,
          $$ProfileCategoriesTableAnnotationComposer,
          $$ProfileCategoriesTableCreateCompanionBuilder,
          $$ProfileCategoriesTableUpdateCompanionBuilder,
          (ProfileCategory, $$ProfileCategoriesTableReferences),
          ProfileCategory,
          PrefetchHooks Function({bool profileId, bool categoryId})
        > {
  $$ProfileCategoriesTableTableManager(
    _$AppDatabase db,
    $ProfileCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
              }) => ProfileCategoriesCompanion(
                id: id,
                profileId: profileId,
                categoryId: categoryId,
                position: position,
                hidden: hidden,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int profileId,
                required int categoryId,
                required int position,
                Value<bool> hidden = const Value.absent(),
              }) => ProfileCategoriesCompanion.insert(
                id: id,
                profileId: profileId,
                categoryId: categoryId,
                position: position,
                hidden: hidden,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfileCategoriesTable, ProfileCategory>(table),
                  $$ProfileCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, categoryId = false}) {
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
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$ProfileCategoriesTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$ProfileCategoriesTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$ProfileCategoriesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$ProfileCategoriesTableReferences
                            ._categoryIdTable(db)
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

typedef $$ProfileCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileCategoriesTable,
      ProfileCategory,
      $$ProfileCategoriesTableFilterComposer,
      $$ProfileCategoriesTableOrderingComposer,
      $$ProfileCategoriesTableAnnotationComposer,
      $$ProfileCategoriesTableCreateCompanionBuilder,
      $$ProfileCategoriesTableUpdateCompanionBuilder,
      (ProfileCategory, $$ProfileCategoriesTableReferences),
      ProfileCategory,
      PrefetchHooks Function({bool profileId, bool categoryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$PictogramsTableTableManager get pictograms =>
      $$PictogramsTableTableManager(_db, _db.pictograms);
  $$BoardItemsTableTableManager get boardItems =>
      $$BoardItemsTableTableManager(_db, _db.boardItems);
  $$ProfileCategoriesTableTableManager get profileCategories =>
      $$ProfileCategoriesTableTableManager(_db, _db.profileCategories);
}
