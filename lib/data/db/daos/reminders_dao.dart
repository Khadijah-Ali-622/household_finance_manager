import 'package:drift/drift.dart';

import '../../../core/utils/uuid.dart';
import '../../../domain/enums/reminder_repeat.dart';
import '../../../domain/enums/reminder_type.dart';
import '../../../domain/models/money_amount.dart';
import '../../../domain/models/reminder.dart';
import '../app_database.dart';

/// Reads and writes reminders with SQL.
///
/// The checked-in drift [Reminder] data class predates the expanded columns
/// on the reminders table (amount, currency, repeat, and the rest). Queries
/// here use the real table so those columns work without running build_runner.
class RemindersDao {
  RemindersDao(this._db);

  final AppDatabase _db;

  static const _columns = '''
id, title, amount, currency, note, due_date, repeat_frequency,
remind_days_before, daily_time_minutes, wallet_id, category_id, type,
linked_type, linked_id, paid_transaction_id, is_done, last_notified_at,
is_deleted, created_at, updated_at
''';

  Stream<List<Reminder>> watchActive() {
    return _db
        .customSelect(
          '''
SELECT $_columns
FROM reminders
WHERE is_deleted = 0
ORDER BY is_done ASC, due_date ASC
''',
          readsFrom: {_db.reminders},
        )
        .watch()
        .map((rows) => rows.map(_map).toList());
  }

  Future<List<Reminder>> getActive() {
    return _db
        .customSelect(
          '''
SELECT $_columns
FROM reminders
WHERE is_deleted = 0
ORDER BY due_date ASC
''',
          readsFrom: {_db.reminders},
        )
        .get()
        .then((rows) => rows.map(_map).toList());
  }

  Future<Reminder?> getById(String id) async {
    final rows = await _db
        .customSelect(
          '''
SELECT $_columns
FROM reminders
WHERE id = ? AND is_deleted = 0
LIMIT 1
''',
          variables: [Variable<String>(id)],
          readsFrom: {_db.reminders},
        )
        .get();
    if (rows.isEmpty) return null;
    return _map(rows.first);
  }

  Future<Reminder?> findActiveByType(String type) async {
    final rows = await _db
        .customSelect(
          '''
SELECT $_columns
FROM reminders
WHERE type = ? AND is_deleted = 0
ORDER BY created_at ASC
LIMIT 1
''',
          variables: [Variable<String>(type)],
          readsFrom: {_db.reminders},
        )
        .get();
    if (rows.isEmpty) return null;
    return _map(rows.first);
  }

  Future<Reminder?> findBudgetLink(String budgetId, String linkedType) async {
    final rows = await _db
        .customSelect(
          '''
SELECT $_columns
FROM reminders
WHERE type = 'budget' AND linked_id = ? AND linked_type = ? AND is_deleted = 0
LIMIT 1
''',
          variables: [
            Variable<String>(budgetId),
            Variable<String>(linkedType),
          ],
          readsFrom: {_db.reminders},
        )
        .get();
    if (rows.isEmpty) return null;
    return _map(rows.first);
  }

  Future<void> insertReminder(Reminder reminder) {
    return _db.customInsert(
      '''
INSERT INTO reminders (
  id, title, amount, currency, note, due_date, repeat_frequency,
  remind_days_before, daily_time_minutes, wallet_id, category_id, type,
  linked_type, linked_id, paid_transaction_id, is_done, last_notified_at,
  is_deleted, created_at, updated_at
) VALUES (${List.filled(20, '?').join(',')})
''',
      variables: [
        Variable<String>(reminder.id),
        Variable<String>(reminder.title),
        Variable<int>(reminder.amount?.minorUnits),
        Variable<String>(reminder.currency),
        Variable<String>(reminder.note),
        Variable<int>(toMillis(reminder.dueDate)),
        Variable<String>(reminder.repeat?.storageValue),
        Variable<int>(reminder.remindDaysBefore),
        Variable<int>(reminder.dailyTimeMinutes),
        Variable<String>(reminder.walletId),
        Variable<String>(reminder.categoryId),
        Variable<String>(reminder.type.storageValue),
        Variable<String>(reminder.linkedType),
        Variable<String>(reminder.linkedId),
        Variable<String>(reminder.paidTransactionId),
        Variable<int>(reminder.isDone ? 1 : 0),
        Variable<int>(
          reminder.lastNotifiedAt == null
              ? null
              : toMillis(reminder.lastNotifiedAt!),
        ),
        Variable<int>(reminder.isDeleted ? 1 : 0),
        Variable<int>(toMillis(reminder.createdAt)),
        Variable<int>(toMillis(reminder.updatedAt)),
      ],
      updates: {_db.reminders},
    );
  }

