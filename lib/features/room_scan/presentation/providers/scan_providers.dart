import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/fallback_orientation_tracker.dart';
import '../../data/services/native_orientation_tracker.dart';
import '../../data/services/sensors_orientation_tracker.dart';
import '../../domain/entities/camera_field_of_view.dart';
import '../../domain/entities/device_aim.dart';
import '../../domain/services/orientation_tracker.dart';

/// Lector de orientación. En las pruebas se sustituye por uno de mentira.
final Provider<OrientationTracker> orientationTrackerProvider =
    Provider<OrientationTracker>(
      (ref) => const FallbackOrientationTracker(
        NativeOrientationTracker(),
        SensorsOrientationTracker(),
      ),
    );

/// Orientación del teléfono en vivo.
final deviceAimProvider = StreamProvider<DeviceAim>(
  (ref) => ref.watch(orientationTrackerProvider).watch(),
  isAutoDispose: true,
);

/// Cámara trasera lista para el visor; `null` si el aparato no tiene.
///
/// Devuelve error si el permiso está denegado: la pantalla lo cuenta y deja
/// seguir midiendo sin imagen.
final cameraControllerProvider = FutureProvider<CameraController?>((ref) async {
  final List<CameraDescription> cameras = await availableCameras();
  if (cameras.isEmpty) return null;

  final CameraDescription camera = cameras.firstWhere(
    (CameraDescription it) => it.lensDirection == CameraLensDirection.back,
    orElse: () => cameras.first,
  );
  final CameraController controller = CameraController(
    camera,
    ResolutionPreset.medium,
    enableAudio: false,
  );
  ref.onDispose(controller.dispose);

  await controller.initialize();
  return controller;
}, isAutoDispose: true);

/// Cuánto abarca la cámara de este aparato.
///
/// Se le pregunta al sistema; si no lo dice, se usa una estimación. De este
/// número depende que el dibujo caiga justo encima de la pared.
final cameraFieldOfViewProvider = FutureProvider<CameraFieldOfView>((
  ref,
) async {
  const MethodChannel channel = MethodChannel('planova/camera');
  try {
    final List<Object?>? result = await channel.invokeListMethod<Object?>(
      'fieldOfView',
    );
    if (result == null || result.length < 2) return CameraFieldOfView.estimated;

    final List<double> values = result.cast<double>();
    return CameraFieldOfView(
      wider: math.max(values[0], values[1]),
      narrower: math.min(values[0], values[1]),
    );
  } catch (_) {
    return CameraFieldOfView.estimated;
  }
});

/// Si este teléfono puede saber hacia dónde se gira.
///
/// Sin giroscopio no hay plano: se puede medir una distancia, pero no
/// levantar la habitación girando. Si el sistema no contesta se da por
/// bueno, que es lo que pasa en las pruebas.
final turnSensorProvider = FutureProvider<bool>((ref) async {
  const MethodChannel channel = MethodChannel('planova/sensors');
  try {
    return await channel.invokeMethod<bool>('hasTurnSensor') ?? true;
  } catch (_) {
    return true;
  }
});
