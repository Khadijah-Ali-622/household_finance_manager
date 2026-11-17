import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key-value store for PIN salt/hash. Secure on mobile/desktop; web fallback.
abstract class SecurePinStore {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

/// Platform secure storage (Keychain / Keystore / encrypted prefs).
class FlutterSecurePinStore implements SecurePinStore {
  FlutterSecurePinStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
            );

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}

/// Web fallback: SharedPreferences (still never stores plain PIN).
///
/// Browsers lack a true Keychain equivalent; only salted hashes are stored.
class WebFallbackPinStore implements SecurePinStore {
  WebFallbackPinStore({SharedPreferences? prefs}) : _prefsOverride = prefs;

  final SharedPreferences? _prefsOverride;
  SharedPreferences? _prefs;
  static const _prefix = 'secure_pin_';

  Future<SharedPreferences> _ensure() async {
    return _prefs ??= _prefsOverride ?? await SharedPreferences.getInstance();
  }

  @override
  Future<void> write(String key, String value) async {
    final p = await _ensure();
    await p.setString('$_prefix$key', value);
  }

  @override
  Future<String?> read(String key) async {
    final p = await _ensure();
    return p.getString('$_prefix$key');
  }

  @override
  Future<void> delete(String key) async {
    final p = await _ensure();
    await p.remove('$_prefix$key');
  }

  @override
  Future<void> deleteAll() async {
    final p = await _ensure();
    final keys = p.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final k in keys) {
      await p.remove(k);
    }
  }
}

SecurePinStore createSecurePinStore() {
  if (kIsWeb) return WebFallbackPinStore();
  return FlutterSecurePinStore();
}
