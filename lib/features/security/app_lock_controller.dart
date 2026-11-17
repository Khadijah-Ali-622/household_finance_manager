import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lockout_logic.dart';
import 'pin_hasher.dart';
import 'screenshot_privacy.dart';
import 'secure_pin_store.dart';

const _kPinHash = 'pin_hash';
const _kPinSalt = 'pin_salt';
const _kPinLength = 'pin_length';
const _kBiometric = 'biometric_enabled';
const _kAutoLock = 'auto_lock_timeout';
const _kFailedAttempts = 'pin_failed_attempts';
const _kLockoutCount = 'pin_lockout_count';
const _kLockedUntilMs = 'pin_locked_until_ms';

class AppLockState {
  const AppLockState({
    required this.ready,
    required this.pinEnabled,
    required this.locked,
    required this.biometricEnabled,
    required this.autoLock,
    required this.failedAttempts,
    required this.lockoutCount,
    this.pinLength = 6,
    this.lockedUntil,
    this.biometricAvailable = false,
  });

  final bool ready;
  final bool pinEnabled;
  final bool locked;
  final bool biometricEnabled;
  final AutoLockTimeout autoLock;
  final int failedAttempts;
  final int lockoutCount;
  final int pinLength;
  final DateTime? lockedUntil;
  final bool biometricAvailable;

  bool get isLockoutActive =>
      LockoutLogic.isLocked(lockedUntil);

  Duration get lockoutRemaining =>
      LockoutLogic.remainingLock(lockedUntil);

  AppLockState copyWith({
    bool? ready,
    bool? pinEnabled,
    bool? locked,
    bool? biometricEnabled,
    AutoLockTimeout? autoLock,
    int? failedAttempts,
    int? lockoutCount,
    int? pinLength,
    DateTime? lockedUntil,
    bool clearLockedUntil = false,
    bool? biometricAvailable,
  }) {
    return AppLockState(
      ready: ready ?? this.ready,
      pinEnabled: pinEnabled ?? this.pinEnabled,
      locked: locked ?? this.locked,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoLock: autoLock ?? this.autoLock,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockoutCount: lockoutCount ?? this.lockoutCount,
      pinLength: pinLength ?? this.pinLength,
      lockedUntil:
          clearLockedUntil ? null : (lockedUntil ?? this.lockedUntil),
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
    );
  }

  static const initial = AppLockState(
    ready: false,
    pinEnabled: false,
    locked: false,
    biometricEnabled: false,
    autoLock: AutoLockTimeout.immediately,
    failedAttempts: 0,
    lockoutCount: 0,
  );
}

class AppLockController extends Notifier<AppLockState> {
  late SecurePinStore _store;
  DateTime? _backgroundedAt;

  @override
  AppLockState build() {
    _store = createSecurePinStore();
    Future.microtask(_load);
    return AppLockState.initial;
  }

  Future<void> _load() async {
    final hash = await _store.read(_kPinHash);
    final salt = await _store.read(_kPinSalt);
    final lengthRaw = await _store.read(_kPinLength);
    final bio = await _store.read(_kBiometric);
    final prefs = await SharedPreferences.getInstance();
    final autoLock = AutoLockTimeout.fromStorage(prefs.getString(_kAutoLock));
    final failed = prefs.getInt(_kFailedAttempts) ?? 0;
    final lockouts = prefs.getInt(_kLockoutCount) ?? 0;
    final untilMs = prefs.getInt(_kLockedUntilMs);
    final until =
        untilMs == null ? null : DateTime.fromMillisecondsSinceEpoch(untilMs);
    final pinLength = int.tryParse(lengthRaw ?? '') ?? 6;

    final enabled = hash != null &&
        hash.isNotEmpty &&
        salt != null &&
        salt.isNotEmpty;

    await ScreenshotPrivacy.setSecure(enabled);

    state = state.copyWith(
      ready: true,
      pinEnabled: enabled,
      locked: enabled,
      biometricEnabled: bio == '1',
      autoLock: autoLock,
      failedAttempts: failed,
      lockoutCount: lockouts,
      pinLength: pinLength == 4 ? 4 : 6,
      lockedUntil: until,
      clearLockedUntil: until == null,
    );
  }

  void setBiometricAvailable(bool value) {
    state = state.copyWith(biometricAvailable: value);
  }

  Future<bool> setPin(String pin) async {
    if (!PinHasher.isValidPin(pin)) return false;
    final salt = PinHasher.generateSalt();
    final hash = PinHasher.hashPin(pin, salt);
    await _store.write(_kPinSalt, salt);
    await _store.write(_kPinHash, hash);
    await _store.write(_kPinLength, '${pin.length}');
    await ScreenshotPrivacy.setSecure(true);
    final cleared = LockoutLogic.registerSuccess();
    await _persistAttempts(cleared.failedAttempts, state.lockoutCount, null);
    state = state.copyWith(
      pinEnabled: true,
      locked: false,
      pinLength: pin.length,
      failedAttempts: 0,
      clearLockedUntil: true,
    );
    return true;
  }

