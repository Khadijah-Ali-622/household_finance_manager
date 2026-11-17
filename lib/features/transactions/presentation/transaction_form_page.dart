import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/currency/iso_currencies.dart';
import '../../../core/l10n/category_l10n.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../domain/enums/category_type.dart';
import '../../../domain/enums/transaction_type.dart';
import '../../../domain/models/money_amount.dart';
import '../../../domain/services/calculator_engine.dart';
import '../../../l10n/app_localizations.dart';
import '../../calculator/presentation/calculator_page.dart';
import '../../providers.dart';

class TransactionFormPage extends ConsumerStatefulWidget {
  const TransactionFormPage({super.key, this.transactionId});

  final String? transactionId;

  @override
  ConsumerState<TransactionFormPage> createState() =>
      _TransactionFormPageState();
}

class _TransactionFormPageState extends ConsumerState<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _receivedCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  TxType _type = TxType.expense;
  String? _walletId;
  String? _toWalletId;
  String? _categoryId;
  String? _paymentMethod = 'cash';
  DateTime _date = DateTime.now();
  bool _loading = false;
  bool _initialized = false;
  bool _receivedEdited = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _receivedCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (_initialized) return;
    _initialized = true;
    if (widget.transactionId == null) return;
    final tx = await ref
        .read(transactionRepositoryProvider)
        .getById(widget.transactionId!);
    if (tx != null && mounted) {
      final wallets = ref.read(walletsProvider).value ?? [];
      final from = wallets.where((w) => w.id == tx.walletId).firstOrNull;
      final digits = IsoCurrencies.decimalDigits(from?.currency ?? 'PKR');
      setState(() {
        _type = tx.type;
        _walletId = tx.walletId;
        _toWalletId = tx.toWalletId;
        _categoryId = tx.categoryId;
        _paymentMethod = tx.paymentMethod ?? 'cash';
        _date = tx.date;
        _amountCtrl.text = MoneyAmount(tx.amount.minorUnits)
            .toMajor(digits)
            .toStringAsFixed(
              tx.amount.minorUnits % MoneyAmount.factor(digits) == 0
                  ? 0
                  : digits,
            );
        if (tx.toAmount != null) {
          final to = wallets.where((w) => w.id == tx.toWalletId).firstOrNull;
          final toDigits = IsoCurrencies.decimalDigits(to?.currency ?? 'PKR');
          _receivedCtrl.text = tx.toAmount!
              .toMajor(toDigits)
              .toStringAsFixed(
                tx.toAmount!.minorUnits % MoneyAmount.factor(toDigits) == 0
                    ? 0
                    : toDigits,
              );
          _receivedEdited = true;
        }
        _noteCtrl.text = tx.note ?? '';
      });
    }
  }

  String? _resolveAmountInput(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final looksLikeExpression = RegExp(r'[+\-×÷*/()%]').hasMatch(trimmed);
    if (!looksLikeExpression) {
      return trimmed.replaceAll(',', '');
    }
    final engine = CalculatorEngine(decimalSeparator: '.');
    final result = engine.evaluate(trimmed.replaceAll(',', ''));
    return switch (result) {
      CalcSuccess(:final value) => engine.formatResult(value),
      CalcError() => null,
    };
  }

  void _prefillReceived({
    required String fromCurrency,
    required String toCurrency,
  }) {
    if (_receivedEdited) return;
    final amountStr = _resolveAmountInput(_amountCtrl.text);
    if (amountStr == null) return;
    final fromDigits = IsoCurrencies.decimalDigits(fromCurrency);
    final sent = MoneyAmount.fromMajorString(
      amountStr,
      fractionDigits: fromDigits,
    );
    if (fromCurrency == toCurrency) {
      final toDigits = IsoCurrencies.decimalDigits(toCurrency);
      _receivedCtrl.text = MoneyAmount(sent.minorUnits)
          .toMajor(toDigits)
          .toStringAsFixed(
            sent.minorUnits % MoneyAmount.factor(toDigits) == 0 ? 0 : toDigits,
          );
      return;
    }
    final converter = ref.read(currencyConverterProvider).value;
    if (converter == null) return;
    final converted = converter.convert(
      amount: sent,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
    if (converted == null) return;
    final toDigits = IsoCurrencies.decimalDigits(toCurrency);
    _receivedCtrl.text = converted.toMajor(toDigits).toStringAsFixed(
          converted.minorUnits % MoneyAmount.factor(toDigits) == 0
              ? 0
              : toDigits,
        );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_walletId == null) return;
    final amountStr = _resolveAmountInput(_amountCtrl.text);
    if (amountStr == null) return;

    final wallets = ref.read(walletsProvider).value ?? [];
    final from = wallets.where((w) => w.id == _walletId).firstOrNull;
    final to = wallets.where((w) => w.id == _toWalletId).firstOrNull;
    final fromDigits = IsoCurrencies.decimalDigits(from?.currency ?? 'PKR');
    final toDigits = IsoCurrencies.decimalDigits(to?.currency ?? 'PKR');

    setState(() => _loading = true);
    try {
      MoneyAmount? received;
      if (_type == TxType.transfer) {
        final receivedStr = _resolveAmountInput(_receivedCtrl.text) ??
            amountStr;
        received = MoneyAmount.fromMajorString(
          receivedStr,
          fractionDigits: toDigits,
        );
      }
      await ref.read(transactionRepositoryProvider).save(
            id: widget.transactionId,
            walletId: _walletId!,
            type: _type,
            amount: MoneyAmount.fromMajorString(
              amountStr,
              fractionDigits: fromDigits,
            ),
            toAmount: received,
            categoryId: _type == TxType.transfer ? null : _categoryId,
            toWalletId: _type == TxType.transfer ? _toWalletId : null,
            date: _date,
            note: _noteCtrl.text,
            paymentMethod: _paymentMethod,
          );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wallets = ref.watch(walletsProvider).value ?? [];
    final categories = ref.watch(categoriesProvider).value ?? [];
    _load();

    _walletId ??= wallets.isNotEmpty ? wallets.first.id : null;
    final fromWallet = wallets.where((w) => w.id == _walletId).firstOrNull;
    final toWallet = wallets.where((w) => w.id == _toWalletId).firstOrNull;
    final crossCurrency = _type == TxType.transfer &&
        fromWallet != null &&
        toWallet != null &&
        fromWallet.currency != toWallet.currency;

    final filteredCats = categories
        .where(
          (c) =>
              (_type == TxType.income && c.type == CategoryType.income) ||
              (_type == TxType.expense && c.type == CategoryType.expense),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transactionId == null
              ? l10n.addTransaction
              : l10n.transactions,
        ),
        actions: [
          if (widget.transactionId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await confirmDelete(context);
                if (ok) {
                  await ref
                      .read(transactionRepositoryProvider)
                      .delete(widget.transactionId!);
                  if (context.mounted) context.pop();
                }
              },
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
          padding: EdgeInsets.all(Responsive.of(context).pagePadding),
          children: [
            SegmentedButton<TxType>(
              segments: [
                ButtonSegment(value: TxType.expense, label: Text(l10n.expense)),
                ButtonSegment(value: TxType.income, label: Text(l10n.income)),
                ButtonSegment(
                  value: TxType.transfer,
                  label: Text(l10n.transfer),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() {
                _type = s.first;
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
                    ? '${l10n.amountSent}${fromWallet != null ? ' (${fromWallet.currency})' : ''}'
                    : l10n.amount,
                suffixIcon: IconButton(
                  tooltip: l10n.calculator,
                  icon: const Icon(Icons.calculate_outlined),
                  onPressed: () async {
                    final result = await showAmountCalculatorSheet(context);
                    if (result != null && mounted) {
                      setState(() => _amountCtrl.text = result);
                      if (_type == TxType.transfer &&
                          fromWallet != null &&
                          toWallet != null) {
                        _prefillReceived(
                          fromCurrency: fromWallet.currency,
                          toCurrency: toWallet.currency,
                        );
                      }
                    }
                  },
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l10n.fieldRequired;
                final parsed = _resolveAmountInput(v.trim());
                if (parsed == null) return l10n.calcInvalidExpression;
                final digits =
                    IsoCurrencies.decimalDigits(fromWallet?.currency ?? 'PKR');
                final m = MoneyAmount.fromMajorString(
                  parsed,
                  fractionDigits: digits,
                );
                if (m.minorUnits <= 0) return l10n.amountMustBePositive;
                return null;
              },
              onChanged: (_) {
                if (_type == TxType.transfer &&
                    fromWallet != null &&
                    toWallet != null) {
                  setState(() {
                    _prefillReceived(
                      fromCurrency: fromWallet.currency,
                      toCurrency: toWallet.currency,
                    );
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _walletId,
              decoration: InputDecoration(
                labelText: _type == TxType.transfer
                    ? l10n.fromWallet
                    : l10n.wallets,
              ),
              items: wallets
                  .map(
                    (w) => DropdownMenuItem(
                      value: w.id,
                      child: Text('${w.name} (${w.currency})'),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() {
                _walletId = v;
                _receivedEdited = false;
              }),
              validator: (v) => v == null ? l10n.fieldRequired : null,
            ),
            if (_type == TxType.transfer) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _toWalletId,
                decoration: InputDecoration(labelText: l10n.toWallet),
                items: wallets
                    .where((w) => w.id != _walletId)
                    .map(
                      (w) => DropdownMenuItem(
                        value: w.id,
                        child: Text('${w.name} (${w.currency})'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() {
                  _toWalletId = v;
                  _receivedEdited = false;
                  final from = wallets.where((w) => w.id == _walletId).firstOrNull;
                  final to = wallets.where((w) => w.id == v).firstOrNull;
                  if (from != null && to != null) {
                    _prefillReceived(
                      fromCurrency: from.currency,
                      toCurrency: to.currency,
                    );
                  }
                }),
                validator: (v) => v == null ? l10n.fieldRequired : null,
              ),
              if (crossCurrency || _type == TxType.transfer) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _receivedCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText:
                        '${l10n.amountReceived}${toWallet != null ? ' (${toWallet.currency})' : ''}',
                  ),
                  onChanged: (_) => _receivedEdited = true,
                  validator: (v) {
                    if (_type != TxType.transfer) return null;
                    if (v == null || v.trim().isEmpty) {
                      return l10n.fieldRequired;
                    }
                    final parsed = _resolveAmountInput(v.trim());
                    if (parsed == null) return l10n.calcInvalidExpression;
                    final digits = IsoCurrencies.decimalDigits(
                      toWallet?.currency ?? 'PKR',
                    );
                    final m = MoneyAmount.fromMajorString(
                      parsed,
                      fractionDigits: digits,
                    );
                    if (m.minorUnits <= 0) return l10n.amountMustBePositive;
                    return null;
                  },
                ),
              ],
            ] else ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _categoryId,
                decoration: InputDecoration(labelText: l10n.category),
                items: filteredCats
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(localizedCategoryName(l10n, c)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _categoryId = v),
                validator: (v) => v == null ? l10n.fieldRequired : null,
              ),
            ],
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.date),
              subtitle: Text(
                '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _paymentMethod,
              decoration: InputDecoration(labelText: l10n.paymentMethod),
              items: [
                DropdownMenuItem(value: 'cash', child: Text(l10n.cash)),
                DropdownMenuItem(value: 'card', child: Text(l10n.creditCard)),
                DropdownMenuItem(
                  value: 'bank_transfer',
                  child: Text(l10n.bank),
                ),
                DropdownMenuItem(value: 'jazzcash', child: Text(l10n.jazzcash)),
                DropdownMenuItem(
                  value: 'easypaisa',
                  child: Text(l10n.easypaisa),
                ),
                DropdownMenuItem(value: 'other', child: Text(l10n.other)),
              ],
              onChanged: (v) => setState(() => _paymentMethod = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteCtrl,
              decoration: InputDecoration(labelText: l10n.note),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
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
      ),
    );
  }
}
