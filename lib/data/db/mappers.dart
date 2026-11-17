import '../../core/utils/uuid.dart';
import '../../domain/enums/asset_type.dart';
import '../../domain/enums/category_type.dart';
import '../../domain/enums/liability_type.dart';
import '../../domain/enums/transaction_type.dart';
import '../../domain/enums/wallet_type.dart';
import '../../domain/models/asset.dart';
import '../../domain/models/budget.dart';
import '../../domain/models/category.dart';
import '../../domain/models/liability.dart';
import '../../domain/models/money_amount.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/wallet.dart';
import '../../domain/models/wallet_group.dart';
import 'app_database.dart';

extension WalletRowMapper on WalletRow {
  Wallet toDomain({MoneyAmount? calculatedBalance}) => Wallet(
        id: id,
        name: name,
        icon: icon,
        color: color,
        currency: currency,
        openingBalance: MoneyAmount(openingBalance),
        type: WalletType.fromStorage(type),
        isLiabilityType: isLiabilityType,
        isArchived: isArchived,
        isDeleted: isDeleted,
        createdAt: fromMillis(createdAt),
        updatedAt: fromMillis(updatedAt),
        calculatedBalance: calculatedBalance,
      );
}

extension CategoryRowMapper on CategoryRow {
  Category toDomain() => Category(
        id: id,
        name: name,
        icon: icon,
        color: color,
        type: CategoryType.fromStorage(type),
        parentId: parentId,
        isDefault: isDefault,
        sortOrder: sortOrder,
        isDeleted: isDeleted,
        createdAt: fromMillis(createdAt),
        updatedAt: fromMillis(updatedAt),
      );
}

extension TransactionRowMapper on TransactionRow {
  Transaction toDomain() => Transaction(
        id: id,
        walletId: walletId,
        type: TxType.fromStorage(type),
        amount: MoneyAmount(amount),
        toAmount: toAmount == null ? null : MoneyAmount(toAmount!),
        categoryId: categoryId,
        toWalletId: toWalletId,
        date: fromMillis(date),
        note: note,
        paymentMethod: paymentMethod,
        receiptPath: receiptPath,
        recurringId: recurringId,
        linkedAssetId: linkedAssetId,
        linkedLiabilityId: linkedLiabilityId,
        isDeleted: isDeleted,
        createdAt: fromMillis(createdAt),
        updatedAt: fromMillis(updatedAt),
      );
}

extension AssetRowMapper on AssetRow {
  Asset toDomain() => Asset(
        id: id,
        name: name,
        type: AssetType.fromStorage(type),
        purchasePrice:
            purchasePrice == null ? null : MoneyAmount(purchasePrice!),
        purchaseDate: purchaseDate == null ? null : fromMillis(purchaseDate!),
        currentValue: MoneyAmount(currentValue),
        currency: currency,
        quantity: quantity,
        unit: unit,
        notes: notes,
        photoPath: photoPath,
        isDeleted: isDeleted,
        createdAt: fromMillis(createdAt),
        updatedAt: fromMillis(updatedAt),
      );
}

extension BudgetRowMapper on BudgetRow {
  Budget toDomain({List<String> walletIds = const []}) {
    final single = walletId;
    final ids = walletIds.isNotEmpty
        ? List<String>.from(walletIds)
        : (single == null || single.isEmpty)
            ? const <String>[]
            : <String>[single];
    final period = yearMonth == 0 ? startMonth : yearMonth;
    return Budget(
      id: id,
      categoryId: categoryId,
      walletIds: ids,
      amount: MoneyAmount(amount),
      currency: currency,
      yearMonth: period,
      rollover: rollover,
      notify80: notify80,
      notifyOver: notifyOver,
      lastNotified80At: lastNotified80At == null
          ? null
          : fromMillis(lastNotified80At!),
      lastNotifiedOverAt: lastNotifiedOverAt == null
          ? null
          : fromMillis(lastNotifiedOverAt!),
      name: name,
      isDeleted: isDeleted,
      createdAt: fromMillis(createdAt),
      updatedAt: fromMillis(updatedAt),
    );
  }
}

extension LiabilityRowMapper on LiabilityRow {
  Liability toDomain() => Liability(
        id: id,
        name: name,
        type: LiabilityType.fromStorage(type),
        totalAmount: MoneyAmount(totalAmount),
        remainingAmount: MoneyAmount(remainingAmount),
        currency: currency,
        installmentAmount: installmentAmount == null
            ? null
            : MoneyAmount(installmentAmount!),
        dueDate: dueDate == null ? null : fromMillis(dueDate!),
        interestRate: interestRate,
        notes: notes,
        linkedWalletId: linkedWalletId,
        isDeleted: isDeleted,
        createdAt: fromMillis(createdAt),
        updatedAt: fromMillis(updatedAt),
      );
}

WalletGroup mapWalletGroup(WalletGroupRow row, List<String> walletIds) =>
    WalletGroup(
      id: row.id,
      name: row.name,
      icon: row.icon,
      walletIds: walletIds,
      isDeleted: row.isDeleted,
      createdAt: fromMillis(row.createdAt),
      updatedAt: fromMillis(row.updatedAt),
    );
