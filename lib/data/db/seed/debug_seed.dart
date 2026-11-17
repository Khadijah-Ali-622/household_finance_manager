import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/default_categories.dart';
import '../../../core/utils/uuid.dart';
import '../app_database.dart';

/// Seeds default categories always; sample wallets/tx only in debug.
class DebugSeed {
  DebugSeed(this.db);

  final AppDatabase db;

  Future<void> runIfNeeded() async {
    await _ensureDefaultCategories();
    if (kDebugMode) {
      await _seedSampleDataIfEmpty();
    }
  }

  Future<void> _ensureDefaultCategories() async {
    final count = await db.categoriesDao.countDefaults();
    if (count > 0) return;

    final now = nowMillis();
    final entries = defaultCategories()
        .map(
          (c) => CategoriesCompanion.insert(
            id: c.id,
            name: c.name,
            icon: c.icon,
            color: c.color,
            type: c.type,
            parentId: Value(c.parentId),
            isDefault: const Value(true),
            sortOrder: Value(c.sortOrder),
            createdAt: now,
            updatedAt: now,
          ),
        )
        .toList();
    await db.categoriesDao.upsertAll(entries);
  }

  Future<void> _seedSampleDataIfEmpty() async {
    final wallets = await db.walletsDao.getActive();
    if (wallets.isNotEmpty) return;

    final now = nowMillis();
    final cashId = newId();
    final bankId = newId();
    final jazzId = newId();

    await db.walletsDao.upsert(
      WalletsCompanion.insert(
        id: cashId,
        name: 'Cash',
        icon: 'account_balance_wallet',
        color: 0xFF2E7D32,
        openingBalance: const Value(500000), // Rs 5,000
        type: 'cash',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.walletsDao.upsert(
      WalletsCompanion.insert(
        id: bankId,
        name: 'HBL Bank',
        icon: 'account_balance',
        color: 0xFF1565C0,
        openingBalance: const Value(5000000), // Rs 50,000
        type: 'bank',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.walletsDao.upsert(
      WalletsCompanion.insert(
        id: jazzId,
        name: 'JazzCash',
        icon: 'phone_android',
        color: 0xFFC62828,
        openingBalance: const Value(200000), // Rs 2,000
        type: 'mobile_wallet',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final today = DateTime.now();
    Future<void> addTx({
      required String walletId,
      required String type,
      required int amount,
      String? categoryId,
      String? toWalletId,
      required DateTime date,
      String? note,
    }) {
      return db.transactionsDao.upsert(
        TransactionsCompanion.insert(
          id: newId(),
          walletId: walletId,
          type: type,
          amount: amount,
          categoryId: Value(categoryId),
          toWalletId: Value(toWalletId),
          date: toMillis(date),
          note: Value(note),
          paymentMethod: const Value('cash'),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    await addTx(
      walletId: bankId,
      type: 'income',
      amount: 8000000,
      categoryId: 'cat-salary',
      date: DateTime(today.year, today.month, 1),
      note: 'Monthly salary',
    );
    await addTx(
      walletId: cashId,
      type: 'expense',
      amount: 350000,
      categoryId: 'cat-rashan',
      date: DateTime(today.year, today.month, 3),
      note: 'Weekly rashan',
    );
    await addTx(
      walletId: bankId,
      type: 'expense',
      amount: 450000,
      categoryId: 'cat-bijli',
      date: DateTime(today.year, today.month, 5),
      note: 'KE bill',
    );
    await addTx(
      walletId: bankId,
      type: 'transfer',
      amount: 1000000,
      toWalletId: cashId,
      date: DateTime(today.year, today.month, 7),
      note: 'ATM withdrawal',
    );
    await addTx(
      walletId: jazzId,
      type: 'expense',
      amount: 50000,
      categoryId: 'cat-mobile',
      date: DateTime(today.year, today.month, 8),
      note: 'Mobile load',
    );

    await db.assetsDao.upsert(
      AssetsCompanion.insert(
        id: newId(),
        name: 'Gold (2 tola)',
        type: 'gold',
        currentValue: 48000000, // Rs 480,000
        quantity: const Value('2'),
        unit: const Value('tola'),
        createdAt: now,
        updatedAt: now,
      ),
    );

    await db.liabilitiesDao.upsert(
      LiabilitiesCompanion.insert(
        id: newId(),
        name: 'Bike Loan',
        type: 'bank_loan',
        totalAmount: 15000000,
        remainingAmount: 9000000,
        installmentAmount: const Value(1500000),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final groupId = newId();
    await db.walletGroupsDao.saveGroup(
      group: WalletGroupsCompanion.insert(
        id: groupId,
        name: 'Ghar ke Kharche',
        icon: const Value('home'),
        createdAt: now,
        updatedAt: now,
      ),
      walletIds: [cashId, jazzId],
      createdAt: now,
    );
  }
}
