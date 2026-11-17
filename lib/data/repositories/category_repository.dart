import 'package:drift/drift.dart';

import '../../core/utils/uuid.dart';
import '../../domain/enums/category_type.dart';
import '../../domain/models/category.dart';
import '../db/app_database.dart';
import '../db/mappers.dart';

class CategoryRepository {
  CategoryRepository(this._db);

  final AppDatabase _db;

  Stream<List<Category>> watchAll() {
    return _db.categoriesDao
        .watchAll()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  Future<void> save({
    String? id,
    required String name,
    required String icon,
    required int color,
    required CategoryType type,
    String? parentId,
  }) async {
    final now = nowMillis();
    final catId = id ?? newId();
    final existing = id == null
        ? null
        : (await _db.categoriesDao.getAll())
            .where((c) => c.id == id)
            .firstOrNull;

    await _db.categoriesDao.upsert(
      CategoriesCompanion(
        id: Value(catId),
        name: Value(name.trim()),
        icon: Value(icon),
        color: Value(color),
        type: Value(type.storageValue),
        parentId: Value(parentId),
        isDefault: Value(existing?.isDefault ?? false),
        sortOrder: Value(existing?.sortOrder ?? 50),
        isDeleted: const Value(false),
        createdAt: Value(existing?.createdAt ?? now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> delete(String id) =>
      _db.categoriesDao.softDelete(id, nowMillis());
}
