import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/default_categories.dart';
import '../../../core/l10n/category_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../domain/enums/category_type.dart';
import '../../../domain/models/category.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catsAsync = ref.watch(categoriesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categories)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: catsAsync.when(
        loading: () => LoadingState(message: l10n.loading),
        error: (e, st) => AsyncErrorView(error: e, stackTrace: st),
        data: (cats) {
          final expense = cats
              .where((c) => c.type == CategoryType.expense)
              .toList();
          final income = cats
              .where((c) => c.type == CategoryType.income)
              .toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.sm,
              AppSpacing.screen,
              88,
            ),
            children: [
              Text(l10n.expense, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ...expense.map((c) => _tile(context, l10n, c)),
              const SizedBox(height: AppSpacing.section),
              Text(l10n.income, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ...income.map((c) => _tile(context, l10n, c)),
            ],
          );
        },
      ),
    );
  }

  Widget _tile(BuildContext context, AppLocalizations l10n, Category c) {
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final color = Color(c.color);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconFromKey(c.icon), color: color, size: 22),
          ),
          title: Text(localizedCategoryName(l10n, c)),
          subtitle: Text(
            c.isDefault ? 'Default' : 'Custom',
            style: theme.textTheme.bodySmall?.copyWith(
              color: finance.mutedText,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final nameCtrl = TextEditingController();
    var type = CategoryType.expense;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.categories),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: l10n.name),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<CategoryType>(
              initialValue: type,
              items: [
                DropdownMenuItem(
                  value: CategoryType.expense,
                  child: Text(l10n.expense),
                ),
                DropdownMenuItem(
                  value: CategoryType.income,
                  child: Text(l10n.income),
                ),
              ],
              onChanged: (v) => type = v ?? CategoryType.expense,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (ok == true && nameCtrl.text.trim().isNotEmpty) {
      await ref
          .read(categoryRepositoryProvider)
          .save(
            name: nameCtrl.text,
            icon: 'more_horiz',
            color: 0xFF0D9488,
            type: type,
          );
    }
  }
}
