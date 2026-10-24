import '../../../../l10n/app_l10n.dart';

/// Los materiales que salen solos del plano y a los que basta ponerles
/// precio unitario.
enum MaterialKind { block, cement, sand, paint, adhesive, tile }

/// De dónde sale la cantidad de un material: de los muros o del piso.
///
/// Es la pregunta que se hace uno al ver 1.121 bloques en una casa de 32 m²:
/// esa cifra no viene del suelo, viene de los muros.
enum MaterialSurface { walls, floor }

extension MaterialSurfaceDisplay on MaterialSurface {
  String label(AppL10n t) => switch (this) {
    MaterialSurface.walls => t.surfaceWalls,
    MaterialSurface.floor => t.surfaceFloor,
  };
}

/// Cómo se nombra, en qué se compra y de qué superficie sale cada material.
extension MaterialKindDisplay on MaterialKind {
  MaterialSurface get surface => switch (this) {
    MaterialKind.block ||
    MaterialKind.cement ||
    MaterialKind.sand ||
    MaterialKind.paint => MaterialSurface.walls,
    MaterialKind.adhesive || MaterialKind.tile => MaterialSurface.floor,
  };

  String label(AppL10n t) => switch (this) {
    MaterialKind.block => t.materialBlock,
    MaterialKind.cement => t.materialCement,
    MaterialKind.sand => t.materialSand,
    MaterialKind.paint => t.materialPaint,
    MaterialKind.adhesive => t.materialAdhesive,
    MaterialKind.tile => t.materialTile,
  };

  String unit(AppL10n t) => switch (this) {
    MaterialKind.block => t.unitShort,
    MaterialKind.cement => t.unitBag,
    MaterialKind.sand => 'm³',
    MaterialKind.paint => t.unitGallon,
    MaterialKind.adhesive => t.unitKilogram,
    MaterialKind.tile => t.unitShort,
  };
}
