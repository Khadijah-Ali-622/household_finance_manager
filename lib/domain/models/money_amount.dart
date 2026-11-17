/// Money stored as integer minor units. Never use doubles for money storage.
class MoneyAmount implements Comparable<MoneyAmount> {
  const MoneyAmount(this.minorUnits);

  final int minorUnits;

  static const zero = MoneyAmount(0);

  /// Parses a major-unit string like "1,250.50" or "1250.5" into minor units.
  factory MoneyAmount.fromMajorString(String input, {int fractionDigits = 2}) {
    final cleaned = input.replaceAll(',', '').trim();
    if (cleaned.isEmpty) return MoneyAmount.zero;
    final negative = cleaned.startsWith('-');
    final raw = negative ? cleaned.substring(1) : cleaned;
    final parts = raw.split('.');
    final whole = int.tryParse(parts[0].isEmpty ? '0' : parts[0]) ?? 0;
    var fraction = 0;
    if (parts.length > 1 && fractionDigits > 0) {
      final fracRaw =
          parts[1].padRight(fractionDigits, '0').substring(0, fractionDigits);
      fraction = int.tryParse(fracRaw) ?? 0;
    }
    final sign = negative ? -1 : 1;
    return MoneyAmount(sign * (whole * factor(fractionDigits) + fraction));
  }

  factory MoneyAmount.fromMajor(num major, {int fractionDigits = 2}) {
    final f = factor(fractionDigits);
    final sign = major < 0 ? -1 : 1;
    final abs = major.abs();
    final whole = abs.floor();
    final frac = ((abs - whole) * f).round();
    return MoneyAmount(sign * (whole * f + frac));
  }

  static int factor(int fractionDigits) {
    var f = 1;
    for (var i = 0; i < fractionDigits; i++) {
      f *= 10;
    }
    return f;
  }

  /// Major units for the given ISO decimal digits (display / charts only).
  double toMajor(int fractionDigits) =>
      minorUnits / factor(fractionDigits).toDouble();

  /// Legacy helper assuming 2 decimal places (PKR/USD). Prefer [toMajor].
  double get asMajor => toMajor(2);

  MoneyAmount operator +(MoneyAmount other) =>
      MoneyAmount(minorUnits + other.minorUnits);

  MoneyAmount operator -(MoneyAmount other) =>
      MoneyAmount(minorUnits - other.minorUnits);

  MoneyAmount operator -() => MoneyAmount(-minorUnits);

  bool get isNegative => minorUnits < 0;
  bool get isZero => minorUnits == 0;

  @override
  int compareTo(MoneyAmount other) => minorUnits.compareTo(other.minorUnits);

  @override
  bool operator ==(Object other) =>
      other is MoneyAmount && other.minorUnits == minorUnits;

  @override
  int get hashCode => minorUnits.hashCode;

  @override
  String toString() => 'MoneyAmount($minorUnits)';
}
