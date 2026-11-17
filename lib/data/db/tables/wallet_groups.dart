import 'package:drift/drift.dart';

@DataClassName('WalletGroupRow')
class WalletGroups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get icon => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WalletGroupMemberRow')
class WalletGroupMembers extends Table {
  TextColumn get groupId => text()();
  TextColumn get walletId => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {groupId, walletId};
}
