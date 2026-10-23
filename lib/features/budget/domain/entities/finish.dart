/// Una superficie concreta de la obra: una pared o el piso de una pieza.
class FinishSurface {
  const FinishSurface({required this.roomId, this.wallId});

  final int roomId;

  /// `null` cuando la superficie es el piso de esa habitación.
  final int? wallId;

  bool get isFloor => wallId == null;

  @override
  bool operator ==(Object other) =>
      other is FinishSurface &&
      other.roomId == roomId &&
      other.wallId == wallId;

  @override
  int get hashCode => Object.hash(roomId, wallId);
}

/// Un acabado: qué se le hace a qué superficies y a cuánto el metro.
///
/// Guarda a qué paredes apunta, no cuántos metros tiene. Si mañana se
/// corrige una pared en el plano, los metros y el precio se actualizan
/// solos.
class Finish {
  const Finish({
    required this.id,
    required this.projectId,
    required this.description,
    required this.unitPrice,
    required this.surfaces,
  });

  final int id;
  final int projectId;

  /// Pintura, estuco, enchape… lo que se escriba.
  final String description;

  /// Precio por metro cuadrado.
  final double unitPrice;

  final List<FinishSurface> surfaces;

  /// El mismo acabado con otras superficies.
  ///
  /// Sirve para mirarlo por partes, por ejemplo la pintura de una sola
  /// habitación cuando se reparte entre varias.
  Finish withSurfaces(List<FinishSurface> surfaces) => Finish(
    id: id,
    projectId: projectId,
    description: description,
    unitPrice: unitPrice,
    surfaces: surfaces,
  );
}

/// Datos de un acabado que escribe el usuario.
class FinishDraft {
  const FinishDraft({
    required this.description,
    required this.unitPrice,
    required this.surfaces,
  });

  final String description;
  final double unitPrice;
  final List<FinishSurface> surfaces;
}
