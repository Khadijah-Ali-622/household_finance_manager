import '../enums/reminder_repeat.dart';
import '../enums/reminder_type.dart';
import '../models/reminder.dart';

/// Pure schedule math for reminders.
///
/// A notification fires [remindDaysBefore] days before the due date, at
/// [Reminder.dailyTimeMinutes] (09:00 when that is empty). If that early time
/// has passed but the due date's own clock time is still ahead, the due-date
/// time is used instead. Month and year steps clamp to the last valid day
/// (31 Jan → 28 Feb).
class ReminderScheduler {
  const ReminderScheduler._();

  static const int defaultTimeMinutes = 9 * 60;
  static const int defaultSoonDays = 7;
  static const int _maxSteps = 500;

  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  /// Whole calendar days from today until [dueDate]. Negative when overdue.
  static int daysUntilDue(DateTime dueDate, DateTime now) {
    final due = DateTime.utc(dueDate.year, dueDate.month, dueDate.day);
    final today = DateTime.utc(now.year, now.month, now.day);
    return due.difference(today).inDays;
  }

  /// Calendar day the early reminder falls on.
  static DateTime remindOnDate({
    required DateTime dueDate,
    required int remindDaysBefore,
  }) {
    final due = dateOnly(dueDate);
    final days = remindDaysBefore < 0 ? 0 : remindDaysBefore;
    return DateTime(due.year, due.month, due.day - days);
  }

  /// Next due day after [dueDate] for a repeating reminder.
  static DateTime nextOccurrence(DateTime dueDate, ReminderRepeat repeat) {
    final due = dateOnly(dueDate);
    return switch (repeat) {
      ReminderRepeat.daily => DateTime(due.year, due.month, due.day + 1),
      ReminderRepeat.weekly => DateTime(due.year, due.month, due.day + 7),
      ReminderRepeat.monthly => _addMonths(due, 1),
      ReminderRepeat.yearly => _addMonths(due, 12),
    };
  }

  /// Moves at least one occurrence forward, then skips any date that is still
  /// today or earlier so a backlog of daily reminders clears in one action.
  static DateTime advanceAfterDone({
    required DateTime dueDate,
    required ReminderRepeat repeat,
    required DateTime now,
  }) {
    final today = dateOnly(now);
    var due = dateOnly(dueDate);
    for (var i = 0; i < _maxSteps; i++) {
      due = nextOccurrence(due, repeat);
      if (dateOnly(due).isAfter(today)) return dateOnly(due);
    }
    return dateOnly(due);
  }

  static DateTime? nextFire({
    required DateTime dueDate,
    required ReminderRepeat? repeat,
    required int remindDaysBefore,
    int? dailyTimeMinutes,
    required ReminderType type,
    required bool isDone,
    required DateTime now,
  }) {
    final minutes = _clampMinutes(dailyTimeMinutes ?? defaultTimeMinutes);
    if (type == ReminderType.dailyExpense) {
      final skipToday =
          isDone && !dateOnly(dueDate).isBefore(dateOnly(now));
      return _nextClock(now, minutes, skipToday: skipToday);
    }

    if (repeat == null) {
      if (isDone) return null;
      return _fireForDue(
        dueDate: dueDate,
        remindDaysBefore: remindDaysBefore,
        minutes: minutes,
        now: now,
      );
    }

    var due = dateOnly(dueDate);
    for (var i = 0; i < _maxSteps; i++) {
      final fire = _fireForDue(
        dueDate: due,
        remindDaysBefore: remindDaysBefore,
        minutes: minutes,
        now: now,
      );
      if (fire != null) return fire;
      final upcoming = nextOccurrence(due, repeat);
      if (!upcoming.isAfter(due)) return null;
      due = upcoming;
    }
    return null;
  }

  static DateTime? nextFireFor(Reminder reminder, DateTime now) {
    return nextFire(
      dueDate: reminder.dueDate,
      repeat: reminder.repeat,
      remindDaysBefore: reminder.remindDaysBefore,
      dailyTimeMinutes: reminder.dailyTimeMinutes,
      type: reminder.type,
      isDone: reminder.isDone,
      now: now,
    );
  }

  /// Open bill whose due calendar day is before today.
  /// Daily expense nudges are never overdue.
  static bool isOverdue({
    required ReminderType type,
    required DateTime dueDate,
    required bool isDone,
    required DateTime now,
  }) {
    if (isDone || type == ReminderType.dailyExpense) return false;
    return dateOnly(dueDate).isBefore(dateOnly(now));
  }

  static bool isOverdueReminder(Reminder reminder, DateTime now) {
    return isOverdue(
      type: reminder.type,
      dueDate: reminder.dueDate,
      isDone: reminder.isDone,
      now: now,
    );
  }

  /// Inside the remind-before window, or within [horizonDays] when that is
  /// longer. Overdue and finished reminders are excluded. An open daily
  /// expense nudge counts as due.
  static bool isDueSoon({
    required ReminderType type,
    required DateTime dueDate,
    required int remindDaysBefore,
    required bool isDone,
    required DateTime now,
    int horizonDays = defaultSoonDays,
  }) {
    if (isDone) return false;
    if (isOverdue(
      type: type,
      dueDate: dueDate,
      isDone: isDone,
      now: now,
    )) {
      return false;
    }
    if (type == ReminderType.dailyExpense) return true;
    final lead = remindDaysBefore < 0 ? 0 : remindDaysBefore;
    final window = lead > horizonDays ? lead : horizonDays;
    return daysUntilDue(dueDate, now) <= window;
  }

  static bool isDueSoonReminder(
    Reminder reminder,
    DateTime now, {
    int horizonDays = defaultSoonDays,
  }) {
    return isDueSoon(
      type: reminder.type,
      dueDate: reminder.dueDate,
      remindDaysBefore: reminder.remindDaysBefore,
      isDone: reminder.isDone,
      now: now,
      horizonDays: horizonDays,
    );
  }

  static DateTime? _fireForDue({
    required DateTime dueDate,
    required int remindDaysBefore,
    required int minutes,
    required DateTime now,
  }) {
    final early = _at(remindOnDate(
      dueDate: dueDate,
      remindDaysBefore: remindDaysBefore,
    ), minutes);
    if (early.isAfter(now)) return early;
    final onDue = _at(dateOnly(dueDate), minutes);
    if (onDue.isAfter(now) && onDue != early) return onDue;
    return null;
  }

  static DateTime _nextClock(
    DateTime now,
    int minutes, {
    required bool skipToday,
  }) {
    var day = dateOnly(now);
    if (skipToday) {
      day = DateTime(day.year, day.month, day.day + 1);
    }
    final fire = _at(day, minutes);
    if (fire.isAfter(now)) return fire;
    final tomorrow = DateTime(day.year, day.month, day.day + 1);
    return _at(tomorrow, minutes);
  }

  static DateTime _at(DateTime day, int minutes) {
    return DateTime(day.year, day.month, day.day, minutes ~/ 60, minutes % 60);
  }

  static int _clampMinutes(int minutes) {
    if (minutes < 0) return 0;
    if (minutes > 23 * 60 + 59) return 23 * 60 + 59;
    return minutes;
  }

  static DateTime _addMonths(DateTime from, int months) {
    final index = (from.year * 12 + (from.month - 1)) + months;
    final year = index ~/ 12;
    final month = index % 12 + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = from.day > lastDay ? lastDay : from.day;
    return DateTime(year, month, day);
  }
}
