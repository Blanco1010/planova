import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:planova/app/theme/app_theme.dart';
import 'package:planova/features/room_scan/domain/entities/device_aim.dart';
import 'package:planova/features/room_scan/presentation/providers/scan_providers.dart';
import 'package:planova/features/room_scan/presentation/screens/room_scan_screen.dart';
import 'package:planova/features/rooms/domain/entities/room.dart';
import 'package:planova/features/rooms/presentation/providers/room_providers.dart';
import 'package:planova/features/settings/presentation/providers/settings_providers.dart';

import '../fakes/fake_orientation_tracker.dart';
import '../fakes/fake_room_repository.dart';
import '../fakes/fake_settings_repository.dart';

/// Inclinación con la que una esquina queda a [distance] metros, sosteniendo
/// el teléfono a 1,50 m del suelo.
double _pitchFor(double distance) => math.atan(1.5 / distance);

/// Las cuatro esquinas de una habitación de 4 × 3 vistas desde el centro:
/// todas a 2,50 m, girando siempre hacia la derecha.
const List<double> _cornerTurns = <double>[0.6435, 2.4981, 3.7851, 5.6397];

void main() {
  setUpAll(initializeDateFormatting);

  late FakeOrientationTracker tracker;
  late FakeRoomRepository rooms;
  late FakeSettingsRepository settings;

  setUp(() {
    tracker = FakeOrientationTracker();
    rooms = FakeRoomRepository();
    settings = FakeSettingsRepository();
  });

  tearDown(() {
    tracker.dispose();
    rooms.dispose();
    settings.dispose();
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
          settingsRepositoryProvider.overrideWithValue(settings),
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

    await tester.tap(find.text('Terminar'));
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
}
