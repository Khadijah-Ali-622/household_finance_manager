import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/enums/transaction_type.dart';
import 'package:household_finance_manager/domain/models/money_amount.dart';
import 'package:household_finance_manager/domain/models/transaction.dart';
import 'package:household_finance_manager/domain/services/balance_calculator.dart';

void main() {
  const calc = BalanceCalculator();

  test('transfer moves money between wallets without income/expense', () {
    final now = DateTime.now();
    final transfer = Transaction(
      id: 't1',
      walletId: 'cash',
      type: TxType.transfer,
      amount: const MoneyAmount(100000),
      toWalletId: 'bank',
      date: now,
      isDeleted: false,
      createdAt: now,
      updatedAt: now,
    );

    final cash = calc.calculate(
      openingBalance: const MoneyAmount(200000),
      walletId: 'cash',
      transactions: [transfer],
    );
    final bank = calc.calculate(
      openingBalance: const MoneyAmount(500000),
      walletId: 'bank',
      transactions: [transfer],
    );

    expect(cash.minorUnits, 100000);
    expect(bank.minorUnits, 600000);
    expect(calc.sumIncome([transfer]).minorUnits, 0);
    expect(calc.sumExpense([transfer]).minorUnits, 0);
  });
}
