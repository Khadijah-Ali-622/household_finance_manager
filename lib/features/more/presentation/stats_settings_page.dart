import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/adaptive_modal.dart';
import '../../../l10n/app_localizations.dart';
import '../../stats/stats_state.dart';

class StatsSettingsPage extends ConsumerWidget {
  const StatsSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final weekStartsMonday = ref.watch(weekStartsOnMondayProvider);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsSettings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.sm,
        ),
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                Icons.date_range_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(l10n.weekStartsOn),
              subtitle: Text(
                weekStartsMonday ? l10n.monday : l10n.sunday,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: finance.mutedText,
                ),
              ),
              onTap: () async {
                final selected = await showAdaptiveModal<bool>(
                  context: context,
                  dialogMaxWidth: 360,
                  builder: (ctx) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(l10n.monday),
                          onTap: () => Navigator.pop(ctx, true),
                        ),
                        ListTile(
                          title: Text(l10n.sunday),
                          onTap: () => Navigator.pop(ctx, false),
                        ),
                      ],
                    ),
                  ),
                );
                if (selected != null) {
                  await ref
                      .read(statsUiProvider.notifier)
                      .setWeekStartsOnMonday(selected);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
