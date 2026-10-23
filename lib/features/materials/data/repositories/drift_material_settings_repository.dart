import '../../../../core/database/app_database.dart';
import '../../domain/entities/material_settings.dart';
import '../../domain/repositories/material_settings_repository.dart';

/// Implementación de [MaterialSettingsRepository] sobre SQLite con Drift.
class DriftMaterialSettingsRepository implements MaterialSettingsRepository {
  const DriftMaterialSettingsRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<MaterialSettings> watch(int projectId) {
    return (_db.select(_db.projectMaterialSettings)
          ..where((t) => t.projectId.equals(projectId)))
        .watchSingleOrNull()
        .map(_toEntity);
  }

  @override
  Future<void> save(int projectId, MaterialSettings settings) async {
    await _db
        .into(_db.projectMaterialSettings)
        .insertOnConflictUpdate(
          MaterialSettingsRow(
            projectId: projectId,
            blockLengthMeters: settings.masonry.blockLengthMeters,
            blockHeightMeters: settings.masonry.blockHeightMeters,
            jointMeters: settings.masonry.jointMeters,
            wallThicknessMeters: settings.masonry.wallThicknessMeters,
            masonryWastePercent: settings.masonry.wastePercent,
            cementBagsPerCubicMeter:
                settings.masonry.cementBagsPerCubicMeter,
            sandCubicMetersPerCubicMeter:
                settings.masonry.sandCubicMetersPerCubicMeter,
            paintCoats: settings.paint.coats,
            squareMetersPerLiter: settings.paint.squareMetersPerLiter,
            paintWastePercent: settings.paint.wastePercent,
            includeCeiling: settings.paint.includeCeiling,
            tileLengthMeters: settings.floor.tileLengthMeters,
            tileWidthMeters: settings.floor.tileWidthMeters,
            floorWastePercent: settings.floor.wastePercent,
            adhesiveKilogramsPerSquareMeter:
                settings.floor.adhesiveKilogramsPerSquareMeter,
          ),
        );
  }

  MaterialSettings _toEntity(MaterialSettingsRow? row) {
    if (row == null) return MaterialSettings.defaults;

    return MaterialSettings(
      masonry: MasonryParams(
        blockLengthMeters: row.blockLengthMeters,
        blockHeightMeters: row.blockHeightMeters,
        jointMeters: row.jointMeters,
        wallThicknessMeters: row.wallThicknessMeters,
        wastePercent: row.masonryWastePercent,
        cementBagsPerCubicMeter: row.cementBagsPerCubicMeter,
        sandCubicMetersPerCubicMeter: row.sandCubicMetersPerCubicMeter,
      ),
      paint: PaintParams(
        coats: row.paintCoats,
        squareMetersPerLiter: row.squareMetersPerLiter,
        wastePercent: row.paintWastePercent,
        includeCeiling: row.includeCeiling,
      ),
      floor: FloorParams(
        tileLengthMeters: row.tileLengthMeters,
        tileWidthMeters: row.tileWidthMeters,
        wastePercent: row.floorWastePercent,
        adhesiveKilogramsPerSquareMeter:
            row.adhesiveKilogramsPerSquareMeter,
      ),
    );
  }
}
