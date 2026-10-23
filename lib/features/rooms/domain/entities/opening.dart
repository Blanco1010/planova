/// Tipo de vano abierto en una pared.
enum OpeningKind { door, window }

/// Un vano (puerta o ventana) dentro de una pared.
class Opening {
  const Opening({
    required this.id,
    required this.kind,
    required this.widthMeters,
    required this.heightMeters,
    required this.distanceFromStartMeters,
  });

  final int id;
  final OpeningKind kind;
  final double widthMeters;
  final double heightMeters;

  /// Distancia desde el inicio de la pared hasta el borde del vano.
  final double distanceFromStartMeters;

  /// Superficie del vano, en m². Es la que se descuenta al pintar o revocar.
  double get areaM2 => widthMeters * heightMeters;
}
