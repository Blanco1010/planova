import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../rooms/domain/entities/room.dart';
import '../../../rooms/presentation/providers/room_providers.dart';
import '../../domain/entities/material_estimates.dart';
import '../../domain/entities/material_settings.dart';
import '../../domain/services/material_calculator.dart';
import '../providers/material_providers.dart';
import '../widgets/material_settings_sheet.dart';

/// Materiales que hacen falta, sacados de lo que miden las habitaciones.
class MaterialsScreen extends ConsumerStatefulWidget {
  const MaterialsScreen({required this.projectId, super.key});

  final int projectId;

  @override
  ConsumerState<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends ConsumerState<MaterialsScreen> {
  /// `null` es el proyecto entero.
  int? _roomId;

  @override
  Widget build(BuildContext context) {
    final List<Room> rooms =
        ref.watch(projectRoomsProvider(widget.projectId)).value ??
        const <Room>[];
    final MaterialSettings settings =
        ref.watch(materialSettingsProvider(widget.projectId)).value ??
        MaterialSettings.defaults;

    final Iterable<Room> selected = _roomId == null
        ? rooms
        : rooms.where((Room room) => room.id == _roomId);
    final SurfaceTotals surfaces = SurfaceTotals.ofRooms(selected);
    final MaterialEstimates estimates = MaterialCalculator.estimate(
      surfaces: surfaces,
      settings: settings,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Materiales'),
        actions: [
          IconButton(
            onPressed: () => MaterialSettingsSheet.show(
              context,
              projectId: widget.projectId,
              settings: settings,
            ),
            tooltip: 'Ajustar rendimientos',
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: rooms.isEmpty
          ? const _NoRooms()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                _RoomPicker(
                  rooms: rooms,
                  selectedId: _roomId,
                  onChanged: (int? id) => setState(() => _roomId = id),
                ),
                const SizedBox(height: 12),
                _SurfacesLine(surfaces: surfaces),
                const SizedBox(height: 16),
                _MasonryCard(estimate: estimates.masonry, settings: settings),
                const SizedBox(height: 12),
                _PaintCard(estimate: estimates.paint, settings: settings),
                const SizedBox(height: 12),
                _FloorCard(estimate: estimates.floor, settings: settings),
                const SizedBox(height: 16),
                Text(
                  'Las cantidades ya traen el desperdicio. Son una '
                  'estimación: compruébalas antes de comprar.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
    );
  }
}

class _RoomPicker extends StatelessWidget {
  const _RoomPicker({
    required this.rooms,
    required this.selectedId,
    required this.onChanged,
  });

  final List<Room> rooms;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Todo el proyecto'),
            selected: selectedId == null,
            onSelected: (_) => onChanged(null),
          ),
          for (final Room room in rooms) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text(room.name),
              selected: selectedId == room.id,
              onSelected: (_) => onChanged(room.id),
            ),
          ],
        ],
      ),
    );
  }
}

class _SurfacesLine extends StatelessWidget {
  const _SurfacesLine({required this.surfaces});

