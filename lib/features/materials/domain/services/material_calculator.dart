import 'dart:math' as math;

import '../entities/material_estimates.dart';
import '../entities/material_settings.dart';

/// Convierte superficies en cantidades de material.
///
/// Todo son funciones puras: las mismas superficies y los mismos
/// rendimientos dan siempre el mismo resultado, y se pueden comprobar.
abstract final class MaterialCalculator {
  static MaterialEstimates estimate({
    required SurfaceTotals surfaces,
    required MaterialSettings settings,
  }) {
    return MaterialEstimates(
      surfaces: surfaces,
      masonry: masonry(
        wallAreaM2: surfaces.netWallAreaM2,
        params: settings.masonry,
      ),
      paint: paint(surfaces: surfaces, params: settings.paint),
      floor: floor(floorAreaM2: surfaces.floorAreaM2, params: settings.floor),
    );
  }

  /// Bloques y mortero de pega.
  ///
  /// Cada bloque ocupa, con su junta, un rectángulo de (largo + junta) por
  /// (alto + junta). Lo que no es bloque en esa cuadrícula es mortero, y
  /// multiplicado por el espesor del muro da el volumen de pega.
  static MasonryEstimate masonry({
    required double wallAreaM2,
    required MasonryParams params,
  }) {
    final double cellLength = params.blockLengthMeters + params.jointMeters;
    final double cellHeight = params.blockHeightMeters + params.jointMeters;
    final double cellArea = cellLength * cellHeight;
    if (wallAreaM2 <= 0 || cellArea <= 0) {
      return const MasonryEstimate(
        wallAreaM2: 0,
        blocks: 0,
        blocksPerSquareMeter: 0,
        mortarCubicMeters: 0,
        cementBags: 0,
        sandCubicMeters: 0,
      );
    }

    final double waste = _wasteFactor(params.wastePercent);
    final double blocksPerSquareMeter = 1 / cellArea;
    final double blockArea =
        params.blockLengthMeters * params.blockHeightMeters;
    final double mortarPerSquareMeter =
        (1 - blockArea / cellArea) * params.wallThicknessMeters;
    final double mortar = wallAreaM2 * mortarPerSquareMeter * waste;

    return MasonryEstimate(
      wallAreaM2: wallAreaM2,
      blocks: (wallAreaM2 * blocksPerSquareMeter * waste).ceil(),
      blocksPerSquareMeter: blocksPerSquareMeter,
      mortarCubicMeters: mortar,
      cementBags: (mortar * params.cementBagsPerCubicMeter).ceil(),
      sandCubicMeters: mortar * params.sandCubicMetersPerCubicMeter,
    );
  }

  /// Pintura: el área por las manos, dividida entre el rendimiento.
  static PaintEstimate paint({
    required SurfaceTotals surfaces,
    required PaintParams params,
  }) {
    final double area =
        surfaces.netWallAreaM2 +
        (params.includeCeiling ? surfaces.floorAreaM2 : 0);
    if (area <= 0 || params.squareMetersPerLiter <= 0 || params.coats <= 0) {
      return PaintEstimate(areaM2: math.max(area, 0), liters: 0, gallons: 0);
    }

    final double liters =
        area *
        params.coats /
        params.squareMetersPerLiter *
        _wasteFactor(params.wastePercent);

    return PaintEstimate(
      areaM2: area,
      liters: liters,
      gallons: liters / PaintEstimate.litersPerGallon,
    );
  }

  /// Baldosa y pegante.
  static FloorEstimate floor({
    required double floorAreaM2,
    required FloorParams params,
  }) {
    final double tileArea = params.tileLengthMeters * params.tileWidthMeters;
    if (floorAreaM2 <= 0 || tileArea <= 0) {
      return const FloorEstimate(
        areaM2: 0,
        tiles: 0,
        tilesPerSquareMeter: 0,
        adhesiveKilograms: 0,
      );
    }

    final double waste = _wasteFactor(params.wastePercent);
    final double tilesPerSquareMeter = 1 / tileArea;

    return FloorEstimate(
      areaM2: floorAreaM2,
      tiles: (floorAreaM2 * tilesPerSquareMeter * waste).ceil(),
      tilesPerSquareMeter: tilesPerSquareMeter,
      adhesiveKilograms:
          floorAreaM2 * params.adhesiveKilogramsPerSquareMeter * waste,
    );
  }

  static double _wasteFactor(double percent) =>
      1 + (percent.isFinite && percent > 0 ? percent / 100 : 0);
}
