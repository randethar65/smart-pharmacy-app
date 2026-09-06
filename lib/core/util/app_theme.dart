import 'package:flutter/material.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';

/// App-wide theme. Headings use Space Grotesk, body uses Inter
/// (both bundled in pubspec.yaml under `flutter > fonts`).
class AppTheme {
  AppTheme._();

  static const String _headingFont = 'PlusJakartaSans';
  static const String _bodyFont = 'Inter';

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: _bodyFont,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent, // يلغي طبقة الـ tint وقت الـ scroll
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.textPrimary, // لون الأيقونات/العنوان الافتراضي
        centerTitle: false,
      ),
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    TextStyle heading(TextStyle? s, {double? size, FontWeight weight = FontWeight.w600}) =>
        (s ?? const TextStyle()).copyWith(
          fontFamily: _headingFont,
          fontWeight: weight,
          fontSize: size,
          color: AppColors.textPrimary,
        );

    return base.copyWith(
      // --- Space Grotesk headings ---
      displayLarge: heading(base.displayLarge, weight: FontWeight.w700),
      displayMedium: heading(base.displayMedium, weight: FontWeight.w700),
      displaySmall: heading(base.displaySmall, weight: FontWeight.w700),
      headlineLarge: heading(base.headlineLarge),
      headlineMedium: heading(base.headlineMedium),
      headlineSmall: heading(base.headlineSmall),

      // Brand wordmark slot: Space Grotesk, bold, 24, teal-green.
      // Use for the "Smart Pharmacy" header / app-bar title.
      titleLarge: heading(
        base.titleLarge,
        size: 24,
        weight: FontWeight.w700,
      ).copyWith(color: AppColors.primary),

      titleMedium: heading(base.titleMedium),
      titleSmall: heading(base.titleSmall),

      // --- Inter body (inherits fontFamily from ThemeData) ---
      bodyLarge: base.bodyLarge?.copyWith(color: AppColors.textPrimary),
      bodyMedium: base.bodyMedium?.copyWith(color: AppColors.textPrimary),
      bodySmall: base.bodySmall?.copyWith(color: AppColors.textSecondary),
    );
  }
}
