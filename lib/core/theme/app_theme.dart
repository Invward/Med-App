// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

/// BurnGuard Design System — "The Clinical Sanctuary"
/// All tokens sourced directly from the HTML/Tailwind config.
class AppColors {
  // Primary
  static const primary = Color(0xFF005AB3);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF0073E0);
  static const onPrimaryContainer = Color(0xFFFEFCFF);
  static const primaryFixed = Color(0xFFD6E3FF);
  static const primaryFixedDim = Color(0xFFAAC7FF);
  static const inversePrimary = Color(0xFFAAC7FF);

  // Secondary (green)
  static const secondary = Color(0xFF006E28);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFF6FFB85);
  static const onSecondaryContainer = Color(0xFF00732A);
  static const secondaryFixed = Color(0xFF72FE88);
  static const secondaryFixedDim = Color(0xFF53E16F);
  static const onSecondaryFixed = Color(0xFF002107);
  static const onSecondaryFixedVariant = Color(0xFF00531C);

  // Tertiary (orange/burn)
  static const tertiary = Color(0xFF9A4100);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFFC25300);
  static const onTertiaryContainer = Color(0xFFFFFBFF);
  static const tertiaryFixed = Color(0xFFFFDBCB);
  static const tertiaryFixedDim = Color(0xFFFFB691);
  static const onTertiaryFixed = Color(0xFF341100);
  static const onTertiaryFixedVariant = Color(0xFF793100);

  // Error
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // Surface & Background
  static const background = Color(0xFFF9F9FE);
  static const onBackground = Color(0xFF1A1C1F);
  static const surface = Color(0xFFF9F9FE);
  static const onSurface = Color(0xFF1A1C1F);
  static const surfaceBright = Color(0xFFF9F9FE);
  static const surfaceDim = Color(0xFFD9DADE);
  static const surfaceTint = Color(0xFF005DB8);
  static const inverseSurface = Color(0xFF2E3034);
  static const inverseOnSurface = Color(0xFFF0F0F5);

  // Surface containers
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF3F3F8);
  static const surfaceContainer = Color(0xFFEDEDF2);
  static const surfaceContainerHigh = Color(0xFFE8E8ED);
  static const surfaceContainerHighest = Color(0xFFE2E2E7);

  // Surface variant
  static const surfaceVariant = Color(0xFFE2E2E7);
  static const onSurfaceVariant = Color(0xFF414754);

  // Outline
  static const outline = Color(0xFF717786);
  static const outlineVariant = Color(0xFFC0C6D6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryContainer],
  );

  // Medical Glow Shadow
  static List<BoxShadow> get medicalGlow => [
    BoxShadow(
      color: const Color(0xFF0A84FF).withOpacity(0.06),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get emergencyGlow => [
    BoxShadow(
      color: const Color(0xFFBA1A1A).withOpacity(0.25),
      blurRadius: 50,
      offset: const Offset(0, 20),
    ),
  ];
}

class AppTextStyles {
  static const _headline = 'Manrope';
  static const _body = 'Inter';

  static const display = TextStyle(
    fontFamily: _headline,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.onSurface,
    height: 1.1,
  );

  static const headlineLarge = TextStyle(
    fontFamily: _headline,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    color: AppColors.onSurface,
  );

  static const headlineMedium = TextStyle(
    fontFamily: _headline,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  static const headlineSmall = TextStyle(
    fontFamily: _headline,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  static const titleLarge = TextStyle(
    fontFamily: _headline,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  static const bodyLarge = TextStyle(
    fontFamily: _body,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.6,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _body,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
    height: 1.5,
  );

  static const labelSmall = TextStyle(
    fontFamily: _body,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.onSurfaceVariant,
  );

  static const labelMedium = TextStyle(
    fontFamily: _body,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.surfaceTint,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xCCF8F8FD), // slate-50 @ 80%
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(
          color: AppColors.outlineVariant,
          fontFamily: 'Inter',
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Color(0xFF94A3B8), // slate-400
        selectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xE6F8F8FD),
        indicatorColor: const Color(0xFFEFF6FF),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return const IconThemeData(color: Color(0xFF94A3B8));
        }),
      ),
      dividerColor: Colors.transparent,
    );
  }
}

// Radius tokens
class AppRadius {
  static const sm = BorderRadius.all(Radius.circular(8));
  static const md = BorderRadius.all(Radius.circular(12));
  static const lg = BorderRadius.all(Radius.circular(16));
  static const xl = BorderRadius.all(Radius.circular(20));
  static const xl2 = BorderRadius.all(Radius.circular(24));
  static const xl3 = BorderRadius.all(Radius.circular(32));
  static const xl4 = BorderRadius.all(Radius.circular(40));
  static const full = BorderRadius.all(Radius.circular(999));
}

// Spacing tokens
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xl2 = 40.0;
  static const xl3 = 48.0;
}
