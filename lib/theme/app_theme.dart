import 'package:flutter/material.dart';

class AppTheme {
  static bool isDarkMode = false;

  // Theme Color Palette (White & Green Combination with Slate Dark Mode Support)
  static Color get backgroundColor => isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB); // Slate 900 vs Off-White
  static Color get surfaceColor => isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF); // Slate 800 vs Pure White
  static Color get primaryColor => const Color(0xFF059669); // Emerald Green
  static Color get secondaryColor => const Color(0xFF10B981); // Vibrant Mint Green
  static Color get accentColor => const Color(0xFF34D399); // Teal-Green Accent
  static Color get warningColor => const Color(0xFFF59E0B); // Amber
  static Color get errorColor => const Color(0xFFEF4444); // Red
  static Color get textPrimary => isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF111827); // Slate 50 vs Charcoal
  static Color get textSecondary => isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF4B5563); // Slate 400 vs Slate Gray
  static Color get textMuted => isDarkMode ? const Color(0xFF64748B) : const Color(0xFF9CA3AF); // Slate 500 vs Light Slate Gray
  static Color get borderOverlay => isDarkMode ? const Color(0xFF334155) : const Color(0xFFE5E7EB); // Slate 700 vs Subtle Gray

  // Gradients
  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get accentGradient => const LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get backgroundGradient => LinearGradient(
    colors: [backgroundColor, isDarkMode ? const Color(0xFF022C22) : const Color(0xFFF0FDF4)], // Fading to dark/light green hint
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient get glassGradient => LinearGradient(
    colors: [
      isDarkMode ? const Color(0x1BFFFFFF) : const Color(0xB3FFFFFF),
      isDarkMode ? const Color(0x05FFFFFF) : const Color(0x33FFFFFF)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dynamic light theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF059669),
      scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      cardColor: const Color(0xFFFFFFFF),
      fontFamily: 'sans-serif',
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF059669),
        secondary: Color(0xFF10B981),
        surface: Color(0xFFFFFFFF),
        error: Color(0xFFEF4444),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF111827), letterSpacing: -0.5),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111827), letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF111827), height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.5),
        bodySmall: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFFFFFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF111827)),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
      ),
    );
  }

  // Dynamic dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF059669),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardColor: const Color(0xFF1E293B),
      fontFamily: 'sans-serif',
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF059669),
        secondary: Color(0xFF10B981),
        surface: Color(0xFF1E293B),
        error: Color(0xFFEF4444),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF8FAFC), letterSpacing: -0.5),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFF8FAFC), letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF8FAFC)),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFF8FAFC)),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFF8FAFC), height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF94A3B8), height: 1.5),
        bodySmall: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF334155), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFF8FAFC)),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF8FAFC)),
      ),
    );
  }
}
