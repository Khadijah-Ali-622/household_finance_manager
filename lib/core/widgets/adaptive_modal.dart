import 'package:material_ui/material_ui.dart';

import '../layout/responsive.dart';

/// Shows a bottom sheet on mobile/tablet, a centered dialog on desktop.
Future<T?> showAdaptiveModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  double dialogMaxWidth = 480,
  bool barrierDismissible = true,
}) {
  final wide = Responsive.of(context).isDesktop;
  if (wide) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dialogMaxWidth,
              maxHeight: MediaQuery.sizeOf(ctx).height * 0.9,
            ),
            child: Material(
              type: MaterialType.card,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: builder(ctx),
            ),
          ),
        );
      },
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: true,
    builder: builder,
  );
}

/// Wraps [child] so Esc / barrier dismiss works; call [Navigator.pop] via actions.
class AdaptiveModalScaffold extends StatelessWidget {
  const AdaptiveModalScaffold({
    super.key,
    required this.child,
    this.title,
    this.actions,
  });

  final Widget child;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.of(context).isDesktop;
    if (!isDesktop) {
      return child;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null || actions != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
            child: Row(
              children: [
                if (title != null)
                  Expanded(
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.titleLarge!,
                      child: title!,
                    ),
                  )
                else
                  const Spacer(),
                ...?actions,
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ],
            ),
          ),
        Flexible(child: child),
      ],
    );
  }
}
