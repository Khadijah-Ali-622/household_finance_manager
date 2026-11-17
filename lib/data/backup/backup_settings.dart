import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/locale/locale_settings.dart';
import 'backup_models.dart';

/// Preference keys copied into a backup. PIN material is never included.
const kBackupSettingKeys = <String>[
  kPrefLocale,
  kPrefBaseCurrency,
  kPrefNativeDigits,
  kPrefOnboardingDone,
  kPrefStatsChartType,
  kPrefWeekStartsMonday,
];

const kPrefStatsChartType = 'stats_chart_type';
const kPrefWeekStartsMonday = 'week_starts_on_monday';

const _kLastBackupAt = 'backup_last_at_ms';
const _kLastBackupSize = 'backup_last_size';
const _kFrequency = 'backup_auto_frequency';
const _kEncryptionEnabled = 'backup_encryption_enabled';
const _kPassword = 'backup_encryption_password';
const _kPasswordFallback = 'backup_encryption_password_fallback';

/// Last backup metadata and the encryption flag live in SharedPreferences.
/// The password itself is stored in [FlutterSecureStorage].
class BackupSettings {
  BackupSettings(
    this.prefs, {
    FlutterSecureStorage? secureStorage,
  }) : _secure = secureStorage ?? const FlutterSecureStorage();

  final SharedPreferences prefs;
  final FlutterSecureStorage _secure;

  DateTime? get lastBackupAt {
    final millis = prefs.getInt(_kLastBackupAt);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
  }

  int? get lastBackupSize => prefs.getInt(_kLastBackupSize);

  AutoBackupFrequency get frequency =>
      AutoBackupFrequency.fromStorage(prefs.getString(_kFrequency));

  bool get encryptionEnabled => prefs.getBool(_kEncryptionEnabled) ?? false;

  Future<void> recordBackup(DateTime when, int sizeBytes) async {
    await prefs.setInt(_kLastBackupAt, when.toUtc().millisecondsSinceEpoch);
    await prefs.setInt(_kLastBackupSize, sizeBytes);
  }

  Future<void> setFrequency(AutoBackupFrequency value) {
    return prefs.setString(_kFrequency, value.name);
  }

  Future<void> setEncryptionEnabled(bool enabled) {
    return prefs.setBool(_kEncryptionEnabled, enabled);
  }

  Future<void> savePassword(String password) async {
    try {
      await _secure.write(key: _kPassword, value: password);
      if (kIsWeb) {
        await prefs.remove(_kPasswordFallback);
      }
    } catch (_) {
      await prefs.setString(_kPasswordFallback, password);
    }
  }

  Future<String?> readPassword() async {
    try {
      final secure = await _secure.read(key: _kPassword);
      if (secure != null && secure.isNotEmpty) return secure;
    } catch (_) {
      // Web and some desktop builds have no keystore. Fall through.
    }
    final fallback = prefs.getString(_kPasswordFallback);
    if (fallback == null || fallback.isEmpty) return null;
    return fallback;
  }

  Future<void> clearPassword() async {
    try {
      await _secure.delete(key: _kPassword);
    } catch (_) {
      // Ignore missing keystore.
    }
    await prefs.remove(_kPasswordFallback);
  }
}
