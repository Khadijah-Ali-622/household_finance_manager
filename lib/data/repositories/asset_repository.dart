import 'package:drift/drift.dart';

import '../../core/utils/uuid.dart';
import '../../domain/enums/asset_type.dart';
import '../../domain/models/asset.dart';
import '../../domain/models/money_amount.dart';
import '../db/app_database.dart';
import '../db/mappers.dart';

class AssetRepository {
  AssetRepository(this._db);

  final AppDatabase _db;

  Stream<List<Asset>> watchAll() {
    return _db.assetsDao
        .watchAll()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  Future<List<Asset>> getAll() async {
    final rows = await _db.assetsDao.getAll();
    return rows.map((r) => r.toDomain()).toList();
  }

  Future<void> save({
    String? id,
    required String name,
    required AssetType type,
    required MoneyAmount currentValue,
    String currency = 'PKR',
    MoneyAmount? purchasePrice,
    DateTime? purchaseDate,
    String? quantity,
    String? unit,
    String? notes,
  }) async {
    final now = nowMillis();
    final assetId = id ?? newId();
    final existing = id == null
        ? null
        : (await _db.assetsDao.getAll())
            .where((a) => a.id == id)
            .firstOrNull;

    await _db.assetsDao.upsert(
      AssetsCompanion(
        id: Value(assetId),
        name: Value(name.trim()),
        type: Value(type.storageValue),
        purchasePrice: Value(purchasePrice?.minorUnits),
        purchaseDate:
            Value(purchaseDate == null ? null : toMillis(purchaseDate)),
        currentValue: Value(currentValue.minorUnits),
        currency: Value(currency.toUpperCase()),
        quantity: Value(quantity),
        unit: Value(unit),
        notes: Value(notes),
        isDeleted: const Value(false),
        createdAt: Value(existing?.createdAt ?? now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> delete(String id) =>
      _db.assetsDao.softDelete(id, nowMillis());
}
