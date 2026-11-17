import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/models/money_amount.dart';
import 'package:household_finance_manager/domain/services/currency_converter.dart';

void main() {
  group('currency decimals', () {
    test('JPY uses 0 decimal digits in parsing', () {
      final yen = MoneyAmount.fromMajorString('1500', fractionDigits: 0);
      expect(yen.minorUnits, 1500);
      expect(yen.toMajor(0), 1500);
    });

    test('KWD uses 3 decimal digits in parsing', () {
      final kwd = MoneyAmount.fromMajorString('1.250', fractionDigits: 3);
      expect(kwd.minorUnits, 1250);
      expect(kwd.toMajor(3), 1.25);
    });
  });

  group('conversion to base', () {
    final converter = CurrencyConverter(
      baseCurrency: 'PKR',
      rates: [
        ExchangeRate(
          from: 'USD',
          to: 'PKR',
          rate: Decimal.parse('280'),
          updatedAt: DateTime(2026, 1, 1),
        ),
        ExchangeRate(
          from: 'JPY',
          to: 'PKR',
          rate: Decimal.parse('1.85'),
          updatedAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    test('converts USD to PKR with 2dp rounding', () {
      // $10.00 → 2800.00 PKR → 280000 paisa
      final pkr = converter.convert(
        amount: const MoneyAmount(1000),
        fromCurrency: 'USD',
        toCurrency: 'PKR',
      );
      expect(pkr!.minorUnits, 280000);
    });

    test('converts JPY (0dp) to PKR', () {
      // ¥100 → 185.00 PKR → 18500 paisa
      final pkr = converter.convert(
        amount: const MoneyAmount(100),
        fromCurrency: 'JPY',
        toCurrency: 'PKR',
      );
      expect(pkr!.minorUnits, 18500);
    });

    test('same currency is identity', () {
      final same = converter.convert(
        amount: const MoneyAmount(500),
        fromCurrency: 'PKR',
        toCurrency: 'PKR',
      );
      expect(same!.minorUnits, 500);
    });

    test('rounding half away from zero', () {
      final c = CurrencyConverter(
        baseCurrency: 'PKR',
        rates: [
          ExchangeRate(
            from: 'USD',
            to: 'PKR',
            rate: Decimal.parse('278.555'),
            updatedAt: DateTime(2026, 1, 1),
          ),
        ],
      );
      // $0.01 * 278.555 = 2.78555 → rounds to 3 paisa? 
      // major 0.01 * 278.555 = 2.78555 PKR → *100 = 278.555 → round 279
      final pkr = c.convert(
        amount: const MoneyAmount(1),
        fromCurrency: 'USD',
        toCurrency: 'PKR',
      );
      expect(pkr!.minorUnits, 279);
    });
  });
}
