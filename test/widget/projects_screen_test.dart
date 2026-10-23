import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:planova/app/theme/app_theme.dart';
import 'package:planova/features/projects/domain/entities/project_draft.dart';
import 'package:planova/features/projects/presentation/providers/project_providers.dart';
import 'package:planova/features/projects/presentation/screens/projects_screen.dart';

import '../fakes/fake_project_repository.dart';

void main() {
  setUpAll(initializeDateFormatting);

  late FakeProjectRepository repository;

  setUp(() => repository = FakeProjectRepository());
  tearDown(() => repository.dispose());

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [projectRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const ProjectsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('sin proyectos muestra el mensaje de lista vacía', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester);

    expect(find.text('Todavía no hay proyectos'), findsOneWidget);
  });

  testWidgets('crear un proyecto lo deja en la lista', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester);

    await tester.tap(find.text('Nuevo proyecto'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).first,
      'Casa de dos pisos',
    );
    await tester.tap(find.text('Crear proyecto'));
    await tester.pumpAndSettle();

    expect(find.text('Casa de dos pisos'), findsOneWidget);
    expect(find.text('Todavía no hay proyectos'), findsNothing);
  });

  testWidgets('eliminar pide confirmación y quita el proyecto', (
    WidgetTester tester,
  ) async {
    await repository.create(const ProjectDraft(name: 'Cocina'));
    await pumpScreen(tester);
    expect(find.text('Cocina'), findsOneWidget);

    await tester.tap(find.byTooltip('Eliminar proyecto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Cocina'), findsNothing);
    expect(find.text('Todavía no hay proyectos'), findsOneWidget);
  });
}
