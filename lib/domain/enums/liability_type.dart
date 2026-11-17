enum LiabilityType {
  bankLoan,
  carLoan,
  houseLoan,
  creditCard,
  payable,
  committee,
  bill,
  other;

  String get storageValue => switch (this) {
        LiabilityType.bankLoan => 'bank_loan',
        LiabilityType.carLoan => 'car_loan',
        LiabilityType.houseLoan => 'house_loan',
        LiabilityType.creditCard => 'credit_card',
        LiabilityType.payable => 'payable',
        LiabilityType.committee => 'committee',
        LiabilityType.bill => 'bill',
        LiabilityType.other => 'other',
      };

  static LiabilityType fromStorage(String value) => switch (value) {
        'bank_loan' => LiabilityType.bankLoan,
        'car_loan' => LiabilityType.carLoan,
        'house_loan' => LiabilityType.houseLoan,
        'credit_card' => LiabilityType.creditCard,
        'payable' => LiabilityType.payable,
        'committee' => LiabilityType.committee,
        'bill' => LiabilityType.bill,
        _ => LiabilityType.other,
      };

  String get label => switch (this) {
        LiabilityType.bankLoan => 'Bank Loan',
        LiabilityType.carLoan => 'Car Loan',
        LiabilityType.houseLoan => 'House Loan',
        LiabilityType.creditCard => 'Credit Card',
        LiabilityType.payable => 'Payable',
        LiabilityType.committee => 'Committee (BC)',
        LiabilityType.bill => 'Bill',
        LiabilityType.other => 'Other',
      };
}
