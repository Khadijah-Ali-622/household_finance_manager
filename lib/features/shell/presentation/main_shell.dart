import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final destinations = <({IconData icon, IconData selected, String label})>[
      (
        icon: Icons.dashboard_outlined,
        selected: Icons.dashboard,
        label: l10n.navDashboard,
      ),
      (
        icon: Icons.receipt_long_outlined,
        selected: Icons.receipt_long,
        label: l10n.navTransactions,
      ),
      (
        icon: Icons.insights_outlined,
        selected: Icons.insights,
        label: l10n.navStats,
      ),
      (
        icon: Icons.account_balance_wallet_outlined,
        selected: Icons.account_balance_wallet,
        label: l10n.navWallets,
      ),
      (
        icon: Icons.more_horiz,
        selected: Icons.more_horiz,
        label: l10n.navMore,
      ),
    ];

    return ResponsiveBuilder(
      builder: (context, responsive) {
        if (responsive.isMobile) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outline),
                ),
                boxShadow: AppShadows.forBrightness(theme.brightness)
                    .map(
                      (s) => BoxShadow(
                        color: s.color,
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    )
                    .toList(),
              ),
              child: NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _goBranch,
                destinations: [
                  for (final d in destinations)
                    NavigationDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selected),
                      label: d.label,
                    ),
                ],
              ),
            ),
          );
        }

        // Tablet: compact rail. Desktop: expanded side menu.
        final extended = responsive.isDesktop;
        return Scaffold(
          body: Row(
            children: [
              _SideNav(
                extended: extended,
                selectedIndex: navigationShell.currentIndex,
                destinations: destinations,
                onSelect: _goBranch,
              ),
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: theme.colorScheme.outline,
              ),
              Expanded(child: navigationShell),
            ],
          ),
        );
      },
    );
  }
}

class _SideNav extends StatelessWidget {
  const _SideNav({
    required this.extended,
    required this.selectedIndex,
    required this.destinations,
    required this.onSelect,
  });

  final bool extended;
  final int selectedIndex;
  final List<({IconData icon, IconData selected, String label})> destinations;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);

    if (!extended) {
      return NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onSelect,
        labelType: NavigationRailLabelType.all,
        minWidth: 80,
        destinations: [
          for (final d in destinations)
            NavigationRailDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selected),
              label: Text(d.label),
            ),
        ],
      );
    }

    // Expanded desktop side menu with hover + keyboard focus.
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      child: SizedBox(
        width: 240,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  'Household Finance',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    final d = destinations[index];
                    final selected = index == selectedIndex;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ListTile(
                          selected: selected,
                          selectedTileColor: theme.colorScheme.primary
                              .withValues(alpha: 0.12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: Icon(
                            selected ? d.selected : d.icon,
                            color: selected
                                ? theme.colorScheme.primary
                                : finance.mutedText,
                          ),
                          title: Text(
                            d.label,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          minVerticalPadding: 12,
                          onTap: () => onSelect(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
