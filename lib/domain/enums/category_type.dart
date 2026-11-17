enum CategoryType {
  income,
  expense;

  String get storageValue => name;

  static CategoryType fromStorage(String value) => switch (value) {
        'income' => CategoryType.income,
        _ => CategoryType.expense,
      };
}
