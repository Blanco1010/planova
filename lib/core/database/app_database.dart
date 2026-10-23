import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/budget/data/tables/budget_tables.dart';
import '../../features/budget/domain/entities/budget_item.dart';
import '../../features/budget/domain/entities/material_kind.dart';
import '../../features/materials/data/tables/material_settings_table.dart';
import '../../features/projects/data/tables/projects_table.dart';
import '../../features/rooms/data/tables/room_openings_table.dart';
import '../../features/rooms/data/tables/room_walls_table.dart';
import '../../features/rooms/data/tables/rooms_table.dart';
import '../../features/rooms/domain/entities/opening.dart';
import '../../features/settings/data/tables/app_settings_table.dart';

part 'app_database.g.dart';

/// Base de datos local (SQLite) de la app. Cada feature aporta sus tablas.
@DriftDatabase(
  tables: [
    Projects,
    AppSettings,
    Rooms,
    RoomWalls,
    RoomOpenings,
    ProjectMaterialSettings,
    MaterialPrices,
    BudgetItems,
    Finishes,
    FinishSurfaces,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: _fileName));

  /// Constructor para pruebas: recibe un ejecutor en memoria.
  AppDatabase.withExecutor(super.executor);

  static const String _fileName = 'planova';

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(rooms);
        await m.createTable(roomWalls);
        await m.createTable(roomOpenings);
      }
      if (from < 3) {
        await m.createTable(projectMaterialSettings);
      }
      if (from < 4) {
        await m.createTable(materialPrices);
        await m.createTable(budgetItems);
      }
      if (from < 5) {
        await m.createTable(finishes);
        await m.createTable(finishSurfaces);
      }
    },
    beforeOpen: (OpeningDetails details) async {
      // Sin esto SQLite ignora las claves foráneas y el borrado en cascada.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

/// Instancia única de la base de datos para toda la app.
final Provider<AppDatabase> databaseProvider = Provider<AppDatabase>((ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
