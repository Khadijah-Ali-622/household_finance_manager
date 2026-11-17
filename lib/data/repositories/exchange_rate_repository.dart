import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/uuid.dart';
import '../../domain/services/currency_converter.dart';
import '../db/app_database.dart';

class ExchangeRateRepository {
  ExchangeRateRepository(this._db, {http.Client? client})
      : _client = client ?? http.Client();

  final AppDatabase _db;
  final http.Client _client;

  Stream<List<ExchangeRate>> watchAll() {
    return _db.exchangeRatesDao.watchAll().map(
          (rows) => rows.map(_map).toList(),
        );
  }

  Future<List<ExchangeRate>> getAll() async {
    final rows = await _db.exchangeRatesDao.getAll();
    return rows.map(_map).toList();
  }

  Future<CurrencyConverter> converterFor(String baseCurrency) async {
    final rates = await getAll();
    return CurrencyConverter(baseCurrency: baseCurrency, rates: rates);
  }

  Stream<CurrencyConverter> watchConverter(String baseCurrency) {
    return watchAll().map(
      (rates) => CurrencyConverter(baseCurrency: baseCurrency, rates: rates),
    );
  }

  Future<void> saveRate({
    required String from,
    required String to,
    required Decimal rate,
  }) async {
    final now = nowMillis();
    await _db.exchangeRatesDao.upsert(
      ExchangeRatesCompanion(
        fromCurrency: Value(from.toUpperCase()),
        toCurrency: Value(to.toUpperCase()),
        rate: Value(rate.toString()),
        updatedAt: Value(now),
      ),
    );
  }

  /// Seeds a few offline defaults around PKR if the table is empty.
  Future<void> seedDefaultsIfEmpty(String baseCurrency) async {
    final existing = await getAll();
    if (existing.isNotEmpty) return;

    final base = baseCurrency.toUpperCase();
    final now = DateTime.now();
    // Approximate offline starter rates (1 base → target). Editable by user.
    final starters = <String, String>{
      if (base == 'PKR') ...{
        'USD': '0.0036',
        'EUR': '0.0033',
        'GBP': '0.0028',
        'INR': '0.30',
        'AED': '0.013',
        'SAR': '0.0135',
        'JPY': '0.54',
        'CNY': '0.026',
        'TRY': '0.12',
        'BDT': '0.39',
      },
      if (base == 'USD') ...{
        'PKR': '278',
        'EUR': '0.92',
        'GBP': '0.79',
        'INR': '83',
        'JPY': '150',
        'AED': '3.67',
      },
    };

    final entries = <ExchangeRatesCompanion>[];
    starters.forEach((to, rate) {
      entries.add(
        ExchangeRatesCompanion.insert(
          fromCurrency: base,
          toCurrency: to,
          rate: rate,
          updatedAt: toMillis(now),
        ),
      );
    });
    // Identity rate.
    entries.add(
      ExchangeRatesCompanion.insert(
        fromCurrency: base,
        toCurrency: base,
        rate: '1',
        updatedAt: toMillis(now),
      ),
    );
    if (entries.isNotEmpty) {
      await _db.exchangeRatesDao.upsertAll(entries);
    }
  }

  /// Fetches live rates for [baseCurrency] from open.er-api.com.
  /// On failure, leaves existing rates untouched and rethrows.
  Future<DateTime> refreshFromNetwork(String baseCurrency) async {
    final base = baseCurrency.toUpperCase();
    final uri = Uri.parse('https://open.er-api.com/v6/latest/$base');
    final response = await _client.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw StateError('HTTP ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['result'] != 'success') {
      throw StateError(body['error-type']?.toString() ?? 'API error');
    }
    final ratesMap = body['rates'] as Map<String, dynamic>?;
    if (ratesMap == null || ratesMap.isEmpty) {
      throw StateError('Empty rates');
    }
    final now = DateTime.now();
    final ms = toMillis(now);
    final entries = <ExchangeRatesCompanion>[
      ExchangeRatesCompanion.insert(
        fromCurrency: base,
        toCurrency: base,
        rate: '1',
        updatedAt: ms,
      ),
    ];
    ratesMap.forEach((code, value) {
      final rateStr = value.toString();
      if (Decimal.tryParse(rateStr) == null) return;
      entries.add(
        ExchangeRatesCompanion.insert(
          fromCurrency: base,
          toCurrency: code.toUpperCase(),
          rate: rateStr,
          updatedAt: ms,
        ),
      );
    });
    await _db.exchangeRatesDao.upsertAll(entries);
    return now;
  }

  ExchangeRate _map(ExchangeRateRow row) => ExchangeRate(
        from: row.fromCurrency,
        to: row.toCurrency,
        rate: Decimal.parse(row.rate),
        updatedAt: fromMillis(row.updatedAt),
      );
}
