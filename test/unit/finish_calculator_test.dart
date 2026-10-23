import 'package:flutter_test/flutter_test.dart';
import 'package:planova/features/budget/domain/entities/finish.dart';
import 'package:planova/features/budget/domain/services/finish_calculator.dart';
import 'package:planova/features/rooms/domain/entities/opening.dart';
import 'package:planova/features/rooms/domain/entities/room.dart';
import 'package:planova/features/rooms/domain/entities/room_drafts.dart';
import 'package:planova/features/rooms/domain/entities/room_wall.dart';

/// Una sala de 4 × 3 con 2,40 m de alto y una puerta en la pared 1.
Room _room({int id = 1, double width = 4, double length = 3}) {
  final List<WallDraft> walls = rectangleWalls(
    widthMeters: width,
    lengthMeters: length,
  );
  return Room(
    id: id,
    projectId: 1,
    name: 'Sala',
    wallHeightMeters: 2.4,
    walls: <RoomWall>[
      for (int i = 0; i < walls.length; i++)
        RoomWall(
          id: id * 10 + i,
          position: i,
          lengthMeters: walls[i].lengthMeters,
          turnDegrees: i == 0 ? 0 : walls[i].turnDegrees,
          openings: i == 0
              ? const <Opening>[
                  Opening(
                    id: 1,
                    kind: OpeningKind.door,
                    widthMeters: 0.8,
                    heightMeters: 2.05,
                    distanceFromStartMeters: 0.5,
                  ),
                ]
              : const <Opening>[],
        ),
    ],
    createdAt: DateTime(2026, 10, 23),
    updatedAt: DateTime(2026, 10, 23),
  );
}

Finish _finish(List<FinishSurface> surfaces, {double unitPrice = 12000}) {
  return Finish(
    id: 1,
    projectId: 1,
    description: 'Pintura',
    unitPrice: unitPrice,
    surfaces: surfaces,
  );
}

void main() {
  test('una pared mide su largo por la altura, menos los vanos', () {
    final Room room = _room();

    // Pared 1: 4 m × 2,40 menos la puerta de 0,80 × 2,05.
    expect(
      FinishCalculator.wallArea(room, room.walls.first),
      closeTo(4 * 2.4 - 0.8 * 2.05, 1e-9),
    );
    // Pared 2: 3 m × 2,40, sin vanos.
    expect(FinishCalculator.wallArea(room, room.walls[1]), closeTo(7.2, 1e-9));
  });

  test('el piso de una habitación es su área', () {
    expect(
      FinishCalculator.surfaceArea(const FinishSurface(roomId: 1), <Room>[
        _room(),
      ]),
      closeTo(12, 1e-9),
    );
  });

  test('suma paredes y pisos elegidos, y los cuenta', () {
    final Room room = _room();
    final FinishEstimate estimate = FinishCalculator.estimate(
      _finish(<FinishSurface>[
        FinishSurface(roomId: 1, wallId: room.walls[1].id),
        FinishSurface(roomId: 1, wallId: room.walls[2].id),
        const FinishSurface(roomId: 1),
      ]),
      <Room>[room],
    );

    // 7,20 + 9,60 de paredes más 12 m² de piso.
    expect(estimate.areaM2, closeTo(28.8, 1e-9));
    expect(estimate.walls, 2);
    expect(estimate.floors, 1);
    expect(estimate.total, closeTo(28.8 * 12000, 1e-6));
  });

  test('una superficie que ya no existe no suma', () {
    final FinishEstimate estimate = FinishCalculator.estimate(
      _finish(const <FinishSurface>[
        FinishSurface(roomId: 99, wallId: 5),
        FinishSurface(roomId: 1, wallId: 999),
      ]),
      <Room>[_room()],
    );

    expect(estimate.areaM2, 0);
    expect(estimate.total, 0);
  });

  test('el total junta todos los acabados', () {
    final Room room = _room();
    final double total = FinishCalculator.totalOf(
      <Finish>[
        _finish(<FinishSurface>[
          FinishSurface(roomId: 1, wallId: room.walls[1].id),
        ]),
        _finish(const <FinishSurface>[
          FinishSurface(roomId: 1),
        ], unitPrice: 30000),
      ],
      <Room>[room],
    );

    expect(total, closeTo(7.2 * 12000 + 12 * 30000, 1e-6));
  });

  test('mirado por habitación, un acabado cuenta solo por la parte de esa', () {
    final Room sala = _room();
    final Room cocina = _room(id: 2, width: 3, length: 2);
    final Finish repartido = _finish(<FinishSurface>[
      FinishSurface(roomId: sala.id, wallId: sala.walls[1].id),
      FinishSurface(roomId: cocina.id, wallId: cocina.walls[1].id),
    ]);
    final Finish soloCocina = _finish(const <FinishSurface>[
      FinishSurface(roomId: 2),
    ]);

    final List<Finish> enLaSala = FinishCalculator.within(<Finish>[
      repartido,
      soloCocina,
    ], <Room>[sala]);

    // El de la cocina se cae; al repartido le queda su pared de la sala.
    expect(enLaSala.length, 1);
    expect(enLaSala.single.surfaces.single.roomId, sala.id);
    expect(enLaSala.single.description, repartido.description);
    expect(
      FinishCalculator.totalOf(enLaSala, <Room>[sala]),
      closeTo(7.2 * 12000, 1e-6),
    );
  });
}
