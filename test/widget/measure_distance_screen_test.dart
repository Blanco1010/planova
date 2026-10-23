import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:planova/app/theme/app_theme.dart';
import 'package:planova/core/geometry/point3d.dart';
import 'package:planova/features/room_scan/domain/entities/scan_surface.dart';
import 'package:planova/features/room_scan/presentation/providers/scan_providers.dart';
import 'package:planova/features/room_scan/presentation/screens/measure_distance_screen.dart';

import '../fakes/fake_spatial_scanner.dart';

void main() {
  setUpAll(initializeDateFormatting);

  late FakeSpatialScanner scanner;

  setUp(() => scanner = FakeSpatialScanner());

  Future<void> pumpMeasure(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 2000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [spatialScannerProvider.overrideWithValue(scanner)],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const MeasureDistanceScreen(
            title: 'Medir la altura',
            surface: ScanSurface.wall,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('mide del suelo al techo apuntando a los dos puntos', (
    WidgetTester tester,
  ) async {
    await pumpMeasure(tester);
    expect(scanner.lastSurface, ScanSurface.wall);

    // El pie de la pared.
    scanner.aimAt(const Point3D(2, 0, 3));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Marcar el principio'));
    await tester.pumpAndSettle();

    // Y el borde del techo, 2,52 m más arriba.
    scanner.aimAt(const Point3D(2, 2.52, 3));
    await tester.pumpAndSettle();

    expect(find.text('2,52 m'), findsOneWidget);
    expect(find.text('Usar 2,52 m'), findsOneWidget);
  });

  testWidgets('sin superficie reconocida no deja empezar', (
    WidgetTester tester,
  ) async {
    await pumpMeasure(tester);

    expect(
      find.text('Mueve el teléfono despacio para reconocer la superficie'),
      findsOneWidget,
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });

  testWidgets('se puede empezar de nuevo', (WidgetTester tester) async {
    await pumpMeasure(tester);
    scanner.aimAt(const Point3D(0, 0, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Marcar el principio'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Empezar de nuevo'));
    await tester.pumpAndSettle();

    expect(find.text('Marcar el principio'), findsOneWidget);
  });
}
