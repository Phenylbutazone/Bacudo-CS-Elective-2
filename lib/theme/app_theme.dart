import 'package:cs_elective_2/theme/wired_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const _mono = 'monospace';

  static ThemeData wired() => _build(
        brightness: Brightness.dark,
        background: WiredColors.wiredBlack,
        surface: WiredColors.wiredSurface,
        onSurface: WiredColors.wiredText,
        onSurfaceVariant: WiredColors.wiredMuted,
        primary: WiredColors.wiredAccent,
        border: WiredColors.wiredBorder,
      );

 
  static ThemeData visible() => _build(
        brightness: Brightness.light,
        background: WiredColors.visibleWhite,
        surface: Colors.white,
        onSurface: WiredColors.visibleBlack,
        onSurfaceVariant: const Color(0xFF555555),
        primary: const Color(0xFF5B4E96),
        border: WiredColors.visibleBorder,
      );

  static ThemeData light() => visible();
  static ThemeData dark() => wired();

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color primary,
    required Color border,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: _mono,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: brightness == Brightness.dark ? Colors.black : Colors.white,
        secondary: primary,
        onSecondary: brightness == Brightness.dark ? Colors.black : Colors.white,
        error: const Color(0xFFCC4444),
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
      ),
      dividerColor: border,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: background,
        foregroundColor: onSurface,
        titleTextStyle: TextStyle(
          fontFamily: _mono,
          fontSize: 14,
          letterSpacing: 1.2,
          color: onSurface,
        ),
        iconTheme: IconThemeData(color: onSurface, size: 20),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: border),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontFamily: _mono,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: onSurface,
        ),
        titleLarge: TextStyle(
          fontFamily: _mono,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleMedium: TextStyle(
          fontFamily: _mono,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: _mono,
          fontSize: 13,
          height: 1.6,
          color: onSurface,
        ),
        bodyMedium: TextStyle(
          fontFamily: _mono,
          fontSize: 12,
          height: 1.5,
          color: onSurface,
        ),
        bodySmall: TextStyle(
          fontFamily: _mono,
          fontSize: 11,
          color: onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontFamily: _mono,
          fontSize: 11,
          letterSpacing: 1,
          color: onSurfaceVariant,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: primary.withValues(alpha: 0.2),
          foregroundColor: onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: border),
          ),
          textStyle: const TextStyle(
            fontFamily: _mono,
            fontSize: 12,
            letterSpacing: 0.8,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          side: BorderSide(color: border),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: const TextStyle(
            fontFamily: _mono,
            fontSize: 12,
            letterSpacing: 0.8,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: onSurface,
          textStyle: TextStyle(
            fontFamily: _mono,
            fontSize: 12,
            decoration: TextDecoration.underline,
            decorationColor: onSurface.withValues(alpha: 0.7),
            color: onSurface,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: onSurface,
          shape: const RoundedRectangleBorder(),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: border,
      ),
    );

    return base;
  }
}
