import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/category_l10n.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../../domain/models/budget.dart';
import '../../../domain/models/category.dart';
import '../../../domain/models/money_amount.dart';
import '../../../domain/services/budget_calculator.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class BudgetsPage extends ConsumerWidget {
  const BudgetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final month = ref.watch(budgetMonthProvider);
    final budgetsAsync = ref.watch(budgetsForMonthProvider(month));
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final responsive = Responsive.of(context);
    final locale = Localizations.localeOf(context).toString();
    final monthLabel = DateFormat.yMMMM(locale).format(
      BudgetCalculator.monthStart(month),
    );
    final columns = responsive.isDesktop ? 3 : (responsive.isTablet ? 2 : 1);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.budgets)),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addBudget,
        onPressed: () => context.push('/more/budgets/add?month=$month'),
        child: const Icon(Icons.add),
      ),
      body: Align(
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
                child: _MonthSelector(label: monthLabel),
              ),
              Expanded(
                child: budgetsAsync.when(
                  loading: () => LoadingState(message: l10n.loading),
                  error: (error, stackTrace) =>
                      AsyncErrorView(error: error, stackTrace: stackTrace),
                  data: (items) {
                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                        responsive.pagePadding,
                        AppSpacing.lg,
                        responsive.pagePadding,
                        responsive.isMobile ? 88 : AppSpacing.xxl,
                      ),
                      children: [
                        if (items.isEmpty)
                          SizedBox(
                            height: 360,
                            child: EmptyState(
                              icon: Icons.savings_outlined,
                              title: l10n.budgets,
                              message: l10n.emptyBudgets,
                              actionLabel: l10n.addBudget,
                              onAction: () => context.push(
                                '/more/budgets/add?month=$month',
                              ),
                            ),
                          )
                        else
                          ResponsiveGrid(
                            columns: columns,
                            spacing: AppSpacing.md,
                            runSpacing: AppSpacing.md,
                            children: [
                              for (final item in items)
                                BudgetProgressCard(
                                  title: budgetDisplayTitle(
                                    l10n,
                                    item.budget,
                                    categories,
                                  ),
                                  subtitle: _subtitle(
                                    l10n,
                                    item.budget,
                                    categories,
                                  ),
                                  progress: item.progress,
                                  currencyCode: item.budget.currency,
                                  statusLabel: _statusLabel(
                                    l10n,
                                    item.progress,
                                  ),
                                  onTap: () => context.push(
                                    '/more/budgets/edit/${item.budget.id}',
                                  ),
                                ),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _subtitle(
    AppLocalizations l10n,
    Budget budget,
    List<Category> categories,
  ) {
    final named = budget.name != null && budget.name!.trim().isNotEmpty;
    if (!named) {
      if (budget.walletIds.isEmpty) return l10n.allWallets;
      return null;
    }
    if (budget.categoryId == null) return l10n.overallBudget;
    final category = categories
        .where((item) => item.id == budget.categoryId)
        .firstOrNull;
    return category == null
        ? l10n.overallBudget
        : localizedCategoryName(l10n, category);
  }

  String? _statusLabel(AppLocalizations l10n, BudgetProgress progress) {
    return switch (progress.status) {
      BudgetStatus.under75 => null,
      BudgetStatus.warning75 => l10n.budgetAlmostUsed,
      BudgetStatus.over => l10n.budgetExceeded,
    };
  }
}

class _MonthSelector extends ConsumerWidget {
  const _MonthSelector({required this.label});

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          tooltip: l10n.previousMonth,
          onPressed: () => ref.read(budgetMonthProvider.notifier).shift(-1),
          icon: const Icon(Icons.arrow_back),
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
        ),
        IconButton(
          tooltip: l10n.nextMonth,
          onPressed: () => ref.read(budgetMonthProvider.notifier).shift(1),
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}

String budgetDisplayTitle(
  AppLocalizations l10n,
  Budget budget,
  List<Category> categories,
) {
  final name = budget.name?.trim();
  if (name != null && name.isNotEmpty) return name;
  if (budget.categoryId == null) return l10n.overallBudget;
  final category = categories
      .where((item) => item.id == budget.categoryId)
      .firstOrNull;
  if (category == null) return l10n.overallBudget;
  return localizedCategoryName(l10n, category);
}

Color budgetStatusColor(FinanceColors finance, BudgetStatus status) {
  return switch (status) {
    BudgetStatus.under75 => finance.income,
    BudgetStatus.warning75 => finance.chartColorAt(3),
    BudgetStatus.over => finance.expense,
  };
}

class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.currencyCode,
    this.subtitle,
    this.statusLabel,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final BudgetProgress progress;
  final String currencyCode;
  final String? statusLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final color = budgetStatusColor(finance, progress.status);
    final percent = (progress.ratio * 100).round().clamp(0, 999);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '$percent%',
                    style: theme.textTheme.labelLarge?.copyWith(color: color),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: finance.mutedText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (statusLabel != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    statusLabel!,
                    style: theme.textTheme.labelMedium?.copyWith(color: color),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: progress.ratio.isFinite
                      ? progress.ratio.clamp(0, 1).toDouble()
                      : 0,
                  backgroundColor: theme.colorScheme.outlineVariant,
                  color: color,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _MoneyLine(
                label: l10n.spent,
                amount: progress.spent,
                currencyCode: currencyCode,
              ),
              const SizedBox(height: AppSpacing.xs),
              _MoneyLine(
                label: l10n.limit,
                amount: progress.limit,
                currencyCode: currencyCode,
              ),
              const SizedBox(height: AppSpacing.xs),
              _MoneyLine(
                label: l10n.remaining,
                amount: progress.remaining,
                currencyCode: currencyCode,
                colorize: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoneyLine extends StatelessWidget {
  const _MoneyLine({
    required this.label,
    required this.amount,
    required this.currencyCode,
    this.colorize = false,
  });

  final String label;
  final MoneyAmount amount;
  final String currencyCode;
  final bool colorize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: finance.mutedText,
            ),
          ),
        ),
        Flexible(
          child: MoneyText(
            amount,
            currencyCode: currencyCode,
            colorize: colorize,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
