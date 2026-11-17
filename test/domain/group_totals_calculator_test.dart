import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/enums/transaction_type.dart';
import 'package:household_finance_manager/domain/enums/wallet_type.dart';
import 'package:household_finance_manager/domain/models/money_amount.dart';
import 'package:household_finance_manager/domain/models/transaction.dart';
import 'package:household_finance_manager/domain/models/wallet.dart';
import 'package:household_finance_manager/domain/services/group_totals_calculator.dart';

Wallet _wallet(String id, int opening, {bool liability = false}) {
  final now = DateTime.now();
  return Wallet(
    id: id,
    name: id,
    icon: 'w',
    color: 1,
    currency: 'PKR',
    openingBalance: MoneyAmount(opening),
    type: liability ? WalletType.creditCard : WalletType.cash,
    isLiabilityType: liability,
    isArchived: false,
    isDeleted: false,
    createdAt: now,
    updatedAt: now,
  );
}

Transaction _tx(
  String walletId,
  TxType type,
  int amount, {
  String? to,
}) {
  final now = DateTime.now();
  return Transaction(
    id: '$walletId-$amount-$type',
    walletId: walletId,
    type: type,
    amount: MoneyAmount(amount),
    toWalletId: to,
    date: now,
    isDeleted: false,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  final calc = GroupTotalsCalculator();

  test('group totals combine selected wallets without merging data', () {
    final wallets = [_wallet('a', 1000), _wallet('b', 2000)];
    final txs = [
      _tx('a', TxType.income, 500),
      _tx('a', TxType.expense, 100),
      _tx('b', TxType.expense, 200),
      _tx('a', TxType.transfer, 50, to: 'b'),
    ];

    final totals = calc.calculate(wallets: wallets, allTransactions: txs);

    expect(totals.totalIncome.minorUnits, 500);
    expect(totals.totalExpense.minorUnits, 300);
    // a: 1000+500-100-50=1350, b: 2000-200+50=1850 => 3200
    expect(totals.totalBalance.minorUnits, 3200);
    expect(totals.perWallet.length, 2);
  });

  test('credit card wallets excluded from combined cash balance', () {
    final wallets = [_wallet('cash', 1000), _wallet('cc', 500, liability: true)];
    final totals = calc.calculate(wallets: wallets, allTransactions: const []);
    expect(totals.totalBalance.minorUnits, 1000);
    expect(totals.perWallet.length, 2);
  });
}
