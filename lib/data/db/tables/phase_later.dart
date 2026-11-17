import 'package:drift/drift.dart';

/// Phase 2 tables. Dates are epoch milliseconds. Money is integer minor units.

@DataClassName('BudgetRow')
class Budgets extends Table {
  TextColumn get id => text()();

  /// Null = overall budget. Non-null = that category only.
  TextColumn get categoryId => text().nullable()();

  /// Single-wallet shortcut. Null when all-wallet or multi-wallet.
  TextColumn get walletId => text().nullable()();

  IntColumn get amount => integer()();
  TextColumn get currency => text().withDefault(const Constant('PKR'))();
  TextColumn get period => text().withDefault(const Constant('monthly'))();

  /// Legacy column; mirrored with [yearMonth] (YYYYMM).
  IntColumn get startMonth => integer()();

  /// Budget period YYYYMM.
  IntColumn get yearMonth => integer().withDefault(const Constant(0))();

  BoolColumn get rollover => boolean().withDefault(const Constant(false))();
  BoolColumn get notify80 =>
      boolean().named('notify_80').withDefault(const Constant(true))();
  BoolColumn get notifyOver => boolean().withDefault(const Constant(true))();
  IntColumn get lastNotified80At =>
      integer().named('last_notified_80_at').nullable()();
  IntColumn get lastNotifiedOverAt => integer().nullable()();

  /// Display name for overall budgets / notes.
  TextColumn get name => text().nullable()();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BudgetWalletMemberRow')
class BudgetWalletMembers extends Table {
  TextColumn get budgetId => text()();
  TextColumn get walletId => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {budgetId, walletId};
}

@DataClassName('RecurringTransactionRow')
class RecurringTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get walletId => text()();

  /// income | expense | transfer
  TextColumn get type => text()();
  IntColumn get amount => integer()();
  TextColumn get currency => text().withDefault(const Constant('PKR'))();
  IntColumn get toAmount => integer().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get toWalletId => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get paymentMethod => text().nullable()();

  /// daily | weekly | monthly | yearly | custom
  TextColumn get frequency => text()();
  IntColumn get intervalN => integer().withDefault(const Constant(1))();
  TextColumn get customUnit => text().nullable()(); // days | months

  IntColumn get startDate => integer().withDefault(const Constant(0))();
  IntColumn get endDate => integer().nullable()();
  IntColumn get nextDueDate => integer()();
  IntColumn get lastGeneratedDate => integer().nullable()();

  /// auto | ask
  TextColumn get mode => text().withDefault(const Constant('ask'))();

  /// standard | committee | installment
  TextColumn get templateType =>
      text().withDefault(const Constant('standard'))();
  IntColumn get installmentCount => integer().nullable()();
  IntColumn get amountRemaining => integer().nullable()();
  IntColumn get generatedCount => integer().withDefault(const Constant(0))();

  BoolColumn get isPaused => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReminderRow')
class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get amount => integer().nullable()();
  TextColumn get currency => text().withDefault(const Constant('PKR'))();
  TextColumn get note => text().nullable()();
  IntColumn get dueDate => integer()();

  /// null = one-shot; else daily | weekly | monthly | yearly
  TextColumn get repeatFrequency => text().nullable()();
  IntColumn get remindDaysBefore => integer().withDefault(const Constant(0))();
  IntColumn get dailyTimeMinutes => integer().nullable()();

  TextColumn get walletId => text().nullable()();
  TextColumn get categoryId => text().nullable()();

  /// bill | recurring | budget | daily_expense
  TextColumn get type => text().withDefault(const Constant('bill'))();
  TextColumn get linkedType => text().nullable()();
  TextColumn get linkedId => text().nullable()();
  TextColumn get paidTransactionId => text().nullable()();

  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get lastNotifiedAt => integer().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CommitteeRow')
class Committees extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get monthlyAmount => integer()();
  IntColumn get totalMembers => integer()();
  IntColumn get myTurnMonth => integer().nullable()();
  IntColumn get startDate => integer()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SavingsGoalRow')
class SavingsGoals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get targetAmount => integer()();
  IntColumn get savedAmount => integer().withDefault(const Constant(0))();
  IntColumn get targetDate => integer().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
