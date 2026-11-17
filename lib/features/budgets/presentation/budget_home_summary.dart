import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/services/budget_calculator.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';
import 'budgets_page.dart';

/// Top budgets for the current month. Drop this onto the dashboard.
class BudgetHomeSummary extends ConsumerWidget {
  const BudgetHomeSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final month = BudgetCalculator.yearMonthOf(DateTime.now());
    final budgetsAsync = ref.watch(budgetsForMonthProvider(month));
    final categories = ref.watch(categoriesProvider).value ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.budgets,
                style: theme.textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/more/budgets'),
              child: Text(l10n.viewBudgets),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        budgetsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => Text(
            l10n.errorGeneric,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return Text(
                l10n.emptyBudgets,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: finance.mutedText,
                ),
              );
            }
            final top = items.take(3);
            return Column(
              children: [
                for (final item in top) ...[
                  BudgetProgressCard(
                    title: budgetDisplayTitle(l10n, item.budget, categories),
                    progress: item.progress,
                    currencyCode: item.budget.currency,
                    statusLabel: switch (item.progress.status) {
                      BudgetStatus.under75 => null,
                      BudgetStatus.warning75 => l10n.budgetAlmostUsed,
                      BudgetStatus.over => l10n.budgetExceeded,
                    },
                    onTap: () => context.push(
                      '/more/budgets/edit/${item.budget.id}',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
