import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Biometric unlock helper. Hidden / no-op on web.
class BiometricAuth {
  BiometricAuth({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  bool get isSupportedPlatform => !kIsWeb;

  Future<bool> canCheck() async {
    if (!isSupportedPlatform) return false;
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false;
      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate({required String reason}) async {
    if (!isSupportedPlatform) return false;
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
