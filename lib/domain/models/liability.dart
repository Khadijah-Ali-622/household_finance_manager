import '../enums/liability_type.dart';
import 'money_amount.dart';

class Liability {
  const Liability({
    required this.id,
    required this.name,
    required this.type,
    required this.totalAmount,
    required this.remainingAmount,
    this.currency = 'PKR',
    this.installmentAmount,
    this.dueDate,
    this.interestRate,
    this.notes,
    this.linkedWalletId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final LiabilityType type;
  final MoneyAmount totalAmount;
  final MoneyAmount remainingAmount;
  final String currency;
  final MoneyAmount? installmentAmount;
  final DateTime? dueDate;
  final String? interestRate;
  final String? notes;
  final String? linkedWalletId;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
}
