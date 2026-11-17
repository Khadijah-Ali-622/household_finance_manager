import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/default_categories.dart';
import '../../../core/l10n/category_l10n.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../domain/enums/transaction_type.dart';
import '../../../l10n/app_localizations.dart';
import '../../budgets/presentation/budget_home_summary.dart';
import '../../providers.dart';
import '../../reminders/presentation/home_due_section.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dashAsync = ref.watch(dashboardProvider);
    final categories = ref.watch(categoriesProvider).value ?? [];
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDashboard)),
      body: dashAsync.when(
        loading: () => LoadingState(message: l10n.loading),
        error: (e, st) => AsyncErrorView(error: e, stackTrace: st),
        data: (dash) {
          final baseCode = dash.baseCurrency;
          final baseMoney = MoneyFormatter(
            currencyCode: baseCode,
            locale: Localizations.localeOf(context).toString(),
            useNativeDigits: ref.watch(nativeDigitsProvider),
          );
          return ResponsiveBuilder(
            builder: (context, responsive) {
              final pad = EdgeInsets.fromLTRB(
                responsive.pagePadding,
                AppSpacing.sm,
                responsive.pagePadding,
                responsive.isMobile ? AppSpacing.xxl : AppSpacing.xxl,
              );
              final summaryCards = [
                _SummaryCard(
                  title: l10n.totalBalance,
                  child: MoneyText(
                    dash.totalBalance,
                    currencyCode: baseCode,
                    style: theme.textTheme.displayLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
                _SummaryCard(
                  title: l10n.thisMonthIncome,
                  indicatorColor: finance.income,
                  child: MoneyText(
                    dash.monthIncome,
                    currencyCode: baseCode,
                    colorize: true,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.start,
                  ),
                ),
                _SummaryCard(
                  title: l10n.thisMonthExpense,
                  indicatorColor: finance.expense,
                  child: MoneyText(
                    dash.monthExpense,
                    currencyCode: baseCode,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: finance.expense,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                _SummaryCard(
                  title: l10n.netWorth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MoneyText(
                        dash.netWorth,
                        currencyCode: baseCode,
                        style: theme.textTheme.headlineMedium,
                        colorize: true,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${l10n.assets}: ${baseMoney.format(dash.totalAssets)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: finance.mutedText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${l10n.liabilities}: ${baseMoney.format(dash.totalLiabilities)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: finance.mutedText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ];

              final walletTiles = dash.wallets.map((w) {
                final walletColor = Color(w.color);
                return Material(
                  color: theme.colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    side: BorderSide(color: theme.colorScheme.outline),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.go('/wallets'),
                    hoverColor: finance.hoverOverlay,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.card,
                        vertical: AppSpacing.md,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: walletColor.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              iconFromKey(w.icon),
                              color: walletColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              w.name,
                              style: theme.textTheme.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                MoneyText(
                                  w.balance,
                                  currencyCode: w.currency,
                                ),
                                if (w.currency != baseCode)
                                  Text(
                                    l10n.convertedApprox(
                                      baseMoney.format(
                                        ref
                                                .watch(
                                                  currencyConverterProvider,
                                                )
                                                .value
                                                ?.toBase(
                                                  w.balance,
                                                  w.currency,
                                                ) ??
                                            w.balance,
                                      ),
                                    ),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: finance.mutedText,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList();

              final charts = [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.incomeVsExpense,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _IncomeExpenseBarChart(
                      months: dash.monthlyIncomeExpense,
                      currencyCode: baseCode,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.topCategories,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (dash.topCategories.isEmpty)
                      Text(
                        l10n.emptyTransactions,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: finance.mutedText,
                        ),
                      )
                    else
                      _CategoryPieChart(
                        spends: dash.topCategories,
                        categoryNames: {
                          for (final c in categories)
                            c.id: localizedCategoryName(l10n, c),
                        },
                      ),
                  ],
                ),
              ];

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
                  child: ListView(
                    padding: pad,
                    children: [
                      ResponsiveGrid(
                        columns: responsive.isDesktop
                            ? 4
                            : responsive.isTablet
                                ? 2
                                : 1,
                        children: summaryCards,
                      ),
                      const SizedBox(height: AppSpacing.section),
                      const HomeDueSection(),
                      const SizedBox(height: AppSpacing.section),
                      const BudgetHomeSummary(),
                      const SizedBox(height: AppSpacing.section),
                      Text(
                        l10n.walletBreakdown,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ResponsiveGrid(
                        columns: responsive.gridColumns,
                        children: walletTiles,
                      ),
                      const SizedBox(height: AppSpacing.section),
                      if (responsive.isWide)
                        ResponsiveGrid(columns: 2, children: charts)
                      else ...[
                        charts[0],
                        const SizedBox(height: AppSpacing.section),
                        charts[1],
                      ],
                      const SizedBox(height: AppSpacing.section),
                      Text(
                        l10n.recentTransactions,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...dash.recentTransactions.map((tx) {
                        final cat = categories
                            .where((c) => c.id == tx.categoryId)
                            .firstOrNull;
                        final fromWallet = dash.wallets
                            .where((w) => w.id == tx.walletId)
                            .firstOrNull;
                        final toWallet = dash.wallets
                            .where((w) => w.id == tx.toWalletId)
                            .firstOrNull;
                        final title = switch (tx.type) {
                          TxType.transfer =>
                            '${fromWallet?.name ?? l10n.fromWallet} → ${toWallet?.name ?? l10n.toWallet}',
                          _ =>
                            cat == null
                                ? tx.type.label
                                : localizedCategoryName(l10n, cat),
                        };
                        final amountCurrency = fromWallet?.currency ?? baseCode;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 12,
                          title: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: SizedBox(
                            width: responsive.isMobile ? 110 : 140,
                            child: tx.type == TxType.transfer
                                ? MoneyText(
                                    tx.amount,
                                    currencyCode: amountCurrency,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: finance.transfer,
                                    ),
                                  )
                                : MoneyText(
                                    tx.type == TxType.expense
                                        ? -tx.amount
                                        : tx.amount,
                                    currencyCode: amountCurrency,
                                    colorize: true,
                                  ),
                          ),
                          onTap: () =>
                              context.push('/transactions/edit/${tx.id}'),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _IncomeExpenseBarChart extends ConsumerWidget {
  const _IncomeExpenseBarChart({
    required this.months,
    required this.currencyCode,
  });

  final List<MonthIncomeExpense> months;
  final String currencyCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final l10n = AppLocalizations.of(context);
    final incomeColor = finance.income;
    final expenseColor = finance.expense;
    final monthFmt = DateFormat('MMM');
    final money = MoneyFormatter(
      currencyCode: currencyCode,
      locale: Localizations.localeOf(context).toString(),
      useNativeDigits: ref.watch(nativeDigitsProvider),
    );

    var maxY = 0.0;
    for (final m in months) {
      if (m.income.asMajor > maxY) maxY = m.income.asMajor;
      if (m.expense.asMajor > maxY) maxY = m.expense.asMajor;
    }
    if (maxY <= 0) maxY = 1;

    return SizedBox(
      height: 240,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: BarChart(
            BarChartData(
              maxY: maxY * 1.15,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    if (groupIndex < 0 || groupIndex >= months.length) {
                      return null;
                    }
                    final m = months[groupIndex];
                    final label = monthFmt.format(DateTime(m.year, m.month));
                    final value = rodIndex == 0 ? m.income : m.expense;
                    final kind = rodIndex == 0 ? l10n.income : l10n.expense;
                    return BarTooltipItem(
                      '$label · $kind\n${money.format(value)}',
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
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value == meta.max) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        value >= 1000
                            ? '${(value / 1000).toStringAsFixed(0)}k'
                            : value.toStringAsFixed(0),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: finance.mutedText,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= months.length) {
                        return const SizedBox.shrink();
                      }
                      final m = months[i];
                      final label = monthFmt.format(DateTime(m.year, m.month));
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: finance.mutedText,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: finance.gridLine, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                for (var i = 0; i < months.length; i++)
                  BarChartGroupData(
                    x: i,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: months[i].income.asMajor,
                        color: incomeColor,
                        width: 8,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(3),
                        ),
                      ),
                      BarChartRodData(
                        toY: months[i].expense.asMajor,
                        color: expenseColor,
                        width: 8,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(3),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPieChart extends StatelessWidget {
  const _CategoryPieChart({required this.spends, required this.categoryNames});

  final List<CategorySpend> spends;
  final Map<String, String> categoryNames;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.card),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 36,
                  sections: [
                    for (var i = 0; i < spends.length; i++)
                      PieChartSectionData(
                        value: spends[i].amount.asMajor,
                        title: '',
                        radius: 52,
                        color: finance.chartColorAt(i),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                for (var i = 0; i < spends.length; i++)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: finance.chartColorAt(i),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        categoryNames[spends[i].categoryId] ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: finance.mutedText,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.child,
    this.indicatorColor,
  });

  final String title;
  final Widget child;
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (indicatorColor != null) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: indicatorColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: finance.mutedText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}
