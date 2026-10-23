import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/money_input.dart';
import '../../../../core/widgets/number_prompt_dialog.dart';
import '../../../materials/domain/entities/material_estimates.dart';
import '../../../materials/domain/entities/material_settings.dart';
import '../../../materials/domain/services/material_calculator.dart';
import '../../../materials/presentation/providers/material_providers.dart';
import '../../../projects/domain/entities/project.dart';
import '../../../projects/presentation/providers/project_providers.dart';
import '../../../rooms/domain/entities/room.dart';
import '../../../rooms/domain/entities/room_plan.dart';
import '../../../rooms/presentation/providers/room_providers.dart';
import '../../domain/entities/budget_item.dart';
import '../../domain/entities/finish.dart';
import '../../domain/entities/budget_summary.dart';
import '../../domain/entities/material_kind.dart';
import '../../data/services/budget_pdf_builder.dart';
import '../../domain/services/budget_calculator.dart';
import '../../domain/services/finish_calculator.dart';
import '../providers/budget_providers.dart';
import '../widgets/budget_item_sheet.dart';
import '../widgets/finish_sheet.dart';

/// Presupuesto de la obra: precio a lo calculado, más lo que se escribe.
class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({required this.projectId, super.key});

  final int projectId;

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  /// `null` es el proyecto entero.
  int? _roomId;

  @override
  Widget build(BuildContext context) {
    final int projectId = widget.projectId;
    final Project? project = ref.watch(projectProvider(projectId)).value;
    final List<Room> rooms =
        ref.watch(projectRoomsProvider(projectId)).value ?? const <Room>[];
    final MaterialSettings settings =
        ref.watch(materialSettingsProvider(projectId)).value ??
        MaterialSettings.defaults;
    final Map<MaterialKind, double> prices =
        ref.watch(materialPricesProvider(projectId)).value ??
        const <MaterialKind, double>{};
    final List<BudgetItem> allItems =
        ref.watch(budgetItemsProvider(projectId)).value ?? const <BudgetItem>[];
    final List<Finish> allFinishes =
        ref.watch(finishesProvider(projectId)).value ?? const <Finish>[];

    final Iterable<Room> scopedRooms = _roomId == null
        ? rooms
        : rooms.where((Room room) => room.id == _roomId);
    final List<BudgetItem> items = _roomId == null
        ? allItems
        : allItems
              .where((BudgetItem item) => item.roomId == _roomId)
              .toList(growable: false);
    final List<Finish> finishes = _roomId == null
        ? allFinishes
        : FinishCalculator.within(allFinishes, scopedRooms);

    final SurfaceTotals surfaces = SurfaceTotals.ofRooms(scopedRooms);
    final MaterialEstimates estimates = MaterialCalculator.estimate(
      surfaces: surfaces,
      settings: settings,
    );
    final List<MaterialLine> lines = BudgetCalculator.materialLines(
      estimates: estimates,
      prices: prices,
    );
    final List<MaterialLine> available = BudgetCalculator.availableMaterials(
      estimates: estimates,
      prices: prices,
    );
    final BudgetSummary summary = BudgetCalculator.summarize(
      materialLines: lines,
      items: items,
      floorAreaM2: surfaces.floorAreaM2,
      finishesTotal: FinishCalculator.totalOf(finishes, scopedRooms),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuesto'),
        actions: [
          IconButton(
            onPressed: project == null
                ? null
                : () => _export(
                    project: project,
                    rooms: scopedRooms.toList(growable: false),
                    lines: lines,
                    items: items,
                    finishes: <FinishEstimate>[
                      for (final Finish finish in finishes)
                        FinishCalculator.estimate(finish, scopedRooms),
                    ],
                    summary: summary,
                  ),
            tooltip: 'Exportar en PDF',
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          if (rooms.isNotEmpty) ...[
            _RoomPicker(
              rooms: rooms,
              selectedId: _roomId,
              onChanged: (int? id) => setState(() => _roomId = id),
            ),
            const SizedBox(height: 16),
          ],
          _MaterialsCard(
            lines: lines,
            onTapLine: _materialOptions,
            onAdd: available.isEmpty ? null : () => _addMaterial(available),
          ),
          const SizedBox(height: 12),
          _ItemsCard(
            items: items,
            onAdd: () => BudgetItemSheet.show(
              context,
              projectId: projectId,
              roomId: _roomId,
            ),
            onTapItem: (BudgetItem item) => BudgetItemSheet.show(
              context,
              projectId: projectId,
              roomId: _roomId,
              item: item,
            ),
          ),
          const SizedBox(height: 12),
          _FinishesCard(
            finishes: finishes,
            rooms: scopedRooms.toList(growable: false),
            onAdd: () => FinishSheet.show(context, projectId: projectId),
            // Se edita el acabado entero, no el recorte que se esté mirando:
            // si no, guardarlo le borraría las paredes de las demás piezas.
            onTapFinish: (Finish finish) => FinishSheet.show(
              context,
              projectId: projectId,
              finish: allFinishes.firstWhere(
                (Finish whole) => whole.id == finish.id,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _SummaryCard(summary: summary),
        ],
      ),
    );
  }

  /// Arma el PDF y lo entrega a la hoja de compartir del teléfono.
  Future<void> _export({
    required Project project,
    required List<Room> rooms,
    required List<MaterialLine> lines,
    required List<BudgetItem> items,
    required List<FinishEstimate> finishes,
    required BudgetSummary summary,
  }) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String scopeLabel = _roomId == null
        ? 'Todo el proyecto'
        : rooms.firstOrNull?.name ?? 'Una habitación';

    try {
      final Map<int, Uint8List> plans = <int, Uint8List>{};
      for (final Room room in rooms) {
        final Uint8List? png = await ref
            .read(floorPlanRendererProvider)
            .toPng(room: room, plan: RoomPlan.of(room));
        if (png != null) plans[room.id] = png;
      }

      final Uint8List bytes = await BudgetPdfBuilder.build(
        project: project,
        scopeLabel: scopeLabel,
        rooms: rooms,
        roomPlans: plans,
        materialLines: lines,
        items: items,
        finishes: finishes,
        summary: summary,
        generatedAt: DateTime.now(),
      );
      await ref
          .read(budgetExporterProvider)
          .share(bytes: bytes, fileName: BudgetPdfBuilder.fileNameFor(project));
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo crear el PDF: $error')),
      );
    }
  }

  /// Elige cuál de los materiales que faltan se mete en el presupuesto.
  Future<void> _addMaterial(List<MaterialLine> available) async {
    final MaterialLine? chosen = await showModalBottomSheet<MaterialLine>(
      context: context,
      builder: (BuildContext sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '¿Qué material entra?',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
              ),
            ),
            for (final MaterialLine line in available)
              ListTile(
                title: Text(line.kind.label),
                subtitle: Text(
                  'Harían falta '
                  '${Formatters.quantity(line.quantity)} ${line.kind.unit}',
                ),
                onTap: () => Navigator.of(sheetContext).pop(line),
              ),
          ],
        ),
      ),
    );

    if (chosen == null || !mounted) return;
    await _editPrice(chosen);
  }

  Future<void> _removeMaterial(MaterialLine line) async {
    await ref
        .read(budgetRepositoryProvider)
        .removePrice(widget.projectId, line.kind);
  }

  Future<void> _editPrice(MaterialLine line) async {
    final double? price = await NumberPromptDialog.show(
      context,
      title: 'Precio de ${line.kind.label.toLowerCase()}',
      label: 'Precio por ${line.kind.unit}',
      prefixText: r'$ ',
      initialText: line.hasPrice ? line.unitPrice.round().toString() : null,
      validator: MoneyInput.validate,
      parse: MoneyInput.parse,
    );

    if (price == null || !mounted) return;
    await ref
        .read(budgetRepositoryProvider)
        .savePrice(widget.projectId, line.kind, price);
  }

  /// Lo que se ofrece al tocar un material ya metido.
  Future<void> _materialOptions(MaterialLine line) async {
    if (!line.hasPrice) {
      await _editPrice(line);
      return;
    }

    final bool? remove = await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Cambiar el precio'),
              onTap: () => Navigator.of(sheetContext).pop(false),
            ),
            ListTile(
              leading: Icon(
                Icons.remove_circle_outline,
                color: Theme.of(sheetContext).colorScheme.error,
              ),
              title: const Text('Quitar del presupuesto'),
              onTap: () => Navigator.of(sheetContext).pop(true),
            ),
          ],
        ),
      ),
    );

    if (remove == null || !mounted) return;
    if (remove) {
      await _removeMaterial(line);
    } else {
      await _editPrice(line);
    }
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

