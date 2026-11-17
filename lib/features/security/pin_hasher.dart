import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Salts and hashes PINs. Never store or compare plain-text PINs.
class PinHasher {
  PinHasher._();

  static const int saltBytes = 16;

  /// Cryptographically secure random salt, base64-encoded.
  static String generateSalt([Random? random]) {
    final rng = random ?? Random.secure();
    final bytes = Uint8List.fromList(
      List<int>.generate(saltBytes, (_) => rng.nextInt(256)),
    );
    return base64Encode(bytes);
  }

  /// Returns a hex SHA-256 digest of `salt:pin`.
  static String hashPin(String pin, String salt) {
    final bytes = utf8.encode('$salt:$pin');
    return sha256.convert(bytes).toString();
  }

  /// Constant-time-ish verify (digest strings are fixed length).
  static bool verify(String pin, String salt, String expectedHash) {
    final actual = hashPin(pin, salt);
    if (actual.length != expectedHash.length) return false;
    var diff = 0;
    for (var i = 0; i < actual.length; i++) {
      diff |= actual.codeUnitAt(i) ^ expectedHash.codeUnitAt(i);
    }
    return diff == 0;
  }

  /// Accepts only 4- or 6-digit numeric PINs.
  static bool isValidPin(String pin) {
    if (pin.length != 4 && pin.length != 6) return false;
    return RegExp(r'^\d+$').hasMatch(pin);
  }
}
