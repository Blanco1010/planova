import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/drift_project_repository.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';

/// Repositorio de proyectos. En pruebas se sustituye por uno falso.
final Provider<ProjectRepository> projectRepositoryProvider =
    Provider<ProjectRepository>(
      (ref) => DriftProjectRepository(ref.watch(databaseProvider)),
    );

/// Lista de proyectos en vivo: se refresca sola al crear, editar o borrar.
final StreamProvider<List<Project>> projectsProvider =
    StreamProvider<List<Project>>(
      (ref) => ref.watch(projectRepositoryProvider).watchAll(),
    );
