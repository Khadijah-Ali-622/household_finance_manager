import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/default_categories.dart';
import '../../../core/currency/iso_currencies.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../core/utils/uuid.dart';
import '../../../core/widgets/adaptive_modal.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../../data/db/daos/transactions_dao.dart';
import '../../../domain/enums/stats_period_kind.dart';
import '../../../domain/enums/transaction_type.dart';
import '../../../domain/models/money_amount.dart';
import '../../../domain/models/stats_models.dart';
import '../../../domain/models/wallet.dart';
import '../../../domain/services/stats_aggregator.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../stats_state.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ui = ref.watch(statsUiProvider);
    final snapshotAsync = ref.watch(statsSnapshotProvider);
    final theme = Theme.of(context);
    const agg = StatsAggregator();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navStats),
        actions: [
          IconButton(
            tooltip: l10n.walletFilter,
            icon: const Icon(Icons.account_balance_wallet_outlined),
            onPressed: () => _openWalletFilter(context, ref),
          ),
        ],
      ),
      body: ResponsiveBuilder(
        builder: (context, responsive) {
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
              child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              responsive.pagePadding,
              AppSpacing.sm,
              responsive.pagePadding,
              0,
            ),
            child: _PeriodHeader(
              label: agg.formatPeriodLabel(ui.range, ui.periodKind),
              kind: ui.periodKind,
              kindLabels: {
                for (final k in StatsPeriodKind.values)
                  k: _periodKindLabel(l10n, k),
              },
              onPrev: ui.periodKind == StatsPeriodKind.custom
                  ? null
                  : () => ref.read(statsUiProvider.notifier).shift(-1),
              onNext: ui.periodKind == StatsPeriodKind.custom
                  ? null
                  : () => ref.read(statsUiProvider.notifier).shift(1),
              onKindChanged: (kind) async {
                if (kind == StatsPeriodKind.custom) {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDateRange: DateTimeRange(
                      start: ui.customStart ?? ui.range.start,
                      end: ui.customEnd ??
                          DateTime(
                            ui.range.end.year,
                            ui.range.end.month,
                            ui.range.end.day,
                          ),
                    ),
                  );
                  if (picked != null) {
                    ref
                        .read(statsUiProvider.notifier)
                        .setCustomRange(picked.start, picked.end);
                  }
                } else {
                  ref.read(statsUiProvider.notifier).setPeriodKind(kind);
                }
              },
              onLabelTap: ui.periodKind == StatsPeriodKind.custom
                  ? () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        initialDateRange: DateTimeRange(
                          start: ui.range.start,
                          end: DateTime(
                            ui.range.end.year,
                            ui.range.end.month,
                            ui.range.end.day,
                          ),
                        ),
                      );
                      if (picked != null) {
                        ref
                            .read(statsUiProvider.notifier)
                            .setCustomRange(picked.start, picked.end);
                      }
                    }
                  : null,
            ),
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => LoadingState(message: l10n.loading),
              error: (e, st) => AsyncErrorView(error: e, stackTrace: st),
              data: (snap) {
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    _IncomeExpenseTabs(
                      income: snap.incomeTotal,
                      expense: snap.expenseTotal,
                      currencyCode: snap.baseCurrency,
                      selected: ui.flow,
                      onChanged: (f) =>
                          ref.read(statsUiProvider.notifier).setFlow(f),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        responsive.pagePadding,
                        AppSpacing.md,
                        responsive.pagePadding,
                        0,
                      ),
                      child: SegmentedButton<StatsChartType>(
                        segments: [
                          ButtonSegment(
                            value: StatsChartType.pie,
                            label: Text(l10n.pieChart),
                            icon: const Icon(Icons.pie_chart_outline, size: 18),
                          ),
                          ButtonSegment(
                            value: StatsChartType.bar,
                            label: Text(l10n.barChart),
                            icon: const Icon(Icons.bar_chart, size: 18),
                          ),
                        ],
                        selected: {ui.chartType},
                        onSelectionChanged: (s) {
                          ref
                              .read(statsUiProvider.notifier)
                              .setChartType(s.first);
                        },
                      ),
                    ),
                    Expanded(
                      child: snap.breakdown.isEmpty
                          ? EmptyState(
                              icon: Icons.insights_outlined,
                              title: l10n.navStats,
                              message: l10n.emptyStats,
                            )
                          : ListView(
                              padding: EdgeInsets.fromLTRB(
                                responsive.pagePadding,
                                AppSpacing.md,
                                responsive.pagePadding,
                                AppSpacing.xxl,
                              ),
                              children: [
                                if (responsive.isWide)
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 280,
                                            child: Card(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  AppSpacing.card,
                                                ),
                                                child: ui.chartType ==
                                                        StatsChartType.pie
                                                    ? _StatsPieChart(
                                                        slices: snap
                                                            .breakdown.slices,
                                                      )
                                                    : _StatsBarChart(
                                                        bars: snap
                                                            .breakdown.bars,
                                                        flow: ui.flow,
                                                        currencyCode:
                                                            snap.baseCurrency,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.lg),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                l10n.categories,
                                                style: theme
                                                    .textTheme.titleMedium,
                                              ),
                                              const SizedBox(
                                                height: AppSpacing.sm,
                                              ),
                                              ...snap.breakdown.slices
                                                  .map(
                                                (slice) => _StatsCategoryTile(
                                                  slice: slice,
                                                  baseCurrency:
                                                      snap.baseCurrency,
                                                  onTap: slice.isOther ||
                                                          slice.categoryId ==
                                                              null
                                                      ? null
                                                      : () =>
                                                          _openCategoryTransactions(
                                                            context,
                                                            ref,
                                                            slice: slice,
                                                            ui: ui,
                                                          ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else ...[
                                  SizedBox(
                                    height: 260,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                          AppSpacing.card,
                                        ),
                                        child: ui.chartType ==
                                                StatsChartType.pie
                                            ? _StatsPieChart(
                                                slices:
                                                    snap.breakdown.slices,
                                              )
                                            : _StatsBarChart(
                                                bars: snap.breakdown.bars,
                                                flow: ui.flow,
                                                currencyCode:
                                                    snap.baseCurrency,
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  Text(
                                    l10n.categories,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  ...snap.breakdown.slices.map(
                                    (slice) => _StatsCategoryTile(
                                      slice: slice,
                                      baseCurrency: snap.baseCurrency,
                                      onTap: slice.isOther ||
                                              slice.categoryId == null
                                          ? null
                                          : () => _openCategoryTransactions(
                                                context,
                                                ref,
                                                slice: slice,
                                                ui: ui,
                                              ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _periodKindLabel(AppLocalizations l10n, StatsPeriodKind kind) {
    return switch (kind) {
      StatsPeriodKind.weekly => l10n.periodWeekly,
      StatsPeriodKind.monthly => l10n.periodMonthly,
      StatsPeriodKind.annually => l10n.periodAnnually,
      StatsPeriodKind.custom => l10n.periodCustom,
    };
  }

  void _openCategoryTransactions(
    BuildContext context,
    WidgetRef ref, {
    required StatsCategorySlice slice,
    required StatsUiState ui,
  }) {
    final walletIds = ui.walletIds;
    ref.read(transactionFilterProvider.notifier).update(
          TransactionFilter(
            walletId: walletIds != null && walletIds.length == 1
                ? walletIds.first
                : null,
            categoryId: slice.categoryId,
            type: ui.flow == StatsFlow.income
                ? TxType.income.storageValue
                : TxType.expense.storageValue,
            fromDate: toMillis(ui.range.start),
            toDate: toMillis(ui.range.end),
          ),
        );
    context.go('/transactions');
  }

  Future<void> _openWalletFilter(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final wallets = ref.read(walletsProvider).value ?? [];
    final groups = ref.read(walletGroupsProvider).value ?? [];
    final current = ref.read(statsUiProvider).walletScope;

    await showAdaptiveModal<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(l10n.allWallets),
                leading: const Icon(Icons.select_all),
                selected: current is StatsWalletAll,
                onTap: () {
                  ref
                      .read(statsUiProvider.notifier)
                      .setWalletScope(const StatsWalletAll());
                  Navigator.pop(ctx);
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(l10n.selectWallets,
                    style: Theme.of(ctx).textTheme.titleSmall),
              ),
              ...wallets.map((w) {
                final selected = current is StatsWalletSelected &&
                    current.walletIds.length == 1 &&
                    current.walletIds.contains(w.id);
                return ListTile(
                  leading: Icon(iconFromKey(w.icon), color: Color(w.color)),
                  title: Text(w.name),
                  selected: selected,
                  onTap: () {
                    ref.read(statsUiProvider.notifier).setWalletScope(
                          StatsWalletSelected({w.id}),
                        );
                    Navigator.pop(ctx);
                  },
                );
              }),
              ListTile(
                leading: const Icon(Icons.checklist),
                title: Text(l10n.selectedWallets),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickMultipleWallets(context, ref, wallets);
                },
              ),
              if (groups.isNotEmpty) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(l10n.walletGroups,
                      style: Theme.of(ctx).textTheme.titleSmall),
                ),
                ...groups.map((g) {
                  final selected = current is StatsWalletGroupScope &&
                      current.groupId == g.id;
                  return ListTile(
                    leading: const Icon(Icons.layers_outlined),
                    title: Text(g.name),
                    selected: selected,
                    onTap: () {
                      ref.read(statsUiProvider.notifier).setWalletScope(
                            StatsWalletGroupScope(g.id, g.walletIds.toSet()),
                          );
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMultipleWallets(
    BuildContext context,
    WidgetRef ref,
    List<Wallet> wallets,
  ) async {
    final l10n = AppLocalizations.of(context);
    final scope = ref.read(statsUiProvider).walletScope;
    final selected = <String>{
      if (scope is StatsWalletSelected) ...scope.walletIds,
      if (scope is StatsWalletGroupScope) ...scope.walletIds,
    };

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            return AlertDialog(
              title: Text(l10n.selectWallets),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final w in wallets)
                      CheckboxListTile(
                        value: selected.contains(w.id),
                        title: Text(w.name),
                        onChanged: (v) {
                          setModal(() {
                            if (v == true) {
                              selected.add(w.id);
                            } else {
                              selected.remove(w.id);
                            }
                          });
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    if (selected.isEmpty) {
                      ref
                          .read(statsUiProvider.notifier)
                          .setWalletScope(const StatsWalletAll());
                    } else {
                      ref.read(statsUiProvider.notifier).setWalletScope(
                            StatsWalletSelected(Set.of(selected)),
                          );
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _PeriodHeader extends StatelessWidget {
  const _PeriodHeader({
    required this.label,
    required this.kind,
    required this.kindLabels,
    required this.onPrev,
    required this.onNext,
    required this.onKindChanged,
    this.onLabelTap,
  });

  final String label;
  final StatsPeriodKind kind;
  final Map<StatsPeriodKind, String> kindLabels;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final ValueChanged<StatsPeriodKind> onKindChanged;
  final VoidCallback? onLabelTap;

  @override
  Widget build(BuildContext context) {
    final narrow = Responsive.of(context).isMobile;
    final nav = Row(
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left),
          constraints: const BoxConstraints(
            minWidth: kMinTouchTarget,
            minHeight: kMinTouchTarget,
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onLabelTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          constraints: const BoxConstraints(
            minWidth: kMinTouchTarget,
            minHeight: kMinTouchTarget,
          ),
        ),
      ],
    );

    final kindDropdown = DropdownButtonHideUnderline(
      child: DropdownButton<StatsPeriodKind>(
        value: kind,
        isExpanded: narrow,
        items: [
          for (final entry in kindLabels.entries)
            DropdownMenuItem(value: entry.key, child: Text(entry.value)),
        ],
        onChanged: (v) {
          if (v != null) onKindChanged(v);
        },
      ),
    );

    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          nav,
          Align(alignment: Alignment.center, child: kindDropdown),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: nav),
        kindDropdown,
        const SizedBox(width: 4),
      ],
    );
  }
}

class _StatsCategoryTile extends StatelessWidget {
  const _StatsCategoryTile({
    required this.slice,
    required this.baseCurrency,
    this.onTap,
  });

  final StatsCategorySlice slice;
  final String baseCurrency;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final color = finance.chartColorAt(slice.colorIndex);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        child: ListTile(
          minVerticalPadding: 12,
          leading: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${slice.percent}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: finance.chartLabel,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Row(
            children: [
              Icon(
                iconFromKey(slice.icon),
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  slice.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: SizedBox(
            width: 110,
            child: MoneyText(slice.amount, currencyCode: baseCurrency),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _IncomeExpenseTabs extends StatelessWidget {
  const _IncomeExpenseTabs({
    required this.income,
    required this.expense,
    required this.currencyCode,
    required this.selected,
    required this.onChanged,
  });

  final MoneyAmount income;
  final MoneyAmount expense;
  final String currencyCode;
  final StatsFlow selected;
  final ValueChanged<StatsFlow> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final l10n = AppLocalizations.of(context);
    final fmt = MoneyFormatter(
      currencyCode: currencyCode,
      locale: Localizations.localeOf(context).toString(),
    );
    final pad = Responsive.of(context).pagePadding;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pad),
      child: Row(
        children: [
          Expanded(
            child: _FlowTab(
              title: l10n.income,
              amount: fmt.format(income),
              selected: selected == StatsFlow.income,
              onTap: () => onChanged(StatsFlow.income),
              textStyle: theme.textTheme.titleSmall,
              mutedColor: finance.mutedText,
              selectedColor: theme.colorScheme.primary,
            ),
          ),
          Expanded(
            child: _FlowTab(
              title: l10n.expense,
              amount: fmt.format(expense),
              selected: selected == StatsFlow.expense,
              onTap: () => onChanged(StatsFlow.expense),
              textStyle: theme.textTheme.titleSmall,
              mutedColor: finance.mutedText,
              selectedColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowTab extends StatelessWidget {
  const _FlowTab({
    required this.title,
    required this.amount,
    required this.selected,
    required this.onTap,
    required this.textStyle,
    required this.mutedColor,
    required this.selectedColor,
  });

  final String title;
  final String amount;
  final bool selected;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final Color mutedColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kMinTouchTarget),
        child: AnimatedContainer(
          duration: AppSpacing.animFast,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                  horizontal: AppSpacing.sm,
                ),
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle?.copyWith(
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected ? selectedColor : mutedColor,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        amount,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: textStyle?.copyWith(
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? selectedColor : mutedColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: AppSpacing.animFast,
                height: 3,
                decoration: BoxDecoration(
                  color: selected ? selectedColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsPieChart extends StatelessWidget {
  const _StatsPieChart({required this.slices});

  final List<StatsCategorySlice> slices;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: [
                for (var i = 0; i < slices.length; i++)
                  PieChartSectionData(
                    value: slices[i].amount.minorUnits.toDouble(),
                    title: '${slices[i].percent}%',
                    radius: 58,
                    titleStyle: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: finance.chartLabel,
                    ),
                    titlePositionPercentageOffset: 0.55,
                    color: finance.chartColorAt(slices[i].colorIndex),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          alignment: WrapAlignment.center,
          children: [
            for (var i = 0; i < slices.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: finance.chartColorAt(slices[i].colorIndex),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    slices[i].name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: finance.mutedText,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _StatsBarChart extends StatelessWidget {
  const _StatsBarChart({
    required this.bars,
    required this.flow,
    required this.currencyCode,
  });

  final List<StatsBarBucket> bars;
  final StatsFlow flow;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final barColor =
        flow == StatsFlow.income ? finance.income : finance.expense;
    final fmt = MoneyFormatter(
      currencyCode: currencyCode,
      locale: Localizations.localeOf(context).toString(),
    );
    final tipDateFmt = DateFormat('d MMM yyyy');
    final digits = IsoCurrencies.decimalDigits(currencyCode);

    var maxY = 0.0;
    for (final b in bars) {
      final v = b.amount.toMajor(digits);
      if (v > maxY) maxY = v;
    }
    if (maxY <= 0) maxY = 1;

    return BarChart(
      BarChartData(
        maxY: maxY * 1.15,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (groupIndex < 0 || groupIndex >= bars.length) return null;
              final b = bars[groupIndex];
              final dateLabel = tipDateFmt.format(b.start);
              return BarTooltipItem(
                '$dateLabel\n${fmt.format(b.amount)}',
                TextStyle(
                  color: theme.colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= bars.length) return const SizedBox.shrink();
                // Avoid overcrowding labels on long months.
                if (bars.length > 16 && i % 3 != 0 && i != bars.length - 1) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    bars[i].label,
                    style: theme.textTheme.labelSmall,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: finance.gridLine,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (var i = 0; i < bars.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: bars[i].amount.toMajor(digits),
                  color: barColor,
                  width: bars.length > 20 ? 4 : 10,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(3),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
