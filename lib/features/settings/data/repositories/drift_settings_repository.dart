import '../../../../core/database/app_database.dart';
import '../../../../core/utils/money.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/settings_repository.dart';

/// Guarda los ajustes como pares clave/valor en SQLite.
class DriftSettingsRepository implements SettingsRepository {
  const DriftSettingsRepository(this._db);

  static const String _themeModeKey = 'theme_mode';
  static const String _moneyKey = 'money_format';

  final AppDatabase _db;

  @override
  Stream<AppThemeMode> watchThemeMode() =>
      _watch(_themeModeKey).map(AppThemeMode.fromStorage);

  @override
  Future<void> saveThemeMode(AppThemeMode mode) =>
      _save(_themeModeKey, mode.name);

  @override
  Stream<MoneyFormat> watchMoney() =>
      _watch(_moneyKey).map(MoneyFormat.fromStorage);

  @override
  Future<void> saveMoney(MoneyFormat money) => _save(_moneyKey, money.name);

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
