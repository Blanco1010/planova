import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/budget_item.dart';
import '../../domain/entities/finish.dart';
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
  Future<void> removePrice(int projectId, MaterialKind kind) async {
    await (_db.delete(_db.materialPrices)..where(
          (t) => t.projectId.equals(projectId) & t.kind.equalsValue(kind),
        ))
        .go();
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

  @override
  Stream<List<Finish>> watchFinishes(int projectId) {
    final query =
        _db.select(_db.finishes).join(<Join<HasResultSet, dynamic>>[
            leftOuterJoin(
              _db.finishSurfaces,
              _db.finishSurfaces.finishId.equalsExp(_db.finishes.id),
            ),
          ])
          ..where(_db.finishes.projectId.equals(projectId))
          ..orderBy([
            OrderingTerm.asc(_db.finishes.createdAt),
            OrderingTerm.asc(_db.finishes.id),
          ]);

    return query.watch().map(_assembleFinishes);
  }

  @override
  Future<int> addFinish(int projectId, FinishDraft draft) {
    return _db.transaction(() async {
      final int finishId = await _db
          .into(_db.finishes)
          .insert(
            FinishesCompanion.insert(
              projectId: projectId,
              description: draft.description,
              unitPrice: draft.unitPrice,
            ),
          );
      await _writeSurfaces(finishId, draft.surfaces);
      return finishId;
    });
  }

  @override
  Future<void> updateFinish(int finishId, FinishDraft draft) async {
    await _db.transaction(() async {
      await (_db.update(
        _db.finishes,
      )..where((t) => t.id.equals(finishId))).write(
        FinishesCompanion(
          description: Value(draft.description),
          unitPrice: Value(draft.unitPrice),
        ),
      );
      await (_db.delete(
        _db.finishSurfaces,
      )..where((t) => t.finishId.equals(finishId))).go();
      await _writeSurfaces(finishId, draft.surfaces);
    });
  }

  @override
  Future<void> deleteFinish(int finishId) async {
    await (_db.delete(_db.finishes)..where((t) => t.id.equals(finishId))).go();
  }

  Future<void> _writeSurfaces(
    int finishId,
    List<FinishSurface> surfaces,
  ) async {
    for (final FinishSurface surface in surfaces) {
      await _db
          .into(_db.finishSurfaces)
          .insert(
            FinishSurfacesCompanion.insert(
              finishId: finishId,
              roomId: surface.roomId,
              wallId: Value(surface.wallId),
            ),
          );
    }
  }

  /// Arma los acabados a partir de las filas del join.
  List<Finish> _assembleFinishes(List<TypedResult> rows) {
    final Map<int, FinishRow> finishRows = <int, FinishRow>{};
    final Map<int, List<FinishSurface>> surfaces = <int, List<FinishSurface>>{};

    for (final TypedResult row in rows) {
      final FinishRow finishRow = row.readTable(_db.finishes);
      finishRows.putIfAbsent(finishRow.id, () => finishRow);

      final FinishSurfaceRow? surface = row.readTableOrNull(_db.finishSurfaces);
      if (surface == null) continue;
      (surfaces[finishRow.id] ??= <FinishSurface>[]).add(
        FinishSurface(roomId: surface.roomId, wallId: surface.wallId),
      );
    }

    return finishRows.values
        .map(
          (FinishRow row) => Finish(
            id: row.id,
            projectId: row.projectId,
            description: row.description,
            unitPrice: row.unitPrice,
            surfaces: surfaces[row.id] ?? const <FinishSurface>[],
          ),
        )
        .toList(growable: false);
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
