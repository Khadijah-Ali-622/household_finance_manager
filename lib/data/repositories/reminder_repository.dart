import '../../core/utils/uuid.dart';
import '../../domain/enums/reminder_repeat.dart';
import '../../domain/enums/reminder_type.dart';
import '../../domain/enums/transaction_type.dart';
import '../../domain/models/budget.dart';
import '../../domain/models/money_amount.dart';
import '../../domain/models/reminder.dart';
import '../../domain/services/reminder_scheduler.dart';
import '../db/app_database.dart';
import '../db/daos/reminders_dao.dart';
import 'transaction_repository.dart';

/// Thrown when mark-as-paid has no amount, wallet, or category to post.
class ReminderPaymentException implements Exception {
  const ReminderPaymentException();

  @override
  String toString() =>
      'Reminder needs an amount, wallet, and category before it can be paid';
}

class ReminderRepository {
  ReminderRepository(AppDatabase db, this._transactions)
    : _dao = RemindersDao(db);

  final TransactionRepository _transactions;
  final RemindersDao _dao;

  Stream<List<Reminder>> watchAll() => _dao.watchActive();

  Stream<List<Reminder>> watchOverdue() {
    return watchAll().map((items) {
      final now = DateTime.now();
      final overdue = [
        for (final item in items)
          if (ReminderScheduler.isOverdueReminder(item, now)) item,
      ];
      overdue.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return overdue;
    });
  }

  Stream<List<Reminder>> watchDueSoon() {
    return watchAll().map((items) {
      final now = DateTime.now();
      final soon = [
        for (final item in items)
          if (ReminderScheduler.isDueSoonReminder(item, now)) item,
      ];
      soon.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return soon;
    });
  }

  Future<List<Reminder>> listActive() => _dao.getActive();

  Future<Reminder?> getById(String id) => _dao.getById(id);

