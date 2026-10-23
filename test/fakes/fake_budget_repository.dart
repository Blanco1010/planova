import 'dart:async';

import 'package:planova/features/budget/domain/entities/budget_item.dart';
import 'package:planova/features/budget/domain/entities/finish.dart';
import 'package:planova/features/budget/domain/entities/material_kind.dart';
import 'package:planova/features/budget/domain/repositories/budget_repository.dart';

/// Precios y partidas en memoria para las pruebas de interfaz.
class FakeBudgetRepository implements BudgetRepository {
  final Map<MaterialKind, double> _prices = <MaterialKind, double>{};
  final List<BudgetItem> _items = <BudgetItem>[];
  final List<Finish> _finishes = <Finish>[];
  final StreamController<void> _changes = StreamController<void>.broadcast();
  int _nextId = 1;

  void dispose() => _changes.close();

  @override
  Stream<Map<MaterialKind, double>> watchPrices(int projectId) async* {
    yield Map<MaterialKind, double>.of(_prices);
    yield* _changes.stream.map((_) => Map<MaterialKind, double>.of(_prices));
  }

  @override
  Future<void> savePrice(
    int projectId,
    MaterialKind kind,
    double unitPrice,
  ) async {
    _prices[kind] = unitPrice;
    _emit();
  }

  @override
  Future<void> removePrice(int projectId, MaterialKind kind) async {
    _prices.remove(kind);
    _emit();
  }

  @override
  Stream<List<BudgetItem>> watchItems(int projectId) async* {
    yield List<BudgetItem>.of(_items);
    yield* _changes.stream.map((_) => List<BudgetItem>.of(_items));
  }

  @override
  Future<int> addItem(int projectId, BudgetItemDraft draft) async {
    final BudgetItem item = _from(_nextId++, projectId, draft);
    _items.add(item);
    _emit();
    return item.id;
  }

  @override
  Future<void> updateItem(int itemId, BudgetItemDraft draft) async {
    final int index = _items.indexWhere((BudgetItem item) => item.id == itemId);
    if (index == -1) return;
    _items[index] = _from(itemId, _items[index].projectId, draft);
    _emit();
  }

  @override
  Future<void> deleteItem(int itemId) async {
    _items.removeWhere((BudgetItem item) => item.id == itemId);
    _emit();
  }

  @override
  Stream<List<Finish>> watchFinishes(int projectId) async* {
    yield List<Finish>.of(_finishes);
    yield* _changes.stream.map((_) => List<Finish>.of(_finishes));
  }

  @override
  Future<int> addFinish(int projectId, FinishDraft draft) async {
    final int id = _nextId++;
    _finishes.add(
      Finish(
        id: id,
        projectId: projectId,
        description: draft.description,
        unitPrice: draft.unitPrice,
        surfaces: draft.surfaces,
      ),
    );
    _emit();
    return id;
  }

  @override
  Future<void> updateFinish(int finishId, FinishDraft draft) async {
    final int index = _finishes.indexWhere((Finish f) => f.id == finishId);
    if (index == -1) return;
    _finishes[index] = Finish(
      id: finishId,
      projectId: _finishes[index].projectId,
      description: draft.description,
      unitPrice: draft.unitPrice,
      surfaces: draft.surfaces,
    );
    _emit();
  }

  @override
  Future<void> deleteFinish(int finishId) async {
    _finishes.removeWhere((Finish f) => f.id == finishId);
    _emit();
  }

  BudgetItem _from(int id, int projectId, BudgetItemDraft draft) => BudgetItem(
    id: id,
    projectId: projectId,
    roomId: draft.roomId,
    category: draft.category,
    description: draft.description,
    unit: draft.unit,
    quantity: draft.quantity,
    unitPrice: draft.unitPrice,
  );

  void _emit() {
    if (!_changes.isClosed) _changes.add(null);
  }
}
