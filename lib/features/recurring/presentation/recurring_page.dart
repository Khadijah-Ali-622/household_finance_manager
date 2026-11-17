import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../../domain/enums/recurring_frequency.dart';
import '../../../domain/enums/recurring_mode.dart';
import '../../../domain/enums/transaction_type.dart';
import '../../../domain/models/recurring_rule.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class RecurringPage extends ConsumerWidget {
  const RecurringPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rules = ref.watch(recurringRulesProvider);
    final wallets = ref.watch(allWalletsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recurring)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/more/recurring/add'),
        child: const Icon(Icons.add),
      ),
      body: rules.when(
        loading: () => LoadingState(message: l10n.loading),
        error: (error, stack) =>
            AsyncErrorView(error: error, stackTrace: stack),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.event_repeat,
              title: l10n.recurring,
              message: l10n.emptyRecurring,
              actionLabel: l10n.addRecurring,
              onAction: () => context.push('/more/recurring/add'),
            );
          }
          final dateFmt = DateFormat.yMMMd();
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  Responsive.of(context).pagePadding,
                  AppSpacing.sm,
                  Responsive.of(context).pagePadding,
                  88,
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final rule = items[index];
                  final wallet = wallets
                      .where((item) => item.id == rule.walletId)
                      .firstOrNull;
                  final title = (rule.note != null && rule.note!.isNotEmpty)
                      ? rule.note!
                      : _typeLabel(l10n, rule.type);
                  final status = !rule.isActive
                      ? l10n.completed
                      : rule.isPaused
                      ? l10n.paused
                      : dateFmt.format(rule.nextDueDate);
                  return Card(
                    child: InkWell(
                      onTap: () =>
                          context.push('/more/recurring/edit/${rule.id}'),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(_typeIcon(rule.type)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        [
                                          _scheduleLabel(l10n, rule),
                                          if (wallet != null) wallet.name,
                                          '${l10n.nextDue}: $status',
                                          rule.mode == RecurringMode.auto
                                              ? l10n.modeAuto
                                              : l10n.modeAsk,
                                          if (rule.installmentCount != null)
                                            '${rule.generatedCount}/${rule.installmentCount}',
                                        ].join(' · '),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: MoneyText(
                                    rule.amount,
                                    currencyCode: rule.currency,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (rule.isActive)
                                    IconButton(
                                      tooltip: rule.isPaused
                                          ? l10n.resume
                                          : l10n.pause,
                                      onPressed: () => ref
                                          .read(recurringRepositoryProvider)
                                          .setPaused(
                                            rule.id,
                                            paused: !rule.isPaused,
                                          ),
                                      icon: Icon(
                                        rule.isPaused
                                            ? Icons.play_arrow
                                            : Icons.pause,
                                      ),
                                    ),
                                  IconButton(
                                    tooltip: l10n.delete,
                                    onPressed: () async {
                                      final ok = await confirmDelete(context);
                                      if (!ok) return;
                                      await ref
                                          .read(recurringRepositoryProvider)
                                          .delete(rule.id);
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

String _typeLabel(AppLocalizations l10n, TxType type) => switch (type) {
  TxType.income => l10n.income,
  TxType.expense => l10n.expense,
  TxType.transfer => l10n.transfer,
};

IconData _typeIcon(TxType type) => switch (type) {
  TxType.income => Icons.arrow_downward,
  TxType.expense => Icons.arrow_upward,
  TxType.transfer => Icons.swap_horiz,
};

String _scheduleLabel(AppLocalizations l10n, RecurringRule rule) {
  final unit = switch (rule.frequency) {
    RecurringFrequency.daily => l10n.unitDays,
    RecurringFrequency.weekly => l10n.unitWeeks,
    RecurringFrequency.monthly => l10n.unitMonths,
    RecurringFrequency.yearly => l10n.unitYears,
    RecurringFrequency.custom =>
      rule.customUnit == 'months' ? l10n.unitMonths : l10n.unitDays,
  };
  if (rule.intervalN <= 1 && rule.frequency != RecurringFrequency.custom) {
    return switch (rule.frequency) {
      RecurringFrequency.daily => l10n.frequencyDaily,
      RecurringFrequency.weekly => l10n.frequencyWeekly,
      RecurringFrequency.monthly => l10n.frequencyMonthly,
      RecurringFrequency.yearly => l10n.frequencyYearly,
      RecurringFrequency.custom =>
        '${l10n.everyInterval} ${rule.intervalN} $unit',
    };
  }
  return '${l10n.everyInterval} ${rule.intervalN} $unit';
}
