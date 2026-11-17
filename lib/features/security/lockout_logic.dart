/// Pure lockout rules after failed PIN attempts.
///
/// After every [maxAttempts] wrong tries, the app locks for
/// [baseLockSeconds] × 2^(lockoutIndex−1) seconds (30, 60, 120, …).
class LockoutLogic {
  LockoutLogic._();

  static const int maxAttempts = 5;
  static const int baseLockSeconds = 30;
  static const int maxLockoutExponent = 8;

  /// Duration for the Nth lockout event (1-based).
  static Duration lockDurationFor(int lockoutCount) {
    final n = lockoutCount < 1 ? 1 : lockoutCount;
    final exp = (n - 1).clamp(0, maxLockoutExponent);
    final seconds = baseLockSeconds * (1 << exp);
    return Duration(seconds: seconds);
  }

  /// True when [failedAttempts] just completed another batch of [maxAttempts].
  static bool shouldTriggerLockout(int failedAttempts) {
    return failedAttempts > 0 && failedAttempts % maxAttempts == 0;
  }

  /// How many lockout events [failedAttempts] corresponds to.
  static int lockoutCountForAttempts(int failedAttempts) {
    return failedAttempts ~/ maxAttempts;
  }

  /// Remaining lock time, or [Duration.zero] if not locked.
  static Duration remainingLock(
    DateTime? lockedUntil, {
    DateTime? now,
  }) {
    if (lockedUntil == null) return Duration.zero;
    final remaining = lockedUntil.difference(now ?? DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  static bool isLocked(DateTime? lockedUntil, {DateTime? now}) {
    return remainingLock(lockedUntil, now: now) > Duration.zero;
  }

  /// Applies one failed attempt; returns updated counters and optional lock end.
  static ({
    int failedAttempts,
    int lockoutCount,
    DateTime? lockedUntil,
  }) registerFailure({
    required int failedAttempts,
    required int lockoutCount,
    DateTime? lockedUntil,
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    if (isLocked(lockedUntil, now: clock)) {
      return (
        failedAttempts: failedAttempts,
        lockoutCount: lockoutCount,
        lockedUntil: lockedUntil,
      );
    }

    final nextAttempts = failedAttempts + 1;
    if (shouldTriggerLockout(nextAttempts)) {
      final nextLockout = lockoutCount + 1;
      return (
        failedAttempts: nextAttempts,
        lockoutCount: nextLockout,
        lockedUntil: clock.add(lockDurationFor(nextLockout)),
      );
    }

    return (
      failedAttempts: nextAttempts,
      lockoutCount: lockoutCount,
      lockedUntil: null,
    );
  }

  /// Clears failure streak after a successful unlock.
  static ({int failedAttempts, DateTime? lockedUntil}) registerSuccess() {
    return (failedAttempts: 0, lockedUntil: null);
  }
}

enum AutoLockTimeout {
  immediately(Duration.zero),
  oneMinute(Duration(minutes: 1)),
  fiveMinutes(Duration(minutes: 5));

  const AutoLockTimeout(this.duration);
  final Duration duration;

  String get storageValue => name;

  static AutoLockTimeout fromStorage(String? value) {
    return AutoLockTimeout.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AutoLockTimeout.immediately,
    );
  }
}
