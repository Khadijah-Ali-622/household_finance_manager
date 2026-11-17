import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/assets_dao.dart';
import 'daos/budgets_dao.dart';
import 'daos/categories_dao.dart';
import 'daos/exchange_rates_dao.dart';
import 'daos/liabilities_dao.dart';
import 'daos/transactions_dao.dart';
import 'daos/wallet_groups_dao.dart';
import 'daos/wallets_dao.dart';
import 'tables/assets.dart';
import 'tables/categories.dart';
import 'tables/exchange_rates.dart';
import 'tables/liabilities.dart';
import 'tables/phase_later.dart';
import 'tables/transactions.dart';
import 'tables/wallet_groups.dart';
import 'tables/wallets.dart';

export 'tables/assets.dart';
export 'tables/categories.dart';
export 'tables/exchange_rates.dart';
export 'tables/liabilities.dart';
export 'tables/phase_later.dart';
export 'tables/transactions.dart';
export 'tables/wallet_groups.dart';
export 'tables/wallets.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Wallets,
    Categories,
    Transactions,
    WalletGroups,
    WalletGroupMembers,
    Assets,
    AssetValueHistory,
    Liabilities,
    LiabilityPayments,
    Budgets,
    BudgetWalletMembers,
    RecurringTransactions,
    Reminders,
    Committees,
    SavingsGoals,
    ExchangeRates,
  ],
  daos: [
    WalletsDao,
    CategoriesDao,
    TransactionsDao,
    WalletGroupsDao,
    AssetsDao,
    LiabilitiesDao,
    ExchangeRatesDao,
    BudgetsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
      await _ensureExpandedPhaseColumns();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Existing data becomes base currency PKR (already the wallet default).
        await m.addColumn(transactions, transactions.toAmount);
        await m.addColumn(assets, assets.currency);
        await m.addColumn(liabilities, liabilities.currency);
        await m.createTable(exchangeRates);
        // Same-currency transfers: received amount equals sent amount.
        await customStatement(
          'UPDATE transactions SET to_amount = amount '
          "WHERE type = 'transfer' AND to_amount IS NULL",
        );
        await customStatement(
          "UPDATE assets SET currency = 'PKR' "
          "WHERE currency IS NULL OR currency = ''",
        );
        await customStatement(
          "UPDATE liabilities SET currency = 'PKR' "
          "WHERE currency IS NULL OR currency = ''",
        );
      }
      if (from < 3) {
        await m.alterTable(TableMigration(budgets));
        await m.createTable(budgetWalletMembers);
        await _ensureBudgetColumns();
        await customStatement(
          'UPDATE budgets SET year_month = start_month '
          'WHERE year_month = 0',
        );
        await _createBudgetIndexes();
      }
      if (from < 4) {
        await _ensureExpandedPhaseColumns();
      }
    },
  );

  /// The generated drift classes still describe the original phase-2 columns.
  /// Add the expanded recurring and reminder columns without build_runner.
  Future<void> _ensureExpandedPhaseColumns() async {
    await customStatement('''
CREATE TABLE IF NOT EXISTS recurring_transactions (
  id TEXT NOT NULL PRIMARY KEY,
  wallet_id TEXT NOT NULL,
  type TEXT NOT NULL,
  amount INTEGER NOT NULL,
  currency TEXT NOT NULL DEFAULT 'PKR',
  to_amount INTEGER,
  category_id TEXT,
  to_wallet_id TEXT,
  note TEXT,
  payment_method TEXT,
  frequency TEXT NOT NULL,
  interval_n INTEGER NOT NULL DEFAULT 1,
  custom_unit TEXT,
  start_date INTEGER NOT NULL DEFAULT 0,
  end_date INTEGER,
  next_due_date INTEGER NOT NULL,
  last_generated_date INTEGER,
  mode TEXT NOT NULL DEFAULT 'ask',
  template_type TEXT NOT NULL DEFAULT 'standard',
  installment_count INTEGER,
  amount_remaining INTEGER,
  generated_count INTEGER NOT NULL DEFAULT 0,
  is_paused INTEGER NOT NULL DEFAULT 0,
  is_active INTEGER NOT NULL DEFAULT 1,
  is_deleted INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
)
''');
    await customStatement('''
CREATE TABLE IF NOT EXISTS reminders (
  id TEXT NOT NULL PRIMARY KEY,
  title TEXT NOT NULL,
  amount INTEGER,
  currency TEXT NOT NULL DEFAULT 'PKR',
  note TEXT,
  due_date INTEGER NOT NULL,
  repeat_frequency TEXT,
  remind_days_before INTEGER NOT NULL DEFAULT 0,
  daily_time_minutes INTEGER,
  wallet_id TEXT,
  category_id TEXT,
  type TEXT NOT NULL DEFAULT 'bill',
  linked_type TEXT,
  linked_id TEXT,
  paid_transaction_id TEXT,
  is_done INTEGER NOT NULL DEFAULT 0,
  last_notified_at INTEGER,
  is_deleted INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
)
''');

    const recurringColumns = <String, String>{
      'currency': "TEXT NOT NULL DEFAULT 'PKR'",
      'to_amount': 'INTEGER',
      'interval_n': 'INTEGER NOT NULL DEFAULT 1',
      'custom_unit': 'TEXT',
      'start_date': 'INTEGER NOT NULL DEFAULT 0',
      'last_generated_date': 'INTEGER',
      'mode': "TEXT NOT NULL DEFAULT 'ask'",
      'template_type': "TEXT NOT NULL DEFAULT 'standard'",
      'installment_count': 'INTEGER',
      'amount_remaining': 'INTEGER',
      'generated_count': 'INTEGER NOT NULL DEFAULT 0',
      'is_paused': 'INTEGER NOT NULL DEFAULT 0',
    };
    for (final entry in recurringColumns.entries) {
      await _addColumnIfMissing(
        'recurring_transactions',
        entry.key,
        entry.value,
      );
    }

    const reminderColumns = <String, String>{
      'amount': 'INTEGER',
      'currency': "TEXT NOT NULL DEFAULT 'PKR'",
      'note': 'TEXT',
      'repeat_frequency': 'TEXT',
      'remind_days_before': 'INTEGER NOT NULL DEFAULT 0',
      'daily_time_minutes': 'INTEGER',
      'wallet_id': 'TEXT',
      'category_id': 'TEXT',
      'type': "TEXT NOT NULL DEFAULT 'bill'",
      'paid_transaction_id': 'TEXT',
      'last_notified_at': 'INTEGER',
    };
    for (final entry in reminderColumns.entries) {
      await _addColumnIfMissing('reminders', entry.key, entry.value);
    }

    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_recurring_due '
      'ON recurring_transactions (is_deleted, is_active, is_paused, next_due_date)',
    );
  }

  Future<void> _addColumnIfMissing(
    String table,
    String column,
    String definition,
  ) async {
    final info = await customSelect('PRAGMA table_info($table)').get();
    final exists = info.any((row) => row.data['name']?.toString() == column);
    if (exists) return;
    await customStatement('ALTER TABLE $table ADD COLUMN $column $definition');
  }

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_wallets_deleted_archived '
      'ON wallets (is_deleted, is_archived)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_categories_type '
      'ON categories (type, is_deleted)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tx_wallet_date '
      'ON transactions (wallet_id, date, is_deleted)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tx_to_wallet '
      'ON transactions (to_wallet_id, is_deleted)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tx_type_date '
      'ON transactions (type, date, is_deleted)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_wgm_wallet '
      'ON wallet_group_members (wallet_id)',
    );
    await _createBudgetIndexes();
  }

  Future<void> _ensureBudgetColumns() async {
    const columns = <String, String>{
      'currency': "TEXT NOT NULL DEFAULT 'PKR'",
      'year_month': 'INTEGER NOT NULL DEFAULT 0',
      'rollover': 'INTEGER NOT NULL DEFAULT 0',
      'notify_80': 'INTEGER NOT NULL DEFAULT 1',
      'notify_over': 'INTEGER NOT NULL DEFAULT 1',
      'last_notified_80_at': 'INTEGER',
      'last_notified_over_at': 'INTEGER',
      'name': 'TEXT',
    };
    for (final entry in columns.entries) {
      await _addColumnIfMissing('budgets', entry.key, entry.value);
    }
    await customStatement('''
CREATE TABLE IF NOT EXISTS budget_wallet_members (
  budget_id TEXT NOT NULL,
  wallet_id TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  PRIMARY KEY (budget_id, wallet_id)
)
''');
  }

  Future<void> _createBudgetIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_budgets_month '
      'ON budgets (year_month, is_deleted)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_budget_members_budget '
      'ON budget_wallet_members (budget_id)',
    );
  }

  /// Erases all local rows (used by Forgot PIN reset). Does not close the DB.
  Future<void> eraseAllData() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  static QueryExecutor _open() {
    return driftDatabase(
      name: 'household_finance',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty) {
            // ignore: avoid_print
            print(
              'Drift web using ${result.chosenImplementation} '
              '(missing: ${result.missingFeatures})',
            );
          }
        },
      ),
    );
  }
}
