import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/currency/iso_currencies.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/currency_picker_sheet.dart';
import '../../../domain/enums/wallet_type.dart';
import '../../../domain/models/money_amount.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

const _walletColors = [
  0xFF2E7D32,
  0xFF1565C0,
  0xFFC62828,
  0xFF6A1B9A,
  0xFF00838F,
  0xFFEF6C00,
  0xFF455A64,
  0xFFAD1457,
];

const _walletIcons = [
  'account_balance_wallet',
  'account_balance',
  'phone_android',
  'credit_card',
  'savings',
];

class WalletFormPage extends ConsumerStatefulWidget {
  const WalletFormPage({super.key, this.walletId});

  final String? walletId;

  @override
  ConsumerState<WalletFormPage> createState() => _WalletFormPageState();
}

class _WalletFormPageState extends ConsumerState<WalletFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _balanceCtrl = TextEditingController(text: '0');
  WalletType _type = WalletType.cash;
  String _icon = _walletIcons.first;
  int _color = _walletColors.first;
  String _currency = 'PKR';
  bool _loading = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _balanceCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadIfNeeded() async {
    if (_initialized || widget.walletId == null) {
      _initialized = true;
      return;
    }
    final wallet =
        await ref.read(walletRepositoryProvider).getById(widget.walletId!);
    if (wallet != null && mounted) {
      setState(() {
        _nameCtrl.text = wallet.name;
        final digits = IsoCurrencies.decimalDigits(wallet.currency);
        final f = MoneyAmount.factor(digits);
        _balanceCtrl.text = wallet.openingBalance.minorUnits % f == 0
            ? (wallet.openingBalance.minorUnits ~/ f).toString()
            : wallet.openingBalance
                .toMajor(digits)
                .toStringAsFixed(digits);
        _type = wallet.type;
        _icon = wallet.icon;
        _color = wallet.color;
        _currency = wallet.currency;
        _initialized = true;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(walletRepositoryProvider).save(
            id: widget.walletId,
            name: _nameCtrl.text,
            icon: _icon,
            color: _color,
            currency: _currency,
            openingBalance: MoneyAmount.fromMajorString(
              _balanceCtrl.text,
              fractionDigits: IsoCurrencies.decimalDigits(_currency),
            ),
            type: _type,
          );
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).errorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    _loadIfNeeded();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.walletId == null ? l10n.addWallet : l10n.editWallet),
        actions: [
          if (widget.walletId != null)
            PopupMenuButton<String>(
              onSelected: (value) async {
                final repo = ref.read(walletRepositoryProvider);
                if (value == 'archive') {
                  await repo.archive(widget.walletId!);
                  if (context.mounted) context.pop();
                } else if (value == 'delete') {
                  final ok = await confirmDelete(context);
                  if (ok) {
                    await repo.delete(widget.walletId!);
                    if (context.mounted) context.pop();
                  }
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'archive', child: Text(l10n.archiveWallet)),
                PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
              ],
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
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: l10n.name),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<WalletType>(
              initialValue: _type,
              decoration: InputDecoration(labelText: l10n.type),
              items: WalletType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _type = v;
                  if (v == WalletType.creditCard) _icon = 'credit_card';
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _balanceCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.openingBalance),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                try {
                  MoneyAmount.fromMajorString(v);
                  return null;
                } catch (_) {
                  return 'Invalid amount';
                }
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.currency),
              subtitle: Text(() {
                final info = IsoCurrencies.byCode(_currency);
                return info == null
                    ? _currency
                    : '${info.code} — ${info.name}';
              }()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final code = await showCurrencyPicker(
                  context,
                  selectedCode: _currency,
                );
                if (code != null) setState(() => _currency = code);
              },
            ),
            const SizedBox(height: 16),
            Text('Color', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _walletColors.map((c) {
                final selected = c == _color;
                return InkWell(
                  onTap: () => setState(() => _color = c),
                  child: CircleAvatar(
                    backgroundColor: Color(c),
                    child: selected
                        ? const Icon(Icons.check, color: AppColors.onAccent)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Icon', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _walletIcons.map((icon) {
                final selected = icon == _icon;
                return ChoiceChip(
                  label: Text(icon.split('_').last),
                  selected: selected,
                  onSelected: (_) => setState(() => _icon = icon),
                );
              }).toList(),
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
