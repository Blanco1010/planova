import '../../../../core/utils/money.dart';
import '../entities/app_theme_mode.dart';

/// Ajustes de la app que sobreviven al cierre.
abstract interface class SettingsRepository {
  Stream<AppThemeMode> watchThemeMode();

  Future<void> saveThemeMode(AppThemeMode mode);

  Stream<MoneyFormat> watchMoney();

  Future<void> saveMoney(MoneyFormat money);
}
