/// En qué capítulo del presupuesto entra una partida.
enum BudgetCategory { material, labor, other }

/// Cómo se nombra cada capítulo.
extension BudgetCategoryDisplay on BudgetCategory {
  String get label => switch (this) {
    BudgetCategory.material => 'Material',
    BudgetCategory.labor => 'Mano de obra',
    BudgetCategory.other => 'Otros',
  };
}

/// Una partida que se escribe a mano: acero, teja, transporte, el maestro…
///
/// Lo que sale del plano (bloques, pintura, baldosa) no vive aquí: se calcula
/// y solo lleva precio unitario.
class BudgetItem {
  const BudgetItem({
    required this.id,
    required this.projectId,
    required this.category,
    required this.description,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    this.roomId,
  });

  final int id;
  final int projectId;

  /// Habitación a la que pertenece, o `null` si es de toda la obra.
  final int? roomId;

  final BudgetCategory category;
  final String description;

  /// Unidad tal como la escribe el usuario: kg, m², viaje, día…
  final String unit;

  final double quantity;
  final double unitPrice;

  double get subtotal => quantity * unitPrice;
}

/// Datos de una partida que escribe el usuario.
class BudgetItemDraft {
  const BudgetItemDraft({
    required this.category,
    required this.description,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    this.roomId,
  });

  final BudgetCategory category;
  final String description;
  final String unit;
  final double quantity;
  final double unitPrice;
  final int? roomId;
}
