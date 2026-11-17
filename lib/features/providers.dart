import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale/locale_settings.dart';
import '../core/notifications/notification_service.dart';
import '../data/db/app_database.dart';
import '../data/db/daos/transactions_dao.dart';
import '../data/db/seed/debug_seed.dart';
import '../data/repositories/asset_repository.dart';
import '../data/repositories/budget_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/dashboard_repository.dart';
import '../data/repositories/exchange_rate_repository.dart';
import '../data/repositories/liability_repository.dart';
import '../data/repositories/recurring_repository.dart';
import '../data/repositories/reminder_repository.dart';
import '../data/repositories/stats_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../data/repositories/wallet_group_repository.dart';
import '../data/repositories/wallet_repository.dart';
import '../data/services/budget_alert_service.dart';
import '../domain/models/asset.dart';
import '../domain/models/category.dart';
import '../domain/models/liability.dart';
import '../domain/models/recurring_rule.dart';
import '../domain/models/reminder.dart';
import '../domain/models/stats_models.dart';
import '../domain/models/transaction.dart';
import '../domain/models/wallet.dart';
import '../domain/models/wallet_group.dart';
import '../domain/services/budget_calculator.dart';
import '../domain/services/currency_converter.dart';
import '../domain/services/group_totals_calculator.dart';
import 'security/app_lock_controller.dart';
import 'stats/stats_state.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final seedReadyProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  try {
    await DebugSeed(db).runIfNeeded();
  } catch (e, st) {
    // Surface seed failures clearly in the flutter run terminal.
    // ignore: avoid_print
    print('DebugSeed failed: $e\n$st');
    rethrow;
  }
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(ref.watch(appDatabaseProvider));
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(ref.watch(appDatabaseProvider));
});

final recurringRepositoryProvider = Provider<RecurringRepository>((ref) {
  return RecurringRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(transactionRepositoryProvider),
  );
});

final recurringRulesProvider = StreamProvider<List<RecurringRule>>((
  ref,
) async* {
  await ref.watch(seedReadyProvider.future);
  yield* ref.watch(recurringRepositoryProvider).watchAll();
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(appDatabaseProvider));
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref.watch(appDatabaseProvider));
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(transactionRepositoryProvider),
  );
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final budgetAlertServiceProvider = Provider<BudgetAlertService>((ref) {
  return BudgetAlertService(
    ref.watch(budgetRepositoryProvider),
    ref.watch(reminderRepositoryProvider),
  );
});

/// Loads active reminders and schedules their local notifications.
/// On web this keeps the in-app lists and skips OS scheduling.
final syncReminderNotificationsProvider = Provider<Future<void> Function()>((
  ref,
) {
  return () async {
    final service = ref.read(notificationServiceProvider);
    final items = await ref.read(reminderRepositoryProvider).listActive();
    await service.rescheduleAll(items);
  };
});

final remindersProvider = StreamProvider<List<Reminder>>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  yield* ref.watch(reminderRepositoryProvider).watchAll();
});

final overdueRemindersProvider = StreamProvider<List<Reminder>>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  yield* ref.watch(reminderRepositoryProvider).watchOverdue();
});

final dueSoonRemindersProvider = StreamProvider<List<Reminder>>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  yield* ref.watch(reminderRepositoryProvider).watchDueSoon();
});

final budgetMonthProvider = NotifierProvider<BudgetMonthNotifier, int>(
  BudgetMonthNotifier.new,
);

class BudgetMonthNotifier extends Notifier<int> {
  @override
  int build() => BudgetCalculator.yearMonthOf(DateTime.now());

  void shift(int delta) {
    state = BudgetCalculator.shiftMonth(state, delta);
  }
}

final budgetsForMonthProvider =
    StreamProvider.family<List<BudgetWithProgress>, int>((
      ref,
      yearMonth,
    ) async* {
      await ref.watch(seedReadyProvider.future);
      final repo = ref.watch(budgetRepositoryProvider);
      await repo.ensureMonthBudgets(yearMonth);
      yield* repo.watchBudgetsForMonth(yearMonth);
    });

final walletGroupRepositoryProvider = Provider<WalletGroupRepository>((ref) {
  return WalletGroupRepository(ref.watch(appDatabaseProvider));
});

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  return AssetRepository(ref.watch(appDatabaseProvider));
});

