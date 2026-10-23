/// Los materiales que salen solos del plano y a los que basta ponerles
/// precio unitario.
enum MaterialKind { block, cement, sand, paint, adhesive, tile }

/// Cómo se nombra y en qué se compra cada material.
extension MaterialKindDisplay on MaterialKind {
  String get label => switch (this) {
    MaterialKind.block => 'Bloques',
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
