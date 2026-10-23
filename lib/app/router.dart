import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/budget/presentation/screens/budget_screen.dart';
import '../features/materials/presentation/screens/materials_screen.dart';
import '../features/projects/presentation/screens/project_detail_screen.dart';
import '../features/projects/presentation/screens/projects_screen.dart';
import '../features/room_scan/presentation/screens/scan_entry_screen.dart';
import '../features/rooms/presentation/screens/room_editor_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';

/// Rutas de la app en un solo sitio, para no escribir cadenas sueltas.
abstract final class AppRoutes {
  static const String projects = '/projects';
  static const String settings = '/settings';

  /// Detalle de un proyecto: `/projects/7`.
  static String projectPath(int projectId) => '$projects/$projectId';

  /// Editor de una habitación: `/projects/7/rooms/3`.
  static String roomEditorPath(int projectId, int roomId) =>
      '${projectPath(projectId)}/rooms/$roomId';

  /// Medición con la cámara: `/projects/7/scan`.
  static String scanPath(int projectId) => '${projectPath(projectId)}/scan';

  /// Materiales del proyecto: `/projects/7/materials`.
  static String materialsPath(int projectId) =>
      '${projectPath(projectId)}/materials';

  /// Presupuesto del proyecto: `/projects/7/budget`.
  static String budgetPath(int projectId) => '${projectPath(projectId)}/budget';
}

final Provider<GoRouter> routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.projects,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.projects,
        builder: (BuildContext context, GoRouterState state) =>
            const ProjectsScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: ':projectId',
            builder: (BuildContext context, GoRouterState state) =>
                ProjectDetailScreen(projectId: _idOf(state, 'projectId')),
            routes: <RouteBase>[
              GoRoute(
                path: 'budget',
                builder: (BuildContext context, GoRouterState state) =>
                    BudgetScreen(projectId: _idOf(state, 'projectId')),
              ),
              GoRoute(
                path: 'materials',
                builder: (BuildContext context, GoRouterState state) =>
                    MaterialsScreen(projectId: _idOf(state, 'projectId')),
              ),
              GoRoute(
                path: 'scan',
                builder: (BuildContext context, GoRouterState state) =>
                    ScanEntryScreen(projectId: _idOf(state, 'projectId')),
              ),
              GoRoute(
                path: 'rooms/:roomId',
                builder: (BuildContext context, GoRouterState state) =>
                    RoomEditorScreen(roomId: _idOf(state, 'roomId')),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsScreen(),
      ),
    ],
  );
});

int _idOf(GoRouterState state, String name) =>
    int.tryParse(state.pathParameters[name] ?? '') ?? 0;
