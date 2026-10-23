import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:planova/app/theme/app_theme.dart';
import 'package:planova/core/geometry/point2d.dart';
import 'package:planova/core/measuring/sighting_math.dart';
import 'package:planova/features/room_scan/domain/entities/device_aim.dart';
import 'package:planova/features/room_scan/presentation/providers/scan_providers.dart';
import 'package:planova/features/room_scan/presentation/screens/room_scan_screen.dart';
import 'package:planova/features/rooms/domain/entities/room.dart';
import 'package:planova/features/rooms/presentation/providers/room_providers.dart';

import '../fakes/fake_orientation_tracker.dart';
import '../fakes/fake_room_repository.dart';

/// Inclinación con la que una esquina queda a [distance] metros, con la
/// altura de teléfono que la app supone mientras no se calibre.
double _pitchFor(double distance) =>
    math.atan(SightingMath.assumedPhoneHeightMeters / distance);

/// Las cuatro esquinas de una habitación de 4 × 3 vistas desde el centro:
/// todas a 2,50 m, girando siempre hacia la derecha.
const List<double> _cornerTurns = <double>[0.6435, 2.4981, 3.7851, 5.6397];

/// Lo que medirían los sensores apuntando desde [from] al pie de [target].
DeviceAim _aimFrom(Point2D from, Point2D target) {
  final double dx = target.x - from.x;
  final double dy = target.y - from.y;
  final double distance = math.sqrt(dx * dx + dy * dy);
  return DeviceAim(
    pitchRadians: _pitchFor(distance),
    turnRadians: math.atan2(dy, dx),
  );
}

