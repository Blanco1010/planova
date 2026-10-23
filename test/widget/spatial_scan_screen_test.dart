import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:planova/app/theme/app_theme.dart';
import 'package:planova/core/geometry/point3d.dart';
import 'package:planova/features/room_scan/domain/entities/scan_surface.dart';
import 'package:planova/features/room_scan/presentation/providers/scan_providers.dart';
import 'package:planova/features/room_scan/presentation/screens/spatial_scan_screen.dart';
import 'package:planova/features/rooms/domain/entities/room.dart';
import 'package:planova/features/rooms/presentation/providers/room_providers.dart';

import '../fakes/fake_room_repository.dart';
import '../fakes/fake_spatial_scanner.dart';

/// Las cuatro esquinas de una sala de 4 × 3, en el suelo (y = 0).
const List<Point3D> _room = <Point3D>[
  Point3D(0, 0, 0),
  Point3D(4, 0, 0),
  Point3D(4, 0, 3),
  Point3D(0, 0, 3),
];

void main() {
  setUpAll(initializeDateFormatting);

  late FakeSpatialScanner scanner;
  late FakeRoomRepository rooms;

  setUp(() {
    scanner = FakeSpatialScanner();
    rooms = FakeRoomRepository();
  });

  tearDown(() => rooms.dispose());

  Future<void> pumpScan(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final GoRouter router = GoRouter(
      initialLocation: '/scan',
      routes: <RouteBase>[
        GoRoute(
          path: '/scan',
          builder: (BuildContext context, GoRouterState state) =>
              const SpatialScanScreen(projectId: 1),
        ),
        GoRoute(
          path: '/projects/1/rooms/:roomId',
          builder: (BuildContext context, GoRouterState state) =>
              Scaffold(body: Text('editor ${state.pathParameters['roomId']}')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          spatialScannerProvider.overrideWithValue(scanner),
          roomRepositoryProvider.overrideWithValue(rooms),
        ],
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> aimAt(WidgetTester tester, Point3D world) async {
    scanner.aimAt(world);
    await tester.pumpAndSettle();
  }

  testWidgets('sin superficie reconocida no deja marcar', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);

    expect(
      find.text('Mueve el teléfono despacio para reconocer el suelo'),
      findsOneWidget,
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });

  testWidgets('enseña la distancia que mide el aparato', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);
    scanner.aimAt(const Point3D(2, 0, 1), distanceMeters: 2.35);
    await tester.pumpAndSettle();

    expect(find.text('2,35 m'), findsOneWidget);
  });

  testWidgets('marcar las esquinas y cerrar guarda la habitación', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);

    for (final Point3D corner in _room) {
      await aimAt(tester, corner);
      await tester.tap(find.text('Marcar esquina'));
      await tester.pumpAndSettle();
    }
    expect(find.text('4 esquinas'), findsOneWidget);

    // De vuelta a la primera esquina: se engancha y cierra.
    await aimAt(tester, _room.first);
    expect(
      find.text('Estás en la esquina 1: cierra la habitación'),
      findsOneWidget,
    );

    await tester.tap(find.text('Cerrar habitación'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Sala ARCore');
    await tester.tap(find.text('Crear habitación'));
    await tester.pumpAndSettle();

    final List<Room> saved = await rooms.watchByProject(1).first;
    expect(saved.single.name, 'Sala ARCore');
    expect(saved.single.walls.map((wall) => wall.lengthMeters), [
      closeTo(4, 0.01),
      closeTo(3, 0.01),
      closeTo(4, 0.01),
      closeTo(3, 0.01),
    ]);
  });

  testWidgets('se puede quitar la última esquina', (WidgetTester tester) async {
    await pumpScan(tester);
    await aimAt(tester, _room.first);
    await tester.tap(find.text('Marcar esquina'));
    await tester.pumpAndSettle();
    expect(find.text('1 esquina'), findsOneWidget);

    await tester.tap(find.byTooltip('Quitar la última'));
    await tester.pumpAndSettle();

    expect(find.text('0 esquinas'), findsOneWidget);
  });

  testWidgets('cada pared medida se ve en la barra', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);

    await aimAt(tester, _room[0]);
    await tester.tap(find.text('Marcar esquina'));
    await tester.pumpAndSettle();
    await aimAt(tester, _room[1]);
    await tester.tap(find.text('Marcar esquina'));
    await tester.pumpAndSettle();

    expect(find.text('Pared 1 · 4,00 m'), findsOneWidget);

    // Y al deshacer, la pared desaparece con la esquina.
    await tester.tap(find.byTooltip('Quitar la última'));
    await tester.pumpAndSettle();
    expect(find.text('Pared 1 · 4,00 m'), findsNothing);
  });

  testWidgets('para el plano, la cámara mira al suelo', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);

    expect(scanner.lastSurface, ScanSurface.floor);
  });
}
