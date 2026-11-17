import 'package:drift/drift.dart';

import '../app_database.dart';

part 'budgets_dao.g.dart';

@DriftAccessor(tables: [Budgets, BudgetWalletMembers])
class BudgetsDao extends DatabaseAccessor<AppDatabase> with _$BudgetsDaoMixin {
  BudgetsDao(super.db);

  Stream<List<BudgetRow>> watchAll() {
    return (select(budgets)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm.desc(t.yearMonth),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch();
  }

  Future<List<BudgetRow>> getAll() {
    return (select(budgets)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm.desc(t.yearMonth),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .get();
  }

  Future<BudgetRow?> getById(String id) {
    return (select(budgets)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Includes soft-deleted rows so a cleared month is not copied again.
  Future<int> countForMonth(int yearMonth) async {
    final count = countAll();
    final query = selectOnly(budgets)
      ..addColumns([count])
      ..where(budgets.yearMonth.equals(yearMonth));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> upsert(BudgetsCompanion entry) =>
      into(budgets).insertOnConflictUpdate(entry);

  Future<void> softDelete(String id, int updatedAt) {
    return (update(budgets)..where((t) => t.id.equals(id))).write(
      BudgetsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<void> markNotified80(String id, int at) {
    return (update(budgets)..where((t) => t.id.equals(id))).write(
      BudgetsCompanion(
        lastNotified80At: Value(at),
        updatedAt: Value(at),
      ),
    );
  }

  Future<void> markNotifiedOver(String id, int at) {
    return (update(budgets)..where((t) => t.id.equals(id))).write(
      BudgetsCompanion(
        lastNotifiedOverAt: Value(at),
        updatedAt: Value(at),
      ),
    );
  }

  Stream<List<BudgetWalletMemberRow>> watchMembers(String budgetId) {
    return (select(budgetWalletMembers)
          ..where((t) => t.budgetId.equals(budgetId)))
        .watch();
  }

  Stream<List<BudgetWalletMemberRow>> watchAllMembers() =>
      select(budgetWalletMembers).watch();

  Future<List<BudgetWalletMemberRow>> getAllMembers() =>
      select(budgetWalletMembers).get();

  Future<List<String>> memberIds(String budgetId) async {
    final rows = await (select(budgetWalletMembers)
          ..where((t) => t.budgetId.equals(budgetId)))
        .get();
    return rows.map((row) => row.walletId).toList();
  }

  Future<void> replaceMembers(
    String budgetId,
    List<String> walletIds,
    int createdAt,
  ) async {
    final unique = walletIds.toSet().toList();
    await transaction(() async {
      await (delete(budgetWalletMembers)
            ..where((t) => t.budgetId.equals(budgetId)))
          .go();
      if (unique.isEmpty) return;
      await batch((b) {
        b.insertAll(
          budgetWalletMembers,
          [
            for (final walletId in unique)
              BudgetWalletMembersCompanion.insert(
                budgetId: budgetId,
                walletId: walletId,
                createdAt: createdAt,
              ),
          ],
        );
      });
    });
  }
}
