import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/app_database.dart';
import 'backup_models.dart';
import 'backup_settings.dart';

/// Reads and writes every backed-up table. Replace clears those tables first.
/// Merge keeps rows whose id (or natural key) is already present.
class BackupRepository {
  BackupRepository(this._db, this._prefs);

  final AppDatabase _db;
  final SharedPreferences _prefs;

  Future<BackupPayload> snapshot() async {
    final groups = await _select('wallet_groups', _groupCols);
    final members = await _db.customSelect(
      'SELECT group_id AS groupId, wallet_id AS walletId, created_at AS createdAt '
      'FROM wallet_group_members',
    ).get();
    final walletIds = <String, List<String>>{};
    for (final row in members) {
      final groupId = _text(row.data, 'groupId');
      final walletId = _text(row.data, 'walletId');
      if (groupId == null || walletId == null) continue;
      walletIds.putIfAbsent(groupId, () => []).add(walletId);
    }

    return BackupPayload(
      createdAt: DateTime.now().toUtc(),
      wallets: await _select('wallets', _walletCols),
      categories: await _select('categories', _categoryCols),
      transactions: await _select('transactions', _transactionCols),
      groups: [
        for (final group in groups)
          {
            ...group,
            'walletIds': walletIds[group['id']?.toString()] ?? const <String>[],
          },
      ],
      assets: await _select('assets', _assetCols),
      liabilities: await _select('liabilities', _liabilityCols),
      budgets: await _select('budgets', _budgetCols),
      budgetMembers: await _select('budget_wallet_members', _budgetMemberCols),
      recurring: await _select('recurring_transactions', _recurringCols),
      reminders: await _select('reminders', _reminderCols),
      exchangeRates: await _select('exchange_rates', _rateCols),
      settings: _readSettings(),
      assetValueHistory: await _select(
        'asset_value_history',
        _assetHistoryCols,
      ),
      liabilityPayments: await _select(
        'liability_payments',
        _liabilityPaymentCols,
      ),
      committees: await _select('committees', _committeeCols),
      savingsGoals: await _select('savings_goals', _savingsCols),
    );
  }

  Future<void> restore(BackupPayload payload, {required RestoreMode mode}) async {
    await _db.transaction(() async {
      if (mode == RestoreMode.replace) {
        const tables = <(String, _Table)>[
          ('wallet_group_members', _Table.groupMembers),
          ('budget_wallet_members', _Table.budgetMembers),
          ('transactions', _Table.transactions),
          ('recurring_transactions', _Table.recurring),
          ('reminders', _Table.reminders),
          ('asset_value_history', _Table.assetHistory),
          ('liability_payments', _Table.liabilityPayments),
          ('wallets', _Table.wallets),
          ('categories', _Table.categories),
          ('wallet_groups', _Table.groups),
          ('assets', _Table.assets),
          ('liabilities', _Table.liabilities),
          ('budgets', _Table.budgets),
          ('exchange_rates', _Table.rates),
          ('committees', _Table.committees),
          ('savings_goals', _Table.savings),
        ];
        for (final table in tables) {
          await _statement('DELETE FROM ${table.$1}', table.$2);
        }
      }

      await _restoreRows('wallets', _walletCols, payload.wallets, mode, _Table.wallets);
      await _restoreRows(
        'categories',
        _categoryCols,
        payload.categories,
        mode,
        _Table.categories,
      );
      await _restoreRows(
        'transactions',
        _transactionCols,
        payload.transactions,
        mode,
        _Table.transactions,
      );
      await _restoreGroups(payload.groups, mode);
      await _restoreRows('assets', _assetCols, payload.assets, mode, _Table.assets);
      await _restoreRows(
        'asset_value_history',
        _assetHistoryCols,
        payload.assetValueHistory,
        mode,
        _Table.assetHistory,
      );
      await _restoreRows(
        'liabilities',
        _liabilityCols,
        payload.liabilities,
        mode,
        _Table.liabilities,
      );
      await _restoreRows(
        'liability_payments',
        _liabilityPaymentCols,
        payload.liabilityPayments,
        mode,
        _Table.liabilityPayments,
      );
      await _restoreRows('budgets', _budgetCols, payload.budgets, mode, _Table.budgets);
      await _restoreBudgetMembers(payload.budgetMembers, mode);
      await _restoreRows(
        'recurring_transactions',
        _recurringCols,
        payload.recurring,
        mode,
        _Table.recurring,
      );
      await _restoreRows(
        'reminders',
        _reminderCols,
        payload.reminders,
        mode,
        _Table.reminders,
      );
      await _restoreRates(payload.exchangeRates, mode);
      await _restoreRows(
        'committees',
        _committeeCols,
        payload.committees,
        mode,
        _Table.committees,
      );
      await _restoreRows(
        'savings_goals',
        _savingsCols,
        payload.savingsGoals,
        mode,
        _Table.savings,
      );
    });
    await _applySettings(payload.settings, mode);
  }

