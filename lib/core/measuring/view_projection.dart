import 'dart:math' as math;

import '../geometry/point2d.dart';

/// Lleva un punto del suelo a su sitio dentro de la imagen de la cámara.
///
/// Con esto las esquinas marcadas se quedan pegadas al sitio donde están en
/// la habitación: el dibujo se ve encima de la pared de verdad, no en un
/// plano aparte.
class ViewProjection {
  const ViewProjection({
    required this.widthPx,
    required this.heightPx,
    required this.aimTurnRadians,
    required this.aimPitchRadians,
    required this.phoneHeightMeters,
    this.horizontalFovRadians = defaultHorizontalFovRadians,
  });

  /// Lo que abarca la pantalla a lo ancho, en radianes (unos 62°).
  ///
  /// La cámara no dice cuánto abarca su vista, así que esto es una
  /// estimación: si el dibujo no casa con lo que se ve, este es el número
  /// que hay que ajustar.
  static const double defaultHorizontalFovRadians = 62 * math.pi / 180;

  /// Más allá de este giro el punto queda tan de lado que no se dibuja.
  static const double _maxBearingRadians = 75 * math.pi / 180;

  final double widthPx;
  final double heightPx;

  /// Giro y inclinación a los que apunta la cámara ahora mismo.
  final double aimTurnRadians;
  final double aimPitchRadians;

  final double phoneHeightMeters;
  final double horizontalFovRadians;

  /// El centro de la pantalla: es justo el punto del suelo al que se apunta.
  Point2D get reticle => Point2D(widthPx / 2, heightPx / 2);

  /// Distancia focal en píxeles, la que convierte ángulos en pantalla.
  double get _focalPx => (widthPx / 2) / math.tan(horizontalFovRadians / 2);

  /// Dónde cae en la pantalla el punto del suelo que está a
  /// [distanceMeters] con un giro de [turnRadians]. `null` si queda fuera.
  Point2D? project({
    required double distanceMeters,
    required double turnRadians,
  }) {
    if (distanceMeters <= 0 || phoneHeightMeters <= 0) return null;

    final double bearing = normalizeRadians(turnRadians - aimTurnRadians);
    if (bearing.abs() > _maxBearingRadians) return null;

    // Cuanto más lejos está el punto, más cerca del horizonte se ve.
    final double depression = math.atan(phoneHeightMeters / distanceMeters);
    final double vertical = depression - aimPitchRadians;
    if (vertical.abs() > _maxBearingRadians) return null;

    final double focal = _focalPx;
    final double x = widthPx / 2 + focal * math.tan(bearing);
    final double y = heightPx / 2 + focal * math.tan(vertical);
    if (!x.isFinite || !y.isFinite) return null;

    return Point2D(x, y);
  }

  /// Deja un ángulo entre -π y π.
  static double normalizeRadians(double radians) {
    const double twoPi = 2 * math.pi;
    double value = (radians + math.pi) % twoPi;
    if (value < 0) value += twoPi;
    return value - math.pi;
  }
}