final liabilityRepositoryProvider = Provider<LiabilityRepository>((ref) {
  return LiabilityRepository(ref.watch(appDatabaseProvider));
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(
    wallets: ref.watch(walletRepositoryProvider),
    transactions: ref.watch(transactionRepositoryProvider),
    assets: ref.watch(assetRepositoryProvider),
    liabilities: ref.watch(liabilityRepositoryProvider),
  );
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository(
    transactions: ref.watch(transactionRepositoryProvider),
  );
});

final walletsProvider = StreamProvider<List<Wallet>>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  yield* ref.watch(walletRepositoryProvider).watchActiveWithBalances();
});

final allWalletsProvider = StreamProvider<List<Wallet>>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  yield* ref.watch(walletRepositoryProvider).watchAllWithBalances();
});

final categoriesProvider = StreamProvider<List<Category>>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  yield* ref.watch(categoryRepositoryProvider).watchAll();
});

final transactionFilterProvider =
    NotifierProvider<TransactionFilterNotifier, TransactionFilter>(
      TransactionFilterNotifier.new,
    );

class TransactionFilterNotifier extends Notifier<TransactionFilter> {
  @override
  TransactionFilter build() => const TransactionFilter();

  void update(TransactionFilter filter) => state = filter;

  void clear() => state = const TransactionFilter();
}

final transactionsProvider = StreamProvider<List<Transaction>>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  final filter = ref.watch(transactionFilterProvider);
  yield* ref.watch(transactionRepositoryProvider).watchFiltered(filter);
});

final walletGroupsProvider = StreamProvider<List<WalletGroup>>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  yield* ref.watch(walletGroupRepositoryProvider).watchGroups();
});

final assetsProvider = StreamProvider<List<Asset>>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  yield* ref.watch(assetRepositoryProvider).watchAll();
});

final liabilitiesProvider = StreamProvider<List<Liability>>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  yield* ref.watch(liabilityRepositoryProvider).watchAll();
});

final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>((ref) {
  return ExchangeRateRepository(ref.watch(appDatabaseProvider));
});

final currencyConverterProvider = StreamProvider<CurrencyConverter>((
  ref,
) async* {
  final base = ref.watch(baseCurrencyProvider);
  final repo = ref.watch(exchangeRateRepositoryProvider);
  await repo.seedDefaultsIfEmpty(base);
  yield* repo.watchConverter(base);
});

final dashboardProvider = StreamProvider<DashboardSnapshot>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  final base = ref.watch(baseCurrencyProvider);
  final converterAsync = ref.watch(currencyConverterProvider);
  if (!converterAsync.hasValue) {
    // Wait for first converter emission without hanging forever.
    final converter = await ref.watch(currencyConverterProvider.future);
    yield* ref
        .watch(dashboardRepositoryProvider)
        .watch(baseCurrency: base, converter: converter);
    return;
  }
  yield* ref
      .watch(dashboardRepositoryProvider)
      .watch(baseCurrency: base, converter: converterAsync.requireValue);
});

final statsSnapshotProvider = StreamProvider<StatsSnapshot>((ref) async* {
  await ref.watch(seedReadyProvider.future);
  final ui = ref.watch(statsUiProvider);
  final categories = await ref.watch(categoriesProvider.future);
  final wallets = await ref.watch(walletsProvider.future);
  final base = ref.watch(baseCurrencyProvider);
  final converterAsync = ref.watch(currencyConverterProvider);
  final converter = converterAsync.hasValue
      ? converterAsync.requireValue
      : await ref.watch(currencyConverterProvider.future);
  final query = StatsQuery(
    range: ui.range,
    flow: ui.flow,
    periodKind: ui.periodKind,
    walletIds: ui.walletIds,
  );
  yield* ref
      .watch(statsRepositoryProvider)
      .watch(
        query: query,
        categories: categories,
        wallets: wallets,
        baseCurrency: base,
        converter: converter,
      );
});

final groupTotalsCalculatorProvider = Provider<GroupTotalsCalculator>((ref) {
  return GroupTotalsCalculator();
});

/// Erases local DB + PIN (Forgot PIN reset). Re-seeds default categories.
final eraseLocalDataProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final db = ref.read(appDatabaseProvider);
    await db.eraseAllData();
    await DebugSeed(db).runIfNeeded();
    await ref.read(appLockProvider.notifier).clearAfterDataErase();
  };
});