  Map<String, dynamic> _readSettings() {
    final map = <String, dynamic>{};
    for (final key in kBackupSettingKeys) {
      if (!_prefs.containsKey(key)) continue;
      final value = _prefs.get(key);
      if (value is String || value is bool || value is int || value is double) {
        map[key] = value;
      }
    }
    return map;
  }

  Future<void> _applySettings(
    Map<String, dynamic> settings,
    RestoreMode mode,
  ) async {
    if (mode == RestoreMode.replace) {
      for (final key in kBackupSettingKeys) {
        if (!settings.containsKey(key)) await _prefs.remove(key);
      }
    }
    for (final entry in settings.entries) {
      if (!kBackupSettingKeys.contains(entry.key)) continue;
      if (mode == RestoreMode.merge && _prefs.containsKey(entry.key)) continue;
      final value = entry.value;
      if (value == null) {
        await _prefs.remove(entry.key);
      } else if (value is bool) {
        await _prefs.setBool(entry.key, value);
      } else if (value is int) {
        await _prefs.setInt(entry.key, value);
      } else if (value is double) {
        await _prefs.setDouble(entry.key, value);
      } else {
        await _prefs.setString(entry.key, value.toString());
      }
    }
  }

  Future<void> _restoreRows(
    String table,
    List<_Col> cols,
    List<Map<String, dynamic>> rows,
    RestoreMode mode,
    _Table target,
  ) async {
    for (final row in rows) {
      final id = row['id']?.toString();
      if (id == null || id.isEmpty) continue;
      if (mode == RestoreMode.merge && await _exists(table, 'id', id)) {
        continue;
      }
      await _insert(table, cols, row, target);
    }
  }

  Future<void> _restoreGroups(
    List<Map<String, dynamic>> groups,
    RestoreMode mode,
  ) async {
    for (final group in groups) {
      final id = group['id']?.toString();
      if (id == null || id.isEmpty) continue;
      if (mode == RestoreMode.merge && await _exists('wallet_groups', 'id', id)) {
        continue;
      }
      await _insert('wallet_groups', _groupCols, group, _Table.groups);
      final rawIds = group['walletIds'];
      if (rawIds is! List) continue;
      for (final walletId in rawIds) {
        await _statement(
          'INSERT OR REPLACE INTO wallet_group_members '
          '(group_id, wallet_id, created_at) VALUES (?, ?, ?)',
          _Table.groupMembers,
          [
            id,
            walletId.toString(),
            _int(group['createdAt']),
          ],
        );
      }
    }
  }

  Future<void> _restoreBudgetMembers(
    List<Map<String, dynamic>> members,
    RestoreMode mode,
  ) async {
    for (final member in members) {
      final budgetId = member['budgetId']?.toString();
      final walletId = member['walletId']?.toString();
      if (budgetId == null || walletId == null || budgetId.isEmpty || walletId.isEmpty) {
        continue;
      }
      if (mode == RestoreMode.merge &&
          await _existsPair(
            'budget_wallet_members',
            'budget_id',
            budgetId,
            'wallet_id',
            walletId,
          )) {
        continue;
      }
      await _insert(
        'budget_wallet_members',
        _budgetMemberCols,
        member,
        _Table.budgetMembers,
      );
    }
  }

  Future<void> _restoreRates(
    List<Map<String, dynamic>> rates,
    RestoreMode mode,
  ) async {
    for (final rate in rates) {
      final from = rate['fromCurrency']?.toString();
      final to = rate['toCurrency']?.toString();
      if (from == null || to == null || from.isEmpty || to.isEmpty) continue;
      if (mode == RestoreMode.merge &&
          await _existsPair(
            'exchange_rates',
            'from_currency',
            from,
            'to_currency',
            to,
          )) {
        continue;
      }
      await _insert('exchange_rates', _rateCols, rate, _Table.rates);
    }
  }

  Future<bool> _exists(String table, String column, String id) async {
    final rows = await _db.customSelect(
      'SELECT 1 AS ok FROM $table WHERE $column = ? LIMIT 1',
      variables: [Variable<String>(id)],
    ).get();
    return rows.isNotEmpty;
  }

