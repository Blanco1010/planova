import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_plan.dart';

/// Tarjeta de una habitación en el detalle del proyecto.
class RoomCard extends StatelessWidget {
  const RoomCard({
    required this.room,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final Room room;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final RoomPlan plan = RoomPlan.of(room);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${Formatters.squareMeters(plan.floorAreaM2)} · '
                      '${room.walls.length} paredes · '
                      'perímetro ${Formatters.meters(plan.perimeterMeters)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (!plan.isClosed) ...[
                      const SizedBox(height: 6),
                      _ClosureWarning(gapMeters: plan.closureGapMeters),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: 'Eliminar habitación',
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Aviso de que el recorrido de paredes no vuelve al punto de partida.
class _ClosureWarning extends StatelessWidget {
  const _ClosureWarning({required this.gapMeters});

  final double gapMeters;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.report_problem_outlined,
          size: 16,
          color: theme.colorScheme.error,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'El plano no cierra: faltan ${Formatters.centimeters(gapMeters)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
