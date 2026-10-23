import 'package:flutter/widgets.dart';
import 'package:planova/core/geometry/point2d.dart';
import 'package:planova/core/geometry/point3d.dart';
import 'package:planova/features/room_scan/domain/entities/scan_surface.dart';
import 'package:planova/features/room_scan/domain/entities/spatial_frame.dart';
import 'package:planova/features/room_scan/presentation/services/spatial_scanner.dart';

/// Cámara con seguimiento de mentira: la prueba decide qué hay bajo la mira.
///
/// Proyecta el mundo en la pantalla con una vista cenital sencilla, que basta
/// para comprobar que el dibujo y las cuentas usan lo que toca.
class FakeSpatialScanner implements SpatialScanner {
  ValueChanged<SpatialFrame?>? _onFrame;

  /// Metros por píxel del proyector de mentira.
  static const double scale = 40;

  void aimAt(Point3D world, {double distanceMeters = 3}) {
    _onFrame?.call(
      SpatialFrame(
        aim: SpatialHit(point: world, distanceMeters: distanceMeters),
        project: _project,
      ),
    );
  }

  void lose() => _onFrame?.call(SpatialFrame(aim: null, project: _project));

  static Point2D _project(Point3D world) =>
      Point2D(200 + world.x * scale, 400 + world.z * scale);

  /// Lo último que se le pidió mirar.
  ScanSurface? lastSurface;

  @override
  Widget view({
    required ValueChanged<SpatialFrame?> onFrame,
    required ScanSurface surface,
  }) {
    _onFrame = onFrame;
    lastSurface = surface;
    return const SizedBox.expand();
  }
}
