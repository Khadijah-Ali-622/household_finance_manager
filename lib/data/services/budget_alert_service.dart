import 'dart:developer' as developer;

import '../../domain/models/budget.dart';
import '../../domain/services/budget_calculator.dart';
import '../repositories/budget_repository.dart';
import '../repositories/reminder_repository.dart';

/// Creates an in-app reminder when a budget crosses 80% or the limit.
///
/// Called from the app lifecycle next to recurring processing. Each threshold
/// is stored once; [BudgetRepository.markNotified80] and
/// [BudgetRepository.markNotifiedOver] keep the next pass quiet.
class BudgetAlertService {
  BudgetAlertService(this._budgets, this._reminders);

  final BudgetRepository _budgets;
  final ReminderRepository _reminders;
  final BudgetCalculator _calc = const BudgetCalculator();

  static const budget80Link = 'budget_80';
  static const budgetOverLink = 'budget_over';

  Future<void> process({
    DateTime? now,
    String Function(Budget budget)? titleFor80,
    String Function(Budget budget)? titleForOver,
  }) async {
    final clock = now ?? DateTime.now();
    final month = BudgetCalculator.yearMonthOf(clock);
    final items = await _budgets.listForMonth(month);
    for (final item in items) {
      try {
        await _processOne(
          item,
          clock,
          titleFor80: titleFor80,
          titleForOver: titleForOver,
        );
      } catch (error, stack) {
        developer.log(
          'Budget alert failed for ${item.budget.id}',
          name: 'reminders',
          error: error,
          stackTrace: stack,
        );
      }
    }
  }

  Future<void> _processOne(
    BudgetWithProgress item,
    DateTime now, {
    String Function(Budget budget)? titleFor80,
    String Function(Budget budget)? titleForOver,
  }) async {
    final budget = item.budget;
    final over = _calc.shouldNotifyOver(
      progress: item.progress,
      notifyOver: budget.notifyOver,
      lastNotifiedOverAt: budget.lastNotifiedOverAt,
    );
    final warn = _calc.shouldNotify80(
      progress: item.progress,
      notify80: budget.notify80,
      lastNotified80At: budget.lastNotified80At,
    );

    if (over) {
      await _reminders.ensureBudgetAlert(
        budget: budget,
        linkedType: budgetOverLink,
        title: titleForOver?.call(budget) ?? _fallback(budget, over: true),
        now: now,
      );
      await _budgets.markNotifiedOver(budget.id);
      if (budget.lastNotified80At == null) {
        await _budgets.markNotified80(budget.id);
      }
      return;
    }

    if (!warn) return;
    await _reminders.ensureBudgetAlert(
      budget: budget,
      linkedType: budget80Link,
      title: titleFor80?.call(budget) ?? _fallback(budget, over: false),
      now: now,
    );
    await _budgets.markNotified80(budget.id);
  }

  String _fallback(Budget budget, {required bool over}) {
    final name = budget.name?.trim();
    final label = (name == null || name.isEmpty) ? 'Budget' : name;
    return over ? 'Budget exceeded: $label' : 'Budget almost used: $label';
  }
}
