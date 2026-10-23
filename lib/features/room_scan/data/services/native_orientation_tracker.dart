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
  /// El convenio de la app es que el giro crece al mirar hacia la derecha, y
  /// eso es lo que da el rumbo del sistema (se mide desde el norte, hacia el
  /// este). Se probó a invertirlo creyendo que las esquinas se iban de sitio
  /// por aquí, y no era eso: era el desplazamiento del teléfono, que no se
  /// sigue. Queda nombrado por si alguna vez hiciera falta.
  static const double _turnSense = 1;

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
