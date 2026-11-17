import 'package:drift/drift.dart';

import '../../../core/utils/uuid.dart';
import '../../../domain/enums/recurring_frequency.dart';
import '../../../domain/enums/recurring_mode.dart';
import '../../../domain/enums/recurring_template.dart';
import '../../../domain/enums/transaction_type.dart';
import '../../../domain/models/money_amount.dart';
import '../../../domain/models/recurring_rule.dart';
import '../app_database.dart';

/// Reads and writes recurring rules with SQL.
///
/// The checked-in drift data classes predate the expanded columns on
/// [RecurringTransactions] and [Reminders]. Queries here use the real table
/// so those columns work without running build_runner.
class RecurringDao {
  RecurringDao(this._db);

  final AppDatabase _db;

  static const _ruleColumns = '''
id, wallet_id, type, amount, currency, to_amount, category_id, to_wallet_id,
note, payment_method, frequency, interval_n, custom_unit, start_date, end_date,
next_due_date, last_generated_date, mode, template_type, installment_count,
amount_remaining, generated_count, is_paused, is_active, is_deleted,
created_at, updated_at
''';

  Stream<List<RecurringRule>> watchActive() {
    return _db
        .customSelect(
          '''
SELECT $_ruleColumns
FROM recurring_transactions
WHERE is_deleted = 0
ORDER BY is_paused ASC, next_due_date ASC
''',
          readsFrom: {_db.recurringTransactions},
        )
        .watch()
        .map((rows) => rows.map(_mapRule).toList());
  }

  Future<RecurringRule?> getById(String id) async {
    final rows = await _db
        .customSelect(
          '''
SELECT $_ruleColumns
FROM recurring_transactions
WHERE id = ? AND is_deleted = 0
LIMIT 1
''',
          variables: [Variable<String>(id)],
          readsFrom: {_db.recurringTransactions},
        )
        .get();
    if (rows.isEmpty) return null;
    return _mapRule(rows.first);
  }

  Future<List<RecurringRule>> getRunnable() {
    return _db
        .customSelect(
          '''
SELECT $_ruleColumns
FROM recurring_transactions
WHERE is_deleted = 0 AND is_active = 1 AND is_paused = 0
ORDER BY next_due_date ASC
''',
          readsFrom: {_db.recurringTransactions},
        )
        .get()
        .then((rows) => rows.map(_mapRule).toList());
  }

  Future<void> insertRule(RecurringRule rule) {
    return _db.customInsert(
      '''
INSERT INTO recurring_transactions (
  id, wallet_id, type, amount, currency, to_amount, category_id, to_wallet_id,
  note, payment_method, frequency, interval_n, custom_unit, start_date, end_date,
  next_due_date, last_generated_date, mode, template_type, installment_count,
  amount_remaining, generated_count, is_paused, is_active, is_deleted,
  created_at, updated_at
) VALUES (${List.filled(27, '?').join(',')})
''',
      variables: [
        Variable<String>(rule.id),
        Variable<String>(rule.walletId),
        Variable<String>(rule.type.storageValue),
        Variable<int>(rule.amount.minorUnits),
        Variable<String>(rule.currency),
        Variable<int>(rule.toAmount?.minorUnits),
        Variable<String>(rule.categoryId),
        Variable<String>(rule.toWalletId),
        Variable<String>(rule.note),
        Variable<String>(rule.paymentMethod),
        Variable<String>(rule.frequency.storageValue),
        Variable<int>(rule.intervalN),
        Variable<String>(rule.customUnit),
        Variable<int>(toMillis(rule.startDate)),
        Variable<int>(rule.endDate == null ? null : toMillis(rule.endDate!)),
        Variable<int>(toMillis(rule.nextDueDate)),
        Variable<int>(
          rule.lastGeneratedDate == null
              ? null
              : toMillis(rule.lastGeneratedDate!),
        ),
        Variable<String>(rule.mode.storageValue),
        Variable<String>(rule.templateType.storageValue),
        Variable<int>(rule.installmentCount),
        Variable<int>(rule.amountRemaining?.minorUnits),
        Variable<int>(rule.generatedCount),
        Variable<int>(rule.isPaused ? 1 : 0),
        Variable<int>(rule.isActive ? 1 : 0),
        Variable<int>(rule.isDeleted ? 1 : 0),
        Variable<int>(toMillis(rule.createdAt)),
        Variable<int>(toMillis(rule.updatedAt)),
      ],
      updates: {_db.recurringTransactions},
    );
  }