  Future<bool> changePin(String currentPin, String newPin) async {
    if (!await verifyPin(currentPin, unlock: false)) return false;
    return setPin(newPin);
  }

  Future<bool> removePin(String currentPin) async {
    if (!await verifyPin(currentPin, unlock: false)) return false;
    await _store.delete(_kPinHash);
    await _store.delete(_kPinSalt);
    await _store.delete(_kPinLength);
    await _store.delete(_kBiometric);
    await ScreenshotPrivacy.setSecure(false);
    final cleared = LockoutLogic.registerSuccess();
    await _persistAttempts(cleared.failedAttempts, 0, null);
    state = state.copyWith(
      pinEnabled: false,
      locked: false,
      biometricEnabled: false,
      failedAttempts: 0,
      lockoutCount: 0,
      clearLockedUntil: true,
    );
    return true;
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _store.write(_kBiometric, enabled ? '1' : '0');
    state = state.copyWith(biometricEnabled: enabled);
  }

  Future<void> setAutoLock(AutoLockTimeout timeout) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAutoLock, timeout.storageValue);
    state = state.copyWith(autoLock: timeout);
  }

  Future<bool> verifyPin(String pin, {bool unlock = true}) async {
    if (!state.pinEnabled) return false;
    if (state.isLockoutActive) return false;

    final salt = await _store.read(_kPinSalt);
    final hash = await _store.read(_kPinHash);
    if (salt == null || hash == null) return false;

    if (PinHasher.verify(pin, salt, hash)) {
      final cleared = LockoutLogic.registerSuccess();
      await _persistAttempts(cleared.failedAttempts, state.lockoutCount, null);
      state = state.copyWith(
        locked: unlock ? false : state.locked,
        failedAttempts: 0,
        clearLockedUntil: true,
      );
      return true;
    }

    final next = LockoutLogic.registerFailure(
      failedAttempts: state.failedAttempts,
      lockoutCount: state.lockoutCount,
      lockedUntil: state.lockedUntil,
    );
    await _persistAttempts(
      next.failedAttempts,
      next.lockoutCount,
      next.lockedUntil,
    );
    state = state.copyWith(
      failedAttempts: next.failedAttempts,
      lockoutCount: next.lockoutCount,
      lockedUntil: next.lockedUntil,
      clearLockedUntil: next.lockedUntil == null,
    );
    return false;
  }

  void unlockWithBiometric() {
    final cleared = LockoutLogic.registerSuccess();
    _persistAttempts(cleared.failedAttempts, state.lockoutCount, null);
    state = state.copyWith(
      locked: false,
      failedAttempts: 0,
      clearLockedUntil: true,
    );
  }

  void lockNow() {
    if (!state.pinEnabled) return;
    state = state.copyWith(locked: true);
  }

  void onAppPaused() {
    if (!state.pinEnabled) return;
    _backgroundedAt = DateTime.now();
    if (state.autoLock == AutoLockTimeout.immediately) {
      state = state.copyWith(locked: true);
    }
  }

  void onAppResumed() {
    if (!state.pinEnabled) return;
    final started = _backgroundedAt;
    _backgroundedAt = null;
    if (state.autoLock == AutoLockTimeout.immediately) {
      state = state.copyWith(locked: true);
      return;
    }
    if (started == null) return;
    final elapsed = DateTime.now().difference(started);
    if (elapsed >= state.autoLock.duration) {
      state = state.copyWith(locked: true);
    }
  }

  /// Clears PIN secrets and prefs used for lock (call after wiping DB).
  Future<void> clearAfterDataErase() async {
    await _store.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAutoLock);
    await prefs.remove(_kFailedAttempts);
    await prefs.remove(_kLockoutCount);
    await prefs.remove(_kLockedUntilMs);
    await ScreenshotPrivacy.setSecure(false);
    state = const AppLockState(
      ready: true,
      pinEnabled: false,
      locked: false,
      biometricEnabled: false,
      autoLock: AutoLockTimeout.immediately,
      failedAttempts: 0,
      lockoutCount: 0,
    );
  }

  Future<void> _persistAttempts(
    int failed,
    int lockouts,
    DateTime? until,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kFailedAttempts, failed);
    await prefs.setInt(_kLockoutCount, lockouts);
    if (until == null) {
      await prefs.remove(_kLockedUntilMs);
    } else {
      await prefs.setInt(_kLockedUntilMs, until.millisecondsSinceEpoch);
    }
  }
}

final appLockProvider =
    NotifierProvider<AppLockController, AppLockState>(AppLockController.new);
