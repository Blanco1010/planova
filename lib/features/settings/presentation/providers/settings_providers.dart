import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/utils/money.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import '../../../projects/presentation/providers/project_providers.dart';
import '../../../rooms/presentation/providers/room_providers.dart';
import '../../data/repositories/drift_settings_repository.dart';
import '../../data/services/demo_data_service.dart';
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

/// Moneda elegida, en vivo. Mientras carga, pesos.
final StreamProvider<MoneyFormat> moneyProvider = StreamProvider<MoneyFormat>(
  (ref) => ref.watch(settingsRepositoryProvider).watchMoney(),
);

/// Cómo se llama cada moneda en la interfaz.
extension MoneyFormatView on MoneyFormat {
  String get label => switch (this) {
    MoneyFormat.cop => 'Peso colombiano',
    MoneyFormat.usd => 'Dólar',
  };

  /// `$ · peso colombiano` para la lista de ajustes.
  String get example => switch (this) {
    MoneyFormat.cop => r'$ 1.250.000',
    MoneyFormat.usd => r'US$ 1,250.00',
  };
}

/// Nombre y equivalente de Flutter de cada modo, para la interfaz.
extension AppThemeModeView on AppThemeMode {
  String get label => switch (this) {
    AppThemeMode.system => 'Igual que el sistema',
    AppThemeMode.light => 'Claro',
    AppThemeMode.dark => 'Oscuro',
  };

  ThemeMode get themeMode => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}

/// Quien siembra el proyecto de ejemplo para probar sin cámara.
final Provider<DemoDataService> demoDataProvider = Provider<DemoDataService>(
  (ref) => DemoDataService(
    projects: ref.watch(projectRepositoryProvider),
    rooms: ref.watch(roomRepositoryProvider),
    budget: ref.watch(budgetRepositoryProvider),
  ),
);
