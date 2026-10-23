import '../entities/project.dart';
import '../entities/project_draft.dart';

/// Acceso a los proyectos guardados. La implementación vive en `data/`.
abstract interface class ProjectRepository {
  /// Proyectos ordenados por fecha de modificación, el más reciente primero.
  Stream<List<Project>> watchAll();

  Future<Project?> findById(int id);

  /// Crea el proyecto y devuelve su `id`.
  Future<int> create(ProjectDraft draft);

  Future<void> update(int id, ProjectDraft draft);

  Future<void> delete(int id);
}
