import 'package:collection/collection.dart';

import '../../core/utils/date_utils.dart';
import '../../core/utils/uuid.dart';
import '../../domain/enums/transaction_type.dart';
import '../../domain/models/money_amount.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/wallet.dart';
import '../../domain/services/balance_calculator.dart';
import '../../domain/services/currency_converter.dart';
import '../../domain/services/net_worth_calculator.dart';
import 'asset_repository.dart';
import 'liability_repository.dart';
import 'transaction_repository.dart';
import 'wallet_repository.dart';

class CategorySpend {
  const CategorySpend({required this.categoryId, required this.amount});
  final String categoryId;
  final MoneyAmount amount;
}

/// One calendar month of income/expense (transfers excluded).
class MonthIncomeExpense {
  const MonthIncomeExpense({
    required this.year,
    required this.month,
    required this.income,
    required this.expense,
  });

  final int year;
  final int month;
  final MoneyAmount income;
  final MoneyAmount expense;
}

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.totalBalance,
    required this.monthIncome,
    required this.monthExpense,
    required this.netWorth,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.baseCurrency,
    required this.wallets,
    required this.topCategories,
    required this.monthlyIncomeExpense,
    required this.recentTransactions,
  });

  final MoneyAmount totalBalance;
  final MoneyAmount monthIncome;
  final MoneyAmount monthExpense;
  final MoneyAmount netWorth;
  final MoneyAmount totalAssets;
  final MoneyAmount totalLiabilities;
  final String baseCurrency;
  final List<Wallet> wallets;
  final List<CategorySpend> topCategories;
  final List<MonthIncomeExpense> monthlyIncomeExpense;
  final List<Transaction> recentTransactions;
}

class DashboardRepository {
  DashboardRepository({
    required WalletRepository wallets,
    required TransactionRepository transactions,
    required AssetRepository assets,
    required LiabilityRepository liabilities,
    // ignore: avoid_unused_constructor_parameters
    BalanceCalculator? balanceCalculator,
    NetWorthCalculator? netWorthCalculator,
  })  : _wallets = wallets,
        _transactions = transactions,
        _assets = assets,
        _liabilities = liabilities,
        _netWorth = netWorthCalculator ?? const NetWorthCalculator();

  final WalletRepository _wallets;
  final TransactionRepository _transactions;
  final AssetRepository _assets;
  final LiabilityRepository _liabilities;
  final NetWorthCalculator _netWorth;

  Stream<DashboardSnapshot> watch({
    required String baseCurrency,
    required CurrencyConverter converter,
  }) async* {
    await for (final wallets in _wallets.watchActiveWithBalances()) {
      final txs = await _transactions.getAll();
      final assets = await _assets.getAll();
      final liabilities = await _liabilities.getAll();
      final recent = txs.take(5).toList();
      final walletById = {for (final w in wallets) w.id: w};

      final now = DateTime.now();
      final from = toMillis(startOfMonth(now));
      final to = toMillis(endOfMonth(now));
      final monthTx = txs.where((t) {
        final ms = toMillis(t.date);
        return ms >= from && ms <= to;
      });

      final monthIncome = _sumInBase(
        monthTx.where((t) => t.type == TxType.income),
        walletById,
        converter,
      );
      final monthExpense = _sumInBase(
        monthTx.where((t) => t.type == TxType.expense),
        walletById,
        converter,
      );

      var totalBalance = 0;
      for (final w in wallets) {
        if (w.isLiabilityType) continue;
        totalBalance +=
            converter.toBase(w.balance, w.currency).minorUnits;
      }

      final spendByCat = <String, int>{};
      for (final tx in monthTx) {
        if (tx.type != TxType.expense || tx.categoryId == null) continue;
        final wallet = walletById[tx.walletId];
        final currency = wallet?.currency ?? baseCurrency;
        final converted = converter.toBase(tx.amount, currency);
        spendByCat[tx.categoryId!] =
            (spendByCat[tx.categoryId!] ?? 0) + converted.minorUnits;
      }
      final top = spendByCat.entries
          .sorted((a, b) => b.value.compareTo(a.value))
          .take(5)
          .map(
            (e) => CategorySpend(
              categoryId: e.key,
              amount: MoneyAmount(e.value),
            ),
          )
          .toList();

      final nw = _netWorth.calculate(
        walletsWithBalances: wallets,
        assets: assets,
        liabilities: liabilities,
        converter: converter,
      );

      final monthlyIncomeExpense = <MonthIncomeExpense>[];
      for (var i = 5; i >= 0; i--) {
        final monthDate = DateTime(now.year, now.month - i, 1);
        final mFrom = toMillis(startOfMonth(monthDate));
        final mTo = toMillis(endOfMonth(monthDate));
        final bucket = txs.where((t) {
          final ms = toMillis(t.date);
          return ms >= mFrom && ms <= mTo;
        });
        monthlyIncomeExpense.add(
          MonthIncomeExpense(
            year: monthDate.year,
            month: monthDate.month,
            income: _sumInBase(
              bucket.where((t) => t.type == TxType.income),
              walletById,
              converter,
            ),
            expense: _sumInBase(
              bucket.where((t) => t.type == TxType.expense),
              walletById,
              converter,
            ),
          ),
        );
      }

      yield DashboardSnapshot(
        totalBalance: MoneyAmount(totalBalance),
        monthIncome: monthIncome,
        monthExpense: monthExpense,
        netWorth: nw,
        totalAssets: _netWorth.totalAssets(
          walletsWithBalances: wallets,
          assets: assets,
          converter: converter,
        ),
        totalLiabilities: _netWorth.totalLiabilities(
          walletsWithBalances: wallets,
          liabilities: liabilities,
          converter: converter,
        ),
        baseCurrency: baseCurrency,
        wallets: wallets,
        topCategories: top,
        monthlyIncomeExpense: monthlyIncomeExpense,
        recentTransactions: recent,
      );
    }
  }

  MoneyAmount _sumInBase(
    Iterable<Transaction> txs,
    Map<String, Wallet> walletById,
    CurrencyConverter converter,
  ) {
    var total = 0;
    for (final tx in txs) {
      if (tx.isDeleted) continue;
      final currency = walletById[tx.walletId]?.currency ?? converter.baseCurrency;
      total += converter.toBase(tx.amount, currency).minorUnits;
    }
    return MoneyAmount(total);
  }
}
