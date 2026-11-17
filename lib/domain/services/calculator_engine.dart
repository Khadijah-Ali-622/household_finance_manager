import 'package:decimal/decimal.dart';

/// Result of evaluating a calculator expression.
sealed class CalcResult {
  const CalcResult();
}

class CalcSuccess extends CalcResult {
  const CalcSuccess(this.value);
  final Decimal value;
}

class CalcError extends CalcResult {
  const CalcError(this.code);
  final CalcErrorCode code;
}

enum CalcErrorCode {
  empty,
  invalid,
  divisionByZero,
}

/// Decimal expression evaluator with standard precedence.
///
/// Supports `+ - × ÷ * / % ( )` and locale decimal separators (`.` / `,`).
/// `%` after a number means ÷ 100 (e.g. `50%` → 0.5).
/// Never uses floating-point doubles for arithmetic.
class CalculatorEngine {
  CalculatorEngine({this.decimalSeparator = '.'});

  final String decimalSeparator;

  static final _ops = {'+', '-', '*', '/', '×', '÷', '%', '(', ')'};

  CalcResult evaluate(String raw) {
    final input = raw.trim();
    if (input.isEmpty) return const CalcError(CalcErrorCode.empty);

    try {
      final tokens = _tokenize(input);
      if (tokens.isEmpty) return const CalcError(CalcErrorCode.invalid);
      final rpn = _toRpn(tokens);
      final value = _evalRpn(rpn);
      return CalcSuccess(value);
    } on _CalcException catch (e) {
      return CalcError(e.code);
    } catch (_) {
      return const CalcError(CalcErrorCode.invalid);
    }
  }

  /// Formats [value] using this engine's decimal separator (no thousands).
  String formatResult(Decimal value) {
    var s = value.toString();
    if (decimalSeparator != '.') {
      s = s.replaceAll('.', decimalSeparator);
    }
    return s;
  }

  List<String> _tokenize(String input) {
    final normalized = input
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll(' ', '');
    final tokens = <String>[];
    final buf = StringBuffer();

    void flushNumber() {
      if (buf.isEmpty) return;
      var n = buf.toString();
      if (decimalSeparator != '.') {
        n = n.replaceAll(decimalSeparator, '.');
      }
      // Allow trailing % attached to number: 50%
      if (n.endsWith('%')) {
        final numPart = n.substring(0, n.length - 1);
        if (numPart.isEmpty || Decimal.tryParse(numPart) == null) {
          throw const _CalcException(CalcErrorCode.invalid);
        }
        tokens.add(numPart);
        tokens.add('%');
      } else {
        if (Decimal.tryParse(n) == null) {
          throw const _CalcException(CalcErrorCode.invalid);
        }
        tokens.add(n);
      }
      buf.clear();
    }

    for (var i = 0; i < normalized.length; i++) {
      final ch = normalized[i];
      final isDigit = RegExp(r'[0-9]').hasMatch(ch);
      final isSep = ch == '.' || ch == decimalSeparator;

      if (isDigit || isSep) {
        buf.write(ch);
        continue;
      }

      if (ch == '%' && buf.isNotEmpty) {
        buf.write(ch);
        flushNumber();
        continue;
      }

      flushNumber();

      if (ch == '-' || ch == '+') {
        final prev = tokens.isEmpty ? null : tokens.last;
        final unary = prev == null ||
            prev == '(' ||
            prev == '+' ||
            prev == '-' ||
            prev == '*' ||
            prev == '/';
        if (unary && ch == '-') {
          tokens.add('u-');
          continue;
        }
        if (unary && ch == '+') {
          continue;
        }
      }

      if (_ops.contains(ch) || ch == '%') {
        tokens.add(ch);
        continue;
      }

      throw const _CalcException(CalcErrorCode.invalid);
    }
    flushNumber();
    return tokens;
  }

  int _precedence(String op) {
    return switch (op) {
      'u-' => 3,
      '%' => 3,
      '*' || '/' => 2,
      '+' || '-' => 1,
      _ => 0,
    };
  }

  bool _rightAssoc(String op) => op == 'u-' || op == '%';

  List<String> _toRpn(List<String> tokens) {
    final output = <String>[];
    final stack = <String>[];

    for (final t in tokens) {
      if (Decimal.tryParse(t) != null) {
        output.add(t);
      } else if (t == '(') {
        stack.add(t);
      } else if (t == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          output.add(stack.removeLast());
        }
        if (stack.isEmpty) {
          throw const _CalcException(CalcErrorCode.invalid);
        }
        stack.removeLast();
      } else {
        while (stack.isNotEmpty &&
            stack.last != '(' &&
            (_precedence(stack.last) > _precedence(t) ||
                (!_rightAssoc(t) &&
                    _precedence(stack.last) == _precedence(t)))) {
          output.add(stack.removeLast());
        }
        stack.add(t);
      }
    }
    while (stack.isNotEmpty) {
      final op = stack.removeLast();
      if (op == '(' || op == ')') {
        throw const _CalcException(CalcErrorCode.invalid);
      }
      output.add(op);
    }
    return output;
  }

  Decimal _evalRpn(List<String> rpn) {
    final stack = <Decimal>[];
    for (final t in rpn) {
      final asNum = Decimal.tryParse(t);
      if (asNum != null) {
        stack.add(asNum);
        continue;
      }
      if (t == 'u-') {
        if (stack.isEmpty) {
          throw const _CalcException(CalcErrorCode.invalid);
        }
        stack.add(-stack.removeLast());
        continue;
      }
      if (t == '%') {
        if (stack.isEmpty) {
          throw const _CalcException(CalcErrorCode.invalid);
        }
        stack.add(
          (stack.removeLast() / Decimal.fromInt(100))
              .toDecimal(scaleOnInfinitePrecision: 20),
        );
        continue;
      }
      if (stack.length < 2) {
        throw const _CalcException(CalcErrorCode.invalid);
      }
      final b = stack.removeLast();
      final a = stack.removeLast();
      stack.add(_apply(a, b, t));
    }
    if (stack.length != 1) {
      throw const _CalcException(CalcErrorCode.invalid);
    }
    return stack.single;
  }

  Decimal _apply(Decimal a, Decimal b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        if (b == Decimal.zero) {
          throw const _CalcException(CalcErrorCode.divisionByZero);
        }
        return (a / b).toDecimal(scaleOnInfinitePrecision: 20);
      default:
        throw const _CalcException(CalcErrorCode.invalid);
    }
  }
}

class _CalcException implements Exception {
  const _CalcException(this.code);
  final CalcErrorCode code;
}
