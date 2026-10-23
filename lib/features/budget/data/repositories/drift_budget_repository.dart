import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/budget_item.dart';
import '../../domain/entities/material_kind.dart';
import '../../domain/repositories/budget_repository.dart';

/// Implementación de [BudgetRepository] sobre SQLite con Drift.
class DriftBudgetRepository implements BudgetRepository {
  const DriftBudgetRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<Map<MaterialKind, double>> watchPrices(int projectId) {
    return (_db.select(
      _db.materialPrices,
    )..where((t) => t.projectId.equals(projectId))).watch().map(
      (List<MaterialPriceRow> rows) => <MaterialKind, double>{
        for (final MaterialPriceRow row in rows) row.kind: row.unitPrice,
      },
    );
  }

  @override
  Future<void> savePrice(
    int projectId,
    MaterialKind kind,
    double unitPrice,
  ) async {
    await _db
        .into(_db.materialPrices)
        .insertOnConflictUpdate(
          MaterialPriceRow(
            projectId: projectId,
            kind: kind,
            unitPrice: unitPrice,
          ),
        );
  }

  @override
  Stream<List<BudgetItem>> watchItems(int projectId) {
    final query = _db.select(_db.budgetItems)
      ..where((t) => t.projectId.equals(projectId))
      ..orderBy([
        (t) => OrderingTerm.asc(t.createdAt),
        (t) => OrderingTerm.asc(t.id),
      ]);
    return query.watch().map(
      (List<BudgetItemRow> rows) => rows.map(_toEntity).toList(growable: false),
    );
  }

  @override
  Future<int> addItem(int projectId, BudgetItemDraft draft) {
    return _db
        .into(_db.budgetItems)
        .insert(
          BudgetItemsCompanion.insert(
            projectId: projectId,
            roomId: Value(draft.roomId),
            category: draft.category,
            description: draft.description,
            unit: draft.unit,
            quantity: draft.quantity,
            unitPrice: draft.unitPrice,
          ),
        );
  }

  @override
  Future<void> updateItem(int itemId, BudgetItemDraft draft) async {
    await (_db.update(
      _db.budgetItems,
    )..where((t) => t.id.equals(itemId))).write(
      BudgetItemsCompanion(
        roomId: Value(draft.roomId),
        category: Value(draft.category),
        description: Value(draft.description),
        unit: Value(draft.unit),
        quantity: Value(draft.quantity),
        unitPrice: Value(draft.unitPrice),
      ),
    );
  }

  @override
  Future<void> deleteItem(int itemId) async {
    await (_db.delete(_db.budgetItems)..where((t) => t.id.equals(itemId))).go();
  }

  BudgetItem _toEntity(BudgetItemRow row) {
    return BudgetItem(
      id: row.id,
      projectId: row.projectId,
      roomId: row.roomId,
      category: row.category,
      description: row.description,
      unit: row.unit,
      quantity: row.quantity,
      unitPrice: row.unitPrice,
    );
  }
}
