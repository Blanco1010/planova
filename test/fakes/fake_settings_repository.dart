import 'package:planova/features/settings/domain/entities/app_theme_mode.dart';
import 'package:planova/features/settings/domain/repositories/settings_repository.dart';

/// Ajustes en memoria para las pruebas de interfaz.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({this.themeMode = AppThemeMode.system});

  final AppThemeMode themeMode;

  @override
  Stream<AppThemeMode> watchThemeMode() =>
      Stream<AppThemeMode>.value(themeMode);

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {}
}
