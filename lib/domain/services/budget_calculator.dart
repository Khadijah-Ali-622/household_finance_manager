import '../enums/transaction_type.dart';
import '../models/money_amount.dart';
import '../models/transaction.dart';

enum BudgetStatus { under75, warning75, over }

/// Spending progress for one budget month.
/// [limit] is the effective cap, including rollover when it applies.
class BudgetProgress {
  const BudgetProgress({
    required this.limit,
    required this.spent,
    required this.remaining,
    required this.ratio,
  });

  final MoneyAmount limit;
  final MoneyAmount spent;

  /// [limit] minus [spent]. Negative when spending is past the limit.
  final MoneyAmount remaining;

  /// [spent] / [limit]. Zero when [limit] is zero.
  final double ratio;

  /// Below 75%, from 75% up to (but not including) 100%, then over.
  BudgetStatus get status {
    if (ratio < 0.75) return BudgetStatus.under75;
    if (ratio < 1.0) return BudgetStatus.warning75;
    return BudgetStatus.over;
  }
}

/// Pure budget math. Transfers and deleted rows never count as spent.
class BudgetCalculator {
  const BudgetCalculator();

  static int yearMonthOf(DateTime date) => date.year * 100 + date.month;

  static DateTime monthStart(int yearMonth) =>
      DateTime(yearMonth ~/ 100, yearMonth % 100);

  static int shiftMonth(int yearMonth, int delta) {
    final shifted = DateTime(yearMonth ~/ 100, yearMonth % 100 + delta);
    return yearMonthOf(shifted);
  }

  static int previousYearMonth(int yearMonth) => shiftMonth(yearMonth, -1);

  static bool isInYearMonth(DateTime date, int yearMonth) {
    return date.year == yearMonth ~/ 100 && date.month == yearMonth % 100;
  }

  /// Sum of expense amounts in [yearMonth].
  /// Null [categoryId] includes every category. Empty [walletIds] includes
  /// every wallet. Income, transfers, and deleted transactions are skipped.
  MoneyAmount spent({
    required Iterable<Transaction> transactions,
    required int yearMonth,
    String? categoryId,
    List<String> walletIds = const [],
  }) {
    final wallets = walletIds.toSet();
    final filterWallets = wallets.isNotEmpty;
    var total = 0;
    for (final tx in transactions) {
      if (tx.isDeleted || tx.type != TxType.expense) continue;
      if (!isInYearMonth(tx.date, yearMonth)) continue;
      if (categoryId != null && tx.categoryId != categoryId) continue;
      if (filterWallets && !wallets.contains(tx.walletId)) continue;
      total += tx.amount.minorUnits;
    }
    return MoneyAmount(total);
  }

  /// Base [amount] plus unused room from last month when [rollover] is on.
  /// A negative [previousRemaining] does not reduce the limit.
  MoneyAmount effectiveLimit({
    required MoneyAmount amount,
    required bool rollover,
    MoneyAmount previousRemaining = MoneyAmount.zero,
  }) {
    if (!rollover || previousRemaining.minorUnits <= 0) return amount;
    return amount + previousRemaining;
  }

  BudgetProgress progress({
    required MoneyAmount amount,
    required bool rollover,
    MoneyAmount previousRemaining = MoneyAmount.zero,
    required Iterable<Transaction> transactions,
    required int yearMonth,
    String? categoryId,
    List<String> walletIds = const [],
  }) {
    final limit = effectiveLimit(
      amount: amount,
      rollover: rollover,
      previousRemaining: previousRemaining,
    );
    final spentAmount = spent(
      transactions: transactions,
      yearMonth: yearMonth,
      categoryId: categoryId,
      walletIds: walletIds,
    );
    final ratio = limit.minorUnits == 0
        ? 0.0
        : spentAmount.minorUnits / limit.minorUnits;
    return BudgetProgress(
      limit: limit,
      spent: spentAmount,
      remaining: limit - spentAmount,
      ratio: ratio,
    );
  }

  /// True once spending reaches 80% and this budget has not been notified yet.
  bool shouldNotify80({
    required BudgetProgress progress,
    required bool notify80,
    DateTime? lastNotified80At,
  }) {
    if (!notify80 || lastNotified80At != null) return false;
    return progress.ratio >= 0.8;
  }

  /// True when spending is at or past the limit and over-budget was not sent.
  bool shouldNotifyOver({
    required BudgetProgress progress,
    required bool notifyOver,
    DateTime? lastNotifiedOverAt,
  }) {
    if (!notifyOver || lastNotifiedOverAt != null) return false;
    return progress.status == BudgetStatus.over;
  }
}
