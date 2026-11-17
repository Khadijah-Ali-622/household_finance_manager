import '../enums/wallet_type.dart';
import 'money_amount.dart';

class Wallet {
  const Wallet({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.currency,
    required this.openingBalance,
    required this.type,
    required this.isLiabilityType,
    required this.isArchived,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.calculatedBalance,
  });

  final String id;
  final String name;
  final String icon;
  final int color;
  final String currency;
  final MoneyAmount openingBalance;
  final WalletType type;
  final bool isLiabilityType;
  final bool isArchived;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Live balance when loaded with aggregates; null if not computed.
  final MoneyAmount? calculatedBalance;

  MoneyAmount get balance => calculatedBalance ?? openingBalance;

  Wallet copyWith({
    String? name,
    String? icon,
    int? color,
    String? currency,
    MoneyAmount? openingBalance,
    WalletType? type,
    bool? isLiabilityType,
    bool? isArchived,
    bool? isDeleted,
    DateTime? updatedAt,
    MoneyAmount? calculatedBalance,
  }) {
    return Wallet(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      currency: currency ?? this.currency,
      openingBalance: openingBalance ?? this.openingBalance,
      type: type ?? this.type,
      isLiabilityType: isLiabilityType ?? this.isLiabilityType,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      calculatedBalance: calculatedBalance ?? this.calculatedBalance,
    );
  }
}
