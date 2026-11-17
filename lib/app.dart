import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart' hide GlobalMaterialLocalizations;

import 'core/locale/app_fonts.dart';
import 'core/locale/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/backup/presentation/backup_lifecycle.dart';
import 'features/recurring/recurring_lifecycle.dart';
import 'features/security/presentation/app_lock_gate.dart';
import 'l10n/app_localizations.dart';

class HouseholdFinanceApp extends ConsumerWidget {
  const HouseholdFinanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final fontsLocale = effectiveLocale(locale, deviceLocale);

    return MaterialApp.router(
      title: 'Household Finance Manager',
      theme: AppFonts.applyToTheme(AppTheme.light(), fontsLocale),
      darkTheme: AppFonts.applyToTheme(AppTheme.dark(), fontsLocale),
      themeMode: themeMode,
      locale: locale,
      localeResolutionCallback: (device, _) {
        return effectiveLocale(locale, device ?? deviceLocale);
      },
      routerConfig: router,
      builder: (context, child) {
        return RecurringLifecycle(
          child: BackupLifecycle(
            child: AppLockGate(child: child ?? const SizedBox.shrink()),
          ),
        );
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
