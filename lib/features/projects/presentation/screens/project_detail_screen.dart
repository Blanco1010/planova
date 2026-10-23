import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/utils/formatters.dart';
import '../../../rooms/domain/entities/room.dart';
import '../../../rooms/domain/entities/room_plan.dart';
import '../../../rooms/presentation/providers/room_providers.dart';
import '../../../rooms/presentation/widgets/room_card.dart';
import '../../../rooms/presentation/widgets/room_form_sheet.dart';
import '../../domain/entities/project.dart';
import '../providers/project_providers.dart';
import '../widgets/project_form_sheet.dart';

/// Detalle de un proyecto: sus datos y sus habitaciones.
class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({required this.projectId, super.key});

  final int projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Project?> projectValue = ref.watch(
      projectProvider(projectId),
    );
    final Project? project = projectValue.value;

    if (projectValue.isLoading && project == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (project == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('El proyecto ya no existe')),
      );
    }

    final AsyncValue<List<Room>> roomsValue = ref.watch(
      projectRoomsProvider(projectId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          IconButton(
            onPressed: () => ProjectFormSheet.show(context, project: project),
            tooltip: 'Editar proyecto',
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: roomsValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text('No se pudieron leer las habitaciones: $error'),
          ),
        ),
        data: (List<Room> rooms) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            _ProjectHeader(project: project, rooms: rooms),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calculate_outlined),
                title: const Text('Materiales'),
                subtitle: const Text(
                  'Bloques, mortero, pintura y piso con tus rendimientos',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.materialsPath(projectId)),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.request_quote_outlined),
                title: const Text('Presupuesto'),
                subtitle: const Text('Precios, mano de obra y costo por m²'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.budgetPath(projectId)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Habitaciones',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (rooms.isEmpty)
              Text(
                'Todavía no hay habitaciones. Crea la primera con su ancho y '
                'su largo, y luego ajusta el plano pared por pared.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            for (final Room room in rooms) ...[
              RoomCard(
                room: room,
                onTap: () =>
                    context.push(AppRoutes.roomEditorPath(projectId, room.id)),
                onDelete: () => _confirmDelete(context, ref, room),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewRoomOptions(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva habitación'),
      ),
    );
  }

  /// Las dos maneras de crear una habitación, tras un solo botón.
  Future<void> _showNewRoomOptions(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Medir con la cámara'),
              subtitle: const Text(
                'Apunta al pie de cada esquina y sale el plano',
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push(AppRoutes.scanPath(projectId));
              },
            ),
            ListTile(
              leading: const Icon(Icons.straighten),
              title: const Text('Escribir las medidas'),
              subtitle: const Text('Ancho y largo, y luego ajustas el plano'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                RoomFormSheet.show(context, projectId: projectId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Room room,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Eliminar habitación'),
        content: Text(
          'Se borrará «${room.name}» con su plano, sus paredes y sus vanos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref.read(roomRepositoryProvider).delete(room.id);
  }
}

/// Datos del proyecto y totales de obra que salen de sus habitaciones.
class _ProjectHeader extends StatelessWidget {
  const _ProjectHeader({required this.project, required this.rooms});

  final Project project;
  final List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> details = <String?>[
      project.client,
      project.address,
    ].whereType<String>().toList();

    double floorArea = 0;
    double netWallArea = 0;
    for (final Room room in rooms) {
      final RoomPlan plan = RoomPlan.of(room);
      floorArea += plan.floorAreaM2;
      netWallArea += plan.netWallAreaM2;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (details.isNotEmpty)
              Text(
                details.join(' · '),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            if (project.notes != null) ...[
              const SizedBox(height: 8),
              Text(project.notes!, style: theme.textTheme.bodyMedium),
            ],
            if (details.isNotEmpty || project.notes != null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
            Row(
              children: [
                Expanded(
                  child: _Total(
                    label: rooms.length == 1 ? 'habitación' : 'habitaciones',
                    value: '${rooms.length}',
                  ),
                ),
                Expanded(
                  child: _Total(
                    label: 'área construida',
                    value: Formatters.squareMeters(floorArea),
                  ),
                ),
                Expanded(
                  child: _Total(
                    label: 'muros sin vanos',
                    value: Formatters.squareMeters(netWallArea),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
