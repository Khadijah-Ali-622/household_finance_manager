import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/enums/asset_type.dart';
import 'package:household_finance_manager/domain/enums/liability_type.dart';
import 'package:household_finance_manager/domain/enums/wallet_type.dart';
import 'package:household_finance_manager/domain/models/asset.dart';
import 'package:household_finance_manager/domain/models/liability.dart';
import 'package:household_finance_manager/domain/models/money_amount.dart';
import 'package:household_finance_manager/domain/models/wallet.dart';
import 'package:household_finance_manager/domain/services/net_worth_calculator.dart';

Wallet _wallet({
  required String id,
  required int balance,
  bool isLiability = false,
}) {
  final now = DateTime.now();
  return Wallet(
    id: id,
    name: id,
    icon: 'wallet',
    color: 0xFF000000,
    currency: 'PKR',
    openingBalance: MoneyAmount.zero,
    type: isLiability ? WalletType.creditCard : WalletType.cash,
    isLiabilityType: isLiability,
    isArchived: false,
    isDeleted: false,
    createdAt: now,
    updatedAt: now,
    calculatedBalance: MoneyAmount(balance),
  );
}

void main() {
  const calc = NetWorthCalculator();

  test('net worth = assets + wallets - liabilities - CC wallets', () {
    final now = DateTime.now();
    final nw = calc.calculate(
      walletsWithBalances: [
        _wallet(id: 'cash', balance: 100000),
        _wallet(id: 'cc', balance: 20000, isLiability: true),
      ],
      assets: [
        Asset(
          id: 'a1',
          name: 'Gold',
          type: AssetType.gold,
          currentValue: const MoneyAmount(500000),
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      liabilities: [
        Liability(
          id: 'l1',
          name: 'Loan',
          type: LiabilityType.bankLoan,
          totalAmount: const MoneyAmount(300000),
          remainingAmount: const MoneyAmount(150000),
          isDeleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );
    // 500000 + 100000 - 20000 - 150000 = 430000
    expect(nw.minorUnits, 430000);
  });
}
