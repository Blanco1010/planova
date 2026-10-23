import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/opening.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_drafts.dart';
import '../../domain/entities/room_wall.dart';
import '../../domain/repositories/room_repository.dart';
import '../mappers/room_mapper.dart';

/// Implementación de [RoomRepository] sobre SQLite con Drift.
///
/// Habitación, paredes y vanos se leen en una sola consulta con joins y se
/// arman en memoria, para que un cambio en cualquier nivel emita una sola vez.
class DriftRoomRepository implements RoomRepository {
  const DriftRoomRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Room>> watchByProject(int projectId) {
    final query = _db.select(_db.rooms).join(_joins())
      ..where(_db.rooms.projectId.equals(projectId))
      ..orderBy(_ordering());
    return query.watch().map(_assemble);
  }

  @override
  Stream<Room?> watchById(int roomId) {
    final query = _db.select(_db.rooms).join(_joins())
      ..where(_db.rooms.id.equals(roomId))
      ..orderBy(_ordering());
    return query.watch().map((List<TypedResult> rows) {
      final List<Room> rooms = _assemble(rows);
      return rooms.isEmpty ? null : rooms.first;
    });
  }

  @override
  Future<int> createFromWalls(
    int projectId,
    RoomDraft draft,
    List<WallDraft> walls,
  ) {
    return _db.transaction(() async {
      final DateTime now = DateTime.now();
      final int roomId = await _db
          .into(_db.rooms)
          .insert(
            RoomsCompanion.insert(
              projectId: projectId,
              name: draft.name,
              wallHeightMeters: Value(draft.wallHeightMeters),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      for (int i = 0; i < walls.length; i++) {
        await _db
            .into(_db.roomWalls)
            .insert(
              RoomWallsCompanion.insert(
                roomId: roomId,
                position: i,
                lengthMeters: walls[i].lengthMeters,
                turnDegrees: Value(i == 0 ? 0 : walls[i].turnDegrees),
              ),
            );
      }
      return roomId;
    });
  }

  @override
  Future<void> update(int roomId, RoomDraft draft) async {
    await (_db.update(_db.rooms)..where((t) => t.id.equals(roomId))).write(
      RoomsCompanion(
        name: Value(draft.name),
        wallHeightMeters: Value(draft.wallHeightMeters),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> delete(int roomId) async {
    await (_db.delete(_db.rooms)..where((t) => t.id.equals(roomId))).go();
  }

  @override
  Future<int> addWall(int roomId, WallDraft draft) {
    return _db.transaction(() async {
      final List<RoomWallRow> existing = await (_db.select(
        _db.roomWalls,
      )..where((t) => t.roomId.equals(roomId))).get();

      return _db
          .into(_db.roomWalls)
          .insert(
            RoomWallsCompanion.insert(
              roomId: roomId,
              position: existing.length,
              lengthMeters: draft.lengthMeters,
              turnDegrees: Value(draft.turnDegrees),
            ),
          );
    });
  }

  @override
  Future<void> updateWall(int wallId, WallDraft draft) async {
    await (_db.update(_db.roomWalls)..where((t) => t.id.equals(wallId))).write(
      RoomWallsCompanion(
        lengthMeters: Value(draft.lengthMeters),
        turnDegrees: Value(draft.turnDegrees),
      ),
    );
  }

  @override
  Future<void> deleteWall(int wallId) async {
    await _db.transaction(() async {
      final RoomWallRow? wall = await (_db.select(
        _db.roomWalls,
      )..where((t) => t.id.equals(wallId))).getSingleOrNull();
      if (wall == null) return;

      await (_db.delete(_db.roomWalls)..where((t) => t.id.equals(wallId))).go();

      // Las posiciones deben quedar seguidas: 0, 1, 2…
      final List<RoomWallRow> remaining =
          await (_db.select(_db.roomWalls)
                ..where((t) => t.roomId.equals(wall.roomId))
                ..orderBy([(t) => OrderingTerm.asc(t.position)]))
              .get();
      for (int i = 0; i < remaining.length; i++) {
        if (remaining[i].position == i) continue;
        await (_db.update(_db.roomWalls)
              ..where((t) => t.id.equals(remaining[i].id)))
            .write(RoomWallsCompanion(position: Value(i)));
      }
    });
  }

  @override
  Future<int> addOpening(int wallId, OpeningDraft draft) {
    return _db
        .into(_db.roomOpenings)
        .insert(
          RoomOpeningsCompanion.insert(
            wallId: wallId,
            kind: draft.kind,
            widthMeters: draft.widthMeters,
            heightMeters: draft.heightMeters,
            distanceFromStartMeters: Value(draft.distanceFromStartMeters),
          ),
        );
  }

  @override
  Future<void> updateOpening(int openingId, OpeningDraft draft) async {
    await (_db.update(
      _db.roomOpenings,
    )..where((t) => t.id.equals(openingId))).write(
      RoomOpeningsCompanion(
        kind: Value(draft.kind),
        widthMeters: Value(draft.widthMeters),
        heightMeters: Value(draft.heightMeters),
        distanceFromStartMeters: Value(draft.distanceFromStartMeters),
      ),
    );
  }

  @override
  Future<void> deleteOpening(int openingId) async {
    await (_db.delete(
      _db.roomOpenings,
    )..where((t) => t.id.equals(openingId))).go();
  }

  List<Join<HasResultSet, dynamic>> _joins() {
    return <Join<HasResultSet, dynamic>>[
      leftOuterJoin(
        _db.roomWalls,
        _db.roomWalls.roomId.equalsExp(_db.rooms.id),
      ),
      leftOuterJoin(
        _db.roomOpenings,
        _db.roomOpenings.wallId.equalsExp(_db.roomWalls.id),
      ),
    ];
  }

  List<OrderingTerm> _ordering() {
    return <OrderingTerm>[
      OrderingTerm.asc(_db.rooms.createdAt),
      OrderingTerm.asc(_db.rooms.id),
      OrderingTerm.asc(_db.roomWalls.position),
      OrderingTerm.asc(_db.roomOpenings.distanceFromStartMeters),
    ];
  }

  /// Arma las habitaciones a partir de las filas del join.
  List<Room> _assemble(List<TypedResult> rows) {
    final Map<int, RoomRow> roomRows = <int, RoomRow>{};
    final Map<int, List<int>> wallIdsByRoom = <int, List<int>>{};
    final Map<int, RoomWallRow> wallRows = <int, RoomWallRow>{};
    final Map<int, List<Opening>> openingsByWall = <int, List<Opening>>{};

    for (final TypedResult row in rows) {
      final RoomRow roomRow = row.readTable(_db.rooms);
      roomRows.putIfAbsent(roomRow.id, () => roomRow);

      final RoomWallRow? wallRow = row.readTableOrNull(_db.roomWalls);
      if (wallRow == null) continue;
      if (!wallRows.containsKey(wallRow.id)) {
        wallRows[wallRow.id] = wallRow;
        (wallIdsByRoom[roomRow.id] ??= <int>[]).add(wallRow.id);
      }

      final RoomOpeningRow? openingRow = row.readTableOrNull(_db.roomOpenings);
      if (openingRow == null) continue;
      (openingsByWall[wallRow.id] ??= <Opening>[]).add(openingRow.toEntity());
    }

    return roomRows.values
        .map(
          (RoomRow roomRow) => _toRoom(
            roomRow,
            wallIdsByRoom[roomRow.id] ?? const <int>[],
            wallRows,
            openingsByWall,
          ),
        )
        .toList(growable: false);
  }

  Room _toRoom(
    RoomRow roomRow,
    List<int> wallIds,
    Map<int, RoomWallRow> wallRows,
    Map<int, List<Opening>> openingsByWall,
  ) {
    final List<RoomWall> walls = <RoomWall>[];
    for (final int wallId in wallIds) {
      final RoomWallRow wallRow = wallRows[wallId]!;
      walls.add(
        RoomWall(
          id: wallRow.id,
          position: wallRow.position,
          lengthMeters: wallRow.lengthMeters,
          turnDegrees: wallRow.turnDegrees,
          openings: openingsByWall[wallId] ?? const <Opening>[],
        ),
      );
    }

    return Room(
      id: roomRow.id,
      projectId: roomRow.projectId,
      name: roomRow.name,
      wallHeightMeters: roomRow.wallHeightMeters,
      walls: walls,
      createdAt: roomRow.createdAt,
      updatedAt: roomRow.updatedAt,
    );
  }
}