class _MaterialsCard extends StatelessWidget {
  const _MaterialsCard({
    required this.lines,
    required this.onTapLine,
    required this.onAdd,
  });

  final List<MaterialLine> lines;
  final ValueChanged<MaterialLine> onTapLine;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Materiales', style: theme.textTheme.titleMedium),
                ),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir'),
                ),
              ],
            ),
            if (lines.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Añade los materiales que quieras presupuestar. Las '
                  'cantidades salen del plano; tú pones el precio y decides '
                  'cuáles entran.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final MaterialLine line in lines)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(line.kind.label),
                subtitle: Text(
                  '${Formatters.quantity(line.quantity)} ${line.kind.unit}'
                  ' × ${Formatters.money(line.unitPrice)}',
                ),
                trailing: Text(
                  Formatters.money(line.subtotal),
                  style: theme.textTheme.titleSmall,
                ),
                onTap: () => onTapLine(line),
              ),
          ],
        ),
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({
    required this.items,
    required this.onAdd,
    required this.onTapItem,
  });

  final List<BudgetItem> items;
  final VoidCallback onAdd;
  final ValueChanged<BudgetItem> onTapItem;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Otras partidas',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir'),
                ),
              ],
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Aquí van el acero, la teja, la mano de obra y todo lo que '
                  'no sale del plano.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final BudgetItem item in items)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.description),
                subtitle: Text(
                  '${item.category.label} · '
                  '${Formatters.quantity(item.quantity)} ${item.unit}'
                  ' × ${Formatters.money(item.unitPrice)}',
                ),
                trailing: Text(
                  Formatters.money(item.subtotal),
                  style: theme.textTheme.titleSmall,
                ),
                onTap: () => onTapItem(item),
              ),
          ],
        ),
      ),
    );
  }
}