  Future<bool> _existsPair(
    String table,
    String leftCol,
    String left,
    String rightCol,
    String right,
  ) async {
    final rows = await _db.customSelect(
      'SELECT 1 AS ok FROM $table WHERE $leftCol = ? AND $rightCol = ? LIMIT 1',
      variables: [Variable<String>(left), Variable<String>(right)],
    ).get();
    return rows.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> _select(
    String table,
    List<_Col> cols,
  ) async {
    final sql =
        'SELECT ${cols.map((col) => '${col.sql} AS "${col.json}"').join(', ')} '
        'FROM $table';
    final rows = await _db.customSelect(sql).get();
    return [for (final row in rows) _read(row.data, cols)];
  }

  Map<String, dynamic> _read(Map<String, dynamic> data, List<_Col> cols) {
    final folded = <String, Object?>{
      for (final entry in data.entries) entry.key.toLowerCase(): entry.value,
    };
    final out = <String, dynamic>{};
    for (final col in cols) {
      final value =
          data[col.json] ??
          folded[col.json.toLowerCase()] ??
          folded[col.sql];
      out[col.json] = _normalize(value, col);
    }
    return out;
  }

  Object? _normalize(Object? value, _Col col) {
    if (value is BigInt) value = value.toInt();
    if (col.kind == _Kind.boolean) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      return false;
    }
    if (col.kind == _Kind.integer && value is num && value is! int) {
      return value.toInt();
    }
    return value;
  }

  Future<int> _insert(
    String table,
    List<_Col> cols,
    Map<String, dynamic> row,
    _Table target,
  ) {
    final sql =
        'INSERT OR REPLACE INTO $table (${cols.map((col) => col.sql).join(', ')}) '
        'VALUES (${List.filled(cols.length, '?').join(', ')})';
    return _statement(sql, target, [for (final col in cols) _bind(col, row[col.json])]);
  }

  Future<int> _statement(
    String sql,
    _Table target, [
    List<Object?> args = const [],
  ]) {
    final variables = <Variable>[
      for (final arg in args)
        if (arg is int)
          Variable<int>(arg)
        else if (arg is String)
          Variable<String>(arg)
        else
          const Variable<String>(null),
    ];
    return switch (target) {
      _Table.wallets => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.wallets},
        ),
      _Table.categories => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.categories},
        ),
      _Table.transactions => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.transactions},
        ),
      _Table.groups => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.walletGroups},
        ),
      _Table.groupMembers => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.walletGroupMembers},
        ),
      _Table.assets => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.assets},
        ),
      _Table.assetHistory => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.assetValueHistory},
        ),
      _Table.liabilities => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.liabilities},
        ),
      _Table.liabilityPayments => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.liabilityPayments},
        ),
      _Table.budgets => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.budgets},
        ),
      _Table.budgetMembers => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.budgetWalletMembers},
        ),
      _Table.recurring => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.recurringTransactions},
        ),
      _Table.reminders => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.reminders},
        ),
      _Table.rates => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.exchangeRates},
        ),
      _Table.committees => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.committees},
        ),
      _Table.savings => _db.customInsert(
          sql,
          variables: variables,
          updates: {_db.savingsGoals},
        ),
    };
  }

  Object? _bind(_Col col, Object? value) {
    if (col.kind == _Kind.boolean) {
      final on = value == true || value == 1 || value == '1';
      return on ? 1 : 0;
    }
    if (col.kind == _Kind.integer) {
      if (value == null) return col.nullable ? null : 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? (col.nullable ? null : 0);
    }
    if (value == null) return col.nullable ? null : '';
    return value.toString();
  }

  String? _text(Map<String, dynamic> data, String key) {
    final value = data[key] ?? data[key.toLowerCase()];
    if (value == null) return null;
    return value.toString();
  }

  int _int(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }
}

enum _Table {
  wallets,
  categories,
  transactions,
  groups,
  groupMembers,
  assets,
  assetHistory,
  liabilities,
  liabilityPayments,
  budgets,
  budgetMembers,
  recurring,
  reminders,
  rates,
  committees,
  savings,
}

enum _Kind { text, integer, boolean }

class _Col {
  const _Col(this.sql, this.json, this.kind, {this.nullable = true});

  final String sql;
  final String json;
  final _Kind kind;
  final bool nullable;
}

