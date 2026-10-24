import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/money_input.dart';
import '../../../../core/widgets/number_prompt_dialog.dart';
import '../../../../l10n/app_l10n.dart';
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
import '../../../settings/presentation/providers/settings_providers.dart';
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
    final MoneyFormat money = ref.watch(moneyProvider).value ?? MoneyFormat.cop;
    final AppL10n t = AppL10n.of(context);

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
        title: Text(t.budget),
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
                    money: money,
                  ),
            tooltip: t.exportPdf,
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
            money: money,
            lines: lines,
            onTapLine: _materialOptions,
            onAdd: available.isEmpty ? null : () => _addMaterial(available),
          ),
          const SizedBox(height: 12),
          _ItemsCard(
            money: money,
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
            money: money,
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
          _SummaryCard(summary: summary, money: money),
        ],
      ),
    );
  }

  AppL10n get _t => AppL10n.of(context);

  /// Arma el PDF y lo entrega a la hoja de compartir del teléfono.
  Future<void> _export({
    required Project project,
    required List<Room> rooms,
    required List<MaterialLine> lines,
    required List<BudgetItem> items,
    required List<FinishEstimate> finishes,
    required BudgetSummary summary,
    required MoneyFormat money,
  }) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String scopeLabel = _roomId == null
        ? _t.wholeProject
        : rooms.firstOrNull?.name ?? _t.oneRoom;

    try {
      final Map<int, Uint8List> plans = <int, Uint8List>{};
      for (final Room room in rooms) {
        final Uint8List? png = await ref
            .read(floorPlanRendererProvider)
            .toPng(room: room, plan: RoomPlan.of(room));
        if (png != null) plans[room.id] = png;
      }

      final Uint8List bytes = await BudgetPdfBuilder.build(
        t: _t,
        project: project,
        scopeLabel: scopeLabel,
        rooms: rooms,
        roomPlans: plans,
        materialLines: lines,
        items: items,
        finishes: finishes,
        summary: summary,
        money: money,
        generatedAt: DateTime.now(),
      );
      await ref
          .read(budgetExporterProvider)
          .share(bytes: bytes, fileName: BudgetPdfBuilder.fileNameFor(project));
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(_t.pdfFailed('$error'))),
      );
    }
  }

  /// Elige cuál de los materiales que faltan se mete en el presupuesto.
  Future<void> _addMaterial(List<MaterialLine> available) async {
    final MaterialLine? chosen = await showModalBottomSheet<MaterialLine>(
      context: context,
      // Con los seis materiales sin precio la lista no cabe de una vez.
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _t.whichMaterial,
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                ),
              ),
              for (final MaterialLine line in available)
                ListTile(
                  title: Text(line.kind.label(_t)),
                  subtitle: Text(
                    _t.materialNeeded(
                      line.kind.surface.label(_t),
                      Formatters.quantity(line.quantity),
                      line.kind.unit(_t),
                    ),
                  ),
                  onTap: () => Navigator.of(sheetContext).pop(line),
                ),
            ],
          ),
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
    final MoneyFormat money = ref.read(moneyProvider).value ?? MoneyFormat.cop;
    final double? price = await NumberPromptDialog.show(
      context,
      title: _t.priceOf(line.kind.label(_t).toLowerCase()),
      label: _t.pricePer(line.kind.unit(_t)),
      prefixText: '${money.symbol} ',
      initialText: line.hasPrice ? money.formatAmount(line.unitPrice) : null,
      inputFormatters: <TextInputFormatter>[MoneyInputFormatter(money)],
      validator: (String? raw) => MoneyInput.validate(raw, money),
      parse: (String? raw) => MoneyInput.parse(raw, money),
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
              title: Text(_t.changePrice),
              onTap: () => Navigator.of(sheetContext).pop(false),
            ),
            ListTile(
              leading: Icon(
                Icons.remove_circle_outline,
                color: Theme.of(sheetContext).colorScheme.error,
              ),
              title: Text(_t.removeFromBudget),
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

class _MaterialsCard extends StatelessWidget {
  const _MaterialsCard({
    required this.money,
    required this.lines,
    required this.onTapLine,
    required this.onAdd,
  });

  final MoneyFormat money;
  final List<MaterialLine> lines;
  final ValueChanged<MaterialLine> onTapLine;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final AppL10n t = AppL10n.of(context);
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
                  child: Text(t.materials, style: theme.textTheme.titleMedium),
                ),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: Text(t.add),
                ),
              ],
            ),
            if (lines.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  t.materialsEmptyBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final MaterialLine line in lines)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(line.kind.label(t)),
                subtitle: Text(
                  t.materialLine(
                    line.kind.surface.label(t),
                    Formatters.quantity(line.quantity),
                    line.kind.unit(t),
                    money.format(line.unitPrice),
                  ),
                ),
                trailing: Text(
                  money.format(line.subtotal),
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
    required this.money,
    required this.items,
    required this.onAdd,
    required this.onTapItem,
  });

  final MoneyFormat money;
  final List<BudgetItem> items;
  final VoidCallback onAdd;
  final ValueChanged<BudgetItem> onTapItem;

  @override
  Widget build(BuildContext context) {
    final AppL10n t = AppL10n.of(context);
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
                    t.otherItems,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: Text(t.add),
                ),
              ],
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  t.otherItemsEmptyBody,
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
                  t.itemLine(
                    item.category.label(t),
                    Formatters.quantity(item.quantity),
                    item.unit,
                    money.format(item.unitPrice),
                  ),
                ),
                trailing: Text(
                  money.format(item.subtotal),
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
    required this.money,
    required this.finishes,
    required this.rooms,
    required this.onAdd,
    required this.onTapFinish,
  });

  final MoneyFormat money;
  final List<Finish> finishes;
  final List<Room> rooms;
  final VoidCallback onAdd;
  final ValueChanged<Finish> onTapFinish;

  @override
  Widget build(BuildContext context) {
    final AppL10n t = AppL10n.of(context);
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
                  child: Text(t.finishes, style: theme.textTheme.titleMedium),
                ),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: Text(t.add),
                ),
              ],
            ),
            if (finishes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  t.finishesEmptyBody,
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
    final AppL10n t = AppL10n.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(estimate.finish.description),
      subtitle: Text(
        t.finishLine(
          _where(t, estimate),
          Formatters.squareMeters(estimate.areaM2),
          money.format(estimate.finish.unitPrice),
        ),
      ),
      trailing: Text(
        money.format(estimate.total),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      onTap: () => onTapFinish(estimate.finish),
    );
  }

  String _where(AppL10n t, FinishEstimate estimate) {
    final List<String> parts = <String>[];
    if (estimate.walls > 0) {
      parts.add(t.wallCount(estimate.walls));
    }
    if (estimate.floors > 0) {
      parts.add(t.floorCount(estimate.floors));
    }
    if (parts.isEmpty) return t.noSurfaces;
    return parts.length == 2 ? t.listAnd(parts.first, parts.last) : parts.first;
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary, required this.money});

  final BudgetSummary summary;
  final MoneyFormat money;

  @override
  Widget build(BuildContext context) {
    final AppL10n t = AppL10n.of(context);
    final ThemeData theme = Theme.of(context);
    final double? perSquareMeter = summary.costPerSquareMeter;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.summary, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            _Line(label: t.materials, value: summary.materialsTotal, money: money),
            _Line(label: t.finishes, value: summary.finishesTotal, money: money),
            _Line(label: t.labour, value: summary.laborTotal, money: money),
            _Line(label: t.otherCategory, value: summary.otherTotal, money: money),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(t.total, style: theme.textTheme.titleMedium),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      money.format(summary.total),
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
                t.perSquareMetre(money.format(perSquareMeter)),
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
  const _Line({
    required this.label,
    required this.value,
    required this.money,
  });

  final String label;
  final double value;
  final MoneyFormat money;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            money.format(value),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
