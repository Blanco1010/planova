import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/drift_budget_repository.dart';
import '../../data/services/printing_budget_exporter.dart';
import '../../domain/entities/budget_item.dart';
import '../../domain/entities/material_kind.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/services/budget_exporter.dart';

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

/// Quien saca el PDF del teléfono. En pruebas se sustituye por uno de mentira.
final Provider<BudgetExporter> budgetExporterProvider =
    Provider<BudgetExporter>((ref) => const PrintingBudgetExporter());
