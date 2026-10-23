import 'package:drift/drift.dart';

import '../../../projects/data/tables/projects_table.dart';

/// Rendimientos con los que se calculan los materiales de un proyecto.
/// Una fila por proyecto; si no existe, se usan los valores por defecto.
@DataClassName('MaterialSettingsRow')
class ProjectMaterialSettings extends Table {
  IntColumn get projectId =>
      integer().references(Projects, #id, onDelete: KeyAction.cascade)();

  RealColumn get blockLengthMeters => real().withDefault(const Constant(0.39))();

  RealColumn get blockHeightMeters => real().withDefault(const Constant(0.19))();

  RealColumn get jointMeters => real().withDefault(const Constant(0.015))();

  RealColumn get wallThicknessMeters =>
      real().withDefault(const Constant(0.12))();

  RealColumn get masonryWastePercent => real().withDefault(const Constant(5))();

  RealColumn get cementBagsPerCubicMeter =>
      real().withDefault(const Constant(7.5))();

  RealColumn get sandCubicMetersPerCubicMeter =>
      real().withDefault(const Constant(1.1))();

  IntColumn get paintCoats => integer().withDefault(const Constant(2))();

  RealColumn get squareMetersPerLiter =>
      real().withDefault(const Constant(10))();

  RealColumn get paintWastePercent => real().withDefault(const Constant(5))();

  BoolColumn get includeCeiling =>
      boolean().withDefault(const Constant(false))();

  RealColumn get tileLengthMeters => real().withDefault(const Constant(0.33))();

  RealColumn get tileWidthMeters => real().withDefault(const Constant(0.33))();

  RealColumn get floorWastePercent => real().withDefault(const Constant(10))();

  RealColumn get adhesiveKilogramsPerSquareMeter =>
      real().withDefault(const Constant(5))();

  @override
  Set<Column<Object>> get primaryKey => {projectId};
}