void main() {
  setUpAll(initializeDateFormatting);

  late FakeOrientationTracker tracker;
  late FakeRoomRepository rooms;

  setUp(() {
    tracker = FakeOrientationTracker();
    rooms = FakeRoomRepository();
  });

  tearDown(() {
    tracker.dispose();
    rooms.dispose();
  });

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
              const RoomScanScreen(projectId: 1),
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
          orientationTrackerProvider.overrideWithValue(tracker),
          roomRepositoryProvider.overrideWithValue(rooms),
          cameraControllerProvider.overrideWith((ref) async => null),
        ],
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> aimAt(
    WidgetTester tester, {
    required double distance,
    required double turn,
  }) async {
    tracker.emit(
      DeviceAim(pitchRadians: _pitchFor(distance), turnRadians: turn),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('sin sensores no deja marcar esquinas', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);

    expect(find.text('Esperando a los sensores…'), findsOneWidget);
    expect(find.text('Sin calibrar'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });

  testWidgets('enseña la distancia a la que apunta el teléfono', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);
    await aimAt(tester, distance: 2.5, turn: 0);

    expect(find.text('2,50 m'), findsOneWidget);
  });

  testWidgets('con el teléfono casi horizontal avisa en vez de medir', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);
    tracker.emit(DeviceAim(pitchRadians: 3 * math.pi / 180, turnRadians: 0));
    await tester.pumpAndSettle();

    expect(find.text('Apunta más abajo, al pie de la pared'), findsOneWidget);
  });

  testWidgets('marcar las cuatro esquinas guarda la habitación medida', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);

    for (final double turn in _cornerTurns) {
      await aimAt(tester, distance: 2.5, turn: turn);
      await tester.tap(find.text('Marcar esquina'));
      await tester.pumpAndSettle();
    }
    expect(find.text('4 esquinas'), findsOneWidget);

    await tester.tap(find.text('Terminar sin cerrar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Sala medida');
    await tester.tap(find.text('Crear habitación'));
    await tester.pumpAndSettle();

    final List<Room> saved = await rooms.watchByProject(1).first;
    expect(saved.length, 1);
    expect(saved.first.name, 'Sala medida');
    expect(saved.first.walls.map((wall) => wall.lengthMeters), [
      closeTo(4, 0.01),
      closeTo(3, 0.01),
      closeTo(4, 0.01),
      closeTo(3, 0.01),
    ]);
    // Y se abre el plano de lo escaneado para corregirlo.
    expect(find.text('editor 1'), findsOneWidget);
  });

  testWidgets('se puede quitar la última esquina marcada', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);
    await aimAt(tester, distance: 2.5, turn: 0);
    await tester.tap(find.text('Marcar esquina'));
    await tester.pumpAndSettle();
    expect(find.text('1 esquina'), findsOneWidget);

    await tester.tap(find.byTooltip('Quitar la última'));
    await tester.pumpAndSettle();

    expect(find.text('0 esquinas'), findsOneWidget);
  });

  testWidgets('volver a la primera esquina cierra la habitación', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);

    for (final double turn in _cornerTurns) {
      await aimAt(tester, distance: 2.5, turn: turn);
      await tester.tap(find.text('Marcar esquina'));
      await tester.pumpAndSettle();
    }

    // Se sigue girando a la derecha hasta volver a la esquina 1.
    await aimAt(tester, distance: 2.5, turn: _cornerTurns.first + 2 * math.pi);

    expect(
      find.text('Estás en la esquina 1: cierra la habitación'),
      findsOneWidget,
    );
    expect(find.text('Marcar esquina'), findsNothing);

    await tester.tap(find.text('Cerrar habitación'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Sala cerrada');
    await tester.tap(find.text('Crear habitación'));
    await tester.pumpAndSettle();

    final List<Room> saved = await rooms.watchByProject(1).first;
    // Cerrar no añade una quinta esquina: siguen siendo cuatro paredes.
    expect(saved.single.walls.length, 4);
    expect(saved.single.walls.map((wall) => wall.lengthMeters), [
      closeTo(4, 0.01),
      closeTo(3, 0.01),
      closeTo(4, 0.01),
      closeTo(3, 0.01),
    ]);
  });

  testWidgets('estando lejos de la esquina 1 se sigue marcando', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);

    for (final double turn in _cornerTurns) {
      await aimAt(tester, distance: 2.5, turn: turn);
      await tester.tap(find.text('Marcar esquina'));
      await tester.pumpAndSettle();
    }
    await aimAt(tester, distance: 2.5, turn: 3.0);

    expect(find.text('Cerrar habitación'), findsNothing);
    expect(find.text('Marcar esquina'), findsOneWidget);
  });

  testWidgets('se puede caminar: el plano no se mueve al reubicarse', (
    WidgetTester tester,
  ) async {
    // Una habitación de 4 × 3 medida desde dos sitios distintos.
    const Point2D c1 = Point2D(0, 0);
    const Point2D c2 = Point2D(4, 0);
    const Point2D c3 = Point2D(4, 3);
    const Point2D c4 = Point2D(0, 3);
    const Point2D desdeAqui = Point2D(0.5, 1.5);
    const Point2D yDesdeAlla = Point2D(3.5, 1.5);

    await pumpScan(tester);

    for (final Point2D corner in <Point2D>[c1, c2]) {
      tracker.emit(_aimFrom(desdeAqui, corner));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Marcar esquina'));
      await tester.pumpAndSettle();
    }

    // Se camina al otro lado y se vuelve a situar apuntando a la esquina 2.
    await tester.tap(find.text('Me moví'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '2'));
    await tester.pumpAndSettle();
    expect(
      find.text('Apunta al pie de la esquina 2 y fija tu posición'),
      findsOneWidget,
    );

    tracker.emit(_aimFrom(yDesdeAlla, c2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Estoy aquí'));
    await tester.pumpAndSettle();

    // Y se siguen marcando las que faltan desde el sitio nuevo.
    for (final Point2D corner in <Point2D>[c3, c4]) {
      tracker.emit(_aimFrom(yDesdeAlla, corner));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Marcar esquina'));
      await tester.pumpAndSettle();
    }

    tracker.emit(_aimFrom(yDesdeAlla, c1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar habitación'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Sala caminada');
    await tester.tap(find.text('Crear habitación'));
    await tester.pumpAndSettle();

    final List<Room> saved = await rooms.watchByProject(1).first;
    expect(saved.single.walls.map((wall) => wall.lengthMeters), [
      closeTo(4, 0.01),
      closeTo(3, 0.01),
      closeTo(4, 0.01),
      closeTo(3, 0.01),
    ]);
  });

  testWidgets('calibrar con el techo deja la medida en su sitio', (
    WidgetTester tester,
  ) async {
    // Teléfono a 1,60 m, pared a 3 m, techo a 2,50 m.
    await pumpScan(tester);

    await tester.tap(find.text('Sin calibrar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '2,50');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    tracker.emit(DeviceAim(pitchRadians: math.atan(1.6 / 3), turnRadians: 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fijar el suelo'));
    await tester.pumpAndSettle();

    expect(find.text('Ahora al techo de esa misma pared'), findsOneWidget);
    tracker.emit(DeviceAim(pitchRadians: -math.atan(0.9 / 3), turnRadians: 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fijar el techo'));
    await tester.pumpAndSettle();

    expect(find.text('Calibrado · 1,60 m'), findsOneWidget);

    // Y a partir de ahí las distancias salen con esa altura.
    tracker.emit(DeviceAim(pitchRadians: math.atan(1.6 / 4), turnRadians: 0));
    await tester.pumpAndSettle();
    expect(find.text('4,00 m'), findsOneWidget);
  });

  testWidgets('si las dos miradas no cuadran, lo dice y repite', (
    WidgetTester tester,
  ) async {
    await pumpScan(tester);

    await tester.tap(find.text('Sin calibrar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    tracker.emit(DeviceAim(pitchRadians: math.atan(1.5 / 3), turnRadians: 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fijar el suelo'));
    await tester.pumpAndSettle();

    // Mirando otra vez hacia abajo: eso no es el techo.
    await tester.tap(find.text('Fijar el techo'));
    await tester.pumpAndSettle();

    expect(find.textContaining('No cuadra'), findsOneWidget);
    expect(find.text('Fijar el suelo'), findsOneWidget);
    expect(find.text('Sin calibrar'), findsOneWidget);
  });
}
