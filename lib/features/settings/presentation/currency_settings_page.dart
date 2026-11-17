import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/locale/locale_settings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/currency_picker_sheet.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class CurrencySettingsPage extends ConsumerStatefulWidget {
  const CurrencySettingsPage({super.key});

  @override
  ConsumerState<CurrencySettingsPage> createState() =>
      _CurrencySettingsPageState();
}

class _CurrencySettingsPageState extends ConsumerState<CurrencySettingsPage> {
  bool _refreshing = false;

  Future<void> _pickBaseCurrency() async {
    final current = ref.read(baseCurrencyProvider);
    final picked = await showCurrencyPicker(context, selectedCode: current);
    if (picked == null || !mounted) return;
    await ref.read(baseCurrencyProvider.notifier).setCurrency(picked);
  }

  Future<void> _refreshRates() async {
    if (_refreshing) return;
    final l10n = AppLocalizations.of(context);
    final base = ref.read(baseCurrencyProvider);
    setState(() => _refreshing = true);
    try {
      await ref.read(exchangeRateRepositoryProvider).refreshFromNetwork(base);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.ratesRefreshSuccess)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.ratesRefreshFailed)));
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  String _updatedLabel(AppLocalizations l10n, DateTime? updated) {
    if (updated == null) return l10n.lastUpdatedNever;
    final locale = Localizations.localeOf(context).toString();
    final formatted = DateFormat.yMMMd(locale)
        .add_jm()
        .format(updated.toLocal());
    return l10n.ratesLastUpdated(formatted);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final base = ref.watch(baseCurrencyProvider);
    final nativeDigits = ref.watch(nativeDigitsProvider);
    final converter = ref.watch(currencyConverterProvider);
    final updated = converter.asData?.value.lastUpdated;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.currencySettings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.sm,
        ),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.payments_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(l10n.baseCurrency),
                  subtitle: Text(
                    currencyLabel(base),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: finance.mutedText,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickBaseCurrency,
                ),
                Divider(height: 1, color: theme.colorScheme.outline),
                SwitchListTile(
                  secondary: Icon(
                    Icons.pin_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(l10n.nativeDigits),
                  value: nativeDigits,
                  onChanged: (value) {
                    ref.read(nativeDigitsProvider.notifier).setEnabled(value);
                  },
                ),
                Divider(height: 1, color: theme.colorScheme.outline),
                ListTile(
                  leading: Icon(
                    Icons.currency_exchange,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(l10n.exchangeRates),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/more/currency/rates'),
                ),
                Divider(height: 1, color: theme.colorScheme.outline),
                ListTile(
                  leading: Icon(Icons.update, color: theme.colorScheme.primary),
                  title: Text(_updatedLabel(l10n, updated)),
                  subtitle: Text(
                    base,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: finance.mutedText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: _refreshing ? null : _refreshRates,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppSpacing.buttonMinHeight),
            ),
            icon: _refreshing
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.refresh),
            label: Text(l10n.refreshRates),
          ),
        ],
      ),
    );
  }
}
