import 'opening.dart';

/// Datos de la habitación que escribe el usuario.
class RoomDraft {
  const RoomDraft({required this.name, required this.wallHeightMeters});

  final String name;
  final double wallHeightMeters;
}

/// Datos de una pared que escribe el usuario.
class WallDraft {
  const WallDraft({required this.lengthMeters, this.turnDegrees = 90});

  final double lengthMeters;
  final double turnDegrees;
}

/// Las cuatro paredes de una habitación rectangular.
List<WallDraft> rectangleWalls({
  required double widthMeters,
  required double lengthMeters,
}) {
  return <WallDraft>[
    WallDraft(lengthMeters: widthMeters, turnDegrees: 0),
    WallDraft(lengthMeters: lengthMeters),
    WallDraft(lengthMeters: widthMeters),
    WallDraft(lengthMeters: lengthMeters),
  ];
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
