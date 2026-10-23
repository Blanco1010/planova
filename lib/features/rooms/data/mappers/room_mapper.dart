import '../../../../core/database/app_database.dart';
import '../../domain/entities/opening.dart';

extension RoomOpeningRowMapper on RoomOpeningRow {
  Opening toEntity() {
    return Opening(
      id: id,
      kind: kind,
      widthMeters: widthMeters,
      heightMeters: heightMeters,
      distanceFromStartMeters: distanceFromStartMeters,
    );
  }
}
