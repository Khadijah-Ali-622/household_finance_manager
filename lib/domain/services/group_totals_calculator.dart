import '../models/money_amount.dart';
import '../models/transaction.dart';
import '../models/wallet.dart';
import 'balance_calculator.dart';
import 'currency_converter.dart';

class WalletBreakdown {
  const WalletBreakdown({
    required this.wallet,
    required this.balance,
    required this.income,
    required this.expense,
    this.balanceInBase,
    this.incomeInBase,
    this.expenseInBase,
  });

  final Wallet wallet;
  final MoneyAmount balance;
  final MoneyAmount income;
  final MoneyAmount expense;
  final MoneyAmount? balanceInBase;
  final MoneyAmount? incomeInBase;
  final MoneyAmount? expenseInBase;
}

class GroupTotals {
  const GroupTotals({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.perWallet,
  });

  /// Totals in base currency when a converter is supplied; otherwise raw sum
  /// (only correct when all wallets share one currency).
  final MoneyAmount totalBalance;
  final MoneyAmount totalIncome;
  final MoneyAmount totalExpense;
  final List<WalletBreakdown> perWallet;
}

/// Combined view for a selection of wallets — display only, never merges data.
class GroupTotalsCalculator {
  GroupTotalsCalculator([BalanceCalculator? balanceCalculator])
      : _balance = balanceCalculator ?? const BalanceCalculator();

  final BalanceCalculator _balance;

  GroupTotals calculate({
    required List<Wallet> wallets,
    required Iterable<Transaction> allTransactions,
    CurrencyConverter? converter,
  }) {
    final walletIds = wallets.map((w) => w.id).toSet();
    final relevant = allTransactions
        .where(
          (tx) =>
              !tx.isDeleted &&
              (walletIds.contains(tx.walletId) ||
                  (tx.toWalletId != null && walletIds.contains(tx.toWalletId))),
        )
        .toList();

    final perWallet = <WalletBreakdown>[];
    var totalBalance = 0;
    var totalIncome = 0;
    var totalExpense = 0;

    for (final wallet in wallets) {
      final walletTxs = relevant.where(
        (tx) => tx.walletId == wallet.id || tx.toWalletId == wallet.id,
      );
      final bal = _balance.calculate(
        openingBalance: wallet.openingBalance,
        walletId: wallet.id,
        transactions: walletTxs,
      );

      final own = relevant.where((tx) => tx.walletId == wallet.id);
      final income = _balance.sumIncome(own);
      final expense = _balance.sumExpense(own);

      final balBase = converter?.toBase(bal, wallet.currency);
      final incomeBase = converter?.toBase(income, wallet.currency);
      final expenseBase = converter?.toBase(expense, wallet.currency);

      perWallet.add(
        WalletBreakdown(
          wallet: wallet,
          balance: bal,
          income: income,
          expense: expense,
          balanceInBase: balBase,
          incomeInBase: incomeBase,
          expenseInBase: expenseBase,
        ),
      );

      if (!wallet.isLiabilityType) {
        totalBalance += (balBase ?? bal).minorUnits;
      }
      totalIncome += (incomeBase ?? income).minorUnits;
      totalExpense += (expenseBase ?? expense).minorUnits;
    }

    return GroupTotals(
      totalBalance: MoneyAmount(totalBalance),
      totalIncome: MoneyAmount(totalIncome),
      totalExpense: MoneyAmount(totalExpense),
      perWallet: perWallet,
    );
  }
}
