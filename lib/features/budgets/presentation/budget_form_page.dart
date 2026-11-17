import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/currency/iso_currencies.dart';
import '../../../core/l10n/category_l10n.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/locale/locale_settings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/currency_picker_sheet.dart';
import '../../../core/widgets/form_page_body.dart';
import '../../../domain/enums/category_type.dart';
import '../../../domain/models/money_amount.dart';
import '../../../domain/services/budget_calculator.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class BudgetFormPage extends ConsumerStatefulWidget {
  const BudgetFormPage({super.key, this.budgetId, this.yearMonth});

  final String? budgetId;
  final int? yearMonth;

  @override
  ConsumerState<BudgetFormPage> createState() => _BudgetFormPageState();
}

class _BudgetFormPageState extends ConsumerState<BudgetFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _wallets = <String>{};
  String _categoryValue = '';
  String _currency = 'PKR';
  bool _rollover = false;
  bool _notify80 = true;
  bool _notifyOver = true;
  bool _loading = false;
  bool _initialized = false;
  bool _defaultsApplied = false;
  late int _yearMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _yearMonth =
        widget.yearMonth ?? now.year * 100 + now.month;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadIfNeeded() async {
    if (_initialized) return;
    if (!_defaultsApplied && widget.budgetId == null) {
      _defaultsApplied = true;
      _currency = ref.read(baseCurrencyProvider);
    }
    if (widget.budgetId == null) {
      _initialized = true;
      return;
    }
    _initialized = true;
    final budget =
        await ref.read(budgetRepositoryProvider).getById(widget.budgetId!);
    if (budget == null || !mounted) return;
    setState(() {
      _nameCtrl.text = budget.name ?? '';
      _categoryValue = budget.categoryId ?? '';
      _currency = budget.currency;
      _amountCtrl.text = MoneyFormatter(
        currencyCode: budget.currency,
      ).formatForInput(budget.amount);
      _wallets
        ..clear()
        ..addAll(budget.walletIds);
      _rollover = budget.rollover;
      _notify80 = budget.notify80;
      _notifyOver = budget.notifyOver;
      _yearMonth = budget.yearMonth;
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final categories = ref.read(categoriesProvider).value ?? const [];
      final expenseIds = categories
          .where((category) => category.type == CategoryType.expense)
          .map((category) => category.id)
          .toSet();
      final categoryId =
          expenseIds.contains(_categoryValue) ? _categoryValue : null;
      await ref.read(budgetRepositoryProvider).save(
            id: widget.budgetId,
            categoryId: categoryId,
            walletIds: _wallets.toList(),
            amount: MoneyAmount.fromMajorString(
              _amountCtrl.text,
              fractionDigits: IsoCurrencies.decimalDigits(_currency),
            ),
            currency: _currency,
            yearMonth: _yearMonth,
            rollover: _rollover,
            notify80: _notify80,
            notifyOver: _notifyOver,
            name: _nameCtrl.text,
          );
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final wallets = ref.watch(walletsProvider).value ?? const [];
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final expenseCategories = categories
        .where((category) => category.type == CategoryType.expense)
        .toList();
    final categoryValue = expenseCategories.any((c) => c.id == _categoryValue)
        ? _categoryValue
        : '';
    final locale = Localizations.localeOf(context).toString();
    final monthLabel = DateFormat.yMMMM(locale).format(
      BudgetCalculator.monthStart(_yearMonth),
    );
    _loadIfNeeded();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.budgetId == null ? l10n.addBudget : l10n.editBudget,
        ),
        actions: [
          if (widget.budgetId != null)
            IconButton(
              tooltip: l10n.deleteBudget,
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await confirmDelete(
                  context,
                  message: l10n.confirmDelete,
                );
                if (!ok || !mounted) return;
                await ref
                    .read(budgetRepositoryProvider)
                    .delete(widget.budgetId!);
                if (context.mounted) context.pop();
              },
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: FormPageBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.budgetNameOptional,
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              InputDecorator(
                decoration: InputDecoration(labelText: l10n.date),
                child: Text(monthLabel),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                key: ValueKey('category-$categoryValue'),
                initialValue: categoryValue,
                decoration: InputDecoration(labelText: l10n.category),
                items: [
                  DropdownMenuItem(
                    value: '',
                    child: Text(l10n.overallBudget),
                  ),
                  for (final category in expenseCategories)
                    DropdownMenuItem(
                      value: category.id,
                      child: Text(localizedCategoryName(l10n, category)),
                    ),
                ],
                onChanged: (value) {
                  setState(() => _categoryValue = value ?? '');
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.selectWallets,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _wallets.isEmpty ? l10n.allWalletsHint : l10n.allWallets,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: finance.mutedText,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final wallet in wallets)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _wallets.contains(wallet.id),
                  title: Text(wallet.name),
                  subtitle: Text(wallet.currency),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _wallets.add(wallet.id);
                      } else {
                        _wallets.remove(wallet.id);
                      }
                    });
                  },
                ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.amount),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.fieldRequired;
                  }
                  final parsed = MoneyAmount.fromMajorString(
                    value,
                    fractionDigits: IsoCurrencies.decimalDigits(_currency),
                  );
                  if (parsed.minorUnits <= 0) {
                    return l10n.amountMustBePositive;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.currency),
                subtitle: Text(_currencyLabel(_currency)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final code = await showCurrencyPicker(
                    context,
                    selectedCode: _currency,
                  );
                  if (code != null) setState(() => _currency = code);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.rollover),
                subtitle: Text(l10n.rolloverSubtitle),
                value: _rollover,
                onChanged: (value) => setState(() => _rollover = value),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.notify80),
                value: _notify80,
                onChanged: (value) => setState(() => _notify80 = value),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.notifyOver),
                value: _notifyOver,
                onChanged: (value) => setState(() => _notifyOver = value),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _loading ? null : _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(kMinTouchTarget),
                ),
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _currencyLabel(String code) {
    final info = IsoCurrencies.byCode(code);
    if (info == null) return code;
    return '${info.code} — ${info.name}';
  }
}
