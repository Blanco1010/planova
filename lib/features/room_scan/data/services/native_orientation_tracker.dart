import 'package:flutter/services.dart';

import '../../domain/entities/device_aim.dart';
import '../../domain/services/orientation_tracker.dart';

/// Orientación tomada de la fusión de sensores de Android.
///
/// Es la buena: no deriva, así que una esquina marcada se queda donde está
/// aunque se gire el teléfono de un lado a otro.
class NativeOrientationTracker implements OrientationTracker {
  const NativeOrientationTracker();

  static const EventChannel _channel = EventChannel('planova/orientation');

  /// Hacia dónde crece el rumbo que entrega el aparato.
  ///
  /// El convenio de la app es que el giro crece al mirar hacia la derecha.
  /// Probado en el teléfono, el rumbo del sistema viene al revés: sin esto,
  /// las esquinas marcadas se van hacia el mismo lado al que se gira.
  static const double _turnSense = -1;

  @override
  Stream<DeviceAim> watch() {
    return _channel.receiveBroadcastStream().map((Object? event) {
      final List<double> values = (event! as List<Object?>).cast<double>();
      return DeviceAim(
        pitchRadians: values[0],
        turnRadians: _turnSense * values[1],
      );
    });
  }
}
