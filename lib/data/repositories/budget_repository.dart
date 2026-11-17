import 'dart:async';

import 'package:drift/drift.dart';

import '../../core/utils/uuid.dart';
import '../../domain/models/budget.dart';
import '../../domain/models/money_amount.dart';
import '../../domain/models/transaction.dart';
import '../../domain/services/budget_calculator.dart';
import '../db/app_database.dart';
import '../db/mappers.dart';

class BudgetWithProgress {
  const BudgetWithProgress({required this.budget, required this.progress});

  final Budget budget;
  final BudgetProgress progress;
}

class BudgetRepository {
  BudgetRepository(this._db, [BudgetCalculator? calculator])
      : _calc = calculator ?? const BudgetCalculator();

  final AppDatabase _db;
  final BudgetCalculator _calc;
  final Map<int, Future<void>> _ensuring = {};

  Stream<List<BudgetWithProgress>> watchBudgetsForMonth(int yearMonth) {
    late StreamController<List<BudgetWithProgress>> controller;
    StreamSubscription<List<BudgetRow>>? budgetSub;
    StreamSubscription<List<BudgetWalletMemberRow>>? memberSub;
    StreamSubscription<List<TransactionRow>>? txSub;
    var budgetRows = <BudgetRow>[];
    var memberRows = <BudgetWalletMemberRow>[];
    var txRows = <TransactionRow>[];
    var budgetsReady = false;
    var membersReady = false;
    var txsReady = false;

    void emit() {
      if (!budgetsReady || !membersReady || !txsReady || controller.isClosed) {
        return;
      }
      try {
        controller.add(
          _mapProgress(yearMonth, budgetRows, memberRows, txRows),
        );
      } catch (e, st) {
        controller.addError(e, st);
      }
    }

    controller = StreamController<List<BudgetWithProgress>>(
      onListen: () {
        budgetSub = _db.budgetsDao.watchAll().listen((rows) {
          budgetRows = rows;
          budgetsReady = true;
          emit();
        }, onError: controller.addError);
        memberSub = _db.budgetsDao.watchAllMembers().listen((rows) {
          memberRows = rows;
          membersReady = true;
          emit();
        }, onError: controller.addError);
        txSub = _db.transactionsDao.watchAllActive().listen((rows) {
          txRows = rows;
          txsReady = true;
          emit();
        }, onError: controller.addError);
      },
      onCancel: () async {
        await budgetSub?.cancel();
        await memberSub?.cancel();
        await txSub?.cancel();
      },
    );

    return controller.stream;
  }

  Future<Budget?> getById(String id) async {
    final row = await _db.budgetsDao.getById(id);
    if (row == null || row.isDeleted) return null;
    final members = await _db.budgetsDao.memberIds(id);
    return row.toDomain(walletIds: members);
  }

