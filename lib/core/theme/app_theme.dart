import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

/// Exact palette tokens for the premium teal / slate theme.
class AppColors {
  AppColors._();

  // —— Light ——
  static const Color background = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF64748B);
  static const Color accent = Color(0xFF0D9488);
  static const Color accentPressed = Color(0xFF0F766E);
  static const Color income = Color(0xFF059669);
  static const Color expense = Color(0xFFDC2626);
  static const Color transfer = Color(0xFF3B82F6);
  static const Color border = Color(0xFFE2E8F0);
  static const Color activeNavBackground = Color(0xFFCCFBF1);
  static const Color hoverOverlay = Color(0xFFF1F5F9);
  static const Color onAccent = Color(0xFFFFFFFF);

  // —— Dark ——
  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkCard = Color(0xFF111A2E);
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextMuted = Color(0xFF94A3B8);
  static const Color darkAccent = Color(0xFF2DD4BF);
  static const Color darkAccentPressed = Color(0xFF14B8A6);
  static const Color darkIncome = Color(0xFF34D399);
  static const Color darkExpense = Color(0xFFF87171);
  static const Color darkTransfer = Color(0xFF60A5FA);
  static const Color darkActiveNavBackground = Color(0xFF134E4A);
  static const Color darkHoverOverlay = Color(0xFF1E293B);
  static const Color darkOnAccent = Color(0xFF0B1220);

  /// Multi-category pie: teal, blue, indigo, amber, rose, slate.
  static const List<Color> chartPalette = [
    Color(0xFF0D9488),
    Color(0xFF3B82F6),
    Color(0xFF6366F1),
    Color(0xFFF59E0B),
    Color(0xFFF43F5E),
    Color(0xFF64748B),
  ];

  static const List<Color> darkChartPalette = [
    Color(0xFF2DD4BF),
    Color(0xFF60A5FA),
    Color(0xFF818CF8),
    Color(0xFFFBBF24),
    Color(0xFFFB7185),
    Color(0xFF94A3B8),
  ];
}

/// Consistent spacing scale used across screens.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double screen = 20;
  static const double section = 20;
  static const double card = 16;
  static const double radius = 16;
  static const double radiusSm = 12;
  static const double radiusLg = 20;
  static const double buttonMinHeight = 48;
  static const Duration animFast = Duration(milliseconds: 160);
}

/// Soft card / FAB shadows matching the design spec.
class AppShadows {
  AppShadows._();

