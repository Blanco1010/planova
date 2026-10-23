/// Preferencia de tema elegida por el usuario.
enum AppThemeMode {
  system,
  light,
  dark;

  /// Lee el valor guardado en la base de datos; si falta, usa el del sistema.
  static AppThemeMode fromStorage(String? value) {
    return AppThemeMode.values.firstWhere(
      (AppThemeMode mode) => mode.name == value,
      orElse: () => AppThemeMode.system,
    );
  }
}
