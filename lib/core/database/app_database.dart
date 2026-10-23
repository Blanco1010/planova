import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/projects/data/tables/projects_table.dart';
import '../../features/settings/data/tables/app_settings_table.dart';

part 'app_database.g.dart';

/// Base de datos local (SQLite) de la app. Cada feature aporta sus tablas.
@DriftDatabase(tables: [Projects, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: _fileName));

  /// Constructor para pruebas: recibe un ejecutor en memoria.
  AppDatabase.withExecutor(super.executor);

  static const String _fileName = 'planova';

  @override
  int get schemaVersion => 1;
}

/// Instancia única de la base de datos para toda la app.
final Provider<AppDatabase> databaseProvider = Provider<AppDatabase>((ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
