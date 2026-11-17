import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/adaptive_modal.dart';
import '../../../l10n/app_localizations.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final baseCurrency = ref.watch(baseCurrencyProvider);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);

    Widget leadingIcon(IconData icon) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 22),
      );
    }

    Widget sectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.xs,
          right: AppSpacing.xs,
          bottom: AppSpacing.sm,
          top: AppSpacing.sm,
        ),
        child: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: finance.mutedText,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    Widget sectionCard(List<Widget> tiles) {
      final children = <Widget>[];
      for (var i = 0; i < tiles.length; i++) {
        children.add(tiles[i]);
        if (i < tiles.length - 1) {
          children.add(Divider(height: 1, color: theme.colorScheme.outline));
        }
      }
      return Card(child: Column(children: children));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.more)),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.of(context).pagePadding,
              vertical: AppSpacing.sm,
            ),
            children: [
              sectionTitle(l10n.sectionTools),
              sectionCard([
                ListTile(
                  leading: leadingIcon(Icons.calculate_outlined),
                  title: Text(l10n.calculator),
                  onTap: () => context.push('/more/calculator'),
                ),
                ListTile(
                  leading: leadingIcon(Icons.event_repeat),
                  title: Text(l10n.recurring),
                  onTap: () => context.push('/more/recurring'),
                ),
                ListTile(
                  leading: leadingIcon(Icons.notifications_outlined),
                  title: Text(l10n.reminders),
                  onTap: () => context.push('/more/reminders'),
                ),
                ListTile(
                  leading: leadingIcon(Icons.currency_exchange),
                  title: Text(l10n.currencyExchange),
                  subtitle: Text(
                    baseCurrency,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: finance.mutedText,
                    ),
                  ),
                  onTap: () => context.push('/more/currency'),
                ),
                ListTile(
                  leading: leadingIcon(Icons.pie_chart_outline),
                  title: Text(l10n.navAssetsLiabilities),
                  onTap: () => context.push('/more/assets'),
                ),
                ListTile(
                  leading: leadingIcon(Icons.category_outlined),
                  title: Text(l10n.categories),
                  onTap: () => context.push('/more/categories'),
                ),
                ListTile(
                  leading: leadingIcon(Icons.savings_outlined),
                  title: Text(l10n.budgets),
                  onTap: () => context.push('/more/budgets'),
                ),
                ListTile(
                  leading: leadingIcon(Icons.layers_outlined),
                  title: Text(l10n.walletGroups),
                  onTap: () => context.push('/wallets/groups'),
                ),
              ]),
              const SizedBox(height: AppSpacing.md),
              sectionTitle(l10n.sectionPreferences),
              sectionCard([
                ListTile(
                  leading: leadingIcon(Icons.language),
                  title: Text(l10n.language),
                  onTap: () => context.push('/more/language'),
                ),
                ListTile(
                  leading: leadingIcon(Icons.brightness_6_outlined),
                  title: Text(l10n.theme),
                  subtitle: Text(
                    switch (themeMode) {
                      ThemeMode.light => l10n.light,
                      ThemeMode.dark => l10n.dark,
                      ThemeMode.system => l10n.system,
                    },
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: finance.mutedText,
                    ),
                  ),
                  onTap: () async {
                    final selected = await showAdaptiveModal<ThemeMode>(
                      context: context,
                      dialogMaxWidth: 360,
                      builder: (ctx) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(l10n.system),
                              onTap: () => Navigator.pop(ctx, ThemeMode.system),
                            ),
                            ListTile(
                              title: Text(l10n.light),
                              onTap: () => Navigator.pop(ctx, ThemeMode.light),
                            ),
                            ListTile(
                              title: Text(l10n.dark),
                              onTap: () => Navigator.pop(ctx, ThemeMode.dark),
                            ),
                          ],
                        ),
                      ),
                    );
                    if (selected != null) {
                      ref.read(themeModeProvider.notifier).setMode(selected);
                    }
                  },
                ),
                ListTile(
                  leading: leadingIcon(Icons.bar_chart_outlined),
                  title: Text(l10n.statsSettings),
                  onTap: () => context.push('/more/stats-settings'),
                ),
              ]),
              const SizedBox(height: AppSpacing.md),
              sectionTitle(l10n.sectionSecurity),
              sectionCard([
                ListTile(
                  leading: leadingIcon(Icons.lock_outline),
                  title: Text(l10n.security),
                  subtitle: Text(
                    l10n.securitySubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: finance.mutedText,
                    ),
                  ),
                  onTap: () => context.push('/more/security'),
                ),
              ]),
              const SizedBox(height: AppSpacing.md),
              sectionTitle(l10n.sectionData),
              sectionCard([
                ListTile(
                  leading: leadingIcon(Icons.backup_outlined),
                  title: Text(l10n.backup),
                  subtitle: Text(
                    l10n.backupSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: finance.mutedText,
                    ),
                  ),
                  onTap: () => context.push('/more/backup'),
                ),
              ]),
              const SizedBox(height: AppSpacing.md),
              sectionTitle(l10n.sectionAbout),
              sectionCard([
                ListTile(
                  leading: leadingIcon(Icons.info_outline),
                  title: Text(l10n.about),
                  subtitle: Text(
                    l10n.aboutSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: finance.mutedText,
                    ),
                  ),
                  onTap: () => context.push('/more/about'),
                ),
              ]),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
