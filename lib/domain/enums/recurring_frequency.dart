enum RecurringFrequency {
  daily,
  weekly,
  monthly,
  yearly,
  custom;

  String get storageValue => name;

  static RecurringFrequency fromStorage(String value) => switch (value) {
    'daily' => RecurringFrequency.daily,
    'weekly' => RecurringFrequency.weekly,
    'monthly' => RecurringFrequency.monthly,
    'yearly' => RecurringFrequency.yearly,
    'custom' => RecurringFrequency.custom,
    _ => RecurringFrequency.monthly,
  };
}
