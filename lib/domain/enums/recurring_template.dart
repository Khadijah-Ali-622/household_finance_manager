enum RecurringTemplate {
  standard,
  committee,
  installment;

  String get storageValue => name;

  static RecurringTemplate fromStorage(String value) => switch (value) {
    'committee' => RecurringTemplate.committee,
    'installment' => RecurringTemplate.installment,
    _ => RecurringTemplate.standard,
  };
}