  Future<void> updateReminder(Reminder reminder) {
    return _db.customUpdate(
      '''
UPDATE reminders SET
  title = ?,
  amount = ?,
  currency = ?,
  note = ?,
  due_date = ?,
  repeat_frequency = ?,
  remind_days_before = ?,
  daily_time_minutes = ?,
  wallet_id = ?,
  category_id = ?,
  type = ?,
  is_done = ?,
  updated_at = ?
WHERE id = ? AND is_deleted = 0
''',
      variables: [
        Variable<String>(reminder.title),
        Variable<int>(reminder.amount?.minorUnits),
        Variable<String>(reminder.currency),
        Variable<String>(reminder.note),
        Variable<int>(toMillis(reminder.dueDate)),
        Variable<String>(reminder.repeat?.storageValue),
        Variable<int>(reminder.remindDaysBefore),
        Variable<int>(reminder.dailyTimeMinutes),
        Variable<String>(reminder.walletId),
        Variable<String>(reminder.categoryId),
        Variable<String>(reminder.type.storageValue),
        Variable<int>(reminder.isDone ? 1 : 0),
        Variable<int>(toMillis(reminder.updatedAt)),
        Variable<String>(reminder.id),
      ],
      updates: {_db.reminders},
      updateKind: UpdateKind.update,
    );
  }

  Future<void> setDone(String id, bool done, int updatedAt) {
    return _db.customUpdate(
      '''
UPDATE reminders
SET is_done = ?, updated_at = ?
WHERE id = ? AND is_deleted = 0
''',
      variables: [
        Variable<int>(done ? 1 : 0),
        Variable<int>(updatedAt),
        Variable<String>(id),
      ],
      updates: {_db.reminders},
      updateKind: UpdateKind.update,
    );
  }

  Future<void> advanceDue(String id, DateTime dueDate, int updatedAt) {
    return _db.customUpdate(
      '''
UPDATE reminders
SET due_date = ?, is_done = 0, updated_at = ?
WHERE id = ? AND is_deleted = 0
''',
      variables: [
        Variable<int>(toMillis(dueDate)),
        Variable<int>(updatedAt),
        Variable<String>(id),
      ],
      updates: {_db.reminders},
      updateKind: UpdateKind.update,
    );
  }

  Future<void> linkPayment({
    required String id,
    required String transactionId,
    required bool isDone,
    required DateTime dueDate,
    required int updatedAt,
  }) {
    return _db.customUpdate(
      '''
UPDATE reminders
SET paid_transaction_id = ?, is_done = ?, due_date = ?, updated_at = ?
WHERE id = ? AND is_deleted = 0
''',
      variables: [
        Variable<String>(transactionId),
        Variable<int>(isDone ? 1 : 0),
        Variable<int>(toMillis(dueDate)),
        Variable<int>(updatedAt),
        Variable<String>(id),
      ],
      updates: {_db.reminders},
      updateKind: UpdateKind.update,
    );
  }

  Future<void> softDelete(String id, int updatedAt) {
    return _db.customUpdate(
      '''
UPDATE reminders
SET is_deleted = 1, updated_at = ?
WHERE id = ?
''',
      variables: [Variable<int>(updatedAt), Variable<String>(id)],
      updates: {_db.reminders},
      updateKind: UpdateKind.update,
    );
  }

  Reminder _map(QueryRow row) {
    final amount = _intOpt(row, 'amount');
    final notified = _intOpt(row, 'last_notified_at');
    return Reminder(
      id: _string(row, 'id') ?? '',
      title: _string(row, 'title') ?? '',
      amount: amount == null ? null : MoneyAmount(amount),
      currency: _string(row, 'currency') ?? 'PKR',
      note: _string(row, 'note'),
      dueDate: fromMillis(_int(row, 'due_date')),
      repeat: ReminderRepeat.fromStorage(_string(row, 'repeat_frequency')),
      remindDaysBefore: _intOpt(row, 'remind_days_before') ?? 0,
      dailyTimeMinutes: _intOpt(row, 'daily_time_minutes'),
      walletId: _string(row, 'wallet_id'),
      categoryId: _string(row, 'category_id'),
      type: ReminderType.fromStorage(_string(row, 'type')),
      linkedType: _string(row, 'linked_type'),
      linkedId: _string(row, 'linked_id'),
      paidTransactionId: _string(row, 'paid_transaction_id'),
      isDone: _bool(row, 'is_done'),
      lastNotifiedAt: notified == null ? null : fromMillis(notified),
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
