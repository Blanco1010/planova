import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/projects/presentation/screens/projects_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';

/// Rutas de la app en un solo sitio, para no escribir cadenas sueltas.
abstract final class AppRoutes {
  static const String projects = '/projects';
  static const String settings = '/settings';
}

final Provider<GoRouter> routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.projects,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.projects,
        builder: (BuildContext context, GoRouterState state) =>
            const ProjectsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsScreen(),
      ),
    ],
  );
});
