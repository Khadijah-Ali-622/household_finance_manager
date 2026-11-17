// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WalletsTable extends Wallets with TableInfo<$WalletsTable, WalletRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PKR'),
  );
  static const VerificationMeta _openingBalanceMeta = const VerificationMeta(
    'openingBalance',
  );
  @override
  late final GeneratedColumn<int> openingBalance = GeneratedColumn<int>(
    'opening_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _isLiabilityTypeMeta = const VerificationMeta(
    'isLiabilityType',
  );
  @override
  late final GeneratedColumn<bool> isLiabilityType = GeneratedColumn<bool>(
    'is_liability_type',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_liability_type" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    color,
    currency,
    openingBalance,
    type,
    isLiabilityType,
    isArchived,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
        _openingBalanceMeta,
        openingBalance.isAcceptableOrUnknown(
          data['opening_balance']!,
          _openingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_liability_type')) {
      context.handle(
        _isLiabilityTypeMeta,
        isLiabilityType.isAcceptableOrUnknown(
          data['is_liability_type']!,
          _isLiabilityTypeMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  WalletRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      openingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isLiabilityType: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_liability_type'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }
}

class WalletRow extends DataClass implements Insertable<WalletRow> {
  final String id;
  final String name;
  final String icon;
  final int color;
  final String currency;
  final int openingBalance;
  final String type;
  final bool isLiabilityType;
  final bool isArchived;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const WalletRow({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.currency,
    required this.openingBalance,
    required this.type,
    required this.isLiabilityType,
    required this.isArchived,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['currency'] = Variable<String>(currency);
    map['opening_balance'] = Variable<int>(openingBalance);
    map['type'] = Variable<String>(type);
    map['is_liability_type'] = Variable<bool>(isLiabilityType);
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      currency: Value(currency),
      openingBalance: Value(openingBalance),
      type: Value(type),
      isLiabilityType: Value(isLiabilityType),
      isArchived: Value(isArchived),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WalletRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      currency: serializer.fromJson<String>(json['currency']),
      openingBalance: serializer.fromJson<int>(json['openingBalance']),
      type: serializer.fromJson<String>(json['type']),
      isLiabilityType: serializer.fromJson<bool>(json['isLiabilityType']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'currency': serializer.toJson<String>(currency),
      'openingBalance': serializer.toJson<int>(openingBalance),
      'type': serializer.toJson<String>(type),
      'isLiabilityType': serializer.toJson<bool>(isLiabilityType),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  WalletRow copyWith({
    String? id,
    String? name,
    String? icon,
    int? color,
    String? currency,
    int? openingBalance,
    String? type,
    bool? isLiabilityType,
    bool? isArchived,
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => WalletRow(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    currency: currency ?? this.currency,
    openingBalance: openingBalance ?? this.openingBalance,
    type: type ?? this.type,
    isLiabilityType: isLiabilityType ?? this.isLiabilityType,
    isArchived: isArchived ?? this.isArchived,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WalletRow copyWithCompanion(WalletsCompanion data) {
    return WalletRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      currency: data.currency.present ? data.currency.value : this.currency,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      type: data.type.present ? data.type.value : this.type,
      isLiabilityType: data.isLiabilityType.present
          ? data.isLiabilityType.value
          : this.isLiabilityType,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('currency: $currency, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('type: $type, ')
          ..write('isLiabilityType: $isLiabilityType, ')
          ..write('isArchived: $isArchived, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    icon,
    color,
    currency,
    openingBalance,
    type,
    isLiabilityType,
    isArchived,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.currency == this.currency &&
          other.openingBalance == this.openingBalance &&
          other.type == this.type &&
          other.isLiabilityType == this.isLiabilityType &&
          other.isArchived == this.isArchived &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WalletsCompanion extends UpdateCompanion<WalletRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> color;
  final Value<String> currency;
  final Value<int> openingBalance;
  final Value<String> type;
  final Value<bool> isLiabilityType;
  final Value<bool> isArchived;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const WalletsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.currency = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.type = const Value.absent(),
    this.isLiabilityType = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalletsCompanion.insert({
    required String id,
    required String name,
    required String icon,
    required int color,
    this.currency = const Value.absent(),
    this.openingBalance = const Value.absent(),
    required String type,
    this.isLiabilityType = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       icon = Value(icon),
       color = Value(color),
       type = Value(type),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WalletRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<String>? currency,
    Expression<int>? openingBalance,
    Expression<String>? type,
    Expression<bool>? isLiabilityType,
    Expression<bool>? isArchived,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (currency != null) 'currency': currency,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (type != null) 'type': type,
      if (isLiabilityType != null) 'is_liability_type': isLiabilityType,
      if (isArchived != null) 'is_archived': isArchived,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalletsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? color,
    Value<String>? currency,
    Value<int>? openingBalance,
    Value<String>? type,
    Value<bool>? isLiabilityType,
    Value<bool>? isArchived,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return WalletsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      currency: currency ?? this.currency,
      openingBalance: openingBalance ?? this.openingBalance,
      type: type ?? this.type,
      isLiabilityType: isLiabilityType ?? this.isLiabilityType,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<int>(openingBalance.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isLiabilityType.present) {
      map['is_liability_type'] = Variable<bool>(isLiabilityType.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('currency: $currency, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('type: $type, ')
          ..write('isLiabilityType: $isLiabilityType, ')
          ..write('isArchived: $isArchived, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    color,
    type,
    parentId,
    isDefault,
    sortOrder,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String name;
  final String icon;
  final int color;
  final String type;
  final String? parentId;
  final bool isDefault;
  final int sortOrder;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.parentId,
    required this.isDefault,
    required this.sortOrder,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      type: Value(type),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isDefault: Value(isDefault),
      sortOrder: Value(sortOrder),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      type: serializer.fromJson<String>(json['type']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'type': serializer.toJson<String>(type),
      'parentId': serializer.toJson<String?>(parentId),
      'isDefault': serializer.toJson<bool>(isDefault),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? name,
    String? icon,
    int? color,
    String? type,
    Value<String?> parentId = const Value.absent(),
    bool? isDefault,
    int? sortOrder,
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    type: type ?? this.type,
    parentId: parentId.present ? parentId.value : this.parentId,
    isDefault: isDefault ?? this.isDefault,
    sortOrder: sortOrder ?? this.sortOrder,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      type: data.type.present ? data.type.value : this.type,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('type: $type, ')
          ..write('parentId: $parentId, ')
          ..write('isDefault: $isDefault, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    icon,
    color,
    type,
    parentId,
    isDefault,
    sortOrder,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.type == this.type &&
          other.parentId == this.parentId &&
          other.isDefault == this.isDefault &&
          other.sortOrder == this.sortOrder &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> color;
  final Value<String> type;
  final Value<String?> parentId;
  final Value<bool> isDefault;
  final Value<int> sortOrder;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.type = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required String icon,
    required int color,
    required String type,
    this.parentId = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       icon = Value(icon),
       color = Value(color),
       type = Value(type),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<String>? type,
    Expression<String>? parentId,
    Expression<bool>? isDefault,
    Expression<int>? sortOrder,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (type != null) 'type': type,
      if (parentId != null) 'parent_id': parentId,
      if (isDefault != null) 'is_default': isDefault,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? color,
    Value<String>? type,
    Value<String?>? parentId,
    Value<bool>? isDefault,
    Value<int>? sortOrder,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      isDefault: isDefault ?? this.isDefault,
      sortOrder: sortOrder ?? this.sortOrder,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('type: $type, ')
          ..write('parentId: $parentId, ')
          ..write('isDefault: $isDefault, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<String> walletId = GeneratedColumn<String>(
    'wallet_id',
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toAmountMeta = const VerificationMeta(
    'toAmount',
  );
  @override
  late final GeneratedColumn<int> toAmount = GeneratedColumn<int>(
    'to_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toWalletIdMeta = const VerificationMeta(
    'toWalletId',
  );
  @override
  late final GeneratedColumn<String> toWalletId = GeneratedColumn<String>(
    'to_wallet_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptPathMeta = const VerificationMeta(
    'receiptPath',
  );
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
    'receipt_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurringIdMeta = const VerificationMeta(
    'recurringId',
  );
  @override
  late final GeneratedColumn<String> recurringId = GeneratedColumn<String>(
    'recurring_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedAssetIdMeta = const VerificationMeta(
    'linkedAssetId',
  );
  @override
  late final GeneratedColumn<String> linkedAssetId = GeneratedColumn<String>(
    'linked_asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedLiabilityIdMeta = const VerificationMeta(
    'linkedLiabilityId',
  );
  @override
  late final GeneratedColumn<String> linkedLiabilityId =
      GeneratedColumn<String>(
        'linked_liability_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    type,
    amount,
    toAmount,
    categoryId,
    toWalletId,
    date,
    note,
    paymentMethod,
    receiptPath,
    recurringId,
    linkedAssetId,
    linkedLiabilityId,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('to_amount')) {
      context.handle(
        _toAmountMeta,
        toAmount.isAcceptableOrUnknown(data['to_amount']!, _toAmountMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('to_wallet_id')) {
      context.handle(
        _toWalletIdMeta,
        toWalletId.isAcceptableOrUnknown(
          data['to_wallet_id']!,
          _toWalletIdMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
        _receiptPathMeta,
        receiptPath.isAcceptableOrUnknown(
          data['receipt_path']!,
          _receiptPathMeta,
        ),
      );
    }
    if (data.containsKey('recurring_id')) {
      context.handle(
        _recurringIdMeta,
        recurringId.isAcceptableOrUnknown(
          data['recurring_id']!,
          _recurringIdMeta,
        ),
      );
    }
    if (data.containsKey('linked_asset_id')) {
      context.handle(
        _linkedAssetIdMeta,
        linkedAssetId.isAcceptableOrUnknown(
          data['linked_asset_id']!,
          _linkedAssetIdMeta,
        ),
      );
    }
    if (data.containsKey('linked_liability_id')) {
      context.handle(
        _linkedLiabilityIdMeta,
        linkedLiabilityId.isAcceptableOrUnknown(
          data['linked_liability_id']!,
          _linkedLiabilityIdMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wallet_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      toAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_amount'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      toWalletId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_wallet_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      receiptPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_path'],
      ),
      recurringId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_id'],
      ),
      linkedAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_asset_id'],
      ),
      linkedLiabilityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_liability_id'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final String id;
  final String walletId;
  final String type;
  final int amount;

  /// Received amount in to-wallet currency for cross-currency transfers.
  /// Null means same as [amount] (same-currency transfer).
  final int? toAmount;
  final String? categoryId;
  final String? toWalletId;
  final int date;
  final String? note;
  final String? paymentMethod;
  final String? receiptPath;
  final String? recurringId;
  final String? linkedAssetId;
  final String? linkedLiabilityId;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const TransactionRow({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    this.toAmount,
    this.categoryId,
    this.toWalletId,
    required this.date,
    this.note,
    this.paymentMethod,
    this.receiptPath,
    this.recurringId,
    this.linkedAssetId,
    this.linkedLiabilityId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['wallet_id'] = Variable<String>(walletId);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || toAmount != null) {
      map['to_amount'] = Variable<int>(toAmount);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || toWalletId != null) {
      map['to_wallet_id'] = Variable<String>(toWalletId);
    }
    map['date'] = Variable<int>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    if (!nullToAbsent || recurringId != null) {
      map['recurring_id'] = Variable<String>(recurringId);
    }
    if (!nullToAbsent || linkedAssetId != null) {
      map['linked_asset_id'] = Variable<String>(linkedAssetId);
    }
    if (!nullToAbsent || linkedLiabilityId != null) {
      map['linked_liability_id'] = Variable<String>(linkedLiabilityId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      type: Value(type),
      amount: Value(amount),
      toAmount: toAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(toAmount),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      toWalletId: toWalletId == null && nullToAbsent
          ? const Value.absent()
          : Value(toWalletId),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
      recurringId: recurringId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringId),
      linkedAssetId: linkedAssetId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedAssetId),
      linkedLiabilityId: linkedLiabilityId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedLiabilityId),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<String>(json['id']),
      walletId: serializer.fromJson<String>(json['walletId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<int>(json['amount']),
      toAmount: serializer.fromJson<int?>(json['toAmount']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      toWalletId: serializer.fromJson<String?>(json['toWalletId']),
      date: serializer.fromJson<int>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      recurringId: serializer.fromJson<String?>(json['recurringId']),
      linkedAssetId: serializer.fromJson<String?>(json['linkedAssetId']),
      linkedLiabilityId: serializer.fromJson<String?>(
        json['linkedLiabilityId'],
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'walletId': serializer.toJson<String>(walletId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<int>(amount),
      'toAmount': serializer.toJson<int?>(toAmount),
      'categoryId': serializer.toJson<String?>(categoryId),
      'toWalletId': serializer.toJson<String?>(toWalletId),
      'date': serializer.toJson<int>(date),
      'note': serializer.toJson<String?>(note),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'recurringId': serializer.toJson<String?>(recurringId),
      'linkedAssetId': serializer.toJson<String?>(linkedAssetId),
      'linkedLiabilityId': serializer.toJson<String?>(linkedLiabilityId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  TransactionRow copyWith({
    String? id,
    String? walletId,
    String? type,
    int? amount,
    Value<int?> toAmount = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> toWalletId = const Value.absent(),
    int? date,
    Value<String?> note = const Value.absent(),
    Value<String?> paymentMethod = const Value.absent(),
    Value<String?> receiptPath = const Value.absent(),
    Value<String?> recurringId = const Value.absent(),
    Value<String?> linkedAssetId = const Value.absent(),
    Value<String?> linkedLiabilityId = const Value.absent(),
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => TransactionRow(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    toAmount: toAmount.present ? toAmount.value : this.toAmount,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    toWalletId: toWalletId.present ? toWalletId.value : this.toWalletId,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
    recurringId: recurringId.present ? recurringId.value : this.recurringId,
    linkedAssetId: linkedAssetId.present
        ? linkedAssetId.value
        : this.linkedAssetId,
    linkedLiabilityId: linkedLiabilityId.present
        ? linkedLiabilityId.value
        : this.linkedLiabilityId,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      toAmount: data.toAmount.present ? data.toAmount.value : this.toAmount,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      toWalletId: data.toWalletId.present
          ? data.toWalletId.value
          : this.toWalletId,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      receiptPath: data.receiptPath.present
          ? data.receiptPath.value
          : this.receiptPath,
      recurringId: data.recurringId.present
          ? data.recurringId.value
          : this.recurringId,
      linkedAssetId: data.linkedAssetId.present
          ? data.linkedAssetId.value
          : this.linkedAssetId,
      linkedLiabilityId: data.linkedLiabilityId.present
          ? data.linkedLiabilityId.value
          : this.linkedLiabilityId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('toAmount: $toAmount, ')
          ..write('categoryId: $categoryId, ')
          ..write('toWalletId: $toWalletId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('recurringId: $recurringId, ')
          ..write('linkedAssetId: $linkedAssetId, ')
          ..write('linkedLiabilityId: $linkedLiabilityId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    type,
    amount,
    toAmount,
    categoryId,
    toWalletId,
    date,
    note,
    paymentMethod,
    receiptPath,
    recurringId,
    linkedAssetId,
    linkedLiabilityId,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.toAmount == this.toAmount &&
          other.categoryId == this.categoryId &&
          other.toWalletId == this.toWalletId &&
          other.date == this.date &&
          other.note == this.note &&
          other.paymentMethod == this.paymentMethod &&
          other.receiptPath == this.receiptPath &&
          other.recurringId == this.recurringId &&
          other.linkedAssetId == this.linkedAssetId &&
          other.linkedLiabilityId == this.linkedLiabilityId &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<String> id;
  final Value<String> walletId;
  final Value<String> type;
  final Value<int> amount;
  final Value<int?> toAmount;
  final Value<String?> categoryId;
  final Value<String?> toWalletId;
  final Value<int> date;
  final Value<String?> note;
  final Value<String?> paymentMethod;
  final Value<String?> receiptPath;
  final Value<String?> recurringId;
  final Value<String?> linkedAssetId;
  final Value<String?> linkedLiabilityId;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.toAmount = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.toWalletId = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.recurringId = const Value.absent(),
    this.linkedAssetId = const Value.absent(),
    this.linkedLiabilityId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String walletId,
    required String type,
    required int amount,
    this.toAmount = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.toWalletId = const Value.absent(),
    required int date,
    this.note = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.recurringId = const Value.absent(),
    this.linkedAssetId = const Value.absent(),
    this.linkedLiabilityId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       walletId = Value(walletId),
       type = Value(type),
       amount = Value(amount),
       date = Value(date),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TransactionRow> custom({
    Expression<String>? id,
    Expression<String>? walletId,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<int>? toAmount,
    Expression<String>? categoryId,
    Expression<String>? toWalletId,
    Expression<int>? date,
    Expression<String>? note,
    Expression<String>? paymentMethod,
    Expression<String>? receiptPath,
    Expression<String>? recurringId,
    Expression<String>? linkedAssetId,
    Expression<String>? linkedLiabilityId,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (toAmount != null) 'to_amount': toAmount,
      if (categoryId != null) 'category_id': categoryId,
      if (toWalletId != null) 'to_wallet_id': toWalletId,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (recurringId != null) 'recurring_id': recurringId,
      if (linkedAssetId != null) 'linked_asset_id': linkedAssetId,
      if (linkedLiabilityId != null) 'linked_liability_id': linkedLiabilityId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? walletId,
    Value<String>? type,
    Value<int>? amount,
    Value<int?>? toAmount,
    Value<String?>? categoryId,
    Value<String?>? toWalletId,
    Value<int>? date,
    Value<String?>? note,
    Value<String?>? paymentMethod,
    Value<String?>? receiptPath,
    Value<String?>? recurringId,
    Value<String?>? linkedAssetId,
    Value<String?>? linkedLiabilityId,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      toAmount: toAmount ?? this.toAmount,
      categoryId: categoryId ?? this.categoryId,
      toWalletId: toWalletId ?? this.toWalletId,
      date: date ?? this.date,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      receiptPath: receiptPath ?? this.receiptPath,
      recurringId: recurringId ?? this.recurringId,
      linkedAssetId: linkedAssetId ?? this.linkedAssetId,
      linkedLiabilityId: linkedLiabilityId ?? this.linkedLiabilityId,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (walletId.present) {
      map['wallet_id'] = Variable<String>(walletId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (toAmount.present) {
      map['to_amount'] = Variable<int>(toAmount.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (toWalletId.present) {
      map['to_wallet_id'] = Variable<String>(toWalletId.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (recurringId.present) {
      map['recurring_id'] = Variable<String>(recurringId.value);
    }
    if (linkedAssetId.present) {
      map['linked_asset_id'] = Variable<String>(linkedAssetId.value);
    }
    if (linkedLiabilityId.present) {
      map['linked_liability_id'] = Variable<String>(linkedLiabilityId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('toAmount: $toAmount, ')
          ..write('categoryId: $categoryId, ')
          ..write('toWalletId: $toWalletId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('recurringId: $recurringId, ')
          ..write('linkedAssetId: $linkedAssetId, ')
          ..write('linkedLiabilityId: $linkedLiabilityId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WalletGroupsTable extends WalletGroups
    with TableInfo<$WalletGroupsTable, WalletGroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletGroupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  WalletGroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletGroupRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WalletGroupsTable createAlias(String alias) {
    return $WalletGroupsTable(attachedDatabase, alias);
  }
}

class WalletGroupRow extends DataClass implements Insertable<WalletGroupRow> {
  final String id;
  final String name;
  final String? icon;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const WalletGroupRow({
    required this.id,
    required this.name,
    this.icon,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  WalletGroupsCompanion toCompanion(bool nullToAbsent) {
    return WalletGroupsCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WalletGroupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletGroupRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  WalletGroupRow copyWith({
    String? id,
    String? name,
    Value<String?> icon = const Value.absent(),
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => WalletGroupRow(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon.present ? icon.value : this.icon,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WalletGroupRow copyWithCompanion(WalletGroupsCompanion data) {
    return WalletGroupRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletGroupRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, icon, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletGroupRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WalletGroupsCompanion extends UpdateCompanion<WalletGroupRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const WalletGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalletGroupsCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WalletGroupRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalletGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? icon,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return WalletGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WalletGroupMembersTable extends WalletGroupMembers
    with TableInfo<$WalletGroupMembersTable, WalletGroupMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletGroupMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<String> walletId = GeneratedColumn<String>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [groupId, walletId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_group_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletGroupMemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {groupId, walletId};
  @override
  WalletGroupMemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletGroupMemberRow(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wallet_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WalletGroupMembersTable createAlias(String alias) {
    return $WalletGroupMembersTable(attachedDatabase, alias);
  }
}

class WalletGroupMemberRow extends DataClass
    implements Insertable<WalletGroupMemberRow> {
  final String groupId;
  final String walletId;
  final int createdAt;
  const WalletGroupMemberRow({
    required this.groupId,
    required this.walletId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['wallet_id'] = Variable<String>(walletId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  WalletGroupMembersCompanion toCompanion(bool nullToAbsent) {
    return WalletGroupMembersCompanion(
      groupId: Value(groupId),
      walletId: Value(walletId),
      createdAt: Value(createdAt),
    );
  }

  factory WalletGroupMemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletGroupMemberRow(
      groupId: serializer.fromJson<String>(json['groupId']),
      walletId: serializer.fromJson<String>(json['walletId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'walletId': serializer.toJson<String>(walletId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  WalletGroupMemberRow copyWith({
    String? groupId,
    String? walletId,
    int? createdAt,
  }) => WalletGroupMemberRow(
    groupId: groupId ?? this.groupId,
    walletId: walletId ?? this.walletId,
    createdAt: createdAt ?? this.createdAt,
  );
  WalletGroupMemberRow copyWithCompanion(WalletGroupMembersCompanion data) {
    return WalletGroupMemberRow(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletGroupMemberRow(')
          ..write('groupId: $groupId, ')
          ..write('walletId: $walletId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(groupId, walletId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletGroupMemberRow &&
          other.groupId == this.groupId &&
          other.walletId == this.walletId &&
          other.createdAt == this.createdAt);
}

class WalletGroupMembersCompanion
    extends UpdateCompanion<WalletGroupMemberRow> {
  final Value<String> groupId;
  final Value<String> walletId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const WalletGroupMembersCompanion({
    this.groupId = const Value.absent(),
    this.walletId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalletGroupMembersCompanion.insert({
    required String groupId,
    required String walletId,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       walletId = Value(walletId),
       createdAt = Value(createdAt);
  static Insertable<WalletGroupMemberRow> custom({
    Expression<String>? groupId,
    Expression<String>? walletId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (walletId != null) 'wallet_id': walletId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalletGroupMembersCompanion copyWith({
    Value<String>? groupId,
    Value<String>? walletId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return WalletGroupMembersCompanion(
      groupId: groupId ?? this.groupId,
      walletId: walletId ?? this.walletId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<String>(walletId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletGroupMembersCompanion(')
          ..write('groupId: $groupId, ')
          ..write('walletId: $walletId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, AssetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
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
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<int> purchasePrice = GeneratedColumn<int>(
    'purchase_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<int> purchaseDate = GeneratedColumn<int>(
    'purchase_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentValueMeta = const VerificationMeta(
    'currentValue',
  );
  @override
  late final GeneratedColumn<int> currentValue = GeneratedColumn<int>(
    'current_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PKR'),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<String> quantity = GeneratedColumn<String>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
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
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    purchasePrice,
    purchaseDate,
    currentValue,
    currency,
    quantity,
    unit,
    notes,
    photoPath,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('current_value')) {
      context.handle(
        _currentValueMeta,
        currentValue.isAcceptableOrUnknown(
          data['current_value']!,
          _currentValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentValueMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  AssetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_price'],
      ),
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_date'],
      ),
      currentValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_value'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantity'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class AssetRow extends DataClass implements Insertable<AssetRow> {
  final String id;
  final String name;
  final String type;
  final int? purchasePrice;
  final int? purchaseDate;
  final int currentValue;
  final String currency;
  final String? quantity;
  final String? unit;
  final String? notes;
  final String? photoPath;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const AssetRow({
    required this.id,
    required this.name,
    required this.type,
    this.purchasePrice,
    this.purchaseDate,
    required this.currentValue,
    required this.currency,
    this.quantity,
    this.unit,
    this.notes,
    this.photoPath,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<int>(purchasePrice);
    }
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<int>(purchaseDate);
    }
    map['current_value'] = Variable<int>(currentValue);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<String>(quantity);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      currentValue: Value(currentValue),
      currency: Value(currency),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AssetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      purchasePrice: serializer.fromJson<int?>(json['purchasePrice']),
      purchaseDate: serializer.fromJson<int?>(json['purchaseDate']),
      currentValue: serializer.fromJson<int>(json['currentValue']),
      currency: serializer.fromJson<String>(json['currency']),
      quantity: serializer.fromJson<String?>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'purchasePrice': serializer.toJson<int?>(purchasePrice),
      'purchaseDate': serializer.toJson<int?>(purchaseDate),
      'currentValue': serializer.toJson<int>(currentValue),
      'currency': serializer.toJson<String>(currency),
      'quantity': serializer.toJson<String?>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AssetRow copyWith({
    String? id,
    String? name,
    String? type,
    Value<int?> purchasePrice = const Value.absent(),
    Value<int?> purchaseDate = const Value.absent(),
    int? currentValue,
    String? currency,
    Value<String?> quantity = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => AssetRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    purchasePrice: purchasePrice.present
        ? purchasePrice.value
        : this.purchasePrice,
    purchaseDate: purchaseDate.present ? purchaseDate.value : this.purchaseDate,
    currentValue: currentValue ?? this.currentValue,
    currency: currency ?? this.currency,
    quantity: quantity.present ? quantity.value : this.quantity,
    unit: unit.present ? unit.value : this.unit,
    notes: notes.present ? notes.value : this.notes,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AssetRow copyWithCompanion(AssetsCompanion data) {
    return AssetRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      currency: data.currency.present ? data.currency.value : this.currency,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('currentValue: $currentValue, ')
          ..write('currency: $currency, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    purchasePrice,
    purchaseDate,
    currentValue,
    currency,
    quantity,
    unit,
    notes,
    photoPath,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.purchasePrice == this.purchasePrice &&
          other.purchaseDate == this.purchaseDate &&
          other.currentValue == this.currentValue &&
          other.currency == this.currency &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AssetsCompanion extends UpdateCompanion<AssetRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int?> purchasePrice;
  final Value<int?> purchaseDate;
  final Value<int> currentValue;
  final Value<String> currency;
  final Value<String?> quantity;
  final Value<String?> unit;
  final Value<String?> notes;
  final Value<String?> photoPath;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.currency = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.purchasePrice = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    required int currentValue,
    this.currency = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       currentValue = Value(currentValue),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AssetRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? purchasePrice,
    Expression<int>? purchaseDate,
    Expression<int>? currentValue,
    Expression<String>? currency,
    Expression<String>? quantity,
    Expression<String>? unit,
    Expression<String>? notes,
    Expression<String>? photoPath,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (currentValue != null) 'current_value': currentValue,
      if (currency != null) 'currency': currency,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<int?>? purchasePrice,
    Value<int?>? purchaseDate,
    Value<int>? currentValue,
    Value<String>? currency,
    Value<String?>? quantity,
    Value<String?>? unit,
    Value<String?>? notes,
    Value<String?>? photoPath,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return AssetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      currentValue: currentValue ?? this.currentValue,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<int>(purchasePrice.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<int>(purchaseDate.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<int>(currentValue.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<String>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('currentValue: $currentValue, ')
          ..write('currency: $currency, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetValueHistoryTable extends AssetValueHistory
    with TableInfo<$AssetValueHistoryTable, AssetValueHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetValueHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assetId,
    value,
    date,
    createdAt,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_value_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssetValueHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
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
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetValueHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetValueHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $AssetValueHistoryTable createAlias(String alias) {
    return $AssetValueHistoryTable(attachedDatabase, alias);
  }
}

class AssetValueHistoryRow extends DataClass
    implements Insertable<AssetValueHistoryRow> {
  final String id;
  final String assetId;
  final int value;
  final int date;
  final int createdAt;
  final int updatedAt;
  final bool isDeleted;
  const AssetValueHistoryRow({
    required this.id,
    required this.assetId,
    required this.value,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_id'] = Variable<String>(assetId);
    map['value'] = Variable<int>(value);
    map['date'] = Variable<int>(date);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  AssetValueHistoryCompanion toCompanion(bool nullToAbsent) {
    return AssetValueHistoryCompanion(
      id: Value(id),
      assetId: Value(assetId),
      value: Value(value),
      date: Value(date),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory AssetValueHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetValueHistoryRow(
      id: serializer.fromJson<String>(json['id']),
      assetId: serializer.fromJson<String>(json['assetId']),
      value: serializer.fromJson<int>(json['value']),
      date: serializer.fromJson<int>(json['date']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetId': serializer.toJson<String>(assetId),
      'value': serializer.toJson<int>(value),
      'date': serializer.toJson<int>(date),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  AssetValueHistoryRow copyWith({
    String? id,
    String? assetId,
    int? value,
    int? date,
    int? createdAt,
    int? updatedAt,
    bool? isDeleted,
  }) => AssetValueHistoryRow(
    id: id ?? this.id,
    assetId: assetId ?? this.assetId,
    value: value ?? this.value,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  AssetValueHistoryRow copyWithCompanion(AssetValueHistoryCompanion data) {
    return AssetValueHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      value: data.value.present ? data.value.value : this.value,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetValueHistoryRow(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('value: $value, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, assetId, value, date, createdAt, updatedAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetValueHistoryRow &&
          other.id == this.id &&
          other.assetId == this.assetId &&
          other.value == this.value &&
          other.date == this.date &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class AssetValueHistoryCompanion extends UpdateCompanion<AssetValueHistoryRow> {
  final Value<String> id;
  final Value<String> assetId;
  final Value<int> value;
  final Value<int> date;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const AssetValueHistoryCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.value = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetValueHistoryCompanion.insert({
    required String id,
    required String assetId,
    required int value,
    required int date,
    required int createdAt,
    required int updatedAt,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assetId = Value(assetId),
       value = Value(value),
       date = Value(date),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AssetValueHistoryRow> custom({
    Expression<String>? id,
    Expression<String>? assetId,
    Expression<int>? value,
    Expression<int>? date,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (value != null) 'value': value,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetValueHistoryCompanion copyWith({
    Value<String>? id,
    Value<String>? assetId,
    Value<int>? value,
    Value<int>? date,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return AssetValueHistoryCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      value: value ?? this.value,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetValueHistoryCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('value: $value, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LiabilitiesTable extends Liabilities
    with TableInfo<$LiabilitiesTable, LiabilityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LiabilitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
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
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingAmountMeta = const VerificationMeta(
    'remainingAmount',
  );
  @override
  late final GeneratedColumn<int> remainingAmount = GeneratedColumn<int>(
    'remaining_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PKR'),
  );
  static const VerificationMeta _installmentAmountMeta = const VerificationMeta(
    'installmentAmount',
  );
  @override
  late final GeneratedColumn<int> installmentAmount = GeneratedColumn<int>(
    'installment_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<int> dueDate = GeneratedColumn<int>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interestRateMeta = const VerificationMeta(
    'interestRate',
  );
  @override
  late final GeneratedColumn<String> interestRate = GeneratedColumn<String>(
    'interest_rate',
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
  static const VerificationMeta _linkedWalletIdMeta = const VerificationMeta(
    'linkedWalletId',
  );
  @override
  late final GeneratedColumn<String> linkedWalletId = GeneratedColumn<String>(
    'linked_wallet_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    totalAmount,
    remainingAmount,
    currency,
    installmentAmount,
    dueDate,
    interestRate,
    notes,
    linkedWalletId,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'liabilities';
  @override
  VerificationContext validateIntegrity(
    Insertable<LiabilityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('remaining_amount')) {
      context.handle(
        _remainingAmountMeta,
        remainingAmount.isAcceptableOrUnknown(
          data['remaining_amount']!,
          _remainingAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingAmountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('installment_amount')) {
      context.handle(
        _installmentAmountMeta,
        installmentAmount.isAcceptableOrUnknown(
          data['installment_amount']!,
          _installmentAmountMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
        _interestRateMeta,
        interestRate.isAcceptableOrUnknown(
          data['interest_rate']!,
          _interestRateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('linked_wallet_id')) {
      context.handle(
        _linkedWalletIdMeta,
        linkedWalletId.isAcceptableOrUnknown(
          data['linked_wallet_id']!,
          _linkedWalletIdMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  LiabilityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LiabilityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount'],
      )!,
      remainingAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      installmentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_amount'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_date'],
      ),
      interestRate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}interest_rate'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      linkedWalletId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_wallet_id'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LiabilitiesTable createAlias(String alias) {
    return $LiabilitiesTable(attachedDatabase, alias);
  }
}

class LiabilityRow extends DataClass implements Insertable<LiabilityRow> {
  final String id;
  final String name;
  final String type;
  final int totalAmount;
  final int remainingAmount;
  final String currency;
  final int? installmentAmount;
  final int? dueDate;
  final String? interestRate;
  final String? notes;
  final String? linkedWalletId;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const LiabilityRow({
    required this.id,
    required this.name,
    required this.type,
    required this.totalAmount,
    required this.remainingAmount,
    required this.currency,
    this.installmentAmount,
    this.dueDate,
    this.interestRate,
    this.notes,
    this.linkedWalletId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['total_amount'] = Variable<int>(totalAmount);
    map['remaining_amount'] = Variable<int>(remainingAmount);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || installmentAmount != null) {
      map['installment_amount'] = Variable<int>(installmentAmount);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<int>(dueDate);
    }
    if (!nullToAbsent || interestRate != null) {
      map['interest_rate'] = Variable<String>(interestRate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || linkedWalletId != null) {
      map['linked_wallet_id'] = Variable<String>(linkedWalletId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LiabilitiesCompanion toCompanion(bool nullToAbsent) {
    return LiabilitiesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      totalAmount: Value(totalAmount),
      remainingAmount: Value(remainingAmount),
      currency: Value(currency),
      installmentAmount: installmentAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(installmentAmount),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      interestRate: interestRate == null && nullToAbsent
          ? const Value.absent()
          : Value(interestRate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      linkedWalletId: linkedWalletId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedWalletId),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LiabilityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LiabilityRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      remainingAmount: serializer.fromJson<int>(json['remainingAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      installmentAmount: serializer.fromJson<int?>(json['installmentAmount']),
      dueDate: serializer.fromJson<int?>(json['dueDate']),
      interestRate: serializer.fromJson<String?>(json['interestRate']),
      notes: serializer.fromJson<String?>(json['notes']),
      linkedWalletId: serializer.fromJson<String?>(json['linkedWalletId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'remainingAmount': serializer.toJson<int>(remainingAmount),
      'currency': serializer.toJson<String>(currency),
      'installmentAmount': serializer.toJson<int?>(installmentAmount),
      'dueDate': serializer.toJson<int?>(dueDate),
      'interestRate': serializer.toJson<String?>(interestRate),
      'notes': serializer.toJson<String?>(notes),
      'linkedWalletId': serializer.toJson<String?>(linkedWalletId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LiabilityRow copyWith({
    String? id,
    String? name,
    String? type,
    int? totalAmount,
    int? remainingAmount,
    String? currency,
    Value<int?> installmentAmount = const Value.absent(),
    Value<int?> dueDate = const Value.absent(),
    Value<String?> interestRate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> linkedWalletId = const Value.absent(),
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => LiabilityRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    totalAmount: totalAmount ?? this.totalAmount,
    remainingAmount: remainingAmount ?? this.remainingAmount,
    currency: currency ?? this.currency,
    installmentAmount: installmentAmount.present
        ? installmentAmount.value
        : this.installmentAmount,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    interestRate: interestRate.present ? interestRate.value : this.interestRate,
    notes: notes.present ? notes.value : this.notes,
    linkedWalletId: linkedWalletId.present
        ? linkedWalletId.value
        : this.linkedWalletId,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LiabilityRow copyWithCompanion(LiabilitiesCompanion data) {
    return LiabilityRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      remainingAmount: data.remainingAmount.present
          ? data.remainingAmount.value
          : this.remainingAmount,
      currency: data.currency.present ? data.currency.value : this.currency,
      installmentAmount: data.installmentAmount.present
          ? data.installmentAmount.value
          : this.installmentAmount,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      notes: data.notes.present ? data.notes.value : this.notes,
      linkedWalletId: data.linkedWalletId.present
          ? data.linkedWalletId.value
          : this.linkedWalletId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LiabilityRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('currency: $currency, ')
          ..write('installmentAmount: $installmentAmount, ')
          ..write('dueDate: $dueDate, ')
          ..write('interestRate: $interestRate, ')
          ..write('notes: $notes, ')
          ..write('linkedWalletId: $linkedWalletId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    totalAmount,
    remainingAmount,
    currency,
    installmentAmount,
    dueDate,
    interestRate,
    notes,
    linkedWalletId,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LiabilityRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.totalAmount == this.totalAmount &&
          other.remainingAmount == this.remainingAmount &&
          other.currency == this.currency &&
          other.installmentAmount == this.installmentAmount &&
          other.dueDate == this.dueDate &&
          other.interestRate == this.interestRate &&
          other.notes == this.notes &&
          other.linkedWalletId == this.linkedWalletId &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LiabilitiesCompanion extends UpdateCompanion<LiabilityRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int> totalAmount;
  final Value<int> remainingAmount;
  final Value<String> currency;
  final Value<int?> installmentAmount;
  final Value<int?> dueDate;
  final Value<String?> interestRate;
  final Value<String?> notes;
  final Value<String?> linkedWalletId;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LiabilitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.remainingAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.installmentAmount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.notes = const Value.absent(),
    this.linkedWalletId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LiabilitiesCompanion.insert({
    required String id,
    required String name,
    required String type,
    required int totalAmount,
    required int remainingAmount,
    this.currency = const Value.absent(),
    this.installmentAmount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.notes = const Value.absent(),
    this.linkedWalletId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       totalAmount = Value(totalAmount),
       remainingAmount = Value(remainingAmount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LiabilityRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? totalAmount,
    Expression<int>? remainingAmount,
    Expression<String>? currency,
    Expression<int>? installmentAmount,
    Expression<int>? dueDate,
    Expression<String>? interestRate,
    Expression<String>? notes,
    Expression<String>? linkedWalletId,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (remainingAmount != null) 'remaining_amount': remainingAmount,
      if (currency != null) 'currency': currency,
      if (installmentAmount != null) 'installment_amount': installmentAmount,
      if (dueDate != null) 'due_date': dueDate,
      if (interestRate != null) 'interest_rate': interestRate,
      if (notes != null) 'notes': notes,
      if (linkedWalletId != null) 'linked_wallet_id': linkedWalletId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LiabilitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<int>? totalAmount,
    Value<int>? remainingAmount,
    Value<String>? currency,
    Value<int?>? installmentAmount,
    Value<int?>? dueDate,
    Value<String?>? interestRate,
    Value<String?>? notes,
    Value<String?>? linkedWalletId,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LiabilitiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      totalAmount: totalAmount ?? this.totalAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      currency: currency ?? this.currency,
      installmentAmount: installmentAmount ?? this.installmentAmount,
      dueDate: dueDate ?? this.dueDate,
      interestRate: interestRate ?? this.interestRate,
      notes: notes ?? this.notes,
      linkedWalletId: linkedWalletId ?? this.linkedWalletId,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (remainingAmount.present) {
      map['remaining_amount'] = Variable<int>(remainingAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (installmentAmount.present) {
      map['installment_amount'] = Variable<int>(installmentAmount.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<int>(dueDate.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<String>(interestRate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (linkedWalletId.present) {
      map['linked_wallet_id'] = Variable<String>(linkedWalletId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LiabilitiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('currency: $currency, ')
          ..write('installmentAmount: $installmentAmount, ')
          ..write('dueDate: $dueDate, ')
          ..write('interestRate: $interestRate, ')
          ..write('notes: $notes, ')
          ..write('linkedWalletId: $linkedWalletId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LiabilityPaymentsTable extends LiabilityPayments
    with TableInfo<$LiabilityPaymentsTable, LiabilityPaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LiabilityPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _liabilityIdMeta = const VerificationMeta(
    'liabilityId',
  );
  @override
  late final GeneratedColumn<String> liabilityId = GeneratedColumn<String>(
    'liability_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    liabilityId,
    amount,
    date,
    transactionId,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'liability_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LiabilityPaymentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('liability_id')) {
      context.handle(
        _liabilityIdMeta,
        liabilityId.isAcceptableOrUnknown(
          data['liability_id']!,
          _liabilityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_liabilityIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  LiabilityPaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LiabilityPaymentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      liabilityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}liability_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LiabilityPaymentsTable createAlias(String alias) {
    return $LiabilityPaymentsTable(attachedDatabase, alias);
  }
}

class LiabilityPaymentRow extends DataClass
    implements Insertable<LiabilityPaymentRow> {
  final String id;
  final String liabilityId;
  final int amount;
  final int date;
  final String? transactionId;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const LiabilityPaymentRow({
    required this.id,
    required this.liabilityId,
    required this.amount,
    required this.date,
    this.transactionId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['liability_id'] = Variable<String>(liabilityId);
    map['amount'] = Variable<int>(amount);
    map['date'] = Variable<int>(date);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LiabilityPaymentsCompanion toCompanion(bool nullToAbsent) {
    return LiabilityPaymentsCompanion(
      id: Value(id),
      liabilityId: Value(liabilityId),
      amount: Value(amount),
      date: Value(date),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LiabilityPaymentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LiabilityPaymentRow(
      id: serializer.fromJson<String>(json['id']),
      liabilityId: serializer.fromJson<String>(json['liabilityId']),
      amount: serializer.fromJson<int>(json['amount']),
      date: serializer.fromJson<int>(json['date']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'liabilityId': serializer.toJson<String>(liabilityId),
      'amount': serializer.toJson<int>(amount),
      'date': serializer.toJson<int>(date),
      'transactionId': serializer.toJson<String?>(transactionId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LiabilityPaymentRow copyWith({
    String? id,
    String? liabilityId,
    int? amount,
    int? date,
    Value<String?> transactionId = const Value.absent(),
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => LiabilityPaymentRow(
    id: id ?? this.id,
    liabilityId: liabilityId ?? this.liabilityId,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LiabilityPaymentRow copyWithCompanion(LiabilityPaymentsCompanion data) {
    return LiabilityPaymentRow(
      id: data.id.present ? data.id.value : this.id,
      liabilityId: data.liabilityId.present
          ? data.liabilityId.value
          : this.liabilityId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LiabilityPaymentRow(')
          ..write('id: $id, ')
          ..write('liabilityId: $liabilityId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('transactionId: $transactionId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    liabilityId,
    amount,
    date,
    transactionId,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LiabilityPaymentRow &&
          other.id == this.id &&
          other.liabilityId == this.liabilityId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.transactionId == this.transactionId &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LiabilityPaymentsCompanion extends UpdateCompanion<LiabilityPaymentRow> {
  final Value<String> id;
  final Value<String> liabilityId;
  final Value<int> amount;
  final Value<int> date;
  final Value<String?> transactionId;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const LiabilityPaymentsCompanion({
    this.id = const Value.absent(),
    this.liabilityId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LiabilityPaymentsCompanion.insert({
    required String id,
    required String liabilityId,
    required int amount,
    required int date,
    this.transactionId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       liabilityId = Value(liabilityId),
       amount = Value(amount),
       date = Value(date),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LiabilityPaymentRow> custom({
    Expression<String>? id,
    Expression<String>? liabilityId,
    Expression<int>? amount,
    Expression<int>? date,
    Expression<String>? transactionId,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (liabilityId != null) 'liability_id': liabilityId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (transactionId != null) 'transaction_id': transactionId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LiabilityPaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? liabilityId,
    Value<int>? amount,
    Value<int>? date,
    Value<String?>? transactionId,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return LiabilityPaymentsCompanion(
      id: id ?? this.id,
      liabilityId: liabilityId ?? this.liabilityId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      transactionId: transactionId ?? this.transactionId,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (liabilityId.present) {
      map['liability_id'] = Variable<String>(liabilityId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LiabilityPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('liabilityId: $liabilityId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('transactionId: $transactionId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<String> walletId = GeneratedColumn<String>(
    'wallet_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PKR'),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  );
  static const VerificationMeta _startMonthMeta = const VerificationMeta(
    'startMonth',
  );
  @override
  late final GeneratedColumn<int> startMonth = GeneratedColumn<int>(
    'start_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMonthMeta = const VerificationMeta(
    'yearMonth',
  );
  @override
  late final GeneratedColumn<int> yearMonth = GeneratedColumn<int>(
    'year_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rolloverMeta = const VerificationMeta(
    'rollover',
  );
  @override
  late final GeneratedColumn<bool> rollover = GeneratedColumn<bool>(
    'rollover',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("rollover" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notify80Meta = const VerificationMeta(
    'notify80',
  );
  @override
  late final GeneratedColumn<bool> notify80 = GeneratedColumn<bool>(
    'notify_80',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_80" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifyOverMeta = const VerificationMeta(
    'notifyOver',
  );
  @override
  late final GeneratedColumn<bool> notifyOver = GeneratedColumn<bool>(
    'notify_over',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_over" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastNotified80AtMeta = const VerificationMeta(
    'lastNotified80At',
  );
  @override
  late final GeneratedColumn<int> lastNotified80At = GeneratedColumn<int>(
    'last_notified_80_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastNotifiedOverAtMeta =
      const VerificationMeta('lastNotifiedOverAt');
  @override
  late final GeneratedColumn<int> lastNotifiedOverAt = GeneratedColumn<int>(
    'last_notified_over_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    walletId,
    amount,
    currency,
    period,
    startMonth,
    yearMonth,
    rollover,
    notify80,
    notifyOver,
    lastNotified80At,
    lastNotifiedOverAt,
    name,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    }
    if (data.containsKey('start_month')) {
      context.handle(
        _startMonthMeta,
        startMonth.isAcceptableOrUnknown(data['start_month']!, _startMonthMeta),
      );
    } else if (isInserting) {
      context.missing(_startMonthMeta);
    }
    if (data.containsKey('year_month')) {
      context.handle(
        _yearMonthMeta,
        yearMonth.isAcceptableOrUnknown(data['year_month']!, _yearMonthMeta),
      );
    }
    if (data.containsKey('rollover')) {
      context.handle(
        _rolloverMeta,
        rollover.isAcceptableOrUnknown(data['rollover']!, _rolloverMeta),
      );
    }
    if (data.containsKey('notify_80')) {
      context.handle(
        _notify80Meta,
        notify80.isAcceptableOrUnknown(data['notify_80']!, _notify80Meta),
      );
    }
    if (data.containsKey('notify_over')) {
      context.handle(
        _notifyOverMeta,
        notifyOver.isAcceptableOrUnknown(data['notify_over']!, _notifyOverMeta),
      );
    }
    if (data.containsKey('last_notified_80_at')) {
      context.handle(
        _lastNotified80AtMeta,
        lastNotified80At.isAcceptableOrUnknown(
          data['last_notified_80_at']!,
          _lastNotified80AtMeta,
        ),
      );
    }
    if (data.containsKey('last_notified_over_at')) {
      context.handle(
        _lastNotifiedOverAtMeta,
        lastNotifiedOverAt.isAcceptableOrUnknown(
          data['last_notified_over_at']!,
          _lastNotifiedOverAtMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  BudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wallet_id'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      startMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_month'],
      )!,
      yearMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_month'],
      )!,
      rollover: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}rollover'],
      )!,
      notify80: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_80'],
      )!,
      notifyOver: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_over'],
      )!,
      lastNotified80At: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_notified_80_at'],
      ),
      lastNotifiedOverAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_notified_over_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class BudgetRow extends DataClass implements Insertable<BudgetRow> {
  final String id;

  /// Null = overall budget. Non-null = that category only.
  final String? categoryId;

  /// Single-wallet shortcut. Null when all-wallet or multi-wallet.
  final String? walletId;
  final int amount;
  final String currency;
  final String period;

  /// Legacy column; mirrored with [yearMonth] (YYYYMM).
  final int startMonth;

  /// Budget period YYYYMM.
  final int yearMonth;
  final bool rollover;
  final bool notify80;
  final bool notifyOver;
  final int? lastNotified80At;
  final int? lastNotifiedOverAt;

  /// Display name for overall budgets / notes.
  final String? name;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const BudgetRow({
    required this.id,
    this.categoryId,
    this.walletId,
    required this.amount,
    required this.currency,
    required this.period,
    required this.startMonth,
    required this.yearMonth,
    required this.rollover,
    required this.notify80,
    required this.notifyOver,
    this.lastNotified80At,
    this.lastNotifiedOverAt,
    this.name,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || walletId != null) {
      map['wallet_id'] = Variable<String>(walletId);
    }
    map['amount'] = Variable<int>(amount);
    map['currency'] = Variable<String>(currency);
    map['period'] = Variable<String>(period);
    map['start_month'] = Variable<int>(startMonth);
    map['year_month'] = Variable<int>(yearMonth);
    map['rollover'] = Variable<bool>(rollover);
    map['notify_80'] = Variable<bool>(notify80);
    map['notify_over'] = Variable<bool>(notifyOver);
    if (!nullToAbsent || lastNotified80At != null) {
      map['last_notified_80_at'] = Variable<int>(lastNotified80At);
    }
    if (!nullToAbsent || lastNotifiedOverAt != null) {
      map['last_notified_over_at'] = Variable<int>(lastNotifiedOverAt);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      walletId: walletId == null && nullToAbsent
          ? const Value.absent()
          : Value(walletId),
      amount: Value(amount),
      currency: Value(currency),
      period: Value(period),
      startMonth: Value(startMonth),
      yearMonth: Value(yearMonth),
      rollover: Value(rollover),
      notify80: Value(notify80),
      notifyOver: Value(notifyOver),
      lastNotified80At: lastNotified80At == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNotified80At),
      lastNotifiedOverAt: lastNotifiedOverAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNotifiedOverAt),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRow(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      walletId: serializer.fromJson<String?>(json['walletId']),
      amount: serializer.fromJson<int>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      period: serializer.fromJson<String>(json['period']),
      startMonth: serializer.fromJson<int>(json['startMonth']),
      yearMonth: serializer.fromJson<int>(json['yearMonth']),
      rollover: serializer.fromJson<bool>(json['rollover']),
      notify80: serializer.fromJson<bool>(json['notify80']),
      notifyOver: serializer.fromJson<bool>(json['notifyOver']),
      lastNotified80At: serializer.fromJson<int?>(json['lastNotified80At']),
      lastNotifiedOverAt: serializer.fromJson<int?>(json['lastNotifiedOverAt']),
      name: serializer.fromJson<String?>(json['name']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String?>(categoryId),
      'walletId': serializer.toJson<String?>(walletId),
      'amount': serializer.toJson<int>(amount),
      'currency': serializer.toJson<String>(currency),
      'period': serializer.toJson<String>(period),
      'startMonth': serializer.toJson<int>(startMonth),
      'yearMonth': serializer.toJson<int>(yearMonth),
      'rollover': serializer.toJson<bool>(rollover),
      'notify80': serializer.toJson<bool>(notify80),
      'notifyOver': serializer.toJson<bool>(notifyOver),
      'lastNotified80At': serializer.toJson<int?>(lastNotified80At),
      'lastNotifiedOverAt': serializer.toJson<int?>(lastNotifiedOverAt),
      'name': serializer.toJson<String?>(name),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  BudgetRow copyWith({
    String? id,
    Value<String?> categoryId = const Value.absent(),
    Value<String?> walletId = const Value.absent(),
    int? amount,
    String? currency,
    String? period,
    int? startMonth,
    int? yearMonth,
    bool? rollover,
    bool? notify80,
    bool? notifyOver,
    Value<int?> lastNotified80At = const Value.absent(),
    Value<int?> lastNotifiedOverAt = const Value.absent(),
    Value<String?> name = const Value.absent(),
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => BudgetRow(
    id: id ?? this.id,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    walletId: walletId.present ? walletId.value : this.walletId,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    period: period ?? this.period,
    startMonth: startMonth ?? this.startMonth,
    yearMonth: yearMonth ?? this.yearMonth,
    rollover: rollover ?? this.rollover,
    notify80: notify80 ?? this.notify80,
    notifyOver: notifyOver ?? this.notifyOver,
    lastNotified80At: lastNotified80At.present
        ? lastNotified80At.value
        : this.lastNotified80At,
    lastNotifiedOverAt: lastNotifiedOverAt.present
        ? lastNotifiedOverAt.value
        : this.lastNotifiedOverAt,
    name: name.present ? name.value : this.name,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BudgetRow copyWithCompanion(BudgetsCompanion data) {
    return BudgetRow(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      period: data.period.present ? data.period.value : this.period,
      startMonth: data.startMonth.present
          ? data.startMonth.value
          : this.startMonth,
      yearMonth: data.yearMonth.present ? data.yearMonth.value : this.yearMonth,
      rollover: data.rollover.present ? data.rollover.value : this.rollover,
      notify80: data.notify80.present ? data.notify80.value : this.notify80,
      notifyOver: data.notifyOver.present
          ? data.notifyOver.value
          : this.notifyOver,
      lastNotified80At: data.lastNotified80At.present
          ? data.lastNotified80At.value
          : this.lastNotified80At,
      lastNotifiedOverAt: data.lastNotifiedOverAt.present
          ? data.lastNotifiedOverAt.value
          : this.lastNotifiedOverAt,
      name: data.name.present ? data.name.value : this.name,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRow(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('walletId: $walletId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('period: $period, ')
          ..write('startMonth: $startMonth, ')
          ..write('yearMonth: $yearMonth, ')
          ..write('rollover: $rollover, ')
          ..write('notify80: $notify80, ')
          ..write('notifyOver: $notifyOver, ')
          ..write('lastNotified80At: $lastNotified80At, ')
          ..write('lastNotifiedOverAt: $lastNotifiedOverAt, ')
          ..write('name: $name, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    walletId,
    amount,
    currency,
    period,
    startMonth,
    yearMonth,
    rollover,
    notify80,
    notifyOver,
    lastNotified80At,
    lastNotifiedOverAt,
    name,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRow &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.walletId == this.walletId &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.period == this.period &&
          other.startMonth == this.startMonth &&
          other.yearMonth == this.yearMonth &&
          other.rollover == this.rollover &&
          other.notify80 == this.notify80 &&
          other.notifyOver == this.notifyOver &&
          other.lastNotified80At == this.lastNotified80At &&
          other.lastNotifiedOverAt == this.lastNotifiedOverAt &&
          other.name == this.name &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetsCompanion extends UpdateCompanion<BudgetRow> {
  final Value<String> id;
  final Value<String?> categoryId;
  final Value<String?> walletId;
  final Value<int> amount;
  final Value<String> currency;
  final Value<String> period;
  final Value<int> startMonth;
  final Value<int> yearMonth;
  final Value<bool> rollover;
  final Value<bool> notify80;
  final Value<bool> notifyOver;
  final Value<int?> lastNotified80At;
  final Value<int?> lastNotifiedOverAt;
  final Value<String?> name;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.walletId = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.period = const Value.absent(),
    this.startMonth = const Value.absent(),
    this.yearMonth = const Value.absent(),
    this.rollover = const Value.absent(),
    this.notify80 = const Value.absent(),
    this.notifyOver = const Value.absent(),
    this.lastNotified80At = const Value.absent(),
    this.lastNotifiedOverAt = const Value.absent(),
    this.name = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    this.categoryId = const Value.absent(),
    this.walletId = const Value.absent(),
    required int amount,
    this.currency = const Value.absent(),
    this.period = const Value.absent(),
    required int startMonth,
    this.yearMonth = const Value.absent(),
    this.rollover = const Value.absent(),
    this.notify80 = const Value.absent(),
    this.notifyOver = const Value.absent(),
    this.lastNotified80At = const Value.absent(),
    this.lastNotifiedOverAt = const Value.absent(),
    this.name = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       startMonth = Value(startMonth),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BudgetRow> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? walletId,
    Expression<int>? amount,
    Expression<String>? currency,
    Expression<String>? period,
    Expression<int>? startMonth,
    Expression<int>? yearMonth,
    Expression<bool>? rollover,
    Expression<bool>? notify80,
    Expression<bool>? notifyOver,
    Expression<int>? lastNotified80At,
    Expression<int>? lastNotifiedOverAt,
    Expression<String>? name,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (walletId != null) 'wallet_id': walletId,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (period != null) 'period': period,
      if (startMonth != null) 'start_month': startMonth,
      if (yearMonth != null) 'year_month': yearMonth,
      if (rollover != null) 'rollover': rollover,
      if (notify80 != null) 'notify_80': notify80,
      if (notifyOver != null) 'notify_over': notifyOver,
      if (lastNotified80At != null) 'last_notified_80_at': lastNotified80At,
      if (lastNotifiedOverAt != null)
        'last_notified_over_at': lastNotifiedOverAt,
      if (name != null) 'name': name,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<String>? id,
    Value<String?>? categoryId,
    Value<String?>? walletId,
    Value<int>? amount,
    Value<String>? currency,
    Value<String>? period,
    Value<int>? startMonth,
    Value<int>? yearMonth,
    Value<bool>? rollover,
    Value<bool>? notify80,
    Value<bool>? notifyOver,
    Value<int?>? lastNotified80At,
    Value<int?>? lastNotifiedOverAt,
    Value<String?>? name,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      walletId: walletId ?? this.walletId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      period: period ?? this.period,
      startMonth: startMonth ?? this.startMonth,
      yearMonth: yearMonth ?? this.yearMonth,
      rollover: rollover ?? this.rollover,
      notify80: notify80 ?? this.notify80,
      notifyOver: notifyOver ?? this.notifyOver,
      lastNotified80At: lastNotified80At ?? this.lastNotified80At,
      lastNotifiedOverAt: lastNotifiedOverAt ?? this.lastNotifiedOverAt,
      name: name ?? this.name,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<String>(walletId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (startMonth.present) {
      map['start_month'] = Variable<int>(startMonth.value);
    }
    if (yearMonth.present) {
      map['year_month'] = Variable<int>(yearMonth.value);
    }
    if (rollover.present) {
      map['rollover'] = Variable<bool>(rollover.value);
    }
    if (notify80.present) {
      map['notify_80'] = Variable<bool>(notify80.value);
    }
    if (notifyOver.present) {
      map['notify_over'] = Variable<bool>(notifyOver.value);
    }
    if (lastNotified80At.present) {
      map['last_notified_80_at'] = Variable<int>(lastNotified80At.value);
    }
    if (lastNotifiedOverAt.present) {
      map['last_notified_over_at'] = Variable<int>(lastNotifiedOverAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('walletId: $walletId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('period: $period, ')
          ..write('startMonth: $startMonth, ')
          ..write('yearMonth: $yearMonth, ')
          ..write('rollover: $rollover, ')
          ..write('notify80: $notify80, ')
          ..write('notifyOver: $notifyOver, ')
          ..write('lastNotified80At: $lastNotified80At, ')
          ..write('lastNotifiedOverAt: $lastNotifiedOverAt, ')
          ..write('name: $name, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetWalletMembersTable extends BudgetWalletMembers
    with TableInfo<$BudgetWalletMembersTable, BudgetWalletMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetWalletMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<String> walletId = GeneratedColumn<String>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [budgetId, walletId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_wallet_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetWalletMemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {budgetId, walletId};
  @override
  BudgetWalletMemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetWalletMemberRow(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wallet_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BudgetWalletMembersTable createAlias(String alias) {
    return $BudgetWalletMembersTable(attachedDatabase, alias);
  }
}

class BudgetWalletMemberRow extends DataClass
    implements Insertable<BudgetWalletMemberRow> {
  final String budgetId;
  final String walletId;
  final int createdAt;
  const BudgetWalletMemberRow({
    required this.budgetId,
    required this.walletId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['wallet_id'] = Variable<String>(walletId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  BudgetWalletMembersCompanion toCompanion(bool nullToAbsent) {
    return BudgetWalletMembersCompanion(
      budgetId: Value(budgetId),
      walletId: Value(walletId),
      createdAt: Value(createdAt),
    );
  }

  factory BudgetWalletMemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetWalletMemberRow(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      walletId: serializer.fromJson<String>(json['walletId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'walletId': serializer.toJson<String>(walletId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  BudgetWalletMemberRow copyWith({
    String? budgetId,
    String? walletId,
    int? createdAt,
  }) => BudgetWalletMemberRow(
    budgetId: budgetId ?? this.budgetId,
    walletId: walletId ?? this.walletId,
    createdAt: createdAt ?? this.createdAt,
  );
  BudgetWalletMemberRow copyWithCompanion(BudgetWalletMembersCompanion data) {
    return BudgetWalletMemberRow(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetWalletMemberRow(')
          ..write('budgetId: $budgetId, ')
          ..write('walletId: $walletId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, walletId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetWalletMemberRow &&
          other.budgetId == this.budgetId &&
          other.walletId == this.walletId &&
          other.createdAt == this.createdAt);
}

class BudgetWalletMembersCompanion
    extends UpdateCompanion<BudgetWalletMemberRow> {
  final Value<String> budgetId;
  final Value<String> walletId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const BudgetWalletMembersCompanion({
    this.budgetId = const Value.absent(),
    this.walletId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetWalletMembersCompanion.insert({
    required String budgetId,
    required String walletId,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       walletId = Value(walletId),
       createdAt = Value(createdAt);
  static Insertable<BudgetWalletMemberRow> custom({
    Expression<String>? budgetId,
    Expression<String>? walletId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (walletId != null) 'wallet_id': walletId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetWalletMembersCompanion copyWith({
    Value<String>? budgetId,
    Value<String>? walletId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return BudgetWalletMembersCompanion(
      budgetId: budgetId ?? this.budgetId,
      walletId: walletId ?? this.walletId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<String>(walletId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetWalletMembersCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('walletId: $walletId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringTransactionsTable extends RecurringTransactions
    with TableInfo<$RecurringTransactionsTable, RecurringTransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<String> walletId = GeneratedColumn<String>(
    'wallet_id',
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PKR'),
  );
  static const VerificationMeta _toAmountMeta = const VerificationMeta(
    'toAmount',
  );
  @override
  late final GeneratedColumn<int> toAmount = GeneratedColumn<int>(
    'to_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toWalletIdMeta = const VerificationMeta(
    'toWalletId',
  );
  @override
  late final GeneratedColumn<String> toWalletId = GeneratedColumn<String>(
    'to_wallet_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalNMeta = const VerificationMeta(
    'intervalN',
  );
  @override
  late final GeneratedColumn<int> intervalN = GeneratedColumn<int>(
    'interval_n',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _customUnitMeta = const VerificationMeta(
    'customUnit',
  );
  @override
  late final GeneratedColumn<String> customUnit = GeneratedColumn<String>(
    'custom_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<int> startDate = GeneratedColumn<int>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<int> endDate = GeneratedColumn<int>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextDueDateMeta = const VerificationMeta(
    'nextDueDate',
  );
  @override
  late final GeneratedColumn<int> nextDueDate = GeneratedColumn<int>(
    'next_due_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastGeneratedDateMeta = const VerificationMeta(
    'lastGeneratedDate',
  );
  @override
  late final GeneratedColumn<int> lastGeneratedDate = GeneratedColumn<int>(
    'last_generated_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ask'),
  );
  static const VerificationMeta _templateTypeMeta = const VerificationMeta(
    'templateType',
  );
  @override
  late final GeneratedColumn<String> templateType = GeneratedColumn<String>(
    'template_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('standard'),
  );
  static const VerificationMeta _installmentCountMeta = const VerificationMeta(
    'installmentCount',
  );
  @override
  late final GeneratedColumn<int> installmentCount = GeneratedColumn<int>(
    'installment_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountRemainingMeta = const VerificationMeta(
    'amountRemaining',
  );
  @override
  late final GeneratedColumn<int> amountRemaining = GeneratedColumn<int>(
    'amount_remaining',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _generatedCountMeta = const VerificationMeta(
    'generatedCount',
  );
  @override
  late final GeneratedColumn<int> generatedCount = GeneratedColumn<int>(
    'generated_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPausedMeta = const VerificationMeta(
    'isPaused',
  );
  @override
  late final GeneratedColumn<bool> isPaused = GeneratedColumn<bool>(
    'is_paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    type,
    amount,
    currency,
    toAmount,
    categoryId,
    toWalletId,
    note,
    paymentMethod,
    frequency,
    intervalN,
    customUnit,
    startDate,
    endDate,
    nextDueDate,
    lastGeneratedDate,
    mode,
    templateType,
    installmentCount,
    amountRemaining,
    generatedCount,
    isPaused,
    isActive,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringTransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('to_amount')) {
      context.handle(
        _toAmountMeta,
        toAmount.isAcceptableOrUnknown(data['to_amount']!, _toAmountMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('to_wallet_id')) {
      context.handle(
        _toWalletIdMeta,
        toWalletId.isAcceptableOrUnknown(
          data['to_wallet_id']!,
          _toWalletIdMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('interval_n')) {
      context.handle(
        _intervalNMeta,
        intervalN.isAcceptableOrUnknown(data['interval_n']!, _intervalNMeta),
      );
    }
    if (data.containsKey('custom_unit')) {
      context.handle(
        _customUnitMeta,
        customUnit.isAcceptableOrUnknown(data['custom_unit']!, _customUnitMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
        _nextDueDateMeta,
        nextDueDate.isAcceptableOrUnknown(
          data['next_due_date']!,
          _nextDueDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextDueDateMeta);
    }
    if (data.containsKey('last_generated_date')) {
      context.handle(
        _lastGeneratedDateMeta,
        lastGeneratedDate.isAcceptableOrUnknown(
          data['last_generated_date']!,
          _lastGeneratedDateMeta,
        ),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('template_type')) {
      context.handle(
        _templateTypeMeta,
        templateType.isAcceptableOrUnknown(
          data['template_type']!,
          _templateTypeMeta,
        ),
      );
    }
    if (data.containsKey('installment_count')) {
      context.handle(
        _installmentCountMeta,
        installmentCount.isAcceptableOrUnknown(
          data['installment_count']!,
          _installmentCountMeta,
        ),
      );
    }
    if (data.containsKey('amount_remaining')) {
      context.handle(
        _amountRemainingMeta,
        amountRemaining.isAcceptableOrUnknown(
          data['amount_remaining']!,
          _amountRemainingMeta,
        ),
      );
    }
    if (data.containsKey('generated_count')) {
      context.handle(
        _generatedCountMeta,
        generatedCount.isAcceptableOrUnknown(
          data['generated_count']!,
          _generatedCountMeta,
        ),
      );
    }
    if (data.containsKey('is_paused')) {
      context.handle(
        _isPausedMeta,
        isPaused.isAcceptableOrUnknown(data['is_paused']!, _isPausedMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  RecurringTransactionRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringTransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wallet_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      toAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_amount'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      toWalletId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_wallet_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      intervalN: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_n'],
      )!,
      customUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_unit'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_date'],
      ),
      nextDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_due_date'],
      )!,
      lastGeneratedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_generated_date'],
      ),
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      templateType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_type'],
      )!,
      installmentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_count'],
      ),
      amountRemaining: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_remaining'],
      ),
      generatedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}generated_count'],
      )!,
      isPaused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paused'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurringTransactionsTable createAlias(String alias) {
    return $RecurringTransactionsTable(attachedDatabase, alias);
  }
}

class RecurringTransactionRow extends DataClass
    implements Insertable<RecurringTransactionRow> {
  final String id;
  final String walletId;

  /// income | expense | transfer
  final String type;
  final int amount;
  final String currency;
  final int? toAmount;
  final String? categoryId;
  final String? toWalletId;
  final String? note;
  final String? paymentMethod;

  /// daily | weekly | monthly | yearly | custom
  final String frequency;
  final int intervalN;
  final String? customUnit;
  final int startDate;
  final int? endDate;
  final int nextDueDate;
  final int? lastGeneratedDate;

  /// auto | ask
  final String mode;

  /// standard | committee | installment
  final String templateType;
  final int? installmentCount;
  final int? amountRemaining;
  final int generatedCount;
  final bool isPaused;
  final bool isActive;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const RecurringTransactionRow({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.currency,
    this.toAmount,
    this.categoryId,
    this.toWalletId,
    this.note,
    this.paymentMethod,
    required this.frequency,
    required this.intervalN,
    this.customUnit,
    required this.startDate,
    this.endDate,
    required this.nextDueDate,
    this.lastGeneratedDate,
    required this.mode,
    required this.templateType,
    this.installmentCount,
    this.amountRemaining,
    required this.generatedCount,
    required this.isPaused,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['wallet_id'] = Variable<String>(walletId);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<int>(amount);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || toAmount != null) {
      map['to_amount'] = Variable<int>(toAmount);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || toWalletId != null) {
      map['to_wallet_id'] = Variable<String>(toWalletId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    map['frequency'] = Variable<String>(frequency);
    map['interval_n'] = Variable<int>(intervalN);
    if (!nullToAbsent || customUnit != null) {
      map['custom_unit'] = Variable<String>(customUnit);
    }
    map['start_date'] = Variable<int>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<int>(endDate);
    }
    map['next_due_date'] = Variable<int>(nextDueDate);
    if (!nullToAbsent || lastGeneratedDate != null) {
      map['last_generated_date'] = Variable<int>(lastGeneratedDate);
    }
    map['mode'] = Variable<String>(mode);
    map['template_type'] = Variable<String>(templateType);
    if (!nullToAbsent || installmentCount != null) {
      map['installment_count'] = Variable<int>(installmentCount);
    }
    if (!nullToAbsent || amountRemaining != null) {
      map['amount_remaining'] = Variable<int>(amountRemaining);
    }
    map['generated_count'] = Variable<int>(generatedCount);
    map['is_paused'] = Variable<bool>(isPaused);
    map['is_active'] = Variable<bool>(isActive);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RecurringTransactionsCompanion toCompanion(bool nullToAbsent) {
    return RecurringTransactionsCompanion(
      id: Value(id),
      walletId: Value(walletId),
      type: Value(type),
      amount: Value(amount),
      currency: Value(currency),
      toAmount: toAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(toAmount),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      toWalletId: toWalletId == null && nullToAbsent
          ? const Value.absent()
          : Value(toWalletId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      frequency: Value(frequency),
      intervalN: Value(intervalN),
      customUnit: customUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(customUnit),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      nextDueDate: Value(nextDueDate),
      lastGeneratedDate: lastGeneratedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastGeneratedDate),
      mode: Value(mode),
      templateType: Value(templateType),
      installmentCount: installmentCount == null && nullToAbsent
          ? const Value.absent()
          : Value(installmentCount),
      amountRemaining: amountRemaining == null && nullToAbsent
          ? const Value.absent()
          : Value(amountRemaining),
      generatedCount: Value(generatedCount),
      isPaused: Value(isPaused),
      isActive: Value(isActive),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringTransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringTransactionRow(
      id: serializer.fromJson<String>(json['id']),
      walletId: serializer.fromJson<String>(json['walletId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<int>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      toAmount: serializer.fromJson<int?>(json['toAmount']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      toWalletId: serializer.fromJson<String?>(json['toWalletId']),
      note: serializer.fromJson<String?>(json['note']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      frequency: serializer.fromJson<String>(json['frequency']),
      intervalN: serializer.fromJson<int>(json['intervalN']),
      customUnit: serializer.fromJson<String?>(json['customUnit']),
      startDate: serializer.fromJson<int>(json['startDate']),
      endDate: serializer.fromJson<int?>(json['endDate']),
      nextDueDate: serializer.fromJson<int>(json['nextDueDate']),
      lastGeneratedDate: serializer.fromJson<int?>(json['lastGeneratedDate']),
      mode: serializer.fromJson<String>(json['mode']),
      templateType: serializer.fromJson<String>(json['templateType']),
      installmentCount: serializer.fromJson<int?>(json['installmentCount']),
      amountRemaining: serializer.fromJson<int?>(json['amountRemaining']),
      generatedCount: serializer.fromJson<int>(json['generatedCount']),
      isPaused: serializer.fromJson<bool>(json['isPaused']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'walletId': serializer.toJson<String>(walletId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<int>(amount),
      'currency': serializer.toJson<String>(currency),
      'toAmount': serializer.toJson<int?>(toAmount),
      'categoryId': serializer.toJson<String?>(categoryId),
      'toWalletId': serializer.toJson<String?>(toWalletId),
      'note': serializer.toJson<String?>(note),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'frequency': serializer.toJson<String>(frequency),
      'intervalN': serializer.toJson<int>(intervalN),
      'customUnit': serializer.toJson<String?>(customUnit),
      'startDate': serializer.toJson<int>(startDate),
      'endDate': serializer.toJson<int?>(endDate),
      'nextDueDate': serializer.toJson<int>(nextDueDate),
      'lastGeneratedDate': serializer.toJson<int?>(lastGeneratedDate),
      'mode': serializer.toJson<String>(mode),
      'templateType': serializer.toJson<String>(templateType),
      'installmentCount': serializer.toJson<int?>(installmentCount),
      'amountRemaining': serializer.toJson<int?>(amountRemaining),
      'generatedCount': serializer.toJson<int>(generatedCount),
      'isPaused': serializer.toJson<bool>(isPaused),
      'isActive': serializer.toJson<bool>(isActive),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  RecurringTransactionRow copyWith({
    String? id,
    String? walletId,
    String? type,
    int? amount,
    String? currency,
    Value<int?> toAmount = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> toWalletId = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> paymentMethod = const Value.absent(),
    String? frequency,
    int? intervalN,
    Value<String?> customUnit = const Value.absent(),
    int? startDate,
    Value<int?> endDate = const Value.absent(),
    int? nextDueDate,
    Value<int?> lastGeneratedDate = const Value.absent(),
    String? mode,
    String? templateType,
    Value<int?> installmentCount = const Value.absent(),
    Value<int?> amountRemaining = const Value.absent(),
    int? generatedCount,
    bool? isPaused,
    bool? isActive,
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => RecurringTransactionRow(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    toAmount: toAmount.present ? toAmount.value : this.toAmount,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    toWalletId: toWalletId.present ? toWalletId.value : this.toWalletId,
    note: note.present ? note.value : this.note,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    frequency: frequency ?? this.frequency,
    intervalN: intervalN ?? this.intervalN,
    customUnit: customUnit.present ? customUnit.value : this.customUnit,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    nextDueDate: nextDueDate ?? this.nextDueDate,
    lastGeneratedDate: lastGeneratedDate.present
        ? lastGeneratedDate.value
        : this.lastGeneratedDate,
    mode: mode ?? this.mode,
    templateType: templateType ?? this.templateType,
    installmentCount: installmentCount.present
        ? installmentCount.value
        : this.installmentCount,
    amountRemaining: amountRemaining.present
        ? amountRemaining.value
        : this.amountRemaining,
    generatedCount: generatedCount ?? this.generatedCount,
    isPaused: isPaused ?? this.isPaused,
    isActive: isActive ?? this.isActive,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurringTransactionRow copyWithCompanion(
    RecurringTransactionsCompanion data,
  ) {
    return RecurringTransactionRow(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      toAmount: data.toAmount.present ? data.toAmount.value : this.toAmount,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      toWalletId: data.toWalletId.present
          ? data.toWalletId.value
          : this.toWalletId,
      note: data.note.present ? data.note.value : this.note,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      intervalN: data.intervalN.present ? data.intervalN.value : this.intervalN,
      customUnit: data.customUnit.present
          ? data.customUnit.value
          : this.customUnit,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      nextDueDate: data.nextDueDate.present
          ? data.nextDueDate.value
          : this.nextDueDate,
      lastGeneratedDate: data.lastGeneratedDate.present
          ? data.lastGeneratedDate.value
          : this.lastGeneratedDate,
      mode: data.mode.present ? data.mode.value : this.mode,
      templateType: data.templateType.present
          ? data.templateType.value
          : this.templateType,
      installmentCount: data.installmentCount.present
          ? data.installmentCount.value
          : this.installmentCount,
      amountRemaining: data.amountRemaining.present
          ? data.amountRemaining.value
          : this.amountRemaining,
      generatedCount: data.generatedCount.present
          ? data.generatedCount.value
          : this.generatedCount,
      isPaused: data.isPaused.present ? data.isPaused.value : this.isPaused,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransactionRow(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('toAmount: $toAmount, ')
          ..write('categoryId: $categoryId, ')
          ..write('toWalletId: $toWalletId, ')
          ..write('note: $note, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('frequency: $frequency, ')
          ..write('intervalN: $intervalN, ')
          ..write('customUnit: $customUnit, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('lastGeneratedDate: $lastGeneratedDate, ')
          ..write('mode: $mode, ')
          ..write('templateType: $templateType, ')
          ..write('installmentCount: $installmentCount, ')
          ..write('amountRemaining: $amountRemaining, ')
          ..write('generatedCount: $generatedCount, ')
          ..write('isPaused: $isPaused, ')
          ..write('isActive: $isActive, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    walletId,
    type,
    amount,
    currency,
    toAmount,
    categoryId,
    toWalletId,
    note,
    paymentMethod,
    frequency,
    intervalN,
    customUnit,
    startDate,
    endDate,
    nextDueDate,
    lastGeneratedDate,
    mode,
    templateType,
    installmentCount,
    amountRemaining,
    generatedCount,
    isPaused,
    isActive,
    isDeleted,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringTransactionRow &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.toAmount == this.toAmount &&
          other.categoryId == this.categoryId &&
          other.toWalletId == this.toWalletId &&
          other.note == this.note &&
          other.paymentMethod == this.paymentMethod &&
          other.frequency == this.frequency &&
          other.intervalN == this.intervalN &&
          other.customUnit == this.customUnit &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.nextDueDate == this.nextDueDate &&
          other.lastGeneratedDate == this.lastGeneratedDate &&
          other.mode == this.mode &&
          other.templateType == this.templateType &&
          other.installmentCount == this.installmentCount &&
          other.amountRemaining == this.amountRemaining &&
          other.generatedCount == this.generatedCount &&
          other.isPaused == this.isPaused &&
          other.isActive == this.isActive &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurringTransactionsCompanion
    extends UpdateCompanion<RecurringTransactionRow> {
  final Value<String> id;
  final Value<String> walletId;
  final Value<String> type;
  final Value<int> amount;
  final Value<String> currency;
  final Value<int?> toAmount;
  final Value<String?> categoryId;
  final Value<String?> toWalletId;
  final Value<String?> note;
  final Value<String?> paymentMethod;
  final Value<String> frequency;
  final Value<int> intervalN;
  final Value<String?> customUnit;
  final Value<int> startDate;
  final Value<int?> endDate;
  final Value<int> nextDueDate;
  final Value<int?> lastGeneratedDate;
  final Value<String> mode;
  final Value<String> templateType;
  final Value<int?> installmentCount;
  final Value<int?> amountRemaining;
  final Value<int> generatedCount;
  final Value<bool> isPaused;
  final Value<bool> isActive;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RecurringTransactionsCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.toAmount = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.toWalletId = const Value.absent(),
    this.note = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.frequency = const Value.absent(),
    this.intervalN = const Value.absent(),
    this.customUnit = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.lastGeneratedDate = const Value.absent(),
    this.mode = const Value.absent(),
    this.templateType = const Value.absent(),
    this.installmentCount = const Value.absent(),
    this.amountRemaining = const Value.absent(),
    this.generatedCount = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringTransactionsCompanion.insert({
    required String id,
    required String walletId,
    required String type,
    required int amount,
    this.currency = const Value.absent(),
    this.toAmount = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.toWalletId = const Value.absent(),
    this.note = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    required String frequency,
    this.intervalN = const Value.absent(),
    this.customUnit = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    required int nextDueDate,
    this.lastGeneratedDate = const Value.absent(),
    this.mode = const Value.absent(),
    this.templateType = const Value.absent(),
    this.installmentCount = const Value.absent(),
    this.amountRemaining = const Value.absent(),
    this.generatedCount = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       walletId = Value(walletId),
       type = Value(type),
       amount = Value(amount),
       frequency = Value(frequency),
       nextDueDate = Value(nextDueDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RecurringTransactionRow> custom({
    Expression<String>? id,
    Expression<String>? walletId,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<String>? currency,
    Expression<int>? toAmount,
    Expression<String>? categoryId,
    Expression<String>? toWalletId,
    Expression<String>? note,
    Expression<String>? paymentMethod,
    Expression<String>? frequency,
    Expression<int>? intervalN,
    Expression<String>? customUnit,
    Expression<int>? startDate,
    Expression<int>? endDate,
    Expression<int>? nextDueDate,
    Expression<int>? lastGeneratedDate,
    Expression<String>? mode,
    Expression<String>? templateType,
    Expression<int>? installmentCount,
    Expression<int>? amountRemaining,
    Expression<int>? generatedCount,
    Expression<bool>? isPaused,
    Expression<bool>? isActive,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (toAmount != null) 'to_amount': toAmount,
      if (categoryId != null) 'category_id': categoryId,
      if (toWalletId != null) 'to_wallet_id': toWalletId,
      if (note != null) 'note': note,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (frequency != null) 'frequency': frequency,
      if (intervalN != null) 'interval_n': intervalN,
      if (customUnit != null) 'custom_unit': customUnit,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (lastGeneratedDate != null) 'last_generated_date': lastGeneratedDate,
      if (mode != null) 'mode': mode,
      if (templateType != null) 'template_type': templateType,
      if (installmentCount != null) 'installment_count': installmentCount,
      if (amountRemaining != null) 'amount_remaining': amountRemaining,
      if (generatedCount != null) 'generated_count': generatedCount,
      if (isPaused != null) 'is_paused': isPaused,
      if (isActive != null) 'is_active': isActive,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? walletId,
    Value<String>? type,
    Value<int>? amount,
    Value<String>? currency,
    Value<int?>? toAmount,
    Value<String?>? categoryId,
    Value<String?>? toWalletId,
    Value<String?>? note,
    Value<String?>? paymentMethod,
    Value<String>? frequency,
    Value<int>? intervalN,
    Value<String?>? customUnit,
    Value<int>? startDate,
    Value<int?>? endDate,
    Value<int>? nextDueDate,
    Value<int?>? lastGeneratedDate,
    Value<String>? mode,
    Value<String>? templateType,
    Value<int?>? installmentCount,
    Value<int?>? amountRemaining,
    Value<int>? generatedCount,
    Value<bool>? isPaused,
    Value<bool>? isActive,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecurringTransactionsCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      toAmount: toAmount ?? this.toAmount,
      categoryId: categoryId ?? this.categoryId,
      toWalletId: toWalletId ?? this.toWalletId,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      frequency: frequency ?? this.frequency,
      intervalN: intervalN ?? this.intervalN,
      customUnit: customUnit ?? this.customUnit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      lastGeneratedDate: lastGeneratedDate ?? this.lastGeneratedDate,
      mode: mode ?? this.mode,
      templateType: templateType ?? this.templateType,
      installmentCount: installmentCount ?? this.installmentCount,
      amountRemaining: amountRemaining ?? this.amountRemaining,
      generatedCount: generatedCount ?? this.generatedCount,
      isPaused: isPaused ?? this.isPaused,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (walletId.present) {
      map['wallet_id'] = Variable<String>(walletId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (toAmount.present) {
      map['to_amount'] = Variable<int>(toAmount.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (toWalletId.present) {
      map['to_wallet_id'] = Variable<String>(toWalletId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (intervalN.present) {
      map['interval_n'] = Variable<int>(intervalN.value);
    }
    if (customUnit.present) {
      map['custom_unit'] = Variable<String>(customUnit.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<int>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<int>(endDate.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<int>(nextDueDate.value);
    }
    if (lastGeneratedDate.present) {
      map['last_generated_date'] = Variable<int>(lastGeneratedDate.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (templateType.present) {
      map['template_type'] = Variable<String>(templateType.value);
    }
    if (installmentCount.present) {
      map['installment_count'] = Variable<int>(installmentCount.value);
    }
    if (amountRemaining.present) {
      map['amount_remaining'] = Variable<int>(amountRemaining.value);
    }
    if (generatedCount.present) {
      map['generated_count'] = Variable<int>(generatedCount.value);
    }
    if (isPaused.present) {
      map['is_paused'] = Variable<bool>(isPaused.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('toAmount: $toAmount, ')
          ..write('categoryId: $categoryId, ')
          ..write('toWalletId: $toWalletId, ')
          ..write('note: $note, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('frequency: $frequency, ')
          ..write('intervalN: $intervalN, ')
          ..write('customUnit: $customUnit, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('lastGeneratedDate: $lastGeneratedDate, ')
          ..write('mode: $mode, ')
          ..write('templateType: $templateType, ')
          ..write('installmentCount: $installmentCount, ')
          ..write('amountRemaining: $amountRemaining, ')
          ..write('generatedCount: $generatedCount, ')
          ..write('isPaused: $isPaused, ')
          ..write('isActive: $isActive, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, ReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PKR'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<int> dueDate = GeneratedColumn<int>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatFrequencyMeta = const VerificationMeta(
    'repeatFrequency',
  );
  @override
  late final GeneratedColumn<String> repeatFrequency = GeneratedColumn<String>(
    'repeat_frequency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindDaysBeforeMeta = const VerificationMeta(
    'remindDaysBefore',
  );
  @override
  late final GeneratedColumn<int> remindDaysBefore = GeneratedColumn<int>(
    'remind_days_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dailyTimeMinutesMeta = const VerificationMeta(
    'dailyTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyTimeMinutes = GeneratedColumn<int>(
    'daily_time_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<String> walletId = GeneratedColumn<String>(
    'wallet_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bill'),
  );
  static const VerificationMeta _linkedTypeMeta = const VerificationMeta(
    'linkedType',
  );
  @override
  late final GeneratedColumn<String> linkedType = GeneratedColumn<String>(
    'linked_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedIdMeta = const VerificationMeta(
    'linkedId',
  );
  @override
  late final GeneratedColumn<String> linkedId = GeneratedColumn<String>(
    'linked_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paidTransactionIdMeta = const VerificationMeta(
    'paidTransactionId',
  );
  @override
  late final GeneratedColumn<String> paidTransactionId =
      GeneratedColumn<String>(
        'paid_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastNotifiedAtMeta = const VerificationMeta(
    'lastNotifiedAt',
  );
  @override
  late final GeneratedColumn<int> lastNotifiedAt = GeneratedColumn<int>(
    'last_notified_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amount,
    currency,
    note,
    dueDate,
    repeatFrequency,
    remindDaysBefore,
    dailyTimeMinutes,
    walletId,
    categoryId,
    type,
    linkedType,
    linkedId,
    paidTransactionId,
    isDone,
    lastNotifiedAt,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('repeat_frequency')) {
      context.handle(
        _repeatFrequencyMeta,
        repeatFrequency.isAcceptableOrUnknown(
          data['repeat_frequency']!,
          _repeatFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('remind_days_before')) {
      context.handle(
        _remindDaysBeforeMeta,
        remindDaysBefore.isAcceptableOrUnknown(
          data['remind_days_before']!,
          _remindDaysBeforeMeta,
        ),
      );
    }
    if (data.containsKey('daily_time_minutes')) {
      context.handle(
        _dailyTimeMinutesMeta,
        dailyTimeMinutes.isAcceptableOrUnknown(
          data['daily_time_minutes']!,
          _dailyTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('linked_type')) {
      context.handle(
        _linkedTypeMeta,
        linkedType.isAcceptableOrUnknown(data['linked_type']!, _linkedTypeMeta),
      );
    }
    if (data.containsKey('linked_id')) {
      context.handle(
        _linkedIdMeta,
        linkedId.isAcceptableOrUnknown(data['linked_id']!, _linkedIdMeta),
      );
    }
    if (data.containsKey('paid_transaction_id')) {
      context.handle(
        _paidTransactionIdMeta,
        paidTransactionId.isAcceptableOrUnknown(
          data['paid_transaction_id']!,
          _paidTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('last_notified_at')) {
      context.handle(
        _lastNotifiedAtMeta,
        lastNotifiedAt.isAcceptableOrUnknown(
          data['last_notified_at']!,
          _lastNotifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  ReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_date'],
      )!,
      repeatFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_frequency'],
      ),
      remindDaysBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remind_days_before'],
      )!,
      dailyTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_time_minutes'],
      ),
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wallet_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      linkedType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_type'],
      ),
      linkedId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_id'],
      ),
      paidTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_transaction_id'],
      ),
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      lastNotifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_notified_at'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class ReminderRow extends DataClass implements Insertable<ReminderRow> {
  final String id;
  final String title;
  final int? amount;
  final String currency;
  final String? note;
  final int dueDate;

  /// null = one-shot; else daily | weekly | monthly | yearly
  final String? repeatFrequency;
  final int remindDaysBefore;
  final int? dailyTimeMinutes;
  final String? walletId;
  final String? categoryId;

  /// bill | recurring | budget | daily_expense
  final String type;
  final String? linkedType;
  final String? linkedId;
  final String? paidTransactionId;
  final bool isDone;
  final int? lastNotifiedAt;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const ReminderRow({
    required this.id,
    required this.title,
    this.amount,
    required this.currency,
    this.note,
    required this.dueDate,
    this.repeatFrequency,
    required this.remindDaysBefore,
    this.dailyTimeMinutes,
    this.walletId,
    this.categoryId,
    required this.type,
    this.linkedType,
    this.linkedId,
    this.paidTransactionId,
    required this.isDone,
    this.lastNotifiedAt,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<int>(amount);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['due_date'] = Variable<int>(dueDate);
    if (!nullToAbsent || repeatFrequency != null) {
      map['repeat_frequency'] = Variable<String>(repeatFrequency);
    }
    map['remind_days_before'] = Variable<int>(remindDaysBefore);
    if (!nullToAbsent || dailyTimeMinutes != null) {
      map['daily_time_minutes'] = Variable<int>(dailyTimeMinutes);
    }
    if (!nullToAbsent || walletId != null) {
      map['wallet_id'] = Variable<String>(walletId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || linkedType != null) {
      map['linked_type'] = Variable<String>(linkedType);
    }
    if (!nullToAbsent || linkedId != null) {
      map['linked_id'] = Variable<String>(linkedId);
    }
    if (!nullToAbsent || paidTransactionId != null) {
      map['paid_transaction_id'] = Variable<String>(paidTransactionId);
    }
    map['is_done'] = Variable<bool>(isDone);
    if (!nullToAbsent || lastNotifiedAt != null) {
      map['last_notified_at'] = Variable<int>(lastNotifiedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      title: Value(title),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      currency: Value(currency),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      dueDate: Value(dueDate),
      repeatFrequency: repeatFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatFrequency),
      remindDaysBefore: Value(remindDaysBefore),
      dailyTimeMinutes: dailyTimeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyTimeMinutes),
      walletId: walletId == null && nullToAbsent
          ? const Value.absent()
          : Value(walletId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      type: Value(type),
      linkedType: linkedType == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedType),
      linkedId: linkedId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedId),
      paidTransactionId: paidTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(paidTransactionId),
      isDone: Value(isDone),
      lastNotifiedAt: lastNotifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNotifiedAt),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<int?>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      note: serializer.fromJson<String?>(json['note']),
      dueDate: serializer.fromJson<int>(json['dueDate']),
      repeatFrequency: serializer.fromJson<String?>(json['repeatFrequency']),
      remindDaysBefore: serializer.fromJson<int>(json['remindDaysBefore']),
      dailyTimeMinutes: serializer.fromJson<int?>(json['dailyTimeMinutes']),
      walletId: serializer.fromJson<String?>(json['walletId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      type: serializer.fromJson<String>(json['type']),
      linkedType: serializer.fromJson<String?>(json['linkedType']),
      linkedId: serializer.fromJson<String?>(json['linkedId']),
      paidTransactionId: serializer.fromJson<String?>(
        json['paidTransactionId'],
      ),
      isDone: serializer.fromJson<bool>(json['isDone']),
      lastNotifiedAt: serializer.fromJson<int?>(json['lastNotifiedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<int?>(amount),
      'currency': serializer.toJson<String>(currency),
      'note': serializer.toJson<String?>(note),
      'dueDate': serializer.toJson<int>(dueDate),
      'repeatFrequency': serializer.toJson<String?>(repeatFrequency),
      'remindDaysBefore': serializer.toJson<int>(remindDaysBefore),
      'dailyTimeMinutes': serializer.toJson<int?>(dailyTimeMinutes),
      'walletId': serializer.toJson<String?>(walletId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'type': serializer.toJson<String>(type),
      'linkedType': serializer.toJson<String?>(linkedType),
      'linkedId': serializer.toJson<String?>(linkedId),
      'paidTransactionId': serializer.toJson<String?>(paidTransactionId),
      'isDone': serializer.toJson<bool>(isDone),
      'lastNotifiedAt': serializer.toJson<int?>(lastNotifiedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ReminderRow copyWith({
    String? id,
    String? title,
    Value<int?> amount = const Value.absent(),
    String? currency,
    Value<String?> note = const Value.absent(),
    int? dueDate,
    Value<String?> repeatFrequency = const Value.absent(),
    int? remindDaysBefore,
    Value<int?> dailyTimeMinutes = const Value.absent(),
    Value<String?> walletId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    String? type,
    Value<String?> linkedType = const Value.absent(),
    Value<String?> linkedId = const Value.absent(),
    Value<String?> paidTransactionId = const Value.absent(),
    bool? isDone,
    Value<int?> lastNotifiedAt = const Value.absent(),
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => ReminderRow(
    id: id ?? this.id,
    title: title ?? this.title,
    amount: amount.present ? amount.value : this.amount,
    currency: currency ?? this.currency,
    note: note.present ? note.value : this.note,
    dueDate: dueDate ?? this.dueDate,
    repeatFrequency: repeatFrequency.present
        ? repeatFrequency.value
        : this.repeatFrequency,
    remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
    dailyTimeMinutes: dailyTimeMinutes.present
        ? dailyTimeMinutes.value
        : this.dailyTimeMinutes,
    walletId: walletId.present ? walletId.value : this.walletId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    type: type ?? this.type,
    linkedType: linkedType.present ? linkedType.value : this.linkedType,
    linkedId: linkedId.present ? linkedId.value : this.linkedId,
    paidTransactionId: paidTransactionId.present
        ? paidTransactionId.value
        : this.paidTransactionId,
    isDone: isDone ?? this.isDone,
    lastNotifiedAt: lastNotifiedAt.present
        ? lastNotifiedAt.value
        : this.lastNotifiedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReminderRow copyWithCompanion(RemindersCompanion data) {
    return ReminderRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      note: data.note.present ? data.note.value : this.note,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      repeatFrequency: data.repeatFrequency.present
          ? data.repeatFrequency.value
          : this.repeatFrequency,
      remindDaysBefore: data.remindDaysBefore.present
          ? data.remindDaysBefore.value
          : this.remindDaysBefore,
      dailyTimeMinutes: data.dailyTimeMinutes.present
          ? data.dailyTimeMinutes.value
          : this.dailyTimeMinutes,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      type: data.type.present ? data.type.value : this.type,
      linkedType: data.linkedType.present
          ? data.linkedType.value
          : this.linkedType,
      linkedId: data.linkedId.present ? data.linkedId.value : this.linkedId,
      paidTransactionId: data.paidTransactionId.present
          ? data.paidTransactionId.value
          : this.paidTransactionId,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      lastNotifiedAt: data.lastNotifiedAt.present
          ? data.lastNotifiedAt.value
          : this.lastNotifiedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('note: $note, ')
          ..write('dueDate: $dueDate, ')
          ..write('repeatFrequency: $repeatFrequency, ')
          ..write('remindDaysBefore: $remindDaysBefore, ')
          ..write('dailyTimeMinutes: $dailyTimeMinutes, ')
          ..write('walletId: $walletId, ')
          ..write('categoryId: $categoryId, ')
          ..write('type: $type, ')
          ..write('linkedType: $linkedType, ')
          ..write('linkedId: $linkedId, ')
          ..write('paidTransactionId: $paidTransactionId, ')
          ..write('isDone: $isDone, ')
          ..write('lastNotifiedAt: $lastNotifiedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    amount,
    currency,
    note,
    dueDate,
    repeatFrequency,
    remindDaysBefore,
    dailyTimeMinutes,
    walletId,
    categoryId,
    type,
    linkedType,
    linkedId,
    paidTransactionId,
    isDone,
    lastNotifiedAt,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.note == this.note &&
          other.dueDate == this.dueDate &&
          other.repeatFrequency == this.repeatFrequency &&
          other.remindDaysBefore == this.remindDaysBefore &&
          other.dailyTimeMinutes == this.dailyTimeMinutes &&
          other.walletId == this.walletId &&
          other.categoryId == this.categoryId &&
          other.type == this.type &&
          other.linkedType == this.linkedType &&
          other.linkedId == this.linkedId &&
          other.paidTransactionId == this.paidTransactionId &&
          other.isDone == this.isDone &&
          other.lastNotifiedAt == this.lastNotifiedAt &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RemindersCompanion extends UpdateCompanion<ReminderRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<int?> amount;
  final Value<String> currency;
  final Value<String?> note;
  final Value<int> dueDate;
  final Value<String?> repeatFrequency;
  final Value<int> remindDaysBefore;
  final Value<int?> dailyTimeMinutes;
  final Value<String?> walletId;
  final Value<String?> categoryId;
  final Value<String> type;
  final Value<String?> linkedType;
  final Value<String?> linkedId;
  final Value<String?> paidTransactionId;
  final Value<bool> isDone;
  final Value<int?> lastNotifiedAt;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.note = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.repeatFrequency = const Value.absent(),
    this.remindDaysBefore = const Value.absent(),
    this.dailyTimeMinutes = const Value.absent(),
    this.walletId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.type = const Value.absent(),
    this.linkedType = const Value.absent(),
    this.linkedId = const Value.absent(),
    this.paidTransactionId = const Value.absent(),
    this.isDone = const Value.absent(),
    this.lastNotifiedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String title,
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.note = const Value.absent(),
    required int dueDate,
    this.repeatFrequency = const Value.absent(),
    this.remindDaysBefore = const Value.absent(),
    this.dailyTimeMinutes = const Value.absent(),
    this.walletId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.type = const Value.absent(),
    this.linkedType = const Value.absent(),
    this.linkedId = const Value.absent(),
    this.paidTransactionId = const Value.absent(),
    this.isDone = const Value.absent(),
    this.lastNotifiedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       dueDate = Value(dueDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReminderRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? amount,
    Expression<String>? currency,
    Expression<String>? note,
    Expression<int>? dueDate,
    Expression<String>? repeatFrequency,
    Expression<int>? remindDaysBefore,
    Expression<int>? dailyTimeMinutes,
    Expression<String>? walletId,
    Expression<String>? categoryId,
    Expression<String>? type,
    Expression<String>? linkedType,
    Expression<String>? linkedId,
    Expression<String>? paidTransactionId,
    Expression<bool>? isDone,
    Expression<int>? lastNotifiedAt,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (note != null) 'note': note,
      if (dueDate != null) 'due_date': dueDate,
      if (repeatFrequency != null) 'repeat_frequency': repeatFrequency,
      if (remindDaysBefore != null) 'remind_days_before': remindDaysBefore,
      if (dailyTimeMinutes != null) 'daily_time_minutes': dailyTimeMinutes,
      if (walletId != null) 'wallet_id': walletId,
      if (categoryId != null) 'category_id': categoryId,
      if (type != null) 'type': type,
      if (linkedType != null) 'linked_type': linkedType,
      if (linkedId != null) 'linked_id': linkedId,
      if (paidTransactionId != null) 'paid_transaction_id': paidTransactionId,
      if (isDone != null) 'is_done': isDone,
      if (lastNotifiedAt != null) 'last_notified_at': lastNotifiedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<int?>? amount,
    Value<String>? currency,
    Value<String?>? note,
    Value<int>? dueDate,
    Value<String?>? repeatFrequency,
    Value<int>? remindDaysBefore,
    Value<int?>? dailyTimeMinutes,
    Value<String?>? walletId,
    Value<String?>? categoryId,
    Value<String>? type,
    Value<String?>? linkedType,
    Value<String?>? linkedId,
    Value<String?>? paidTransactionId,
    Value<bool>? isDone,
    Value<int?>? lastNotifiedAt,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      note: note ?? this.note,
      dueDate: dueDate ?? this.dueDate,
      repeatFrequency: repeatFrequency ?? this.repeatFrequency,
      remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
      dailyTimeMinutes: dailyTimeMinutes ?? this.dailyTimeMinutes,
      walletId: walletId ?? this.walletId,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      linkedType: linkedType ?? this.linkedType,
      linkedId: linkedId ?? this.linkedId,
      paidTransactionId: paidTransactionId ?? this.paidTransactionId,
      isDone: isDone ?? this.isDone,
      lastNotifiedAt: lastNotifiedAt ?? this.lastNotifiedAt,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<int>(dueDate.value);
    }
    if (repeatFrequency.present) {
      map['repeat_frequency'] = Variable<String>(repeatFrequency.value);
    }
    if (remindDaysBefore.present) {
      map['remind_days_before'] = Variable<int>(remindDaysBefore.value);
    }
    if (dailyTimeMinutes.present) {
      map['daily_time_minutes'] = Variable<int>(dailyTimeMinutes.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<String>(walletId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (linkedType.present) {
      map['linked_type'] = Variable<String>(linkedType.value);
    }
    if (linkedId.present) {
      map['linked_id'] = Variable<String>(linkedId.value);
    }
    if (paidTransactionId.present) {
      map['paid_transaction_id'] = Variable<String>(paidTransactionId.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (lastNotifiedAt.present) {
      map['last_notified_at'] = Variable<int>(lastNotifiedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('note: $note, ')
          ..write('dueDate: $dueDate, ')
          ..write('repeatFrequency: $repeatFrequency, ')
          ..write('remindDaysBefore: $remindDaysBefore, ')
          ..write('dailyTimeMinutes: $dailyTimeMinutes, ')
          ..write('walletId: $walletId, ')
          ..write('categoryId: $categoryId, ')
          ..write('type: $type, ')
          ..write('linkedType: $linkedType, ')
          ..write('linkedId: $linkedId, ')
          ..write('paidTransactionId: $paidTransactionId, ')
          ..write('isDone: $isDone, ')
          ..write('lastNotifiedAt: $lastNotifiedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommitteesTable extends Committees
    with TableInfo<$CommitteesTable, CommitteeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommitteesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _monthlyAmountMeta = const VerificationMeta(
    'monthlyAmount',
  );
  @override
  late final GeneratedColumn<int> monthlyAmount = GeneratedColumn<int>(
    'monthly_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMembersMeta = const VerificationMeta(
    'totalMembers',
  );
  @override
  late final GeneratedColumn<int> totalMembers = GeneratedColumn<int>(
    'total_members',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _myTurnMonthMeta = const VerificationMeta(
    'myTurnMonth',
  );
  @override
  late final GeneratedColumn<int> myTurnMonth = GeneratedColumn<int>(
    'my_turn_month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<int> startDate = GeneratedColumn<int>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
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
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    monthlyAmount,
    totalMembers,
    myTurnMonth,
    startDate,
    status,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'committees';
  @override
  VerificationContext validateIntegrity(
    Insertable<CommitteeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('monthly_amount')) {
      context.handle(
        _monthlyAmountMeta,
        monthlyAmount.isAcceptableOrUnknown(
          data['monthly_amount']!,
          _monthlyAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyAmountMeta);
    }
    if (data.containsKey('total_members')) {
      context.handle(
        _totalMembersMeta,
        totalMembers.isAcceptableOrUnknown(
          data['total_members']!,
          _totalMembersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalMembersMeta);
    }
    if (data.containsKey('my_turn_month')) {
      context.handle(
        _myTurnMonthMeta,
        myTurnMonth.isAcceptableOrUnknown(
          data['my_turn_month']!,
          _myTurnMonthMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  CommitteeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommitteeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      monthlyAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_amount'],
      )!,
      totalMembers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_members'],
      )!,
      myTurnMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}my_turn_month'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CommitteesTable createAlias(String alias) {
    return $CommitteesTable(attachedDatabase, alias);
  }
}

class CommitteeRow extends DataClass implements Insertable<CommitteeRow> {
  final String id;
  final String name;
  final int monthlyAmount;
  final int totalMembers;
  final int? myTurnMonth;
  final int startDate;
  final String status;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const CommitteeRow({
    required this.id,
    required this.name,
    required this.monthlyAmount,
    required this.totalMembers,
    this.myTurnMonth,
    required this.startDate,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['monthly_amount'] = Variable<int>(monthlyAmount);
    map['total_members'] = Variable<int>(totalMembers);
    if (!nullToAbsent || myTurnMonth != null) {
      map['my_turn_month'] = Variable<int>(myTurnMonth);
    }
    map['start_date'] = Variable<int>(startDate);
    map['status'] = Variable<String>(status);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CommitteesCompanion toCompanion(bool nullToAbsent) {
    return CommitteesCompanion(
      id: Value(id),
      name: Value(name),
      monthlyAmount: Value(monthlyAmount),
      totalMembers: Value(totalMembers),
      myTurnMonth: myTurnMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(myTurnMonth),
      startDate: Value(startDate),
      status: Value(status),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CommitteeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommitteeRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      monthlyAmount: serializer.fromJson<int>(json['monthlyAmount']),
      totalMembers: serializer.fromJson<int>(json['totalMembers']),
      myTurnMonth: serializer.fromJson<int?>(json['myTurnMonth']),
      startDate: serializer.fromJson<int>(json['startDate']),
      status: serializer.fromJson<String>(json['status']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'monthlyAmount': serializer.toJson<int>(monthlyAmount),
      'totalMembers': serializer.toJson<int>(totalMembers),
      'myTurnMonth': serializer.toJson<int?>(myTurnMonth),
      'startDate': serializer.toJson<int>(startDate),
      'status': serializer.toJson<String>(status),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  CommitteeRow copyWith({
    String? id,
    String? name,
    int? monthlyAmount,
    int? totalMembers,
    Value<int?> myTurnMonth = const Value.absent(),
    int? startDate,
    String? status,
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => CommitteeRow(
    id: id ?? this.id,
    name: name ?? this.name,
    monthlyAmount: monthlyAmount ?? this.monthlyAmount,
    totalMembers: totalMembers ?? this.totalMembers,
    myTurnMonth: myTurnMonth.present ? myTurnMonth.value : this.myTurnMonth,
    startDate: startDate ?? this.startDate,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CommitteeRow copyWithCompanion(CommitteesCompanion data) {
    return CommitteeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      monthlyAmount: data.monthlyAmount.present
          ? data.monthlyAmount.value
          : this.monthlyAmount,
      totalMembers: data.totalMembers.present
          ? data.totalMembers.value
          : this.totalMembers,
      myTurnMonth: data.myTurnMonth.present
          ? data.myTurnMonth.value
          : this.myTurnMonth,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      status: data.status.present ? data.status.value : this.status,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommitteeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('monthlyAmount: $monthlyAmount, ')
          ..write('totalMembers: $totalMembers, ')
          ..write('myTurnMonth: $myTurnMonth, ')
          ..write('startDate: $startDate, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    monthlyAmount,
    totalMembers,
    myTurnMonth,
    startDate,
    status,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommitteeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.monthlyAmount == this.monthlyAmount &&
          other.totalMembers == this.totalMembers &&
          other.myTurnMonth == this.myTurnMonth &&
          other.startDate == this.startDate &&
          other.status == this.status &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CommitteesCompanion extends UpdateCompanion<CommitteeRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> monthlyAmount;
  final Value<int> totalMembers;
  final Value<int?> myTurnMonth;
  final Value<int> startDate;
  final Value<String> status;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CommitteesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.monthlyAmount = const Value.absent(),
    this.totalMembers = const Value.absent(),
    this.myTurnMonth = const Value.absent(),
    this.startDate = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommitteesCompanion.insert({
    required String id,
    required String name,
    required int monthlyAmount,
    required int totalMembers,
    this.myTurnMonth = const Value.absent(),
    required int startDate,
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       monthlyAmount = Value(monthlyAmount),
       totalMembers = Value(totalMembers),
       startDate = Value(startDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CommitteeRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? monthlyAmount,
    Expression<int>? totalMembers,
    Expression<int>? myTurnMonth,
    Expression<int>? startDate,
    Expression<String>? status,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (monthlyAmount != null) 'monthly_amount': monthlyAmount,
      if (totalMembers != null) 'total_members': totalMembers,
      if (myTurnMonth != null) 'my_turn_month': myTurnMonth,
      if (startDate != null) 'start_date': startDate,
      if (status != null) 'status': status,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommitteesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? monthlyAmount,
    Value<int>? totalMembers,
    Value<int?>? myTurnMonth,
    Value<int>? startDate,
    Value<String>? status,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CommitteesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      monthlyAmount: monthlyAmount ?? this.monthlyAmount,
      totalMembers: totalMembers ?? this.totalMembers,
      myTurnMonth: myTurnMonth ?? this.myTurnMonth,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (monthlyAmount.present) {
      map['monthly_amount'] = Variable<int>(monthlyAmount.value);
    }
    if (totalMembers.present) {
      map['total_members'] = Variable<int>(totalMembers.value);
    }
    if (myTurnMonth.present) {
      map['my_turn_month'] = Variable<int>(myTurnMonth.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<int>(startDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommitteesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('monthlyAmount: $monthlyAmount, ')
          ..write('totalMembers: $totalMembers, ')
          ..write('myTurnMonth: $myTurnMonth, ')
          ..write('startDate: $startDate, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<int> targetAmount = GeneratedColumn<int>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAmountMeta = const VerificationMeta(
    'savedAmount',
  );
  @override
  late final GeneratedColumn<int> savedAmount = GeneratedColumn<int>(
    'saved_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<int> targetDate = GeneratedColumn<int>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    targetAmount,
    savedAmount,
    targetDate,
    isDeleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('saved_amount')) {
      context.handle(
        _savedAmountMeta,
        savedAmount.isAcceptableOrUnknown(
          data['saved_amount']!,
          _savedAmountMeta,
        ),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
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
  SavingsGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoalRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount'],
      )!,
      savedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saved_amount'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_date'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }
}

class SavingsGoalRow extends DataClass implements Insertable<SavingsGoalRow> {
  final String id;
  final String name;
  final int targetAmount;
  final int savedAmount;
  final int? targetDate;
  final bool isDeleted;
  final int createdAt;
  final int updatedAt;
  const SavingsGoalRow({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    this.targetDate,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['target_amount'] = Variable<int>(targetAmount);
    map['saved_amount'] = Variable<int>(savedAmount);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<int>(targetDate);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      name: Value(name),
      targetAmount: Value(targetAmount),
      savedAmount: Value(savedAmount),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SavingsGoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoalRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetAmount: serializer.fromJson<int>(json['targetAmount']),
      savedAmount: serializer.fromJson<int>(json['savedAmount']),
      targetDate: serializer.fromJson<int?>(json['targetDate']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'targetAmount': serializer.toJson<int>(targetAmount),
      'savedAmount': serializer.toJson<int>(savedAmount),
      'targetDate': serializer.toJson<int?>(targetDate),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SavingsGoalRow copyWith({
    String? id,
    String? name,
    int? targetAmount,
    int? savedAmount,
    Value<int?> targetDate = const Value.absent(),
    bool? isDeleted,
    int? createdAt,
    int? updatedAt,
  }) => SavingsGoalRow(
    id: id ?? this.id,
    name: name ?? this.name,
    targetAmount: targetAmount ?? this.targetAmount,
    savedAmount: savedAmount ?? this.savedAmount,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SavingsGoalRow copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoalRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      savedAmount: data.savedAmount.present
          ? data.savedAmount.value
          : this.savedAmount,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('savedAmount: $savedAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    targetAmount,
    savedAmount,
    targetDate,
    isDeleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoalRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetAmount == this.targetAmount &&
          other.savedAmount == this.savedAmount &&
          other.targetDate == this.targetDate &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoalRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> targetAmount;
  final Value<int> savedAmount;
  final Value<int?> targetDate;
  final Value<bool> isDeleted;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.savedAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    required String id,
    required String name,
    required int targetAmount,
    this.savedAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       targetAmount = Value(targetAmount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SavingsGoalRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? targetAmount,
    Expression<int>? savedAmount,
    Expression<int>? targetDate,
    Expression<bool>? isDeleted,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (savedAmount != null) 'saved_amount': savedAmount,
      if (targetDate != null) 'target_date': targetDate,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavingsGoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? targetAmount,
    Value<int>? savedAmount,
    Value<int?>? targetDate,
    Value<bool>? isDeleted,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      targetDate: targetDate ?? this.targetDate,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<int>(targetAmount.value);
    }
    if (savedAmount.present) {
      map['saved_amount'] = Variable<int>(savedAmount.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<int>(targetDate.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('savedAmount: $savedAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTable extends ExchangeRates
    with TableInfo<$ExchangeRatesTable, ExchangeRateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fromCurrencyMeta = const VerificationMeta(
    'fromCurrency',
  );
  @override
  late final GeneratedColumn<String> fromCurrency = GeneratedColumn<String>(
    'from_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toCurrencyMeta = const VerificationMeta(
    'toCurrency',
  );
  @override
  late final GeneratedColumn<String> toCurrency = GeneratedColumn<String>(
    'to_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<String> rate = GeneratedColumn<String>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    fromCurrency,
    toCurrency,
    rate,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExchangeRateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('from_currency')) {
      context.handle(
        _fromCurrencyMeta,
        fromCurrency.isAcceptableOrUnknown(
          data['from_currency']!,
          _fromCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromCurrencyMeta);
    }
    if (data.containsKey('to_currency')) {
      context.handle(
        _toCurrencyMeta,
        toCurrency.isAcceptableOrUnknown(data['to_currency']!, _toCurrencyMeta),
      );
    } else if (isInserting) {
      context.missing(_toCurrencyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
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
  Set<GeneratedColumn> get $primaryKey => {fromCurrency, toCurrency};
  @override
  ExchangeRateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRateRow(
      fromCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_currency'],
      )!,
      toCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_currency'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rate'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExchangeRatesTable createAlias(String alias) {
    return $ExchangeRatesTable(attachedDatabase, alias);
  }
}

class ExchangeRateRow extends DataClass implements Insertable<ExchangeRateRow> {
  final String fromCurrency;
  final String toCurrency;

  /// Decimal string: 1 major [fromCurrency] = rate major [toCurrency].
  final String rate;
  final int updatedAt;
  const ExchangeRateRow({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['from_currency'] = Variable<String>(fromCurrency);
    map['to_currency'] = Variable<String>(toCurrency);
    map['rate'] = Variable<String>(rate);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesCompanion(
      fromCurrency: Value(fromCurrency),
      toCurrency: Value(toCurrency),
      rate: Value(rate),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExchangeRateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRateRow(
      fromCurrency: serializer.fromJson<String>(json['fromCurrency']),
      toCurrency: serializer.fromJson<String>(json['toCurrency']),
      rate: serializer.fromJson<String>(json['rate']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fromCurrency': serializer.toJson<String>(fromCurrency),
      'toCurrency': serializer.toJson<String>(toCurrency),
      'rate': serializer.toJson<String>(rate),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ExchangeRateRow copyWith({
    String? fromCurrency,
    String? toCurrency,
    String? rate,
    int? updatedAt,
  }) => ExchangeRateRow(
    fromCurrency: fromCurrency ?? this.fromCurrency,
    toCurrency: toCurrency ?? this.toCurrency,
    rate: rate ?? this.rate,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExchangeRateRow copyWithCompanion(ExchangeRatesCompanion data) {
    return ExchangeRateRow(
      fromCurrency: data.fromCurrency.present
          ? data.fromCurrency.value
          : this.fromCurrency,
      toCurrency: data.toCurrency.present
          ? data.toCurrency.value
          : this.toCurrency,
      rate: data.rate.present ? data.rate.value : this.rate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRateRow(')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fromCurrency, toCurrency, rate, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRateRow &&
          other.fromCurrency == this.fromCurrency &&
          other.toCurrency == this.toCurrency &&
          other.rate == this.rate &&
          other.updatedAt == this.updatedAt);
}

class ExchangeRatesCompanion extends UpdateCompanion<ExchangeRateRow> {
  final Value<String> fromCurrency;
  final Value<String> toCurrency;
  final Value<String> rate;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ExchangeRatesCompanion({
    this.fromCurrency = const Value.absent(),
    this.toCurrency = const Value.absent(),
    this.rate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExchangeRatesCompanion.insert({
    required String fromCurrency,
    required String toCurrency,
    required String rate,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : fromCurrency = Value(fromCurrency),
       toCurrency = Value(toCurrency),
       rate = Value(rate),
       updatedAt = Value(updatedAt);
  static Insertable<ExchangeRateRow> custom({
    Expression<String>? fromCurrency,
    Expression<String>? toCurrency,
    Expression<String>? rate,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fromCurrency != null) 'from_currency': fromCurrency,
      if (toCurrency != null) 'to_currency': toCurrency,
      if (rate != null) 'rate': rate,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExchangeRatesCompanion copyWith({
    Value<String>? fromCurrency,
    Value<String>? toCurrency,
    Value<String>? rate,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExchangeRatesCompanion(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fromCurrency.present) {
      map['from_currency'] = Variable<String>(fromCurrency.value);
    }
    if (toCurrency.present) {
      map['to_currency'] = Variable<String>(toCurrency.value);
    }
    if (rate.present) {
      map['rate'] = Variable<String>(rate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesCompanion(')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WalletsTable wallets = $WalletsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $WalletGroupsTable walletGroups = $WalletGroupsTable(this);
  late final $WalletGroupMembersTable walletGroupMembers =
      $WalletGroupMembersTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $AssetValueHistoryTable assetValueHistory =
      $AssetValueHistoryTable(this);
  late final $LiabilitiesTable liabilities = $LiabilitiesTable(this);
  late final $LiabilityPaymentsTable liabilityPayments =
      $LiabilityPaymentsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $BudgetWalletMembersTable budgetWalletMembers =
      $BudgetWalletMembersTable(this);
  late final $RecurringTransactionsTable recurringTransactions =
      $RecurringTransactionsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $CommitteesTable committees = $CommitteesTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $ExchangeRatesTable exchangeRates = $ExchangeRatesTable(this);
  late final WalletsDao walletsDao = WalletsDao(this as AppDatabase);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  late final TransactionsDao transactionsDao = TransactionsDao(
    this as AppDatabase,
  );
  late final WalletGroupsDao walletGroupsDao = WalletGroupsDao(
    this as AppDatabase,
  );
  late final AssetsDao assetsDao = AssetsDao(this as AppDatabase);
  late final LiabilitiesDao liabilitiesDao = LiabilitiesDao(
    this as AppDatabase,
  );
  late final ExchangeRatesDao exchangeRatesDao = ExchangeRatesDao(
    this as AppDatabase,
  );
  late final BudgetsDao budgetsDao = BudgetsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    wallets,
    categories,
    transactions,
    walletGroups,
    walletGroupMembers,
    assets,
    assetValueHistory,
    liabilities,
    liabilityPayments,
    budgets,
    budgetWalletMembers,
    recurringTransactions,
    reminders,
    committees,
    savingsGoals,
    exchangeRates,
  ];
}

typedef $$WalletsTableCreateCompanionBuilder = WalletsCompanion Function({
  required String id,
  required String name,
  required String icon,
  required int color,
  Value<String> currency,
  Value<int> openingBalance,
  required String type,
  Value<bool> isLiabilityType,
  Value<bool> isArchived,
  Value<bool> isDeleted,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$WalletsTableUpdateCompanionBuilder = WalletsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> icon,
  Value<int> color,
  Value<String> currency,
  Value<int> openingBalance,
  Value<String> type,
  Value<bool> isLiabilityType,
  Value<bool> isArchived,
  Value<bool> isDeleted,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$WalletsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableFilterComposer({
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

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLiabilityType => $composableBuilder(
    column: $table.isLiabilityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableOrderingComposer({
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

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLiabilityType => $composableBuilder(
    column: $table.isLiabilityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableAnnotationComposer({
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

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isLiabilityType => $composableBuilder(
    column: $table.isLiabilityType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WalletsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletsTable,
          WalletRow,
          $$WalletsTableFilterComposer,
          $$WalletsTableOrderingComposer,
          $$WalletsTableAnnotationComposer,
          $$WalletsTableCreateCompanionBuilder,
          $$WalletsTableUpdateCompanionBuilder,
          (WalletRow, BaseReferences<_$AppDatabase, $WalletsTable, WalletRow>),
          WalletRow,
          PrefetchHooks Function()
        > {
  $$WalletsTableTableManager(_$AppDatabase db, $WalletsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> openingBalance = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isLiabilityType = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletsCompanion(
                id: id,
                name: name,
                icon: icon,
                color: color,
                currency: currency,
                openingBalance: openingBalance,
                type: type,
                isLiabilityType: isLiabilityType,
                isArchived: isArchived,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String icon,
                required int color,
                Value<String> currency = const Value.absent(),
                Value<int> openingBalance = const Value.absent(),
                required String type,
                Value<bool> isLiabilityType = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WalletsCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                color: color,
                currency: currency,
                openingBalance: openingBalance,
                type: type,
                isLiabilityType: isLiabilityType,
                isArchived: isArchived,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WalletsTable, WalletRow>(table),
                  BaseReferences<_$AppDatabase, $WalletsTable, WalletRow>(
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

typedef $$WalletsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletsTable,
      WalletRow,
      $$WalletsTableFilterComposer,
      $$WalletsTableOrderingComposer,
      $$WalletsTableAnnotationComposer,
      $$WalletsTableCreateCompanionBuilder,
      $$WalletsTableUpdateCompanionBuilder,
      (WalletRow, BaseReferences<_$AppDatabase, $WalletsTable, WalletRow>),
      WalletRow,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String name,
  required String icon,
  required int color,
  required String type,
  Value<String?> parentId,
  Value<bool> isDefault,
  Value<int> sortOrder,
  Value<bool> isDeleted,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> icon,
  Value<int> color,
  Value<String> type,
  Value<String?> parentId,
  Value<bool> isDefault,
  Value<int> sortOrder,
  Value<bool> isDeleted,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (
            CategoryRow,
            BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>,
          ),
          CategoryRow,
          PrefetchHooks Function()
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
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                icon: icon,
                color: color,
                type: type,
                parentId: parentId,
                isDefault: isDefault,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String icon,
                required int color,
                required String type,
                Value<String?> parentId = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                color: color,
                type: type,
                parentId: parentId,
                isDefault: isDefault,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryRow>(table),
                  BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>(
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

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (
        CategoryRow,
        BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>,
      ),
      CategoryRow,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required String walletId,
      required String type,
      required int amount,
      Value<int?> toAmount,
      Value<String?> categoryId,
      Value<String?> toWalletId,
      required int date,
      Value<String?> note,
      Value<String?> paymentMethod,
      Value<String?> receiptPath,
      Value<String?> recurringId,
      Value<String?> linkedAssetId,
      Value<String?> linkedLiabilityId,
      Value<bool> isDeleted,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String> walletId,
      Value<String> type,
      Value<int> amount,
      Value<int?> toAmount,
      Value<String?> categoryId,
      Value<String?> toWalletId,
      Value<int> date,
      Value<String?> note,
      Value<String?> paymentMethod,
      Value<String?> receiptPath,
      Value<String?> recurringId,
      Value<String?> linkedAssetId,
      Value<String?> linkedLiabilityId,
      Value<bool> isDeleted,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
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

  ColumnFilters<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toAmount => $composableBuilder(
    column: $table.toAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toWalletId => $composableBuilder(
    column: $table.toWalletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedAssetId => $composableBuilder(
    column: $table.linkedAssetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedLiabilityId => $composableBuilder(
    column: $table.linkedLiabilityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
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

  ColumnOrderings<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toAmount => $composableBuilder(
    column: $table.toAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toWalletId => $composableBuilder(
    column: $table.toWalletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedAssetId => $composableBuilder(
    column: $table.linkedAssetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedLiabilityId => $composableBuilder(
    column: $table.linkedLiabilityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get toAmount =>
      $composableBuilder(column: $table.toAmount, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toWalletId => $composableBuilder(
    column: $table.toWalletId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedAssetId => $composableBuilder(
    column: $table.linkedAssetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedLiabilityId => $composableBuilder(
    column: $table.linkedLiabilityId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            TransactionRow,
            BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>,
          ),
          TransactionRow,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> walletId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int?> toAmount = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> toWalletId = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<String?> recurringId = const Value.absent(),
                Value<String?> linkedAssetId = const Value.absent(),
                Value<String?> linkedLiabilityId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                walletId: walletId,
                type: type,
                amount: amount,
                toAmount: toAmount,
                categoryId: categoryId,
                toWalletId: toWalletId,
                date: date,
                note: note,
                paymentMethod: paymentMethod,
                receiptPath: receiptPath,
                recurringId: recurringId,
                linkedAssetId: linkedAssetId,
                linkedLiabilityId: linkedLiabilityId,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String walletId,
                required String type,
                required int amount,
                Value<int?> toAmount = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> toWalletId = const Value.absent(),
                required int date,
                Value<String?> note = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<String?> recurringId = const Value.absent(),
                Value<String?> linkedAssetId = const Value.absent(),
                Value<String?> linkedLiabilityId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                walletId: walletId,
                type: type,
                amount: amount,
                toAmount: toAmount,
                categoryId: categoryId,
                toWalletId: toWalletId,
                date: date,
                note: note,
                paymentMethod: paymentMethod,
                receiptPath: receiptPath,
                recurringId: recurringId,
                linkedAssetId: linkedAssetId,
                linkedLiabilityId: linkedLiabilityId,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, TransactionRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TransactionsTable,
                    TransactionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        TransactionRow,
        BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>,
      ),
      TransactionRow,
      PrefetchHooks Function()
    >;
typedef $$WalletGroupsTableCreateCompanionBuilder =
    WalletGroupsCompanion Function({
      required String id,
      required String name,
      Value<String?> icon,
      Value<bool> isDeleted,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$WalletGroupsTableUpdateCompanionBuilder =
    WalletGroupsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> icon,
      Value<bool> isDeleted,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$WalletGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletGroupsTable> {
  $$WalletGroupsTableFilterComposer({
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

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletGroupsTable> {
  $$WalletGroupsTableOrderingComposer({
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

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletGroupsTable> {
  $$WalletGroupsTableAnnotationComposer({
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

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WalletGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletGroupsTable,
          WalletGroupRow,
          $$WalletGroupsTableFilterComposer,
          $$WalletGroupsTableOrderingComposer,
          $$WalletGroupsTableAnnotationComposer,
          $$WalletGroupsTableCreateCompanionBuilder,
          $$WalletGroupsTableUpdateCompanionBuilder,
          (
            WalletGroupRow,
            BaseReferences<_$AppDatabase, $WalletGroupsTable, WalletGroupRow>,
          ),
          WalletGroupRow,
          PrefetchHooks Function()
        > {
  $$WalletGroupsTableTableManager(_$AppDatabase db, $WalletGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletGroupsCompanion(
                id: id,
                name: name,
                icon: icon,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> icon = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WalletGroupsCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WalletGroupsTable, WalletGroupRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WalletGroupsTable,
                    WalletGroupRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletGroupsTable,
      WalletGroupRow,
      $$WalletGroupsTableFilterComposer,
      $$WalletGroupsTableOrderingComposer,
      $$WalletGroupsTableAnnotationComposer,
      $$WalletGroupsTableCreateCompanionBuilder,
      $$WalletGroupsTableUpdateCompanionBuilder,
      (
        WalletGroupRow,
        BaseReferences<_$AppDatabase, $WalletGroupsTable, WalletGroupRow>,
      ),
      WalletGroupRow,
      PrefetchHooks Function()
    >;
typedef $$WalletGroupMembersTableCreateCompanionBuilder =
    WalletGroupMembersCompanion Function({
      required String groupId,
      required String walletId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$WalletGroupMembersTableUpdateCompanionBuilder =
    WalletGroupMembersCompanion Function({
      Value<String> groupId,
      Value<String> walletId,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$WalletGroupMembersTableFilterComposer
    extends Composer<_$AppDatabase, $WalletGroupMembersTable> {
  $$WalletGroupMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletGroupMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletGroupMembersTable> {
  $$WalletGroupMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletGroupMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletGroupMembersTable> {
  $$WalletGroupMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WalletGroupMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletGroupMembersTable,
          WalletGroupMemberRow,
          $$WalletGroupMembersTableFilterComposer,
          $$WalletGroupMembersTableOrderingComposer,
          $$WalletGroupMembersTableAnnotationComposer,
          $$WalletGroupMembersTableCreateCompanionBuilder,
          $$WalletGroupMembersTableUpdateCompanionBuilder,
          (
            WalletGroupMemberRow,
            BaseReferences<
              _$AppDatabase,
              $WalletGroupMembersTable,
              WalletGroupMemberRow
            >,
          ),
          WalletGroupMemberRow,
          PrefetchHooks Function()
        > {
  $$WalletGroupMembersTableTableManager(
    _$AppDatabase db,
    $WalletGroupMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletGroupMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletGroupMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletGroupMembersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> walletId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletGroupMembersCompanion(
                groupId: groupId,
                walletId: walletId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String walletId,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WalletGroupMembersCompanion.insert(
                groupId: groupId,
                walletId: walletId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WalletGroupMembersTable, WalletGroupMemberRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $WalletGroupMembersTable,
                    WalletGroupMemberRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletGroupMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletGroupMembersTable,
      WalletGroupMemberRow,
      $$WalletGroupMembersTableFilterComposer,
      $$WalletGroupMembersTableOrderingComposer,
      $$WalletGroupMembersTableAnnotationComposer,
      $$WalletGroupMembersTableCreateCompanionBuilder,
      $$WalletGroupMembersTableUpdateCompanionBuilder,
      (
        WalletGroupMemberRow,
        BaseReferences<
          _$AppDatabase,
          $WalletGroupMembersTable,
          WalletGroupMemberRow
        >,
      ),
      WalletGroupMemberRow,
      PrefetchHooks Function()
    >;
typedef $$AssetsTableCreateCompanionBuilder = AssetsCompanion Function({
  required String id,
  required String name,
  required String type,
  Value<int?> purchasePrice,
  Value<int?> purchaseDate,
  required int currentValue,
  Value<String> currency,
  Value<String?> quantity,
  Value<String?> unit,
  Value<String?> notes,
  Value<String?> photoPath,
  Value<bool> isDeleted,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$AssetsTableUpdateCompanionBuilder = AssetsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<int?> purchasePrice,
  Value<int?> purchaseDate,
  Value<int> currentValue,
  Value<String> currency,
  Value<String?> quantity,
  Value<String?> unit,
  Value<String?> notes,
  Value<String?> photoPath,
  Value<bool> isDeleted,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetsTable,
          AssetRow,
          $$AssetsTableFilterComposer,
          $$AssetsTableOrderingComposer,
          $$AssetsTableAnnotationComposer,
          $$AssetsTableCreateCompanionBuilder,
          $$AssetsTableUpdateCompanionBuilder,
          (AssetRow, BaseReferences<_$AppDatabase, $AssetsTable, AssetRow>),
          AssetRow,
          PrefetchHooks Function()
        > {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> purchasePrice = const Value.absent(),
                Value<int?> purchaseDate = const Value.absent(),
                Value<int> currentValue = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion(
                id: id,
                name: name,
                type: type,
                purchasePrice: purchasePrice,
                purchaseDate: purchaseDate,
                currentValue: currentValue,
                currency: currency,
                quantity: quantity,
                unit: unit,
                notes: notes,
                photoPath: photoPath,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                Value<int?> purchasePrice = const Value.absent(),
                Value<int?> purchaseDate = const Value.absent(),
                required int currentValue,
                Value<String> currency = const Value.absent(),
                Value<String?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion.insert(
                id: id,
                name: name,
                type: type,
                purchasePrice: purchasePrice,
                purchaseDate: purchaseDate,
                currentValue: currentValue,
                currency: currency,
                quantity: quantity,
                unit: unit,
                notes: notes,
                photoPath: photoPath,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssetsTable, AssetRow>(table),
                  BaseReferences<_$AppDatabase, $AssetsTable, AssetRow>(
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

typedef $$AssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetsTable,
      AssetRow,
      $$AssetsTableFilterComposer,
      $$AssetsTableOrderingComposer,
      $$AssetsTableAnnotationComposer,
      $$AssetsTableCreateCompanionBuilder,
      $$AssetsTableUpdateCompanionBuilder,
      (AssetRow, BaseReferences<_$AppDatabase, $AssetsTable, AssetRow>),
      AssetRow,
      PrefetchHooks Function()
    >;
typedef $$AssetValueHistoryTableCreateCompanionBuilder =
    AssetValueHistoryCompanion Function({
      required String id,
      required String assetId,
      required int value,
      required int date,
      required int createdAt,
      required int updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$AssetValueHistoryTableUpdateCompanionBuilder =
    AssetValueHistoryCompanion Function({
      Value<String> id,
      Value<String> assetId,
      Value<int> value,
      Value<int> date,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$AssetValueHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $AssetValueHistoryTable> {
  $$AssetValueHistoryTableFilterComposer({
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

  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssetValueHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetValueHistoryTable> {
  $$AssetValueHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetValueHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetValueHistoryTable> {
  $$AssetValueHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$AssetValueHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetValueHistoryTable,
          AssetValueHistoryRow,
          $$AssetValueHistoryTableFilterComposer,
          $$AssetValueHistoryTableOrderingComposer,
          $$AssetValueHistoryTableAnnotationComposer,
          $$AssetValueHistoryTableCreateCompanionBuilder,
          $$AssetValueHistoryTableUpdateCompanionBuilder,
          (
            AssetValueHistoryRow,
            BaseReferences<
              _$AppDatabase,
              $AssetValueHistoryTable,
              AssetValueHistoryRow
            >,
          ),
          AssetValueHistoryRow,
          PrefetchHooks Function()
        > {
  $$AssetValueHistoryTableTableManager(
    _$AppDatabase db,
    $AssetValueHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetValueHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetValueHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetValueHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> assetId = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetValueHistoryCompanion(
                id: id,
                assetId: assetId,
                value: value,
                date: date,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String assetId,
                required int value,
                required int date,
                required int createdAt,
                required int updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetValueHistoryCompanion.insert(
                id: id,
                assetId: assetId,
                value: value,
                date: date,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssetValueHistoryTable, AssetValueHistoryRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $AssetValueHistoryTable,
                    AssetValueHistoryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssetValueHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetValueHistoryTable,
      AssetValueHistoryRow,
      $$AssetValueHistoryTableFilterComposer,
      $$AssetValueHistoryTableOrderingComposer,
      $$AssetValueHistoryTableAnnotationComposer,
      $$AssetValueHistoryTableCreateCompanionBuilder,
      $$AssetValueHistoryTableUpdateCompanionBuilder,
      (
        AssetValueHistoryRow,
        BaseReferences<
          _$AppDatabase,
          $AssetValueHistoryTable,
          AssetValueHistoryRow
        >,
      ),
      AssetValueHistoryRow,
      PrefetchHooks Function()
    >;
typedef $$LiabilitiesTableCreateCompanionBuilder =
    LiabilitiesCompanion Function({
      required String id,
      required String name,
      required String type,
      required int totalAmount,
      required int remainingAmount,
      Value<String> currency,
      Value<int?> installmentAmount,
      Value<int?> dueDate,
      Value<String?> interestRate,
      Value<String?> notes,
      Value<String?> linkedWalletId,
      Value<bool> isDeleted,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LiabilitiesTableUpdateCompanionBuilder =
    LiabilitiesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<int> totalAmount,
      Value<int> remainingAmount,
      Value<String> currency,
      Value<int?> installmentAmount,
      Value<int?> dueDate,
      Value<String?> interestRate,
      Value<String?> notes,
      Value<String?> linkedWalletId,
      Value<bool> isDeleted,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$LiabilitiesTableFilterComposer
    extends Composer<_$AppDatabase, $LiabilitiesTable> {
  $$LiabilitiesTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingAmount => $composableBuilder(
    column: $table.remainingAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentAmount => $composableBuilder(
    column: $table.installmentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedWalletId => $composableBuilder(
    column: $table.linkedWalletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LiabilitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $LiabilitiesTable> {
  $$LiabilitiesTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingAmount => $composableBuilder(
    column: $table.remainingAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentAmount => $composableBuilder(
    column: $table.installmentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedWalletId => $composableBuilder(
    column: $table.linkedWalletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LiabilitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LiabilitiesTable> {
  $$LiabilitiesTableAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remainingAmount => $composableBuilder(
    column: $table.remainingAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get installmentAmount => $composableBuilder(
    column: $table.installmentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get linkedWalletId => $composableBuilder(
    column: $table.linkedWalletId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LiabilitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LiabilitiesTable,
          LiabilityRow,
          $$LiabilitiesTableFilterComposer,
          $$LiabilitiesTableOrderingComposer,
          $$LiabilitiesTableAnnotationComposer,
          $$LiabilitiesTableCreateCompanionBuilder,
          $$LiabilitiesTableUpdateCompanionBuilder,
          (
            LiabilityRow,
            BaseReferences<_$AppDatabase, $LiabilitiesTable, LiabilityRow>,
          ),
          LiabilityRow,
          PrefetchHooks Function()
        > {
  $$LiabilitiesTableTableManager(_$AppDatabase db, $LiabilitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LiabilitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LiabilitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LiabilitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> totalAmount = const Value.absent(),
                Value<int> remainingAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int?> installmentAmount = const Value.absent(),
                Value<int?> dueDate = const Value.absent(),
                Value<String?> interestRate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> linkedWalletId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LiabilitiesCompanion(
                id: id,
                name: name,
                type: type,
                totalAmount: totalAmount,
                remainingAmount: remainingAmount,
                currency: currency,
                installmentAmount: installmentAmount,
                dueDate: dueDate,
                interestRate: interestRate,
                notes: notes,
                linkedWalletId: linkedWalletId,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required int totalAmount,
                required int remainingAmount,
                Value<String> currency = const Value.absent(),
                Value<int?> installmentAmount = const Value.absent(),
                Value<int?> dueDate = const Value.absent(),
                Value<String?> interestRate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> linkedWalletId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LiabilitiesCompanion.insert(
                id: id,
                name: name,
                type: type,
                totalAmount: totalAmount,
                remainingAmount: remainingAmount,
                currency: currency,
                installmentAmount: installmentAmount,
                dueDate: dueDate,
                interestRate: interestRate,
                notes: notes,
                linkedWalletId: linkedWalletId,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LiabilitiesTable, LiabilityRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LiabilitiesTable,
                    LiabilityRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LiabilitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LiabilitiesTable,
      LiabilityRow,
      $$LiabilitiesTableFilterComposer,
      $$LiabilitiesTableOrderingComposer,
      $$LiabilitiesTableAnnotationComposer,
      $$LiabilitiesTableCreateCompanionBuilder,
      $$LiabilitiesTableUpdateCompanionBuilder,
      (
        LiabilityRow,
        BaseReferences<_$AppDatabase, $LiabilitiesTable, LiabilityRow>,
      ),
      LiabilityRow,
      PrefetchHooks Function()
    >;
typedef $$LiabilityPaymentsTableCreateCompanionBuilder =
    LiabilityPaymentsCompanion Function({
      required String id,
      required String liabilityId,
      required int amount,
      required int date,
      Value<String?> transactionId,
      Value<bool> isDeleted,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$LiabilityPaymentsTableUpdateCompanionBuilder =
    LiabilityPaymentsCompanion Function({
      Value<String> id,
      Value<String> liabilityId,
      Value<int> amount,
      Value<int> date,
      Value<String?> transactionId,
      Value<bool> isDeleted,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$LiabilityPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $LiabilityPaymentsTable> {
  $$LiabilityPaymentsTableFilterComposer({
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

  ColumnFilters<String> get liabilityId => $composableBuilder(
    column: $table.liabilityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LiabilityPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LiabilityPaymentsTable> {
  $$LiabilityPaymentsTableOrderingComposer({
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

  ColumnOrderings<String> get liabilityId => $composableBuilder(
    column: $table.liabilityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LiabilityPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LiabilityPaymentsTable> {
  $$LiabilityPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get liabilityId => $composableBuilder(
    column: $table.liabilityId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LiabilityPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LiabilityPaymentsTable,
          LiabilityPaymentRow,
          $$LiabilityPaymentsTableFilterComposer,
          $$LiabilityPaymentsTableOrderingComposer,
          $$LiabilityPaymentsTableAnnotationComposer,
          $$LiabilityPaymentsTableCreateCompanionBuilder,
          $$LiabilityPaymentsTableUpdateCompanionBuilder,
          (
            LiabilityPaymentRow,
            BaseReferences<
              _$AppDatabase,
              $LiabilityPaymentsTable,
              LiabilityPaymentRow
            >,
          ),
          LiabilityPaymentRow,
          PrefetchHooks Function()
        > {
  $$LiabilityPaymentsTableTableManager(
    _$AppDatabase db,
    $LiabilityPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LiabilityPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LiabilityPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LiabilityPaymentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> liabilityId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LiabilityPaymentsCompanion(
                id: id,
                liabilityId: liabilityId,
                amount: amount,
                date: date,
                transactionId: transactionId,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String liabilityId,
                required int amount,
                required int date,
                Value<String?> transactionId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LiabilityPaymentsCompanion.insert(
                id: id,
                liabilityId: liabilityId,
                amount: amount,
                date: date,
                transactionId: transactionId,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LiabilityPaymentsTable, LiabilityPaymentRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $LiabilityPaymentsTable,
                    LiabilityPaymentRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LiabilityPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LiabilityPaymentsTable,
      LiabilityPaymentRow,
      $$LiabilityPaymentsTableFilterComposer,
      $$LiabilityPaymentsTableOrderingComposer,
      $$LiabilityPaymentsTableAnnotationComposer,
      $$LiabilityPaymentsTableCreateCompanionBuilder,
      $$LiabilityPaymentsTableUpdateCompanionBuilder,
      (
        LiabilityPaymentRow,
        BaseReferences<
          _$AppDatabase,
          $LiabilityPaymentsTable,
          LiabilityPaymentRow
        >,
      ),
      LiabilityPaymentRow,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  required String id,
  Value<String?> categoryId,
  Value<String?> walletId,
  required int amount,
  Value<String> currency,
  Value<String> period,
  required int startMonth,
  Value<int> yearMonth,
  Value<bool> rollover,
  Value<bool> notify80,
  Value<bool> notifyOver,
  Value<int?> lastNotified80At,
  Value<int?> lastNotifiedOverAt,
  Value<String?> name,
  Value<bool> isDeleted,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<String> id,
  Value<String?> categoryId,
  Value<String?> walletId,
  Value<int> amount,
  Value<String> currency,
  Value<String> period,
  Value<int> startMonth,
  Value<int> yearMonth,
  Value<bool> rollover,
  Value<bool> notify80,
  Value<bool> notifyOver,
  Value<int?> lastNotified80At,
  Value<int?> lastNotifiedOverAt,
  Value<String?> name,
  Value<bool> isDeleted,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
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

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearMonth => $composableBuilder(
    column: $table.yearMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rollover => $composableBuilder(
    column: $table.rollover,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notify80 => $composableBuilder(
    column: $table.notify80,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyOver => $composableBuilder(
    column: $table.notifyOver,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastNotified80At => $composableBuilder(
    column: $table.lastNotified80At,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastNotifiedOverAt => $composableBuilder(
    column: $table.lastNotifiedOverAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
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

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearMonth => $composableBuilder(
    column: $table.yearMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rollover => $composableBuilder(
    column: $table.rollover,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notify80 => $composableBuilder(
    column: $table.notify80,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyOver => $composableBuilder(
    column: $table.notifyOver,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastNotified80At => $composableBuilder(
    column: $table.lastNotified80At,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastNotifiedOverAt => $composableBuilder(
    column: $table.lastNotifiedOverAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get startMonth => $composableBuilder(
    column: $table.startMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get yearMonth =>
      $composableBuilder(column: $table.yearMonth, builder: (column) => column);

  GeneratedColumn<bool> get rollover =>
      $composableBuilder(column: $table.rollover, builder: (column) => column);

  GeneratedColumn<bool> get notify80 =>
      $composableBuilder(column: $table.notify80, builder: (column) => column);

  GeneratedColumn<bool> get notifyOver => $composableBuilder(
    column: $table.notifyOver,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastNotified80At => $composableBuilder(
    column: $table.lastNotified80At,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastNotifiedOverAt => $composableBuilder(
    column: $table.lastNotifiedOverAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          BudgetRow,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (BudgetRow, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>),
          BudgetRow,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> walletId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<int> startMonth = const Value.absent(),
                Value<int> yearMonth = const Value.absent(),
                Value<bool> rollover = const Value.absent(),
                Value<bool> notify80 = const Value.absent(),
                Value<bool> notifyOver = const Value.absent(),
                Value<int?> lastNotified80At = const Value.absent(),
                Value<int?> lastNotifiedOverAt = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                categoryId: categoryId,
                walletId: walletId,
                amount: amount,
                currency: currency,
                period: period,
                startMonth: startMonth,
                yearMonth: yearMonth,
                rollover: rollover,
                notify80: notify80,
                notifyOver: notifyOver,
                lastNotified80At: lastNotified80At,
                lastNotifiedOverAt: lastNotifiedOverAt,
                name: name,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> categoryId = const Value.absent(),
                Value<String?> walletId = const Value.absent(),
                required int amount,
                Value<String> currency = const Value.absent(),
                Value<String> period = const Value.absent(),
                required int startMonth,
                Value<int> yearMonth = const Value.absent(),
                Value<bool> rollover = const Value.absent(),
                Value<bool> notify80 = const Value.absent(),
                Value<bool> notifyOver = const Value.absent(),
                Value<int?> lastNotified80At = const Value.absent(),
                Value<int?> lastNotifiedOverAt = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                categoryId: categoryId,
                walletId: walletId,
                amount: amount,
                currency: currency,
                period: period,
                startMonth: startMonth,
                yearMonth: yearMonth,
                rollover: rollover,
                notify80: notify80,
                notifyOver: notifyOver,
                lastNotified80At: lastNotified80At,
                lastNotifiedOverAt: lastNotifiedOverAt,
                name: name,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, BudgetRow>(table),
                  BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>(
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

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      BudgetRow,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (BudgetRow, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>),
      BudgetRow,
      PrefetchHooks Function()
    >;
typedef $$BudgetWalletMembersTableCreateCompanionBuilder =
    BudgetWalletMembersCompanion Function({
      required String budgetId,
      required String walletId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$BudgetWalletMembersTableUpdateCompanionBuilder =
    BudgetWalletMembersCompanion Function({
      Value<String> budgetId,
      Value<String> walletId,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$BudgetWalletMembersTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetWalletMembersTable> {
  $$BudgetWalletMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetWalletMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetWalletMembersTable> {
  $$BudgetWalletMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetWalletMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetWalletMembersTable> {
  $$BudgetWalletMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BudgetWalletMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetWalletMembersTable,
          BudgetWalletMemberRow,
          $$BudgetWalletMembersTableFilterComposer,
          $$BudgetWalletMembersTableOrderingComposer,
          $$BudgetWalletMembersTableAnnotationComposer,
          $$BudgetWalletMembersTableCreateCompanionBuilder,
          $$BudgetWalletMembersTableUpdateCompanionBuilder,
          (
            BudgetWalletMemberRow,
            BaseReferences<
              _$AppDatabase,
              $BudgetWalletMembersTable,
              BudgetWalletMemberRow
            >,
          ),
          BudgetWalletMemberRow,
          PrefetchHooks Function()
        > {
  $$BudgetWalletMembersTableTableManager(
    _$AppDatabase db,
    $BudgetWalletMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetWalletMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetWalletMembersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BudgetWalletMembersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<String> walletId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetWalletMembersCompanion(
                budgetId: budgetId,
                walletId: walletId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required String walletId,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetWalletMembersCompanion.insert(
                budgetId: budgetId,
                walletId: walletId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetWalletMembersTable, BudgetWalletMemberRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $BudgetWalletMembersTable,
                    BudgetWalletMemberRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetWalletMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetWalletMembersTable,
      BudgetWalletMemberRow,
      $$BudgetWalletMembersTableFilterComposer,
      $$BudgetWalletMembersTableOrderingComposer,
      $$BudgetWalletMembersTableAnnotationComposer,
      $$BudgetWalletMembersTableCreateCompanionBuilder,
      $$BudgetWalletMembersTableUpdateCompanionBuilder,
      (
        BudgetWalletMemberRow,
        BaseReferences<
          _$AppDatabase,
          $BudgetWalletMembersTable,
          BudgetWalletMemberRow
        >,
      ),
      BudgetWalletMemberRow,
      PrefetchHooks Function()
    >;
typedef $$RecurringTransactionsTableCreateCompanionBuilder =
    RecurringTransactionsCompanion Function({
      required String id,
      required String walletId,
      required String type,
      required int amount,
      Value<String> currency,
      Value<int?> toAmount,
      Value<String?> categoryId,
      Value<String?> toWalletId,
      Value<String?> note,
      Value<String?> paymentMethod,
      required String frequency,
      Value<int> intervalN,
      Value<String?> customUnit,
      Value<int> startDate,
      Value<int?> endDate,
      required int nextDueDate,
      Value<int?> lastGeneratedDate,
      Value<String> mode,
      Value<String> templateType,
      Value<int?> installmentCount,
      Value<int?> amountRemaining,
      Value<int> generatedCount,
      Value<bool> isPaused,
      Value<bool> isActive,
      Value<bool> isDeleted,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$RecurringTransactionsTableUpdateCompanionBuilder =
    RecurringTransactionsCompanion Function({
      Value<String> id,
      Value<String> walletId,
      Value<String> type,
      Value<int> amount,
      Value<String> currency,
      Value<int?> toAmount,
      Value<String?> categoryId,
      Value<String?> toWalletId,
      Value<String?> note,
      Value<String?> paymentMethod,
      Value<String> frequency,
      Value<int> intervalN,
      Value<String?> customUnit,
      Value<int> startDate,
      Value<int?> endDate,
      Value<int> nextDueDate,
      Value<int?> lastGeneratedDate,
      Value<String> mode,
      Value<String> templateType,
      Value<int?> installmentCount,
      Value<int?> amountRemaining,
      Value<int> generatedCount,
      Value<bool> isPaused,
      Value<bool> isActive,
      Value<bool> isDeleted,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$RecurringTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableFilterComposer({
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

  ColumnFilters<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toAmount => $composableBuilder(
    column: $table.toAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toWalletId => $composableBuilder(
    column: $table.toWalletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalN => $composableBuilder(
    column: $table.intervalN,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customUnit => $composableBuilder(
    column: $table.customUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastGeneratedDate => $composableBuilder(
    column: $table.lastGeneratedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateType => $composableBuilder(
    column: $table.templateType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountRemaining => $composableBuilder(
    column: $table.amountRemaining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get generatedCount => $composableBuilder(
    column: $table.generatedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecurringTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableOrderingComposer({
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

  ColumnOrderings<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toAmount => $composableBuilder(
    column: $table.toAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toWalletId => $composableBuilder(
    column: $table.toWalletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalN => $composableBuilder(
    column: $table.intervalN,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customUnit => $composableBuilder(
    column: $table.customUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastGeneratedDate => $composableBuilder(
    column: $table.lastGeneratedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateType => $composableBuilder(
    column: $table.templateType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountRemaining => $composableBuilder(
    column: $table.amountRemaining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generatedCount => $composableBuilder(
    column: $table.generatedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurringTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get toAmount =>
      $composableBuilder(column: $table.toAmount, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toWalletId => $composableBuilder(
    column: $table.toWalletId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get intervalN =>
      $composableBuilder(column: $table.intervalN, builder: (column) => column);

  GeneratedColumn<String> get customUnit => $composableBuilder(
    column: $table.customUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastGeneratedDate => $composableBuilder(
    column: $table.lastGeneratedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get templateType => $composableBuilder(
    column: $table.templateType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountRemaining => $composableBuilder(
    column: $table.amountRemaining,
    builder: (column) => column,
  );

  GeneratedColumn<int> get generatedCount => $composableBuilder(
    column: $table.generatedCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPaused =>
      $composableBuilder(column: $table.isPaused, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecurringTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringTransactionsTable,
          RecurringTransactionRow,
          $$RecurringTransactionsTableFilterComposer,
          $$RecurringTransactionsTableOrderingComposer,
          $$RecurringTransactionsTableAnnotationComposer,
          $$RecurringTransactionsTableCreateCompanionBuilder,
          $$RecurringTransactionsTableUpdateCompanionBuilder,
          (
            RecurringTransactionRow,
            BaseReferences<
              _$AppDatabase,
              $RecurringTransactionsTable,
              RecurringTransactionRow
            >,
          ),
          RecurringTransactionRow,
          PrefetchHooks Function()
        > {
  $$RecurringTransactionsTableTableManager(
    _$AppDatabase db,
    $RecurringTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringTransactionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecurringTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurringTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> walletId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int?> toAmount = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> toWalletId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> intervalN = const Value.absent(),
                Value<String?> customUnit = const Value.absent(),
                Value<int> startDate = const Value.absent(),
                Value<int?> endDate = const Value.absent(),
                Value<int> nextDueDate = const Value.absent(),
                Value<int?> lastGeneratedDate = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> templateType = const Value.absent(),
                Value<int?> installmentCount = const Value.absent(),
                Value<int?> amountRemaining = const Value.absent(),
                Value<int> generatedCount = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringTransactionsCompanion(
                id: id,
                walletId: walletId,
                type: type,
                amount: amount,
                currency: currency,
                toAmount: toAmount,
                categoryId: categoryId,
                toWalletId: toWalletId,
                note: note,
                paymentMethod: paymentMethod,
                frequency: frequency,
                intervalN: intervalN,
                customUnit: customUnit,
                startDate: startDate,
                endDate: endDate,
                nextDueDate: nextDueDate,
                lastGeneratedDate: lastGeneratedDate,
                mode: mode,
                templateType: templateType,
                installmentCount: installmentCount,
                amountRemaining: amountRemaining,
                generatedCount: generatedCount,
                isPaused: isPaused,
                isActive: isActive,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String walletId,
                required String type,
                required int amount,
                Value<String> currency = const Value.absent(),
                Value<int?> toAmount = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> toWalletId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                required String frequency,
                Value<int> intervalN = const Value.absent(),
                Value<String?> customUnit = const Value.absent(),
                Value<int> startDate = const Value.absent(),
                Value<int?> endDate = const Value.absent(),
                required int nextDueDate,
                Value<int?> lastGeneratedDate = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> templateType = const Value.absent(),
                Value<int?> installmentCount = const Value.absent(),
                Value<int?> amountRemaining = const Value.absent(),
                Value<int> generatedCount = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecurringTransactionsCompanion.insert(
                id: id,
                walletId: walletId,
                type: type,
                amount: amount,
                currency: currency,
                toAmount: toAmount,
                categoryId: categoryId,
                toWalletId: toWalletId,
                note: note,
                paymentMethod: paymentMethod,
                frequency: frequency,
                intervalN: intervalN,
                customUnit: customUnit,
                startDate: startDate,
                endDate: endDate,
                nextDueDate: nextDueDate,
                lastGeneratedDate: lastGeneratedDate,
                mode: mode,
                templateType: templateType,
                installmentCount: installmentCount,
                amountRemaining: amountRemaining,
                generatedCount: generatedCount,
                isPaused: isPaused,
                isActive: isActive,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $RecurringTransactionsTable,
                    RecurringTransactionRow
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecurringTransactionsTable,
                    RecurringTransactionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurringTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringTransactionsTable,
      RecurringTransactionRow,
      $$RecurringTransactionsTableFilterComposer,
      $$RecurringTransactionsTableOrderingComposer,
      $$RecurringTransactionsTableAnnotationComposer,
      $$RecurringTransactionsTableCreateCompanionBuilder,
      $$RecurringTransactionsTableUpdateCompanionBuilder,
      (
        RecurringTransactionRow,
        BaseReferences<
          _$AppDatabase,
          $RecurringTransactionsTable,
          RecurringTransactionRow
        >,
      ),
      RecurringTransactionRow,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  required String id,
  required String title,
  Value<int?> amount,
  Value<String> currency,
  Value<String?> note,
  required int dueDate,
  Value<String?> repeatFrequency,
  Value<int> remindDaysBefore,
  Value<int?> dailyTimeMinutes,
  Value<String?> walletId,
  Value<String?> categoryId,
  Value<String> type,
  Value<String?> linkedType,
  Value<String?> linkedId,
  Value<String?> paidTransactionId,
  Value<bool> isDone,
  Value<int?> lastNotifiedAt,
  Value<bool> isDeleted,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<int?> amount,
  Value<String> currency,
  Value<String?> note,
  Value<int> dueDate,
  Value<String?> repeatFrequency,
  Value<int> remindDaysBefore,
  Value<int?> dailyTimeMinutes,
  Value<String?> walletId,
  Value<String?> categoryId,
  Value<String> type,
  Value<String?> linkedType,
  Value<String?> linkedId,
  Value<String?> paidTransactionId,
  Value<bool> isDone,
  Value<int?> lastNotifiedAt,
  Value<bool> isDeleted,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatFrequency => $composableBuilder(
    column: $table.repeatFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remindDaysBefore => $composableBuilder(
    column: $table.remindDaysBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyTimeMinutes => $composableBuilder(
    column: $table.dailyTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedType => $composableBuilder(
    column: $table.linkedType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedId => $composableBuilder(
    column: $table.linkedId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidTransactionId => $composableBuilder(
    column: $table.paidTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatFrequency => $composableBuilder(
    column: $table.repeatFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remindDaysBefore => $composableBuilder(
    column: $table.remindDaysBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyTimeMinutes => $composableBuilder(
    column: $table.dailyTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedType => $composableBuilder(
    column: $table.linkedType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedId => $composableBuilder(
    column: $table.linkedId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidTransactionId => $composableBuilder(
    column: $table.paidTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get repeatFrequency => $composableBuilder(
    column: $table.repeatFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remindDaysBefore => $composableBuilder(
    column: $table.remindDaysBefore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyTimeMinutes => $composableBuilder(
    column: $table.dailyTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get linkedType => $composableBuilder(
    column: $table.linkedType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedId =>
      $composableBuilder(column: $table.linkedId, builder: (column) => column);

  GeneratedColumn<String> get paidTransactionId => $composableBuilder(
    column: $table.paidTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<int> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          ReminderRow,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (
            ReminderRow,
            BaseReferences<_$AppDatabase, $RemindersTable, ReminderRow>,
          ),
          ReminderRow,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> dueDate = const Value.absent(),
                Value<String?> repeatFrequency = const Value.absent(),
                Value<int> remindDaysBefore = const Value.absent(),
                Value<int?> dailyTimeMinutes = const Value.absent(),
                Value<String?> walletId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> linkedType = const Value.absent(),
                Value<String?> linkedId = const Value.absent(),
                Value<String?> paidTransactionId = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<int?> lastNotifiedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                title: title,
                amount: amount,
                currency: currency,
                note: note,
                dueDate: dueDate,
                repeatFrequency: repeatFrequency,
                remindDaysBefore: remindDaysBefore,
                dailyTimeMinutes: dailyTimeMinutes,
                walletId: walletId,
                categoryId: categoryId,
                type: type,
                linkedType: linkedType,
                linkedId: linkedId,
                paidTransactionId: paidTransactionId,
                isDone: isDone,
                lastNotifiedAt: lastNotifiedAt,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<int?> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int dueDate,
                Value<String?> repeatFrequency = const Value.absent(),
                Value<int> remindDaysBefore = const Value.absent(),
                Value<int?> dailyTimeMinutes = const Value.absent(),
                Value<String?> walletId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> linkedType = const Value.absent(),
                Value<String?> linkedId = const Value.absent(),
                Value<String?> paidTransactionId = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<int?> lastNotifiedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                title: title,
                amount: amount,
                currency: currency,
                note: note,
                dueDate: dueDate,
                repeatFrequency: repeatFrequency,
                remindDaysBefore: remindDaysBefore,
                dailyTimeMinutes: dailyTimeMinutes,
                walletId: walletId,
                categoryId: categoryId,
                type: type,
                linkedType: linkedType,
                linkedId: linkedId,
                paidTransactionId: paidTransactionId,
                isDone: isDone,
                lastNotifiedAt: lastNotifiedAt,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, ReminderRow>(table),
                  BaseReferences<_$AppDatabase, $RemindersTable, ReminderRow>(
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

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      ReminderRow,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (
        ReminderRow,
        BaseReferences<_$AppDatabase, $RemindersTable, ReminderRow>,
      ),
      ReminderRow,
      PrefetchHooks Function()
    >;
typedef $$CommitteesTableCreateCompanionBuilder = CommitteesCompanion Function({
  required String id,
  required String name,
  required int monthlyAmount,
  required int totalMembers,
  Value<int?> myTurnMonth,
  required int startDate,
  Value<String> status,
  Value<bool> isDeleted,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$CommitteesTableUpdateCompanionBuilder = CommitteesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> monthlyAmount,
  Value<int> totalMembers,
  Value<int?> myTurnMonth,
  Value<int> startDate,
  Value<String> status,
  Value<bool> isDeleted,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$CommitteesTableFilterComposer
    extends Composer<_$AppDatabase, $CommitteesTable> {
  $$CommitteesTableFilterComposer({
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

  ColumnFilters<int> get monthlyAmount => $composableBuilder(
    column: $table.monthlyAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMembers => $composableBuilder(
    column: $table.totalMembers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get myTurnMonth => $composableBuilder(
    column: $table.myTurnMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CommitteesTableOrderingComposer
    extends Composer<_$AppDatabase, $CommitteesTable> {
  $$CommitteesTableOrderingComposer({
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

  ColumnOrderings<int> get monthlyAmount => $composableBuilder(
    column: $table.monthlyAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMembers => $composableBuilder(
    column: $table.totalMembers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get myTurnMonth => $composableBuilder(
    column: $table.myTurnMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CommitteesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommitteesTable> {
  $$CommitteesTableAnnotationComposer({
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

  GeneratedColumn<int> get monthlyAmount => $composableBuilder(
    column: $table.monthlyAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMembers => $composableBuilder(
    column: $table.totalMembers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get myTurnMonth => $composableBuilder(
    column: $table.myTurnMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CommitteesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CommitteesTable,
          CommitteeRow,
          $$CommitteesTableFilterComposer,
          $$CommitteesTableOrderingComposer,
          $$CommitteesTableAnnotationComposer,
          $$CommitteesTableCreateCompanionBuilder,
          $$CommitteesTableUpdateCompanionBuilder,
          (
            CommitteeRow,
            BaseReferences<_$AppDatabase, $CommitteesTable, CommitteeRow>,
          ),
          CommitteeRow,
          PrefetchHooks Function()
        > {
  $$CommitteesTableTableManager(_$AppDatabase db, $CommitteesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommitteesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommitteesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommitteesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> monthlyAmount = const Value.absent(),
                Value<int> totalMembers = const Value.absent(),
                Value<int?> myTurnMonth = const Value.absent(),
                Value<int> startDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CommitteesCompanion(
                id: id,
                name: name,
                monthlyAmount: monthlyAmount,
                totalMembers: totalMembers,
                myTurnMonth: myTurnMonth,
                startDate: startDate,
                status: status,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int monthlyAmount,
                required int totalMembers,
                Value<int?> myTurnMonth = const Value.absent(),
                required int startDate,
                Value<String> status = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CommitteesCompanion.insert(
                id: id,
                name: name,
                monthlyAmount: monthlyAmount,
                totalMembers: totalMembers,
                myTurnMonth: myTurnMonth,
                startDate: startDate,
                status: status,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CommitteesTable, CommitteeRow>(table),
                  BaseReferences<_$AppDatabase, $CommitteesTable, CommitteeRow>(
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

typedef $$CommitteesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CommitteesTable,
      CommitteeRow,
      $$CommitteesTableFilterComposer,
      $$CommitteesTableOrderingComposer,
      $$CommitteesTableAnnotationComposer,
      $$CommitteesTableCreateCompanionBuilder,
      $$CommitteesTableUpdateCompanionBuilder,
      (
        CommitteeRow,
        BaseReferences<_$AppDatabase, $CommitteesTable, CommitteeRow>,
      ),
      CommitteeRow,
      PrefetchHooks Function()
    >;
typedef $$SavingsGoalsTableCreateCompanionBuilder =
    SavingsGoalsCompanion Function({
      required String id,
      required String name,
      required int targetAmount,
      Value<int> savedAmount,
      Value<int?> targetDate,
      Value<bool> isDeleted,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$SavingsGoalsTableUpdateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> targetAmount,
      Value<int> savedAmount,
      Value<int?> targetDate,
      Value<bool> isDeleted,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
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

  ColumnFilters<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savedAmount => $composableBuilder(
    column: $table.savedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
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

  ColumnOrderings<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savedAmount => $composableBuilder(
    column: $table.savedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
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

  GeneratedColumn<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savedAmount => $composableBuilder(
    column: $table.savedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SavingsGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTable,
          SavingsGoalRow,
          $$SavingsGoalsTableFilterComposer,
          $$SavingsGoalsTableOrderingComposer,
          $$SavingsGoalsTableAnnotationComposer,
          $$SavingsGoalsTableCreateCompanionBuilder,
          $$SavingsGoalsTableUpdateCompanionBuilder,
          (
            SavingsGoalRow,
            BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoalRow>,
          ),
          SavingsGoalRow,
          PrefetchHooks Function()
        > {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetAmount = const Value.absent(),
                Value<int> savedAmount = const Value.absent(),
                Value<int?> targetDate = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavingsGoalsCompanion(
                id: id,
                name: name,
                targetAmount: targetAmount,
                savedAmount: savedAmount,
                targetDate: targetDate,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int targetAmount,
                Value<int> savedAmount = const Value.absent(),
                Value<int?> targetDate = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SavingsGoalsCompanion.insert(
                id: id,
                name: name,
                targetAmount: targetAmount,
                savedAmount: savedAmount,
                targetDate: targetDate,
                isDeleted: isDeleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavingsGoalsTable, SavingsGoalRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SavingsGoalsTable,
                    SavingsGoalRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTable,
      SavingsGoalRow,
      $$SavingsGoalsTableFilterComposer,
      $$SavingsGoalsTableOrderingComposer,
      $$SavingsGoalsTableAnnotationComposer,
      $$SavingsGoalsTableCreateCompanionBuilder,
      $$SavingsGoalsTableUpdateCompanionBuilder,
      (
        SavingsGoalRow,
        BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoalRow>,
      ),
      SavingsGoalRow,
      PrefetchHooks Function()
    >;
typedef $$ExchangeRatesTableCreateCompanionBuilder =
    ExchangeRatesCompanion Function({
      required String fromCurrency,
      required String toCurrency,
      required String rate,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ExchangeRatesTableUpdateCompanionBuilder =
    ExchangeRatesCompanion Function({
      Value<String> fromCurrency,
      Value<String> toCurrency,
      Value<String> rate,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ExchangeRatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExchangeRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExchangeRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExchangeRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExchangeRatesTable,
          ExchangeRateRow,
          $$ExchangeRatesTableFilterComposer,
          $$ExchangeRatesTableOrderingComposer,
          $$ExchangeRatesTableAnnotationComposer,
          $$ExchangeRatesTableCreateCompanionBuilder,
          $$ExchangeRatesTableUpdateCompanionBuilder,
          (
            ExchangeRateRow,
            BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRateRow>,
          ),
          ExchangeRateRow,
          PrefetchHooks Function()
        > {
  $$ExchangeRatesTableTableManager(_$AppDatabase db, $ExchangeRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> fromCurrency = const Value.absent(),
                Value<String> toCurrency = const Value.absent(),
                Value<String> rate = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExchangeRatesCompanion(
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                rate: rate,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String fromCurrency,
                required String toCurrency,
                required String rate,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExchangeRatesCompanion.insert(
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                rate: rate,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExchangeRatesTable, ExchangeRateRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExchangeRatesTable,
                    ExchangeRateRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExchangeRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExchangeRatesTable,
      ExchangeRateRow,
      $$ExchangeRatesTableFilterComposer,
      $$ExchangeRatesTableOrderingComposer,
      $$ExchangeRatesTableAnnotationComposer,
      $$ExchangeRatesTableCreateCompanionBuilder,
      $$ExchangeRatesTableUpdateCompanionBuilder,
      (
        ExchangeRateRow,
        BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRateRow>,
      ),
      ExchangeRateRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db, _db.wallets);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$WalletGroupsTableTableManager get walletGroups =>
      $$WalletGroupsTableTableManager(_db, _db.walletGroups);
  $$WalletGroupMembersTableTableManager get walletGroupMembers =>
      $$WalletGroupMembersTableTableManager(_db, _db.walletGroupMembers);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$AssetValueHistoryTableTableManager get assetValueHistory =>
      $$AssetValueHistoryTableTableManager(_db, _db.assetValueHistory);
  $$LiabilitiesTableTableManager get liabilities =>
      $$LiabilitiesTableTableManager(_db, _db.liabilities);
  $$LiabilityPaymentsTableTableManager get liabilityPayments =>
      $$LiabilityPaymentsTableTableManager(_db, _db.liabilityPayments);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$BudgetWalletMembersTableTableManager get budgetWalletMembers =>
      $$BudgetWalletMembersTableTableManager(_db, _db.budgetWalletMembers);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(_db, _db.recurringTransactions);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$CommitteesTableTableManager get committees =>
      $$CommitteesTableTableManager(_db, _db.committees);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db, _db.exchangeRates);
}
