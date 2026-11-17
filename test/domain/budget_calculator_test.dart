import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/enums/transaction_type.dart';
import 'package:household_finance_manager/domain/models/money_amount.dart';
import 'package:household_finance_manager/domain/models/transaction.dart';
import 'package:household_finance_manager/domain/services/budget_calculator.dart';

Transaction _tx({
  required String id,
  required TxType type,
  required int amount,
  required DateTime date,
  String walletId = 'w1',
  String? categoryId,
  bool isDeleted = false,
}) {
  return Transaction(
    id: id,
    walletId: walletId,
    type: type,
    amount: MoneyAmount(amount),
    categoryId: categoryId,
    date: date,
    isDeleted: isDeleted,
    createdAt: date,
    updatedAt: date,
  );
}

void main() {
  const calc = BudgetCalculator();
  final march = DateTime(2026, 3, 15);
  final marchEnd = DateTime(2026, 3, 31, 23, 30);
  final aprilStart = DateTime(2026, 4, 1, 0, 5);

  List<Transaction> sample() {
    return [
      _tx(
        id: 'food',
        type: TxType.expense,
        amount: 4000,
        date: march,
        categoryId: 'food',
      ),
      _tx(
        id: 'fuel',
        type: TxType.expense,
        amount: 2500,
        date: marchEnd,
        categoryId: 'fuel',
        walletId: 'w2',
      ),
      _tx(
        id: 'income',
        type: TxType.income,
        amount: 9000,
        date: march,
        categoryId: 'salary',
      ),
      _tx(
        id: 'transfer',
        type: TxType.transfer,
        amount: 50000,
        date: march,
        categoryId: 'food',
      ),
      _tx(
        id: 'deleted',
        type: TxType.expense,
        amount: 8000,
        date: march,
        categoryId: 'food',
        isDeleted: true,
      ),
      _tx(
        id: 'april',
        type: TxType.expense,
        amount: 3000,
        date: aprilStart,
        categoryId: 'food',
      ),
    ];
  }

  group('spent', () {
    test('excludes transfers, income, deleted rows, and other months', () {
      final spent = calc.spent(
        transactions: sample(),
        yearMonth: 202603,
      );
      expect(spent.minorUnits, 6500);
    });

    test('category filter counts only that category', () {
      final spent = calc.spent(
        transactions: sample(),
        yearMonth: 202603,
        categoryId: 'food',
      );
      expect(spent.minorUnits, 4000);
    });

    test('wallet filter limits wallets and empty means all', () {
      final txs = sample();
      expect(
        calc
            .spent(
              transactions: txs,
              yearMonth: 202603,
              walletIds: const ['w2'],
            )
            .minorUnits,
        2500,
      );
      expect(
        calc
            .spent(
              transactions: txs,
              yearMonth: 202603,
              walletIds: const [],
            )
            .minorUnits,
        6500,
      );
    });
  });

  group('thresholds and rollover', () {
    test('under 75, warning from 75, over at 100', () {
      BudgetProgress at(int spentMinor) {
        return calc.progress(
          amount: const MoneyAmount(10000),
          rollover: false,
          transactions: [
            _tx(
              id: 'e',
              type: TxType.expense,
              amount: spentMinor,
              date: march,
            ),
          ],
          yearMonth: 202603,
        );
      }

      expect(at(7499).ratio, closeTo(0.7499, 0.0001));
      expect(at(7499).status, BudgetStatus.under75);
      expect(at(7500).status, BudgetStatus.warning75);
      expect(at(9999).status, BudgetStatus.warning75);
      expect(at(10000).status, BudgetStatus.over);
      expect(at(12000).status, BudgetStatus.over);
      expect(at(12000).remaining.minorUnits, -2000);
    });

    test('ratio is 0 when the limit is 0', () {
      final progress = calc.progress(
        amount: MoneyAmount.zero,
        rollover: false,
        transactions: [
          _tx(id: 'e', type: TxType.expense, amount: 50, date: march),
        ],
        yearMonth: 202603,
      );
      expect(progress.ratio, 0);
      expect(progress.status, BudgetStatus.under75);
      expect(progress.remaining.minorUnits, -50);
    });

    test('rollover adds only a positive previous remainder', () {
      final february = [
        _tx(
          id: 'feb',
          type: TxType.expense,
          amount: 4000,
          date: DateTime(2026, 2, 10),
        ),
        _tx(
          id: 'feb-transfer',
          type: TxType.transfer,
          amount: 20000,
          date: DateTime(2026, 2, 11),
        ),
      ];
      final februaryProgress = calc.progress(
        amount: const MoneyAmount(10000),
        rollover: false,
        transactions: february,
        yearMonth: 202602,
      );
      expect(februaryProgress.remaining.minorUnits, 6000);

      final rolled = calc.progress(
        amount: const MoneyAmount(10000),
        rollover: true,
        previousRemaining: februaryProgress.remaining,
        transactions: [
          _tx(id: 'mar', type: TxType.expense, amount: 1000, date: march),
        ],
        yearMonth: 202603,
      );
      expect(rolled.limit.minorUnits, 16000);
      expect(rolled.spent.minorUnits, 1000);
      expect(rolled.remaining.minorUnits, 15000);

      final ignored = calc.progress(
        amount: const MoneyAmount(10000),
        rollover: true,
        previousRemaining: const MoneyAmount(-2500),
        transactions: const [],
        yearMonth: 202603,
      );
      expect(ignored.limit.minorUnits, 10000);

      final noFlag = calc.progress(
        amount: const MoneyAmount(10000),
        rollover: false,
        previousRemaining: const MoneyAmount(6000),
        transactions: const [],
        yearMonth: 202603,
      );
      expect(noFlag.limit.minorUnits, 10000);
    });
  });

  group('notifications', () {
    BudgetProgress ratioProgress(double ratio) {
      return BudgetProgress(
        limit: const MoneyAmount(10000),
        spent: MoneyAmount((ratio * 10000).round()),
        remaining: MoneyAmount(10000 - (ratio * 10000).round()),
        ratio: ratio,
      );
    }

    test('shouldNotify80 respects the flag, ratio, and last notified', () {
      final almost = ratioProgress(0.8);
      final below = ratioProgress(0.79);
      expect(
        calc.shouldNotify80(
          progress: almost,
          notify80: true,
          lastNotified80At: null,
        ),
        isTrue,
      );
      expect(
        calc.shouldNotify80(
          progress: below,
          notify80: true,
          lastNotified80At: null,
        ),
        isFalse,
      );
      expect(
        calc.shouldNotify80(
          progress: almost,
          notify80: false,
          lastNotified80At: null,
        ),
        isFalse,
      );
      expect(
        calc.shouldNotify80(
          progress: almost,
          notify80: true,
          lastNotified80At: DateTime(2026, 3, 20),
        ),
        isFalse,
      );
    });

    test('shouldNotifyOver respects the flag, status, and last notified', () {
      final over = ratioProgress(1);
      final warning = ratioProgress(0.9);
      expect(over.status, BudgetStatus.over);
      expect(warning.status, BudgetStatus.warning75);
      expect(
        calc.shouldNotifyOver(
          progress: over,
          notifyOver: true,
          lastNotifiedOverAt: null,
        ),
        isTrue,
      );
      expect(
        calc.shouldNotifyOver(
          progress: warning,
          notifyOver: true,
          lastNotifiedOverAt: null,
        ),
        isFalse,
      );
      expect(
        calc.shouldNotifyOver(
          progress: over,
          notifyOver: false,
          lastNotifiedOverAt: null,
        ),
        isFalse,
      );
      expect(
        calc.shouldNotifyOver(
          progress: over,
          notifyOver: true,
          lastNotifiedOverAt: DateTime(2026, 3, 21),
        ),
        isFalse,
      );
    });
  });
}
