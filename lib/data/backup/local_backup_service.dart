import 'dart:convert';

import 'package:csv/csv.dart';

import 'backup_models.dart';
import 'local_backup_store.dart';
import 'local_backup_store_api.dart';

/// Local JSON and CSV files. Safety copies are pruned to the newest five.
class LocalBackupService {
  LocalBackupService({LocalBackupStore? store})
      : _store = store ?? createLocalBackupStore();

  static const safetyPrefix = 'hfm-safety-';
  static const exportPrefix = 'hfm-local-';
  static const csvPrefix = 'hfm-transactions-';
  static const keepCount = 5;

  final LocalBackupStore _store;

  Future<StoredBackup> writeSafetyCopy(String json) {
    return _store.write(
      prefix: safetyPrefix,
      extension: 'json',
      contents: json,
      keep: keepCount,
    );
  }

  Future<StoredBackup> writeExport(String json) {
    return _store.write(
      prefix: exportPrefix,
      extension: 'json',
      contents: json,
      keep: keepCount,
    );
  }

  Future<StoredBackup> writeCsv(String csv) {
    return _store.write(
      prefix: csvPrefix,
      extension: 'csv',
      contents: csv,
      keep: keepCount,
    );
  }

  Future<List<StoredBackup>> listSafetyCopies() => _store.list(safetyPrefix);

  Future<List<StoredBackup>> listExports() => _store.list(exportPrefix);

  Future<String> read(StoredBackup item) => _store.read(item);

  Future<bool> shareJson(StoredBackup item) {
    return _store.share(item, mimeType: 'application/json');
  }

  Future<bool> shareCsv(StoredBackup item) {
    return _store.share(item, mimeType: 'text/csv');
  }

  Future<String?> pickJsonFile() {
    return _store.pickTextFile(extensions: const ['json']);
  }

  static String transactionsToCsv(List<Map<String, dynamic>> transactions) {
    const headers = [
      'id',
      'date',
      'type',
      'walletId',
      'toWalletId',
      'categoryId',
      'amount',
      'toAmount',
      'note',
      'paymentMethod',
      'isDeleted',
    ];
    final rows = <List<Object?>>[
      headers,
      for (final tx in transactions)
        [
          for (final key in headers) tx[key],
        ],
    ];
    return const ListToCsvConverter().convert(rows);
  }

  static int utf8Size(String text) => utf8.encode(text).length;
}
