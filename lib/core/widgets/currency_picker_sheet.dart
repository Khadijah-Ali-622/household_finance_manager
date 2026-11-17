import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../currency/iso_currencies.dart';
import '../theme/app_theme.dart';
import 'adaptive_modal.dart';

Future<String?> showCurrencyPicker(
  BuildContext context, {
  String? selectedCode,
}) {
  return showAdaptiveModal<String>(
    context: context,
    dialogMaxWidth: 520,
    builder: (ctx) => _CurrencyPickerSheet(selectedCode: selectedCode),
  );
}

class _CurrencyPickerSheet extends StatefulWidget {
  const _CurrencyPickerSheet({this.selectedCode});

  final String? selectedCode;

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  final _search = TextEditingController();
  late List<CurrencyInfo> _results;

  @override
  void initState() {
    super.initState();
    _results = IsoCurrencies.search('');
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final popular = IsoCurrencies.popular();
    final query = _search.text.trim();
    final showPopular = query.isEmpty;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: l10n.searchCurrency,
                ),
                onChanged: (v) => setState(() {
                  _results = IsoCurrencies.search(v);
                }),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  if (showPopular) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screen,
                      ),
                      child: Text(
                        l10n.popularCurrencies,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    ...popular.map(_tile),
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screen,
                      ),
                      child: Text(
                        l10n.allCurrencies,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  ],
                  ..._results
                      .where((c) => !showPopular || !popular.contains(c))
                      .map(_tile),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _tile(CurrencyInfo c) {
    final selected = c.code == widget.selectedCode;
    return ListTile(
      title: Text('${c.code} — ${c.name}'),
      subtitle: Text('${c.symbol} · ${c.decimalDigits} dp'),
      trailing: selected ? const Icon(Icons.check) : null,
      onTap: () => Navigator.pop(context, c.code),
    );
  }
}
