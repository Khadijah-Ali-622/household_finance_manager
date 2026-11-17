import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/adaptive_modal.dart';
import '../../../l10n/app_localizations.dart';
import '../app_lock_controller.dart';
import '../biometric_auth.dart';
import '../lockout_logic.dart';
import '../pin_hasher.dart';
import 'pin_pad.dart';

class SecurityPage extends ConsumerWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lock = ref.watch(appLockProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.security)),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.sm,
        ),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    lock.pinEnabled ? Icons.lock : Icons.lock_open_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(l10n.pinLock),
                  subtitle: Text(
                    lock.pinEnabled ? l10n.pinEnabled : l10n.pinDisabled,
                  ),
                ),
                if (!lock.pinEnabled)
                  ListTile(
                    title: Text(l10n.setPin),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _setPinFlow(context, ref),
                  )
                else ...[
                  ListTile(
                    title: Text(l10n.changePin),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _changePinFlow(context, ref),
                  ),
                  ListTile(
                    title: Text(l10n.removePin),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _removePinFlow(context, ref),
                  ),
                  Divider(height: 1, color: theme.colorScheme.outline),
                  ListTile(
                    title: Text(l10n.autoLock),
                    subtitle: Text(_autoLockLabel(l10n, lock.autoLock)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _pickAutoLock(context, ref),
                  ),
                  if (!kIsWeb) ...[
                    Divider(height: 1, color: theme.colorScheme.outline),
                    SwitchListTile(
                      title: Text(l10n.biometricUnlock),
                      value: lock.biometricEnabled,
                      onChanged: lock.biometricAvailable
                          ? (v) async {
                              if (v) {
                                final ok = await BiometricAuth().authenticate(
                                  reason: l10n.biometricReason,
                                );
                                if (!ok) return;
                              }
                              await ref
                                  .read(appLockProvider.notifier)
                                  .setBiometricEnabled(v);
                            }
                          : null,
                    ),
                  ],
                ],
              ],
            ),
          ),
          if (lock.pinEnabled) ...[
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.warning_amber_outlined,
                  color: theme.colorScheme.error,
                ),
                title: Text(l10n.forgotPin),
                subtitle: Text(l10n.forgotPinWarning),
                isThreeLine: true,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _autoLockLabel(AppLocalizations l10n, AutoLockTimeout t) {
    return switch (t) {
      AutoLockTimeout.immediately => l10n.autoLockImmediate,
      AutoLockTimeout.oneMinute => l10n.autoLock1Min,
      AutoLockTimeout.fiveMinutes => l10n.autoLock5Min,
    };
  }

  Future<void> _pickAutoLock(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final selected = await showAdaptiveModal<AutoLockTimeout>(
      context: context,
      dialogMaxWidth: 360,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.autoLockImmediate),
              onTap: () => Navigator.pop(ctx, AutoLockTimeout.immediately),
            ),
            ListTile(
              title: Text(l10n.autoLock1Min),
              onTap: () => Navigator.pop(ctx, AutoLockTimeout.oneMinute),
            ),
            ListTile(
              title: Text(l10n.autoLock5Min),
              onTap: () => Navigator.pop(ctx, AutoLockTimeout.fiveMinutes),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      await ref.read(appLockProvider.notifier).setAutoLock(selected);
    }
  }

  Future<void> _setPinFlow(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final first = await _promptPin(context, title: l10n.enterPin);
    if (first == null || !context.mounted) return;
    final second = await _promptPin(
      context,
      title: l10n.confirmPin,
      fixedLength: first.length,
    );
    if (second == null || !context.mounted) return;
    if (first != second) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pinsDoNotMatch)),
      );
      return;
    }
    if (!PinHasher.isValidPin(first)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.invalidPinLength)),
      );
      return;
    }
    await ref.read(appLockProvider.notifier).setPin(first);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pinSetSuccess)),
      );
    }
  }

  Future<void> _changePinFlow(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final pinLen = ref.read(appLockProvider).pinLength;
    final current = await _promptPin(
      context,
      title: l10n.enterCurrentPin,
      fixedLength: pinLen,
    );
    if (current == null || !context.mounted) return;
    final ok = await ref
        .read(appLockProvider.notifier)
        .verifyPin(current, unlock: false);
    if (!ok) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.wrongPin)),
        );
      }
      return;
    }
    if (!context.mounted) return;
    final first = await _promptPin(context, title: l10n.enterNewPin);
    if (first == null || !context.mounted) return;
    final second = await _promptPin(
      context,
      title: l10n.confirmPin,
      fixedLength: first.length,
    );
    if (second == null || !context.mounted) return;
    if (first != second) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pinsDoNotMatch)),
      );
      return;
    }
    await ref.read(appLockProvider.notifier).setPin(first);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pinSetSuccess)),
      );
    }
  }

  Future<void> _removePinFlow(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final pinLen = ref.read(appLockProvider).pinLength;
    final current = await _promptPin(
      context,
      title: l10n.enterCurrentPin,
      fixedLength: pinLen,
    );
    if (current == null || !context.mounted) return;
    final ok = await ref.read(appLockProvider.notifier).removePin(current);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? l10n.pinRemoved : l10n.wrongPin)),
    );
  }

  Future<String?> _promptPin(
    BuildContext context, {
    required String title,
    int? fixedLength,
  }) {
    return showAdaptiveModal<String>(
      context: context,
      dialogMaxWidth: 400,
      builder: (ctx) => _PinPromptSheet(
        title: title,
        fixedLength: fixedLength,
      ),
    );
  }
}

class _PinPromptSheet extends StatefulWidget {
  const _PinPromptSheet({required this.title, this.fixedLength});

  final String title;
  final int? fixedLength;

  @override
  State<_PinPromptSheet> createState() => _PinPromptSheetState();
}

class _PinPromptSheetState extends State<_PinPromptSheet> {
  String _pin = '';
  late int _length;

  @override
  void initState() {
    super.initState();
    _length = widget.fixedLength ?? 4;
  }

  void _submitIfReady() {
    if (_pin.length == _length) {
      Navigator.pop(context, _pin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final canChooseLength = widget.fixedLength == null;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title, style: theme.textTheme.titleLarge),
            if (canChooseLength) ...[
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 4, label: Text('4')),
                  ButtonSegment(value: 6, label: Text('6')),
                ],
                selected: {_length},
                onSelectionChanged: (s) => setState(() {
                  _length = s.first;
                  _pin = '';
                }),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            PinDots(length: _length, filled: _pin.length),
            const SizedBox(height: AppSpacing.lg),
            PinPad(
              onDigit: (d) {
                if (_pin.length >= _length) return;
                setState(() => _pin += d);
                _submitIfReady();
              },
              onBackspace: () {
                if (_pin.isEmpty) return;
                setState(() => _pin = _pin.substring(0, _pin.length - 1));
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
