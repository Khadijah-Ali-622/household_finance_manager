import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/money_text.dart';
import '../../../domain/models/reminder.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';
import 'reminder_labels.dart';

/// Due soon and overdue reminders for the dashboard, including web.
class HomeDueSection extends ConsumerWidget {
  const HomeDueSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final overdue = ref.watch(overdueRemindersProvider);
    final dueSoon = ref.watch(dueSoonRemindersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.reminders, style: theme.textTheme.titleMedium),
            ),
            TextButton(
              onPressed: () => context.push('/more/reminders'),
              child: Text(l10n.viewReminders),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        overdue.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => Text(
            l10n.errorGeneric,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          data: (lateItems) {
            return dueSoon.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => Text(
                l10n.errorGeneric,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              data: (soonItems) {
                if (lateItems.isEmpty && soonItems.isEmpty) {
                  return Text(
                    l10n.noDueReminders,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: finance.mutedText,
                    ),
                  );
                }
                final now = DateTime.now();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (lateItems.isNotEmpty) ...[
                      Text(
                        l10n.overdue,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: finance.expense,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final item in lateItems.take(5)) ...[
                        _DueTile(reminder: item, now: now, overdue: true),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                    if (soonItems.isNotEmpty) ...[
                      if (lateItems.isNotEmpty)
                        const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.dueSoon,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: finance.mutedText,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final item in soonItems.take(5)) ...[
                        _DueTile(reminder: item, now: now, overdue: false),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _DueTile extends StatelessWidget {
  const _DueTile({
    required this.reminder,
    required this.now,
    required this.overdue,
  });

  final Reminder reminder;
  final DateTime now;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final color = overdue ? finance.expense : null;
    final amount = reminder.amount;

    return Card(
      child: ListTile(
        leading: Icon(
          overdue ? Icons.warning_amber_rounded : Icons.notifications_outlined,
          color: color ?? theme.colorScheme.primary,
        ),
        title: Text(
          reminder.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(color: color),
        ),
        subtitle: Text(
          reminderDueLabel(l10n, reminder, now),
          style: theme.textTheme.bodySmall?.copyWith(
            color: color ?? finance.mutedText,
          ),
        ),
        trailing: amount == null
            ? null
            : MoneyText(amount, currencyCode: reminder.currency),
        onTap: () => context.push('/more/reminders/edit/${reminder.id}'),
      ),
    );
  }
}
