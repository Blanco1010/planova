import 'package:flutter_test/flutter_test.dart';
import 'package:planova/features/rooms/domain/entities/opening.dart';
import 'package:planova/features/rooms/domain/entities/room.dart';
import 'package:planova/features/rooms/domain/entities/room_plan.dart';
import 'package:planova/features/rooms/domain/entities/room_wall.dart';

Room _room({
  required List<double> lengths,
  double wallHeightMeters = 2.4,
  List<Opening> openingsOnFirstWall = const <Opening>[],
}) {
  final DateTime now = DateTime(2026, 10, 22);
  return Room(
    id: 1,
    projectId: 1,
    name: 'Sala',
    wallHeightMeters: wallHeightMeters,
    walls: <RoomWall>[
      for (int i = 0; i < lengths.length; i++)
        RoomWall(
          id: i + 1,
          position: i,
          lengthMeters: lengths[i],
          turnDegrees: i == 0 ? 0 : 90,
          openings: i == 0 ? openingsOnFirstWall : const <Opening>[],
        ),
    ],
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  test('un rectángulo de 4 × 3 mide 12 m² y 14 m de perímetro', () {
    final RoomPlan plan = RoomPlan.of(_room(lengths: <double>[4, 3, 4, 3]));

    expect(plan.floorAreaM2, closeTo(12, 1e-9));
    expect(plan.perimeterMeters, closeTo(14, 1e-9));
    expect(plan.isClosed, isTrue);
    expect(plan.vertices.length, 4);
  });

  test('los vanos se descuentan de la superficie de muros', () {
    final RoomPlan plan = RoomPlan.of(
      _room(
        lengths: <double>[4, 3, 4, 3],
        openingsOnFirstWall: const <Opening>[
          Opening(
            id: 1,
            kind: OpeningKind.door,
            widthMeters: 0.80,
            heightMeters: 2.05,
            distanceFromStartMeters: 0.5,
          ),
          Opening(
            id: 2,
            kind: OpeningKind.window,
            widthMeters: 1.20,
            heightMeters: 1.20,
            distanceFromStartMeters: 2,
          ),
        ],
      ),
    );

    // 14 m de perímetro por 2,40 m de alto.
    expect(plan.grossWallAreaM2, closeTo(33.6, 1e-9));
    expect(plan.openingsAreaM2, closeTo(0.80 * 2.05 + 1.20 * 1.20, 1e-9));
    expect(
      plan.netWallAreaM2,
      closeTo(33.6 - (0.80 * 2.05 + 1.20 * 1.20), 1e-9),
    );
  });

  test('avisa cuando el recorrido no vuelve al punto de partida', () {
    final RoomPlan plan = RoomPlan.of(_room(lengths: <double>[4, 3, 4, 2.5]));

    expect(plan.isClosed, isFalse);
    expect(plan.closureGapMeters, closeTo(0.5, 1e-9));
  });

  test('el giro de la primera pared no mueve el plano', () {
    final Room base = _room(lengths: <double>[4, 3, 4, 3]);
    final Room rotated = Room(
      id: base.id,
      projectId: base.projectId,
      name: base.name,
      wallHeightMeters: base.wallHeightMeters,
      walls: <RoomWall>[
        RoomWall(
          id: base.walls.first.id,
          position: 0,
          lengthMeters: base.walls.first.lengthMeters,
          turnDegrees: 45,
        ),
        ...base.walls.skip(1),
      ],
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
    );

    expect(RoomPlan.of(rotated).vertices, RoomPlan.of(base).vertices);
  });
}
