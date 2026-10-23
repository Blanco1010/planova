import 'opening.dart';

/// Una pared de la habitación, con los vanos que tenga.
class RoomWall {
  const RoomWall({
    required this.id,
    required this.position,
    required this.lengthMeters,
    required this.turnDegrees,
    this.openings = const <Opening>[],
  });

  final int id;

  /// Orden dentro del recorrido de la habitación, empezando en 0.
  final int position;

  final double lengthMeters;

  /// Giro respecto a la pared anterior. +90° gira a la derecha.
  final double turnDegrees;

  final List<Opening> openings;

  /// Superficie de los vanos de esta pared, en m².
  double get openingsAreaM2 =>
      openings.fold<double>(0, (double sum, Opening o) => sum + o.areaM2);

  /// Cómo se llama la pared en pantalla: «Pared 1», «Pared 2»…
  String get label => 'Pared ${position + 1}';
}
