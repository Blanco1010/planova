import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_l10n.dart';
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
    final AppL10n t = AppL10n.of(context);
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
        title: Text(t.materials),
        actions: [
          IconButton(
            onPressed: () => MaterialSettingsSheet.show(
              context,
              projectId: widget.projectId,
              settings: settings,
            ),
            tooltip: t.tuneRates,
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
                  t.materialsNote,
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
            label: Text(AppL10n.of(context).wholeProject),
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
      AppL10n.of(context).surfacesLine(
        Formatters.squareMeters(surfaces.netWallAreaM2),
        Formatters.squareMeters(surfaces.floorAreaM2),
      ),
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
    final AppL10n t = AppL10n.of(context);
    final MasonryParams params = settings.masonry;
    return _EstimateCard(
      icon: Icons.grid_view,
      title: t.masonry,
      headline: t.piecesCount(Formatters.units(estimate.blocks)),
      source: t.fromWallsNotFloor(
        Formatters.squareMeters(estimate.wallAreaM2),
      ),
      rows: <(String, String)>[
        (t.bedMortar, Formatters.cubicMeters(estimate.mortarCubicMeters)),
        (t.materialCement, t.cementBags(Formatters.units(estimate.cementBags))),
        (t.materialSand, Formatters.cubicMeters(estimate.sandCubicMeters)),
      ],
      footnote: t.masonryNote(
        Formatters.squareMeters(estimate.wallAreaM2),
        Formatters.decimal(estimate.blocksPerSquareMeter),
        Formatters.quantity(params.wastePercent),
        Formatters.centimeters(params.blockLengthMeters),
        Formatters.centimeters(params.blockHeightMeters),
        Formatters.centimeters(params.jointMeters),
        Formatters.centimeters(params.wallThicknessMeters),
      ),
    );
  }
}

class _PaintCard extends StatelessWidget {
  const _PaintCard({required this.estimate, required this.settings});

  final PaintEstimate estimate;
  final MaterialSettings settings;

  @override
  Widget build(BuildContext context) {
    final AppL10n t = AppL10n.of(context);
    final PaintParams params = settings.paint;
    return _EstimateCard(
      icon: Icons.format_paint_outlined,
      title: t.paint,
      headline: Formatters.liters(estimate.liters),
      source: params.includeCeiling
          ? t.fromWallsAndCeiling(Formatters.squareMeters(estimate.areaM2))
          : t.fromWallsNotFloor(Formatters.squareMeters(estimate.areaM2)),
      rows: <(String, String)>[
        (t.inGallons, t.gallonsValue(Formatters.decimal(estimate.gallons))),
        (t.surface, Formatters.squareMeters(estimate.areaM2)),
      ],
      footnote: t.paintNote(
        '${params.coats}',
        Formatters.decimal(params.squareMetersPerLiter),
        params.includeCeiling ? t.includesCeiling : '',
      ),
    );
  }
}

class _FloorCard extends StatelessWidget {
  const _FloorCard({required this.estimate, required this.settings});

  final FloorEstimate estimate;
  final MaterialSettings settings;

  @override
  Widget build(BuildContext context) {
    final AppL10n t = AppL10n.of(context);
    final FloorParams params = settings.floor;
    return _EstimateCard(
      icon: Icons.dashboard_outlined,
      title: t.floor,
      headline: t.tilesCount(Formatters.units(estimate.tiles)),
      source: t.fromFloorArea(Formatters.squareMeters(estimate.areaM2)),
      rows: <(String, String)>[
        (t.materialAdhesive, Formatters.kilograms(estimate.adhesiveKilograms)),
        (t.surface, Formatters.squareMeters(estimate.areaM2)),
      ],
      footnote: t.floorNote(
        Formatters.squareMeters(estimate.areaM2),
        Formatters.decimal(estimate.tilesPerSquareMeter),
        Formatters.quantity(params.wastePercent),
        Formatters.centimeters(params.tileLengthMeters),
        Formatters.centimeters(params.tileWidthMeters),
      ),
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
    final AppL10n t = AppL10n.of(context);
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
              t.nothingToCalculate,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              t.nothingToCalculateBody,
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
