import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:planova/features/rooms/domain/entities/opening.dart';
import 'package:planova/features/rooms/domain/entities/room.dart';
import 'package:planova/features/rooms/domain/entities/room_drafts.dart';
import 'package:planova/features/rooms/domain/entities/room_plan.dart';
import 'package:planova/features/rooms/domain/entities/room_wall.dart';
import 'package:planova/features/rooms/presentation/widgets/floor_plan_view.dart';

/// Los primeros bytes de un PNG.
const List<int> _pngMagic = <int>[0x89, 0x50, 0x4E, 0x47];

Room _room({List<Opening> openingsOnFirstWall = const <Opening>[]}) {
  final List<WallDraft> walls = rectangleWalls(widthMeters: 4, lengthMeters: 3);
  return Room(
    id: 1,
    projectId: 1,
    name: 'Sala',
    wallHeightMeters: 2.4,
    walls: <RoomWall>[
      for (int i = 0; i < walls.length; i++)
        RoomWall(
          id: i + 1,
          position: i,
          lengthMeters: walls[i].lengthMeters,
          turnDegrees: i == 0 ? 0 : walls[i].turnDegrees,
          openings: i == 0 ? openingsOnFirstWall : const <Opening>[],
        ),
    ],
    createdAt: DateTime(2026, 10, 22),
    updatedAt: DateTime(2026, 10, 22),
  );
}

void main() {
  testWidgets('el plano se pinta en un PNG con contenido', (
    WidgetTester tester,
  ) async {
    final Room room = _room(
      openingsOnFirstWall: const <Opening>[
        Opening(
          id: 1,
          kind: OpeningKind.door,
          widthMeters: 0.9,
          heightMeters: 2.05,
          distanceFromStartMeters: 1.2,
        ),
      ],
    );

    // toImage() necesita el motor de verdad, fuera del reloj falso.
    final Uint8List? png = await tester.runAsync<Uint8List?>(
      () => renderFloorPlanPng(room: room, plan: RoomPlan.of(room)),
    );

    expect(png, isNotNull);
    expect(png!.take(4), _pngMagic);
    expect(png.length, greaterThan(1000));
  });

  testWidgets('una habitación sin plano no devuelve imagen', (
    WidgetTester tester,
  ) async {
    final Room room = Room(
      id: 2,
      projectId: 1,
      name: 'Sin paredes',
      wallHeightMeters: 2.4,
      walls: const <RoomWall>[],
      createdAt: DateTime(2026, 10, 22),
      updatedAt: DateTime(2026, 10, 22),
    );

    expect(
      await tester.runAsync<Uint8List?>(
        () => renderFloorPlanPng(room: room, plan: RoomPlan.of(room)),
      ),
      isNull,
    );
  });
}
