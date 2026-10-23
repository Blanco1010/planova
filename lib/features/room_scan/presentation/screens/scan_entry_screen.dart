import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../rooms/domain/entities/room.dart';
import '../../../rooms/domain/entities/room_drafts.dart';
import '../../../rooms/presentation/providers/room_providers.dart';
import '../../domain/entities/scan_surface.dart';
import '../providers/scan_providers.dart';
import 'measure_distance_screen.dart';
import 'room_scan_screen.dart';
import 'spatial_scan_screen.dart';

/// Elige con qué se mide según lo que tenga el teléfono, y qué se va a medir.
///
/// Con ARCore se pregunta antes si se va al piso o a una pared: el aparato
/// busca mucho mejor cuando sabe qué mirar.
class ScanEntryScreen extends ConsumerWidget {
  const ScanEntryScreen({required this.projectId, super.key});

  final int projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> arCore = ref.watch(arCoreProvider);

    return arCore.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.darkNavy,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (Object error, StackTrace _) =>
          RoomScanScreen(projectId: projectId),
      data: (bool available) => available
          ? _SurfaceChooser(projectId: projectId)
          : RoomScanScreen(projectId: projectId),
    );
  }
}

/// ¿Qué vamos a medir?
class _SurfaceChooser extends ConsumerWidget {
  const _SurfaceChooser({required this.projectId});

  final int projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Medir con la cámara')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Text('¿Qué vas a medir?', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'La cámara busca mejor cuando sabe qué mirar.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          _Option(
            icon: Icons.crop_square,
            title: ScanSurface.floor.label,
            subtitle:
                'Marcas las esquinas en el suelo y sale el plano de la '
                'habitación, con todas sus paredes.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    SpatialScanScreen(projectId: projectId),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Option(
            icon: Icons.height,
            title: ScanSurface.wall.label,
            subtitle:
                'Mides del suelo al techo apuntando a los dos puntos, y esa '
                'altura queda guardada en la habitación que elijas.',
            onTap: () => _measureHeight(context, ref),
          ),
        ],
      ),
    );
  }

  /// Mide del suelo al techo y le pone esa altura a una habitación.
  Future<void> _measureHeight(BuildContext context, WidgetRef ref) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final double? meters = await MeasureDistanceScreen.show(
      context,
      title: 'Medir la altura',
      surface: ScanSurface.wall,
    );
    if (meters == null || !context.mounted) return;

    final List<Room> rooms =
        ref.read(projectRoomsProvider(projectId)).value ?? const <Room>[];
    if (rooms.isEmpty) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Mide ${Formatters.meters(meters)}. Crea una habitación para '
            'usarla.',
          ),
        ),
      );
      return;
    }

    final Room? room = rooms.length == 1
        ? rooms.single
        : await _pickRoom(context, rooms);
    if (room == null) return;

    await ref
        .read(roomRepositoryProvider)
        .update(room.id, RoomDraft(name: room.name, wallHeightMeters: meters));
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Listo: «${room.name}» queda con ${Formatters.meters(meters)} '
          'de altura.',
        ),
      ),
    );
  }

  Future<Room?> _pickRoom(BuildContext context, List<Room> rooms) {
    return showDialog<Room>(
      context: context,
      builder: (BuildContext dialogContext) => SimpleDialog(
        title: const Text('¿A qué habitación?'),
        children: <Widget>[
          for (final Room room in rooms)
            SimpleDialogOption(
              onPressed: () => Navigator.of(dialogContext).pop(room),
              child: Text(
                '${room.name} · ahora '
                '${Formatters.meters(room.wallHeightMeters)}',
              ),
            ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
