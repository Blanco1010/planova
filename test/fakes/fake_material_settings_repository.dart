import 'dart:async';

import 'package:planova/features/materials/domain/entities/material_settings.dart';
import 'package:planova/features/materials/domain/repositories/material_settings_repository.dart';

/// Rendimientos en memoria para las pruebas de interfaz.
class FakeMaterialSettingsRepository implements MaterialSettingsRepository {
  final Map<int, MaterialSettings> _byProject = <int, MaterialSettings>{};
  final StreamController<void> _changes = StreamController<void>.broadcast();

  void dispose() => _changes.close();

  @override
  Stream<MaterialSettings> watch(int projectId) async* {
    yield _byProject[projectId] ?? MaterialSettings.defaults;
    yield* _changes.stream.map(
      (_) => _byProject[projectId] ?? MaterialSettings.defaults,
    );
  }

  @override
  Future<void> save(int projectId, MaterialSettings settings) async {
    _byProject[projectId] = settings;
    if (!_changes.isClosed) _changes.add(null);
  }
}
