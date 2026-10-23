import 'package:drift/drift.dart';

import '../../../projects/data/tables/projects_table.dart';

/// Habitaciones de un proyecto. Al borrar el proyecto se van con él.
@DataClassName('RoomRow')
class Rooms extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get projectId =>
      integer().references(Projects, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text().withLength(min: 1, max: 120)();

  /// Altura libre de las paredes, en metros.
  RealColumn get wallHeightMeters => real().withDefault(const Constant(2.4))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
