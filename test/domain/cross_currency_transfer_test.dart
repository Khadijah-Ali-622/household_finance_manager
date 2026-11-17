import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/enums/transaction_type.dart';
import 'package:household_finance_manager/domain/models/money_amount.dart';
import 'package:household_finance_manager/domain/models/transaction.dart';
import 'package:household_finance_manager/domain/services/balance_calculator.dart';

void main() {
  const calc = BalanceCalculator();

  test('cross-currency transfer uses amount out and toAmount in', () {
    final now = DateTime.now();
    final transfer = Transaction(
      id: 't1',
      walletId: 'pkr-cash',
      type: TxType.transfer,
      amount: const MoneyAmount(280000), // Rs 2,800 sent
      toAmount: const MoneyAmount(1000), // $10.00 received
      toWalletId: 'usd-bank',
      date: now,
      isDeleted: false,
      createdAt: now,
      updatedAt: now,
    );

    final pkr = calc.calculate(
      openingBalance: const MoneyAmount(500000),
      walletId: 'pkr-cash',
      transactions: [transfer],
    );
    final usd = calc.calculate(
      openingBalance: const MoneyAmount(0),
      walletId: 'usd-bank',
      transactions: [transfer],
    );

    expect(pkr.minorUnits, 220000);
    expect(usd.minorUnits, 1000);
    expect(calc.sumIncome([transfer]).minorUnits, 0);
    expect(calc.sumExpense([transfer]).minorUnits, 0);
  });

  test('same-currency transfer still uses amount when toAmount null', () {
    final now = DateTime.now();
    final transfer = Transaction(
      id: 't2',
      walletId: 'a',
      type: TxType.transfer,
      amount: const MoneyAmount(10000),
      toWalletId: 'b',
      date: now,
      isDeleted: false,
      createdAt: now,
      updatedAt: now,
    );

    final a = calc.calculate(
      openingBalance: const MoneyAmount(20000),
      walletId: 'a',
      transactions: [transfer],
    );
    final b = calc.calculate(
      openingBalance: MoneyAmount.zero,
      walletId: 'b',
      transactions: [transfer],
    );
    expect(a.minorUnits, 10000);
    expect(b.minorUnits, 10000);
  });
}
