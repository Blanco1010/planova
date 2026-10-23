import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:planova/app/theme/app_theme.dart';
import 'package:planova/features/rooms/domain/entities/room_drafts.dart';
import 'package:planova/features/rooms/presentation/providers/room_providers.dart';
import 'package:planova/features/rooms/presentation/screens/room_editor_screen.dart';

import '../fakes/fake_room_repository.dart';

void main() {
  setUpAll(initializeDateFormatting);

  late FakeRoomRepository repository;
  late int roomId;

  setUp(() async {
    repository = FakeRoomRepository();
    roomId = await repository.createFromWalls(
      1,
      const RoomDraft(name: 'Sala', wallHeightMeters: 2.4),
      rectangleWalls(widthMeters: 4, lengthMeters: 3),
    );
  });

  tearDown(() => repository.dispose());

  Future<void> pumpEditor(WidgetTester tester) async {
    // Pantalla alta para que la lista entera quepa y se construya.
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [roomRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: RoomEditorScreen(roomId: roomId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('muestra el área y las paredes de la habitación', (
    WidgetTester tester,
  ) async {
    await pumpEditor(tester);

    expect(find.text('12,00 m²'), findsOneWidget);
    expect(find.text('14,00 m'), findsOneWidget);
    expect(find.text('Pared 1 · 4,00 m'), findsOneWidget);
    expect(find.text('Pared 4 · 3,00 m'), findsOneWidget);
  });

  testWidgets('cambiar el largo de una pared recalcula el área', (
    WidgetTester tester,
  ) async {
    await pumpEditor(tester);

    await tester.tap(find.text('Pared 2 · 3,00 m'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '5');
    await tester.tap(find.text('Guardar pared'));
    await tester.pumpAndSettle();

    expect(find.text('Pared 2 · 5,00 m'), findsOneWidget);
    expect(find.text('20,00 m²'), findsOneWidget);
  });

  testWidgets('añadir un vano lo descuenta de la superficie de muros', (
    WidgetTester tester,
  ) async {
    await pumpEditor(tester);
    // 14 m de perímetro × 2,40 m de alto, sin vanos todavía.
    expect(find.text('33,60 m²'), findsOneWidget);

    await tester.tap(find.text('Pared 1 · 4,00 m'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Añadir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Añadir vano'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar pared'));
    await tester.pumpAndSettle();

    // Puerta de 0,80 × 2,05 m: 33,60 − 1,64.
    expect(find.text('31,96 m²'), findsOneWidget);
  });
}
