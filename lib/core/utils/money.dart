import 'package:intl/intl.dart';

import '../../domain/models/money_amount.dart';
import '../currency/iso_currencies.dart';

/// Formats minor-unit money using ISO decimal digits and locale patterns.
class MoneyFormatter {
  MoneyFormatter({
    this.currencyCode = 'PKR',
    this.locale = 'en',
    this.useNativeDigits = false,
  });

  final String currencyCode;
  final String locale;
  final bool useNativeDigits;

  int get decimalDigits => IsoCurrencies.decimalDigits(currencyCode);

  String get symbol =>
      IsoCurrencies.byCode(currencyCode)?.symbol ?? currencyCode;

  String get _numberLocale {
    if (useNativeDigits) return locale;
    if (currencyCode == 'PKR' || currencyCode == 'INR') {
      if (locale.startsWith('en') ||
          locale.startsWith('ur') ||
          locale.startsWith('hi')) {
        return 'en_IN';
      }
    }
    if (locale.startsWith('ar') ||
        locale.startsWith('ur') ||
        locale.startsWith('hi') ||
        locale.startsWith('bn')) {
      return 'en';
    }
    return locale;
  }

  String format(MoneyAmount amount, {bool withSymbol = true}) {
    final major = amount.toMajor(decimalDigits);
    final num = NumberFormat.decimalPatternDigits(
      locale: _numberLocale,
      decimalDigits: decimalDigits,
    ).format(major);

    if (!withSymbol) return num;

    if (currencyCode == 'PKR' &&
        (locale.startsWith('en') ||
            locale == 'en_PK' ||
            locale.startsWith('ur'))) {
      return 'Rs $num';
    }

    // Symbol before/after roughly follows LTR default; RTL layouts mirror.
    return '$symbol $num';
  }

  /// Formats for TextField editing (no currency symbol).
  String formatForInput(MoneyAmount amount) {
    final digits = decimalDigits;
    final f = MoneyAmount.factor(digits);
    if (digits == 0 || amount.minorUnits % f == 0) {
      return (amount.minorUnits ~/ f).toString();
    }
    return amount.toMajor(digits).toStringAsFixed(digits);
  }
}
