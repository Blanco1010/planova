import 'dart:async';

import 'package:planova/features/settings/domain/entities/app_theme_mode.dart';
import 'package:planova/features/settings/domain/repositories/settings_repository.dart';

/// Ajustes en memoria para las pruebas de interfaz.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({
    this.themeMode = AppThemeMode.system,
    this.phoneHeight = SettingsRepository.defaultPhoneHeight,
  }) : _phoneHeight = phoneHeight;

  final AppThemeMode themeMode;
  final double phoneHeight;
  final StreamController<double> _heights =
      StreamController<double>.broadcast();
  double _phoneHeight;

  void dispose() => _heights.close();

  @override
  Stream<AppThemeMode> watchThemeMode() =>
      Stream<AppThemeMode>.value(themeMode);

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {}

  @override
  Stream<double> watchPhoneHeight() async* {
    yield _phoneHeight;
    yield* _heights.stream;
  }

  @override
  Future<void> savePhoneHeight(double meters) async {
    _phoneHeight = meters;
    if (!_heights.isClosed) _heights.add(meters);
  }
}
