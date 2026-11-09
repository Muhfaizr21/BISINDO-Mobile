import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0C0D11);
  static const Color surface = Color(0xFF16171E);
  static const Color surfaceElevated = Color(0xFF1F2029);
  static const Color surfaceHigher = Color(0xFF262833);
  static const Color border = Color(0xFF292A36);
  static const Color borderLight = Color(0xFF383A48);

  static const Color primary = Color(0xFF8B5CF6); // Electric Violet
  static const Color primaryDark = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFFA78BFA);

  static const Color accentCyan = Color(0xFF00E5FF); // Neon Cyan
  static const Color accentPink = Color(0xFFFF007F); // Neon Magenta/Pink
  static const Color accentGreen = Color(0xFF10B981); // Emerald Online
  static const Color accentAmber = Color(0xFFF59E0B);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accentCyan,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