/// Los acabados: qué se le hace a qué paredes y pisos.
class _FinishesCard extends StatelessWidget {
  const _FinishesCard({
    required this.finishes,
    required this.rooms,
    required this.onAdd,
    required this.onTapFinish,
  });

  final List<Finish> finishes;
  final List<Room> rooms;
  final VoidCallback onAdd;
  final ValueChanged<Finish> onTapFinish;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Acabados', style: theme.textTheme.titleMedium),
                ),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir'),
                ),
              ],
            ),
            if (finishes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Marca las paredes y los pisos que llevan pintura, estuco '
                  'o enchape y ponles precio por m². Los metros salen del '
                  'plano.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final Finish finish in finishes)
              _finishTile(context, FinishCalculator.estimate(finish, rooms)),
          ],
        ),
      ),
    );
  }

  Widget _finishTile(BuildContext context, FinishEstimate estimate) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(estimate.finish.description),
      subtitle: Text(
        '${_where(estimate)} · ${Formatters.squareMeters(estimate.areaM2)}'
        ' × ${Formatters.money(estimate.finish.unitPrice)}',
      ),
      trailing: Text(
        Formatters.money(estimate.total),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      onTap: () => onTapFinish(estimate.finish),
    );
  }

  String _where(FinishEstimate estimate) {
    final List<String> parts = <String>[];
    if (estimate.walls > 0) {
      parts.add(estimate.walls == 1 ? '1 pared' : '${estimate.walls} paredes');
    }
    if (estimate.floors > 0) {
      parts.add(estimate.floors == 1 ? '1 piso' : '${estimate.floors} pisos');
    }
    return parts.isEmpty ? 'Sin superficies' : parts.join(' y ');
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final BudgetSummary summary;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double? perSquareMeter = summary.costPerSquareMeter;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            _Line(label: 'Materiales', value: summary.materialsTotal),
            _Line(label: 'Acabados', value: summary.finishesTotal),
            _Line(label: 'Mano de obra', value: summary.laborTotal),
            _Line(label: 'Otros', value: summary.otherTotal),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Total', style: theme.textTheme.titleMedium),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      Formatters.money(summary.total),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (perSquareMeter != null) ...[
              const SizedBox(height: 6),
              Text(
                '${Formatters.money(perSquareMeter)} por m² de piso',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            Formatters.money(value),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
