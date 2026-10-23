import 'package:flutter_test/flutter_test.dart';
import 'package:planova/features/budget/domain/entities/budget_item.dart';
import 'package:planova/features/budget/domain/entities/finish.dart';
import 'package:planova/features/budget/domain/entities/material_kind.dart';
import 'package:planova/features/budget/domain/services/budget_calculator.dart';
import 'package:planova/features/budget/domain/services/finish_calculator.dart';
import 'package:planova/features/materials/domain/entities/material_estimates.dart';
import 'package:planova/features/materials/domain/entities/material_settings.dart';
import 'package:planova/features/materials/domain/services/material_calculator.dart';
import 'package:planova/features/projects/domain/entities/project.dart';
import 'package:planova/features/rooms/domain/entities/room.dart';
import 'package:planova/features/settings/data/services/demo_data_service.dart';

import '../fakes/fake_budget_repository.dart';
import '../fakes/fake_project_repository.dart';
import '../fakes/fake_room_repository.dart';

void main() {
  late FakeProjectRepository projects;
  late FakeRoomRepository rooms;
  late FakeBudgetRepository budget;
  late DemoDataService service;

  setUp(() {
    projects = FakeProjectRepository();
    rooms = FakeRoomRepository();
    budget = FakeBudgetRepository();
    service = DemoDataService(
      projects: projects,
      rooms: rooms,
      budget: budget,
    );
  });

  tearDown(() {
    projects.dispose();
    rooms.dispose();
    budget.dispose();
  });

  test('siembra un proyecto con tres habitaciones medidas', () async {
    final int projectId = await service.seed();

    final List<Project> saved = await projects.watchAll().first;
    expect(saved.single.name, 'Casa de ejemplo');

    final List<Room> salas = await rooms.watchByProject(projectId).first;
    expect(
      salas.map((Room room) => room.name),
      <String>['Sala', 'Cocina', 'Alcoba'],
    );
    expect(salas.every((Room room) => room.walls.length == 4), isTrue);
    // La sala lleva puerta y ventana.
    expect(
      salas.first.walls.fold<int>(
        0,
        (int count, wall) => count + wall.openings.length,
      ),
      2,
    );
  });

  test('deja el presupuesto listo para mirar', () async {
    final int projectId = await service.seed();
    final List<Room> salas = await rooms.watchByProject(projectId).first;

    final Map<MaterialKind, double> prices = await budget
        .watchPrices(projectId)
        .first;
    final List<BudgetItem> items = await budget.watchItems(projectId).first;
    final List<Finish> finishes = await budget
        .watchFinishes(projectId)
        .first;

    expect(prices[MaterialKind.block], 1800);
    expect(items.length, 3);
    expect(finishes.length, 2);

    // Y las cuentas dan un total con sentido.
    final lines = BudgetCalculator.materialLines(
      estimates: MaterialCalculator.estimate(
        surfaces: SurfaceTotals.ofRooms(salas),
        settings: MaterialSettings.defaults,
      ),
      prices: prices,
    );
    final summary = BudgetCalculator.summarize(
      materialLines: lines,
      items: items,
      floorAreaM2: SurfaceTotals.ofRooms(salas).floorAreaM2,
      finishesTotal: FinishCalculator.totalOf(finishes, salas),
    );

    expect(summary.materialsTotal, greaterThan(0));
    expect(summary.laborTotal, closeTo(12 * 90000, 1e-6));
    expect(summary.finishesTotal, greaterThan(0));
    expect(summary.costPerSquareMeter, isNotNull);
  });
}
