import '../../../../core/geometry/point2d.dart';
import '../../../../core/measuring/sighting_math.dart';

/// Lo medido hasta ahora: las esquinas de la habitación y dónde está parado
/// quien mide.
///
/// Las esquinas van en coordenadas de la habitación, no respecto a quien
/// mide. Por eso se puede caminar: lo que cambia al moverse es [observer],
/// y las paredes se quedan donde están.
class ScanSession {
  const ScanSession({required this.observer, required this.corners});

  static const ScanSession empty = ScanSession(
    observer: Point2D.origin,
    corners: <Point2D>[],
  );

  /// Dónde está parado quien mide.
  final Point2D observer;

  /// Esquinas marcadas, en orden de recorrido.
  final List<Point2D> corners;

  bool get isEmpty => corners.isEmpty;

  /// Marca la esquina que se ve a [distanceMeters] con un giro de
  /// [turnRadians], y la guarda ya convertida a coordenadas.
  ScanSession mark({
    required double distanceMeters,
    required double turnRadians,
  }) {
    return ScanSession(
      observer: observer,
      corners: <Point2D>[
        ...corners,
        SightingMath.cornerFrom(
          observer,
          distanceMeters: distanceMeters,
          turnRadians: turnRadians,
        ),
      ],
    );
  }

  /// Vuelve a situar a quien mide: apunta a la esquina [cornerIndex], que ya
  /// está marcada, y de ahí sale la posición nueva.
  ScanSession relocateFrom(
    int cornerIndex, {
    required double distanceMeters,
    required double turnRadians,
  }) {
    if (cornerIndex < 0 || cornerIndex >= corners.length) return this;

    return ScanSession(
      observer: SightingMath.positionFromCorner(
        corners[cornerIndex],
        distanceMeters: distanceMeters,
        turnRadians: turnRadians,
      ),
      corners: corners,
    );
  }

  ScanSession withoutLast() {
    if (corners.isEmpty) return this;
    return ScanSession(
      observer: observer,
      corners: corners.sublist(0, corners.length - 1),
    );
  }

  /// Cómo se ve [corner] desde donde se está: a qué distancia y giro.
  ({double distance, double turn}) viewOf(Point2D corner) =>
      SightingMath.viewFrom(observer, corner);

  /// Dónde cae el punto al que se apunta ahora, en coordenadas.
  Point2D aimPoint({
    required double distanceMeters,
    required double turnRadians,
  }) => SightingMath.cornerFrom(
    observer,
    distanceMeters: distanceMeters,
    turnRadians: turnRadians,
  );
}
