import '../../../../core/geometry/point2d.dart';
import '../../../../core/geometry/point3d.dart';

/// Lo que la cámara tiene bajo la mira en este instante.
class SpatialHit {
  const SpatialHit({required this.point, required this.distanceMeters});

  /// Dónde está ese punto en el mundo.
  final Point3D point;

  /// A cuánto está de la cámara. Lo mide el aparato, no se estima.
  final double distanceMeters;
}

/// Un fotograma del escaneo con seguimiento espacial.
///
/// Trae lo único que hace falta para dibujar encima: qué hay bajo la mira y
/// dónde cae en la pantalla cualquier punto del mundo.
class SpatialFrame {
  const SpatialFrame({required this.aim, required this.project});

  /// `null` cuando la mira no encuentra superficie reconocida.
  final SpatialHit? aim;

  /// Dónde se dibuja un punto del mundo; `null` si queda detrás de la cámara.
  final Point2D? Function(Point3D world) project;

  bool get isTracking => aim != null;
}
