import 'project.dart';

/// Datos que el usuario escribe al crear o editar un proyecto.
///
/// Las fechas no viajan aquí: las pone la capa de datos.
class ProjectDraft {
  const ProjectDraft({
    required this.name,
    this.client,
    this.address,
    this.notes,
  });

  factory ProjectDraft.fromProject(Project project) {
    return ProjectDraft(
      name: project.name,
      client: project.client,
      address: project.address,
      notes: project.notes,
    );
  }

  final String name;
  final String? client;
  final String? address;
  final String? notes;
}
