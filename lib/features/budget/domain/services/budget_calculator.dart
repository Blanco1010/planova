import '../../../materials/domain/entities/material_estimates.dart';
import '../entities/budget_item.dart';
import '../entities/budget_summary.dart';
import '../entities/material_kind.dart';

/// Pone precio a lo que calculó la obra y suma el presupuesto.
abstract final class BudgetCalculator {
  /// Cantidad de cada material según el tipo de unidad con que se compra.
  static double quantityOf(MaterialKind kind, MaterialEstimates estimates) {
    return switch (kind) {
      MaterialKind.block => estimates.masonry.blocks.toDouble(),
      MaterialKind.cement => estimates.masonry.cementBags.toDouble(),
      MaterialKind.sand => estimates.masonry.sandCubicMeters,
      MaterialKind.paint => estimates.paint.gallons,
      MaterialKind.adhesive => estimates.floor.adhesiveKilograms,
      MaterialKind.tile => estimates.floor.tiles.toDouble(),
    };
  }

  /// Las líneas de material que tienen cantidad; las de cero no se enseñan.
  static List<MaterialLine> materialLines({
    required MaterialEstimates estimates,
    required Map<MaterialKind, double> prices,
  }) {
    final List<MaterialLine> lines = <MaterialLine>[];
    for (final MaterialKind kind in MaterialKind.values) {
      final double quantity = quantityOf(kind, estimates);
      if (quantity <= 0) continue;
      lines.add(
        MaterialLine(
          kind: kind,
          quantity: quantity,
          unitPrice: prices[kind] ?? 0,
        ),
      );
    }
    return lines;
  }

  static BudgetSummary summarize({
    required List<MaterialLine> materialLines,
    required List<BudgetItem> items,
    required double floorAreaM2,
    double finishesTotal = 0,
  }) {
    double materials = 0;
    int priced = 0;
    for (final MaterialLine line in materialLines) {
      materials += line.subtotal;
      if (line.hasPrice) priced++;
    }

    double labor = 0;
    double other = 0;
    for (final BudgetItem item in items) {
      switch (item.category) {
        case BudgetCategory.material:
          materials += item.subtotal;
        case BudgetCategory.labor:
          labor += item.subtotal;
        case BudgetCategory.other:
          other += item.subtotal;
      }
    }

    return BudgetSummary(
      materialsTotal: materials,
      laborTotal: labor,
      otherTotal: other,
      finishesTotal: finishesTotal,
      floorAreaM2: floorAreaM2,
      pricedMaterials: priced,
      totalMaterials: materialLines.length,
    );
  }
}
