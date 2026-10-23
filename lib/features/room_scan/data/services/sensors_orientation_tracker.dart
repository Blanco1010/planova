import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

import '../../../../core/measuring/sighting_math.dart';
import '../../domain/entities/device_aim.dart';
import '../../domain/services/orientation_tracker.dart';

/// Orientación real del teléfono: acelerómetro para la inclinación y
/// giroscopio para el giro.
class SensorsOrientationTracker implements OrientationTracker {
  const SensorsOrientationTracker();

  /// Suavizado de la inclinación: sin esto el número baila y no se puede leer.
  static const double _smoothing = 0.25;

  /// Saltos de tiempo mayores que esto no se integran: el teléfono estuvo
  /// dormido o la lectura se perdió.
  static const double _maxStepSeconds = 0.5;

  @override
  Stream<DeviceAim> watch() {
    StreamSubscription<AccelerometerEvent>? accelerometer;
    StreamSubscription<GyroscopeEvent>? gyroscope;
    AccelerometerEvent? lastAccelerometer;
    DateTime? lastGyroscopeAt;
    double? smoothedPitch;
    double turn = 0;

    late final StreamController<DeviceAim> controller;
    controller = StreamController<DeviceAim>(
      onListen: () {
        accelerometer =
            accelerometerEventStream(
              samplingPeriod: SensorInterval.uiInterval,
            ).listen((AccelerometerEvent event) {
              lastAccelerometer = event;
              final double? pitch = SightingMath.pitchRadians(
                event.x,
                event.y,
                event.z,
              );
              if (pitch == null) return;

              smoothedPitch = smoothedPitch == null
                  ? pitch
                  : smoothedPitch! * (1 - _smoothing) + pitch * _smoothing;
              controller.add(
                DeviceAim(pitchRadians: smoothedPitch!, turnRadians: turn),
              );
            });

        gyroscope =
            gyroscopeEventStream(
              samplingPeriod: SensorInterval.gameInterval,
            ).listen((GyroscopeEvent event) {
              final AccelerometerEvent? reference = lastAccelerometer;
              final DateTime? previous = lastGyroscopeAt;
              lastGyroscopeAt = event.timestamp;
              if (reference == null || previous == null) return;

              final double seconds =
                  event.timestamp.difference(previous).inMicroseconds / 1e6;
              if (seconds <= 0 || seconds > _maxStepSeconds) return;

              turn +=
                  SightingMath.turnRateToTheRight(
                    gx: event.x,
                    gy: event.y,
                    gz: event.z,
                    ax: reference.x,
                    ay: reference.y,
                    az: reference.z,
                  ) *
                  seconds;
            });
      },
      onCancel: () async {
        await accelerometer?.cancel();
        await gyroscope?.cancel();
      },
    );

    return controller.stream;
  }
}
