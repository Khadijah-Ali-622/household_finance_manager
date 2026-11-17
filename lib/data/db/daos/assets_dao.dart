import 'package:drift/drift.dart';

import '../app_database.dart';

part 'assets_dao.g.dart';

@DriftAccessor(tables: [Assets])
class AssetsDao extends DatabaseAccessor<AppDatabase> with _$AssetsDaoMixin {
  AssetsDao(super.db);

  Stream<List<AssetRow>> watchAll() {
    return (select(assets)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<AssetRow>> getAll() {
    return (select(assets)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<void> upsert(AssetsCompanion entry) =>
      into(assets).insertOnConflictUpdate(entry);

  Future<void> softDelete(String id, int updatedAt) {
    return (update(assets)..where((t) => t.id.equals(id))).write(
      AssetsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(updatedAt),
      ),
    );
  }
}
