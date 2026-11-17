import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/enums/stats_period_kind.dart';
import 'package:household_finance_manager/domain/enums/transaction_type.dart';
import 'package:household_finance_manager/domain/models/money_amount.dart';
import 'package:household_finance_manager/domain/models/stats_models.dart';
import 'package:household_finance_manager/domain/models/transaction.dart';
import 'package:household_finance_manager/domain/services/stats_aggregator.dart';

Transaction _tx({
  required String id,
  required TxType type,
  required int amount,
  required DateTime date,
  String walletId = 'w1',
  String? categoryId,
  String? toWalletId,
  bool isDeleted = false,
}) {
  return Transaction(
    id: id,
    walletId: walletId,
    type: type,
    amount: MoneyAmount(amount),
    categoryId: categoryId,
    toWalletId: toWalletId,
    date: date,
    isDeleted: isDeleted,
    createdAt: date,
    updatedAt: date,
  );
}

void main() {
  const agg = StatsAggregator();

  group('period boundaries', () {
    test('weekly range starts on Monday and ends Sunday', () {
      // Wednesday 12 Nov 2025
      final range = agg.rangeFor(
        kind: StatsPeriodKind.weekly,
        anchor: DateTime(2025, 11, 12),
        weekStartWeekday: DateTime.monday,
      );
      expect(range.start, DateTime(2025, 11, 10));
      expect(range.end.year, 2025);
      expect(range.end.month, 11);
      expect(range.end.day, 16);
      expect(range.end.hour, 23);
      expect(range.dayCount, 7);
    });

    test('weekly range can start on Sunday when configured', () {
      final range = agg.rangeFor(
        kind: StatsPeriodKind.weekly,
        anchor: DateTime(2025, 11, 12),
        weekStartWeekday: DateTime.sunday,
      );
      expect(range.start, DateTime(2025, 11, 9));
      expect(range.end.day, 15);
    });

    test('monthly range is first to last day of month', () {
      final range = agg.rangeFor(
        kind: StatsPeriodKind.monthly,
        anchor: DateTime(2026, 2, 14),
      );
      expect(range.start, DateTime(2026, 2, 1));
      expect(range.end.day, 28);
      expect(range.end.year, 2026);
      expect(range.dayCount, 28);
    });

    test('annually range is Jan 1 to Dec 31', () {
      final range = agg.rangeFor(
        kind: StatsPeriodKind.annually,
        anchor: DateTime(2026, 8, 1),
      );
      expect(range.start, DateTime(2026, 1, 1));
      expect(range.end.month, 12);
      expect(range.end.day, 31);
      expect(range.start.year, 2026);
    });

    test('custom range is inclusive start/end days', () {
      final range = agg.rangeFor(
        kind: StatsPeriodKind.custom,
        anchor: DateTime(2026, 1, 1),
        customStart: DateTime(2026, 3, 5, 15),
        customEnd: DateTime(2026, 3, 10, 8),
      );
      expect(range.start, DateTime(2026, 3, 5));
      expect(range.end.day, 10);
      expect(range.dayCount, 6);
    });

    test('shift weekly / monthly / annually', () {
      final week = agg.rangeFor(
        kind: StatsPeriodKind.weekly,
        anchor: DateTime(2026, 11, 12),
      );
      final nextWeek = agg.shift(
        current: week,
        kind: StatsPeriodKind.weekly,
        delta: 1,
      );
      // Week of 2026-11-12 (Thu) starts Mon 2026-11-09; next week → 2026-11-16.
      expect(nextWeek.start, DateTime(2026, 11, 16));

      final month = agg.rangeFor(
        kind: StatsPeriodKind.monthly,
        anchor: DateTime(2026, 1, 15),
      );
      final nextMonth = agg.shift(
        current: month,
        kind: StatsPeriodKind.monthly,
        delta: 1,
      );
      expect(nextMonth.start, DateTime(2026, 2, 1));

      final year = agg.rangeFor(
        kind: StatsPeriodKind.annually,
        anchor: DateTime(2026, 5, 1),
      );
      final prevYear = agg.shift(
        current: year,
        kind: StatsPeriodKind.annually,
        delta: -1,
      );
      expect(prevYear.start.year, 2025);
    });
  });

  group('transfer exclusion and soft-delete', () {
    test('transfers and deleted txs are excluded from income and expense', () {
      final range = StatsDateRange(
        start: DateTime(2026, 11, 1),
        end: DateTime(2026, 11, 30, 23, 59, 59, 999),
      );
      final txs = [
        _tx(
          id: '1',
          type: TxType.income,
          amount: 10000,
          date: DateTime(2026, 11, 5),
          categoryId: 'sal',
        ),
        _tx(
          id: '2',
          type: TxType.expense,
          amount: 4000,
          date: DateTime(2026, 11, 6),
          categoryId: 'food',
        ),
        _tx(
          id: '3',
          type: TxType.transfer,
          amount: 2500,
          date: DateTime(2026, 11, 7),
          toWalletId: 'w2',
        ),
        _tx(
          id: '4',
          type: TxType.expense,
          amount: 9999,
          date: DateTime(2026, 11, 8),
          categoryId: 'food',
          isDeleted: true,
        ),
      ];

      final totals = agg.totalsFor(transactions: txs, range: range);
      expect(totals.income.minorUnits, 10000);
      expect(totals.expense.minorUnits, 4000);

      final expense = agg.analyze(
        transactions: txs,
        query: StatsQuery(
          range: range,
          flow: StatsFlow.expense,
          periodKind: StatsPeriodKind.monthly,
        ),
        categories: {
          'food': const CategoryMeta(id: 'food', name: 'Food', icon: 'eco'),
        },
      );
      expect(expense.total.minorUnits, 4000);
    });
  });

  group('percentages and Other grouping', () {
    test('percentages always sum to 100', () {
      final percents = StatsAggregator.percentagesThatSumTo100([
        100,
        100,
        100,
      ]);
      expect(percents.fold<int>(0, (a, b) => a + b), 100);

      final uneven = StatsAggregator.percentagesThatSumTo100([1, 1, 1]);
      expect(uneven.fold<int>(0, (a, b) => a + b), 100);

      final empty = StatsAggregator.percentagesThatSumTo100([]);
      expect(empty, isEmpty);
    });

    test('slices below 3% are grouped into Other and percents sum to 100', () {
      final range = StatsDateRange(
        start: DateTime(2026, 11, 1),
        end: DateTime(2026, 11, 30, 23, 59, 59, 999),
      );
      // total = 10000
      // a=7000 (70%), b=2500 (25%), c=200 (2%), d=300 (3% — kept: not strictly < 3%)
      // Wait: threshold is strictly < 3%, so 300*100=30000, total*3=30000 → NOT < → kept
      // c=200: 200*100=20000 < 30000 → Other
      final txs = [
        _tx(
          id: 'a',
          type: TxType.expense,
          amount: 7000,
          date: DateTime(2026, 11, 2),
          categoryId: 'a',
        ),
        _tx(
          id: 'b',
          type: TxType.expense,
          amount: 2500,
          date: DateTime(2026, 11, 3),
          categoryId: 'b',
        ),
        _tx(
          id: 'c',
          type: TxType.expense,
          amount: 200,
          date: DateTime(2026, 11, 4),
          categoryId: 'c',
        ),
        _tx(
          id: 'd',
          type: TxType.expense,
          amount: 300,
          date: DateTime(2026, 11, 5),
          categoryId: 'd',
        ),
      ];

      final result = agg.analyze(
        transactions: txs,
        query: StatsQuery(
          range: range,
          flow: StatsFlow.expense,
          periodKind: StatsPeriodKind.monthly,
        ),
        categories: {
          'a': const CategoryMeta(id: 'a', name: 'A', icon: 'a'),
          'b': const CategoryMeta(id: 'b', name: 'B', icon: 'b'),
          'c': const CategoryMeta(id: 'c', name: 'C', icon: 'c'),
          'd': const CategoryMeta(id: 'd', name: 'D', icon: 'd'),
        },
      );

      expect(result.total.minorUnits, 10000);
      expect(result.slices.any((s) => s.isOther), isTrue);
      final other = result.slices.firstWhere((s) => s.isOther);
      expect(other.amount.minorUnits, 200);
      expect(result.slices.where((s) => s.categoryId == 'c'), isEmpty);
      expect(
        result.slices.fold<int>(0, (a, s) => a + s.percent),
        100,
      );
    });

    test('multiple tiny slices merge into a single Other', () {
      final range = StatsDateRange(
        start: DateTime(2026, 1, 1),
        end: DateTime(2026, 1, 31, 23, 59, 59, 999),
      );
      // total 10000; big 9400; two tiny 300 each → both < 3%? 300*100=30000, 10000*3=30000 → NOT strictly less
      // use 200 and 200 and big 9600
      final txs = [
        _tx(
          id: '1',
          type: TxType.expense,
          amount: 9600,
          date: DateTime(2026, 1, 2),
          categoryId: 'big',
        ),
        _tx(
          id: '2',
          type: TxType.expense,
          amount: 200,
          date: DateTime(2026, 1, 3),
          categoryId: 't1',
        ),
        _tx(
          id: '3',
          type: TxType.expense,
          amount: 200,
          date: DateTime(2026, 1, 4),
          categoryId: 't2',
        ),
      ];

      final result = agg.analyze(
        transactions: txs,
        query: StatsQuery(
          range: range,
          flow: StatsFlow.expense,
          periodKind: StatsPeriodKind.monthly,
        ),
        categories: {
          'big': const CategoryMeta(id: 'big', name: 'Big', icon: 'b'),
          't1': const CategoryMeta(id: 't1', name: 'T1', icon: 't'),
          't2': const CategoryMeta(id: 't2', name: 'T2', icon: 't'),
        },
      );

      expect(result.slices.length, 2);
      expect(result.slices.last.isOther, isTrue);
      expect(result.slices.last.amount.minorUnits, 400);
      expect(
        result.slices.fold<int>(0, (a, s) => a + s.percent),
        100,
      );
    });
  });

  group('bar buckets', () {
    test('weekly builds 7 daily bars', () {
      final range = agg.rangeFor(
        kind: StatsPeriodKind.weekly,
        anchor: DateTime(2026, 11, 12),
      );
      final bars = agg.buildBarBuckets(
        transactions: const [],
        range: range,
        periodKind: StatsPeriodKind.weekly,
      );
      expect(bars.length, 7);
    });

    test('annually builds 12 monthly bars', () {
      final range = agg.rangeFor(
        kind: StatsPeriodKind.annually,
        anchor: DateTime(2026, 6, 1),
      );
      final bars = agg.buildBarBuckets(
        transactions: const [],
        range: range,
        periodKind: StatsPeriodKind.annually,
      );
      expect(bars.length, 12);
    });
  });
}
