import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/category_l10n.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/adaptive_modal.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../../data/db/daos/transactions_dao.dart';
import '../../../domain/enums/transaction_type.dart';
import '../../../domain/models/transaction.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final txsAsync = ref.watch(transactionsProvider);
    final wallets = ref.watch(walletsProvider).value ?? [];
    final categories = ref.watch(categoriesProvider).value ?? [];
    final filter = ref.watch(transactionFilterProvider);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transactions)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/transactions/add'),
        child: const Icon(Icons.add),
      ),
      body: ResponsiveBuilder(
        builder: (context, responsive) {
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      responsive.pagePadding,
                      AppSpacing.sm,
                      responsive.pagePadding,
                      0,
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: l10n.search,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          tooltip: l10n.filters,
                          icon: const Icon(Icons.tune),
                          onPressed: () => _openFilters(context),
                        ),
                      ),
                      onChanged: (v) {
                        ref
                            .read(transactionFilterProvider.notifier)
                            .update(
                              TransactionFilter(
                                walletId: filter.walletId,
                                categoryId: filter.categoryId,
                                type: filter.type,
                                search: v,
                                fromDate: filter.fromDate,
                                toDate: filter.toDate,
                              ),
                            );
                      },
                    ),
                  ),
                  Expanded(
                    child: txsAsync.when(
                      loading: () => LoadingState(message: l10n.loading),
                      error: (e, st) =>
                          AsyncErrorView(error: e, stackTrace: st),
                      data: (txs) {
                        if (txs.isEmpty) {
                          return EmptyState(
                            icon: Icons.receipt_long_outlined,
                            title: l10n.transactions,
                            message: l10n.emptyTransactions,
                            actionLabel: l10n.addTransaction,
                            onAction: () => context.push('/transactions/add'),
                          );
                        }
                        final grouped = <String, List<Transaction>>{};
                        for (final tx in txs) {
                          final key = dayKey(tx.date);
                          grouped.putIfAbsent(key, () => []).add(tx);
                        }
                        final keys = grouped.keys.toList();

                        return ListView.builder(
                          padding: EdgeInsets.fromLTRB(
                            responsive.pagePadding,
                            AppSpacing.sm,
                            responsive.pagePadding,
                            responsive.isMobile ? 88 : 24,
                          ),
                          itemCount: keys.length,
                          itemBuilder: (context, index) {
                    final dayTxs = grouped[keys[index]]!;
                    final header = formatDayHeader(dayTxs.first.date);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            header.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: finance.mutedText,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        ...dayTxs.map((tx) {
                          final wallet = wallets
                              .where((w) => w.id == tx.walletId)
                              .firstOrNull;
                          final toWallet = wallets
                              .where((w) => w.id == tx.toWalletId)
                              .firstOrNull;
                          final cat = categories
                              .where((c) => c.id == tx.categoryId)
                              .firstOrNull;
                          final typeColor = switch (tx.type) {
                            TxType.income => finance.income,
                            TxType.expense => finance.expense,
                            TxType.transfer => finance.transfer,
                          };
                          final title = switch (tx.type) {
                            TxType.transfer =>
                              '${wallet?.name ?? l10n.fromWallet} → ${toWallet?.name ?? l10n.toWallet}',
                            _ =>
                              cat == null
                                  ? tx.type.label
                                  : localizedCategoryName(l10n, cat),
                          };
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: Card(
                              child: ListTile(
                                minVerticalPadding: 12,
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: typeColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    switch (tx.type) {
                                      TxType.income => Icons.south_west,
                                      TxType.expense => Icons.north_east,
                                      TxType.transfer => Icons.swap_horiz,
                                    },
                                    color: typeColor,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  [
                                        if (tx.type != TxType.transfer)
                                          wallet?.name,
                                        tx.note,
                                      ]
                                      .whereType<String>()
                                      .where((e) => e.isNotEmpty)
                                      .join(' · '),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: finance.mutedText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: SizedBox(
                                  width: responsive.isMobile ? 100 : 140,
                                  child: tx.type == TxType.transfer
                                      ? MoneyText(
                                          tx.amount,
                                          currencyCode:
                                              wallet?.currency ?? 'PKR',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            color: finance.transfer,
                                          ),
                                        )
                                      : MoneyText(
                                          tx.type == TxType.expense
                                              ? -tx.amount
                                              : tx.amount,
                                          currencyCode:
                                              wallet?.currency ?? 'PKR',
                                          colorize: true,
                                        ),
                                ),
                                onTap: () => context
                                    .push('/transactions/edit/${tx.id}'),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openFilters(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final wallets = ref.read(walletsProvider).value ?? [];
    final categories = ref.read(categoriesProvider).value ?? [];
    var filter = ref.read(transactionFilterProvider);

    await showAdaptiveModal<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSpacing.screen,
                right: AppSpacing.screen,
                top: AppSpacing.lg,
                bottom: MediaQuery.paddingOf(ctx).bottom + AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.filters, style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String?>(
                    initialValue: filter.walletId,
                    decoration: InputDecoration(labelText: l10n.wallets),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      ...wallets.map(
                        (w) =>
                            DropdownMenuItem(value: w.id, child: Text(w.name)),
                      ),
                    ],
                    onChanged: (v) => setModal(
                      () => filter = TransactionFilter(
                        walletId: v,
                        categoryId: filter.categoryId,
                        type: filter.type,
                        search: filter.search,
                        fromDate: filter.fromDate,
                        toDate: filter.toDate,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String?>(
                    initialValue: filter.type,
                    decoration: InputDecoration(labelText: l10n.type),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      ...TxType.values.map(
                        (t) => DropdownMenuItem(
                          value: t.storageValue,
                          child: Text(t.label),
                        ),
                      ),
                    ],
                    onChanged: (v) => setModal(
                      () => filter = TransactionFilter(
                        walletId: filter.walletId,
                        categoryId: filter.categoryId,
                        type: v,
                        search: filter.search,
                        fromDate: filter.fromDate,
                        toDate: filter.toDate,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String?>(
                    initialValue: filter.categoryId,
                    decoration: InputDecoration(labelText: l10n.category),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      ...categories.map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(localizedCategoryName(l10n, c)),
                        ),
                      ),
                    ],
                    onChanged: (v) => setModal(
                      () => filter = TransactionFilter(
                        walletId: filter.walletId,
                        categoryId: v,
                        type: filter.type,
                        search: filter.search,
                        fromDate: filter.fromDate,
                        toDate: filter.toDate,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          ref.read(transactionFilterProvider.notifier).clear();
                          Navigator.pop(ctx);
                        },
                        child: Text(l10n.clearFilters),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () {
                          ref
                              .read(transactionFilterProvider.notifier)
                              .update(filter);
                          Navigator.pop(ctx);
                        },
                        child: Text(l10n.save),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
