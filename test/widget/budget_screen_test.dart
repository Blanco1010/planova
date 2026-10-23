import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:planova/app/theme/app_theme.dart';
import 'package:planova/features/budget/domain/entities/budget_item.dart';
import 'package:planova/features/budget/presentation/providers/budget_providers.dart';
import 'package:planova/features/budget/presentation/screens/budget_screen.dart';
import 'package:planova/features/materials/presentation/providers/material_providers.dart';
import 'package:planova/features/projects/domain/entities/project_draft.dart';
import 'package:planova/features/projects/presentation/providers/project_providers.dart';
import 'package:planova/features/rooms/domain/entities/room_drafts.dart';
import 'package:planova/features/rooms/presentation/providers/room_providers.dart';

import '../fakes/fake_budget_exporter.dart';
import '../fakes/fake_floor_plan_renderer.dart';
import '../fakes/fake_budget_repository.dart';
import '../fakes/fake_project_repository.dart';
import '../fakes/fake_material_settings_repository.dart';
import '../fakes/fake_room_repository.dart';

void main() {
  setUpAll(initializeDateFormatting);

  late FakeRoomRepository rooms;
  late FakeMaterialSettingsRepository settings;
  late FakeBudgetRepository budget;
  late FakeProjectRepository projects;
  late FakeBudgetExporter exporter;
  late FakeFloorPlanRenderer planRenderer;

  setUp(() async {
    rooms = FakeRoomRepository();
    settings = FakeMaterialSettingsRepository();
    budget = FakeBudgetRepository();
    exporter = FakeBudgetExporter();
    planRenderer = FakeFloorPlanRenderer();
    projects = FakeProjectRepository();
    await projects.create(const ProjectDraft(name: 'Casa López'));
  });

  tearDown(() {
    rooms.dispose();
    settings.dispose();
    budget.dispose();
    projects.dispose();
  });

  Future<void> pumpBudget(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 3000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          roomRepositoryProvider.overrideWithValue(rooms),
          materialSettingsRepositoryProvider.overrideWithValue(settings),
          budgetRepositoryProvider.overrideWithValue(budget),
          projectRepositoryProvider.overrideWithValue(projects),
          budgetExporterProvider.overrideWithValue(exporter),
          floorPlanRendererProvider.overrideWithValue(planRenderer),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const BudgetScreen(projectId: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Una sala de 4 × 3: 425 bloques, 4 bultos, 122 baldosas.
  Future<void> addRoom() {
    return rooms.createFromWalls(
      1,
      const RoomDraft(name: 'Sala', wallHeightMeters: 2.4),
      rectangleWalls(widthMeters: 4, lengthMeters: 3),
    );
  }

  testWidgets('sin habitaciones lo dice y el total es cero', (
    WidgetTester tester,
  ) async {
    await pumpBudget(tester);

    expect(find.text('Todavía no hay habitaciones medidas.'), findsOneWidget);
    expect(find.text(r'$ 0'), findsWidgets);
  });

  testWidgets('enseña las cantidades del plano esperando precio', (
    WidgetTester tester,
  ) async {
    await addRoom();
    await pumpBudget(tester);

    expect(find.text('Bloques'), findsOneWidget);
    expect(find.text('425 unid · toca para ponerle precio'), findsOneWidget);
    expect(find.textContaining('Faltan 6 precios'), findsOneWidget);
  });

  testWidgets('ponerle precio a los bloques calcula su subtotal', (
    WidgetTester tester,
  ) async {
    await addRoom();
    await pumpBudget(tester);

    await tester.tap(find.text('Bloques'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '1800');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    // 425 × 1.800.
    expect(find.text(r'$ 765.000'), findsWidgets);
    expect(find.text('425 unid × \$ 1.800'), findsOneWidget);
    expect(find.textContaining('Faltan 5 precios'), findsOneWidget);
  });

  testWidgets('una partida de mano de obra entra en su capítulo', (
    WidgetTester tester,
  ) async {
    await addRoom();
    await pumpBudget(tester);

    // El primero es el de las partidas; el segundo, el de acabados.
    await tester.tap(find.widgetWithText(TextButton, 'Añadir').first);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(SegmentedButton<BudgetCategory>),
        matching: find.text('Mano de obra'),
      ),
    );
    await tester.enterText(
      find.ancestor(
        of: find.text('Descripción'),
        matching: find.byType(TextFormField),
      ),
      'Maestro de obra',
    );
    await tester.enterText(
      find.ancestor(
        of: find.text('Cantidad'),
        matching: find.byType(TextFormField),
      ),
      '12',
    );
    await tester.enterText(
      find.ancestor(
        of: find.text('Precio por unidad'),
        matching: find.byType(TextFormField),
      ),
      '90.000',
    );
    await tester.tap(find.text('Añadir partida'));
    await tester.pumpAndSettle();

    // 12 × 90.000 = 1.080.000, y va a mano de obra, no a materiales.
    expect(find.text('Maestro de obra'), findsOneWidget);
    expect(find.text(r'$ 1.080.000'), findsWidgets);
    expect(find.text('Mano de obra · 12 unid × \$ 90.000'), findsOneWidget);
  });

  testWidgets('exportar entrega un PDF con el nombre del proyecto', (
    WidgetTester tester,
  ) async {
    await addRoom();
    await pumpBudget(tester);

    await tester.tap(find.byTooltip('Exportar en PDF'));
    await tester.pumpAndSettle();

    expect(exporter.lastFileName, 'presupuesto-casa-l-pez.pdf');
    expect(exporter.lastBytes, isNotNull);
    expect(exporter.lastBytes!.length, greaterThan(2000));
    // Y el plano de la habitación fue al documento.
    expect(planRenderer.calls, 1);
  });

  testWidgets('un acabado toma las paredes marcadas y suma al total', (
    WidgetTester tester,
  ) async {
    await addRoom();
    await pumpBudget(tester);

    await tester.tap(find.widgetWithText(TextButton, 'Añadir').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.ancestor(
        of: find.text('Qué se hace'),
        matching: find.byType(TextFormField),
      ),
      'Pintura vinilo',
    );
    await tester.enterText(
      find.ancestor(
        of: find.text('Precio por m²'),
        matching: find.byType(TextFormField),
      ),
      '12.000',
    );

    // La sala es de 4 × 3 y 2,40 de alto: la pared 2 son 7,20 m².
    await tester.tap(find.text('Pared 2 · 7,20 m²'));
    await tester.pumpAndSettle();
    expect(find.text('Marcado: 7,20 m²'), findsOneWidget);

    await tester.tap(find.text('Añadir acabado'));
    await tester.pumpAndSettle();

    expect(find.text('Pintura vinilo'), findsOneWidget);
    expect(find.text('1 pared · 7,20 m² × \$ 12.000'), findsOneWidget);
    // 7,20 × 12.000 = 86.400, y entra en el total.
    expect(find.text(r'$ 86.400'), findsWidgets);
  });
}
