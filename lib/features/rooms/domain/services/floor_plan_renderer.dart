import 'dart:typed_data';

import '../entities/room.dart';
import '../entities/room_plan.dart';

/// Convierte el plano de una habitación en una imagen, para el PDF.
///
/// Está detrás de un contrato porque pintar en un lienzo de verdad necesita
/// el motor de Flutter; así las pantallas que lo usan se pueden probar.
abstract interface class FloorPlanRenderer {
  /// `null` cuando la habitación todavía no tiene plano que dibujar.
  Future<Uint8List?> toPng({required Room room, required RoomPlan plan});
}
