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

  @override
  Stream<DeviceAim> watch() {
    return _channel.receiveBroadcastStream().map((Object? event) {
      final List<double> values = (event! as List<Object?>).cast<double>();
      return DeviceAim(pitchRadians: values[0], turnRadians: values[1]);
    });
  }
}
