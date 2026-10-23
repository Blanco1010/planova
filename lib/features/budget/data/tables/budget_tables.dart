import 'package:drift/drift.dart';

import '../../../projects/data/tables/projects_table.dart';
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
