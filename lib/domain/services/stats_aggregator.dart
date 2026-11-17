import 'package:intl/intl.dart';

import '../../core/utils/date_utils.dart';
import '../enums/stats_period_kind.dart';
import '../enums/transaction_type.dart';
import '../models/money_amount.dart';
import '../models/stats_models.dart';
import '../models/transaction.dart';

/// Pure stats aggregation — integer money only; no Flutter/UI imports.
class StatsAggregator {
  const StatsAggregator({
    this.otherThresholdPercent = 3,
  });

  /// Slices with share strictly below this percent are grouped into "Other".
  final int otherThresholdPercent;

  // —— Period boundaries ——

  /// [weekStartWeekday] uses [DateTime] constants (1 = Monday … 7 = Sunday).
  StatsDateRange rangeFor({
    required StatsPeriodKind kind,
    required DateTime anchor,
    DateTime? customStart,
    DateTime? customEnd,
    int weekStartWeekday = DateTime.monday,
  }) {
    switch (kind) {
      case StatsPeriodKind.weekly:
        return weekContaining(anchor, weekStartWeekday: weekStartWeekday);
      case StatsPeriodKind.monthly:
        return StatsDateRange(
          start: startOfMonth(anchor),
          end: endOfMonth(anchor),
        );
      case StatsPeriodKind.annually:
        return StatsDateRange(
          start: DateTime(anchor.year, 1, 1),
          end: DateTime(anchor.year, 12, 31, 23, 59, 59, 999),
        );
      case StatsPeriodKind.custom:
        final s = customStart ?? anchor;
        final e = customEnd ?? anchor;
        final a = startOfDay(s);
        final b = endOfDay(e);
        return a.isAfter(b)
            ? StatsDateRange(start: startOfDay(e), end: endOfDay(s))
            : StatsDateRange(start: a, end: b);
    }
  }

  StatsDateRange weekContaining(
    DateTime date, {
    int weekStartWeekday = DateTime.monday,
  }) {
    final day = startOfDay(date);
    final diff = (day.weekday - weekStartWeekday + 7) % 7;
    final start = day.subtract(Duration(days: diff));
    final end = endOfDay(start.add(const Duration(days: 6)));
    return StatsDateRange(start: start, end: end);
  }

  StatsDateRange shift({
    required StatsDateRange current,
    required StatsPeriodKind kind,
    required int delta,
    int weekStartWeekday = DateTime.monday,
  }) {
    switch (kind) {
      case StatsPeriodKind.weekly:
        final anchor = current.start.add(Duration(days: 7 * delta));
        return weekContaining(anchor, weekStartWeekday: weekStartWeekday);
      case StatsPeriodKind.monthly:
        final anchor = DateTime(current.start.year, current.start.month + delta, 1);
        return StatsDateRange(start: startOfMonth(anchor), end: endOfMonth(anchor));
      case StatsPeriodKind.annually:
        final year = current.start.year + delta;
        return StatsDateRange(
          start: DateTime(year, 1, 1),
          end: DateTime(year, 12, 31, 23, 59, 59, 999),
        );
      case StatsPeriodKind.custom:
        final days = current.dayCount;
        final newStart = startOfDay(current.start.add(Duration(days: days * delta)));
        final newEnd = endOfDay(newStart.add(Duration(days: days - 1)));
        return StatsDateRange(start: newStart, end: newEnd);
    }
  }

  String formatPeriodLabel(StatsDateRange range, StatsPeriodKind kind) {
    switch (kind) {
      case StatsPeriodKind.weekly:
      case StatsPeriodKind.custom:
        final sameMonth = range.start.month == range.end.month &&
            range.start.year == range.end.year;
        if (sameMonth) {
          return '${range.start.day} - ${range.end.day} '
              '${DateFormat('MMM yyyy').format(range.start)}';
        }
        if (range.start.year == range.end.year) {
          return '${DateFormat('d MMM').format(range.start)} - '
              '${DateFormat('d MMM yyyy').format(range.end)}';
        }
        return '${DateFormat('d MMM yyyy').format(range.start)} - '
            '${DateFormat('d MMM yyyy').format(range.end)}';
      case StatsPeriodKind.monthly:
        return DateFormat('MMM yyyy').format(range.start);
      case StatsPeriodKind.annually:
        return '${range.start.year}';
    }
  }

  // —— Aggregation ——

  StatsBreakdown analyze({
    required Iterable<Transaction> transactions,
    required StatsQuery query,
    required Map<String, CategoryMeta> categories,
    String otherLabel = 'Other',
    String uncategorizedLabel = 'Uncategorized',
    int Function(Transaction tx)? amountOf,
  }) {
    final valueOf = amountOf ?? (tx) => tx.amount.minorUnits;
    final filtered = filterTransactions(transactions, query);
    final totalMinor = filtered.fold<int>(0, (s, t) => s + valueOf(t));
    final total = MoneyAmount(totalMinor);

    final slices = buildCategorySlices(
      transactions: filtered,
      totalMinor: totalMinor,
      categories: categories,
      otherLabel: otherLabel,
      uncategorizedLabel: uncategorizedLabel,
      amountOf: valueOf,
    );

    final bars = buildBarBuckets(
      transactions: filtered,
      range: query.range,
      periodKind: query.periodKind,
      amountOf: valueOf,
    );

    return StatsBreakdown(total: total, slices: slices, bars: bars);
  }

