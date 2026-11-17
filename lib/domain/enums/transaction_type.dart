enum TxType {
  income,
  expense,
  transfer;

  String get storageValue => name;

  static TxType fromStorage(String value) => switch (value) {
        'income' => TxType.income,
        'expense' => TxType.expense,
        'transfer' => TxType.transfer,
        _ => TxType.expense,
      };

  String get label => switch (this) {
        TxType.income => 'Income',
        TxType.expense => 'Expense',
        TxType.transfer => 'Transfer',
      };
}
