import 'package:material_ui/material_ui.dart';

import '../../../domain/enums/reminder_repeat.dart';
import '../../../domain/enums/reminder_type.dart';
import '../../../domain/models/reminder.dart';
import '../../../domain/services/reminder_scheduler.dart';
import '../../../l10n/app_localizations.dart';

String reminderTypeLabel(AppLocalizations l10n, ReminderType type) {
  return switch (type) {
    ReminderType.bill => l10n.reminderTypeBill,
    ReminderType.recurring => l10n.reminderTypeRecurring,
    ReminderType.budget => l10n.reminderTypeBudget,
    ReminderType.dailyExpense => l10n.reminderTypeDailyExpense,
  };
}

String reminderRepeatLabel(AppLocalizations l10n, ReminderRepeat? repeat) {
  return switch (repeat) {
    null => l10n.repeatNone,
    ReminderRepeat.daily => l10n.frequencyDaily,
    ReminderRepeat.weekly => l10n.frequencyWeekly,
    ReminderRepeat.monthly => l10n.frequencyMonthly,
    ReminderRepeat.yearly => l10n.frequencyYearly,
  };
}

String reminderDueLabel(
  AppLocalizations l10n,
  Reminder reminder,
  DateTime now,
) {
  if (reminder.type == ReminderType.dailyExpense) {
    return reminder.isDone ? l10n.completed : l10n.dueToday;
  }
  if (reminder.isDone) return l10n.completed;
  final days = ReminderScheduler.daysUntilDue(reminder.dueDate, now);
  if (days < 0) return l10n.overdueByDays(-days);
  if (days == 0) return l10n.dueToday;
  return l10n.dueInDays(days);
}

String reminderClockLabel(BuildContext context, int? minutes) {
  final value = minutes ?? ReminderScheduler.defaultTimeMinutes;
  final time = TimeOfDay(hour: value ~/ 60, minute: value % 60);
  return time.format(context);
}

bool reminderCanMarkPaid(Reminder reminder) {
  return !reminder.isDone &&
      reminder.type != ReminderType.budget &&
      reminder.type != ReminderType.dailyExpense;
}
