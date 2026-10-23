import 'package:flutter_test/flutter_test.dart';
import 'package:planova/features/budget/domain/entities/budget_item.dart';
import 'package:planova/features/budget/domain/entities/budget_summary.dart';
import 'package:planova/features/budget/domain/entities/material_kind.dart';
import 'package:planova/features/budget/domain/services/budget_calculator.dart';
import 'package:planova/features/materials/domain/entities/material_estimates.dart';
import 'package:planova/features/materials/domain/entities/material_settings.dart';
import 'package:planova/features/materials/domain/services/material_calculator.dart';

/// Una sala de 4 × 3 con 2,40 m de alto.
final MaterialEstimates _estimates = MaterialCalculator.estimate(
  surfaces: const SurfaceTotals(netWallAreaM2: 33.6, floorAreaM2: 12),
  settings: MaterialSettings.defaults,
);

BudgetItem _item({
  required BudgetCategory category,
  required double quantity,
  required double unitPrice,
}) {
  return BudgetItem(
    id: 1,
    projectId: 1,
    category: category,
    description: 'partida',
    unit: 'unid',
    quantity: quantity,
    unitPrice: unitPrice,
  );
}

void main() {
  group('materialLines', () {
    test('una línea por material con cantidad', () {
      final List<MaterialLine> lines = BudgetCalculator.materialLines(
        estimates: _estimates,
        prices: const <MaterialKind, double>{},
      );

      expect(lines.length, MaterialKind.values.length);
      expect(lines.every((MaterialLine line) => line.quantity > 0), isTrue);
      expect(lines.every((MaterialLine line) => line.hasPrice), isFalse);
    });

    test('sin obra medida no hay líneas', () {
      final List<MaterialLine> lines = BudgetCalculator.materialLines(
        estimates: MaterialCalculator.estimate(
          surfaces: SurfaceTotals.empty,
          settings: MaterialSettings.defaults,
        ),
        prices: const <MaterialKind, double>{},
      );

      expect(lines, isEmpty);
    });

    test('el subtotal es la cantidad por el precio', () {
      final List<MaterialLine> lines = BudgetCalculator.materialLines(
        estimates: _estimates,
        prices: const <MaterialKind, double>{MaterialKind.block: 1800},
      );
      final MaterialLine blocks = lines.firstWhere(
        (MaterialLine line) => line.kind == MaterialKind.block,
      );

      // 425 bloques × $1.800.
      expect(blocks.quantity, 425);
      expect(blocks.subtotal, closeTo(765000, 1e-6));
    });
  });

  group('summarize', () {
    test('separa materiales, mano de obra y otros', () {
      final List<MaterialLine> lines = BudgetCalculator.materialLines(
        estimates: _estimates,
        prices: const <MaterialKind, double>{
          MaterialKind.block: 1800,
          MaterialKind.cement: 32000,
          MaterialKind.tile: 2500,
        },
      );

      final BudgetSummary summary = BudgetCalculator.summarize(
        materialLines: lines,
        items: <BudgetItem>[
          _item(category: BudgetCategory.labor, quantity: 1, unitPrice: 500000),
          _item(category: BudgetCategory.other, quantity: 2, unitPrice: 80000),
        ],
        floorAreaM2: 12,
      );

      // 425 × 1.800 + 4 × 32.000 + 122 × 2.500.
      expect(summary.materialsTotal, closeTo(1198000, 1e-6));
      expect(summary.laborTotal, closeTo(500000, 1e-6));
      expect(summary.otherTotal, closeTo(160000, 1e-6));
      expect(summary.total, closeTo(1858000, 1e-6));
      expect(summary.costPerSquareMeter, closeTo(1858000 / 12, 1e-6));
    });

    test('avisa mientras falten precios', () {
      final List<MaterialLine> lines = BudgetCalculator.materialLines(
        estimates: _estimates,
        prices: const <MaterialKind, double>{MaterialKind.block: 1800},
      );
      final BudgetSummary summary = BudgetCalculator.summarize(
        materialLines: lines,
        items: const <BudgetItem>[],
        floorAreaM2: 12,
      );

      expect(summary.pricedMaterials, 1);
      expect(summary.totalMaterials, 6);
      expect(summary.isComplete, isFalse);
    });

    test('una partida de material suma con los calculados', () {
      final BudgetSummary summary = BudgetCalculator.summarize(
        materialLines: const <MaterialLine>[],
        items: <BudgetItem>[
          _item(
            category: BudgetCategory.material,
            quantity: 10,
            unitPrice: 4500,
          ),
        ],
        floorAreaM2: 0,
      );

      expect(summary.materialsTotal, closeTo(45000, 1e-6));
      expect(summary.costPerSquareMeter, isNull);
      expect(summary.isComplete, isTrue);
    });
  });
}
