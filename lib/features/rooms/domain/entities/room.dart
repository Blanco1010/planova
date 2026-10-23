import 'room_wall.dart';

/// Una habitación de un proyecto, con su recorrido de paredes.
class Room {
  const Room({
    required this.id,
    required this.projectId,
    required this.name,
    required this.wallHeightMeters,
    required this.walls,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int projectId;
  final String name;

  /// Altura libre de las paredes, igual para toda la habitación.
  final double wallHeightMeters;

  /// Paredes en orden de recorrido.
  final List<RoomWall> walls;

  final DateTime createdAt;
  final DateTime updatedAt;
}
