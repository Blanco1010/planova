import '../../../../core/database/app_database.dart';
import '../../domain/entities/project.dart';

/// Traduce entre la fila de Drift y la entidad de dominio.
extension ProjectRowMapper on ProjectRow {
  Project toEntity() {
    return Project(
      id: id,
      name: name,
      client: client,
      address: address,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
