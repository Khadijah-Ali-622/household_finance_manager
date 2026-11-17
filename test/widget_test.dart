import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/models/money_amount.dart';

void main() {
  test('MoneyAmount parses major string with commas', () {
    expect(MoneyAmount.fromMajorString('1,250.50').minorUnits, 125050);
    expect(MoneyAmount.fromMajorString('100').minorUnits, 10000);
  });
}
