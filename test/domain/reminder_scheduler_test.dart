import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/enums/reminder_repeat.dart';
import 'package:household_finance_manager/domain/enums/reminder_type.dart';
import 'package:household_finance_manager/domain/services/reminder_scheduler.dart';

void main() {
  const nine = ReminderScheduler.defaultTimeMinutes;

  DateTime? fire({
    required DateTime due,
    required DateTime now,
    ReminderRepeat? repeat,
    int remindDaysBefore = 0,
    int? dailyTimeMinutes = nine,
    ReminderType type = ReminderType.bill,
    bool isDone = false,
  }) {
    return ReminderScheduler.nextFire(
      dueDate: due,
      repeat: repeat,
      remindDaysBefore: remindDaysBefore,
      dailyTimeMinutes: dailyTimeMinutes,
      type: type,
      isDone: isDone,
      now: now,
    );
  }

  group('next fire and days before', () {
    test('one-shot fires remindDaysBefore at the chosen time', () {
      final when = fire(
        due: DateTime(2026, 5, 10),
        now: DateTime(2026, 5, 1, 8),
        remindDaysBefore: 3,
      );
      expect(when, DateTime(2026, 5, 7, 9));
      expect(
        ReminderScheduler.remindOnDate(
          dueDate: DateTime(2026, 5, 10, 18),
          remindDaysBefore: 3,
        ),
        DateTime(2026, 5, 7),
      );
    });

    test('uses the due-date time after the early reminder has passed', () {
      final when = fire(
        due: DateTime(2026, 5, 10),
        now: DateTime(2026, 5, 7, 10),
        remindDaysBefore: 3,
      );
      expect(when, DateTime(2026, 5, 10, 9));
    });

    test('a finished one-shot has no future fire', () {
      expect(
        fire(
          due: DateTime(2026, 5, 10),
          now: DateTime(2026, 5, 1),
          isDone: true,
        ),
        isNull,
      );
    });

    test('a one-shot whose due time has passed does not fire', () {
      expect(
        fire(
          due: DateTime(2026, 5, 10),
          now: DateTime(2026, 5, 10, 9, 1),
        ),
        isNull,
      );
    });

    test('a repeating bill skips an occurrence that already fired', () {
      final when = fire(
        due: DateTime(2026, 5, 10),
        now: DateTime(2026, 5, 10, 9, 1),
        repeat: ReminderRepeat.monthly,
      );
      expect(when, DateTime(2026, 6, 10, 9));
    });
  });

  group('month length', () {
    test('31 January monthly moves to the last day of February', () {
      expect(
        ReminderScheduler.nextOccurrence(
          DateTime(2026, 1, 31),
          ReminderRepeat.monthly,
        ),
        DateTime(2026, 2, 28),
      );
      expect(
        ReminderScheduler.nextOccurrence(
          DateTime(2024, 1, 31),
          ReminderRepeat.monthly,
        ),
        DateTime(2024, 2, 29),
      );
    });

    test('advanceAfterDone clears a daily backlog through today', () {
      final next = ReminderScheduler.advanceAfterDone(
        dueDate: DateTime(2026, 5, 1),
        repeat: ReminderRepeat.daily,
        now: DateTime(2026, 5, 10, 15),
      );
      expect(next, DateTime(2026, 5, 11));
    });
  });

  group('overdue and due soon', () {
    test('a bill due yesterday is overdue and not due soon', () {
      final now = DateTime(2026, 5, 10, 12);
      expect(
        ReminderScheduler.isOverdue(
          type: ReminderType.bill,
          dueDate: DateTime(2026, 5, 9),
          isDone: false,
          now: now,
        ),
        isTrue,
      );
      expect(
        ReminderScheduler.isDueSoon(
          type: ReminderType.bill,
          dueDate: DateTime(2026, 5, 9),
          remindDaysBefore: 2,
          isDone: false,
          now: now,
        ),
        isFalse,
      );
      expect(ReminderScheduler.daysUntilDue(DateTime(2026, 5, 9), now), -1);
    });

    test('done, due today, and daily expense are not overdue', () {
      final now = DateTime(2026, 5, 10, 12);
      expect(
        ReminderScheduler.isOverdue(
          type: ReminderType.bill,
          dueDate: DateTime(2026, 5, 9),
          isDone: true,
          now: now,
        ),
        isFalse,
      );
      expect(
        ReminderScheduler.isOverdue(
          type: ReminderType.bill,
          dueDate: DateTime(2026, 5, 10),
          isDone: false,
          now: now,
        ),
        isFalse,
      );
      expect(
        ReminderScheduler.isOverdue(
          type: ReminderType.dailyExpense,
          dueDate: DateTime(2026, 5, 1),
          isDone: false,
          now: now,
        ),
        isFalse,
      );
    });

    test('due soon follows the longer of the horizon and days-before', () {
      final now = DateTime(2026, 5, 1, 8);
      expect(
        ReminderScheduler.isDueSoon(
          type: ReminderType.bill,
          dueDate: DateTime(2026, 5, 4),
          remindDaysBefore: 0,
          isDone: false,
          now: now,
        ),
        isTrue,
      );
      expect(
        ReminderScheduler.isDueSoon(
          type: ReminderType.bill,
          dueDate: DateTime(2026, 5, 20),
          remindDaysBefore: 0,
          isDone: false,
          now: now,
        ),
        isFalse,
      );
      expect(
        ReminderScheduler.isDueSoon(
          type: ReminderType.bill,
          dueDate: DateTime(2026, 5, 20),
          remindDaysBefore: 14,
          isDone: false,
          now: DateTime(2026, 5, 10, 8),
        ),
        isTrue,
      );
      expect(
        ReminderScheduler.isDueSoon(
          type: ReminderType.bill,
          dueDate: DateTime(2026, 5, 20),
          remindDaysBefore: 14,
          isDone: false,
          now: now,
        ),
        isFalse,
      );
      expect(
        ReminderScheduler.isDueSoon(
          type: ReminderType.bill,
          dueDate: DateTime(2026, 5, 4),
          remindDaysBefore: 1,
          isDone: true,
          now: now,
        ),
        isFalse,
      );
    });

    test('an open daily expense nudge is due soon', () {
      final now = DateTime(2026, 5, 10, 19);
      expect(
        ReminderScheduler.isDueSoon(
          type: ReminderType.dailyExpense,
          dueDate: DateTime(2026, 5, 10),
          remindDaysBefore: 0,
          isDone: false,
          now: now,
        ),
        isTrue,
      );
      expect(
        ReminderScheduler.isDueSoon(
          type: ReminderType.dailyExpense,
          dueDate: DateTime(2026, 5, 10),
          remindDaysBefore: 0,
          isDone: true,
          now: now,
        ),
        isFalse,
      );
    });
  });

  group('daily expense clock', () {
    test('fires later today, then tomorrow after that time', () {
      expect(
        fire(
          due: DateTime(2026, 5, 10),
          now: DateTime(2026, 5, 10, 19),
          type: ReminderType.dailyExpense,
          dailyTimeMinutes: 20 * 60,
        ),
        DateTime(2026, 5, 10, 20),
      );
      expect(
        fire(
          due: DateTime(2026, 5, 10),
          now: DateTime(2026, 5, 10, 21),
          type: ReminderType.dailyExpense,
          dailyTimeMinutes: 20 * 60,
        ),
        DateTime(2026, 5, 11, 20),
      );
    });

    test('a nudge already done today waits until tomorrow', () {
      expect(
        fire(
          due: DateTime(2026, 5, 10),
          now: DateTime(2026, 5, 10, 19),
          type: ReminderType.dailyExpense,
          dailyTimeMinutes: 20 * 60,
          isDone: true,
        ),
        DateTime(2026, 5, 11, 20),
      );
    });
  });
}
