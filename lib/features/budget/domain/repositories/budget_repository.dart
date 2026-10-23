import '../entities/budget_item.dart';
import '../entities/material_kind.dart';

/// Precios unitarios y partidas escritas a mano, por proyecto.
abstract interface class BudgetRepository {
  /// Precio de cada material calculado; los que no estén, van sin precio.
  Stream<Map<MaterialKind, double>> watchPrices(int projectId);

  Future<void> savePrice(int projectId, MaterialKind kind, double unitPrice);

  /// Partidas del proyecto, de la más vieja a la más nueva.
  Stream<List<BudgetItem>> watchItems(int projectId);

  Future<int> addItem(int projectId, BudgetItemDraft draft);

  Future<void> updateItem(int itemId, BudgetItemDraft draft);

  Future<void> deleteItem(int itemId);
}
