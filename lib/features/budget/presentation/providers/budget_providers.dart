import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/drift_budget_repository.dart';
import '../../domain/entities/budget_item.dart';
import '../../domain/entities/material_kind.dart';
import '../../domain/repositories/budget_repository.dart';

final Provider<BudgetRepository> budgetRepositoryProvider =
    Provider<BudgetRepository>(
      (ref) => DriftBudgetRepository(ref.watch(databaseProvider)),
    );

/// Precios unitarios del proyecto, en vivo.
final materialPricesProvider =
    StreamProvider.family<Map<MaterialKind, double>, int>(
      (ref, int projectId) =>
          ref.watch(budgetRepositoryProvider).watchPrices(projectId),
    );

/// Partidas escritas a mano, en vivo.
final budgetItemsProvider = StreamProvider.family<List<BudgetItem>, int>(
  (ref, int projectId) =>
      ref.watch(budgetRepositoryProvider).watchItems(projectId),
);

/// Cómo se enseña cada material calculado.
extension MaterialKindDisplay on MaterialKind {
  String get label => switch (this) {
    MaterialKind.block => 'Bloques',
    MaterialKind.cement => 'Cemento',
    MaterialKind.sand => 'Arena',
    MaterialKind.paint => 'Pintura',
    MaterialKind.adhesive => 'Pegante',
    MaterialKind.tile => 'Baldosas',
  };

  String get unit => switch (this) {
    MaterialKind.block => 'unid',
    MaterialKind.cement => 'bulto',
    MaterialKind.sand => 'm³',
    MaterialKind.paint => 'gal',
    MaterialKind.adhesive => 'kg',
    MaterialKind.tile => 'unid',
  };
}

/// Cómo se enseña cada capítulo del presupuesto.
extension BudgetCategoryDisplay on BudgetCategory {
  String get label => switch (this) {
    BudgetCategory.material => 'Material',
    BudgetCategory.labor => 'Mano de obra',
    BudgetCategory.other => 'Otros',
  };
}
