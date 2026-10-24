import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/utils/money.dart';
import '../../../../l10n/app_l10n.dart';
import '../../data/repositories/drift_settings_repository.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/settings_repository.dart';

final Provider<SettingsRepository> settingsRepositoryProvider =
    Provider<SettingsRepository>(
      (ref) => DriftSettingsRepository(ref.watch(databaseProvider)),
    );

/// Tema elegido, en vivo. Mientras carga, la app usa el del sistema.
final StreamProvider<AppThemeMode> themeModeProvider =
    StreamProvider<AppThemeMode>(
      (ref) => ref.watch(settingsRepositoryProvider).watchThemeMode(),
    );

/// Cómo se llama cada idioma en la interfaz.
extension AppLanguageView on AppLanguage {
  String label(AppL10n t) => switch (this) {
    AppLanguage.system => t.optionSystem,
    AppLanguage.spanish => t.languageSpanish,
    AppLanguage.english => t.languageEnglish,
  };
}

/// Idioma elegido, en vivo. Mientras carga, el del sistema.
final StreamProvider<AppLanguage> languageProvider =
    StreamProvider<AppLanguage>(
      (ref) => ref.watch(settingsRepositoryProvider).watchLanguage(),
    );

/// Moneda elegida, en vivo. Mientras carga, pesos.
final StreamProvider<MoneyFormat> moneyProvider = StreamProvider<MoneyFormat>(
  (ref) => ref.watch(settingsRepositoryProvider).watchMoney(),
);

/// Cómo se llama cada moneda en la interfaz.
extension MoneyFormatView on MoneyFormat {
  String label(AppL10n t) => switch (this) {
    MoneyFormat.cop => t.currencyCop,
    MoneyFormat.usd => t.currencyUsd,
  };

  /// `$ · peso colombiano` para la lista de ajustes.
  String get example => switch (this) {
    MoneyFormat.cop => r'$ 1.250.000',
    MoneyFormat.usd => r'US$ 1,250.00',
  };
}

/// Nombre y equivalente de Flutter de cada modo, para la interfaz.
extension AppThemeModeView on AppThemeMode {
  String label(AppL10n t) => switch (this) {
    AppThemeMode.system => t.optionSystem,
    AppThemeMode.light => t.themeLight,
    AppThemeMode.dark => t.themeDark,
  };

  ThemeMode get themeMode => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}
