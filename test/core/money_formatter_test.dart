import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/core/utils/money.dart';
import 'package:household_finance_manager/domain/models/money_amount.dart';

void main() {
  test('This Month Expense displays as positive Rs amount', () {
    // sumExpense returns a non-negative total; the dashboard must format that
    // value directly (not negated), e.g. Rs 8,500 instead of Rs -8,500.
    const monthExpense = MoneyAmount(850000);
    final displayed = MoneyFormatter().format(monthExpense);

    expect(displayed, 'Rs 8,500.00');
    expect(displayed.contains('-'), isFalse);
  });
}
