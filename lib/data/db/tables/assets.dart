import 'package:drift/drift.dart';

@DataClassName('AssetRow')
class Assets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()();
  IntColumn get purchasePrice => integer().nullable()();
  IntColumn get purchaseDate => integer().nullable()();
  IntColumn get currentValue => integer()();
  TextColumn get currency => text().withDefault(const Constant('PKR'))();
  TextColumn get quantity => text().nullable()();

  TextColumn get unit => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AssetValueHistoryRow')
class AssetValueHistory extends Table {
  TextColumn get id => text()();
  TextColumn get assetId => text()();
  IntColumn get value => integer()();
  IntColumn get date => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
