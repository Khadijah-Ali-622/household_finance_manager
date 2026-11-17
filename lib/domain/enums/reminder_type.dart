enum ReminderType {
  bill,
  recurring,
  budget,
  dailyExpense;

  /// Stored in `reminders.type`.
  String get storageValue => switch (this) {
    ReminderType.bill => 'bill',
    ReminderType.recurring => 'recurring',
    ReminderType.budget => 'budget',
    ReminderType.dailyExpense => 'daily_expense',
  };

  static ReminderType fromStorage(String? value) => switch (value) {
    'recurring' => ReminderType.recurring,
    'budget' => ReminderType.budget,
    'daily_expense' => ReminderType.dailyExpense,
    _ => ReminderType.bill,
  };
}
