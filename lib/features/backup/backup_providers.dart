import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/backup/backup_coordinator.dart';
import '../../data/backup/backup_repository.dart';
import '../../data/backup/backup_settings.dart';
import '../../data/backup/drive_backup_service.dart';
import '../../data/backup/local_backup_service.dart';
import '../../domain/enums/stats_period_kind.dart';
import '../providers.dart';
import '../stats/stats_state.dart';
import '../../core/locale/locale_settings.dart';

final backupSettingsProvider = Provider<BackupSettings>((ref) {
  return BackupSettings(ref.watch(sharedPreferencesProvider));
});

final localBackupServiceProvider = Provider<LocalBackupService>((ref) {
  return LocalBackupService();
});

final driveBackupServiceProvider = Provider<DriveBackupService>((ref) {
  return DriveBackupService();
});

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(sharedPreferencesProvider),
  );
});

final backupCoordinatorProvider = Provider<BackupCoordinator>((ref) {
  return BackupCoordinator(
    repository: ref.watch(backupRepositoryProvider),
    settings: ref.watch(backupSettingsProvider),
    local: ref.watch(localBackupServiceProvider),
    drive: ref.watch(driveBackupServiceProvider),
  );
});

void refreshFinanceProviders(WidgetRef ref) {
  ref.invalidate(walletsProvider);
  ref.invalidate(allWalletsProvider);
  ref.invalidate(categoriesProvider);
  ref.invalidate(transactionsProvider);
  ref.invalidate(walletGroupsProvider);
  ref.invalidate(assetsProvider);
  ref.invalidate(liabilitiesProvider);
  ref.invalidate(recurringRulesProvider);
  ref.invalidate(budgetsForMonthProvider);
  ref.invalidate(currencyConverterProvider);
  ref.invalidate(dashboardProvider);
  ref.invalidate(statsSnapshotProvider);
}

Future<void> applyReplacedSettings(WidgetRef ref, Map<String, dynamic> settings) async {
  final locale = settings[kPrefLocale];
  if (locale is String && locale.isNotEmpty && locale != 'system') {
    await ref.read(localeProvider.notifier).setLocale(Locale(locale));
  } else {
    await ref.read(localeProvider.notifier).setLocale(null);
  }
  final currency = settings[kPrefBaseCurrency];
  await ref.read(baseCurrencyProvider.notifier).setCurrency(
        currency is String && currency.isNotEmpty ? currency : 'PKR',
      );
  await ref.read(nativeDigitsProvider.notifier).setEnabled(
        settings[kPrefNativeDigits] == true,
      );
  final onboard = settings[kPrefOnboardingDone];
  await ref.read(onboardingDoneProvider.notifier).setDone(onboard != false);
  await ref.read(statsUiProvider.notifier).setChartType(
        settings[kPrefStatsChartType] == 'bar'
            ? StatsChartType.bar
            : StatsChartType.pie,
      );
  final week = settings[kPrefWeekStartsMonday];
  await ref.read(statsUiProvider.notifier).setWeekStartsOnMonday(
        week is bool ? week : true,
      );
}
