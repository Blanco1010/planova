import '../../../../core/geometry/point2d.dart';

/// Engancha la puntería a una esquina ya marcada.
///
/// Sirve para cerrar la habitación sin dejar un hueco: al apuntar otra vez a
/// la primera esquina, el recorrido se cierra exactamente en ella.
abstract final class ScanSnap {
  /// Cuánto se puede estar de lejos y seguir contando como «encima».
  static const double defaultToleranceMeters = 0.6;

  /// Índice de la esquina a la que se engancha la puntería, o `null` si no
  /// hay ninguna cerca.
  static int? cornerNear(
    List<Point2D> corners,
    Point2D aim, {
    double toleranceMeters = defaultToleranceMeters,
  }) {
    int? nearest;
    double nearestDistance = double.infinity;

    for (int i = 0; i < corners.length; i++) {
      final double distance = corners[i].distanceTo(aim);
      if (distance <= toleranceMeters && distance < nearestDistance) {
        nearest = i;
        nearestDistance = distance;
      }
    }
    return nearest;
  }

  /// ¿Apuntar ahí cierra la habitación? Solo la primera esquina cierra, y
  /// hace falta que ya haya un polígono de al menos tres lados.
  static bool closesRoom(List<Point2D> corners, Point2D aim) {
    if (corners.length < 3) return false;
    return cornerNear(corners, aim) == 0;
  }
}
