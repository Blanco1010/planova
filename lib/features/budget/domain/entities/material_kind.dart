/// Los materiales que salen solos del plano y a los que basta ponerles
/// precio unitario.
enum MaterialKind { block, cement, sand, paint, adhesive, tile }

/// De dónde sale la cantidad de un material: de los muros o del piso.
///
/// Es la pregunta que se hace uno al ver 1.121 bloques en una casa de 32 m²:
/// esa cifra no viene del suelo, viene de los muros.
enum MaterialSurface { walls, floor }

extension MaterialSurfaceDisplay on MaterialSurface {
  String get label => switch (this) {
    MaterialSurface.walls => 'Paredes',
    MaterialSurface.floor => 'Piso',
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

  String get label => switch (this) {
    MaterialKind.block => 'Bloques o ladrillos',
    MaterialKind.cement => 'Cemento',
    MaterialKind.sand => 'Arena',
    MaterialKind.paint => 'Pintura',
    MaterialKind.adhesive => 'Pegante',
    MaterialKind.tile => 'Baldosas',
  };

  String get unit => switch (this) {
    MaterialKind.block => 'unid',
    MaterialKind.cement => 'bulto',
    MaterialKind.sand => 'm³',
    MaterialKind.paint => 'gal',
    MaterialKind.adhesive => 'kg',
    MaterialKind.tile => 'unid',
  };
}
