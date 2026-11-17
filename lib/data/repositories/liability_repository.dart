import 'package:drift/drift.dart';

import '../../core/utils/uuid.dart';
import '../../domain/enums/liability_type.dart';
import '../../domain/models/liability.dart';
import '../../domain/models/money_amount.dart';
import '../db/app_database.dart';
import '../db/mappers.dart';

class LiabilityRepository {
  LiabilityRepository(this._db);

  final AppDatabase _db;

  Stream<List<Liability>> watchAll() {
    return _db.liabilitiesDao
        .watchAll()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  Future<List<Liability>> getAll() async {
    final rows = await _db.liabilitiesDao.getAll();
    return rows.map((r) => r.toDomain()).toList();
  }

  Future<void> save({
    String? id,
    required String name,
    required LiabilityType type,
    required MoneyAmount totalAmount,
    required MoneyAmount remainingAmount,
    String currency = 'PKR',
    MoneyAmount? installmentAmount,
    DateTime? dueDate,
    String? interestRate,
    String? notes,
  }) async {
    final now = nowMillis();
    final liabilityId = id ?? newId();
    final existing = id == null
        ? null
        : (await _db.liabilitiesDao.getAll())
            .where((l) => l.id == id)
            .firstOrNull;

    await _db.liabilitiesDao.upsert(
      LiabilitiesCompanion(
        id: Value(liabilityId),
        name: Value(name.trim()),
        type: Value(type.storageValue),
        totalAmount: Value(totalAmount.minorUnits),
        remainingAmount: Value(remainingAmount.minorUnits),
        currency: Value(currency.toUpperCase()),
        installmentAmount: Value(installmentAmount?.minorUnits),
        dueDate: Value(dueDate == null ? null : toMillis(dueDate)),
        interestRate: Value(interestRate),
        notes: Value(notes),
        isDeleted: const Value(false),
        createdAt: Value(existing?.createdAt ?? now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> delete(String id) =>
      _db.liabilitiesDao.softDelete(id, nowMillis());
}
