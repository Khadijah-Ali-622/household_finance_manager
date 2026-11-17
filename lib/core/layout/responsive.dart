import 'package:material_ui/material_ui.dart';

/// Shared breakpoints: mobile &lt;600, tablet 600–1024, desktop &gt;1024.
enum AppBreakpoint {
  mobile,
  tablet,
  desktop,
}

/// Max content width on large screens (centered).
const double kContentMaxWidth = 1200;

/// Minimum touch / click target size.
const double kMinTouchTarget = 48;

class Responsive {
  Responsive._(this.width);

  factory Responsive.of(BuildContext context) {
    return Responsive._(MediaQuery.sizeOf(context).width);
  }

  factory Responsive.fromWidth(double width) => Responsive._(width);

  final double width;

  static const double mobileMax = 600;
  static const double tabletMax = 1024;

  AppBreakpoint get breakpoint {
    if (width < mobileMax) return AppBreakpoint.mobile;
    if (width <= tabletMax) return AppBreakpoint.tablet;
    return AppBreakpoint.desktop;
  }

  bool get isMobile => breakpoint == AppBreakpoint.mobile;
  bool get isTablet => breakpoint == AppBreakpoint.tablet;
  bool get isDesktop => breakpoint == AppBreakpoint.desktop;
  bool get isWide => !isMobile;

  /// Wallet / card grid columns.
  int get gridColumns {
    if (isDesktop) return 3;
    if (isTablet) return 2;
    return 1;
  }

  /// Summary metric columns on dashboard.
  int get summaryColumns {
    if (isDesktop) return 4;
    if (isTablet) return 2;
    return 1;
  }

  /// Horizontal page padding.
  double get pagePadding {
    if (isDesktop) return 32;
    if (isTablet) return 24;
    return 20;
  }

  /// Side navigation width when expanded (desktop).
  double get sideNavWidth => isDesktop ? 240 : 80;
}

/// Rebuilds when width crosses breakpoints (via [LayoutBuilder]).
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, Responsive responsive) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        return builder(context, Responsive.fromWidth(width));
      },
    );
  }
}

/// Centers child and caps width at [kContentMaxWidth].
class ConstrainedContent extends StatelessWidget {
  const ConstrainedContent({
    super.key,
    required this.child,
    this.maxWidth = kContentMaxWidth,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: r.pagePadding),
          child: child,
        ),
      ),
    );
  }
}

/// Scrollable page body with optional max-width centering.
class AdaptivePageBody extends StatelessWidget {
  const AdaptivePageBody({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth = kContentMaxWidth,
    this.scrollable = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double maxWidth;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final pad = padding ??
        EdgeInsets.fromLTRB(
          r.pagePadding,
          8,
          r.pagePadding,
          r.isMobile ? 88 : 24,
        );

    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(padding: pad, child: child),
    );

    content = Align(alignment: Alignment.topCenter, child: content);

    if (!scrollable) return content;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: content,
          ),
        );
      },
    );
  }
}

/// Simple multi-column grid that wraps children (no scroll itself).
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.columns,
    this.spacing = 12,
    this.runSpacing = 12,
    this.childAspectRatio,
  });

  final List<Widget> children;
  final int? columns;
  final double spacing;
  final double runSpacing;
  final double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final cols = columns ?? Responsive.of(context).gridColumns;
    if (cols <= 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: runSpacing),
            children[i],
          ],
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = (width - spacing * (cols - 1)) / cols;
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final child in children)
              SizedBox(
                width: itemWidth,
                child: childAspectRatio == null
                    ? child
                    : AspectRatio(
                        aspectRatio: childAspectRatio!,
                        child: child,
                      ),
              ),
          ],
        );
      },
    );
  }
}

/// Ensures minimum 48×48 interactive area; adds mouse cursor on desktop.
class AdaptiveInkWell extends StatelessWidget {
  const AdaptiveInkWell({
    super.key,
    required this.onTap,
    required this.child,
    this.borderRadius,
    this.onLongPress,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: borderRadius,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: kMinTouchTarget,
              minHeight: kMinTouchTarget,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
