import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/data/backup/backup_exporter.dart';
import 'package:household_finance_manager/data/backup/backup_models.dart';
import 'package:household_finance_manager/data/backup/local_backup_service.dart';

void main() {
  final payload = BackupPayload(
    createdAt: DateTime.utc(2026, 3, 4, 5, 6, 7),
    wallets: const [
      {
        'id': 'w1',
        'name': 'Round Trip Wallet',
        'icon': 'wallet',
        'color': 0xFF0D9488,
        'currency': 'PKR',
        'openingBalance': 150000,
        'type': 'cash',
        'isLiabilityType': false,
        'isArchived': false,
        'isDeleted': false,
        'createdAt': 1700000000000,
        'updatedAt': 1700000001000,
      },
    ],
    categories: const [
      {'id': 'c1', 'name': 'Groceries', 'type': 'expense'},
    ],
    transactions: const [
      {
        'id': 't1',
        'walletId': 'w1',
        'type': 'expense',
        'amount': 25050,
        'toAmount': null,
        'categoryId': 'c1',
        'date': 1700000002000,
        'note': 'Milk, "bread", and eggs',
        'isDeleted': false,
      },
    ],
    groups: const [
      {
        'id': 'g1',
        'name': 'Home',
        'walletIds': ['w1'],
        'isDeleted': false,
      },
    ],
    assets: const [
      {'id': 'a1', 'name': 'Gold', 'currentValue': 900000},
    ],
    liabilities: const [
      {'id': 'l1', 'name': 'Bike loan', 'remainingAmount': 400000},
    ],
    budgets: const [
      {'id': 'b1', 'amount': 2000000, 'yearMonth': 202603, 'rollover': true},
    ],
    budgetMembers: const [
      {'budgetId': 'b1', 'walletId': 'w1', 'createdAt': 1700000003000},
    ],
    recurring: const [
      {'id': 'r1', 'walletId': 'w1', 'amount': 10000, 'frequency': 'monthly'},
    ],
    reminders: const [
      {'id': 'm1', 'title': 'Rent', 'dueDate': 1700000004000, 'isDone': false},
    ],
    exchangeRates: const [
      {
        'fromCurrency': 'USD',
        'toCurrency': 'PKR',
        'rate': '280',
        'updatedAt': 1700000005000,
      },
    ],
    settings: const {
      'base_currency': 'PKR',
      'native_digits': false,
      'app_locale': 'en',
    },
  );

  const exporter = BackupExporter();

  test('unencrypted export and import round-trip', () {
    final json = exporter.exportToJson(payload);
    expect(json, contains('"encrypted": false'));
    expect(exporter.isEncrypted(json), isFalse);
    final restored = exporter.importFromJson(json);
    expect(restored.toJson(), payload.toJson());
  });

  test('encrypted export and import round-trip', () {
    final json = exporter.exportToJson(payload, password: 'household-secret');
    expect(exporter.isEncrypted(json), isTrue);
    expect(json, contains(BackupExporter.forgottenPasswordWarning));
    expect(json, isNot(contains('Round Trip Wallet')));
    expect(json, contains('"data":'));

    final restored = exporter.importFromJson(
      json,
      password: 'household-secret',
    );
    expect(restored.toJson(), payload.toJson());
  });

  test('wrong or missing password explains that it cannot be recovered', () {
    final json = exporter.exportToJson(payload, password: 'household-secret');
    expect(
      () => exporter.importFromJson(json),
      throwsA(
        isA<BackupPasswordException>().having(
          (error) => error.message,
          'message',
          contains('forget this password'),
        ),
      ),
    );
    expect(
      () => exporter.importFromJson(json, password: 'wrong-password'),
      throwsA(
        isA<BackupPasswordException>().having(
          (error) => error.message,
          'message',
          contains('forgot the password'),
        ),
      ),
    );
  });

  test('corrupted json is rejected', () {
    expect(
      () => exporter.importFromJson('{not json'),
      throwsA(isA<BackupCorruptException>()),
    );
  });

  test('transaction csv quotes commas and quotes', () {
    final csv = LocalBackupService.transactionsToCsv(payload.transactions);
    expect(csv, contains('Milk'));
    expect(csv.split('\n').first, contains('walletId'));
    expect(csv, contains('"Milk, ""bread"", and eggs"'));
  });
}
