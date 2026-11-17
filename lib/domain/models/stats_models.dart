import '../enums/stats_period_kind.dart';
import 'money_amount.dart';

/// Inclusive date range for a stats period (local calendar dates).
class StatsDateRange {
  const StatsDateRange({required this.start, required this.end});

  /// Start of the first day (00:00:00.000).
  final DateTime start;

  /// End of the last day (23:59:59.999).
  final DateTime end;

  int get dayCount {
    final a = DateTime(start.year, start.month, start.day);
    final b = DateTime(end.year, end.month, end.day);
    return b.difference(a).inDays + 1;
  }
}

class StatsCategorySlice {
  const StatsCategorySlice({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.amount,
    required this.percent,
    required this.colorIndex,
    this.isOther = false,
  });

  /// Null when [isOther] or uncategorized.
  final String? categoryId;
  final String name;
  final String icon;
  final MoneyAmount amount;

  /// Whole percent 0–100; all slices in a breakdown sum to 100 (or 0 if empty).
  final int percent;
  final int colorIndex;
  final bool isOther;
}

class StatsBarBucket {
  const StatsBarBucket({
    required this.start,
    required this.end,
    required this.label,
    required this.amount,
  });

  final DateTime start;
  final DateTime end;
  final String label;
  final MoneyAmount amount;
}

class StatsBreakdown {
  const StatsBreakdown({
    required this.total,
    required this.slices,
    required this.bars,
  });

  final MoneyAmount total;
  final List<StatsCategorySlice> slices;
  final List<StatsBarBucket> bars;

  bool get isEmpty => total.isZero;
}

class StatsQuery {
  const StatsQuery({
    required this.range,
    required this.flow,
    required this.periodKind,
    this.walletIds,
  });

  final StatsDateRange range;
  final StatsFlow flow;
  final StatsPeriodKind periodKind;

  /// Null or empty = all wallets. Otherwise only these wallet IDs.
  final Set<String>? walletIds;
}

class CategoryMeta {
  const CategoryMeta({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final String icon;
}
