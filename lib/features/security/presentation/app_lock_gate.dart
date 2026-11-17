import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../app_lock_controller.dart';
import '../biometric_auth.dart';
import 'lock_screen.dart';

/// Observes lifecycle, shows [LockScreen] over the app when locked.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  final _bio = BiometricAuth();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initBio());
  }

  Future<void> _initBio() async {
    final available = await _bio.canCheck();
    if (mounted) {
      ref.read(appLockProvider.notifier).setBiometricAvailable(available);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lock = ref.read(appLockProvider.notifier);
    switch (state) {
      // Use paused/hidden only — inactive fires for biometric sheets too.
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        lock.onAppPaused();
      case AppLifecycleState.resumed:
        lock.onAppResumed();
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(appLockProvider);
    final showLock = lock.ready && lock.pinEnabled && lock.locked;

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (showLock) const Positioned.fill(child: LockScreen()),
      ],
    );
  }
}
