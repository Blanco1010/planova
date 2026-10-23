import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/project_draft.dart';
import '../../domain/repositories/project_repository.dart';
import '../mappers/project_mapper.dart';

/// Implementación de [ProjectRepository] sobre SQLite con Drift.
class DriftProjectRepository implements ProjectRepository {
  const DriftProjectRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Project>> watchAll() {
    final SimpleSelectStatement<$ProjectsTable, ProjectRow> query = _db.select(
      _db.projects,
    )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    return query.watch().map(
      (rows) => rows.map((row) => row.toEntity()).toList(growable: false),
    );
  }

  @override
  Stream<Project?> watchById(int id) {
    return (_db.select(_db.projects)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((ProjectRow? row) => row?.toEntity());
  }

  @override
  Future<Project?> findById(int id) async {
    final ProjectRow? row = await (_db.select(
      _db.projects,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<int> create(ProjectDraft draft) {
    final DateTime now = DateTime.now();
    return _db
        .into(_db.projects)
        .insert(
          ProjectsCompanion.insert(
            name: draft.name,
            client: Value(draft.client),
            address: Value(draft.address),
            notes: Value(draft.notes),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<void> update(int id, ProjectDraft draft) async {
    await (_db.update(_db.projects)..where((t) => t.id.equals(id))).write(
      ProjectsCompanion(
        name: Value(draft.name),
        client: Value(draft.client),
        address: Value(draft.address),
        notes: Value(draft.notes),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> delete(int id) async {
    await (_db.delete(_db.projects)..where((t) => t.id.equals(id))).go();
  }
}
