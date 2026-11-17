import 'package:drift/drift.dart';

@DataClassName('WalletRow')
class Wallets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  TextColumn get currency => text().withDefault(const Constant('PKR'))();
  IntColumn get openingBalance => integer().withDefault(const Constant(0))();
  TextColumn get type => text()();
  BoolColumn get isLiabilityType =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