  /// Income and expense totals for a period (transfers & deleted excluded).
  ({MoneyAmount income, MoneyAmount expense}) totalsFor({
    required Iterable<Transaction> transactions,
    required StatsDateRange range,
    Set<String>? walletIds,
    int Function(Transaction tx)? amountOf,
  }) {
    final valueOf = amountOf ?? (tx) => tx.amount.minorUnits;
    var income = 0;
    var expense = 0;
    for (final tx in transactions) {
      if (!_matchesScope(tx, range: range, walletIds: walletIds)) continue;
      if (tx.type == TxType.income) {
        income += valueOf(tx);
      } else if (tx.type == TxType.expense) {
        expense += valueOf(tx);
      }
    }
    return (income: MoneyAmount(income), expense: MoneyAmount(expense));
  }

  List<Transaction> filterTransactions(
    Iterable<Transaction> transactions,
    StatsQuery query,
  ) {
    final wantType =
        query.flow == StatsFlow.income ? TxType.income : TxType.expense;
    return [
      for (final tx in transactions)
        if (_matchesScope(tx, range: query.range, walletIds: query.walletIds) &&
            tx.type == wantType)
          tx,
    ];
  }

  bool _matchesScope(
    Transaction tx, {
    required StatsDateRange range,
    Set<String>? walletIds,
  }) {
    if (tx.isDeleted) return false;
    if (tx.type == TxType.transfer) return false;
    final ms = tx.date.millisecondsSinceEpoch;
    if (ms < range.start.millisecondsSinceEpoch) return false;
    if (ms > range.end.millisecondsSinceEpoch) return false;
    if (walletIds != null && walletIds.isNotEmpty) {
      if (!walletIds.contains(tx.walletId)) return false;
    }
    return true;
  }

  List<StatsCategorySlice> buildCategorySlices({
    required Iterable<Transaction> transactions,
    required int totalMinor,
    required Map<String, CategoryMeta> categories,
    required String otherLabel,
    required String uncategorizedLabel,
    int Function(Transaction tx)? amountOf,
  }) {
    if (totalMinor <= 0) return const [];
    final valueOf = amountOf ?? (tx) => tx.amount.minorUnits;

    final byCat = <String?, int>{};
    for (final tx in transactions) {
      byCat[tx.categoryId] = (byCat[tx.categoryId] ?? 0) + valueOf(tx);
    }

    final kept = <({String? id, String name, String icon, int amount})>[];
    var otherAmount = 0;

    for (final entry in byCat.entries) {
      final amount = entry.value;
      // Strictly below threshold → Other (integer compare, no doubles).
      final isSmall = amount * 100 < totalMinor * otherThresholdPercent;
      if (isSmall) {
        otherAmount += amount;
        continue;
      }
      final id = entry.key;
      if (id == null) {
        kept.add((
          id: null,
          name: uncategorizedLabel,
          icon: 'more_horiz',
          amount: amount,
        ));
      } else {
        final meta = categories[id];
        kept.add((
          id: id,
          name: meta?.name ?? uncategorizedLabel,
          icon: meta?.icon ?? 'more_horiz',
          amount: amount,
        ));
      }
    }

    kept.sort((a, b) => b.amount.compareTo(a.amount));

    final amounts = <int>[
      ...kept.map((e) => e.amount),
      if (otherAmount > 0) otherAmount,
    ];
    final percents = percentagesThatSumTo100(amounts);

    final slices = <StatsCategorySlice>[];
    for (var i = 0; i < kept.length; i++) {
      final row = kept[i];
      slices.add(
        StatsCategorySlice(
          categoryId: row.id,
          name: row.name,
          icon: row.icon,
          amount: MoneyAmount(row.amount),
          percent: percents[i],
          colorIndex: i,
        ),
      );
    }
    if (otherAmount > 0) {
      slices.add(
        StatsCategorySlice(
          categoryId: null,
          name: otherLabel,
          icon: 'more_horiz',
          amount: MoneyAmount(otherAmount),
          percent: percents.last,
          colorIndex: slices.length,
          isOther: true,
        ),
      );
    }
    return slices;
  }

  /// Largest-remainder method so whole percents always sum to 100 (or 0).
  static List<int> percentagesThatSumTo100(List<int> amounts) {
    if (amounts.isEmpty) return const [];
    final total = amounts.fold<int>(0, (a, b) => a + b);
    if (total <= 0) return List.filled(amounts.length, 0);

    final floors = List<int>.filled(amounts.length, 0);
    final fracs = List<int>.filled(amounts.length, 0);
    var used = 0;
    for (var i = 0; i < amounts.length; i++) {
      final product = amounts[i] * 100;
      floors[i] = product ~/ total;
      fracs[i] = product % total;
      used += floors[i];
    }
    var rem = 100 - used;
    final order = List<int>.generate(amounts.length, (i) => i)
      ..sort((a, b) {
        final byFrac = fracs[b].compareTo(fracs[a]);
        if (byFrac != 0) return byFrac;
        return amounts[b].compareTo(amounts[a]);
      });
    final result = List<int>.from(floors);
    for (var i = 0; i < rem; i++) {
      result[order[i]]++;
    }
    return result;
  }

