import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/locale/locale_settings.dart';
import '../../features/assets_liabilities/presentation/asset_form_page.dart';
import '../../features/budgets/presentation/budget_form_page.dart';
import '../../features/budgets/presentation/budgets_page.dart';
import '../../features/assets_liabilities/presentation/assets_liabilities_page.dart';
import '../../features/assets_liabilities/presentation/liability_form_page.dart';
import '../../features/calculator/presentation/calculator_page.dart';
import '../../features/categories/presentation/categories_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/about/presentation/about_page.dart';
import '../../features/backup/presentation/backup_page.dart';
import '../../features/more/presentation/language_page.dart';
import '../../features/more/presentation/more_page.dart';
import '../../features/more/presentation/stats_settings_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/recurring/presentation/recurring_form_page.dart';
import '../../features/recurring/presentation/recurring_page.dart';
import '../../features/reminders/presentation/reminder_form_page.dart';
import '../../features/reminders/presentation/reminders_page.dart';
import '../../features/security/presentation/security_page.dart';
import '../../features/settings/presentation/currency_settings_page.dart';
import '../../features/settings/presentation/exchange_rates_page.dart';
import '../../features/shell/presentation/main_shell.dart';
import '../../features/stats/presentation/stats_page.dart';
import '../../features/transactions/presentation/transaction_form_page.dart';
import '../../features/transactions/presentation/transactions_page.dart';
import '../../features/wallet_groups/presentation/combined_view_page.dart';
import '../../features/wallet_groups/presentation/group_form_page.dart';
import '../../features/wallet_groups/presentation/groups_page.dart';
import '../../features/wallet_groups/presentation/quick_select_page.dart';
import '../../features/wallets/presentation/wallet_form_page.dart';
import '../../features/wallets/presentation/wallets_page.dart';

final _rootKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen<bool>(onboardingDoneProvider, (previous, next) {
    refresh.value++;
  });

  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: ref.read(onboardingDoneProvider)
        ? '/dashboard'
        : '/onboarding',
    refreshListenable: refresh,
    redirect: (context, state) {
      final done = ref.read(onboardingDoneProvider);
      final onOnboarding = state.matchedLocation == '/onboarding';
      if (!done && !onOnboarding) return '/onboarding';
      if (done && onOnboarding) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionsPage(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const TransactionFormPage(),
                  ),
                  GoRoute(
                    path: 'edit/:id',
                    builder: (context, state) => TransactionFormPage(
                      transactionId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/stats',
                builder: (context, state) => const StatsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallets',
                builder: (context, state) => const WalletsPage(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const WalletFormPage(),
                  ),
                  GoRoute(
                    path: 'edit/:id',
                    builder: (context, state) =>
                        WalletFormPage(walletId: state.pathParameters['id']),
                  ),
                  GoRoute(
                    path: 'groups',
                    builder: (context, state) => const GroupsPage(),
                    routes: [
                      GoRoute(
                        path: 'add',
                        builder: (context, state) => const GroupFormPage(),
                      ),
                      GoRoute(
                        path: 'edit/:id',
                        builder: (context, state) =>
                            GroupFormPage(groupId: state.pathParameters['id']),
                      ),
                      GoRoute(
                        path: 'view/:id',
                        builder: (context, state) => CombinedViewPage(
                          groupId: state.pathParameters['id'],
                        ),
                      ),
                      GoRoute(
                        path: 'quick',
                        builder: (context, state) => const QuickSelectPage(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (context, state) => const MorePage(),
                routes: [
                  GoRoute(
                    path: 'categories',
                    builder: (context, state) => const CategoriesPage(),
                  ),
                  GoRoute(
                    path: 'budgets',
                    builder: (context, state) => const BudgetsPage(),
                    routes: [
                      GoRoute(
                        path: 'add',
                        builder: (context, state) => BudgetFormPage(
                          yearMonth: int.tryParse(
                            state.uri.queryParameters['month'] ?? '',
                          ),
                        ),
                      ),
                      GoRoute(
                        path: 'edit/:id',
                        builder: (context, state) => BudgetFormPage(
                          budgetId: state.pathParameters['id'],
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'calculator',
                    builder: (context, state) => const CalculatorPage(),
                  ),
                  GoRoute(
                    path: 'recurring',
                    builder: (context, state) => const RecurringPage(),
                    routes: [
                      GoRoute(
                        path: 'add',
                        builder: (context, state) => const RecurringFormPage(),
                      ),
                      GoRoute(
                        path: 'edit/:id',
                        builder: (context, state) => RecurringFormPage(
                          ruleId: state.pathParameters['id'],
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'reminders',
                    builder: (context, state) => const RemindersPage(),
                    routes: [
                      GoRoute(
                        path: 'add',
                        builder: (context, state) => const ReminderFormPage(),
                      ),
                      GoRoute(
                        path: 'edit/:id',
                        builder: (context, state) => ReminderFormPage(
                          reminderId: state.pathParameters['id'],
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'security',
                    builder: (context, state) => const SecurityPage(),
                  ),
                  GoRoute(
                    path: 'language',
                    builder: (context, state) => const LanguagePage(),
                  ),
                  GoRoute(
                    path: 'stats-settings',
                    builder: (context, state) => const StatsSettingsPage(),
                  ),
                  GoRoute(
                    path: 'currency',
                    builder: (context, state) => const CurrencySettingsPage(),
                    routes: [
                      GoRoute(
                        path: 'rates',
                        builder: (context, state) => const ExchangeRatesPage(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'backup',
                    builder: (context, state) => const BackupPage(),
                  ),
                  GoRoute(
                    path: 'about',
                    builder: (context, state) => const AboutPage(),
                  ),
                  GoRoute(
                    path: 'assets',
                    builder: (context, state) => const AssetsLiabilitiesPage(),
                    routes: [
                      GoRoute(
                        path: 'asset/add',
                        builder: (context, state) => const AssetFormPage(),
                      ),
                      GoRoute(
                        path: 'asset/edit/:id',
                        builder: (context, state) =>
                            AssetFormPage(assetId: state.pathParameters['id']),
                      ),
                      GoRoute(
                        path: 'liability/add',
                        builder: (context, state) => const LiabilityFormPage(),
                      ),
                      GoRoute(
                        path: 'liability/edit/:id',
                        builder: (context, state) => LiabilityFormPage(
                          liabilityId: state.pathParameters['id'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
