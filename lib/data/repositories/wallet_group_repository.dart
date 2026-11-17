import 'package:drift/drift.dart';

import '../../core/utils/uuid.dart';
import '../../domain/models/wallet_group.dart';
import '../db/app_database.dart';
import '../db/mappers.dart';

class WalletGroupRepository {
  WalletGroupRepository(this._db);

  final AppDatabase _db;

  Stream<List<WalletGroup>> watchGroups() {
    return _db.walletGroupsDao.watchGroups().asyncMap((rows) async {
      final result = <WalletGroup>[];
      for (final row in rows) {
        final members = await _db.walletGroupsDao.memberIds(row.id);
        result.add(mapWalletGroup(row, members));
      }
      return result;
    });
  }

  Future<WalletGroup?> getById(String id) async {
    final rows = await _db.walletGroupsDao.watchGroups().first;
    final row = rows.where((r) => r.id == id).firstOrNull;
    if (row == null) return null;
    final members = await _db.walletGroupsDao.memberIds(id);
    return mapWalletGroup(row, members);
  }

  Future<void> save({
    String? id,
    required String name,
    String? icon,
    required List<String> walletIds,
  }) async {
    if (walletIds.isEmpty) {
      throw ArgumentError('Select at least one wallet');
    }
    final now = nowMillis();
    final groupId = id ?? newId();
    final existing = id == null ? null : await getById(id);

    await _db.walletGroupsDao.saveGroup(
      group: WalletGroupsCompanion(
        id: Value(groupId),
        name: Value(name.trim()),
        icon: Value(icon),
        isDeleted: const Value(false),
        createdAt: Value(
          existing == null ? now : toMillis(existing.createdAt),
        ),
        updatedAt: Value(now),
      ),
      walletIds: walletIds,
      createdAt: now,
    );
  }

  Future<void> delete(String id) =>
      _db.walletGroupsDao.softDelete(id, nowMillis());
}
