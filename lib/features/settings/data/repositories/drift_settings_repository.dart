import '../../../../core/database/app_database.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/settings_repository.dart';

/// Guarda los ajustes como pares clave/valor en SQLite.
class DriftSettingsRepository implements SettingsRepository {
  const DriftSettingsRepository(this._db);

  static const String _themeModeKey = 'theme_mode';

  final AppDatabase _db;

  @override
  Stream<AppThemeMode> watchThemeMode() {
    return (_db.select(_db.appSettings)
          ..where((t) => t.key.equals(_themeModeKey)))
        .watchSingleOrNull()
        .map((AppSettingRow? row) => AppThemeMode.fromStorage(row?.value));
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingRow(key: _themeModeKey, value: mode.name),
        );
  }
}
