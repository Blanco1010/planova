import 'dart:math' as math;

import '../geometry/point2d.dart';

/// Matemática de la medición con la cámara.
///
/// El método es el de toda la vida con un clinómetro: si sabes a qué altura
/// llevas el teléfono y con qué inclinación miras al pie de la pared, la
/// distancia sale por trigonometría. Son funciones puras, sin sensores de por
/// medio, para poder comprobarlas.
abstract final class SightingMath {
  /// Por debajo de esta inclinación la distancia se dispara: una décima de
  /// grado de error se convierte en metros, así que no se da por buena.
  static const double minPitchDegrees = 8;

  /// Más allá de esto no es una habitación, es una lectura perdida.
  static const double maxDistanceMeters = 30;

  /// Inclinación de la cámara por debajo de la horizontal, en radianes.
  ///
  /// Toma la lectura del acelerómetro en reposo, que apunta hacia arriba:
  /// con el teléfono de pie vale 0, y tumbado mirando al suelo, 90°.
  /// Devuelve `null` si la lectura no tiene sentido (teléfono en movimiento).
  static double? pitchRadians(double ax, double ay, double az) {
    final double norm = math.sqrt(ax * ax + ay * ay + az * az);
    if (norm < 5 || norm > 15) return null;
    return math.asin((az / norm).clamp(-1.0, 1.0));
  }

  /// Distancia horizontal hasta el punto del suelo al que apunta la cámara.
  ///
  /// `null` cuando el teléfono está demasiado levantado para fiarse.
  static double? distanceToFloorPoint({
    required double pitchRadians,
    required double eyeHeightMeters,
  }) {
    if (eyeHeightMeters <= 0) return null;
    if (pitchRadians < minPitchDegrees * math.pi / 180) return null;

    final double tangent = math.tan(pitchRadians);
    if (tangent <= 0) return null;

    final double distance = eyeHeightMeters / tangent;
    if (!distance.isFinite || distance > maxDistanceMeters) return null;
    return distance;
  }

  /// Velocidad de giro hacia la derecha, en radianes por segundo.
  ///
  /// Proyecta el giroscopio sobre la vertical del mundo (la que marca la
  /// gravedad), así da igual cómo esté inclinado el teléfono.
  static double turnRateToTheRight({
    required double gx,
    required double gy,
    required double gz,
    required double ax,
    required double ay,
    required double az,
  }) {
    final double norm = math.sqrt(ax * ax + ay * ay + az * az);
    if (norm == 0) return 0;

    final double dot = (gx * ax + gy * ay + gz * az) / norm;
    // Girar a la derecha es giro horario visto desde arriba, que con la regla
    // de la mano derecha sale negativo sobre la vertical.
    return -dot;
  }

  /// Coordenada de la esquina a la que se apunta, sabiendo desde dónde se
  /// mira. Así el punto queda anclado a la habitación y no a quien mide:
  /// aunque después se camine, la esquina sigue donde está.
  static Point2D cornerFrom(
    Point2D observer, {
    required double distanceMeters,
    required double turnRadians,
  }) {
    return observer +
        floorPoint(distanceMeters: distanceMeters, turnRadians: turnRadians);
  }

  /// El camino de vuelta: dónde está parado quien mide, sabiendo a qué
  /// esquina conocida apunta y a qué distancia la ve.
  ///
  /// Es lo que permite moverse por la obra sin perder el plano: se apunta a
  /// una esquina ya marcada y la app vuelve a saber dónde estás.
  static Point2D positionFromCorner(
    Point2D corner, {
    required double distanceMeters,
    required double turnRadians,
  }) {
    return corner -
        floorPoint(distanceMeters: distanceMeters, turnRadians: turnRadians);
  }

  /// Cómo se ve un punto desde [observer]: a qué distancia y con qué giro.
  static ({double distance, double turn}) viewFrom(
    Point2D observer,
    Point2D target,
  ) {
    final Point2D relative = target - observer;
    return (
      distance: math.sqrt(relative.x * relative.x + relative.y * relative.y),
      turn: math.atan2(relative.y, relative.x),
    );
  }

  /// Punto del suelo en el plano, visto desde donde está parado el usuario.
  ///
  /// El giro se mide desde la primera esquina marcada y crece hacia la
  /// derecha, igual que la `y` del plano crece hacia abajo en el dibujo.
  static Point2D floorPoint({
    required double distanceMeters,
    required double turnRadians,
  }) {
    return Point2D(
      distanceMeters * math.cos(turnRadians),
      distanceMeters * math.sin(turnRadians),
    );
  }
}