const _walletCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('name', 'name', _Kind.text, nullable: false),
  _Col('icon', 'icon', _Kind.text, nullable: false),
  _Col('color', 'color', _Kind.integer, nullable: false),
  _Col('currency', 'currency', _Kind.text, nullable: false),
  _Col('opening_balance', 'openingBalance', _Kind.integer, nullable: false),
  _Col('type', 'type', _Kind.text, nullable: false),
  _Col('is_liability_type', 'isLiabilityType', _Kind.boolean, nullable: false),
  _Col('is_archived', 'isArchived', _Kind.boolean, nullable: false),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _categoryCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('name', 'name', _Kind.text, nullable: false),
  _Col('icon', 'icon', _Kind.text, nullable: false),
  _Col('color', 'color', _Kind.integer, nullable: false),
  _Col('type', 'type', _Kind.text, nullable: false),
  _Col('parent_id', 'parentId', _Kind.text),
  _Col('is_default', 'isDefault', _Kind.boolean, nullable: false),
  _Col('sort_order', 'sortOrder', _Kind.integer, nullable: false),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _transactionCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('wallet_id', 'walletId', _Kind.text, nullable: false),
  _Col('type', 'type', _Kind.text, nullable: false),
  _Col('amount', 'amount', _Kind.integer, nullable: false),
  _Col('to_amount', 'toAmount', _Kind.integer),
  _Col('category_id', 'categoryId', _Kind.text),
  _Col('to_wallet_id', 'toWalletId', _Kind.text),
  _Col('date', 'date', _Kind.integer, nullable: false),
  _Col('note', 'note', _Kind.text),
  _Col('payment_method', 'paymentMethod', _Kind.text),
  _Col('receipt_path', 'receiptPath', _Kind.text),
  _Col('recurring_id', 'recurringId', _Kind.text),
  _Col('linked_asset_id', 'linkedAssetId', _Kind.text),
  _Col('linked_liability_id', 'linkedLiabilityId', _Kind.text),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _groupCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('name', 'name', _Kind.text, nullable: false),
  _Col('icon', 'icon', _Kind.text),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _assetCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('name', 'name', _Kind.text, nullable: false),
  _Col('type', 'type', _Kind.text, nullable: false),
  _Col('purchase_price', 'purchasePrice', _Kind.integer),
  _Col('purchase_date', 'purchaseDate', _Kind.integer),
  _Col('current_value', 'currentValue', _Kind.integer, nullable: false),
  _Col('currency', 'currency', _Kind.text, nullable: false),
  _Col('quantity', 'quantity', _Kind.text),
  _Col('unit', 'unit', _Kind.text),
  _Col('notes', 'notes', _Kind.text),
  _Col('photo_path', 'photoPath', _Kind.text),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _assetHistoryCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('asset_id', 'assetId', _Kind.text, nullable: false),
  _Col('value', 'value', _Kind.integer, nullable: false),
  _Col('date', 'date', _Kind.integer, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
];

