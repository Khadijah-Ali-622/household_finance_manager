import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/currency/iso_currencies.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/currency_picker_sheet.dart';
import '../../../domain/enums/liability_type.dart';
import '../../../domain/models/money_amount.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class LiabilityFormPage extends ConsumerStatefulWidget {
  const LiabilityFormPage({super.key, this.liabilityId});

  final String? liabilityId;

  @override
  ConsumerState<LiabilityFormPage> createState() => _LiabilityFormPageState();
}

class _LiabilityFormPageState extends ConsumerState<LiabilityFormPage> {
  final _nameCtrl = TextEditingController();
  final _totalCtrl = TextEditingController();
  final _remainingCtrl = TextEditingController();
  final _installmentCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  LiabilityType _type = LiabilityType.other;
  String _currency = 'PKR';
  bool _loading = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _totalCtrl.dispose();
    _remainingCtrl.dispose();
    _installmentCtrl.dispose();
    _rateCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String _fmt(MoneyAmount amount, String currency) {
    final digits = IsoCurrencies.decimalDigits(currency);
    final f = MoneyAmount.factor(digits);
    if (amount.minorUnits % f == 0) {
      return (amount.minorUnits ~/ f).toString();
    }
    return amount.toMajor(digits).toStringAsFixed(digits);
  }

  Future<void> _load() async {
    if (_initialized || widget.liabilityId == null) {
      _initialized = true;
      return;
    }
    final items =
        await ref.read(liabilityRepositoryProvider).watchAll().first;
    final item = items.where((l) => l.id == widget.liabilityId).firstOrNull;
    if (item != null && mounted) {
      setState(() {
        _nameCtrl.text = item.name;
        _type = item.type;
        _currency = item.currency;
        _totalCtrl.text = _fmt(item.totalAmount, item.currency);
        _remainingCtrl.text = _fmt(item.remainingAmount, item.currency);
        if (item.installmentAmount != null) {
          _installmentCtrl.text =
              _fmt(item.installmentAmount!, item.currency);
        }
        _rateCtrl.text = item.interestRate ?? '';
        _notesCtrl.text = item.notes ?? '';
        _initialized = true;
      });
    }
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    final digits = IsoCurrencies.decimalDigits(_currency);
    setState(() => _loading = true);
    try {
      await ref.read(liabilityRepositoryProvider).save(
            id: widget.liabilityId,
            name: _nameCtrl.text,
            type: _type,
            totalAmount: MoneyAmount.fromMajorString(
              _totalCtrl.text,
              fractionDigits: digits,
            ),
            remainingAmount: MoneyAmount.fromMajorString(
              _remainingCtrl.text,
              fractionDigits: digits,
            ),
            currency: _currency,
            installmentAmount: _installmentCtrl.text.trim().isEmpty
                ? null
                : MoneyAmount.fromMajorString(
                    _installmentCtrl.text,
                    fractionDigits: digits,
                  ),
            interestRate:
                _rateCtrl.text.trim().isEmpty ? null : _rateCtrl.text.trim(),
            notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text,
          );
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    _load();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.liabilityId == null ? l10n.addLiability : l10n.editLiability,
        ),
        actions: [
          if (widget.liabilityId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await confirmDelete(context);
                if (ok) {
                  await ref
                      .read(liabilityRepositoryProvider)
                      .delete(widget.liabilityId!);
                  if (context.mounted) context.pop();
                }
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(labelText: l10n.name),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<LiabilityType>(
            initialValue: _type,
            decoration: InputDecoration(labelText: l10n.type),
            items: LiabilityType.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                .toList(),
            onChanged: (v) =>
                setState(() => _type = v ?? LiabilityType.other),
          ),
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
          TextField(
            controller: _totalCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.amount),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _remainingCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.remainingAmount),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _installmentCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Installment'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _rateCtrl,
            decoration: const InputDecoration(labelText: 'Interest rate'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            decoration: InputDecoration(labelText: l10n.note),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _save,
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
