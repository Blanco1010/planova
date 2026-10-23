import 'dart:async';

import 'package:planova/features/projects/domain/entities/project.dart';
import 'package:planova/features/projects/domain/entities/project_draft.dart';
import 'package:planova/features/projects/domain/repositories/project_repository.dart';

/// Repositorio en memoria para las pruebas de interfaz: sin SQLite de por medio.
class FakeProjectRepository implements ProjectRepository {
  FakeProjectRepository([List<Project> initial = const <Project>[]])
      : _projects = List<Project>.of(initial);

  final List<Project> _projects;
  final StreamController<List<Project>> _changes =
      StreamController<List<Project>>.broadcast();
  int _nextId = 1;

  @override
  Stream<List<Project>> watchAll() async* {
    yield List<Project>.unmodifiable(_projects);
    yield* _changes.stream;
  }

  @override
  Future<Project?> findById(int id) async {
    for (final Project project in _projects) {
      if (project.id == id) return project;
    }
    return null;
  }

  @override
  Future<int> create(ProjectDraft draft) async {
    final DateTime now = DateTime.now();
    final Project project = Project(
      id: _nextId++,
      name: draft.name,
      client: draft.client,
      address: draft.address,
      notes: draft.notes,
      createdAt: now,
      updatedAt: now,
    );
    _projects.insert(0, project);
    _emit();
    return project.id;
  }

  @override
  Future<void> update(int id, ProjectDraft draft) async {
    final int index = _projects.indexWhere((Project p) => p.id == id);
    if (index == -1) return;
    final Project current = _projects[index];
    _projects[index] = Project(
      id: current.id,
      name: draft.name,
      client: draft.client,
      address: draft.address,
      notes: draft.notes,
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
    );
    _emit();
  }

  @override
  Future<void> delete(int id) async {
    _projects.removeWhere((Project project) => project.id == id);
    _emit();
  }

  void dispose() => _changes.close();

  void _emit() => _changes.add(List<Project>.unmodifiable(_projects));
}
