import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../app_lock_controller.dart';
import '../biometric_auth.dart';
import '../lockout_logic.dart';
import 'pin_pad.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  String _pin = '';
  bool _error = false;
  String? _message;
  Timer? _ticker;
  final _bio = BiometricAuth();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeBiometric());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _maybeBiometric() async {
    final lock = ref.read(appLockProvider);
    if (!lock.biometricEnabled || !_bio.isSupportedPlatform) return;
    if (lock.isLockoutActive) return;
    final ok = await _bio.authenticate(
      reason: AppLocalizations.of(context).biometricReason,
    );
    if (ok && mounted) {
      ref.read(appLockProvider.notifier).unlockWithBiometric();
    }
  }

  Future<void> _onDigit(String d) async {
    final lock = ref.read(appLockProvider);
    if (lock.isLockoutActive) return;
    final len = lock.pinLength;
    if (_pin.length >= len) return;

    final next = _pin + d;
    setState(() {
      _error = false;
      _message = null;
      _pin = next;
    });

    if (next.length == len) {
      await _submit(next);
    }
  }

  Future<void> _submit(String pin) async {
    final l10n = AppLocalizations.of(context);
    final ok =
        await ref.read(appLockProvider.notifier).verifyPin(pin, unlock: true);
    if (!mounted) return;
    if (ok) {
      setState(() {
        _pin = '';
        _error = false;
        _message = null;
      });
      return;
    }
    final updated = ref.read(appLockProvider);
    setState(() {
      _error = true;
      _pin = '';
      if (updated.isLockoutActive) {
        _message = l10n.lockoutMessage(updated.lockoutRemaining.inSeconds);
      } else {
        final left = LockoutLogic.maxAttempts -
            (updated.failedAttempts % LockoutLogic.maxAttempts);
        _message = '${l10n.wrongPin} · ${l10n.attemptsRemaining(left)}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lock = ref.watch(appLockProvider);
    final lockedOut = lock.isLockoutActive;
    final remaining = lock.lockoutRemaining.inSeconds;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.lock_outline,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.unlockTitle,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                lockedOut
                    ? l10n.lockoutMessage(remaining)
                    : (_message ?? l10n.unlockSubtitle),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _error || lockedOut
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              PinDots(
                length: lock.pinLength,
                filled: _pin.length,
                error: _error,
              ),
              const SizedBox(height: AppSpacing.xxl),
              PinPad(
                enabled: !lockedOut,
                onDigit: _onDigit,
                onBackspace: () {
                  if (_pin.isEmpty) return;
                  setState(() {
                    _pin = _pin.substring(0, _pin.length - 1);
                    _error = false;
                  });
                },
                onBiometric: lock.biometricEnabled && _bio.isSupportedPlatform
                    ? _maybeBiometric
                    : null,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showForgotPin(context),
                child: Text(l10n.forgotPin),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showForgotPin(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.forgotPin),
        content: Text(l10n.forgotPinWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _confirmErase(context);
            },
            child: Text(l10n.forgotPinConfirmAction),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmErase(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.forgotPinConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.forgotPinConfirmBody),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.typeEraseToConfirm,
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () {
              if (controller.text.trim().toUpperCase() == 'ERASE') {
                Navigator.pop(ctx, true);
              }
            },
            child: Text(l10n.forgotPinConfirmAction),
          ),
        ],
      ),
    );
    controller.dispose();
    if (ok != true || !context.mounted) return;
    await ref.read(eraseLocalDataProvider)();
  }
}
