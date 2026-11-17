import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';

/// Numeric PIN pad (RTL-aware via Directionality).
class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.onBiometric,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometric;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget keyBtn(String label, {VoidCallback? onTap, IconData? icon}) {
      return SizedBox(
        width: 72,
        height: 72,
        child: Material(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: enabled ? onTap : null,
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 28)
                  : Text(
                      label,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row
                  .map((d) => keyBtn(d, onTap: () => onDigit(d)))
                  .toList(),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (onBiometric != null)
              keyBtn('', icon: Icons.fingerprint, onTap: onBiometric)
            else
              const SizedBox(width: 72, height: 72),
            keyBtn('0', onTap: () => onDigit('0')),
            keyBtn('', icon: Icons.backspace_outlined, onTap: onBackspace),
          ],
        ),
      ],
    );
  }
}

class PinDots extends StatelessWidget {
  const PinDots({
    super.key,
    required this.length,
    required this.filled,
    this.error = false,
  });

  final int length;
  final int filled;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = error
        ? theme.colorScheme.error
        : theme.colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final on = i < filled;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: on ? color : Colors.transparent,
            border: Border.all(color: color, width: 2),
          ),
        );
      }),
    );
  }
}
