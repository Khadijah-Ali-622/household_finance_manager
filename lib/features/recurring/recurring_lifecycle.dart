import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../providers.dart';

/// Runs due recurring rules when the app starts and each time it resumes.
class RecurringLifecycle extends ConsumerStatefulWidget {
  const RecurringLifecycle({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<RecurringLifecycle> createState() => _RecurringLifecycleState();
}

class _RecurringLifecycleState extends ConsumerState<RecurringLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _process());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _process();
    }
  }

  Future<void> _process() async {
    if (!mounted) return;
    try {
      await ref.read(recurringRepositoryProvider).processDueRules();
    } catch (error, stack) {
      debugPrint('Recurring processDueRules failed: $error\n$stack');
    }
    if (!mounted) return;
    try {
      await ref.read(reminderRepositoryProvider).rollDailyExpenses();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      await ref.read(budgetAlertServiceProvider).process(
        titleFor80: (budget) => _budgetTitle(l10n.budgetAlmostUsed, budget.name),
        titleForOver: (budget) => _budgetTitle(l10n.budgetExceeded, budget.name),
      );
      await ref.read(syncReminderNotificationsProvider)();
    } catch (error, stack) {
      debugPrint('Reminder processing failed: $error\n$stack');
    }
  }

  String _budgetTitle(String label, String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return label;
    return '$label: $trimmed';
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
