import 'package:drift/drift.dart';

import 'rooms_table.dart';

/// Paredes de una habitación, en orden de recorrido.
@DataClassName('RoomWallRow')
class RoomWalls extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get roomId =>
      integer().references(Rooms, #id, onDelete: KeyAction.cascade)();

  /// Orden dentro del recorrido, empezando en 0.
  IntColumn get position => integer()();

  RealColumn get lengthMeters => real()();

  /// Giro respecto a la pared anterior, en grados. La primera pared no gira.
  RealColumn get turnDegrees => real().withDefault(const Constant(90))();
}