  /// Updates the template. Leaves generated history and pause state in place.
  Future<void> updateRule(RecurringRule rule) {
    return _db.customUpdate(
      '''
UPDATE recurring_transactions SET
  wallet_id = ?,
  type = ?,
  amount = ?,
  currency = ?,
  to_amount = ?,
  category_id = ?,
  to_wallet_id = ?,
  note = ?,
  payment_method = ?,
  frequency = ?,
  interval_n = ?,
  custom_unit = ?,
  start_date = ?,
  end_date = ?,
  next_due_date = ?,
  mode = ?,
  template_type = ?,
  installment_count = ?,
  amount_remaining = ?,
  is_active = ?,
  updated_at = ?
WHERE id = ? AND is_deleted = 0
''',
      variables: [
        Variable<String>(rule.walletId),
        Variable<String>(rule.type.storageValue),
        Variable<int>(rule.amount.minorUnits),
        Variable<String>(rule.currency),
        Variable<int>(rule.toAmount?.minorUnits),
        Variable<String>(rule.categoryId),
        Variable<String>(rule.toWalletId),
        Variable<String>(rule.note),
        Variable<String>(rule.paymentMethod),
        Variable<String>(rule.frequency.storageValue),
        Variable<int>(rule.intervalN),
        Variable<String>(rule.customUnit),
        Variable<int>(toMillis(rule.startDate)),
        Variable<int>(rule.endDate == null ? null : toMillis(rule.endDate!)),
        Variable<int>(toMillis(rule.nextDueDate)),
        Variable<String>(rule.mode.storageValue),
        Variable<String>(rule.templateType.storageValue),
        Variable<int>(rule.installmentCount),
        Variable<int>(rule.amountRemaining?.minorUnits),
        Variable<int>(rule.isActive ? 1 : 0),
        Variable<int>(toMillis(rule.updatedAt)),
        Variable<String>(rule.id),
      ],
      updates: {_db.recurringTransactions},
      updateKind: UpdateKind.update,
    );
  }

  Future<void> updateProgress({
    required String id,
    required DateTime? lastGeneratedDate,
    required DateTime nextDueDate,
    required int generatedCount,
    required int? amountRemaining,
    required bool isActive,
    required int updatedAt,
  }) {
    return _db.customUpdate(
      '''
UPDATE recurring_transactions SET
  last_generated_date = ?,
  next_due_date = ?,
  generated_count = ?,
  amount_remaining = ?,
  is_active = ?,
  updated_at = ?
WHERE id = ?
''',
      variables: [
        Variable<int>(
          lastGeneratedDate == null ? null : toMillis(lastGeneratedDate),
        ),
        Variable<int>(toMillis(nextDueDate)),
        Variable<int>(generatedCount),
        Variable<int>(amountRemaining),
        Variable<int>(isActive ? 1 : 0),
        Variable<int>(updatedAt),
        Variable<String>(id),
      ],
      updates: {_db.recurringTransactions},
      updateKind: UpdateKind.update,
    );
  }

  Future<void> setPaused(String id, bool paused, int updatedAt) {
    return _db.customUpdate(
      '''
UPDATE recurring_transactions
SET is_paused = ?, updated_at = ?
WHERE id = ? AND is_deleted = 0
''',
      variables: [
        Variable<int>(paused ? 1 : 0),
        Variable<int>(updatedAt),
        Variable<String>(id),
      ],
      updates: {_db.recurringTransactions},
      updateKind: UpdateKind.update,
    );
  }

  Future<void> softDelete(String id, int updatedAt) {
    return _db.customUpdate(
      '''
UPDATE recurring_transactions
SET is_deleted = 1, is_active = 0, updated_at = ?
WHERE id = ?
''',
      variables: [Variable<int>(updatedAt), Variable<String>(id)],
      updates: {_db.recurringTransactions},
      updateKind: UpdateKind.update,
    );
  }

  Future<bool> hasGeneratedTransaction(
    String recurringId,
    int dateMillis,
  ) async {
    final rows = await _db
        .customSelect(
          '''
SELECT id FROM transactions
WHERE recurring_id = ? AND date = ? AND is_deleted = 0
LIMIT 1
''',
          variables: [Variable<String>(recurringId), Variable<int>(dateMillis)],
          readsFrom: {_db.transactions},
        )
        .get();
    return rows.isNotEmpty;
  }

