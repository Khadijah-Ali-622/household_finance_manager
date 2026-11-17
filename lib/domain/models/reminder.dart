import '../enums/reminder_repeat.dart';
import '../enums/reminder_type.dart';
import 'money_amount.dart';

/// A bill, budget, recurring, or daily-expense reminder.
///
/// Dates are calendar instants. [amount] is null when the reminder is only a
/// nudge. [repeat] null means the reminder happens once.
class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    this.amount,
    required this.currency,
    this.note,
    required this.dueDate,
    this.repeat,
    required this.remindDaysBefore,
    this.dailyTimeMinutes,
    this.walletId,
    this.categoryId,
    required this.type,
    this.linkedType,
    this.linkedId,
    this.paidTransactionId,
    required this.isDone,
    this.lastNotifiedAt,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final MoneyAmount? amount;
  final String currency;
  final String? note;
  final DateTime dueDate;
  final ReminderRepeat? repeat;

  /// How many days before [dueDate] the notification should fire.
  final int remindDaysBefore;

  /// Minutes from midnight for the notification clock time. Null uses 09:00.
  final int? dailyTimeMinutes;
  final String? walletId;
  final String? categoryId;
  final ReminderType type;
  final String? linkedType;
  final String? linkedId;
  final String? paidTransactionId;
  final bool isDone;
  final DateTime? lastNotifiedAt;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get repeats => repeat != null;
}