  List<StatsBarBucket> buildBarBuckets({
    required Iterable<Transaction> transactions,
    required StatsDateRange range,
    required StatsPeriodKind periodKind,
    int Function(Transaction tx)? amountOf,
  }) {
    final mode = barGroupingFor(periodKind, range);
    switch (mode) {
      case StatsBarGrouping.day:
        return _dailyBars(transactions, range, amountOf);
      case StatsBarGrouping.week:
        return _weeklyBars(transactions, range, amountOf);
      case StatsBarGrouping.month:
        return _monthlyBars(transactions, range, amountOf);
    }
  }

  /// Custom ranges: ≤31 days → day, ≤93 days → week, else → month.
  StatsBarGrouping barGroupingFor(StatsPeriodKind kind, StatsDateRange range) {
    switch (kind) {
      case StatsPeriodKind.weekly:
        return StatsBarGrouping.day;
      case StatsPeriodKind.monthly:
        return StatsBarGrouping.day;
      case StatsPeriodKind.annually:
        return StatsBarGrouping.month;
      case StatsPeriodKind.custom:
        final days = range.dayCount;
        if (days <= 31) return StatsBarGrouping.day;
        if (days <= 93) return StatsBarGrouping.week;
        return StatsBarGrouping.month;
    }
  }

  List<StatsBarBucket> _dailyBars(
    Iterable<Transaction> transactions,
    StatsDateRange range,
    int Function(Transaction tx)? amountOf,
  ) {
    final dayFmt = DateFormat('d');
    final buckets = <StatsBarBucket>[];
    var cursor = startOfDay(range.start);
    final last = startOfDay(range.end);
    while (!cursor.isAfter(last)) {
      final bStart = cursor;
      final bEnd = endOfDay(cursor);
      buckets.add(
        StatsBarBucket(
          start: bStart,
          end: bEnd,
          label: dayFmt.format(cursor),
          amount: MoneyAmount(_sumIn(transactions, bStart, bEnd, amountOf)),
        ),
      );
      cursor = cursor.add(const Duration(days: 1));
    }
    return buckets;
  }

  List<StatsBarBucket> _weeklyBars(
    Iterable<Transaction> transactions,
    StatsDateRange range,
    int Function(Transaction tx)? amountOf,
  ) {
    final buckets = <StatsBarBucket>[];
    var cursor = startOfDay(range.start);
    final last = startOfDay(range.end);
    var weekIndex = 1;
    while (!cursor.isAfter(last)) {
      final bStart = cursor;
      var bEndDay = cursor.add(const Duration(days: 6));
      if (bEndDay.isAfter(last)) bEndDay = last;
      final bEnd = endOfDay(bEndDay);
      buckets.add(
        StatsBarBucket(
          start: bStart,
          end: bEnd,
          label: 'W$weekIndex',
          amount: MoneyAmount(_sumIn(transactions, bStart, bEnd, amountOf)),
        ),
      );
      weekIndex++;
      cursor = bEndDay.add(const Duration(days: 1));
    }
    return buckets;
  }

  List<StatsBarBucket> _monthlyBars(
    Iterable<Transaction> transactions,
    StatsDateRange range,
    int Function(Transaction tx)? amountOf,
  ) {
    final monthFmt = DateFormat('MMM');
    final buckets = <StatsBarBucket>[];
    var year = range.start.year;
    var month = range.start.month;
    final endYear = range.end.year;
    final endMonth = range.end.month;
    while (year < endYear || (year == endYear && month <= endMonth)) {
      final monthStart = DateTime(year, month, 1);
      final monthEnd = endOfMonth(monthStart);
      final bStart =
          monthStart.isBefore(range.start) ? startOfDay(range.start) : monthStart;
      final bEnd = monthEnd.isAfter(range.end) ? range.end : monthEnd;
      buckets.add(
        StatsBarBucket(
          start: bStart,
          end: bEnd,
          label: monthFmt.format(monthStart),
          amount: MoneyAmount(_sumIn(transactions, bStart, bEnd, amountOf)),
        ),
      );
      month++;
      if (month > 12) {
        month = 1;
        year++;
      }
    }
    return buckets;
  }

  int _sumIn(
    Iterable<Transaction> txs,
    DateTime start,
    DateTime end,
    int Function(Transaction tx)? amountOf,
  ) {
    final valueOf = amountOf ?? (tx) => tx.amount.minorUnits;
    final from = start.millisecondsSinceEpoch;
    final to = end.millisecondsSinceEpoch;
    var sum = 0;
    for (final tx in txs) {
      final ms = tx.date.millisecondsSinceEpoch;
      if (ms >= from && ms <= to) sum += valueOf(tx);
    }
    return sum;
  }
}

enum StatsBarGrouping { day, week, month }
