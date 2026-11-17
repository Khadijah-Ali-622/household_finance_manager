import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final groupsAsync = ref.watch(walletGroupsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.walletGroups),
        actions: [
          TextButton(
            onPressed: () => context.push('/wallets/groups/quick'),
            child: Text(l10n.quickSelect),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/wallets/groups/add'),
        child: const Icon(Icons.add),
      ),
      body: groupsAsync.when(
        loading: () => LoadingState(message: l10n.loading),
        error: (e, st) => AsyncErrorView(error: e, stackTrace: st),
        data: (groups) {
          if (groups.isEmpty) {
            return EmptyState(
              icon: Icons.layers_outlined,
              title: l10n.walletGroups,
              message: l10n.emptyGroups,
              actionLabel: l10n.createGroup,
              onAction: () => context.push('/wallets/groups/add'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.sm,
              AppSpacing.screen,
              88,
            ),
            itemCount: groups.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final g = groups[index];
              return Card(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.layers_outlined,
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  title: Text(g.name),
                  subtitle: Text('${g.walletIds.length} wallets'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: FinanceColors.of(context).mutedText,
                  ),
                  onTap: () => context.push('/wallets/groups/view/${g.id}'),
                  onLongPress: () =>
                      context.push('/wallets/groups/edit/${g.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
