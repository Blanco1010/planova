import '../../../rooms/domain/entities/room.dart';
import '../../../rooms/domain/entities/room_plan.dart';

/// Superficies de las que salen los materiales.
class SurfaceTotals {
  const SurfaceTotals({required this.netWallAreaM2, required this.floorAreaM2});

  /// Suma lo que miden las habitaciones que se le pasen.
  factory SurfaceTotals.ofRooms(Iterable<Room> rooms) {
    double netWallArea = 0;
    double floorArea = 0;
    for (final Room room in rooms) {
      final RoomPlan plan = RoomPlan.of(room);
      netWallArea += plan.netWallAreaM2;
      floorArea += plan.floorAreaM2;
    }
    return SurfaceTotals(netWallAreaM2: netWallArea, floorAreaM2: floorArea);
  }

  static const SurfaceTotals empty = SurfaceTotals(
    netWallAreaM2: 0,
    floorAreaM2: 0,
  );

  /// Muros descontando puertas y ventanas.
  final double netWallAreaM2;

  /// Área del piso.
  final double floorAreaM2;

  bool get isEmpty => netWallAreaM2 <= 0 && floorAreaM2 <= 0;
}

/// Bloques y mortero para levantar los muros.
class MasonryEstimate {
  const MasonryEstimate({
    required this.wallAreaM2,
    required this.blocks,
    required this.blocksPerSquareMeter,
    required this.mortarCubicMeters,
    required this.cementBags,
    required this.sandCubicMeters,
  });

  final double wallAreaM2;

  /// Bloques o ladrillos, con el desperdicio ya sumado.
  final int blocks;

  final double blocksPerSquareMeter;

  /// Mortero de pega.
  final double mortarCubicMeters;

  final int cementBags;
  final double sandCubicMeters;
}

/// Pintura para muros y, si se quiere, el cielo raso.
class PaintEstimate {
  const PaintEstimate({
    required this.areaM2,
    required this.liters,
    required this.gallons,
  });

  /// Un galón tiene 3,785 litros.
  static const double litersPerGallon = 3.785;

  final double areaM2;
  final double liters;
  final double gallons;
}

/// Baldosa y pegante para el piso.
class FloorEstimate {
  const FloorEstimate({
    required this.areaM2,
    required this.tiles,
    required this.tilesPerSquareMeter,
    required this.adhesiveKilograms,
  });

  final double areaM2;

  /// Piezas con el desperdicio ya sumado.
  final int tiles;

  final double tilesPerSquareMeter;
  final double adhesiveKilograms;
}

/// Lo que hace falta para una habitación o para el proyecto entero.
class MaterialEstimates {
  const MaterialEstimates({
    required this.surfaces,
    required this.masonry,
    required this.paint,
    required this.floor,
  });

  final SurfaceTotals surfaces;
  final MasonryEstimate masonry;
  final PaintEstimate paint;
  final FloorEstimate floor;
}
