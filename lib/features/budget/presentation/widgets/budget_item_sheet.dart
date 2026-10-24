import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/measure_input.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/money_input.dart';
import '../../../../l10n/app_l10n.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/budget_item.dart';
import '../providers/budget_providers.dart';

/// Hoja para añadir o editar una partida escrita a mano.
class BudgetItemSheet extends ConsumerStatefulWidget {
  const BudgetItemSheet._({
    required this.projectId,
    required this.roomId,
    this.item,
  });

  /// Sin [item] añade una partida nueva; con él, la edita.
  /// [roomId] es la habitación a la que se carga, o `null` para toda la obra.
  static Future<void> show(
    BuildContext context, {
    required int projectId,
    int? roomId,
    BudgetItem? item,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: BudgetItemSheet._(
          projectId: projectId,
          roomId: roomId,
          item: item,
        ),
      ),
    );
  }

  final int projectId;
  final int? roomId;
  final BudgetItem? item;

  @override
  ConsumerState<BudgetItemSheet> createState() => _BudgetItemSheetState();
}

class _BudgetItemSheetState extends ConsumerState<BudgetItemSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _description;
  late final TextEditingController _unit;
  late final TextEditingController _quantity;
  late final TextEditingController _price;
  late BudgetCategory _category;
  bool _saving = false;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final BudgetItem? item = widget.item;
    _category = item?.category ?? BudgetCategory.material;
    _description = TextEditingController(text: item?.description ?? '');
    _unit = TextEditingController(text: item?.unit ?? 'unid');
    _quantity = TextEditingController(
      text: item == null ? '1' : Formatters.quantity(item.quantity),
    );
    final MoneyFormat money = ref.read(moneyProvider).value ?? MoneyFormat.cop;
    _price = TextEditingController(
      text: item == null ? '' : money.formatAmount(item.unitPrice),
    );
  }

  @override
  void dispose() {
    _description.dispose();
    _unit.dispose();
    _quantity.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MoneyFormat money = ref.watch(moneyProvider).value ?? MoneyFormat.cop;
    final AppL10n t = AppL10n.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? t.editItem : t.newItem,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SegmentedButton<BudgetCategory>(
                segments: [
                  for (final BudgetCategory category in BudgetCategory.values)
                    ButtonSegment<BudgetCategory>(
                      value: category,
                      label: Text(category.label(t)),
                    ),
                ],
                selected: <BudgetCategory>{_category},
                onSelectionChanged: (Set<BudgetCategory> selection) =>
                    setState(() => _category = selection.first),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _description,
                autofocus: !_isEditing,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: t.description,
                  hintText: t.itemHint,
                ),
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty)
                    ? t.itemRequired
                    : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantity,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(labelText: t.quantity),
                      validator: (String? value) =>
                          MeasureInput.validate(value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unit,
                      decoration: InputDecoration(labelText: t.unit),
                      validator: (String? value) =>
                          (value == null || value.trim().isEmpty)
                          ? t.missing
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: t.pricePerUnit,
                  prefixText: '${money.symbol} ',
                ),
                inputFormatters: <TextInputFormatter>[
                  MoneyInputFormatter(money),
                ],
                validator: (String? raw) => MoneyInput.validate(raw, money),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_isEditing ? t.saveChanges : t.addItem),
              ),
              if (_isEditing)
                TextButton(
                  onPressed: _saving ? null : _delete,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(t.deleteItem),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final MoneyFormat money = ref.read(moneyProvider).value ?? MoneyFormat.cop;
    final NavigatorState navigator = Navigator.of(context);
    final BudgetItemDraft draft = BudgetItemDraft(
      category: _category,
      description: _description.text.trim(),
      unit: _unit.text.trim(),
      quantity: MeasureInput.parse(_quantity.text)!,
      unitPrice: MoneyInput.parse(_price.text, money)!,
      roomId: widget.item?.roomId ?? widget.roomId,
    );

    setState(() => _saving = true);
    final BudgetItem? item = widget.item;
    if (item == null) {
      await ref.read(budgetRepositoryProvider).addItem(widget.projectId, draft);
    } else {
      await ref.read(budgetRepositoryProvider).updateItem(item.id, draft);
    }
    navigator.pop();
  }

  Future<void> _delete() async {
    final NavigatorState navigator = Navigator.of(context);
    setState(() => _saving = true);
    await ref.read(budgetRepositoryProvider).deleteItem(widget.item!.id);
    navigator.pop();
  }
}
