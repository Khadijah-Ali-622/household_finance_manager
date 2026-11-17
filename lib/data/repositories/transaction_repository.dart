import 'package:drift/drift.dart';

import '../../core/utils/uuid.dart';
import '../../domain/enums/transaction_type.dart';
import '../../domain/models/money_amount.dart';
import '../../domain/models/transaction.dart';
import '../db/app_database.dart';
import '../db/daos/transactions_dao.dart';
import '../db/mappers.dart';

class TransactionRepository {
  TransactionRepository(this._db);

  final AppDatabase _db;

  Stream<List<Transaction>> watchFiltered(TransactionFilter filter) {
    return _db.transactionsDao
        .watchFiltered(filter)
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  Stream<List<Transaction>> watchRecent({int limit = 5}) {
    return _db.transactionsDao
        .watchRecent(limit: limit)
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  Stream<List<Transaction>> watchAll() {
    return _db.transactionsDao.watchAllActive().map(
      (rows) => rows.map((r) => r.toDomain()).toList(),
    );
  }

  Future<List<Transaction>> getAll() async {
    final rows = await _db.transactionsDao.getAllActive();
    return rows.map((r) => r.toDomain()).toList();
  }

  Future<Transaction?> getById(String id) async {
    final row = await _db.transactionsDao.getById(id);
    if (row == null || row.isDeleted) return null;
    return row.toDomain();
  }

  Future<void> save({
    String? id,
    required String walletId,
    required TxType type,
    required MoneyAmount amount,
    MoneyAmount? toAmount,
    String? categoryId,
    String? toWalletId,
    required DateTime date,
    String? note,
    String? paymentMethod,
    String? recurringId,
  }) async {
    if (amount.minorUnits <= 0) {
      throw ArgumentError('Amount must be positive');
    }
    if (type == TxType.transfer) {
      if (toWalletId == null || toWalletId.isEmpty) {
        throw ArgumentError('Transfer requires toWalletId');
      }
      if (toWalletId == walletId) {
        throw ArgumentError('Cannot transfer to the same wallet');
      }
      final received = toAmount ?? amount;
      if (received.minorUnits <= 0) {
        throw ArgumentError('Received amount must be positive');
      }
    } else if (categoryId == null) {
      throw ArgumentError('Category required for income/expense');
    }

    final now = nowMillis();
    final txId = id ?? newId();
    final existing = id == null ? null : await _db.transactionsDao.getById(id);

    await _db.transactionsDao.upsert(
      TransactionsCompanion(
        id: Value(txId),
        walletId: Value(walletId),
        type: Value(type.storageValue),
        amount: Value(amount.minorUnits),
        toAmount: Value(
          type == TxType.transfer ? (toAmount ?? amount).minorUnits : null,
        ),
        categoryId: Value(type == TxType.transfer ? null : categoryId),
        toWalletId: Value(type == TxType.transfer ? toWalletId : null),
        date: Value(toMillis(date)),
        note: Value(note?.trim().isEmpty == true ? null : note?.trim()),
        paymentMethod: Value(paymentMethod),
        recurringId: recurringId == null
            ? const Value.absent()
            : Value(recurringId),
        isDeleted: const Value(false),
        createdAt: Value(existing?.createdAt ?? now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> delete(String id) =>
      _db.transactionsDao.softDelete(id, nowMillis());
}
