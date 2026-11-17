import 'package:drift/drift.dart';

import '../app_database.dart';

part 'wallets_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletsDao extends DatabaseAccessor<AppDatabase> with _$WalletsDaoMixin {
  WalletsDao(super.db);

  Stream<List<WalletRow>> watchActive() {
    return (select(wallets)
          ..where((t) => t.isDeleted.equals(false) & t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<WalletRow>> getActive() {
    return (select(wallets)
          ..where((t) => t.isDeleted.equals(false) & t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<List<WalletRow>> getAllIncludingArchived() {
    return (select(wallets)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm.asc(t.isArchived),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .get();
  }

  Stream<List<WalletRow>> watchAllIncludingArchived() {
    return (select(wallets)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm.asc(t.isArchived),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch();
  }

  Future<WalletRow?> getById(String id) {
    return (select(wallets)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsert(WalletsCompanion entry) =>
      into(wallets).insertOnConflictUpdate(entry);

  Future<void> softDelete(String id, int updatedAt) {
    return (update(wallets)..where((t) => t.id.equals(id))).write(
      WalletsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<void> setArchived(String id, bool archived, int updatedAt) {
    return (update(wallets)..where((t) => t.id.equals(id))).write(
      WalletsCompanion(
        isArchived: Value(archived),
        updatedAt: Value(updatedAt),
      ),
    );
  }
}
