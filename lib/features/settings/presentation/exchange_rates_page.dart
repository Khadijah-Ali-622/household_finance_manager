import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/locale/locale_settings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../domain/services/currency_converter.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';

final _exchangeRatesProvider = StreamProvider<List<ExchangeRate>>((ref) {
  return ref.watch(exchangeRateRepositoryProvider).watchAll();
});

class ExchangeRatesPage extends ConsumerWidget {
  const ExchangeRatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final base = ref.watch(baseCurrencyProvider);
    final ratesAsync = ref.watch(_exchangeRatesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.exchangeRates)),
      body: ratesAsync.when(
        loading: () => LoadingState(message: l10n.loading),
        error: (e, st) => AsyncErrorView(error: e, stackTrace: st),
        data: (rates) {
          final visible = rates.where((r) => r.from != r.to).toList()
            ..sort((a, b) {
              final aRank = a.from == base ? 0 : 1;
              final bRank = b.from == base ? 0 : 1;
              final byBase = aRank.compareTo(bRank);
              if (byBase != 0) return byBase;
              final byFrom = a.from.compareTo(b.from);
              if (byFrom != 0) return byFrom;
              return a.to.compareTo(b.to);
            });
          if (visible.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Text(
                  l10n.noExchangeRate,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: finance.mutedText,
                  ),
                ),
              ),
            );
          }
          final locale = Localizations.localeOf(context).toString();
          final dateFmt = DateFormat.yMMMd(locale);
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: visible.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: theme.colorScheme.outline),
            itemBuilder: (context, index) {
              final rate = visible[index];
              return ListTile(
                title: Text('1 ${rate.from} = ${rate.rate} ${rate.to}'),
                subtitle: Text(
                  dateFmt.format(rate.updatedAt.toLocal()),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: finance.mutedText,
                  ),
                ),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => _editRate(context, ref, rate),
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> _editRate(
  BuildContext context,
  WidgetRef ref,
  ExchangeRate rate,
) async {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController(text: rate.rate.toString());
  final parsed = await showDialog<Decimal>(
    context: context,
    builder: (ctx) {
      String? errorText;
      return StatefulBuilder(
        builder: (context, setLocal) {
          return AlertDialog(
            title: Text(l10n.editRate),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('${l10n.fromCurrency}: ${rate.from}'),
                const SizedBox(height: AppSpacing.xs),
                Text('${l10n.toCurrency}: ${rate.to}'),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.rate,
                    errorText: errorText,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () {
                  final raw = controller.text.trim().replaceAll(',', '');
                  final value = Decimal.tryParse(raw);
                  if (value == null) {
                    setLocal(() {
                      errorText = l10n.fieldRequired;
                    });
                    return;
                  }
                  if (value <= Decimal.zero) {
                    setLocal(() {
                      errorText = l10n.amountMustBePositive;
                    });
                    return;
                  }
                  Navigator.pop(ctx, value);
                },
                child: Text(l10n.save),
              ),
            ],
          );
        },
      );
    },
  );
  controller.dispose();
  if (parsed == null || !context.mounted) return;
  await ref
      .read(exchangeRateRepositoryProvider)
      .saveRate(from: rate.from, to: rate.to, rate: parsed);
}
