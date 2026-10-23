import 'dart:async';

import '../../domain/entities/device_aim.dart';
import '../../domain/services/orientation_tracker.dart';

/// Usa el primer lector y, si no puede, se pasa al segundo.
///
/// En Android manda la fusión de sensores del sistema; donde no la haya
/// (aparatos sin sensor de rotación, otras plataformas) se cae al
/// giroscopio, que deriva pero sirve para salir del paso.
class FallbackOrientationTracker implements OrientationTracker {
  const FallbackOrientationTracker(this._preferred, this._backup);

  final OrientationTracker _preferred;
  final OrientationTracker _backup;

  @override
  Stream<DeviceAim> watch() async* {
    bool delivered = false;
    try {
      // Con `await for` el fallo llega aquí; con `yield*` se escaparía.
      await for (final DeviceAim aim in _preferred.watch()) {
        delivered = true;
        yield aim;
      }
      if (delivered) return;
    } catch (_) {
      // El lector preferido no sirve en este aparato.
    }
    yield* _backup.watch();
  }
}
