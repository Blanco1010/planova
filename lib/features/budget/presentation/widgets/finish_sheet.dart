import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/money_input.dart';
import '../../../../core/widgets/confirm_delete_dialog.dart';
import '../../../rooms/domain/entities/room.dart';
import '../../../rooms/domain/entities/room_wall.dart';
import '../../../rooms/presentation/providers/room_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/finish.dart';
import '../../domain/services/finish_calculator.dart';
import '../providers/budget_providers.dart';

/// Hoja para elegir qué superficies llevan un acabado y a qué precio.
///
/// Se marcan paredes y pisos de la obra; lo que se guarda es a cuáles
/// apunta, así que los metros salen siempre del plano de ese momento.
class FinishSheet extends ConsumerStatefulWidget {
  const FinishSheet._({required this.projectId, this.finish});

  static Future<void> show(
    BuildContext context, {
    required int projectId,
    Finish? finish,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: FinishSheet._(projectId: projectId, finish: finish),
      ),
    );
  }

  final int projectId;
  final Finish? finish;

  @override
  ConsumerState<FinishSheet> createState() => _FinishSheetState();
}

class _FinishSheetState extends ConsumerState<FinishSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final Set<FinishSurface> _selected;
  bool _saving = false;

  bool get _isEditing => widget.finish != null;

  @override
  void initState() {
    super.initState();
    final Finish? finish = widget.finish;
    final MoneyFormat money = ref.read(moneyProvider).value ?? MoneyFormat.cop;
    _description = TextEditingController(text: finish?.description ?? '');
    _price = TextEditingController(
      text: finish == null ? '' : money.formatAmount(finish.unitPrice),
    );
    _selected = <FinishSurface>{...?finish?.surfaces};
  }

  @override
  void dispose() {
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Room> rooms =
        ref.watch(projectRoomsProvider(widget.projectId)).value ??
        const <Room>[];
    final MoneyFormat money = ref.watch(moneyProvider).value ?? MoneyFormat.cop;
    final double area = _selectedArea(rooms);
    final double? price = MoneyInput.parse(_price.text, money);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEditing ? 'Editar acabado' : 'Nuevo acabado',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _description,
                  autofocus: !_isEditing,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Qué se hace',
                    hintText: 'Pintura vinilo, estuco, enchape…',
                  ),
                  validator: (String? value) =>
                      (value == null || value.trim().isEmpty)
                      ? 'Escribe qué acabado es'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _price,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Precio por m²',
                    prefixText: '${money.symbol} ',
                  ),
                  inputFormatters: <TextInputFormatter>[
                    MoneyInputFormatter(money),
                  ],
                  onChanged: (_) => setState(() {}),
                  validator: (String? raw) => MoneyInput.validate(raw, money),
                ),
                const SizedBox(height: 20),
                Text('Dónde se aplica', style: theme.textTheme.titleMedium),
                if (rooms.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Todavía no hay habitaciones medidas.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                for (final Room room in rooms) _roomSection(room),
                const SizedBox(height: 12),
                _Total(area: area, price: price, money: money),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _saving ? null : () => _save(rooms),
                  child: Text(
                    _isEditing ? 'Guardar cambios' : 'Añadir acabado',
                  ),
                ),
                if (_isEditing)
                  TextButton(
                    onPressed: _saving ? null : _delete,
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    child: const Text('Eliminar acabado'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roomSection(Room room) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          room.name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        for (final RoomWall wall in room.walls)
          _surfaceTile(
            surface: FinishSurface(roomId: room.id, wallId: wall.id),
            label: wall.label,
            area: FinishCalculator.wallArea(room, wall),
          ),
        _surfaceTile(
          surface: FinishSurface(roomId: room.id),
          label: 'Piso',
          area: FinishCalculator.surfaceArea(
            FinishSurface(roomId: room.id),
            <Room>[room],
          ),
        ),
      ],
    );
  }

  Widget _surfaceTile({
    required FinishSurface surface,
    required String label,
    required double area,
  }) {
    return CheckboxListTile(
      value: _selected.contains(surface),
      onChanged: (bool? checked) => setState(() {
        if (checked ?? false) {
          _selected.add(surface);
        } else {
          _selected.remove(surface);
        }
      }),
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text('$label · ${Formatters.squareMeters(area)}'),
    );
  }

  double _selectedArea(List<Room> rooms) {
    double area = 0;
    for (final FinishSurface surface in _selected) {
      area += FinishCalculator.surfaceArea(surface, rooms);
    }
    return area;
  }

  Future<void> _save(List<Room> rooms) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marca al menos una pared o un piso.')),
      );
      return;
    }

    final MoneyFormat money = ref.read(moneyProvider).value ?? MoneyFormat.cop;
    final NavigatorState navigator = Navigator.of(context);
    final FinishDraft draft = FinishDraft(
      description: _description.text.trim(),
      unitPrice: MoneyInput.parse(_price.text, money)!,
      surfaces: _selected.toList(growable: false),
    );

    setState(() => _saving = true);
    final Finish? finish = widget.finish;
    if (finish == null) {
      await ref
          .read(budgetRepositoryProvider)
          .addFinish(widget.projectId, draft);
    } else {
      await ref.read(budgetRepositoryProvider).updateFinish(finish.id, draft);
    }
    navigator.pop();
  }

  Future<void> _delete() async {
    final NavigatorState navigator = Navigator.of(context);
    final bool confirmed = await ConfirmDeleteDialog.show(
      context,
      title: 'Eliminar acabado',
      message:
          'Se quita «${widget.finish!.description}» del presupuesto. Las '
          'paredes y el plano no se tocan.',
    );
    if (!confirmed) return;

    setState(() => _saving = true);
    await ref.read(budgetRepositoryProvider).deleteFinish(widget.finish!.id);
    navigator.pop();
  }
}

/// Lo que suma lo marcado, mientras se marca.
class _Total extends StatelessWidget {
  const _Total({
    required this.area,
    required this.price,
    required this.money,
  });

  final double area;
  final double? price;
  final MoneyFormat money;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double? price = this.price;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Marcado: ${Formatters.squareMeters(area)}',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            price == null || price <= 0 ? '—' : money.format(area * price),
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
