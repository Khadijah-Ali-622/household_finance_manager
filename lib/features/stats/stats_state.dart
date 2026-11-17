import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/enums/stats_period_kind.dart';
import '../../domain/models/stats_models.dart';
import '../../domain/services/stats_aggregator.dart';

const _kChartType = 'stats_chart_type';
const _kWeekStartsMonday = 'week_starts_on_monday';

/// Wallet scope for stats: all, an explicit set, or a saved group.
sealed class StatsWalletScope {
  const StatsWalletScope();
}

class StatsWalletAll extends StatsWalletScope {
  const StatsWalletAll();
}

class StatsWalletSelected extends StatsWalletScope {
  const StatsWalletSelected(this.walletIds);
  final Set<String> walletIds;
}

class StatsWalletGroupScope extends StatsWalletScope {
  const StatsWalletGroupScope(this.groupId, this.walletIds);
  final String groupId;
  final Set<String> walletIds;
}

class StatsUiState {
  const StatsUiState({
    required this.periodKind,
    required this.range,
    required this.flow,
    required this.chartType,
    required this.weekStartsOnMonday,
    required this.walletScope,
    this.customStart,
    this.customEnd,
  });

  final StatsPeriodKind periodKind;
  final StatsDateRange range;
  final StatsFlow flow;
  final StatsChartType chartType;
  final bool weekStartsOnMonday;
  final StatsWalletScope walletScope;
  final DateTime? customStart;
  final DateTime? customEnd;

  int get weekStartWeekday =>
      weekStartsOnMonday ? DateTime.monday : DateTime.sunday;

  Set<String>? get walletIds => switch (walletScope) {
        StatsWalletAll() => null,
        StatsWalletSelected(:final walletIds) => walletIds,
        StatsWalletGroupScope(:final walletIds) => walletIds,
      };

  StatsUiState copyWith({
    StatsPeriodKind? periodKind,
    StatsDateRange? range,
    StatsFlow? flow,
    StatsChartType? chartType,
    bool? weekStartsOnMonday,
    StatsWalletScope? walletScope,
    DateTime? customStart,
    DateTime? customEnd,
    bool clearCustom = false,
  }) {
    return StatsUiState(
      periodKind: periodKind ?? this.periodKind,
      range: range ?? this.range,
      flow: flow ?? this.flow,
      chartType: chartType ?? this.chartType,
      weekStartsOnMonday: weekStartsOnMonday ?? this.weekStartsOnMonday,
      walletScope: walletScope ?? this.walletScope,
      customStart: clearCustom ? null : (customStart ?? this.customStart),
      customEnd: clearCustom ? null : (customEnd ?? this.customEnd),
    );
  }
}

class StatsUiNotifier extends Notifier<StatsUiState> {
  static const _agg = StatsAggregator();

  @override
  StatsUiState build() {
    final now = DateTime.now();
    final range = _agg.rangeFor(
      kind: StatsPeriodKind.monthly,
      anchor: now,
    );
    // Load prefs asynchronously without blocking first frame.
    Future.microtask(_loadPrefs);
    return StatsUiState(
      periodKind: StatsPeriodKind.monthly,
      range: range,
      flow: StatsFlow.expense,
      chartType: StatsChartType.pie,
      weekStartsOnMonday: true,
      walletScope: const StatsWalletAll(),
    );
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final chartRaw = prefs.getString(_kChartType);
    final chart = chartRaw == 'bar' ? StatsChartType.bar : StatsChartType.pie;
    final weekMon = prefs.getBool(_kWeekStartsMonday) ?? true;
    if (!ref.mounted) return;
    var next = state.copyWith(
      chartType: chart,
      weekStartsOnMonday: weekMon,
    );
    if (state.periodKind == StatsPeriodKind.weekly) {
      next = next.copyWith(
        range: _agg.rangeFor(
          kind: StatsPeriodKind.weekly,
          anchor: state.range.start,
          weekStartWeekday: weekMon ? DateTime.monday : DateTime.sunday,
        ),
      );
    }
    state = next;
  }

  Future<void> setChartType(StatsChartType type) async {
    state = state.copyWith(chartType: type);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kChartType,
      type == StatsChartType.bar ? 'bar' : 'pie',
    );
  }

  Future<void> setWeekStartsOnMonday(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWeekStartsMonday, value);
    if (!ref.mounted) return;
    var next = state.copyWith(weekStartsOnMonday: value);
    if (state.periodKind == StatsPeriodKind.weekly) {
      next = next.copyWith(
        range: _agg.rangeFor(
          kind: StatsPeriodKind.weekly,
          anchor: state.range.start,
          weekStartWeekday: value ? DateTime.monday : DateTime.sunday,
        ),
      );
    }
    state = next;
  }

  void setFlow(StatsFlow flow) => state = state.copyWith(flow: flow);

  void setPeriodKind(StatsPeriodKind kind) {
    if (kind == StatsPeriodKind.custom) {
      state = state.copyWith(
        periodKind: kind,
        customStart: state.range.start,
        customEnd: startOfDaySafe(state.range.end),
      );
      return;
    }
    final range = _agg.rangeFor(
      kind: kind,
      anchor: state.range.start,
      weekStartWeekday: state.weekStartWeekday,
    );
    state = state.copyWith(
      periodKind: kind,
      range: range,
      clearCustom: true,
    );
  }

  void setCustomRange(DateTime start, DateTime end) {
    final range = _agg.rangeFor(
      kind: StatsPeriodKind.custom,
      anchor: start,
      customStart: start,
      customEnd: end,
    );
    state = state.copyWith(
      periodKind: StatsPeriodKind.custom,
      range: range,
      customStart: startOfDaySafe(start),
      customEnd: startOfDaySafe(end),
    );
  }

  void shift(int delta) {
    if (state.periodKind == StatsPeriodKind.custom) return;
    final range = _agg.shift(
      current: state.range,
      kind: state.periodKind,
      delta: delta,
      weekStartWeekday: state.weekStartWeekday,
    );
    state = state.copyWith(range: range);
  }

  void setWalletScope(StatsWalletScope scope) {
    state = state.copyWith(walletScope: scope);
  }

  static DateTime startOfDaySafe(DateTime d) =>
      DateTime(d.year, d.month, d.day);
}

final statsUiProvider =
    NotifierProvider<StatsUiNotifier, StatsUiState>(StatsUiNotifier.new);

/// Separate provider so More page can toggle week start without opening Stats.
final weekStartsOnMondayProvider = Provider<bool>((ref) {
  return ref.watch(statsUiProvider.select((s) => s.weekStartsOnMonday));
});
