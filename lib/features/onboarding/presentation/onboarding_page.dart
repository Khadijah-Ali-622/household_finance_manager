import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/locale/locale_settings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/currency_picker_sheet.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final Locale _deviceLocale;
  Locale? _locale;
  late String _currency;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    _currency = defaultCurrencyForDeviceLocale(_deviceLocale);
  }

  String get _deviceLanguageLabel {
    final code = _deviceLocale.languageCode;
    if (isSupportedLanguageCode(code)) return languageDisplayName(code);
    return languageDisplayName('en');
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(localeProvider.notifier).setLocale(_locale);
      await ref.read(baseCurrencyProvider.notifier).setCurrency(_currency);
      await ref
          .read(exchangeRateRepositoryProvider)
          .seedDefaultsIfEmpty(_currency);
      await ref.read(onboardingDoneProvider.notifier).complete();
      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);

    final languages = <({String title, String? subtitle, Locale? value})>[
      (
        title: l10n.useDeviceLanguage,
        subtitle: _deviceLanguageLabel,
        value: null,
      ),
      for (final supported in appSupportedLocales)
        (
          title: languageDisplayName(supported.languageCode),
          subtitle: null,
          value: supported,
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.onboardingTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.sm,
          AppSpacing.screen,
          AppSpacing.xxl,
        ),
        children: [
          Text(
            l10n.onboardingSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: finance.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          Text(l10n.chooseLanguage, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < languages.length; i++) ...[
                  if (i > 0)
                    Divider(height: 1, color: theme.colorScheme.outline),
                  ListTile(
                    title: Text(languages[i].title),
                    subtitle: languages[i].subtitle == null
                        ? null
                        : Text(
                            languages[i].subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: finance.mutedText,
                            ),
                          ),
                    trailing: _isSelected(languages[i].value)
                        ? Icon(Icons.check, color: theme.colorScheme.primary)
                        : null,
                    onTap: () => setState(() => _locale = languages[i].value),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          Text(l10n.chooseCurrency, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: ListTile(
              title: Text(l10n.baseCurrency),
              subtitle: Text(currencyLabel(_currency)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final picked = await showCurrencyPicker(
                  context,
                  selectedCode: _currency,
                );
                if (picked != null && mounted) {
                  setState(() => _currency = picked);
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.sm,
            AppSpacing.screen,
            AppSpacing.screen,
          ),
          child: FilledButton(
            onPressed: _saving ? null : _finish,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppSpacing.buttonMinHeight),
            ),
            child: _saving
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : Text(l10n.getStarted),
          ),
        ),
      ),
    );
  }

  bool _isSelected(Locale? value) {
    if (value == null) return _locale == null;
    return _locale?.languageCode == value.languageCode;
  }
}
