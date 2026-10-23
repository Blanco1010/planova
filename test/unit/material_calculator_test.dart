import 'package:flutter_test/flutter_test.dart';
import 'package:planova/features/materials/domain/entities/material_estimates.dart';
import 'package:planova/features/materials/domain/entities/material_settings.dart';
import 'package:planova/features/materials/domain/services/material_calculator.dart';

void main() {
  group('mampostería', () {
    test('el bloque de 39 × 19 con junta de 1,5 cm da 12 por m²', () {
      final MasonryEstimate estimate = MaterialCalculator.masonry(
        wallAreaM2: 10,
        params: MasonryParams.defaults,
      );

      // 1 / (0,405 × 0,205) = 12,04 bloques por m².
      expect(estimate.blocksPerSquareMeter, closeTo(12.044, 0.001));
      // 10 m² × 12,04 × 1,05 de desperdicio, redondeando hacia arriba.
      expect(estimate.blocks, 127);
    });

    test('el mortero sale de la junta por el espesor del muro', () {
      final MasonryEstimate estimate = MaterialCalculator.masonry(
        wallAreaM2: 10,
        params: MasonryParams.defaults,
      );

      expect(estimate.mortarCubicMeters, closeTo(0.1354, 0.0005));
      expect(estimate.cementBags, 2);
      expect(estimate.sandCubicMeters, closeTo(0.149, 0.001));
    });

    test('sin muro no hay materiales', () {
      final MasonryEstimate estimate = MaterialCalculator.masonry(
        wallAreaM2: 0,
        params: MasonryParams.defaults,
      );

      expect(estimate.blocks, 0);
      expect(estimate.cementBags, 0);
    });

    test('una junta más gruesa baja los bloques y sube el mortero', () {
      final MasonryEstimate thin = MaterialCalculator.masonry(
        wallAreaM2: 20,
        params: MasonryParams.defaults,
      );
      final MasonryEstimate thick = MaterialCalculator.masonry(
        wallAreaM2: 20,
        params: const MasonryParams(
          blockLengthMeters: 0.39,
          blockHeightMeters: 0.19,
          jointMeters: 0.03,
          wallThicknessMeters: 0.12,
          wastePercent: 5,
          cementBagsPerCubicMeter: 7.5,
          sandCubicMetersPerCubicMeter: 1.1,
        ),
      );

      expect(thick.blocks, lessThan(thin.blocks));
      expect(thick.mortarCubicMeters, greaterThan(thin.mortarCubicMeters));
    });
  });

  group('pintura', () {
    test('dos manos sobre 33,60 m² con rendimiento de 10 m²/L', () {
      final PaintEstimate estimate = MaterialCalculator.paint(
        surfaces: const SurfaceTotals(netWallAreaM2: 33.6, floorAreaM2: 12),
        params: PaintParams.defaults,
      );

      // 33,6 × 2 / 10 × 1,05.
      expect(estimate.liters, closeTo(7.056, 0.001));
      expect(estimate.gallons, closeTo(7.056 / 3.785, 0.001));
      expect(estimate.areaM2, closeTo(33.6, 1e-9));
    });

    test('con el cielo raso incluido se suma el área del piso', () {
      final PaintEstimate estimate = MaterialCalculator.paint(
        surfaces: const SurfaceTotals(netWallAreaM2: 33.6, floorAreaM2: 12),
        params: const PaintParams(
          coats: 2,
          squareMetersPerLiter: 10,
          wastePercent: 5,
          includeCeiling: true,
        ),
      );

      expect(estimate.areaM2, closeTo(45.6, 1e-9));
      expect(estimate.liters, closeTo(45.6 * 2 / 10 * 1.05, 0.001));
    });
  });

  group('piso', () {
    test('baldosa de 33 × 33 sobre 12 m² con 10 % de desperdicio', () {
      final FloorEstimate estimate = MaterialCalculator.floor(
        floorAreaM2: 12,
        params: FloorParams.defaults,
      );

      expect(estimate.tilesPerSquareMeter, closeTo(9.183, 0.001));
      // 12 × 9,183 × 1,10 = 121,2 → 122 piezas.
      expect(estimate.tiles, 122);
      expect(estimate.adhesiveKilograms, closeTo(66, 0.001));
    });
  });

  group('estimate', () {
    test('junta las tres cuentas de una habitación', () {
      final MaterialEstimates estimates = MaterialCalculator.estimate(
        surfaces: const SurfaceTotals(netWallAreaM2: 33.6, floorAreaM2: 12),
        settings: MaterialSettings.defaults,
      );

      expect(estimates.masonry.blocks, greaterThan(0));
      expect(estimates.paint.liters, greaterThan(0));
      expect(estimates.floor.tiles, 122);
    });
  });
}
