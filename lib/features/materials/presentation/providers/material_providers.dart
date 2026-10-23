import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/drift_material_settings_repository.dart';
import '../../domain/entities/material_settings.dart';
import '../../domain/repositories/material_settings_repository.dart';

final Provider<MaterialSettingsRepository> materialSettingsRepositoryProvider =
    Provider<MaterialSettingsRepository>(
      (ref) => DriftMaterialSettingsRepository(ref.watch(databaseProvider)),
    );

/// Rendimientos del proyecto, en vivo.
final materialSettingsProvider = StreamProvider.family<MaterialSettings, int>(
  (ref, int projectId) =>
      ref.watch(materialSettingsRepositoryProvider).watch(projectId),
);
