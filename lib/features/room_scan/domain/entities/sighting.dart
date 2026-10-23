import '../../../../core/geometry/point2d.dart';
import '../../../../core/measuring/sighting_math.dart';

/// Una esquina marcada: a qué distancia quedó y con cuánto giro.
class Sighting {
  const Sighting({required this.distanceMeters, required this.turnRadians});

  final double distanceMeters;
  final double turnRadians;

  /// Dónde cae la esquina en el plano, tomando como centro al que mide.
  Point2D get point => SightingMath.floorPoint(
    distanceMeters: distanceMeters,
    turnRadians: turnRadians,
  );
}
