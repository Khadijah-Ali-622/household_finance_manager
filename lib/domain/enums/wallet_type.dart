enum WalletType {
  cash,
  bank,
  mobileWallet,
  creditCard,
  other;

  String get storageValue => switch (this) {
        WalletType.cash => 'cash',
        WalletType.bank => 'bank',
        WalletType.mobileWallet => 'mobile_wallet',
        WalletType.creditCard => 'credit_card',
        WalletType.other => 'other',
      };

  static WalletType fromStorage(String value) => switch (value) {
        'cash' => WalletType.cash,
        'bank' => WalletType.bank,
        'mobile_wallet' => WalletType.mobileWallet,
        'credit_card' => WalletType.creditCard,
        _ => WalletType.other,
      };

  String get label => switch (this) {
        WalletType.cash => 'Cash',
        WalletType.bank => 'Bank',
        WalletType.mobileWallet => 'Mobile Wallet',
        WalletType.creditCard => 'Credit Card',
        WalletType.other => 'Other',
      };

  bool get isLiabilityType => this == WalletType.creditCard;
}
