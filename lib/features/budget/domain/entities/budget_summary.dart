import 'material_kind.dart';

/// Una línea de material calculado: cantidad por precio.
class MaterialLine {
  const MaterialLine({
    required this.kind,
    required this.quantity,
    required this.unitPrice,
  });

  final MaterialKind kind;
  final double quantity;

  /// Cero mientras no se le ponga precio.
  final double unitPrice;

  double get subtotal => quantity * unitPrice;

  bool get hasPrice => unitPrice > 0;
}

/// Lo que suma el presupuesto, por capítulos.
class BudgetSummary {
  const BudgetSummary({
    required this.materialsTotal,
    required this.laborTotal,
    required this.otherTotal,
    required this.floorAreaM2,
    required this.pricedMaterials,
    required this.totalMaterials,
  });

  final double materialsTotal;
  final double laborTotal;
  final double otherTotal;
  final double floorAreaM2;

  /// Cuántos materiales calculados ya tienen precio, y cuántos hay.
  /// Sirve para avisar de que el total todavía está incompleto.
  final int pricedMaterials;
  final int totalMaterials;

  double get total => materialsTotal + laborTotal + otherTotal;

  /// Costo por metro cuadrado de piso; `null` si no hay área medida.
  double? get costPerSquareMeter =>
      floorAreaM2 > 0 ? total / floorAreaM2 : null;

  bool get isComplete => pricedMaterials == totalMaterials;
}
