import '../../../budget/domain/entities/budget_item.dart';
import '../../../budget/domain/entities/finish.dart';
import '../../../budget/domain/entities/material_kind.dart';
import '../../../budget/domain/repositories/budget_repository.dart';
import '../../../projects/domain/entities/project_draft.dart';
import '../../../projects/domain/repositories/project_repository.dart';
import '../../../rooms/domain/entities/opening.dart';
import '../../../rooms/domain/entities/room.dart';
import '../../../rooms/domain/entities/room_drafts.dart';
import '../../../rooms/domain/entities/room_wall.dart';
import '../../../rooms/domain/repositories/room_repository.dart';

/// Siembra un proyecto de ejemplo con todo dentro.
///
/// Sirve para probar el presupuesto y el PDF en un emulador, donde no hay
/// cámara ni sensores con los que medir nada.
class DemoDataService {
  /// Como se llama el proyecto que se siembra.
  static const String projectName = 'Casa de ejemplo';

  const DemoDataService({
    required this.projects,
    required this.rooms,
    required this.budget,
  });

  final ProjectRepository projects;
  final RoomRepository rooms;
  final BudgetRepository budget;

  /// Crea el proyecto y devuelve su `id`.
  Future<int> seed() async {
    final int projectId = await projects.create(
      const ProjectDraft(
        name: projectName,
        client: 'Ana López',
        address: 'Vereda El Carmen',
        notes: 'Proyecto de prueba para ver el presupuesto y el PDF.',
      ),
    );

    final Room sala = await _createRoom(
      projectId,
      name: 'Sala',
      width: 4.2,
      length: 3.4,
      height: 2.5,
      door: true,
      window: true,
    );
    final Room cocina = await _createRoom(
      projectId,
      name: 'Cocina',
      width: 3,
      length: 2.4,
      height: 2.5,
      door: true,
    );
    await _createRoom(
      projectId,
      name: 'Alcoba',
      width: 3.5,
      length: 3,
      height: 2.5,
      door: true,
      window: true,
    );

    await _priceMaterials(projectId);
    await _addItems(projectId);
    await _addFinishes(projectId, sala: sala, cocina: cocina);

    return projectId;
  }

  Future<Room> _createRoom(
    int projectId, {
    required String name,
    required double width,
    required double length,
    required double height,
    bool door = false,
    bool window = false,
  }) async {
    final int roomId = await rooms.createFromWalls(
      projectId,
      RoomDraft(name: name, wallHeightMeters: height),
      rectangleWalls(widthMeters: width, lengthMeters: length),
    );

    final Room room = (await rooms.watchById(roomId).first)!;
    if (door) {
      await rooms.addOpening(
        room.walls.first.id,
        const OpeningDraft(
          kind: OpeningKind.door,
          widthMeters: 0.9,
          heightMeters: 2.05,
          distanceFromStartMeters: 0.6,
        ),
      );
    }
    if (window) {
      await rooms.addOpening(
        room.walls[1].id,
        const OpeningDraft(
          kind: OpeningKind.window,
          widthMeters: 1.4,
          heightMeters: 1.2,
          distanceFromStartMeters: 0.8,
        ),
      );
    }

    return (await rooms.watchById(roomId).first)!;
  }

  Future<void> _priceMaterials(int projectId) async {
    const Map<MaterialKind, double> prices = <MaterialKind, double>{
      MaterialKind.block: 1800,
      MaterialKind.cement: 32000,
      MaterialKind.sand: 95000,
      MaterialKind.tile: 2500,
    };
    for (final MapEntry<MaterialKind, double> price in prices.entries) {
      await budget.savePrice(projectId, price.key, price.value);
    }
  }

  Future<void> _addItems(int projectId) async {
    await budget.addItem(
      projectId,
      const BudgetItemDraft(
        category: BudgetCategory.labor,
        description: 'Maestro de obra',
        unit: 'día',
        quantity: 12,
        unitPrice: 90000,
      ),
    );
    await budget.addItem(
      projectId,
      const BudgetItemDraft(
        category: BudgetCategory.material,
        description: 'Varilla de 1/2"',
        unit: 'unid',
        quantity: 40,
        unitPrice: 38000,
      ),
    );
    await budget.addItem(
      projectId,
      const BudgetItemDraft(
        category: BudgetCategory.other,
        description: 'Transporte de material',
        unit: 'viaje',
        quantity: 2,
        unitPrice: 80000,
      ),
    );
  }

  Future<void> _addFinishes(
    int projectId, {
    required Room sala,
    required Room cocina,
  }) async {
    await budget.addFinish(
      projectId,
      FinishDraft(
        description: 'Pintura vinilo',
        unitPrice: 12000,
        surfaces: <FinishSurface>[
          for (final RoomWall wall in sala.walls)
            FinishSurface(roomId: sala.id, wallId: wall.id),
        ],
      ),
    );
    await budget.addFinish(
      projectId,
      FinishDraft(
        description: 'Enchape de piso',
        unitPrice: 48000,
        surfaces: <FinishSurface>[FinishSurface(roomId: cocina.id)],
      ),
    );
  }
}
