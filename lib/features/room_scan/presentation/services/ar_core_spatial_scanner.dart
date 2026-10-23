import 'package:ar_measure_flutter/datatypes/config_planedetection.dart';
import 'package:ar_measure_flutter/managers/ar_anchor_manager.dart';
import 'package:ar_measure_flutter/managers/ar_location_manager.dart';
import 'package:ar_measure_flutter/managers/ar_object_manager.dart';
import 'package:ar_measure_flutter/managers/ar_session_manager.dart';
import 'package:ar_measure_flutter/models/ar_frame_update.dart';
import 'package:ar_measure_flutter/models/ar_hittest_result.dart';
import 'package:ar_measure_flutter/widgets/ar_view.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../../../../core/geometry/point2d.dart';
import '../../../../core/geometry/point3d.dart';
import '../../domain/entities/scan_surface.dart';
import '../../domain/entities/spatial_frame.dart';
import 'spatial_scanner.dart';

/// La cámara con seguimiento de ARCore.
///
/// ARCore mide la distancia de verdad y sabe dónde está el teléfono, así que
/// las esquinas marcadas se quedan clavadas aunque se camine. No hace falta
/// calibrar nada ni decir a qué altura se lleva el aparato.
class ArCoreSpatialScanner implements SpatialScanner {
  const ArCoreSpatialScanner();

  /// Cuántas veces por segundo se pregunta qué hay bajo la mira.
  static const int _samplesPerSecond = 20;

  @override
  Widget view({
    required ValueChanged<SpatialFrame?> onFrame,
    required ScanSurface surface,
  }) {
    return _ArCoreView(
      onFrame: onFrame,
      surface: surface,
      samplesPerSecond: _samplesPerSecond,
    );
  }
}

class _ArCoreView extends StatefulWidget {
  const _ArCoreView({
    required this.onFrame,
    required this.surface,
    required this.samplesPerSecond,
  });

  final ValueChanged<SpatialFrame?> onFrame;
  final ScanSurface surface;
  final int samplesPerSecond;

  @override
  State<_ArCoreView> createState() => _ArCoreViewState();
}

class _ArCoreViewState extends State<_ArCoreView> {
  ARSessionManager? _session;

  @override
  void dispose() {
    _session?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ARView(
          // Se le dice qué buscar: con las dos cosas a la vez tarda más y
          // engancha la que no toca.
          planeDetectionConfig: switch (widget.surface) {
            ScanSurface.floor => PlaneDetectionConfig.horizontal,
            ScanSurface.wall => PlaneDetectionConfig.vertical,
          },
          permissionPromptDescription:
              'Planova necesita la cámara para medir la habitación.',
          permissionPromptButtonText: 'Dar permiso',
          onARViewCreated: (
            ARSessionManager session,
            ARObjectManager objects,
            ARAnchorManager anchors,
            ARLocationManager location,
          ) => _start(session, constraints.biggest, context),
        );
      },
    );
  }

  Future<void> _start(
    ARSessionManager session,
    Size size,
    BuildContext context,
  ) async {
    _session = session;
    session
      ..onInitialize(
        // La manita que da vueltas no se quita nunca y estorba.
        showAnimatedGuide: false,
        showFeaturePoints: false,
        showPlanes: true,
        handleTaps: false,
      )
      ..onFrameUpdate = _onFrameUpdate;

    // La mira está en el centro de la vista, en píxeles del aparato.
    final double ratio = MediaQuery.devicePixelRatioOf(context);
    await session.setFrameUpdates(
      true,
      x: size.width * ratio / 2,
      y: size.height * ratio / 2,
      hz: widget.samplesPerSecond,
    );
  }

  void _onFrameUpdate(ARFrameUpdate? update) {
    if (update == null) {
      widget.onFrame(null);
      return;
    }

    final ARHitTestResult? hit = update.reticleHit;
    final double ratio = View.of(context).devicePixelRatio;

    widget.onFrame(
      SpatialFrame(
        aim: hit == null
            ? null
            : SpatialHit(
                point: _toPoint(hit.worldTransform.getTranslation()),
                distanceMeters: hit.distance,
              ),
        project: (Point3D world) {
          final Offset? screen = update.project(
            vm.Vector3(world.x, world.y, world.z),
          );
          // El proyector trabaja en píxeles del aparato; la pantalla de
          // Flutter va en los suyos.
          return screen == null
              ? null
              : Point2D(screen.dx / ratio, screen.dy / ratio);
        },
      ),
    );
  }

  Point3D _toPoint(vm.Vector3 translation) =>
      Point3D(translation.x, translation.y, translation.z);
}
