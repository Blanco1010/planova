import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/presentation/providers/settings_providers.dart';
import '../../data/services/sensors_orientation_tracker.dart';
import '../../domain/entities/device_aim.dart';
import '../../domain/services/orientation_tracker.dart';

/// Lector de orientación. En las pruebas se sustituye por uno de mentira.
final Provider<OrientationTracker> orientationTrackerProvider =
    Provider<OrientationTracker>((ref) => const SensorsOrientationTracker());

/// Orientación del teléfono en vivo.
final deviceAimProvider = StreamProvider<DeviceAim>(
  (ref) => ref.watch(orientationTrackerProvider).watch(),
  isAutoDispose: true,
);

/// Altura a la que el usuario sostiene el teléfono, en metros.
final phoneHeightProvider = StreamProvider<double>(
  (ref) => ref.watch(settingsRepositoryProvider).watchPhoneHeight(),
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
