/// Medidas y rendimientos de la mampostería.
///
/// Los valores por defecto son los del bloque de 39 × 19 × 12 cm y un mortero
/// 1:4; cada obra los puede cambiar, que para eso están a la vista.
class MasonryParams {
  const MasonryParams({
    required this.blockLengthMeters,
    required this.blockHeightMeters,
    required this.jointMeters,
    required this.wallThicknessMeters,
    required this.wastePercent,
    required this.cementBagsPerCubicMeter,
    required this.sandCubicMetersPerCubicMeter,
  });

  static const MasonryParams defaults = MasonryParams(
    blockLengthMeters: 0.39,
    blockHeightMeters: 0.19,
    jointMeters: 0.015,
    wallThicknessMeters: 0.12,
    wastePercent: 5,
    cementBagsPerCubicMeter: 7.5,
    sandCubicMetersPerCubicMeter: 1.1,
  );

  final double blockLengthMeters;
  final double blockHeightMeters;

  /// Espesor de la junta de pega.
  final double jointMeters;

  /// Espesor del muro: es lo que da el volumen de mortero.
  final double wallThicknessMeters;

  final double wastePercent;

  /// Bultos de cemento que lleva un metro cúbico de mortero.
  final double cementBagsPerCubicMeter;

  /// Arena que lleva un metro cúbico de mortero.
  final double sandCubicMetersPerCubicMeter;
}

/// Rendimiento de la pintura.
class PaintParams {
  const PaintParams({
    required this.coats,
    required this.squareMetersPerLiter,
    required this.wastePercent,
    required this.includeCeiling,
  });

  static const PaintParams defaults = PaintParams(
    coats: 2,
    squareMetersPerLiter: 10,
    wastePercent: 5,
    includeCeiling: false,
  );

  /// Manos de pintura.
  final int coats;

  /// Metros cuadrados que cubre un litro en una mano.
  final double squareMetersPerLiter;

  final double wastePercent;

  /// Si se pinta también el cielo raso, se suma el área del piso.
  final bool includeCeiling;
}

/// Medidas de la baldosa y rendimiento del pegante.
class FloorParams {
  const FloorParams({
    required this.tileLengthMeters,
    required this.tileWidthMeters,
    required this.wastePercent,
    required this.adhesiveKilogramsPerSquareMeter,
  });

  static const FloorParams defaults = FloorParams(
    tileLengthMeters: 0.33,
    tileWidthMeters: 0.33,
    wastePercent: 10,
    adhesiveKilogramsPerSquareMeter: 5,
  );

  final double tileLengthMeters;
  final double tileWidthMeters;
  final double wastePercent;
  final double adhesiveKilogramsPerSquareMeter;
}

/// Todos los rendimientos con los que se calculan los materiales de un
/// proyecto. Se guardan por proyecto: cada obra trabaja con lo suyo.
class MaterialSettings {
  const MaterialSettings({
    required this.masonry,
    required this.paint,
    required this.floor,
  });

  static const MaterialSettings defaults = MaterialSettings(
    masonry: MasonryParams.defaults,
    paint: PaintParams.defaults,
    floor: FloorParams.defaults,
  );

  final MasonryParams masonry;
  final PaintParams paint;
  final FloorParams floor;

  MaterialSettings copyWith({
    MasonryParams? masonry,
    PaintParams? paint,
    FloorParams? floor,
  }) {
    return MaterialSettings(
      masonry: masonry ?? this.masonry,
      paint: paint ?? this.paint,
      floor: floor ?? this.floor,
    );
  }
}
