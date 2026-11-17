import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/features/security/lockout_logic.dart';

void main() {
  group('LockoutLogic', () {
    test('lock duration doubles each lockout', () {
      expect(LockoutLogic.lockDurationFor(1), const Duration(seconds: 30));
      expect(LockoutLogic.lockDurationFor(2), const Duration(seconds: 60));
      expect(LockoutLogic.lockDurationFor(3), const Duration(seconds: 120));
    });

    test('triggers lockout every 5 failures', () {
      expect(LockoutLogic.shouldTriggerLockout(5), isTrue);
      expect(LockoutLogic.shouldTriggerLockout(10), isTrue);
      expect(LockoutLogic.shouldTriggerLockout(4), isFalse);
      expect(LockoutLogic.shouldTriggerLockout(6), isFalse);
    });

    test('registerFailure locks after 5 attempts for 30s', () {
      final now = DateTime(2026, 1, 1, 12);
      var failed = 0;
      var lockouts = 0;
      DateTime? until;

      for (var i = 0; i < 5; i++) {
        final next = LockoutLogic.registerFailure(
          failedAttempts: failed,
          lockoutCount: lockouts,
          lockedUntil: until,
          now: now,
        );
        failed = next.failedAttempts;
        lockouts = next.lockoutCount;
        until = next.lockedUntil;
      }

      expect(failed, 5);
      expect(lockouts, 1);
      expect(until, now.add(const Duration(seconds: 30)));
      expect(LockoutLogic.isLocked(until, now: now), isTrue);
      expect(
        LockoutLogic.isLocked(until, now: now.add(const Duration(seconds: 31))),
        isFalse,
      );
    });

    test('second lockout is 60 seconds', () {
      final now = DateTime(2026, 1, 1, 12);
      final first = LockoutLogic.registerFailure(
        failedAttempts: 4,
        lockoutCount: 0,
        now: now,
      );
      expect(first.lockoutCount, 1);

      final later = now.add(const Duration(minutes: 1));
      final second = LockoutLogic.registerFailure(
        failedAttempts: 9,
        lockoutCount: 1,
        now: later,
      );
      expect(second.lockoutCount, 2);
      expect(second.lockedUntil, later.add(const Duration(seconds: 60)));
    });

    test('registerSuccess clears streak', () {
      final cleared = LockoutLogic.registerSuccess();
      expect(cleared.failedAttempts, 0);
      expect(cleared.lockedUntil, isNull);
    });

    test('AutoLockTimeout fromStorage', () {
      expect(
        AutoLockTimeout.fromStorage('oneMinute'),
        AutoLockTimeout.oneMinute,
      );
      expect(
        AutoLockTimeout.fromStorage(null),
        AutoLockTimeout.immediately,
      );
    });
  });
}
