import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/services/calculator_engine.dart';

void main() {
  final engine = CalculatorEngine();

  Decimal d(String s) => Decimal.parse(s);

  group('CalculatorEngine', () {
    test('addition and subtraction', () {
      final r = engine.evaluate('10+5-3');
      expect(r, isA<CalcSuccess>());
      expect((r as CalcSuccess).value, d('12'));
    });

    test('precedence: multiplication before addition', () {
      final r = engine.evaluate('2+3*4');
      expect((r as CalcSuccess).value, d('14'));
    });

    test('parentheses override precedence', () {
      final r = engine.evaluate('(2+3)*4');
      expect((r as CalcSuccess).value, d('20'));
    });

    test('decimal addition without float error (0.1+0.2)', () {
      final r = engine.evaluate('0.1+0.2');
      expect((r as CalcSuccess).value, d('0.3'));
    });

    test('division', () {
      final r = engine.evaluate('10/4');
      expect((r as CalcSuccess).value, d('2.5'));
    });

    test('division by zero', () {
      final r = engine.evaluate('5/0');
      expect(r, isA<CalcError>());
      expect((r as CalcError).code, CalcErrorCode.divisionByZero);
    });

    test('invalid expression', () {
      final r = engine.evaluate('2+*3');
      expect(r, isA<CalcError>());
      expect((r as CalcError).code, CalcErrorCode.invalid);
    });

    test('empty expression', () {
      final r = engine.evaluate('   ');
      expect((r as CalcError).code, CalcErrorCode.empty);
    });

    test('percent', () {
      final r = engine.evaluate('50%');
      expect((r as CalcSuccess).value, d('0.5'));
    });

    test('unicode operators', () {
      final r = engine.evaluate('12×3÷2');
      expect((r as CalcSuccess).value, d('18'));
    });

    test('locale decimal separator comma', () {
      final eu = CalculatorEngine(decimalSeparator: ',');
      final r = eu.evaluate('0,1+0,2');
      expect((r as CalcSuccess).value, d('0.3'));
      expect(eu.formatResult(r.value), '0,3');
    });

    test('unary minus', () {
      final r = engine.evaluate('-5+2');
      expect((r as CalcSuccess).value, d('-3'));
    });
  });
}