  Future<void> save({
    String? id,
    required String title,
    MoneyAmount? amount,
    required String currency,
    String? note,
    required DateTime dueDate,
    ReminderRepeat? repeat,
    required int remindDaysBefore,
    int? dailyTimeMinutes,
    String? walletId,
    String? categoryId,
    required ReminderType type,
    String? linkedType,
    String? linkedId,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Title is required');
    }
    if (amount != null && amount.minorUnits <= 0) {
      throw ArgumentError('Amount must be positive');
    }

    final isDaily = type == ReminderType.dailyExpense;
    final storedRepeat = isDaily ? ReminderRepeat.daily : repeat;
    final days = isDaily
        ? 0
        : remindDaysBefore < 0
        ? 0
        : remindDaysBefore;
    final now = DateTime.now();
    var existing = id == null ? null : await _dao.getById(id);
    if (existing == null && isDaily) {
      existing = await _dao.findActiveByType(
        ReminderType.dailyExpense.storageValue,
      );
    }

    final dueChanged =
        existing != null &&
        ReminderScheduler.dateOnly(existing.dueDate) !=
            ReminderScheduler.dateOnly(dueDate);
    final reminder = Reminder(
      id: existing?.id ?? id ?? newId(),
      title: trimmed,
      amount: amount,
      currency: currency.trim().isEmpty ? 'PKR' : currency.toUpperCase(),
      note: _blankToNull(note),
      dueDate: ReminderScheduler.dateOnly(isDaily ? now : dueDate),
      repeat: storedRepeat,
      remindDaysBefore: days > 365 ? 365 : days,
      dailyTimeMinutes: _clampTime(dailyTimeMinutes),
      walletId: _blankToNull(walletId),
      categoryId: _blankToNull(categoryId),
      type: type,
      linkedType: existing?.linkedType ?? _blankToNull(linkedType),
      linkedId: existing?.linkedId ?? _blankToNull(linkedId),
      paidTransactionId: existing?.paidTransactionId,
      isDone: existing == null
          ? false
          : dueChanged
          ? false
          : existing.isDone,
      lastNotifiedAt: existing?.lastNotifiedAt,
      isDeleted: false,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    if (existing == null) {
      await _dao.insertReminder(reminder);
    } else {
      await _dao.updateReminder(reminder);
    }
  }

  Future<void> setDailyExpenseEnabled({
    required bool enabled,
    required String title,
    int dailyTimeMinutes = 20 * 60,
  }) async {
    final existing = await _dao.findActiveByType(
      ReminderType.dailyExpense.storageValue,
    );
    if (!enabled) {
      if (existing != null) {
        await _dao.softDelete(existing.id, nowMillis());
      }
      return;
    }
    if (existing != null) return;
    final now = DateTime.now();
    await _dao.insertReminder(
      Reminder(
        id: newId(),
        title: title.trim().isEmpty ? 'Add today\'s expenses' : title.trim(),
        currency: 'PKR',
        dueDate: ReminderScheduler.dateOnly(now),
        repeat: ReminderRepeat.daily,
        remindDaysBefore: 0,
        dailyTimeMinutes: _clampTime(dailyTimeMinutes),
        type: ReminderType.dailyExpense,
        isDone: false,
        isDeleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  /// Opens today's daily-expense nudge again after the previous day was done.
  Future<void> rollDailyExpenses({DateTime? now}) async {
    final clock = now ?? DateTime.now();
    final today = ReminderScheduler.dateOnly(clock);
    final items = await _dao.getActive();
    for (final item in items) {
      if (item.type != ReminderType.dailyExpense) continue;
      if (!ReminderScheduler.dateOnly(item.dueDate).isBefore(today)) continue;
      await _dao.advanceDue(item.id, today, nowMillis());
    }
  }

  /// Inserts one budget alert per threshold if that link is not already stored.
  Future<void> ensureBudgetAlert({
    required Budget budget,
    required String linkedType,
    required String title,
    DateTime? now,
  }) async {
    final existing = await _dao.findBudgetLink(budget.id, linkedType);
    if (existing != null) return;
    final clock = now ?? DateTime.now();
    final walletId = budget.walletIds.length == 1
        ? budget.walletIds.first
        : null;
    await _dao.insertReminder(
      Reminder(
        id: newId(),
        title: title.trim().isEmpty ? 'Budget' : title.trim(),
        currency: budget.currency,
        dueDate: ReminderScheduler.dateOnly(clock),
        remindDaysBefore: 0,
        walletId: walletId,
        categoryId: budget.categoryId,
        type: ReminderType.budget,
        linkedType: linkedType,
        linkedId: budget.id,
        isDone: false,
        isDeleted: false,
        createdAt: clock,
        updatedAt: clock,
      ),
    );
  }

  Future<void> markDone(String id) async {
    final reminder = await _dao.getById(id);
    if (reminder == null) return;
    final repeat = reminder.repeat;
    final closesInPlace =
        repeat == null ||
        reminder.type == ReminderType.dailyExpense ||
        reminder.type == ReminderType.budget;
    if (closesInPlace) {
      if (!reminder.isDone) {
        await _dao.setDone(id, true, nowMillis());
      }
      return;
    }
    final next = ReminderScheduler.advanceAfterDone(
      dueDate: reminder.dueDate,
      repeat: repeat,
      now: DateTime.now(),
    );
    await _dao.advanceDue(id, next, nowMillis());
  }

  /// Posts an expense, then stores its id on the reminder.
  ///
  /// Repeating bills move to the next due date. One-shot bills stay done.
  Future<void> markAsPaid(String id) async {
    final reminder = await _dao.getById(id);
    if (reminder == null) return;
    if (reminder.isDone &&
        reminder.paidTransactionId != null &&
        reminder.repeat == null) {
      return;
    }
    final amount = reminder.amount;
    final walletId = reminder.walletId;
    final categoryId = reminder.categoryId;
    if (amount == null ||
        amount.minorUnits <= 0 ||
        walletId == null ||
        categoryId == null) {
      throw const ReminderPaymentException();
    }

    final txId = newId();
    await _transactions.save(
      id: txId,
      walletId: walletId,
      type: TxType.expense,
      amount: amount,
      categoryId: categoryId,
      date: DateTime.now(),
      note: reminder.note ?? reminder.title,
    );

    final repeat = reminder.repeat;
    if (repeat == null ||
        reminder.type == ReminderType.dailyExpense ||
        reminder.type == ReminderType.budget) {
      await _dao.linkPayment(
        id: id,
        transactionId: txId,
        isDone: true,
        dueDate: reminder.dueDate,
        updatedAt: nowMillis(),
      );
      return;
    }

    final next = ReminderScheduler.advanceAfterDone(
      dueDate: reminder.dueDate,
      repeat: repeat,
      now: DateTime.now(),
    );
    await _dao.linkPayment(
      id: id,
      transactionId: txId,
      isDone: false,
      dueDate: next,
      updatedAt: nowMillis(),
    );
  }

  Future<void> delete(String id) => _dao.softDelete(id, nowMillis());

  int? _clampTime(int? minutes) {
    if (minutes == null) return null;
    if (minutes < 0) return 0;
    if (minutes > 1439) return 1439;
    return minutes;
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
