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
import '../../../data/repositories/reminder_repository.dart';
import '../../../domain/enums/reminder_type.dart';
import '../../../domain/models/reminder.dart';
import '../../../domain/services/reminder_scheduler.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';
import 'reminder_labels.dart';

class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reminders = ref.watch(remindersProvider);
    final finance = FinanceColors.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reminders)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/more/reminders/add'),
        child: const Icon(Icons.add),
      ),
      body: reminders.when(
        loading: () => LoadingState(message: l10n.loading),
        error: (error, stack) =>
            AsyncErrorView(error: error, stackTrace: stack),
        data: (items) {
          final hasDaily = items.any(
            (item) => item.type == ReminderType.dailyExpense,
          );
          final now = DateTime.now();
          final sorted = [...items]..sort((a, b) {
            final rankA = _rank(a, now);
            final rankB = _rank(b, now);
            if (rankA != rankB) return rankA.compareTo(rankB);
            return a.dueDate.compareTo(b.dueDate);
          });
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  Responsive.of(context).pagePadding,
                  AppSpacing.sm,
                  Responsive.of(context).pagePadding,
                  88,
                ),
                children: [
                  Card(
                    child: SwitchListTile(
                      secondary: Icon(
                        Icons.today_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(l10n.dailyExpenseReminder),
                      subtitle: Text(
                        l10n.dailyExpenseReminderHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: finance.mutedText,
                        ),
                      ),
                      value: hasDaily,
                      onChanged: (enabled) async {
                        await ref
                            .read(reminderRepositoryProvider)
                            .setDailyExpenseEnabled(
                              enabled: enabled,
                              title: l10n.dailyExpenseReminder,
                            );
                        await ref.read(syncReminderNotificationsProvider)();
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (sorted.isEmpty)
                    EmptyState(
                      icon: Icons.notifications_none,
                      title: l10n.reminders,
                      message: l10n.emptyReminders,
                      actionLabel: l10n.addReminder,
                      onAction: () => context.push('/more/reminders/add'),
                    )
                  else
                    for (var i = 0; i < sorted.length; i++) ...[
                      _ReminderCard(reminder: sorted[i], now: now),
                      if (i < sorted.length - 1)
                        const SizedBox(height: AppSpacing.sm),
                    ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

int _rank(Reminder reminder, DateTime now) {
  if (ReminderScheduler.isOverdueReminder(reminder, now)) return 0;
  if (!reminder.isDone) return 1;
  return 2;
}

class _ReminderCard extends ConsumerWidget {
  const _ReminderCard({required this.reminder, required this.now});

  final Reminder reminder;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final overdue = ReminderScheduler.isOverdueReminder(reminder, now);
    final color = overdue ? finance.expense : null;
    final dateFmt = DateFormat.yMMMd();
    final amount = reminder.amount;

    return Card(
      child: InkWell(
        onTap: () => context.push('/more/reminders/edit/${reminder.id}'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    overdue
                        ? Icons.warning_amber_rounded
                        : Icons.notifications_outlined,
                    color: color ?? theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          [
                            reminderTypeLabel(l10n, reminder.type),
                            reminderDueLabel(l10n, reminder, now),
                            if (reminder.type != ReminderType.dailyExpense)
                              dateFmt.format(reminder.dueDate),
                            reminderRepeatLabel(l10n, reminder.repeat),
                            if (reminder.isDone &&
                                reminder.paidTransactionId != null)
                              l10n.paid,
                          ].join(' · '),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (amount != null) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: MoneyText(
                        amount,
                        currencyCode: reminder.currency,
                      ),
                    ),
                  ],
                ],
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!reminder.isDone)
                      IconButton(
                        tooltip: l10n.markDone,
                        onPressed: () => _run(
                          context,
                          ref,
                          () => ref
                              .read(reminderRepositoryProvider)
                              .markDone(reminder.id),
                        ),
                        icon: const Icon(Icons.check),
                      ),
                    if (reminderCanMarkPaid(reminder))
                      IconButton(
                        tooltip: l10n.markPaid,
                        onPressed: () => _run(
                          context,
                          ref,
                          () => ref
                              .read(reminderRepositoryProvider)
                              .markAsPaid(reminder.id),
                        ),
                        icon: const Icon(Icons.payments_outlined),
                      ),
                    IconButton(
                      tooltip: l10n.delete,
                      onPressed: () async {
                        final ok = await confirmDelete(context);
                        if (!ok || !context.mounted) return;
                        await _run(
                          context,
                          ref,
                          () => ref
                              .read(reminderRepositoryProvider)
                              .delete(reminder.id),
                        );
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
  }

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action();
      await ref.read(syncReminderNotificationsProvider)();
    } on ReminderPaymentException {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.markPaidNeedsDetails)),
      );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    }
  }
}
