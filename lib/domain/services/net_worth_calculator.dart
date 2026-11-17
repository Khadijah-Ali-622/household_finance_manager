import '../models/asset.dart';
import '../models/liability.dart';
import '../models/money_amount.dart';
import '../models/wallet.dart';
import 'currency_converter.dart';

/// Net Worth = total assets (incl. non-CC wallet balances) − total liabilities
/// (explicit liabilities + credit-card wallet balances as debt).
///
/// When [converter] is provided, all amounts are converted to the base currency.
class NetWorthCalculator {
  const NetWorthCalculator();

  MoneyAmount calculate({
    required Iterable<Wallet> walletsWithBalances,
    required Iterable<Asset> assets,
    required Iterable<Liability> liabilities,
    CurrencyConverter? converter,
  }) {
    var total = 0;

    for (final asset in assets) {
      if (asset.isDeleted) continue;
      total += _toBase(
        asset.currentValue,
        asset.currency,
        converter,
      ).minorUnits;
    }

    for (final wallet in walletsWithBalances) {
      if (wallet.isDeleted || wallet.isArchived) continue;
      final bal = _toBase(wallet.balance, wallet.currency, converter);
      if (wallet.isLiabilityType) {
        total -= bal.minorUnits;
      } else {
        total += bal.minorUnits;
      }
    }

    for (final liability in liabilities) {
      if (liability.isDeleted) continue;
      total -= _toBase(
        liability.remainingAmount,
        liability.currency,
        converter,
      ).minorUnits;
    }

    return MoneyAmount(total);
  }

  MoneyAmount totalAssets({
    required Iterable<Wallet> walletsWithBalances,
    required Iterable<Asset> assets,
    CurrencyConverter? converter,
  }) {
    var total = 0;
    for (final asset in assets) {
      if (asset.isDeleted) continue;
      total += _toBase(
        asset.currentValue,
        asset.currency,
        converter,
      ).minorUnits;
    }
    for (final wallet in walletsWithBalances) {
      if (wallet.isDeleted || wallet.isArchived || wallet.isLiabilityType) {
        continue;
      }
      total +=
          _toBase(wallet.balance, wallet.currency, converter).minorUnits;
    }
    return MoneyAmount(total);
  }

  MoneyAmount totalLiabilities({
    required Iterable<Wallet> walletsWithBalances,
    required Iterable<Liability> liabilities,
    CurrencyConverter? converter,
  }) {
    var total = 0;
    for (final liability in liabilities) {
      if (liability.isDeleted) continue;
      total += _toBase(
        liability.remainingAmount,
        liability.currency,
        converter,
      ).minorUnits;
    }
    for (final wallet in walletsWithBalances) {
      if (wallet.isDeleted || wallet.isArchived || !wallet.isLiabilityType) {
        continue;
      }
      total +=
          _toBase(wallet.balance, wallet.currency, converter).minorUnits;
    }
    return MoneyAmount(total);
  }

  MoneyAmount _toBase(
    MoneyAmount amount,
    String currency,
    CurrencyConverter? converter,
  ) {
    if (converter == null) return amount;
    return converter.toBase(amount, currency);
  }
}
