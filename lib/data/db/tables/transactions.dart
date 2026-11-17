import 'package:drift/drift.dart';

@DataClassName('TransactionRow')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get walletId => text()();
  TextColumn get type => text()(); // income | expense | transfer
  IntColumn get amount => integer()(); // always positive minor units (from wallet)
  /// Received amount in to-wallet currency for cross-currency transfers.
  /// Null means same as [amount] (same-currency transfer).
  IntColumn get toAmount => integer().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get toWalletId => text().nullable()();

  IntColumn get date => integer()();
  TextColumn get note => text().nullable()();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get receiptPath => text().nullable()();
  TextColumn get recurringId => text().nullable()();
  TextColumn get linkedAssetId => text().nullable()();
  TextColumn get linkedLiabilityId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
