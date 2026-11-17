import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/features/security/pin_hasher.dart';

void main() {
  group('PinHasher', () {
    test('generates salt of expected decoded length', () {
      final salt = PinHasher.generateSalt(Random(1));
      expect(salt.isNotEmpty, isTrue);
      expect(PinHasher.generateSalt(Random(1)), salt);
      expect(PinHasher.generateSalt(Random(2)), isNot(salt));
    });

    test('hash is deterministic for same pin+salt', () {
      const salt = 'abc123salt';
      final a = PinHasher.hashPin('1234', salt);
      final b = PinHasher.hashPin('1234', salt);
      expect(a, b);
      expect(a, isNot(equals('1234')));
    });

    test('different pins produce different hashes', () {
      const salt = 'abc123salt';
      expect(
        PinHasher.hashPin('1234', salt),
        isNot(PinHasher.hashPin('1235', salt)),
      );
    });

    test('verify accepts correct pin and rejects wrong', () {
      const salt = 's';
      final hash = PinHasher.hashPin('654321', salt);
      expect(PinHasher.verify('654321', salt, hash), isTrue);
      expect(PinHasher.verify('654320', salt, hash), isFalse);
    });

    test('isValidPin accepts 4 or 6 digits only', () {
      expect(PinHasher.isValidPin('1234'), isTrue);
      expect(PinHasher.isValidPin('123456'), isTrue);
      expect(PinHasher.isValidPin('12345'), isFalse);
      expect(PinHasher.isValidPin('12ab'), isFalse);
      expect(PinHasher.isValidPin(''), isFalse);
    });
  });
}
