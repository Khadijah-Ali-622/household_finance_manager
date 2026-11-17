import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/currency/iso_currencies.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/currency_picker_sheet.dart';
import '../../../domain/enums/asset_type.dart';
import '../../../domain/models/money_amount.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class AssetFormPage extends ConsumerStatefulWidget {
  const AssetFormPage({super.key, this.assetId});

  final String? assetId;

  @override
  ConsumerState<AssetFormPage> createState() => _AssetFormPageState();
}

class _AssetFormPageState extends ConsumerState<AssetFormPage> {
  final _nameCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  AssetType _type = AssetType.other;
  String _currency = 'PKR';
  bool _loading = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _valueCtrl.dispose();
    _qtyCtrl.dispose();
    _unitCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (_initialized || widget.assetId == null) {
      _initialized = true;
      return;
    }
    final assets = await ref.read(assetRepositoryProvider).watchAll().first;
    final asset = assets.where((a) => a.id == widget.assetId).firstOrNull;
    if (asset != null && mounted) {
      setState(() {
        _nameCtrl.text = asset.name;
        _type = asset.type;
        _currency = asset.currency;
        final digits = IsoCurrencies.decimalDigits(asset.currency);
        final f = MoneyAmount.factor(digits);
        _valueCtrl.text = asset.currentValue.minorUnits % f == 0
            ? (asset.currentValue.minorUnits ~/ f).toString()
            : asset.currentValue.toMajor(digits).toStringAsFixed(digits);
        _qtyCtrl.text = asset.quantity ?? '';
        _unitCtrl.text = asset.unit ?? '';
        _notesCtrl.text = asset.notes ?? '';
        _initialized = true;
      });
    }
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _valueCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    try {
      await ref.read(assetRepositoryProvider).save(
            id: widget.assetId,
            name: _nameCtrl.text,
            type: _type,
            currentValue: MoneyAmount.fromMajorString(
              _valueCtrl.text,
              fractionDigits: IsoCurrencies.decimalDigits(_currency),
            ),
            currency: _currency,
            quantity: _qtyCtrl.text.trim().isEmpty ? null : _qtyCtrl.text,
            unit: _unitCtrl.text.trim().isEmpty ? null : _unitCtrl.text,
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
        title: Text(widget.assetId == null ? l10n.addAsset : l10n.editAsset),
        actions: [
          if (widget.assetId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok = await confirmDelete(context);
                if (ok) {
                  await ref
                      .read(assetRepositoryProvider)
                      .delete(widget.assetId!);
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
          DropdownButtonFormField<AssetType>(
            initialValue: _type,
            decoration: InputDecoration(labelText: l10n.type),
            items: AssetType.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                .toList(),
            onChanged: (v) => setState(() => _type = v ?? AssetType.other),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _valueCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.currentValue),
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
            controller: _qtyCtrl,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _unitCtrl,
            decoration: const InputDecoration(labelText: 'Unit (tola/gram)'),
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