  /// #0F172A at 6% opacity, blur 12, offset (0, 4).
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F0F172A),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> cardDark = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> fab = [
    BoxShadow(
      color: Color(0x1A0F172A),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> forBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? cardDark : card;
}

/// Premium teal / slate finance theme — all app colors & component themes.
class AppTheme {
  AppTheme._();

  // Backward-compatible aliases used by a few screens.
  static const Color primary = AppColors.accent;
  static const Color onPrimary = AppColors.onAccent;
  static const Color scaffoldBackground = AppColors.background;
  static const Color cardSurface = AppColors.card;
  static const Color navIndicator = AppColors.activeNavBackground;
  static const Color secondary = AppColors.textSecondary;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color income = AppColors.income;
  static const Color expense = AppColors.expense;
  static const Color transfer = AppColors.transfer;
  static const double radius = AppSpacing.radius;

  static const List<Color> chartPalette = AppColors.chartPalette;
  static const List<Color> darkChartPalette = AppColors.darkChartPalette;

  static ThemeData light() {
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.accent,
      onPrimary: AppColors.onAccent,
      primaryContainer: AppColors.activeNavBackground,
      onPrimaryContainer: AppColors.accentPressed,
      secondary: AppColors.textSecondary,
      onSecondary: AppColors.onAccent,
      secondaryContainer: AppColors.hoverOverlay,
      onSecondaryContainer: AppColors.textPrimary,
      tertiary: AppColors.transfer,
      onTertiary: AppColors.onAccent,
      tertiaryContainer: const Color(0xFFDBEAFE),
      onTertiaryContainer: const Color(0xFF1E3A8A),
      error: AppColors.expense,
      onError: AppColors.onAccent,
      errorContainer: const Color(0xFFFEE2E2),
      onErrorContainer: const Color(0xFF7F1D1D),
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerLowest: AppColors.background,
      surfaceContainerLow: AppColors.card,
      surfaceContainer: AppColors.card,
      surfaceContainerHigh: AppColors.hoverOverlay,
      surfaceContainerHighest: AppColors.activeNavBackground,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
      shadow: const Color(0xFF0F172A),
      scrim: const Color(0xFF000000),
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.background,
      inversePrimary: AppColors.darkAccent,
      surfaceTint: Colors.transparent,
    );
    return _base(
      scheme,
      finance: const FinanceColors(
        income: AppColors.income,
        expense: AppColors.expense,
        transfer: AppColors.transfer,
        accentPressed: AppColors.accentPressed,
        mutedText: AppColors.textMuted,
        hoverOverlay: AppColors.hoverOverlay,
        activeNavBackground: AppColors.activeNavBackground,
        chartPalette: AppColors.chartPalette,
        chartLabel: AppColors.onAccent,
        gridLine: AppColors.border,
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkAccent,
      onPrimary: AppColors.darkOnAccent,
      primaryContainer: AppColors.darkActiveNavBackground,
      onPrimaryContainer: AppColors.darkAccent,
      secondary: AppColors.darkTextSecondary,
      onSecondary: AppColors.darkOnAccent,
      secondaryContainer: AppColors.darkHoverOverlay,
      onSecondaryContainer: AppColors.darkTextPrimary,
      tertiary: AppColors.darkTransfer,
      onTertiary: AppColors.darkOnAccent,
      tertiaryContainer: const Color(0xFF1E3A5F),
      onTertiaryContainer: AppColors.darkTextPrimary,
      error: AppColors.darkExpense,
      onError: AppColors.darkOnAccent,
      errorContainer: const Color(0xFF7F1D1D),
      onErrorContainer: const Color(0xFFFEE2E2),
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      surfaceContainerLowest: AppColors.darkBackground,
      surfaceContainerLow: AppColors.darkCard,
      surfaceContainer: AppColors.darkCard,
      surfaceContainerHigh: AppColors.darkHoverOverlay,
      surfaceContainerHighest: AppColors.darkActiveNavBackground,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkBorder,
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),
      inverseSurface: AppColors.darkTextPrimary,
      onInverseSurface: AppColors.darkBackground,
      inversePrimary: AppColors.accent,
      surfaceTint: Colors.transparent,
    );
    return _base(
      scheme,
      finance: const FinanceColors(
        income: AppColors.darkIncome,
        expense: AppColors.darkExpense,
        transfer: AppColors.darkTransfer,
        accentPressed: AppColors.darkAccentPressed,
        mutedText: AppColors.darkTextMuted,
        hoverOverlay: AppColors.darkHoverOverlay,
        activeNavBackground: AppColors.darkActiveNavBackground,
        chartPalette: AppColors.darkChartPalette,
        // White labels stay readable on saturated pie slices in both modes.
        chartLabel: AppColors.onAccent,
        gridLine: AppColors.darkBorder,
      ),
    );
  }

  static ThemeData _base(
    ColorScheme scheme, {
    required FinanceColors finance,
  }) {
    final isDark = scheme.brightness == Brightness.dark;
    final cardColor = scheme.surfaceContainerLow;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      side: BorderSide(color: scheme.outline),
    );
    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
    );

    final baseText = _interTextTheme(scheme);

    final overlay = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return finance.accentPressed.withValues(alpha: 0.16);
      }
      if (states.contains(WidgetState.hovered)) {
        return finance.hoverOverlay;
      }
      return null;
    });

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      extensions: [finance],
      textTheme: baseText,
      primaryTextTheme: baseText,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: isDark ? 0 : 2,
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x0F0F172A),
        margin: EdgeInsets.zero,
        shape: shape,
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: ListTileThemeData(
        textColor: scheme.onSurface,
        iconColor: scheme.onSurface,
        selectedTileColor: finance.hoverOverlay,
        selectedColor: scheme.primary,
        subtitleTextStyle: baseText.bodyMedium?.copyWith(
          color: finance.mutedText,
        ),
        titleTextStyle: baseText.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        hintStyle: baseText.bodyMedium?.copyWith(color: finance.mutedText),
        labelStyle: baseText.bodyMedium?.copyWith(color: finance.mutedText),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.outline;
            }
            if (states.contains(WidgetState.pressed)) {
              return finance.accentPressed;
            }
            return scheme.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
          minimumSize: const WidgetStatePropertyAll(
            Size(64, AppSpacing.buttonMinHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: 12),
          ),
          shape: WidgetStatePropertyAll(controlShape),
          elevation: const WidgetStatePropertyAll(0),
          overlayColor: overlay,
          animationDuration: AppSpacing.animFast,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return finance.accentPressed;
            }
            return scheme.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
          minimumSize: const WidgetStatePropertyAll(
            Size(64, AppSpacing.buttonMinHeight),
          ),
          shape: WidgetStatePropertyAll(controlShape),
          elevation: const WidgetStatePropertyAll(0),
          animationDuration: AppSpacing.animFast,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(scheme.primary),
          minimumSize: const WidgetStatePropertyAll(
            Size(64, AppSpacing.buttonMinHeight),
          ),
          side: WidgetStatePropertyAll(BorderSide(color: scheme.outline)),
          shape: WidgetStatePropertyAll(controlShape),
          overlayColor: overlay,
          animationDuration: AppSpacing.animFast,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(scheme.primary),
          shape: WidgetStatePropertyAll(controlShape),
          overlayColor: overlay,
          animationDuration: AppSpacing.animFast,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.primaryContainer,
        disabledColor: scheme.outline.withValues(alpha: 0.4),
        labelStyle: baseText.labelLarge!.copyWith(color: scheme.onSurface),
        secondaryLabelStyle:
            baseText.labelLarge!.copyWith(color: scheme.onPrimary),
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return scheme.primary;
            }
            return cardColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return scheme.onPrimary;
            }
            return finance.mutedText;
          }),
          side: WidgetStatePropertyAll(BorderSide(color: scheme.outline)),
          shape: WidgetStatePropertyAll(controlShape),
          visualDensity: VisualDensity.comfortable,
          animationDuration: AppSpacing.animFast,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        indicatorColor: finance.activeNavBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        overlayColor: overlay,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: baseText.bodySmall?.fontFamily,
            fontFamilyFallback: baseText.bodySmall?.fontFamilyFallback,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? scheme.primary : finance.mutedText,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.primary, size: 24);
          }
          return IconThemeData(color: finance.mutedText, size: 24);
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: const Color(0x0F0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: scheme.outline),
        ),
        titleTextStyle: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        contentTextStyle: baseText.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
          height: 1.45,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
        dragHandleColor: scheme.outline,
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: baseText.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
      hoverColor: finance.hoverOverlay,
      highlightColor: finance.hoverOverlay.withValues(alpha: 0.6),
      splashColor: scheme.primary.withValues(alpha: 0.12),
    );
  }

  static TextTheme _interTextTheme(ColorScheme scheme) {
    final primary = scheme.onSurface;
    final secondary = scheme.onSurfaceVariant;
    final muted = scheme.brightness == Brightness.dark
        ? AppColors.darkTextMuted
        : AppColors.textMuted;

    TextStyle inter({
      required double size,
      required FontWeight weight,
      required Color color,
      double height = 1.45,
      double? letterSpacing,
    }) {
      try {
        return GoogleFonts.inter(
          fontSize: size,
          fontWeight: weight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      } catch (_) {
        return TextStyle(
          fontFamily: 'Inter',
          fontFamilyFallback: const ['Segoe UI', 'Roboto', 'Arial', 'sans-serif'],
          fontSize: size,
          fontWeight: weight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      }
    }

    return TextTheme(
      displayLarge: inter(size: 36, weight: FontWeight.w700, color: primary, height: 1.2),
      displayMedium: inter(size: 28, weight: FontWeight.w700, color: primary, height: 1.25),
      displaySmall: inter(size: 24, weight: FontWeight.w700, color: primary, height: 1.25),
      headlineLarge: inter(size: 28, weight: FontWeight.w700, color: primary, height: 1.25),
      headlineMedium: inter(size: 24, weight: FontWeight.w700, color: primary, height: 1.3),
      headlineSmall: inter(size: 20, weight: FontWeight.w600, color: primary, height: 1.3),
      titleLarge: inter(size: 20, weight: FontWeight.w600, color: primary, height: 1.35),
      titleMedium: inter(size: 18, weight: FontWeight.w600, color: primary, height: 1.35),
      titleSmall: inter(size: 16, weight: FontWeight.w600, color: primary, height: 1.4),
      bodyLarge: inter(size: 16, weight: FontWeight.w400, color: primary, height: 1.5),
      bodyMedium: inter(size: 14, weight: FontWeight.w400, color: primary, height: 1.45),
      bodySmall: inter(size: 13, weight: FontWeight.w400, color: secondary, height: 1.4),
      labelLarge: inter(size: 14, weight: FontWeight.w600, color: primary, height: 1.4),
      labelMedium: inter(size: 12, weight: FontWeight.w500, color: secondary, height: 1.35),
      labelSmall: inter(
        size: 11,
        weight: FontWeight.w600,
        color: muted,
        height: 1.35,
        letterSpacing: 0.6,
      ),
    );
  }
}

/// Income / expense / transfer / chart colors accessed via [Theme.of].
@immutable
class FinanceColors extends ThemeExtension<FinanceColors> {
  const FinanceColors({
    required this.income,
    required this.expense,
    required this.transfer,
    required this.accentPressed,
    required this.mutedText,
    required this.hoverOverlay,
    required this.activeNavBackground,
    required this.chartPalette,
    required this.chartLabel,
    required this.gridLine,
  });

  final Color income;
  final Color expense;
  final Color transfer;
  final Color accentPressed;
  final Color mutedText;
  final Color hoverOverlay;
  final Color activeNavBackground;
  final List<Color> chartPalette;
  final Color chartLabel;
  final Color gridLine;

  static FinanceColors of(BuildContext context) {
    return Theme.of(context).extension<FinanceColors>()!;
  }

  Color chartColorAt(int index) =>
      chartPalette[index % chartPalette.length];

  @override
  FinanceColors copyWith({
    Color? income,
    Color? expense,
    Color? transfer,
    Color? accentPressed,
    Color? mutedText,
    Color? hoverOverlay,
    Color? activeNavBackground,
    List<Color>? chartPalette,
    Color? chartLabel,
    Color? gridLine,
  }) {
    return FinanceColors(
      income: income ?? this.income,
      expense: expense ?? this.expense,
      transfer: transfer ?? this.transfer,
      accentPressed: accentPressed ?? this.accentPressed,
      mutedText: mutedText ?? this.mutedText,
      hoverOverlay: hoverOverlay ?? this.hoverOverlay,
      activeNavBackground:
          activeNavBackground ?? this.activeNavBackground,
      chartPalette: chartPalette ?? this.chartPalette,
      chartLabel: chartLabel ?? this.chartLabel,
      gridLine: gridLine ?? this.gridLine,
    );
  }

  @override
  FinanceColors lerp(ThemeExtension<FinanceColors>? other, double t) {
    if (other is! FinanceColors) return this;
    return FinanceColors(
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      transfer: Color.lerp(transfer, other.transfer, t)!,
      accentPressed: Color.lerp(accentPressed, other.accentPressed, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      hoverOverlay: Color.lerp(hoverOverlay, other.hoverOverlay, t)!,
      activeNavBackground:
          Color.lerp(activeNavBackground, other.activeNavBackground, t)!,
      chartPalette: [
        for (var i = 0; i < chartPalette.length; i++)
          Color.lerp(
            chartPalette[i],
            other.chartPalette[i % other.chartPalette.length],
            t,
          )!,
      ],
      chartLabel: Color.lerp(chartLabel, other.chartLabel, t)!,
      gridLine: Color.lerp(gridLine, other.gridLine, t)!,
    );
  }
}
