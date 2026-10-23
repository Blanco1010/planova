import 'opening.dart';

/// Datos de la habitación que escribe el usuario.
class RoomDraft {
  const RoomDraft({required this.name, required this.wallHeightMeters});

  final String name;
  final double wallHeightMeters;
}

/// Medidas de una habitación rectangular, para crearla de un tirón.
class RectangularRoomDraft {
  const RectangularRoomDraft({
    required this.room,
    required this.widthMeters,
    required this.lengthMeters,
  });

  final RoomDraft room;
  final double widthMeters;
  final double lengthMeters;
}

/// Datos de una pared que escribe el usuario.
class WallDraft {
  const WallDraft({required this.lengthMeters, this.turnDegrees = 90});

  final double lengthMeters;
  final double turnDegrees;
}

/// Datos de un vano que escribe el usuario.
class OpeningDraft {
  const OpeningDraft({
    required this.kind,
    required this.widthMeters,
    required this.heightMeters,
    required this.distanceFromStartMeters,
  });

  final OpeningKind kind;
  final double widthMeters;
  final double heightMeters;
  final double distanceFromStartMeters;
}
