import 'money_amount.dart';

/// Monthly spending budget. [categoryId] null means every category.
/// Empty [walletIds] means every wallet.
class Budget {
  const Budget({
    required this.id,
    this.categoryId,
    this.walletIds = const [],
    required this.amount,
    required this.currency,
    required this.yearMonth,
    required this.rollover,
    required this.notify80,
    required this.notifyOver,
    this.lastNotified80At,
    this.lastNotifiedOverAt,
    this.name,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String? categoryId;
  final List<String> walletIds;
  final MoneyAmount amount;
  final String currency;

  /// Period as YYYYMM.
  final int yearMonth;
  final bool rollover;
  final bool notify80;
  final bool notifyOver;
  final DateTime? lastNotified80At;
  final DateTime? lastNotifiedOverAt;
  final String? name;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isOverall => categoryId == null;
}
