import 'package:drift/drift.dart';

import '../../domain/entities/opening.dart';
import 'room_walls_table.dart';

/// Puertas y ventanas abiertas en una pared.
@DataClassName('RoomOpeningRow')
class RoomOpenings extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get wallId =>
      integer().references(RoomWalls, #id, onDelete: KeyAction.cascade)();

  TextColumn get kind => textEnum<OpeningKind>()();

  RealColumn get widthMeters => real()();

  RealColumn get heightMeters => real()();

  /// Distancia desde el inicio de la pared hasta el borde del vano.
  RealColumn get distanceFromStartMeters =>
      real().withDefault(const Constant(0))();
}
