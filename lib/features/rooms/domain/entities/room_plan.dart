import '../../../../core/geometry/plan_geometry.dart';
import '../../../../core/geometry/point2d.dart';
import 'room.dart';
import 'room_wall.dart';

/// El plano de una habitación: lo que se dibuja y lo que se mide.
///
/// Se calcula a partir de las paredes, nunca se guarda: así las medidas y el
/// dibujo no pueden quedar desfasados entre sí.
class RoomPlan {
  const RoomPlan._({
    required this.vertices,
    required this.floorAreaM2,
    required this.perimeterMeters,
    required this.closureGapMeters,
    required this.grossWallAreaM2,
    required this.openingsAreaM2,
  });

  factory RoomPlan.of(Room room) {
    final List<WallStep> steps = <WallStep>[];
    for (int i = 0; i < room.walls.length; i++) {
      final RoomWall wall = room.walls[i];
      steps.add(
        WallStep(
          lengthMeters: wall.lengthMeters,
          // La primera pared marca el punto de partida: siempre va horizontal,
          // así el plano no gira al tocar su giro.
          turnDegrees: i == 0 ? 0 : wall.turnDegrees,
        ),
      );
    }
    final List<Point2D> traced = PlanGeometry.traceChain(steps);

    // El trazado devuelve un punto más que paredes: el de cierre.
    final List<Point2D> vertices = traced.length > 1
        ? traced.sublist(0, traced.length - 1)
        : traced;
    final double gap = traced.length > 1
        ? traced.last.distanceTo(traced.first)
        : 0;

    double perimeter = 0;
    double grossWallArea = 0;
    double openingsArea = 0;
    for (final RoomWall wall in room.walls) {
      perimeter += wall.lengthMeters;
      grossWallArea += wall.lengthMeters * room.wallHeightMeters;
      openingsArea += wall.openingsAreaM2;
    }

    return RoomPlan._(
      vertices: vertices,
      floorAreaM2: PlanGeometry.polygonArea(vertices),
      perimeterMeters: perimeter,
      closureGapMeters: gap,
      grossWallAreaM2: grossWallArea,
      openingsAreaM2: openingsArea,
    );
  }

  /// Hasta dónde se acepta que el recorrido no vuelva al punto de partida.
  static const double closureToleranceMeters = 0.02;

  /// Vértices del polígono, uno por pared.
  final List<Point2D> vertices;

  /// Área del piso, en m².
  final double floorAreaM2;

  /// Suma de las longitudes de las paredes, en metros.
  final double perimeterMeters;

  /// Cuánto le falta al recorrido para volver al punto de partida.
  final double closureGapMeters;

  /// Superficie de paredes sin descontar vanos, en m².
  final double grossWallAreaM2;

  /// Superficie de puertas y ventanas, en m².
  final double openingsAreaM2;

  /// Superficie de paredes descontando puertas y ventanas, en m².
  /// Es la que sirve para pintura, revoque o enchape.
  double get netWallAreaM2 {
    final double net = grossWallAreaM2 - openingsAreaM2;
    return net < 0 ? 0 : net;
  }

  bool get isClosed => closureGapMeters <= closureToleranceMeters;

  /// Vértices listos para dibujar el contorno cerrado.
  List<Point2D> get outline => vertices.isEmpty
      ? const <Point2D>[]
      : <Point2D>[...vertices, vertices.first];

  /// Extremos de la pared en la posición [index], en coordenadas del plano.
  (Point2D, Point2D) segmentAt(int index) {
    final Point2D start = vertices[index];
    final Point2D end = vertices[(index + 1) % vertices.length];
    return (start, end);
  }
}
