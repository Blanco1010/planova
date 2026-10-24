import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/widgets/confirm_delete_dialog.dart';
import '../../../../l10n/app_l10n.dart';
import '../../domain/entities/project.dart';
import '../providers/project_providers.dart';
import '../widgets/project_card.dart';
import '../widgets/project_form_sheet.dart';

/// Pantalla de inicio: los proyectos guardados en el teléfono.
class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppL10n t = AppL10n.of(context);
    final AsyncValue<List<Project>> projects = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planova'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            tooltip: t.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: projects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace _) => _MessageView(
          icon: Icons.error_outline,
          title: t.projectsLoadError,
          message: '$error',
        ),
        data: (List<Project> items) => items.isEmpty
            ? _MessageView(
                icon: Icons.home_work_outlined,
                title: t.projectsEmptyTitle,
                message: t.projectsEmptyBody,
              )
            : _ProjectList(projects: items),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ProjectFormSheet.show(context),
        icon: const Icon(Icons.add),
        label: Text(t.newProject),
      ),
    );
  }
}

class _ProjectList extends ConsumerWidget {
  const _ProjectList({required this.projects});

  final List<Project> projects;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: projects.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        final Project project = projects[index];
        return ProjectCard(
          project: project,
          onTap: () => context.push(AppRoutes.projectPath(project.id)),
          onDelete: () => _confirmDelete(context, ref, project),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) async {
    final AppL10n t = AppL10n.of(context);
    final bool confirmed = await ConfirmDeleteDialog.show(
      context,
      title: t.deleteProject,
      message: t.deleteProjectMessage(project.name),
    );

    if (!confirmed) return;
    await ref.read(projectRepositoryProvider).delete(project.id);
  }
}

/// Mensaje a pantalla completa para la lista vacía y para los errores.
class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