  Future<bool> hasRecurringReminder(String ruleId, int dueMillis) async {
    final rows = await _db
        .customSelect(
          '''
SELECT id FROM reminders
WHERE linked_id = ? AND due_date = ? AND type = 'recurring' AND is_deleted = 0
LIMIT 1
''',
          variables: [Variable<String>(ruleId), Variable<int>(dueMillis)],
          readsFrom: {_db.reminders},
        )
        .get();
    return rows.isNotEmpty;
  }

  Future<void> insertRecurringReminder({
    required String id,
    required String title,
    required int? amount,
    required String currency,
    required String? note,
    required int dueDate,
    required String? walletId,
    required String? categoryId,
    required String linkedId,
    required int createdAt,
  }) {
    return _db.customInsert(
      '''
INSERT INTO reminders (
  id, title, amount, currency, note, due_date, wallet_id, category_id,
  type, linked_type, linked_id, is_done, is_deleted, created_at, updated_at
) VALUES (${List.filled(15, '?').join(',')})
''',
      variables: [
        Variable<String>(id),
        Variable<String>(title),
        Variable<int>(amount),
        Variable<String>(currency),
        Variable<String>(note),
        Variable<int>(dueDate),
        Variable<String>(walletId),
        Variable<String>(categoryId),
        Variable<String>('recurring'),
        Variable<String>('recurring'),
        Variable<String>(linkedId),
        Variable<int>(0),
        Variable<int>(0),
        Variable<int>(createdAt),
        Variable<int>(createdAt),
      ],
      updates: {_db.reminders},
    );
  }

  RecurringRule _mapRule(QueryRow row) {
    final currency = _string(row, 'currency') ?? 'PKR';
    final toAmount = _intOpt(row, 'to_amount');
    final remaining = _intOpt(row, 'amount_remaining');
    final end = _intOpt(row, 'end_date');
    final last = _intOpt(row, 'last_generated_date');
    return RecurringRule(
      id: _string(row, 'id') ?? '',
      walletId: _string(row, 'wallet_id') ?? '',
      type: TxType.fromStorage(_string(row, 'type') ?? 'expense'),
      amount: MoneyAmount(_int(row, 'amount')),
      currency: currency,
      toAmount: toAmount == null ? null : MoneyAmount(toAmount),
      categoryId: _string(row, 'category_id'),
      toWalletId: _string(row, 'to_wallet_id'),
      note: _string(row, 'note'),
      paymentMethod: _string(row, 'payment_method'),
      frequency: RecurringFrequency.fromStorage(
        _string(row, 'frequency') ?? 'monthly',
      ),
      intervalN: _intOpt(row, 'interval_n') ?? 1,
      customUnit: _string(row, 'custom_unit'),
      startDate: fromMillis(_intOpt(row, 'start_date') ?? 0),
      endDate: end == null ? null : fromMillis(end),
      nextDueDate: fromMillis(_int(row, 'next_due_date')),
      lastGeneratedDate: last == null ? null : fromMillis(last),
      mode: RecurringMode.fromStorage(_string(row, 'mode') ?? 'ask'),
      templateType: RecurringTemplate.fromStorage(
        _string(row, 'template_type') ?? 'standard',
      ),
      installmentCount: _intOpt(row, 'installment_count'),
      amountRemaining: remaining == null ? null : MoneyAmount(remaining),
      generatedCount: _intOpt(row, 'generated_count') ?? 0,
      isPaused: _bool(row, 'is_paused'),
      isActive: _bool(row, 'is_active'),
      isDeleted: _bool(row, 'is_deleted'),
      createdAt: fromMillis(_int(row, 'created_at')),
      updatedAt: fromMillis(_int(row, 'updated_at')),
    );
  }

  Object? _raw(QueryRow row, String name) => row.data[name];

  String? _string(QueryRow row, String name) {
    final value = _raw(row, name);
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }

  int _int(QueryRow row, String name) => _intOpt(row, name) ?? 0;

  int? _intOpt(QueryRow row, String name) {
    final value = _raw(row, name);
    if (value == null) return null;
    if (value is int) return value;
    if (value is BigInt) return value.toInt();
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  bool _bool(QueryRow row, String name) {
    final value = _raw(row, name);
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is num) return value != 0;
    return false;
  }
}