const _liabilityCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('name', 'name', _Kind.text, nullable: false),
  _Col('type', 'type', _Kind.text, nullable: false),
  _Col('total_amount', 'totalAmount', _Kind.integer, nullable: false),
  _Col('remaining_amount', 'remainingAmount', _Kind.integer, nullable: false),
  _Col('currency', 'currency', _Kind.text, nullable: false),
  _Col('installment_amount', 'installmentAmount', _Kind.integer),
  _Col('due_date', 'dueDate', _Kind.integer),
  _Col('interest_rate', 'interestRate', _Kind.text),
  _Col('notes', 'notes', _Kind.text),
  _Col('linked_wallet_id', 'linkedWalletId', _Kind.text),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _liabilityPaymentCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('liability_id', 'liabilityId', _Kind.text, nullable: false),
  _Col('amount', 'amount', _Kind.integer, nullable: false),
  _Col('date', 'date', _Kind.integer, nullable: false),
  _Col('transaction_id', 'transactionId', _Kind.text),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _budgetCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('category_id', 'categoryId', _Kind.text),
  _Col('wallet_id', 'walletId', _Kind.text),
  _Col('amount', 'amount', _Kind.integer, nullable: false),
  _Col('currency', 'currency', _Kind.text, nullable: false),
  _Col('period', 'period', _Kind.text, nullable: false),
  _Col('start_month', 'startMonth', _Kind.integer, nullable: false),
  _Col('year_month', 'yearMonth', _Kind.integer, nullable: false),
  _Col('rollover', 'rollover', _Kind.boolean, nullable: false),
  _Col('notify_80', 'notify80', _Kind.boolean, nullable: false),
  _Col('notify_over', 'notifyOver', _Kind.boolean, nullable: false),
  _Col('last_notified_80_at', 'lastNotified80At', _Kind.integer),
  _Col('last_notified_over_at', 'lastNotifiedOverAt', _Kind.integer),
  _Col('name', 'name', _Kind.text),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _budgetMemberCols = [
  _Col('budget_id', 'budgetId', _Kind.text, nullable: false),
  _Col('wallet_id', 'walletId', _Kind.text, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
];

const _recurringCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('wallet_id', 'walletId', _Kind.text, nullable: false),
  _Col('type', 'type', _Kind.text, nullable: false),
  _Col('amount', 'amount', _Kind.integer, nullable: false),
  _Col('currency', 'currency', _Kind.text, nullable: false),
  _Col('to_amount', 'toAmount', _Kind.integer),
  _Col('category_id', 'categoryId', _Kind.text),
  _Col('to_wallet_id', 'toWalletId', _Kind.text),
  _Col('note', 'note', _Kind.text),
  _Col('payment_method', 'paymentMethod', _Kind.text),
  _Col('frequency', 'frequency', _Kind.text, nullable: false),
  _Col('interval_n', 'intervalN', _Kind.integer, nullable: false),
  _Col('custom_unit', 'customUnit', _Kind.text),
  _Col('start_date', 'startDate', _Kind.integer, nullable: false),
  _Col('end_date', 'endDate', _Kind.integer),
  _Col('next_due_date', 'nextDueDate', _Kind.integer, nullable: false),
  _Col('last_generated_date', 'lastGeneratedDate', _Kind.integer),
  _Col('mode', 'mode', _Kind.text, nullable: false),
  _Col('template_type', 'templateType', _Kind.text, nullable: false),
  _Col('installment_count', 'installmentCount', _Kind.integer),
  _Col('amount_remaining', 'amountRemaining', _Kind.integer),
  _Col('generated_count', 'generatedCount', _Kind.integer, nullable: false),
  _Col('is_paused', 'isPaused', _Kind.boolean, nullable: false),
  _Col('is_active', 'isActive', _Kind.boolean, nullable: false),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _reminderCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('title', 'title', _Kind.text, nullable: false),
  _Col('amount', 'amount', _Kind.integer),
  _Col('currency', 'currency', _Kind.text, nullable: false),
  _Col('note', 'note', _Kind.text),
  _Col('due_date', 'dueDate', _Kind.integer, nullable: false),
  _Col('repeat_frequency', 'repeatFrequency', _Kind.text),
  _Col('remind_days_before', 'remindDaysBefore', _Kind.integer, nullable: false),
  _Col('daily_time_minutes', 'dailyTimeMinutes', _Kind.integer),
  _Col('wallet_id', 'walletId', _Kind.text),
  _Col('category_id', 'categoryId', _Kind.text),
  _Col('type', 'type', _Kind.text, nullable: false),
  _Col('linked_type', 'linkedType', _Kind.text),
  _Col('linked_id', 'linkedId', _Kind.text),
  _Col('paid_transaction_id', 'paidTransactionId', _Kind.text),
  _Col('is_done', 'isDone', _Kind.boolean, nullable: false),
  _Col('last_notified_at', 'lastNotifiedAt', _Kind.integer),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _rateCols = [
  _Col('from_currency', 'fromCurrency', _Kind.text, nullable: false),
  _Col('to_currency', 'toCurrency', _Kind.text, nullable: false),
  _Col('rate', 'rate', _Kind.text, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _committeeCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('name', 'name', _Kind.text, nullable: false),
  _Col('monthly_amount', 'monthlyAmount', _Kind.integer, nullable: false),
  _Col('total_members', 'totalMembers', _Kind.integer, nullable: false),
  _Col('my_turn_month', 'myTurnMonth', _Kind.integer),
  _Col('start_date', 'startDate', _Kind.integer, nullable: false),
  _Col('status', 'status', _Kind.text, nullable: false),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];

const _savingsCols = [
  _Col('id', 'id', _Kind.text, nullable: false),
  _Col('name', 'name', _Kind.text, nullable: false),
  _Col('target_amount', 'targetAmount', _Kind.integer, nullable: false),
  _Col('saved_amount', 'savedAmount', _Kind.integer, nullable: false),
  _Col('target_date', 'targetDate', _Kind.integer),
  _Col('is_deleted', 'isDeleted', _Kind.boolean, nullable: false),
  _Col('created_at', 'createdAt', _Kind.integer, nullable: false),
  _Col('updated_at', 'updatedAt', _Kind.integer, nullable: false),
];
