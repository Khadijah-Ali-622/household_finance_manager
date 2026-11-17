import 'package:drift/drift.dart';

import '../app_database.dart';

part 'transactions_dao.g.dart';

class TransactionFilter {
  const TransactionFilter({
    this.walletId,
    this.categoryId,
    this.type,
    this.search,
    this.fromDate,
    this.toDate,
  });

  final String? walletId;
  final String? categoryId;
  final String? type;
  final String? search;
  final int? fromDate;
  final int? toDate;
}

@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  Stream<List<TransactionRow>> watchFiltered(TransactionFilter filter) {
    final query = select(transactions)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (filter.walletId != null) {
      final wid = filter.walletId!;
      query.where(
        (t) => t.walletId.equals(wid) | t.toWalletId.equals(wid),
      );
    }
    if (filter.categoryId != null) {
      query.where((t) => t.categoryId.equals(filter.categoryId!));
    }
    if (filter.type != null) {
      query.where((t) => t.type.equals(filter.type!));
    }
    if (filter.fromDate != null) {
      query.where((t) => t.date.isBiggerOrEqualValue(filter.fromDate!));
    }
    if (filter.toDate != null) {
      query.where((t) => t.date.isSmallerOrEqualValue(filter.toDate!));
    }
    if (filter.search != null && filter.search!.trim().isNotEmpty) {
      final q = '%${filter.search!.trim()}%';
      query.where((t) => t.note.like(q));
    }

    return query.watch();
  }

  Stream<List<TransactionRow>> watchRecent({int limit = 5}) {
    return (select(transactions)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(limit))
        .watch();
  }

  Stream<List<TransactionRow>> watchAllActive() {
    return (select(transactions)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// One-shot fetch — prefer this inside other stream callbacks (avoids
  /// nested-watch deadlocks on web's single-threaded SQLite).
  Future<List<TransactionRow>> getAllActive() {
    return (select(transactions)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<List<TransactionRow>> getForWallets(List<String> walletIds) {
    if (walletIds.isEmpty) return Future.value([]);
    return (select(transactions)
          ..where(
            (t) =>
                t.isDeleted.equals(false) &
                (t.walletId.isIn(walletIds) | t.toWalletId.isIn(walletIds)),
          ))
        .get();
  }

  Future<TransactionRow?> getById(String id) {
    return (select(transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsert(TransactionsCompanion entry) =>
      into(transactions).insertOnConflictUpdate(entry);

  Future<void> softDelete(String id, int updatedAt) {
    return (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(updatedAt),
      ),
    );
  }
}
