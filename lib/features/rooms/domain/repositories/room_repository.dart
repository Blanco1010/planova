import '../entities/room.dart';
import '../entities/room_drafts.dart';

/// Acceso a las habitaciones de un proyecto, con sus paredes y vanos.
abstract interface class RoomRepository {
  /// Habitaciones del proyecto, en el orden en que se crearon.
  Stream<List<Room>> watchByProject(int projectId);

  /// Una habitación concreta; `null` si ya no existe.
  Stream<Room?> watchById(int roomId);

  /// Crea una habitación con el recorrido de paredes que se le pase, venga
  /// de las medidas escritas a mano o de un escaneo.
  Future<int> createFromWalls(
    int projectId,
    RoomDraft draft,
    List<WallDraft> walls,
  );

  Future<void> update(int roomId, RoomDraft draft);

  Future<void> delete(int roomId);

  /// Añade una pared al final del recorrido y devuelve su `id`.
  Future<int> addWall(int roomId, WallDraft draft);

  Future<void> updateWall(int wallId, WallDraft draft);

  Future<void> deleteWall(int wallId);

  Future<int> addOpening(int wallId, OpeningDraft draft);

  Future<void> updateOpening(int openingId, OpeningDraft draft);

  Future<void> deleteOpening(int openingId);
}
