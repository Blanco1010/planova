import 'dart:math' as math;

import 'point2d.dart';

/// Un punto del mundo real, en metros, tal como lo entrega ARCore.
///
/// La `y` es la altura; el suelo de la habitación queda en el plano `x`–`z`.
class Point3D {
  const Point3D(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  /// Lo que se ve desde arriba: la planta.
  Point2D get onFloor => Point2D(x, z);

  /// Distancia en línea recta hasta otro punto, en metros.
  double distanceTo(Point3D other) {
    final double dx = x - other.x;
    final double dy = y - other.y;
    final double dz = z - other.z;
    return math.sqrt(dx * dx + dy * dy + dz * dz);
  }

  @override
  bool operator ==(Object other) =>
      other is Point3D && other.x == x && other.y == y && other.z == z;

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  String toString() =>
      'Point3D(${x.toStringAsFixed(3)}, ${y.toStringAsFixed(3)}, '
      '${z.toStringAsFixed(3)})';
}
