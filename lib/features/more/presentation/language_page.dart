import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class LanguagePage extends ConsumerWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final theme = Theme.of(context);

    final options = <({String title, Locale? value})>[
      (title: l10n.useDeviceLanguage, value: null),
      for (final supported in appSupportedLocales)
        (title: languageDisplayName(supported.languageCode), value: supported),
    ];

    Widget tile({
      required String title,
      required Locale? value,
      required bool selected,
    }) {
      return ListTile(
        title: Text(title),
        trailing: selected
            ? Icon(Icons.check, color: theme.colorScheme.primary)
            : null,
        onTap: () => ref.read(localeProvider.notifier).setLocale(value),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.language)),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.sm,
        ),
        children: [
          Card(
            child: Column(
              children: [
                for (var i = 0; i < options.length; i++) ...[
                  if (i > 0)
                    Divider(height: 1, color: theme.colorScheme.outline),
                  tile(
                    title: options[i].title,
                    value: options[i].value,
                    selected: options[i].value == null
                        ? locale == null
                        : locale?.languageCode ==
                              options[i].value!.languageCode,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
