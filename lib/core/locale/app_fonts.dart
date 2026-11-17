import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

/// Script-aware text themes via google_fonts, with Inter fallbacks.
class AppFonts {
  AppFonts._();

  static TextTheme textThemeFor(Locale? locale, TextTheme base) {
    final code = locale?.languageCode ?? 'en';
    TextStyle Function({
      TextStyle? textStyle,
      Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      double? height,
      double? letterSpacing,
    }) loader;

    switch (code) {
      case 'ur':
        loader = GoogleFonts.notoNastaliqUrdu;
      case 'ar':
        loader = GoogleFonts.notoNaskhArabic;
      case 'hi':
      case 'bn':
        loader = GoogleFonts.notoSans;
      case 'zh':
        loader = GoogleFonts.notoSansSc;
      case 'ru':
        loader = GoogleFonts.notoSans;
      default:
        loader = GoogleFonts.inter;
    }

    TextStyle apply(TextStyle? style) {
      if (style == null) return loader();
      try {
        return loader(textStyle: style);
      } catch (_) {
        return GoogleFonts.inter(textStyle: style);
      }
    }

    return base.copyWith(
      displayLarge: apply(base.displayLarge),
      displayMedium: apply(base.displayMedium),
      displaySmall: apply(base.displaySmall),
      headlineLarge: apply(base.headlineLarge),
      headlineMedium: apply(base.headlineMedium),
      headlineSmall: apply(base.headlineSmall),
      titleLarge: apply(base.titleLarge),
      titleMedium: apply(base.titleMedium),
      titleSmall: apply(base.titleSmall),
      bodyLarge: apply(base.bodyLarge),
      bodyMedium: apply(base.bodyMedium),
      bodySmall: apply(base.bodySmall),
      labelLarge: apply(base.labelLarge),
      labelMedium: apply(base.labelMedium),
      labelSmall: apply(base.labelSmall),
    );
  }

  static ThemeData applyToTheme(ThemeData theme, Locale? locale) {
    final text = textThemeFor(locale, theme.textTheme);
    return theme.copyWith(
      textTheme: text,
      primaryTextTheme: textThemeFor(locale, theme.primaryTextTheme),
    );
  }
}
