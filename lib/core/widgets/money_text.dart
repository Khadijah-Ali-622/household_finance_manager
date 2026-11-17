import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/models/money_amount.dart';
import '../locale/locale_settings.dart';
import '../theme/app_theme.dart';
import '../utils/money.dart';

class MoneyText extends ConsumerWidget {
  const MoneyText(
    this.amount, {
    super.key,
    this.style,
    this.currencyCode = 'PKR',
    this.colorize = false,
    this.locale,
    this.useNativeDigits,
    this.maxLines = 1,
    this.softWrap = false,
    this.textAlign,
  });

  final MoneyAmount amount;
  final TextStyle? style;
  final String currencyCode;
  final bool colorize;

  /// Overrides the locale used for grouping and native digits.
  /// When null, the active app locale is used.
  final Locale? locale;

  /// Overrides the native-digits setting.
  /// When null, [nativeDigitsProvider] is used.
  final bool? useNativeDigits;

  final int? maxLines;
  final bool softWrap;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = FinanceColors.of(context);
    final fromSettings = ref.watch(nativeDigitsProvider);
    final localeName = (locale ?? Localizations.localeOf(context)).toString();
    final formatted = MoneyFormatter(
      currencyCode: currencyCode,
      locale: localeName,
      useNativeDigits: useNativeDigits ?? fromSettings,
    ).format(amount);
    Color? color;
    if (colorize) {
      if (amount.isNegative) {
        color = finance.expense;
      } else if (!amount.isZero) {
        color = finance.income;
      }
    }
    final text = Text(
      formatted,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: TextOverflow.ellipsis,
      style: (style ?? theme.textTheme.titleMedium)?.copyWith(
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );

    // Scale down large amounts in tight trailing slots instead of overflowing.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: textAlign == TextAlign.center
          ? Alignment.center
          : AlignmentDirectional.centerEnd,
      child: text,
    );
  }
}
