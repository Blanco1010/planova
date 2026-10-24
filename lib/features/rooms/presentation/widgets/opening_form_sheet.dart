import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/measure_input.dart';
import '../../../../l10n/app_l10n.dart';
import '../../domain/entities/opening.dart';
import '../../domain/entities/room_drafts.dart';
import '../../domain/repositories/room_repository.dart';
import '../providers/room_providers.dart';
import 'opening_kind_display.dart';

/// Hoja para añadir o editar una puerta o una ventana de una pared.
class OpeningFormSheet extends ConsumerStatefulWidget {
  const OpeningFormSheet._({
    required this.wallId,
    required this.wallLengthMeters,
    required this.wallHeightMeters,
    this.opening,
  });

  /// Abre la hoja. Sin [opening] añade un vano nuevo; con él, lo edita.
  static Future<void> show(
    BuildContext context, {
    required int wallId,
    required double wallLengthMeters,
    required double wallHeightMeters,
    Opening? opening,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: OpeningFormSheet._(
          wallId: wallId,
          wallLengthMeters: wallLengthMeters,
          wallHeightMeters: wallHeightMeters,
          opening: opening,
        ),
      ),
    );
  }

  final int wallId;
  final double wallLengthMeters;
  final double wallHeightMeters;
  final Opening? opening;

  @override
  ConsumerState<OpeningFormSheet> createState() => _OpeningFormSheetState();
}

class _OpeningFormSheetState extends ConsumerState<OpeningFormSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late OpeningKind _kind;
  late final TextEditingController _width;
  late final TextEditingController _height;
  late final TextEditingController _distance;
  bool _saving = false;

  bool get _isEditing => widget.opening != null;

  @override
  void initState() {
    super.initState();
    final Opening? opening = widget.opening;
    _kind = opening?.kind ?? OpeningKind.door;
    _width = TextEditingController(
      text: Formatters.decimal(opening?.widthMeters ?? 0.80),
    );
    _height = TextEditingController(
      text: Formatters.decimal(opening?.heightMeters ?? 2.05),
    );
    _distance = TextEditingController(
      text: Formatters.decimal(opening?.distanceFromStartMeters ?? 0),
    );
  }

  @override
  void dispose() {
    _width.dispose();
    _height.dispose();
    _distance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _isEditing ? t.editOpening : t.newOpening,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SegmentedButton<OpeningKind>(
                segments: [
                  for (final OpeningKind kind in OpeningKind.values)
                    ButtonSegment<OpeningKind>(
                      value: kind,
                      label: Text(kind.label(t)),
                      icon: Icon(kind.icon),
                    ),
                ],
                selected: <OpeningKind>{_kind},
                onSelectionChanged: (Set<OpeningKind> selection) {
                  setState(() => _kind = selection.first);
                  _applyDefaultsFor(selection.first);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _width,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(labelText: t.widthMetersShort),
                      validator: (String? value) => MeasureInput.validate(
                        value,
                        max: widget.wallLengthMeters,
                        maxMessage: t.openingTooWide,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _height,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(labelText: t.heightMetersShort),
                      validator: (String? value) => MeasureInput.validate(
                        value,
                        max: widget.wallHeightMeters,
                        maxMessage: t.openingTooTall,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _distance,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: t.openingDistance,
                  helperText: t.wallMeasures(
                    Formatters.meters(widget.wallLengthMeters),
                  ),
                ),
                validator: _validateDistance,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_isEditing ? t.saveChanges : t.addOpening),
              ),
              if (_isEditing)
                TextButton(
                  onPressed: _saving ? null : _delete,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(t.deleteOpening),
                ),
            ],
          ),
        ),
      ),
    );
  }
  AppL10n get _t => AppL10n.of(context);

  /// Medidas típicas al cambiar de tipo, para no escribirlas siempre.
  void _applyDefaultsFor(OpeningKind kind) {
    final bool isDoor = kind == OpeningKind.door;
    _width.text = Formatters.decimal(isDoor ? 0.80 : 1.20);
    _height.text = Formatters.decimal(isDoor ? 2.05 : 1.20);
  }

  String? _validateDistance(String? raw) {
    final double? value = MeasureInput.parse(raw);
    if (value == null || value.isNaN || value < 0) {
      return _t.measureRequired;
    }
    final double width = MeasureInput.parse(_width.text) ?? 0;
    if (value + width > widget.wallLengthMeters + 0.001) {
      return _t.openingOffWall;
    }
    return null;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final NavigatorState navigator = Navigator.of(context);
    final OpeningDraft draft = OpeningDraft(
      kind: _kind,
      widthMeters: MeasureInput.parse(_width.text)!,
      heightMeters: MeasureInput.parse(_height.text)!,
      distanceFromStartMeters: MeasureInput.parse(_distance.text)!,
    );

    setState(() => _saving = true);
    final RoomRepository repository = ref.read(roomRepositoryProvider);
    final Opening? opening = widget.opening;
    if (opening == null) {
      await repository.addOpening(widget.wallId, draft);
    } else {
      await repository.updateOpening(opening.id, draft);
    }
    navigator.pop();
  }

  Future<void> _delete() async {
    final NavigatorState navigator = Navigator.of(context);
    setState(() => _saving = true);
    await ref.read(roomRepositoryProvider).deleteOpening(widget.opening!.id);
    navigator.pop();
  }
}
