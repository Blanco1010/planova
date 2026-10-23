import 'package:drift/drift.dart';

import '../../../projects/data/tables/projects_table.dart';
import '../../../rooms/data/tables/room_walls_table.dart';
import '../../../rooms/data/tables/rooms_table.dart';
import '../../domain/entities/budget_item.dart';
import '../../domain/entities/material_kind.dart';

/// Precio unitario de cada material calculado, por proyecto.
@DataClassName('MaterialPriceRow')
class MaterialPrices extends Table {
  IntColumn get projectId =>
      integer().references(Projects, #id, onDelete: KeyAction.cascade)();

  TextColumn get kind => textEnum<MaterialKind>()();

  RealColumn get unitPrice => real()();

  @override
  Set<Column<Object>> get primaryKey => {projectId, kind};
}

/// Partidas escritas a mano: acero, teja, mano de obra, transporte…
@DataClassName('BudgetItemRow')
class BudgetItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get projectId =>
      integer().references(Projects, #id, onDelete: KeyAction.cascade)();

  /// Habitación a la que se carga la partida, si es de una sola.
  IntColumn get roomId => integer().nullable().references(
    Rooms,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get category => textEnum<BudgetCategory>()();

  TextColumn get description => text().withLength(min: 1, max: 160)();

  TextColumn get unit => text().withLength(min: 1, max: 24)();

  RealColumn get quantity => real()();

  RealColumn get unitPrice => real()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Acabados: qué se le hace a unas superficies y a cuánto el metro.
@DataClassName('FinishRow')
class Finishes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get projectId =>
      integer().references(Projects, #id, onDelete: KeyAction.cascade)();

  TextColumn get description => text().withLength(min: 1, max: 160)();

  /// Precio por metro cuadrado.
  RealColumn get unitPrice => real()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Las superficies que entran en un acabado.
///
/// Se guarda a qué pared apunta, no cuántos metros tiene: así el día que se
/// corrija el plano, el acabado se recalcula solo.
@DataClassName('FinishSurfaceRow')
class FinishSurfaces extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get finishId =>
      integer().references(Finishes, #id, onDelete: KeyAction.cascade)();

  IntColumn get roomId =>
      integer().references(Rooms, #id, onDelete: KeyAction.cascade)();

  /// `null` cuando la superficie es el piso de esa habitación.
  IntColumn get wallId => integer().nullable().references(
    RoomWalls,
    #id,
    onDelete: KeyAction.cascade,
  )();
}
