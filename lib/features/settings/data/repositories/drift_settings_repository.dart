import '../../../../core/database/app_database.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/settings_repository.dart';

/// Guarda los ajustes como pares clave/valor en SQLite.
class DriftSettingsRepository implements SettingsRepository {
  const DriftSettingsRepository(this._db);

  static const String _themeModeKey = 'theme_mode';
  static const String _phoneHeightKey = 'phone_height_m';

  final AppDatabase _db;

  @override
  Stream<AppThemeMode> watchThemeMode() =>
      _watch(_themeModeKey).map(AppThemeMode.fromStorage);

  @override
  Future<void> saveThemeMode(AppThemeMode mode) => _save(_themeModeKey, mode.name);

  @override
  Stream<double> watchPhoneHeight() => _watch(_phoneHeightKey).map(
    (String? value) =>
        double.tryParse(value ?? '') ?? SettingsRepository.defaultPhoneHeight,
  );

  @override
  Future<void> savePhoneHeight(double meters) =>
      _save(_phoneHeightKey, '$meters');

  Stream<String?> _watch(String key) {
    return (_db.select(_db.appSettings)..where((t) => t.key.equals(key)))
        .watchSingleOrNull()
        .map((AppSettingRow? row) => row?.value);
  }

  Future<void> _save(String key, String value) async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(AppSettingRow(key: key, value: value));
  }
}
