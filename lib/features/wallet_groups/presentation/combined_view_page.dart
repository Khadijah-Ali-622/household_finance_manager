import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/locale/locale_settings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class CombinedViewPage extends ConsumerWidget {
  const CombinedViewPage({super.key, this.groupId, this.walletIds});

  final String? groupId;
  final List<String>? walletIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final walletsAsync = ref.watch(walletsProvider);
    final txsAsync = ref.watch(transactionsProvider);
    final groupsAsync = ref.watch(walletGroupsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.combinedView)),
      body: walletsAsync.when(
        loading: () => LoadingState(message: l10n.loading),
        error: (e, st) => AsyncErrorView(error: e, stackTrace: st),
        data: (allWallets) {
          final groups = groupsAsync.value ?? [];
          List<String> ids = walletIds ?? [];
          String title = l10n.combinedView;
          if (groupId != null) {
            final g = groups.where((x) => x.id == groupId).firstOrNull;
            if (g != null) {
              ids = g.walletIds;
              title = g.name;
            }
          }
          final selected =
              allWallets.where((w) => ids.contains(w.id)).toList();
          final txs = txsAsync.value ?? [];
          final base = ref.watch(baseCurrencyProvider);
          final converter = ref.watch(currencyConverterProvider).value;
          final totals = ref.read(groupTotalsCalculatorProvider).calculate(
                wallets: selected,
                allTransactions: txs,
                converter: converter,
              );
          final ownFmt = (amount, code) => MoneyFormatter(
                currencyCode: code,
                locale: Localizations.localeOf(context).toString(),
                useNativeDigits: ref.watch(nativeDigitsProvider),
              ).format(amount);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screen),
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.card),
                  child: Column(
                    children: [
                      _row(context, l10n.balance, totals.totalBalance, base),
                      _row(context, l10n.income, totals.totalIncome, base),
                      _row(context, l10n.expense, totals.totalExpense, base),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              Text(
                l10n.perWalletBreakdown,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              ...totals.perWallet.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Card(
                    child: ListTile(
                      title: Text('${b.wallet.name} (${b.wallet.currency})'),
                      subtitle: Text(
                        '${l10n.income}: ${ownFmt(b.income, b.wallet.currency)} · ${l10n.expense}: ${ownFmt(b.expense, b.wallet.currency)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: FinanceColors.of(context).mutedText,
                            ),
                      ),
                      trailing: MoneyText(
                        b.balance,
                        currencyCode: b.wallet.currency,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    dynamic amount,
    String currencyCode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          MoneyText(amount, currencyCode: currencyCode),
        ],
      ),
    );
  }
}
