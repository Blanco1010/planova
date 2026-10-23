import '../entities/material_settings.dart';

/// Rendimientos de materiales guardados por proyecto.
abstract interface class MaterialSettingsRepository {
  /// Los del proyecto; si nunca se han tocado, los valores por defecto.
  Stream<MaterialSettings> watch(int projectId);

  Future<void> save(int projectId, MaterialSettings settings);
}
