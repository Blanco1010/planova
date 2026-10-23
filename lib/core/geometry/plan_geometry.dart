import 'dart:math' as math;

import 'point2d.dart';

/// Un tramo de la cadena de paredes: cuánto mide y cuánto gira respecto a la
/// pared anterior. Un giro de +90° es girar a la derecha en el dibujo.
class WallStep {
  const WallStep({required this.lengthMeters, required this.turnDegrees});

  final double lengthMeters;
  final double turnDegrees;
}

/// Rectángulo que envuelve un conjunto de puntos.
class PlanBounds {
  const PlanBounds({required this.min, required this.max});

  final Point2D min;
  final Point2D max;

  double get width => max.x - min.x;
  double get height => max.y - min.y;
}

/// Cálculos de geometría del plano. Funciones puras, sin nada de Flutter.
abstract final class PlanGeometry {
  /// Recorre la cadena de paredes desde el origen y devuelve los vértices.
  ///
  /// Devuelve un punto más que paredes: el último es donde termina el
  /// recorrido, que coincidirá con el primero si la habitación cierra.
  static List<Point2D> traceChain(List<WallStep> steps) {
    final List<Point2D> vertices = <Point2D>[Point2D.origin];
    double heading = 0;
    Point2D cursor = Point2D.origin;

    for (final WallStep step in steps) {
      heading += step.turnDegrees;
      final double radians = heading * math.pi / 180;
      cursor = Point2D(
        cursor.x + step.lengthMeters * math.cos(radians),
        cursor.y + step.lengthMeters * math.sin(radians),
      );
      vertices.add(cursor);
    }

    return vertices;
  }

  /// Camino inverso a [traceChain]: de los vértices de un polígono a la
  /// cadena de paredes que lo recorre.
  ///
  /// Devuelve una pared por vértice; la última vuelve al punto de partida.
  /// La primera no gira, porque es la que marca el arranque del plano.
  static List<WallStep> chainFromVertices(List<Point2D> vertices) {
    if (vertices.length < 2) return const <WallStep>[];

    final List<WallStep> steps = <WallStep>[];
    double previousHeading = 0;
    for (int i = 0; i < vertices.length; i++) {
      final Point2D start = vertices[i];
      final Point2D end = vertices[(i + 1) % vertices.length];
      final double dx = end.x - start.x;
      final double dy = end.y - start.y;
      final double heading = math.atan2(dy, dx) * 180 / math.pi;

      steps.add(
        WallStep(
          lengthMeters: math.sqrt(dx * dx + dy * dy),
          turnDegrees: i == 0 ? 0 : normalizeDegrees(heading - previousHeading),
        ),
      );
      previousHeading = heading;
    }
    return steps;
  }

  /// Deja un ángulo en el rango [-180, 180), que es como se leen los giros.
  static double normalizeDegrees(double degrees) =>
      ((degrees + 180) % 360) - 180;

  /// Área del polígono por la fórmula del cordón de zapato, en m².
  static double polygonArea(List<Point2D> vertices) {
    if (vertices.length < 3) return 0;

    double sum = 0;
    for (int i = 0; i < vertices.length; i++) {
      final Point2D current = vertices[i];
      final Point2D next = vertices[(i + 1) % vertices.length];
      sum += current.x * next.y - next.x * current.y;
    }
    return sum.abs() / 2;
  }

  /// Distancia del punto [p] al segmento que va de [a] a [b].
  static double distanceToSegment(Point2D p, Point2D a, Point2D b) {
    final Point2D ab = b - a;
    final double lengthSquared = ab.x * ab.x + ab.y * ab.y;
    if (lengthSquared == 0) return p.distanceTo(a);

    final Point2D ap = p - a;
    final double t = ((ap.x * ab.x + ap.y * ab.y) / lengthSquared).clamp(
      0.0,
      1.0,
    );
    return p.distanceTo(a + ab * t);
  }

  static PlanBounds boundsOf(List<Point2D> vertices) {
    if (vertices.isEmpty) {
      return const PlanBounds(min: Point2D.origin, max: Point2D.origin);
    }

    double minX = vertices.first.x;
    double minY = vertices.first.y;
    double maxX = minX;
    double maxY = minY;
    for (final Point2D vertex in vertices) {
      minX = math.min(minX, vertex.x);
      minY = math.min(minY, vertex.y);
      maxX = math.max(maxX, vertex.x);
      maxY = math.max(maxY, vertex.y);
    }
    return PlanBounds(min: Point2D(minX, minY), max: Point2D(maxX, maxY));
  }

  /// Centro geométrico de los vértices, para saber hacia dónde queda «afuera».
  static Point2D centroidOf(List<Point2D> vertices) {
    if (vertices.isEmpty) return Point2D.origin;

    double x = 0;
    double y = 0;
    for (final Point2D vertex in vertices) {
      x += vertex.x;
      y += vertex.y;
    }
    return Point2D(x / vertices.length, y / vertices.length);
  }
}
