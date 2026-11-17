import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/currency/iso_currencies.dart';
import '../../../core/l10n/category_l10n.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/currency_picker_sheet.dart';
import '../../../core/widgets/form_page_body.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../domain/enums/category_type.dart';
import '../../../domain/enums/recurring_frequency.dart';
import '../../../domain/enums/recurring_mode.dart';
import '../../../domain/enums/recurring_template.dart';
import '../../../domain/enums/transaction_type.dart';
import '../../../domain/models/money_amount.dart';
import '../../../domain/models/wallet.dart';
import '../../../domain/services/recurring_generator.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class RecurringFormPage extends ConsumerStatefulWidget {
  const RecurringFormPage({super.key, this.ruleId});

  final String? ruleId;

  @override
  ConsumerState<RecurringFormPage> createState() => _RecurringFormPageState();
}

class _RecurringFormPageState extends ConsumerState<RecurringFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _receivedCtrl = TextEditingController();
  final _intervalCtrl = TextEditingController(text: '1');
  final _countCtrl = TextEditingController(text: '12');
  final _noteCtrl = TextEditingController();

  TxType _type = TxType.expense;
  RecurringFrequency _frequency = RecurringFrequency.monthly;
  RecurringMode _mode = RecurringMode.ask;
  RecurringTemplate _template = RecurringTemplate.standard;
  String? _customUnit = 'days';
  String? _walletId;
  String? _toWalletId;
  String? _categoryId;
  String? _paymentMethod = 'cash';
  String _currency = 'PKR';
  DateTime _start = RecurringGenerator.dateOnly(DateTime.now());
  DateTime? _end;
  bool _receivedEdited = false;
  bool _loading = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _receivedCtrl.dispose();
    _intervalCtrl.dispose();
    _countCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final wallets = await ref.read(allWalletsProvider.future);
    if (widget.ruleId == null) {
      final first = wallets.firstOrNull;
      if (mounted) {
        setState(() {
          _walletId = first?.id;
          _currency = first?.currency ?? 'PKR';
          _ready = true;
        });
      }
      return;
    }

    final rule = await ref
        .read(recurringRepositoryProvider)
        .getById(widget.ruleId!);
    if (!mounted) return;
    if (rule == null) {
      setState(() => _ready = true);
      return;
    }
    setState(() {
      _type = rule.type;
      _frequency = rule.frequency;
      _mode = rule.mode;
      _template = rule.templateType;
      _customUnit = rule.customUnit ?? 'days';
      _walletId = rule.walletId;
      _toWalletId = rule.toWalletId;
      _categoryId = rule.categoryId;
      _paymentMethod = rule.paymentMethod ?? 'cash';
      _currency = rule.currency;
      _start = rule.startDate;
      _end = rule.endDate;
      _intervalCtrl.text = rule.intervalN.toString();
      final count = rule.installmentCount;
      if (count != null) {
        _countCtrl.text = count.toString();
      }
      _amountCtrl.text = _formatMinor(rule.amount.minorUnits, rule.currency);
      if (rule.toAmount != null) {
        final to = wallets.where((w) => w.id == rule.toWalletId).firstOrNull;
        _receivedCtrl.text = _formatMinor(
          rule.toAmount!.minorUnits,
          to?.currency ?? rule.currency,
        );
        _receivedEdited = true;
      }
      _noteCtrl.text = rule.note ?? '';
      _ready = true;
    });
  }

  String _formatMinor(int minor, String currency) {
    final digits = IsoCurrencies.decimalDigits(currency);
    final factor = MoneyAmount.factor(digits);
    if (minor % factor == 0) return (minor ~/ factor).toString();
    return MoneyAmount(minor).toMajor(digits).toStringAsFixed(digits);
  }

  MoneyAmount? _parse(String raw, String currency) {
    final cleaned = raw.trim().replaceAll(',', '');
    if (cleaned.isEmpty) return null;
    return MoneyAmount.fromMajorString(
      cleaned,
      fractionDigits: IsoCurrencies.decimalDigits(currency),
    );
  }

  Future<void> _pickDate({required bool end}) async {
    final initial = end ? (_end ?? _start) : _start;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (end) {
        _end = RecurringGenerator.dateOnly(picked);
      } else {
        _start = RecurringGenerator.dateOnly(picked);
      }
    });
  }

  String _dateLabel(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> _save(List<Wallet> wallets) async {
    if (!_formKey.currentState!.validate()) return;
    final from = wallets.where((w) => w.id == _walletId).firstOrNull;
    final to = wallets.where((w) => w.id == _toWalletId).firstOrNull;
    if (from == null) return;

    final amount = _parse(_amountCtrl.text, _currency);
    if (amount == null) return;

    MoneyAmount? received;
    if (_type == TxType.transfer) {
      final raw =
          _receivedCtrl.text.trim().isEmpty && from.currency == to?.currency
          ? _amountCtrl.text
          : _receivedCtrl.text;
      received = _parse(raw, to?.currency ?? _currency);
    }

    setState(() => _loading = true);
    try {
      await ref
          .read(recurringRepositoryProvider)
          .save(
            id: widget.ruleId,
            walletId: from.id,
            type: _type,
            amount: amount,
            currency: _currency,
            toAmount: received,
            categoryId: _type == TxType.transfer ? null : _categoryId,
            toWalletId: _type == TxType.transfer ? _toWalletId : null,
            note: _noteCtrl.text,
            paymentMethod: _paymentMethod,
            frequency: _frequency,
            intervalN: int.tryParse(_intervalCtrl.text.trim()) ?? 1,
            customUnit: _customUnit,
            startDate: _start,
            endDate: _end,
            mode: _mode,
            templateType: _template,
            installmentCount: _template == RecurringTemplate.installment
                ? int.tryParse(_countCtrl.text.trim())
                : null,
          );
      if (mounted) context.pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wallets = ref.watch(allWalletsProvider).value ?? const <Wallet>[];
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final from = wallets.where((w) => w.id == _walletId).firstOrNull;
    final to = wallets.where((w) => w.id == _toWalletId).firstOrNull;
    final crossCurrency =
        _type == TxType.transfer &&
        from != null &&
        to != null &&
        from.currency != to.currency;
    final filtered = categories.where((c) {
      if (_type == TxType.income) return c.type == CategoryType.income;
      if (_type == TxType.expense) return c.type == CategoryType.expense;
      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ruleId == null ? l10n.addRecurring : l10n.editRecurring,
        ),
        actions: [
          if (widget.ruleId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await confirmDelete(context);
                if (!ok || !context.mounted) return;
                await ref
                    .read(recurringRepositoryProvider)
                    .delete(widget.ruleId!);
                if (context.mounted) context.pop();
              },
            ),
        ],
      ),
      body: !_ready
          ? LoadingState(message: l10n.loading)
          : Form(
              key: _formKey,
              child: FormPageBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<TxType>(
                      segments: [
                        ButtonSegment(
                          value: TxType.expense,
                          label: Text(l10n.expense),
                        ),
                        ButtonSegment(
                          value: TxType.income,
                          label: Text(l10n.income),
                        ),
                        ButtonSegment(
                          value: TxType.transfer,
                          label: Text(l10n.transfer),
                        ),
                      ],
                      selected: {_type},
                      onSelectionChanged: (value) => setState(() {
                        _type = value.first;
                        _categoryId = null;
                        _receivedEdited = false;
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: _type == TxType.transfer
                            ? l10n.amountSent
                            : l10n.amount,
                      ),
                      validator: (value) {
                        final parsed = _parse(value ?? '', _currency);
                        if (parsed == null) return l10n.fieldRequired;
                        if (parsed.minorUnits <= 0) {
                          return l10n.amountMustBePositive;
                        }
                        return null;
                      },
                      onChanged: (_) {
                        if (_type != TxType.transfer ||
                            _receivedEdited ||
                            from == null ||
                            to == null) {
                          return;
                        }
                        if (from.currency == to.currency) {
                          _receivedCtrl.text = _amountCtrl.text;
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      key: ValueKey('from-$_walletId'),
                      initialValue: wallets.any((w) => w.id == _walletId)
                          ? _walletId
                          : null,
                      decoration: InputDecoration(
                        labelText: _type == TxType.transfer
                            ? l10n.fromWallet
                            : l10n.wallets,
                      ),
                      items: [
                        for (final wallet in wallets)
                          DropdownMenuItem(
                            value: wallet.id,
                            child: Text('${wallet.name} (${wallet.currency})'),
                          ),
                      ],
                      onChanged: (value) {
                        final wallet = wallets
                            .where((w) => w.id == value)
                            .firstOrNull;
                        setState(() {
                          _walletId = value;
                          if (wallet != null) _currency = wallet.currency;
                          if (_toWalletId == value) _toWalletId = null;
                          _receivedEdited = false;
                        });
                      },
                      validator: (value) =>
                          value == null ? l10n.fieldRequired : null,
                    ),
                    if (_type == TxType.transfer) ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        key: ValueKey('to-$_toWalletId-$_walletId'),
                        initialValue: wallets.any((w) => w.id == _toWalletId)
                            ? _toWalletId
                            : null,
                        decoration: InputDecoration(labelText: l10n.toWallet),
                        items: [
                          for (final wallet in wallets)
                            if (wallet.id != _walletId)
                              DropdownMenuItem(
                                value: wallet.id,
                                child: Text(
                                  '${wallet.name} (${wallet.currency})',
                                ),
                              ),
                        ],
                        onChanged: (value) => setState(() {
                          _toWalletId = value;
                          _receivedEdited = false;
                          final target = wallets
                              .where((w) => w.id == value)
                              .firstOrNull;
                          if (from != null &&
                              target != null &&
                              from.currency == target.currency) {
                            _receivedCtrl.text = _amountCtrl.text;
                          }
                        }),
                        validator: (value) =>
                            value == null ? l10n.fieldRequired : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _receivedCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText:
                              '${l10n.amountReceived}${to != null ? ' (${to.currency})' : ''}',
                        ),
                        onChanged: (_) => _receivedEdited = true,
                        validator: (value) {
                          if (_type != TxType.transfer) return null;
                          final same =
                              from != null &&
                              to != null &&
                              from.currency == to.currency;
                          final raw =
                              (value == null || value.trim().isEmpty) && same
                              ? _amountCtrl.text
                              : (value ?? '');
                          final parsed = _parse(raw, to?.currency ?? _currency);
                          if (parsed == null || parsed.minorUnits <= 0) {
                            return crossCurrency
                                ? l10n.amountMustBePositive
                                : l10n.fieldRequired;
                          }
                          return null;
                        },
                      ),
                    ] else ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        key: ValueKey('cat-$_type-$_categoryId'),
                        initialValue: filtered.any((c) => c.id == _categoryId)
                            ? _categoryId
                            : null,
                        decoration: InputDecoration(labelText: l10n.category),
                        items: [
                          for (final category in filtered)
                            DropdownMenuItem(
                              value: category.id,
                              child: Text(
                                localizedCategoryName(l10n, category),
                              ),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => _categoryId = value),
                        validator: (value) =>
                            value == null ? l10n.fieldRequired : null,
                      ),
                    ],
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.currency),
                      subtitle: Text(_currency),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final code = await showCurrencyPicker(
                          context,
                          selectedCode: _currency,
                        );
                        if (code != null) setState(() => _currency = code);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<RecurringFrequency>(
                      key: ValueKey('freq-$_frequency'),
                      initialValue: _frequency,
                      decoration: InputDecoration(labelText: l10n.frequency),
                      items: [
                        DropdownMenuItem(
                          value: RecurringFrequency.daily,
                          child: Text(l10n.frequencyDaily),
                        ),
                        DropdownMenuItem(
                          value: RecurringFrequency.weekly,
                          child: Text(l10n.frequencyWeekly),
                        ),
                        DropdownMenuItem(
                          value: RecurringFrequency.monthly,
                          child: Text(l10n.frequencyMonthly),
                        ),
                        DropdownMenuItem(
                          value: RecurringFrequency.yearly,
                          child: Text(l10n.frequencyYearly),
                        ),
                        DropdownMenuItem(
                          value: RecurringFrequency.custom,
                          child: Text(l10n.frequencyCustom),
                        ),
                      ],
                      onChanged: (value) => setState(() {
                        _frequency = value ?? RecurringFrequency.monthly;
                      }),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _intervalCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.everyInterval,
                        suffixText: _unitLabel(l10n),
                      ),
                      validator: (value) {
                        final n = int.tryParse(value?.trim() ?? '');
                        if (n == null || n < 1) return l10n.fieldRequired;
                        return null;
                      },
                    ),
                    if (_frequency == RecurringFrequency.custom) ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        key: ValueKey('unit-$_customUnit'),
                        initialValue: _customUnit == 'months'
                            ? 'months'
                            : 'days',
                        decoration: InputDecoration(labelText: l10n.customUnit),
                        items: [
                          DropdownMenuItem(
                            value: 'days',
                            child: Text(l10n.unitDays),
                          ),
                          DropdownMenuItem(
                            value: 'months',
                            child: Text(l10n.unitMonths),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _customUnit = value ?? 'days'),
                      ),
                    ],
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.startDate),
                      subtitle: Text(_dateLabel(_start)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _pickDate(end: false),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.endDate),
                      subtitle: Text(
                        _end == null ? l10n.noEndDate : _dateLabel(_end!),
                      ),
                      trailing: _end == null
                          ? const Icon(Icons.calendar_today)
                          : IconButton(
                              tooltip: l10n.clearEndDate,
                              onPressed: () => setState(() => _end = null),
                              icon: const Icon(Icons.close),
                            ),
                      onTap: () => _pickDate(end: true),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<RecurringMode>(
                      key: ValueKey('mode-$_mode'),
                      initialValue: _mode,
                      decoration: InputDecoration(
                        labelText: l10n.recurringMode,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: RecurringMode.auto,
                          child: Text(l10n.modeAuto),
                        ),
                        DropdownMenuItem(
                          value: RecurringMode.ask,
                          child: Text(l10n.modeAsk),
                        ),
                      ],
                      onChanged: (value) => setState(() {
                        _mode = value ?? RecurringMode.ask;
                      }),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<RecurringTemplate>(
                      key: ValueKey('tpl-$_template'),
                      initialValue: _template,
                      decoration: InputDecoration(labelText: l10n.template),
                      items: [
                        DropdownMenuItem(
                          value: RecurringTemplate.standard,
                          child: Text(l10n.templateStandard),
                        ),
                        DropdownMenuItem(
                          value: RecurringTemplate.committee,
                          child: Text(l10n.templateCommittee),
                        ),
                        DropdownMenuItem(
                          value: RecurringTemplate.installment,
                          child: Text(l10n.templateInstallment),
                        ),
                      ],
                      onChanged: (value) => setState(() {
                        _template = value ?? RecurringTemplate.standard;
                      }),
                    ),
                    if (_template == RecurringTemplate.installment) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _countCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.installmentCount,
                        ),
                        validator: (value) {
                          if (_template != RecurringTemplate.installment) {
                            return null;
                          }
                          final n = int.tryParse(value?.trim() ?? '');
                          if (n == null || n < 1) return l10n.fieldRequired;
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      key: ValueKey('pay-$_paymentMethod'),
                      initialValue: _paymentMethod,
                      decoration: InputDecoration(
                        labelText: l10n.paymentMethod,
                      ),
                      items: [
                        DropdownMenuItem(value: 'cash', child: Text(l10n.cash)),
                        DropdownMenuItem(
                          value: 'card',
                          child: Text(l10n.creditCard),
                        ),
                        DropdownMenuItem(value: 'bank', child: Text(l10n.bank)),
                        DropdownMenuItem(
                          value: 'jazzcash',
                          child: Text(l10n.jazzcash),
                        ),
                        DropdownMenuItem(
                          value: 'easypaisa',
                          child: Text(l10n.easypaisa),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text(l10n.other),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _paymentMethod = value),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _noteCtrl,
                      decoration: InputDecoration(labelText: l10n.note),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _loading ? null : () => _save(wallets),
                      child: Text(l10n.save),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _unitLabel(AppLocalizations l10n) => switch (_frequency) {
    RecurringFrequency.daily => l10n.unitDays,
    RecurringFrequency.weekly => l10n.unitWeeks,
    RecurringFrequency.monthly => l10n.unitMonths,
    RecurringFrequency.yearly => l10n.unitYears,
    RecurringFrequency.custom =>
      _customUnit == 'months' ? l10n.unitMonths : l10n.unitDays,
  };
}
