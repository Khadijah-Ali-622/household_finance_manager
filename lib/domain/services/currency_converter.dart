import 'package:decimal/decimal.dart';

import '../../core/currency/iso_currencies.dart';
import '../models/money_amount.dart';

/// Exchange rate: 1 major unit of [from] equals [rate] major units of [to].
class ExchangeRate {
  const ExchangeRate({
    required this.from,
    required this.to,
    required this.rate,
    required this.updatedAt,
  });

  final String from;
  final String to;
  final Decimal rate;
  final DateTime updatedAt;
}

/// Converts money between currencies using integer minor units + Decimal rates.
class CurrencyConverter {
  CurrencyConverter({
    required this.baseCurrency,
    List<ExchangeRate> rates = const [],
  }) : _rates = {
          for (final r in rates) _key(r.from, r.to): r,
        };

  final String baseCurrency;
  final Map<String, ExchangeRate> _rates;

  static String _key(String from, String to) =>
      '${from.toUpperCase()}_${to.toUpperCase()}';

  void upsertRate(ExchangeRate rate) {
    _rates[_key(rate.from, rate.to)] = rate;
  }

  Decimal? rateFor(String from, String to) {
    final f = from.toUpperCase();
    final t = to.toUpperCase();
    if (f == t) return Decimal.one;

    final direct = _rates[_key(f, t)];
    if (direct != null) return direct.rate;

    final inverse = _rates[_key(t, f)];
    if (inverse != null && inverse.rate != Decimal.zero) {
      return (Decimal.one / inverse.rate)
          .toDecimal(scaleOnInfinitePrecision: 12);
    }

    final base = baseCurrency.toUpperCase();
    if (f != base && t != base) {
      final toBase = rateFor(f, base);
      final fromBase = rateFor(base, t);
      if (toBase != null && fromBase != null) {
        return toBase * fromBase;
      }
    }
    return null;
  }

  /// Converts [amount] from [fromCurrency] into [toCurrency] minor units.
  /// Returns null if no rate path exists (except same-currency).
  MoneyAmount? convert({
    required MoneyAmount amount,
    required String fromCurrency,
    required String toCurrency,
  }) {
    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();
    if (from == to) return amount;

    final rate = rateFor(from, to);
    if (rate == null) return null;

    final fromDigits = IsoCurrencies.decimalDigits(from);
    final toDigits = IsoCurrencies.decimalDigits(to);
    final fromFactor = Decimal.fromInt(_factor(fromDigits));
    final toFactor = Decimal.fromInt(_factor(toDigits));

    final major = (Decimal.fromInt(amount.minorUnits) / fromFactor)
        .toDecimal(scaleOnInfinitePrecision: 16);
    final convertedMajor = major * rate;
    final toMinorDec = convertedMajor * toFactor;
    return MoneyAmount(_roundDecimal(toMinorDec));
  }

  /// Converts to base currency; missing rates treated as zero when [strict] is
  /// false (default), so totals still render offline with partial rates.
  MoneyAmount toBase(
    MoneyAmount amount,
    String currency, {
    bool strict = false,
  }) {
    final converted = convert(
      amount: amount,
      fromCurrency: currency,
      toCurrency: baseCurrency,
    );
    if (converted != null) return converted;
    if (strict) {
      throw StateError('No exchange rate for $currency → $baseCurrency');
    }
    return MoneyAmount.zero;
  }

  DateTime? get lastUpdated {
    if (_rates.isEmpty) return null;
    return _rates.values
        .map((r) => r.updatedAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }

  static int _factor(int digits) {
    var f = 1;
    for (var i = 0; i < digits; i++) {
      f *= 10;
    }
    return f;
  }

  static int _roundDecimal(Decimal value) {
    // Half-away-from-zero via Decimal round.
    final rounded = value.round(scale: 0);
    return rounded.toBigInt().toInt();
  }
}