  Future<void> save({
    String? id,
    String? categoryId,
    List<String> walletIds = const [],
    required MoneyAmount amount,
    required String currency,
    required int yearMonth,
    required bool rollover,
    required bool notify80,
    required bool notifyOver,
    String? name,
  }) async {
    if (amount.minorUnits <= 0) {
      throw ArgumentError('Amount must be greater than zero');
    }
    final now = nowMillis();
    final budgetId = id ?? newId();
    final existing = id == null ? null : await getById(id);
    final trimmed = name?.trim();
    final storedName =
        (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    final wallets = walletIds.toSet().toList();

    await _db.transaction(() async {
      await _db.budgetsDao.upsert(
        BudgetsCompanion(
          id: Value(budgetId),
          categoryId: Value(categoryId),
          walletId: Value(wallets.length == 1 ? wallets.first : null),
          amount: Value(amount.minorUnits),
          currency: Value(currency),
          period: const Value('monthly'),
          startMonth: Value(yearMonth),
          yearMonth: Value(yearMonth),
          rollover: Value(rollover),
          notify80: Value(notify80),
          notifyOver: Value(notifyOver),
          lastNotified80At: Value(
            existing?.lastNotified80At == null
                ? null
                : toMillis(existing!.lastNotified80At!),
          ),
          lastNotifiedOverAt: Value(
            existing?.lastNotifiedOverAt == null
                ? null
                : toMillis(existing!.lastNotifiedOverAt!),
          ),
          name: Value(storedName),
          isDeleted: const Value(false),
          createdAt: Value(
            existing == null ? now : toMillis(existing.createdAt),
          ),
          updatedAt: Value(now),
        ),
      );
      await _db.budgetsDao.replaceMembers(budgetId, wallets, now);
    });
  }

  Future<void> delete(String id) =>
      _db.budgetsDao.softDelete(id, nowMillis());

  /// Copies earlier months forward when this month has never had a budget row.
  /// A cleared month (soft-deleted rows) is left empty.
  Future<void> ensureMonthBudgets(int yearMonth) {
    return _ensureTracked(yearMonth, 0);
  }

  Future<void> _ensureTracked(int yearMonth, int depth) {
    final pending = _ensuring[yearMonth];
    if (pending != null) return pending;
    final future = _fillMonthIfEmpty(yearMonth, depth);
    _ensuring[yearMonth] = future;
    return future.whenComplete(() => _ensuring.remove(yearMonth));
  }

  Future<void> _fillMonthIfEmpty(int yearMonth, int depth) async {
    if (depth > 36) return;
    final count = await _db.budgetsDao.countForMonth(yearMonth);
    if (count > 0) return;
    final previous = BudgetCalculator.previousYearMonth(yearMonth);
    await _ensureTracked(previous, depth + 1);
    await copyFromPreviousMonth(yearMonth);
  }

  /// Inserts missing budgets from the previous month.
  /// Stored amount stays the base limit. Rollover is applied when progress
  /// is computed, so unused money is not added twice.
  Future<void> copyFromPreviousMonth(int yearMonth) async {
    final previousMonth = BudgetCalculator.previousYearMonth(yearMonth);
    final all = await _loadBudgets();
    final current = all.where((b) => b.yearMonth == yearMonth).toList();
    final previous = all.where((b) => b.yearMonth == previousMonth).toList();
    if (previous.isEmpty) return;

    final now = nowMillis();
    await _db.transaction(() async {
      for (final budget in previous) {
        final exists = current.any(
          (other) =>
              other.categoryId == budget.categoryId &&
              other.currency == budget.currency &&
              _sameWallets(other.walletIds, budget.walletIds),
        );
        if (exists) continue;
        final id = newId();
        await _db.budgetsDao.upsert(
          BudgetsCompanion(
            id: Value(id),
            categoryId: Value(budget.categoryId),
            walletId: Value(
              budget.walletIds.length == 1 ? budget.walletIds.first : null,
            ),
            amount: Value(budget.amount.minorUnits),
            currency: Value(budget.currency),
            period: const Value('monthly'),
            startMonth: Value(yearMonth),
            yearMonth: Value(yearMonth),
            rollover: Value(budget.rollover),
            notify80: Value(budget.notify80),
            notifyOver: Value(budget.notifyOver),
            lastNotified80At: const Value(null),
            lastNotifiedOverAt: const Value(null),
            name: Value(budget.name),
            isDeleted: const Value(false),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
        await _db.budgetsDao.replaceMembers(id, budget.walletIds, now);
      }
    });
  }

  Future<List<BudgetWithProgress>> listForMonth(int yearMonth) async {
    await ensureMonthBudgets(yearMonth);
    final rows = await _db.budgetsDao.getAll();
    final members = await _db.budgetsDao.getAllMembers();
    final txs = await _db.transactionsDao.getAllActive();
    return _mapProgress(yearMonth, rows, members, txs);
  }

  Future<BudgetProgress> computeProgress(Budget budget) async {
    final all = await _loadBudgets();
    final txs = await _db.transactionsDao.getAllActive();
    return _progressFor(
      budget,
      all,
      txs.map((row) => row.toDomain()).toList(),
      {},
      {},
    );
  }

  Future<void> markNotified80(String id) {
    final now = nowMillis();
    return _db.budgetsDao.markNotified80(id, now);
  }

  Future<void> markNotifiedOver(String id) {
    final now = nowMillis();
    return _db.budgetsDao.markNotifiedOver(id, now);
  }

  Future<List<Budget>> _loadBudgets() async {
    final rows = await _db.budgetsDao.getAll();
    final members = await _db.budgetsDao.getAllMembers();
    return _toBudgets(rows, members);
  }

  List<BudgetWithProgress> _mapProgress(
    int yearMonth,
    List<BudgetRow> budgetRows,
    List<BudgetWalletMemberRow> memberRows,
    List<TransactionRow> txRows,
  ) {
    final budgets = _toBudgets(budgetRows, memberRows);
    final transactions = txRows.map((row) => row.toDomain()).toList();
    final memo = <String, BudgetProgress>{};
    final stack = <String>{};
    final result = <BudgetWithProgress>[
      for (final budget in budgets.where((b) => b.yearMonth == yearMonth))
        BudgetWithProgress(
          budget: budget,
          progress: _progressFor(budget, budgets, transactions, memo, stack),
        ),
    ];
    result.sort((a, b) {
      final byRatio = b.progress.ratio.compareTo(a.progress.ratio);
      if (byRatio != 0) return byRatio;
      return a.budget.id.compareTo(b.budget.id);
    });
    return result;
  }

  List<Budget> _toBudgets(
    List<BudgetRow> rows,
    List<BudgetWalletMemberRow> members,
  ) {
    final byBudget = <String, List<String>>{};
    for (final member in members) {
      byBudget.putIfAbsent(member.budgetId, () => []).add(member.walletId);
    }
    return [
      for (final row in rows)
        row.toDomain(walletIds: byBudget[row.id] ?? const []),
    ];
  }

  BudgetProgress _progressFor(
    Budget budget,
    List<Budget> all,
    List<Transaction> transactions,
    Map<String, BudgetProgress> memo,
    Set<String> stack,
  ) {
    final cached = memo[budget.id];
    if (cached != null) return cached;

    if (!stack.add(budget.id)) {
      final broken = _calc.progress(
        amount: budget.amount,
        rollover: false,
        transactions: transactions,
        yearMonth: budget.yearMonth,
        categoryId: budget.categoryId,
        walletIds: budget.walletIds,
      );
      memo[budget.id] = broken;
      return broken;
    }

    var previousRemaining = MoneyAmount.zero;
    if (budget.rollover) {
      final previous = _matchPrevious(budget, all);
      if (previous != null) {
        previousRemaining = _progressFor(
          previous,
          all,
          transactions,
          memo,
          stack,
        ).remaining;
      }
    }

    final progress = _calc.progress(
      amount: budget.amount,
      rollover: budget.rollover,
      previousRemaining: previousRemaining,
      transactions: transactions,
      yearMonth: budget.yearMonth,
      categoryId: budget.categoryId,
      walletIds: budget.walletIds,
    );
    memo[budget.id] = progress;
    stack.remove(budget.id);
    return progress;
  }

  Budget? _matchPrevious(Budget budget, List<Budget> all) {
    final previousMonth = BudgetCalculator.previousYearMonth(budget.yearMonth);
    Budget? match;
    for (final other in all) {
      if (other.yearMonth != previousMonth) continue;
      if (other.categoryId != budget.categoryId) continue;
      if (other.currency != budget.currency) continue;
      if (!_sameWallets(other.walletIds, budget.walletIds)) continue;
      if (match == null || other.updatedAt.isAfter(match.updatedAt)) {
        match = other;
      }
    }
    return match;
  }

  bool _sameWallets(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final left = a.toSet();
    final right = b.toSet();
    return left.length == right.length && left.containsAll(right);
  }
}
