import 'dart:async';

import 'package:planova/features/rooms/domain/entities/opening.dart';
import 'package:planova/features/rooms/domain/entities/room.dart';
import 'package:planova/features/rooms/domain/entities/room_drafts.dart';
import 'package:planova/features/rooms/domain/entities/room_wall.dart';
import 'package:planova/features/rooms/domain/repositories/room_repository.dart';

/// Repositorio de habitaciones en memoria para las pruebas de interfaz.
class FakeRoomRepository implements RoomRepository {
  final List<Room> _rooms = <Room>[];
  final StreamController<void> _changes = StreamController<void>.broadcast();
  int _nextRoomId = 1;
  int _nextWallId = 1;
  int _nextOpeningId = 1;

  void dispose() => _changes.close();

  @override
  Stream<List<Room>> watchByProject(int projectId) async* {
    yield _ofProject(projectId);
    yield* _changes.stream.map((_) => _ofProject(projectId));
  }

  @override
  Stream<Room?> watchById(int roomId) async* {
    yield _byId(roomId);
    yield* _changes.stream.map((_) => _byId(roomId));
  }

  @override
  Future<int> createFromWalls(
    int projectId,
    RoomDraft draft,
    List<WallDraft> walls,
  ) async {
    final DateTime now = DateTime.now();
    final Room room = Room(
      id: _nextRoomId++,
      projectId: projectId,
      name: draft.name,
      wallHeightMeters: draft.wallHeightMeters,
      walls: <RoomWall>[
        for (int i = 0; i < walls.length; i++)
          RoomWall(
            id: _nextWallId++,
            position: i,
            lengthMeters: walls[i].lengthMeters,
            turnDegrees: i == 0 ? 0 : walls[i].turnDegrees,
          ),
      ],
      createdAt: now,
      updatedAt: now,
    );
    _rooms.add(room);
    _emit();
    return room.id;
  }

  @override
  Future<void> update(int roomId, RoomDraft draft) async {
    _replaceRoom(
      roomId,
      (Room room) => _copy(
        room,
        name: draft.name,
        wallHeightMeters: draft.wallHeightMeters,
      ),
    );
  }

  @override
  Future<void> delete(int roomId) async {
    _rooms.removeWhere((Room room) => room.id == roomId);
    _emit();
  }

  @override
  Future<int> addWall(int roomId, WallDraft draft) async {
    final int wallId = _nextWallId++;
    _replaceRoom(roomId, (Room room) {
      return _copy(
        room,
        walls: <RoomWall>[
          ...room.walls,
          RoomWall(
            id: wallId,
            position: room.walls.length,
            lengthMeters: draft.lengthMeters,
            turnDegrees: draft.turnDegrees,
          ),
        ],
      );
    });
    return wallId;
  }

  @override
  Future<void> updateWall(int wallId, WallDraft draft) async {
    _mapWall(
      wallId,
      (RoomWall wall) => RoomWall(
        id: wall.id,
        position: wall.position,
        lengthMeters: draft.lengthMeters,
        turnDegrees: draft.turnDegrees,
        openings: wall.openings,
      ),
    );
  }

  @override
  Future<void> deleteWall(int wallId) async {
    final Room? room = _roomOfWall(wallId);
    if (room == null) return;

    final List<RoomWall> remaining = room.walls
        .where((RoomWall wall) => wall.id != wallId)
        .toList();
    _replaceRoom(
      room.id,
      (Room current) => _copy(
        current,
        walls: <RoomWall>[
          for (int i = 0; i < remaining.length; i++)
            RoomWall(
              id: remaining[i].id,
              position: i,
              lengthMeters: remaining[i].lengthMeters,
              turnDegrees: remaining[i].turnDegrees,
              openings: remaining[i].openings,
            ),
        ],
      ),
    );
  }

  @override
  Future<int> addOpening(int wallId, OpeningDraft draft) async {
    final int openingId = _nextOpeningId++;
    _mapWall(
      wallId,
      (RoomWall wall) => _copyWall(
        wall,
        openings: <Opening>[..._openings(wall), _opening(openingId, draft)],
      ),
    );
    return openingId;
  }

  @override
  Future<void> updateOpening(int openingId, OpeningDraft draft) async {
    final Room? room = _roomOfOpening(openingId);
    if (room == null) return;

    for (final RoomWall wall in room.walls) {
      if (!wall.openings.any((Opening o) => o.id == openingId)) continue;
      _mapWall(
        wall.id,
        (RoomWall current) => _copyWall(
          current,
          openings: current.openings
              .map(
                (Opening o) =>
                    o.id == openingId ? _opening(openingId, draft) : o,
              )
              .toList(),
        ),
      );
      return;
    }
  }

  @override
  Future<void> deleteOpening(int openingId) async {
    final Room? room = _roomOfOpening(openingId);
    if (room == null) return;

    for (final RoomWall wall in room.walls) {
      if (!wall.openings.any((Opening o) => o.id == openingId)) continue;
      _mapWall(
        wall.id,
        (RoomWall current) => _copyWall(
          current,
          openings: current.openings
              .where((Opening o) => o.id != openingId)
              .toList(),
        ),
      );
      return;
    }
  }

  List<Room> _ofProject(int projectId) => _rooms
      .where((Room room) => room.projectId == projectId)
      .toList(growable: false);

  Room? _byId(int roomId) {
    for (final Room room in _rooms) {
      if (room.id == roomId) return room;
    }
    return null;
  }

  Room? _roomOfWall(int wallId) {
    for (final Room room in _rooms) {
      if (room.walls.any((RoomWall wall) => wall.id == wallId)) return room;
    }
    return null;
  }

  Room? _roomOfOpening(int openingId) {
    for (final Room room in _rooms) {
      for (final RoomWall wall in room.walls) {
        if (wall.openings.any((Opening o) => o.id == openingId)) return room;
      }
    }
    return null;
  }

  void _replaceRoom(int roomId, Room Function(Room room) change) {
    final int index = _rooms.indexWhere((Room room) => room.id == roomId);
    if (index == -1) return;
    _rooms[index] = change(_rooms[index]);
    _emit();
  }

  void _mapWall(int wallId, RoomWall Function(RoomWall wall) change) {
    final Room? room = _roomOfWall(wallId);
    if (room == null) return;
    _replaceRoom(
      room.id,
      (Room current) => _copy(
        current,
        walls: current.walls
            .map((RoomWall wall) => wall.id == wallId ? change(wall) : wall)
            .toList(),
      ),
    );
  }

  List<Opening> _openings(RoomWall wall) => wall.openings;

  Opening _opening(int id, OpeningDraft draft) => Opening(
    id: id,
    kind: draft.kind,
    widthMeters: draft.widthMeters,
    heightMeters: draft.heightMeters,
    distanceFromStartMeters: draft.distanceFromStartMeters,
  );

  Room _copy(
    Room room, {
    String? name,
    double? wallHeightMeters,
    List<RoomWall>? walls,
  }) {
    return Room(
      id: room.id,
      projectId: room.projectId,
      name: name ?? room.name,
      wallHeightMeters: wallHeightMeters ?? room.wallHeightMeters,
      walls: walls ?? room.walls,
      createdAt: room.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  RoomWall _copyWall(RoomWall wall, {List<Opening>? openings}) => RoomWall(
    id: wall.id,
    position: wall.position,
    lengthMeters: wall.lengthMeters,
    turnDegrees: wall.turnDegrees,
    openings: openings ?? wall.openings,
  );

  void _emit() {
    if (!_changes.isClosed) _changes.add(null);
  }
}
