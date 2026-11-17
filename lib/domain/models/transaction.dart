import '../enums/transaction_type.dart';
import 'money_amount.dart';

class Transaction {
  const Transaction({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    this.toAmount,
    this.categoryId,
    this.toWalletId,
    required this.date,
    this.note,
    this.paymentMethod,
    this.receiptPath,
    this.recurringId,
    this.linkedAssetId,
    this.linkedLiabilityId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String walletId;
  final TxType type;
  /// Amount in the from-wallet currency (always positive minor units).
  final MoneyAmount amount;
  /// Amount credited to to-wallet; defaults to [amount] when null.
  final MoneyAmount? toAmount;
  final String? categoryId;
  final String? toWalletId;
  final DateTime date;
  final String? note;
  final String? paymentMethod;
  final String? receiptPath;
  final String? recurringId;
  final String? linkedAssetId;
  final String? linkedLiabilityId;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  MoneyAmount get receivedAmount => toAmount ?? amount;

  bool get isTransfer => type == TxType.transfer;
  bool get isIncome => type == TxType.income;
  bool get isExpense => type == TxType.expense;
}
