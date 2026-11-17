import 'package:drift/drift.dart';

import '../app_database.dart';

part 'exchange_rates_dao.g.dart';

@DriftAccessor(tables: [ExchangeRates])
class ExchangeRatesDao extends DatabaseAccessor<AppDatabase>
    with _$ExchangeRatesDaoMixin {
  ExchangeRatesDao(super.db);

  Stream<List<ExchangeRateRow>> watchAll() {
    return (select(exchangeRates)
          ..orderBy([
            (t) => OrderingTerm.asc(t.fromCurrency),
            (t) => OrderingTerm.asc(t.toCurrency),
          ]))
        .watch();
  }

  Future<List<ExchangeRateRow>> getAll() {
    return select(exchangeRates).get();
  }

  Future<void> upsert(ExchangeRatesCompanion entry) =>
      into(exchangeRates).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<ExchangeRatesCompanion> entries) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(exchangeRates, entries);
    });
  }

  Future<void> clear() => delete(exchangeRates).go();
}
