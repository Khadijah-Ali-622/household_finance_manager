enum ReminderRepeat {
  daily,
  weekly,
  monthly,
  yearly;

  /// Stored in `reminders.repeat_frequency`. Null in the database means once.
  String get storageValue => name;

  static ReminderRepeat? fromStorage(String? value) => switch (value) {
    'daily' => ReminderRepeat.daily,
    'weekly' => ReminderRepeat.weekly,
    'monthly' => ReminderRepeat.monthly,
    'yearly' => ReminderRepeat.yearly,
    _ => null,
  };
}
