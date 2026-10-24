import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_l10n.dart';
import '../../domain/entities/opening.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_drafts.dart';
import '../../domain/entities/room_plan.dart';
import '../../domain/entities/room_wall.dart';
import '../providers/room_providers.dart';
import '../widgets/floor_plan_view.dart';
import '../widgets/room_form_sheet.dart';
import '../widgets/wall_form_sheet.dart';

/// Editor del plano de una habitación: el dibujo y la lista de paredes.
class RoomEditorScreen extends ConsumerStatefulWidget {
  const RoomEditorScreen({required this.roomId, super.key});

  final int roomId;

  @override
  ConsumerState<RoomEditorScreen> createState() => _RoomEditorScreenState();
}

class _RoomEditorScreenState extends ConsumerState<RoomEditorScreen> {
  int? _selectedWallId;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Room?> roomValue = ref.watch(roomProvider(widget.roomId));
    final Room? room = roomValue.value;

    if (roomValue.isLoading && room == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (room == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(AppL10n.of(context).roomGone)),
      );
    }

    final AppL10n t = AppL10n.of(context);
    final RoomPlan plan = RoomPlan.of(room);

    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
        actions: [
          IconButton(
            onPressed: () => RoomFormSheet.show(
              context,
              projectId: room.projectId,
              room: room,
            ),
            tooltip: t.editRoom,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Card(
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: FloorPlanView(
                room: room,
                plan: plan,
                selectedWallId: _selectedWallId,
                onWallTap: (RoomWall wall) => _openWall(room, wall),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _PlanSummary(room: room, plan: plan),
          if (!plan.isClosed) ...[
            const SizedBox(height: 12),
            _ClosureBanner(gapMeters: plan.closureGapMeters),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  t.walls,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton.icon(
                onPressed: () => _addWall(room),
                icon: const Icon(Icons.add),
                label: Text(t.addWall),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (room.walls.isEmpty)
            Text(
              t.wallsEmptyBody,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          for (final RoomWall wall in room.walls)
            _WallTile(
              wall: wall,
              selected: wall.id == _selectedWallId,
              onTap: () => _openWall(room, wall),
            ),
        ],
      ),
    );
  }

  Future<void> _openWall(Room room, RoomWall wall) async {
    setState(() => _selectedWallId = wall.id);
    await WallFormSheet.show(context, roomId: room.id, wallId: wall.id);
    if (!mounted) return;
    setState(() => _selectedWallId = null);
  }

  /// Añade una pared de 3 m y abre su hoja para ajustar la medida.
  Future<void> _addWall(Room room) async {
    final int wallId = await ref
        .read(roomRepositoryProvider)
        .addWall(room.id, const WallDraft(lengthMeters: 3));
    if (!mounted) return;

    setState(() => _selectedWallId = wallId);
    await WallFormSheet.show(context, roomId: room.id, wallId: wallId);
    if (!mounted) return;
    setState(() => _selectedWallId = null);
  }
}

/// Las cuatro cifras que resumen el plano.
class _PlanSummary extends StatelessWidget {
  const _PlanSummary({required this.room, required this.plan});

  final Room room;
  final RoomPlan plan;

  @override
  Widget build(BuildContext context) {
    final AppL10n t = AppL10n.of(context);

    return Row(
      // Sin este aire, «Muros sin vanos» y «Altura» quedan pegados.
      spacing: 12,
      children: [
        Expanded(
          child: _Stat(
            label: t.floorArea,
            value: Formatters.squareMeters(plan.floorAreaM2),
          ),
        ),
        Expanded(
          child: _Stat(
            label: t.perimeter,
            value: Formatters.meters(plan.perimeterMeters),
          ),
        ),
        Expanded(
          child: _Stat(
            label: t.netWallAreaTitle,
            value: Formatters.squareMeters(plan.netWallAreaM2),
          ),
        ),
        Expanded(
          child: _Stat(
            label: t.height,
            value: Formatters.meters(room.wallHeightMeters),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

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

class _ClosureBanner extends StatelessWidget {
  const _ClosureBanner({required this.gapMeters});

  final double gapMeters;

  @override
  Widget build(BuildContext context) {
    final AppL10n t = AppL10n.of(context);
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.report_problem_outlined,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              t.planOpenWarning(Formatters.centimeters(gapMeters)),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WallTile extends StatelessWidget {
  const _WallTile({
    required this.wall,
    required this.selected,
    required this.onTap,
  });

  final RoomWall wall;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppL10n t = AppL10n.of(context);
    final String turn = wall.position == 0
        ? t.wallStart
        : t.wallTurn(Formatters.degrees(wall.turnDegrees));

    return ListTile(
      selected: selected,
      selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.08),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        '${wall.name(t)} · ${Formatters.meters(wall.lengthMeters)}',
      ),
      subtitle: Text(
        wall.openings.isEmpty
            ? turn
            : '$turn · ${_openingsSummary(t, wall.openings)}',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  String _openingsSummary(AppL10n t, List<Opening> openings) {
    final int doors = openings
        .where((Opening o) => o.kind == OpeningKind.door)
        .length;
    final int windows = openings.length - doors;
    final List<String> parts = <String>[];
    if (doors > 0) parts.add(t.doorCount(doors));
    if (windows > 0) parts.add(t.windowCount(windows));
    return parts.length == 2
        ? t.listAnd(parts.first, parts.last)
        : parts.join();
  }
}
