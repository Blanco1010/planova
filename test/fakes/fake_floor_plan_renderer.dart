import 'dart:convert';
import 'dart:typed_data';

import 'package:planova/features/rooms/domain/entities/room.dart';
import 'package:planova/features/rooms/domain/entities/room_plan.dart';
import 'package:planova/features/rooms/domain/services/floor_plan_renderer.dart';

/// Devuelve siempre el mismo PNG mínimo: pintar de verdad necesita el motor
/// de Flutter, que no está disponible dentro de una prueba de pantalla.
class FakeFloorPlanRenderer implements FloorPlanRenderer {
  static final Uint8List onePixelPng = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmM'
    'IQAAAABJRU5ErkJggg==',
  );

  int calls = 0;

  @override
  Future<Uint8List?> toPng({required Room room, required RoomPlan plan}) async {
    calls++;
    return plan.vertices.length < 2 ? null : onePixelPng;
  }
}
