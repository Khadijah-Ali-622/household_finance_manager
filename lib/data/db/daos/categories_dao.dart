import 'package:drift/drift.dart';

import '../app_database.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  Stream<List<CategoryRow>> watchAll() {
    return (select(categories)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm.asc(t.type),
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch();
  }

  Future<List<CategoryRow>> getAll() {
    return (select(categories)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .get();
  }

  Future<void> upsert(CategoriesCompanion entry) =>
      into(categories).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<CategoriesCompanion> entries) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(categories, entries);
    });
  }

  Future<void> softDelete(String id, int updatedAt) {
    return (update(categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<int> countDefaults() async {
    final count = countAll();
    final query = selectOnly(categories)
      ..addColumns([count])
      ..where(
        categories.isDeleted.equals(false) & categories.isDefault.equals(true),
      );
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }
}
