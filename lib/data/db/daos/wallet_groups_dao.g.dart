// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_groups_dao.dart';

// ignore_for_file: type=lint
mixin _$WalletGroupsDaoMixin on DatabaseAccessor<AppDatabase> {
  $WalletGroupsTable get walletGroups => attachedDatabase.walletGroups;
  $WalletGroupMembersTable get walletGroupMembers =>
      attachedDatabase.walletGroupMembers;
  WalletGroupsDaoManager get managers => WalletGroupsDaoManager(this);
}

class WalletGroupsDaoManager {
  final _$WalletGroupsDaoMixin _db;
  WalletGroupsDaoManager(this._db);
  $$WalletGroupsTableTableManager get walletGroups =>
      $$WalletGroupsTableTableManager(_db.attachedDatabase, _db.walletGroups);
  $$WalletGroupMembersTableTableManager get walletGroupMembers =>
      $$WalletGroupMembersTableTableManager(
        _db.attachedDatabase,
        _db.walletGroupMembers,
      );
}
