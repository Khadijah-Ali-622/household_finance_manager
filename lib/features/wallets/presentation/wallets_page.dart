import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/default_categories.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class WalletsPage extends ConsumerWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final walletsAsync = ref.watch(allWalletsProvider);
    final finance = FinanceColors.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wallets),
        actions: [
          IconButton(
            tooltip: l10n.walletGroups,
            onPressed: () => context.push('/wallets/groups'),
            icon: const Icon(Icons.layers_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/wallets/add'),
        child: const Icon(Icons.add),
      ),
      body: walletsAsync.when(
        loading: () => LoadingState(message: l10n.loading),
        error: (e, st) => AsyncErrorView(error: e, stackTrace: st),
        data: (wallets) {
          if (wallets.isEmpty) {
            return EmptyState(
              icon: Icons.account_balance_wallet_outlined,
              title: l10n.wallets,
              message: l10n.emptyWallets,
              actionLabel: l10n.addWallet,
              onAction: () => context.push('/wallets/add'),
            );
          }
          return ResponsiveBuilder(
            builder: (context, responsive) {
              final cards = wallets.map((w) {
                final walletColor = Color(w.color);
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.push('/wallets/edit/${w.id}'),
                    hoverColor: finance.hoverOverlay,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.card),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: walletColor.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              iconFromKey(w.icon),
                              color: walletColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  w.name,
                                  style: theme.textTheme.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  [
                                    w.type.label,
                                    if (w.isArchived) l10n.archived,
                                  ].join(' · '),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: finance.mutedText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Flexible(
                            child: MoneyText(
                              w.balance,
                              currencyCode: w.currency,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList();

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      responsive.pagePadding,
                      AppSpacing.sm,
                      responsive.pagePadding,
                      responsive.isMobile ? 88 : 24,
                    ),
                    child: ResponsiveGrid(
                      columns: responsive.gridColumns,
                      children: cards,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
