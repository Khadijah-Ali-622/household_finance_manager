import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/adaptive_modal.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../../domain/services/net_worth_calculator.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class AssetsLiabilitiesPage extends ConsumerWidget {
  const AssetsLiabilitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final assetsAsync = ref.watch(assetsProvider);
    final liabilitiesAsync = ref.watch(liabilitiesProvider);
    final wallets = ref.watch(walletsProvider).value ?? [];
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navAssetsLiabilities)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context),
        child: const Icon(Icons.add),
      ),
      body: assetsAsync.when(
        loading: () => LoadingState(message: l10n.loading),
        error: (e, st) => AsyncErrorView(error: e, stackTrace: st),
        data: (assets) {
          final liabilities = liabilitiesAsync.value ?? [];
          const calc = NetWorthCalculator();
          final netWorth = calc.calculate(
            walletsWithBalances: wallets,
            assets: assets,
            liabilities: liabilities,
          );

          final r = Responsive.of(context);
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  r.pagePadding,
                  AppSpacing.sm,
                  r.pagePadding,
                  r.isMobile ? 88 : 24,
                ),
                children: [
                  Card(
                    child: ListTile(
                      minVerticalPadding: 12,
                      title: Text(l10n.netWorth),
                      trailing: SizedBox(
                        width: 140,
                        child: MoneyText(
                          netWorth,
                          colorize: true,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.section),
                  Text(l10n.assets, style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  if (assets.isEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Text(
                        l10n.emptyAssets,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: finance.mutedText,
                        ),
                      ),
                    )
                  else
                    ResponsiveGrid(
                      columns: r.gridColumns,
                      children: [
                        for (final a in assets)
                          Card(
                            child: ListTile(
                              minVerticalPadding: 12,
                              title: Text(
                                a.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(a.type.label),
                              trailing: SizedBox(
                                width: 110,
                                child: MoneyText(
                                  a.currentValue,
                                  currencyCode: a.currency,
                                ),
                              ),
                              onTap: () => context
                                  .push('/more/assets/asset/edit/${a.id}'),
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.section),
                  Text(l10n.liabilities, style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  if (liabilities.isEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Text(
                        l10n.emptyLiabilities,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: finance.mutedText,
                        ),
                      ),
                    )
                  else
                    ResponsiveGrid(
                      columns: r.gridColumns,
                      children: [
                        for (final l in liabilities)
                          Card(
                            child: ListTile(
                              minVerticalPadding: 12,
                              title: Text(
                                l.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(l.type.label),
                              trailing: SizedBox(
                                width: 110,
                                child: MoneyText(
                                  l.remainingAmount,
                                  currencyCode: l.currency,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: finance.expense,
                                  ),
                                ),
                              ),
                              onTap: () => context.push(
                                '/more/assets/liability/edit/${l.id}',
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showAdaptiveModal<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.diamond_outlined),
              title: Text(l10n.addAsset),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/more/assets/asset/add');
              },
            ),
            ListTile(
              leading: const Icon(Icons.money_off_csred_outlined),
              title: Text(l10n.addLiability),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/more/assets/liability/add');
              },
            ),
          ],
        ),
      ),
    );
  }
}
