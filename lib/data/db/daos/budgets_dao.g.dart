// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budgets_dao.dart';

// ignore_for_file: type=lint
mixin _$BudgetsDaoMixin on DatabaseAccessor<AppDatabase> {
  $BudgetsTable get budgets => attachedDatabase.budgets;
  $BudgetWalletMembersTable get budgetWalletMembers =>
      attachedDatabase.budgetWalletMembers;
  BudgetsDaoManager get managers => BudgetsDaoManager(this);
}

class BudgetsDaoManager {
  final _$BudgetsDaoMixin _db;
  BudgetsDaoManager(this._db);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db.attachedDatabase, _db.budgets);
  $$BudgetWalletMembersTableTableManager get budgetWalletMembers =>
      $$BudgetWalletMembersTableTableManager(
        _db.attachedDatabase,
        _db.budgetWalletMembers,
      );
}
