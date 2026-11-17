import 'package:material_ui/material_ui.dart';

import '../layout/responsive.dart';
import '../theme/app_theme.dart';

/// Centers and width-limits form content; always scrollable.
class FormPageBody extends StatelessWidget {
  const FormPageBody({
    super.key,
    required this.child,
    this.maxWidth = 640,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            r.pagePadding,
            AppSpacing.md,
            r.pagePadding,
            AppSpacing.xxl + MediaQuery.paddingOf(context).bottom,
          ),
          child: child,
        ),
      ),
    );
  }
}
