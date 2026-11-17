enum RecurringMode {
  auto,
  ask;

  String get storageValue => name;

  static RecurringMode fromStorage(String value) => switch (value) {
    'auto' => RecurringMode.auto,
    _ => RecurringMode.ask,
  };
}
