import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Hides app content in Android recent-apps screenshots when possible.
class ScreenshotPrivacy {
  ScreenshotPrivacy._();

  static const _channel = MethodChannel('household_finance/privacy');

  static Future<void> setSecure(bool enabled) async {
    if (kIsWeb) return;
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('setSecure', {'enabled': enabled});
    } catch (_) {
      // Best-effort; ignore on unsupported platforms.
    }
  }
}
