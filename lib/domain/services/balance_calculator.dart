import '../enums/transaction_type.dart';
import '../models/money_amount.dart';
import '../models/transaction.dart';

/// Wallet balance is NEVER stored as an editable field.
/// balance = opening + income − expense + transfers_in − transfers_out
class BalanceCalculator {
  const BalanceCalculator();

  /// [transactions] must already exclude soft-deleted rows.
  MoneyAmount calculate({
    required MoneyAmount openingBalance,
    required String walletId,
    required Iterable<Transaction> transactions,
  }) {
    var balance = openingBalance.minorUnits;

    for (final tx in transactions) {
      if (tx.isDeleted) continue;
      final amount = tx.amount.minorUnits;

      switch (tx.type) {
        case TxType.income:
          if (tx.walletId == walletId) balance += amount;
        case TxType.expense:
          if (tx.walletId == walletId) balance -= amount;
        case TxType.transfer:
          // Transfer is NOT income or expense — only moves between wallets.
          // Cross-currency: debit [amount] from source, credit [toAmount] to dest.
          if (tx.walletId == walletId) {
            balance -= amount; // out (source currency)
          }
          if (tx.toWalletId == walletId) {
            balance += tx.receivedAmount.minorUnits; // in (dest currency)
          }
      }
    }

    return MoneyAmount(balance);
  }

  /// Income total for a wallet set. Transfers are excluded.
  MoneyAmount sumIncome(Iterable<Transaction> transactions) {
    var total = 0;
    for (final tx in transactions) {
      if (tx.isDeleted || tx.type != TxType.income) continue;
      total += tx.amount.minorUnits;
    }
    return MoneyAmount(total);
  }

  /// Expense total for a wallet set. Transfers are excluded.
  MoneyAmount sumExpense(Iterable<Transaction> transactions) {
    var total = 0;
    for (final tx in transactions) {
      if (tx.isDeleted || tx.type != TxType.expense) continue;
      total += tx.amount.minorUnits;
    }
    return MoneyAmount(total);
  }
}
