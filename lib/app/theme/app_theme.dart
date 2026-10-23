import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Temas claro y oscuro de la app, construidos sobre la paleta de marca.
abstract final class AppTheme {
  /// Radio de esquina común a tarjetas, hojas y diálogos.
  static const double radius = 16;

  static ThemeData get light => _build(_lightScheme);

  static ThemeData get dark => _build(_darkScheme);

  static final ColorScheme _lightScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primaryBlue,
        onPrimary: Colors.white,
        primaryContainer: AppColors.deepBlue,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.lightBlue,
        onSecondary: AppColors.deepBlue,
        surface: AppColors.lightSurface,
        onSurface: AppColors.darkNavy,
        surfaceContainerLowest: AppColors.lightSurface,
        surfaceContainerLow: AppColors.lightBackground,
        surfaceContainer: AppColors.lightBackground,
        onSurfaceVariant: AppColors.mutedLight,
        outlineVariant: AppColors.borderLight,
      );

  static final ColorScheme _darkScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.lightBlue,
        onPrimary: AppColors.darkNavy,
        primaryContainer: AppColors.deepBlue,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.primaryBlue,
        onSecondary: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.onDark,
        surfaceContainerLowest: AppColors.darkSunken,
        surfaceContainerLow: AppColors.darkNavy,
        surfaceContainer: AppColors.darkSurface,
        onSurfaceVariant: AppColors.mutedDark,
        outlineVariant: AppColors.borderDark,
      );

  static ThemeData _build(ColorScheme scheme) {
    final bool isLight = scheme.brightness == Brightness.light;
    final Color canvas = isLight
        ? AppColors.lightBackground
        : AppColors.darkNavy;
    final Color titleColor = isLight ? AppColors.deepBlue : Colors.white;

    final ThemeData base = ThemeData(colorScheme: scheme);
    final TextTheme text = base.textTheme
        .apply(bodyColor: scheme.onSurface, displayColor: titleColor)
        .copyWith(
          titleLarge: base.textTheme.titleLarge?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: base.textTheme.titleMedium?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w600,
          ),
          labelLarge: base.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );

    final OutlineInputBorder fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );

    return base.copyWith(
      scaffoldBackgroundColor: canvas,
      canvasColor: canvas,
      textTheme: text,
      appBarTheme: AppBarThemeData(
        backgroundColor: canvas,
        foregroundColor: titleColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        titleTextStyle: text.titleMedium,
        subtitleTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: scheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: text.labelLarge),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: isLight ? AppColors.lightSurface : AppColors.darkSunken,
        border: fieldBorder,
        enabledBorder: fieldBorder,
        focusedBorder: fieldBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        titleTextStyle: text.titleLarge,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepBlue,
        contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
