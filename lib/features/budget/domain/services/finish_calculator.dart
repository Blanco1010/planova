import '../../../rooms/domain/entities/room.dart';
import '../../../rooms/domain/entities/room_plan.dart';
import '../../../rooms/domain/entities/room_wall.dart';
import '../entities/finish.dart';

/// Lo que mide un acabado y lo que cuesta.
class FinishEstimate {
  const FinishEstimate({
    required this.finish,
    required this.areaM2,
    required this.walls,
    required this.floors,
  });

  final Finish finish;

  /// Metros cuadrados de todas sus superficies, ya descontados los vanos.
  final double areaM2;

  /// Cuántas paredes y cuántos pisos entran.
  final int walls;
  final int floors;

  double get total => areaM2 * finish.unitPrice;
}

/// Mide las superficies que lleva cada acabado.
abstract final class FinishCalculator {
  /// Lo que mide una pared, descontando sus puertas y ventanas.
  static double wallArea(Room room, RoomWall wall) {
    final double gross = wall.lengthMeters * room.wallHeightMeters;
    final double net = gross - wall.openingsAreaM2;
    return net < 0 ? 0 : net;
  }

  /// Lo que mide una superficie suelta; cero si ya no existe.
  static double surfaceArea(FinishSurface surface, Iterable<Room> rooms) {
    final Room? room = _roomOf(surface.roomId, rooms);
    if (room == null) return 0;

    if (surface.isFloor) return RoomPlan.of(room).floorAreaM2;

    for (final RoomWall wall in room.walls) {
      if (wall.id == surface.wallId) return wallArea(room, wall);
    }
    return 0;
  }

  static FinishEstimate estimate(Finish finish, Iterable<Room> rooms) {
    double area = 0;
    int walls = 0;
    int floors = 0;

    for (final FinishSurface surface in finish.surfaces) {
      area += surfaceArea(surface, rooms);
      if (surface.isFloor) {
        floors++;
      } else {
        walls++;
      }
    }

    return FinishEstimate(
      finish: finish,
      areaM2: area,
      walls: walls,
      floors: floors,
    );
  }

  /// Los mismos acabados vistos desde unas habitaciones.
  ///
  /// A cada uno le quedan solo las superficies que están ahí, y el que no
  /// toca ninguna se cae de la lista. Es lo que hace falta para mirar el
  /// presupuesto de una sola habitación: una pintura repartida entre varias
  /// cuenta solo por la parte de esta.
  static List<Finish> within(
    Iterable<Finish> finishes,
    Iterable<Room> rooms,
  ) {
    final Set<int> ids = <int>{for (final Room room in rooms) room.id};
    final List<Finish> scoped = <Finish>[];

    for (final Finish finish in finishes) {
      final List<FinishSurface> surfaces = finish.surfaces
          .where((FinishSurface surface) => ids.contains(surface.roomId))
          .toList(growable: false);
      if (surfaces.isNotEmpty) scoped.add(finish.withSurfaces(surfaces));
    }

    return scoped;
  }

  static double totalOf(Iterable<Finish> finishes, Iterable<Room> rooms) {
    double total = 0;
    for (final Finish finish in finishes) {
      total += estimate(finish, rooms).total;
    }
    return total;
  }

  static Room? _roomOf(int id, Iterable<Room> rooms) {
    for (final Room room in rooms) {
      if (room.id == id) return room;
    }
    return null;
  }
}