  final SurfaceTotals surfaces;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Text(
      'Muros sin vanos ${Formatters.squareMeters(surfaces.netWallAreaM2)}'
      ' · Piso ${Formatters.squareMeters(surfaces.floorAreaM2)}',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _MasonryCard extends StatelessWidget {
  const _MasonryCard({required this.estimate, required this.settings});

  final MasonryEstimate estimate;
  final MaterialSettings settings;

  @override
  Widget build(BuildContext context) {
    final MasonryParams params = settings.masonry;
    return _EstimateCard(
      icon: Icons.grid_view,
      title: 'Mampostería',
      headline: '${Formatters.units(estimate.blocks)} bloques',
      source:
          'De ${Formatters.squareMeters(estimate.wallAreaM2)} de muros '
          '(no del piso)',
      rows: <(String, String)>[
        ('Mortero de pega', Formatters.cubicMeters(estimate.mortarCubicMeters)),
        ('Cemento', '${Formatters.units(estimate.cementBags)} bultos'),
        ('Arena', Formatters.cubicMeters(estimate.sandCubicMeters)),
      ],
      footnote:
          '${Formatters.squareMeters(estimate.wallAreaM2)} × '
          '${Formatters.decimal(estimate.blocksPerSquareMeter)} bloques/m² + '
          '${Formatters.quantity(params.wastePercent)} % de desperdicio. '
          'Bloque de ${Formatters.centimeters(params.blockLengthMeters)} × '
          '${Formatters.centimeters(params.blockHeightMeters)}, junta de '
          '${Formatters.centimeters(params.jointMeters)}, muro de '
          '${Formatters.centimeters(params.wallThicknessMeters)}.',
    );
  }
}

class _PaintCard extends StatelessWidget {
  const _PaintCard({required this.estimate, required this.settings});

  final PaintEstimate estimate;
  final MaterialSettings settings;

  @override
  Widget build(BuildContext context) {
    final PaintParams params = settings.paint;
    return _EstimateCard(
      icon: Icons.format_paint_outlined,
      title: 'Pintura',
      headline: Formatters.liters(estimate.liters),
      source: params.includeCeiling
          ? 'De ${Formatters.squareMeters(estimate.areaM2)} de muros y cielo '
                'raso'
          : 'De ${Formatters.squareMeters(estimate.areaM2)} de muros '
                '(no del piso)',
      rows: <(String, String)>[
        ('En galones', '${Formatters.decimal(estimate.gallons)} gal'),
        ('Superficie', Formatters.squareMeters(estimate.areaM2)),
      ],
      footnote:
          '${params.coats} manos · ${Formatters.decimal(params.squareMetersPerLiter)}'
          ' m² por litro'
          '${params.includeCeiling ? ' · incluye el cielo raso' : ''}',
    );
  }
}

class _FloorCard extends StatelessWidget {
  const _FloorCard({required this.estimate, required this.settings});

  final FloorEstimate estimate;
  final MaterialSettings settings;

  @override
  Widget build(BuildContext context) {
    final FloorParams params = settings.floor;
    return _EstimateCard(
      icon: Icons.dashboard_outlined,
      title: 'Piso',
      headline: '${Formatters.units(estimate.tiles)} baldosas',
      source: 'De ${Formatters.squareMeters(estimate.areaM2)} de piso',
      rows: <(String, String)>[
        ('Pegante', Formatters.kilograms(estimate.adhesiveKilograms)),
        ('Superficie', Formatters.squareMeters(estimate.areaM2)),
      ],
      footnote:
          '${Formatters.squareMeters(estimate.areaM2)} × '
          '${Formatters.decimal(estimate.tilesPerSquareMeter)} baldosas/m² + '
          '${Formatters.quantity(params.wastePercent)} % de desperdicio. '
          'Baldosa de ${Formatters.centimeters(params.tileLengthMeters)} × '
          '${Formatters.centimeters(params.tileWidthMeters)}.',
    );
  }
}

class _EstimateCard extends StatelessWidget {
  const _EstimateCard({
    required this.icon,
    required this.title,
    required this.headline,
    required this.source,
    required this.rows,
    required this.footnote,
  });

  final IconData icon;
  final String title;
  final String headline;

  /// De qué superficie sale la cuenta: es lo primero que uno se pregunta.
  final String source;

  final List<(String, String)> rows;
  final String footnote;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text(title, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              headline,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              source,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            for (final (String label, String value) in rows)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(label, style: theme.textTheme.bodyMedium),
                    ),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            Text(
              footnote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoRooms extends StatelessWidget {
  const _NoRooms();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calculate_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Aún no hay de dónde calcular',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Los materiales salen de lo que miden las habitaciones. '
              'Crea la primera y vuelve aquí.',
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
