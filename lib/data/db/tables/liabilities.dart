import 'package:drift/drift.dart';

@DataClassName('LiabilityRow')
class Liabilities extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()();
  IntColumn get totalAmount => integer()();
  IntColumn get remainingAmount => integer()();
  TextColumn get currency => text().withDefault(const Constant('PKR'))();
  IntColumn get installmentAmount => integer().nullable()();

  IntColumn get dueDate => integer().nullable()();
  TextColumn get interestRate => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get linkedWalletId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LiabilityPaymentRow')
class LiabilityPayments extends Table {
  TextColumn get id => text()();
  TextColumn get liabilityId => text()();
  IntColumn get amount => integer()();
  IntColumn get date => integer()();
  TextColumn get transactionId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
