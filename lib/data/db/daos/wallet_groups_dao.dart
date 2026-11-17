import 'package:drift/drift.dart';

import '../app_database.dart';

part 'wallet_groups_dao.g.dart';

@DriftAccessor(tables: [WalletGroups, WalletGroupMembers])
class WalletGroupsDao extends DatabaseAccessor<AppDatabase>
    with _$WalletGroupsDaoMixin {
  WalletGroupsDao(super.db);

  Stream<List<WalletGroupRow>> watchGroups() {
    return (select(walletGroups)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<String>> memberIds(String groupId) async {
    final rows = await (select(walletGroupMembers)
          ..where((t) => t.groupId.equals(groupId)))
        .get();
    return rows.map((r) => r.walletId).toList();
  }

  Stream<List<WalletGroupMemberRow>> watchMembers(String groupId) {
    return (select(walletGroupMembers)
          ..where((t) => t.groupId.equals(groupId)))
        .watch();
  }

  Future<void> saveGroup({
    required WalletGroupsCompanion group,
    required List<String> walletIds,
    required int createdAt,
  }) async {
    await transaction(() async {
      await into(walletGroups).insertOnConflictUpdate(group);
      await (delete(walletGroupMembers)
            ..where((t) => t.groupId.equals(group.id.value)))
          .go();
      await batch((b) {
        b.insertAll(
          walletGroupMembers,
          walletIds
              .map(
                (wid) => WalletGroupMembersCompanion.insert(
                  groupId: group.id.value,
                  walletId: wid,
                  createdAt: createdAt,
                ),
              )
              .toList(),
        );
      });
    });
  }

  Future<void> softDelete(String id, int updatedAt) {
    return (update(walletGroups)..where((t) => t.id.equals(id))).write(
      WalletGroupsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(updatedAt),
      ),
    );
  }
}
