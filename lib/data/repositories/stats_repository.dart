import '../../domain/models/category.dart';
import '../../domain/models/money_amount.dart';
import '../../domain/models/stats_models.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/wallet.dart';
import '../../domain/services/currency_converter.dart';
import '../../domain/services/stats_aggregator.dart';
import 'transaction_repository.dart';

class StatsSnapshot {
  const StatsSnapshot({
    required this.incomeTotal,
    required this.expenseTotal,
    required this.breakdown,
    required this.baseCurrency,
  });

  final MoneyAmount incomeTotal;
  final MoneyAmount expenseTotal;
  final StatsBreakdown breakdown;
  final String baseCurrency;
}

/// Loads transactions and delegates aggregation to [StatsAggregator].
class StatsRepository {
  StatsRepository({
    required TransactionRepository transactions,
    StatsAggregator? aggregator,
  })  : _transactions = transactions,
        _aggregator = aggregator ?? const StatsAggregator();

  final TransactionRepository _transactions;
  final StatsAggregator _aggregator;

  StatsAggregator get aggregator => _aggregator;

  Stream<StatsSnapshot> watch({
    required StatsQuery query,
    required List<Category> categories,
    required List<Wallet> wallets,
    required String baseCurrency,
    required CurrencyConverter converter,
  }) async* {
    await for (final txs in _transactions.watchAll()) {
      yield compute(
        transactions: txs,
        query: query,
        categories: categories,
        wallets: wallets,
        baseCurrency: baseCurrency,
        converter: converter,
      );
    }
  }

  StatsSnapshot compute({
    required List<Transaction> transactions,
    required StatsQuery query,
    required List<Category> categories,
    required List<Wallet> wallets,
    required String baseCurrency,
    required CurrencyConverter converter,
  }) {
    final meta = {
      for (final c in categories)
        c.id: CategoryMeta(id: c.id, name: c.name, icon: c.icon),
    };
    final currencyByWallet = {
      for (final w in wallets) w.id: w.currency,
    };

    int amountInBase(Transaction tx) {
      final currency = currencyByWallet[tx.walletId] ?? baseCurrency;
      return converter.toBase(tx.amount, currency).minorUnits;
    }

    final totals = _aggregator.totalsFor(
      transactions: transactions,
      range: query.range,
      walletIds: query.walletIds,
      amountOf: amountInBase,
    );

    final breakdown = _aggregator.analyze(
      transactions: transactions,
      query: query,
      categories: meta,
      amountOf: amountInBase,
    );

    return StatsSnapshot(
      incomeTotal: totals.income,
      expenseTotal: totals.expense,
      breakdown: breakdown,
      baseCurrency: baseCurrency,
    );
  }
}
