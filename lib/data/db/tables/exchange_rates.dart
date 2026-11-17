import 'package:drift/drift.dart';

@DataClassName('ExchangeRateRow')
class ExchangeRates extends Table {
  TextColumn get fromCurrency => text()();
  TextColumn get toCurrency => text()();
  /// Decimal string: 1 major [fromCurrency] = rate major [toCurrency].
  TextColumn get rate => text()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {fromCurrency, toCurrency};
}
