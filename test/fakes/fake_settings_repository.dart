import 'package:planova/core/utils/money.dart';
import 'package:planova/features/settings/domain/entities/app_language.dart';
import 'package:planova/features/settings/domain/entities/app_theme_mode.dart';
import 'package:planova/features/settings/domain/repositories/settings_repository.dart';

/// Ajustes en memoria para las pruebas de interfaz.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({
    this.themeMode = AppThemeMode.system,
    this.money = MoneyFormat.cop,
    this.language = AppLanguage.system,
  });

  final AppThemeMode themeMode;
  final MoneyFormat money;
  final AppLanguage language;

  @override
  Stream<AppThemeMode> watchThemeMode() =>
      Stream<AppThemeMode>.value(themeMode);

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {}

  @override
  Stream<MoneyFormat> watchMoney() => Stream<MoneyFormat>.value(money);

  @override
  Future<void> saveMoney(MoneyFormat money) async {}

  @override
  Stream<AppLanguage> watchLanguage() => Stream<AppLanguage>.value(language);

  @override
  Future<void> saveLanguage(AppLanguage language) async {}
}
