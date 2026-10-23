import '../entities/app_theme_mode.dart';

/// Ajustes de la app que sobreviven al cierre.
abstract interface class SettingsRepository {
  /// Altura a la que se sostiene el teléfono al medir, si no se ha cambiado.
  static const double defaultPhoneHeight = 1.50;

  Stream<AppThemeMode> watchThemeMode();

  Future<void> saveThemeMode(AppThemeMode mode);

  /// Altura del teléfono sobre el suelo al medir con la cámara, en metros.
  Stream<double> watchPhoneHeight();

  Future<void> savePhoneHeight(double meters);
}
