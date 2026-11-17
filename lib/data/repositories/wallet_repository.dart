import 'dart:async';

import 'package:drift/drift.dart';

import '../../core/utils/uuid.dart';
import '../../domain/enums/wallet_type.dart';
import '../../domain/models/money_amount.dart';
import '../../domain/models/wallet.dart';
import '../../domain/services/balance_calculator.dart';
import '../db/app_database.dart';
import '../db/mappers.dart';

class WalletRepository {
  WalletRepository(this._db, [BalanceCalculator? calculator])
      : _calc = calculator ?? const BalanceCalculator();

  final AppDatabase _db;
  final BalanceCalculator _calc;

  Stream<List<Wallet>> watchActiveWithBalances() {
    return _watchBalances(walletStream: _db.walletsDao.watchActive());
  }

  Stream<List<Wallet>> watchAllWithBalances() {
    return _watchBalances(
      walletStream: _db.walletsDao.watchAllIncludingArchived(),
    );
  }

  /// Recomputes balances whenever wallets *or* transactions change.
  /// Avoids nested `.watch().first` (unsafe on web's single-threaded SQLite).
  Stream<List<Wallet>> _watchBalances({
    required Stream<List<WalletRow>> walletStream,
  }) {
    late StreamController<List<Wallet>> controller;
    StreamSubscription<List<WalletRow>>? walletSub;
    StreamSubscription<List<TransactionRow>>? txSub;
    var latestWallets = <WalletRow>[];
    var latestTxs = <TransactionRow>[];
    var walletsReady = false;
    var txsReady = false;

    Future<void> emit() async {
      if (!walletsReady || !txsReady || controller.isClosed) return;
      try {
        controller.add(_mapBalances(latestWallets, latestTxs));
      } catch (e, st) {
        controller.addError(e, st);
      }
    }

    controller = StreamController<List<Wallet>>(
      onListen: () {
        walletSub = walletStream.listen((rows) {
          latestWallets = rows;
          walletsReady = true;
          emit();
        }, onError: controller.addError);
        txSub = _db.transactionsDao.watchAllActive().listen((rows) {
          latestTxs = rows;
          txsReady = true;
          emit();
        }, onError: controller.addError);
      },
      onCancel: () async {
        await walletSub?.cancel();
        await txSub?.cancel();
      },
    );

    return controller.stream;
  }

  List<Wallet> _mapBalances(
    List<WalletRow> rows,
    List<TransactionRow> txs,
  ) {
    final domainTx = txs.map((t) => t.toDomain()).toList();
    return rows.map((row) {
      final wallet = row.toDomain();
      final balance = _calc.calculate(
        openingBalance: wallet.openingBalance,
        walletId: wallet.id,
        transactions: domainTx,
      );
      return wallet.copyWith(calculatedBalance: balance);
    }).toList();
  }

  Future<List<Wallet>> _attachBalances(List<WalletRow> rows) async {
    final txs = await _db.transactionsDao.getAllActive();
    return _mapBalances(rows, txs);
  }

  Future<Wallet?> getById(String id) async {
    final row = await _db.walletsDao.getById(id);
    if (row == null || row.isDeleted) return null;
    final list = await _attachBalances([row]);
    return list.first;
  }

  Future<void> save({
    String? id,
    required String name,
    required String icon,
    required int color,
    required String currency,
    required MoneyAmount openingBalance,
    required WalletType type,
  }) async {
    final now = nowMillis();
    final walletId = id ?? newId();
    final existing = id == null ? null : await _db.walletsDao.getById(id);

    await _db.walletsDao.upsert(
      WalletsCompanion(
        id: Value(walletId),
        name: Value(name.trim()),
        icon: Value(icon),
        color: Value(color),
        currency: Value(currency),
        openingBalance: Value(openingBalance.minorUnits),
        type: Value(type.storageValue),
        isLiabilityType: Value(type.isLiabilityType),
        isArchived: Value(existing?.isArchived ?? false),
        isDeleted: const Value(false),
        createdAt: Value(existing?.createdAt ?? now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> archive(String id, {bool archived = true}) =>
      _db.walletsDao.setArchived(id, archived, nowMillis());

  Future<void> delete(String id) =>
      _db.walletsDao.softDelete(id, nowMillis());
}
