import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../providers.dart';
import '../backup_providers.dart';

/// Runs a due Drive backup when the app opens or returns to the foreground.
class BackupLifecycle extends ConsumerStatefulWidget {
  const BackupLifecycle({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<BackupLifecycle> createState() => _BackupLifecycleState();
}

class _BackupLifecycleState extends ConsumerState<BackupLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _run();
  }

  Future<void> _run() async {
    if (!mounted) return;
    try {
      await ref.read(seedReadyProvider.future);
      await ref.read(backupCoordinatorProvider).runAutoBackupIfDue();
    } catch (error, stack) {
      debugPrint('Auto backup skipped: $error\n$stack');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
