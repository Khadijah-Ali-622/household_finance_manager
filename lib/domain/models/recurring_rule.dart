import '../enums/recurring_frequency.dart';
import '../enums/recurring_mode.dart';
import '../enums/recurring_template.dart';
import '../enums/transaction_type.dart';
import 'money_amount.dart';

class RecurringRule {
  const RecurringRule({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.currency,
    this.toAmount,
    this.categoryId,
    this.toWalletId,
    this.note,
    this.paymentMethod,
    required this.frequency,
    required this.intervalN,
    this.customUnit,
    required this.startDate,
    this.endDate,
    required this.nextDueDate,
    this.lastGeneratedDate,
    required this.mode,
    required this.templateType,
    this.installmentCount,
    this.amountRemaining,
    required this.generatedCount,
    required this.isPaused,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String walletId;
  final TxType type;
  final MoneyAmount amount;
  final String currency;
  final MoneyAmount? toAmount;
  final String? categoryId;
  final String? toWalletId;
  final String? note;
  final String? paymentMethod;
  final RecurringFrequency frequency;
  final int intervalN;

  /// `days` or `months` when [frequency] is [RecurringFrequency.custom].
  final String? customUnit;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime nextDueDate;
  final DateTime? lastGeneratedDate;
  final RecurringMode mode;
  final RecurringTemplate templateType;
  final int? installmentCount;
  final MoneyAmount? amountRemaining;
  final int generatedCount;
  final bool isPaused;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isInstallment => templateType == RecurringTemplate.installment;
}
