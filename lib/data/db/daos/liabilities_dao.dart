import 'package:drift/drift.dart';

import '../app_database.dart';

part 'liabilities_dao.g.dart';

@DriftAccessor(tables: [Liabilities])
class LiabilitiesDao extends DatabaseAccessor<AppDatabase>
    with _$LiabilitiesDaoMixin {
  LiabilitiesDao(super.db);

  Stream<List<LiabilityRow>> watchAll() {
    return (select(liabilities)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<LiabilityRow>> getAll() {
    return (select(liabilities)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<void> upsert(LiabilitiesCompanion entry) =>
      into(liabilities).insertOnConflictUpdate(entry);

  Future<void> softDelete(String id, int updatedAt) {
    return (update(liabilities)..where((t) => t.id.equals(id))).write(
      LiabilitiesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(updatedAt),
      ),
    );
  }
}
