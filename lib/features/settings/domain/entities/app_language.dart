/// Idioma elegido por el usuario.
///
/// `system` sigue al teléfono; los demás mandan sobre él, que es lo que pide
/// quien tiene el teléfono en un idioma y trabaja en otro.
enum AppLanguage {
  system,
  spanish,
  english;

  /// El código que entiende Flutter, o `null` para seguir al sistema.
  String? get code => switch (this) {
    AppLanguage.system => null,
    AppLanguage.spanish => 'es',
    AppLanguage.english => 'en',
  };

  /// Lee el valor guardado; si falta, el del sistema.
  static AppLanguage fromStorage(String? value) {
    return AppLanguage.values.firstWhere(
      (AppLanguage language) => language.name == value,
      orElse: () => AppLanguage.system,
    );
  }
}
