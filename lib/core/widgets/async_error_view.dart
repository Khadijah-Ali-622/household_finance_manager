import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';

/// Shows a user-friendly message in release; in debug, also shows the
/// exception + stack and prints them to the console via [debugPrint].
class AsyncErrorView extends StatelessWidget {
  const AsyncErrorView({
    super.key,
    required this.error,
    this.stackTrace,
  });

  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Always print so it shows in `flutter run` terminal / browser console.
    debugPrint('AsyncValue error: $error');
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace, label: 'AsyncValue stack');
    }

    if (!kDebugMode) {
      return Center(child: Text(l10n.errorGeneric));
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: SelectableText(
          '${l10n.errorGeneric}\n\n$error\n\n${stackTrace ?? ''}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontFamily: 'monospace',
              ),
        ),
      ),
    );
  }
}
