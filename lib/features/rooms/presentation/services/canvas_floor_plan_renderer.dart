import 'dart:typed_data';

import '../../domain/entities/room.dart';
import '../../domain/entities/room_plan.dart';
import '../../domain/services/floor_plan_renderer.dart';
import '../widgets/floor_plan_view.dart';

/// Pinta el plano con el mismo pintor que la pantalla.
class CanvasFloorPlanRenderer implements FloorPlanRenderer {
  const CanvasFloorPlanRenderer();

  @override
  Future<Uint8List?> toPng({required Room room, required RoomPlan plan}) =>
      renderFloorPlanPng(room: room, plan: plan);
}
