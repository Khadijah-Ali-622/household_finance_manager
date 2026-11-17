import 'dart:developer' as developer;
import 'dart:math' as math;

import '../../core/utils/uuid.dart';
import '../../domain/enums/recurring_frequency.dart';
import '../../domain/enums/recurring_mode.dart';
import '../../domain/enums/recurring_template.dart';
import '../../domain/enums/transaction_type.dart';
import '../../domain/models/money_amount.dart';
import '../../domain/models/recurring_rule.dart';
import '../../domain/services/recurring_generator.dart';
import '../db/app_database.dart';
import '../db/daos/recurring_dao.dart';
import 'transaction_repository.dart';

class RecurringRepository {
  RecurringRepository(this._db, this._transactions) : _dao = RecurringDao(_db);

  final AppDatabase _db;
  final TransactionRepository _transactions;
  final RecurringDao _dao;

  /// Safety cap so a long-overdue daily rule cannot write thousands of rows
  /// in one pass. The next app start continues where this pass stopped.
  static const int _maxPerPass = 366;

  Stream<List<RecurringRule>> watchAll() => _dao.watchActive();

  Future<RecurringRule?> getById(String id) => _dao.getById(id);

  Future<void> save({
    String? id,
    required String walletId,
    required TxType type,
    required MoneyAmount amount,
    required String currency,
    MoneyAmount? toAmount,
    String? categoryId,
    String? toWalletId,
    String? note,
    String? paymentMethod,
    required RecurringFrequency frequency,
    required int intervalN,
    String? customUnit,
    required DateTime startDate,
    DateTime? endDate,
    required RecurringMode mode,
    required RecurringTemplate templateType,
    int? installmentCount,
  }) async {
    if (amount.minorUnits <= 0) {
      throw ArgumentError('Amount must be positive');
    }
    final every = RecurringGenerator.normalizeInterval(intervalN);
    if (endDate != null &&
        RecurringGenerator.dateOnly(endDate)
            .isBefore(RecurringGenerator.dateOnly(startDate))) {
      throw ArgumentError('End date is before start date');
    }

    MoneyAmount? received = toAmount;
    String? targetWallet = toWalletId;
    String? category = categoryId;
    if (type == TxType.transfer) {
      if (targetWallet == null || targetWallet.isEmpty) {
        throw ArgumentError('Transfer requires toWalletId');
      }
      if (targetWallet == walletId) {
        throw ArgumentError('Cannot transfer to the same wallet');
      }
      received = received ?? amount;
      if (received.minorUnits <= 0) {
        throw ArgumentError('Received amount must be positive');
      }
      category = null;
    } else {
      if (category == null || category.isEmpty) {
        throw ArgumentError('Category required for income/expense');
      }
      targetWallet = null;
      received = null;
    }

    if (templateType == RecurringTemplate.installment &&
        (installmentCount == null || installmentCount < 1)) {
      throw ArgumentError('Installment count required');
    }

    final existing = id == null ? null : await _dao.getById(id);
    final now = DateTime.now();
    final generatedCount = existing?.generatedCount ?? 0;
    final unit = frequency == RecurringFrequency.custom
        ? (RecurringGenerator.isMonthUnit(customUnit) ? 'months' : 'days')
        : null;
    final next = RecurringGenerator.nextDue(
      start: startDate,
      lastGenerated: existing?.lastGeneratedDate,
      frequency: frequency,
      intervalN: every,
      customUnit: unit,
    );
    final open = _scheduleOpen(
      templateType: templateType,
      installmentCount: installmentCount,
      generatedCount: generatedCount,
      endDate: endDate,
      next: next,
    );
    final remaining = templateType == RecurringTemplate.installment
        ? MoneyAmount(
            math.max(
              0,
              amount.minorUnits *
                  math.max(0, (installmentCount ?? 0) - generatedCount),
            ),
          )
        : null;

    final rule = RecurringRule(
      id: existing?.id ?? id ?? newId(),
      walletId: walletId,
      type: type,
      amount: amount,
      currency: currency.toUpperCase(),
      toAmount: received,
      categoryId: category,
      toWalletId: targetWallet,
      note: _blankToNull(note),
      paymentMethod: _blankToNull(paymentMethod),
      frequency: frequency,
      intervalN: every,
      customUnit: unit,
      startDate: RecurringGenerator.dateOnly(startDate),
      endDate: endDate == null ? null : RecurringGenerator.dateOnly(endDate),
      nextDueDate: next,
      lastGeneratedDate: existing?.lastGeneratedDate,
      mode: mode,
      templateType: templateType,
      installmentCount: templateType == RecurringTemplate.installment
          ? installmentCount
          : null,
      amountRemaining: remaining,
      generatedCount: generatedCount,
      isPaused: existing?.isPaused ?? false,
      isActive: open,
      isDeleted: false,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    if (existing == null) {
      await _dao.insertRule(rule);
    } else {
      await _dao.updateRule(rule);
    }
    await processDueRules(now: now);
  }

  Future<void> setPaused(String id, {required bool paused}) async {
    await _dao.setPaused(id, paused, nowMillis());
    if (!paused) {
      await processDueRules();
    }
  }

  Future<void> delete(String id) => _dao.softDelete(id, nowMillis());

  /// Creates missed transactions or ask-reminders for every running rule.
  ///
  /// Editing a rule does not rewrite transactions already saved. This only
  /// appends occurrences after [RecurringRule.lastGeneratedDate].
  Future<void> processDueRules({DateTime? now}) async {
    final today = RecurringGenerator.dateOnly(now ?? DateTime.now());
    final rules = await _dao.getRunnable();
    for (final rule in rules) {
      try {
        await _db.transaction(() => _processRule(rule, today));
      } catch (error, stack) {
        developer.log(
          'Failed to process recurring rule ${rule.id}',
          name: 'recurring',
          error: error,
          stackTrace: stack,
        );
      }
    }
  }

  Future<void> _processRule(RecurringRule rule, DateTime today) async {
    final occurrences = RecurringGenerator.missedOccurrences(
      start: rule.startDate,
      lastGenerated: rule.lastGeneratedDate,
      today: today,
      frequency: rule.frequency,
      intervalN: rule.intervalN,
      customUnit: rule.customUnit,
      endDate: rule.endDate,
    );

    final slots =
        rule.templateType == RecurringTemplate.installment &&
            rule.installmentCount != null
        ? math.max(0, rule.installmentCount! - rule.generatedCount)
        : null;
    final pending = (slots == null ? occurrences : occurrences.take(slots))
        .take(_maxPerPass)
        .toList();

    final created = <DateTime>[];
    for (final date in pending) {
      final millis = toMillis(date);
      if (rule.mode == RecurringMode.auto) {
        final exists = await _dao.hasGeneratedTransaction(rule.id, millis);
        if (!exists) {
          await _transactions.save(
            walletId: rule.walletId,
            type: rule.type,
            amount: rule.amount,
            toAmount: rule.type == TxType.transfer
                ? (rule.toAmount ?? rule.amount)
                : null,
            categoryId: rule.type == TxType.transfer ? null : rule.categoryId,
            toWalletId: rule.type == TxType.transfer ? rule.toWalletId : null,
            date: date,
            note: rule.note,
            paymentMethod: rule.paymentMethod,
            recurringId: rule.id,
          );
        }
      } else {
        final exists = await _dao.hasRecurringReminder(rule.id, millis);
        if (!exists) {
          final title = (rule.note != null && rule.note!.trim().isNotEmpty)
              ? rule.note!.trim()
              : '${rule.type.storageValue} recurring';
          await _dao.insertRecurringReminder(
            id: newId(),
            title: title,
            amount: rule.amount.minorUnits,
            currency: rule.currency,
            note: rule.note,
            dueDate: millis,
            walletId: rule.walletId,
            categoryId: rule.categoryId,
            linkedId: rule.id,
            createdAt: nowMillis(),
          );
        }
      }
      created.add(date);
    }

    final last = created.isEmpty ? rule.lastGeneratedDate : created.last;
    final generatedCount = rule.generatedCount + created.length;
    final next = RecurringGenerator.nextDue(
      start: rule.startDate,
      lastGenerated: last,
      frequency: rule.frequency,
      intervalN: rule.intervalN,
      customUnit: rule.customUnit,
    );
    final open = _scheduleOpen(
      templateType: rule.templateType,
      installmentCount: rule.installmentCount,
      generatedCount: generatedCount,
      endDate: rule.endDate,
      next: next,
    );
    final remaining = rule.templateType == RecurringTemplate.installment
        ? math.max(
            0,
            (rule.amountRemaining?.minorUnits ??
                    rule.amount.minorUnits * (rule.installmentCount ?? 0)) -
                rule.amount.minorUnits * created.length,
          )
        : rule.amountRemaining?.minorUnits;

    final progressChanged =
        created.isNotEmpty ||
        open != rule.isActive ||
        RecurringGenerator.dateOnly(rule.nextDueDate) != next;
    if (!progressChanged) return;

    await _dao.updateProgress(
      id: rule.id,
      lastGeneratedDate: last,
      nextDueDate: next,
      generatedCount: generatedCount,
      amountRemaining: remaining,
      isActive: open,
      updatedAt: nowMillis(),
    );
  }

  bool _scheduleOpen({
    required RecurringTemplate templateType,
    required int? installmentCount,
    required int generatedCount,
    required DateTime? endDate,
    required DateTime next,
  }) {
    if (templateType == RecurringTemplate.installment &&
        installmentCount != null &&
        generatedCount >= installmentCount) {
      return false;
    }
    if (endDate != null &&
        RecurringGenerator.dateOnly(next)
            .isAfter(RecurringGenerator.dateOnly(endDate))) {
      return false;
    }
    return true;
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
