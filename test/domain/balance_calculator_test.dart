import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/enums/transaction_type.dart';
import 'package:household_finance_manager/domain/models/money_amount.dart';
import 'package:household_finance_manager/domain/models/transaction.dart';
import 'package:household_finance_manager/domain/services/balance_calculator.dart';

Transaction _tx({
  required String id,
  required String walletId,
  required TxType type,
  required int amount,
  String? toWalletId,
  bool isDeleted = false,
}) {
  final now = DateTime.now();
  return Transaction(
    id: id,
    walletId: walletId,
    type: type,
    amount: MoneyAmount(amount),
    toWalletId: toWalletId,
    date: now,
    isDeleted: isDeleted,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  const calc = BalanceCalculator();

  test('balance = opening + income - expense + in - out', () {
    final balance = calc.calculate(
      openingBalance: const MoneyAmount(100000), // 1000
      walletId: 'w1',
      transactions: [
        _tx(id: '1', walletId: 'w1', type: TxType.income, amount: 50000),
        _tx(id: '2', walletId: 'w1', type: TxType.expense, amount: 20000),
        _tx(
          id: '3',
          walletId: 'w1',
          type: TxType.transfer,
          amount: 10000,
          toWalletId: 'w2',
        ),
        _tx(
          id: '4',
          walletId: 'w2',
          type: TxType.transfer,
          amount: 5000,
          toWalletId: 'w1',
        ),
      ],
    );
    // 1000 + 500 - 200 - 100 + 50 = 1250 => 125000
    expect(balance.minorUnits, 125000);
  });

  test('soft-deleted transactions are ignored', () {
    final balance = calc.calculate(
      openingBalance: MoneyAmount.zero,
      walletId: 'w1',
      transactions: [
        _tx(
          id: '1',
          walletId: 'w1',
          type: TxType.income,
          amount: 10000,
          isDeleted: true,
        ),
      ],
    );
    expect(balance.minorUnits, 0);
  });

  test('income and expense sums exclude transfers', () {
    final txs = [
      _tx(id: '1', walletId: 'w1', type: TxType.income, amount: 100),
      _tx(id: '2', walletId: 'w1', type: TxType.expense, amount: 40),
      _tx(
        id: '3',
        walletId: 'w1',
        type: TxType.transfer,
        amount: 25,
        toWalletId: 'w2',
      ),
    ];
    expect(calc.sumIncome(txs).minorUnits, 100);
    expect(calc.sumExpense(txs).minorUnits, 40);
  });
}
