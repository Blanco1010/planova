import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:planova/core/utils/money.dart';
import 'package:planova/features/budget/data/services/budget_pdf_builder.dart';
import 'package:planova/features/budget/domain/entities/budget_item.dart';
import 'package:planova/features/budget/domain/entities/budget_summary.dart';
import 'package:planova/features/budget/domain/entities/material_kind.dart';
import 'package:planova/features/budget/domain/services/budget_calculator.dart';
import 'package:planova/features/budget/domain/services/finish_calculator.dart';
import 'package:planova/features/materials/domain/entities/material_estimates.dart';
import 'package:planova/features/materials/domain/entities/material_settings.dart';
import 'package:planova/features/materials/domain/services/material_calculator.dart';
import 'package:planova/features/projects/domain/entities/project.dart';
import 'package:planova/features/rooms/domain/entities/room.dart';
import 'package:planova/features/rooms/domain/entities/room_drafts.dart';
import 'package:planova/features/rooms/domain/entities/room_wall.dart';

final Project _project = Project(
  id: 1,
  name: 'Casa López',
  client: 'Ana López',
  address: 'Vereda El Carmen',
  createdAt: DateTime(2026, 10, 22),
  updatedAt: DateTime(2026, 10, 22),
);

Room _room(String name, double width, double length) {
  final List<WallDraft> walls = rectangleWalls(
    widthMeters: width,
    lengthMeters: length,
  );
  return Room(
    id: 1,
    projectId: 1,
    name: name,
    wallHeightMeters: 2.4,
    walls: <RoomWall>[
      for (int i = 0; i < walls.length; i++)
        RoomWall(
          id: i + 1,
          position: i,
          lengthMeters: walls[i].lengthMeters,
          turnDegrees: i == 0 ? 0 : walls[i].turnDegrees,
        ),
    ],
    createdAt: DateTime(2026, 10, 22),
    updatedAt: DateTime(2026, 10, 22),
  );
}

Future<Uint8List> _buildSample() {
  final List<Room> rooms = <Room>[_room('Sala', 4, 3)];
  final MaterialEstimates estimates = MaterialCalculator.estimate(
    surfaces: SurfaceTotals.ofRooms(rooms),
    settings: MaterialSettings.defaults,
  );
  final List<MaterialLine> lines = BudgetCalculator.materialLines(
    estimates: estimates,
    prices: const <MaterialKind, double>{
      MaterialKind.block: 1800,
      MaterialKind.cement: 32000,
      MaterialKind.tile: 2500,
    },
  );
  const List<BudgetItem> items = <BudgetItem>[
    BudgetItem(
      id: 1,
      projectId: 1,
      category: BudgetCategory.labor,
      description: 'Maestro de obra',
      unit: 'día',
      quantity: 12,
      unitPrice: 90000,
    ),
  ];

  return BudgetPdfBuilder.build(
    money: MoneyFormat.cop,
    project: _project,
    scopeLabel: 'Todo el proyecto',
    rooms: rooms,
    roomPlans: const <int, Uint8List>{},
    materialLines: lines,
    items: items,
    finishes: const <FinishEstimate>[],
    summary: BudgetCalculator.summarize(
      materialLines: lines,
      items: items,
      floorAreaM2: 12,
    ),
    generatedAt: DateTime(2026, 10, 22),
    compress: false,
  );
}

void main() {
  setUpAll(initializeDateFormatting);

  test('devuelve un PDF con contenido', () async {
    final Uint8List bytes = await _buildSample();

    expect(utf8.decode(bytes.take(4).toList()), '%PDF');
    expect(bytes.length, greaterThan(2000));
  });

  test('lleva las cifras y los nombres del presupuesto', () async {
    // Sin comprimir, el texto dibujado se puede leer en los bytes.
    final String content = latin1.decode(
      await _buildSample(),
      allowInvalid: true,
    );

    expect(content, contains('Casa L'));
    expect(content, contains('Maestro'));
    expect(content, contains('765.000'));
    expect(content, contains('2.278.000'));
    expect(content, contains('sin'));
  });

  test('el nombre del archivo sale del proyecto', () {
    expect(
      BudgetPdfBuilder.fileNameFor(_project),
      'presupuesto-casa-l-pez.pdf',
    );
    expect(
      BudgetPdfBuilder.fileNameFor(
        Project(
          id: 2,
          name: '   ',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ),
      'presupuesto-obra.pdf',
    );
  });

  test('se arma igual sin habitaciones ni partidas', () async {
    final Uint8List bytes = await BudgetPdfBuilder.build(
      money: MoneyFormat.cop,
      project: _project,
      scopeLabel: 'Todo el proyecto',
      rooms: const <Room>[],
      roomPlans: const <int, Uint8List>{},
      materialLines: const <MaterialLine>[],
      items: const <BudgetItem>[],
      finishes: const <FinishEstimate>[],
      summary: BudgetCalculator.summarize(
        materialLines: const <MaterialLine>[],
        items: const <BudgetItem>[],
        floorAreaM2: 0,
      ),
      generatedAt: DateTime(2026, 10, 22),
    );

    expect(utf8.decode(bytes.take(4).toList()), '%PDF');
  });
}
