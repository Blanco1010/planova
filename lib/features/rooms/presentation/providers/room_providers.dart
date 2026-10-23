import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/drift_room_repository.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';

final Provider<RoomRepository> roomRepositoryProvider =
    Provider<RoomRepository>(
      (ref) => DriftRoomRepository(ref.watch(databaseProvider)),
    );

/// Habitaciones de un proyecto, en vivo.
final projectRoomsProvider = StreamProvider.family<List<Room>, int>(
  (ref, int projectId) =>
      ref.watch(roomRepositoryProvider).watchByProject(projectId),
);

/// Una habitación con sus paredes y vanos, en vivo.
final roomProvider = StreamProvider.family<Room?, int>(
  (ref, int roomId) => ref.watch(roomRepositoryProvider).watchById(roomId),
);
