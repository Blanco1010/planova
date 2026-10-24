import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:planova/app/theme/app_theme.dart';
import 'package:planova/l10n/app_l10n.dart';
import 'package:planova/features/materials/presentation/providers/material_providers.dart';
import 'package:planova/features/materials/presentation/screens/materials_screen.dart';
import 'package:planova/features/rooms/domain/entities/room_drafts.dart';
import 'package:planova/features/rooms/presentation/providers/room_providers.dart';

import '../fakes/fake_material_settings_repository.dart';
import '../fakes/fake_room_repository.dart';

void main() {
  setUpAll(initializeDateFormatting);

  late FakeRoomRepository rooms;
  late FakeMaterialSettingsRepository settings;

  setUp(() {
    rooms = FakeRoomRepository();
    settings = FakeMaterialSettingsRepository();
  });

  tearDown(() {
    rooms.dispose();
    settings.dispose();
  });

  Future<void> pumpMaterials(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 3000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          roomRepositoryProvider.overrideWithValue(rooms),
          materialSettingsRepositoryProvider.overrideWithValue(settings),
        ],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          theme: AppTheme.light,
          home: const MaterialsScreen(projectId: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Una sala de 4 × 3 y 2,40 m de alto: 33,60 m² de muro y 12 m² de piso.
  Future<void> addRoom({String name = 'Sala'}) {
    return rooms.createFromWalls(
      1,
      RoomDraft(name: name, wallHeightMeters: 2.4),
      rectangleWalls(widthMeters: 4, lengthMeters: 3),
    );
  }

  testWidgets('sin habitaciones no hay nada que calcular', (
    WidgetTester tester,
  ) async {
    await pumpMaterials(tester);

    expect(find.text('Aún no hay de dónde calcular'), findsOneWidget);
  });

  testWidgets('calcula bloques, pintura y piso de la obra', (
    WidgetTester tester,
  ) async {
    await addRoom();
    await pumpMaterials(tester);

    expect(
      find.text('Muros sin vanos 33,60 m² · Piso 12,00 m²'),
      findsOneWidget,
    );
    // 33,60 m² × 12,04 bloques/m² × 1,05 de desperdicio.
    expect(find.text('425 piezas'), findsOneWidget);
    expect(find.text('4 bultos'), findsOneWidget);
    // 33,60 × 2 manos / 10 m² por litro × 1,05.
    expect(find.text('7,06 L'), findsOneWidget);
    // 12 m² × 9,18 baldosas/m² × 1,10.
    expect(find.text('122 baldosas'), findsOneWidget);
    expect(find.text('66,00 kg'), findsOneWidget);
    // Y queda claro de dónde sale cada cuenta.
    expect(find.text('De 33,60 m² de muros (no del piso)'), findsNWidgets(2));
    expect(find.text('De 12,00 m² de piso'), findsOneWidget);
    expect(
      find.textContaining('33,60 m² × 12,04 piezas/m² + 5 % de desperdicio'),
      findsOneWidget,
    );
  });

  testWidgets('se puede mirar una sola habitación', (
    WidgetTester tester,
  ) async {
    await addRoom();
    await addRoom(name: 'Cocina');
    await pumpMaterials(tester);

    // Las dos juntas: el doble de piso.
    expect(find.textContaining('Piso 24,00 m²'), findsOneWidget);

    await tester.tap(find.text('Cocina'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Piso 12,00 m²'), findsOneWidget);
    expect(find.text('122 baldosas'), findsOneWidget);
  });

  testWidgets('cambiar las manos de pintura recalcula los litros', (
    WidgetTester tester,
  ) async {
    await addRoom();
    await pumpMaterials(tester);
    expect(find.text('7,06 L'), findsOneWidget);

    await tester.tap(find.byTooltip('Ajustar rendimientos'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.ancestor(
        of: find.text('Manos'),
        matching: find.byType(TextFormField),
      ),
      '3',
    );
    await tester.tap(find.text('Guardar rendimientos'));
    await tester.pumpAndSettle();

    // 33,60 × 3 / 10 × 1,05.
    expect(find.text('10,58 L'), findsOneWidget);
  });
}
