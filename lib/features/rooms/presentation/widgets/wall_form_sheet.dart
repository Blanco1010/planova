import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/measure_input.dart';
import '../../domain/entities/opening.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_drafts.dart';
import '../../domain/entities/room_wall.dart';
import '../providers/room_providers.dart';
import 'opening_form_sheet.dart';
import 'opening_kind_display.dart';

/// Hoja de una pared: su medida, su giro y sus vanos.
class WallFormSheet extends ConsumerStatefulWidget {
  const WallFormSheet._({required this.roomId, required this.wallId});

  static Future<void> show(
    BuildContext context, {
    required int roomId,
    required int wallId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: WallFormSheet._(roomId: roomId, wallId: wallId),
      ),
    );
  }

  final int roomId;
  final int wallId;

  @override
  ConsumerState<WallFormSheet> createState() => _WallFormSheetState();
}

class _WallFormSheetState extends ConsumerState<WallFormSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _length = TextEditingController();
  final TextEditingController _turn = TextEditingController();
  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _length.dispose();
    _turn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Room? room = ref.watch(roomProvider(widget.roomId)).value;
    final RoomWall? wall = _wallOf(room);
    if (room == null || wall == null) {
      return const SizedBox(height: 120);
    }

    if (!_initialized) {
      _length.text = Formatters.decimal(wall.lengthMeters);
      _turn.text = Formatters.decimal(wall.turnDegrees);
      _initialized = true;
    }

    final bool isFirstWall = wall.position == 0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(wall.label, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _length,
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Largo de la pared (m)',
                      ),
                      validator: (String? value) =>
                          MeasureInput.validate(value),
                    ),
                    if (!isFirstWall) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _turn,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Giro respecto a la pared anterior (°)',
                          helperText:
                              '90 gira a la derecha, -90 a la izquierda',
                        ),
                        validator: _validateTurn,
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _saving ? null : () => _save(wall),
                      child: const Text('Guardar pared'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Puertas y ventanas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => OpeningFormSheet.show(
                      context,
                      wallId: wall.id,
                      wallLengthMeters: wall.lengthMeters,
                      wallHeightMeters: room.wallHeightMeters,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Añadir'),
                  ),
                ],
              ),
              if (wall.openings.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Esta pared no tiene vanos. Los que añadas se descuentan '
                    'de la superficie a pintar.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              for (final Opening opening in wall.openings)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(opening.kind.icon),
                  title: Text(
                    '${opening.kind.label} '
                    '${Formatters.decimal(opening.widthMeters)} × '
                    '${Formatters.meters(opening.heightMeters)}',
                  ),
                  subtitle: Text(
                    'A ${Formatters.meters(opening.distanceFromStartMeters)} '
                    'del inicio',
                  ),
                  onTap: () => OpeningFormSheet.show(
                    context,
                    wallId: wall.id,
                    wallLengthMeters: wall.lengthMeters,
                    wallHeightMeters: room.wallHeightMeters,
                    opening: opening,
                  ),
                ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _saving ? null : () => _deleteWall(wall),
                child: const Text('Eliminar esta pared'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RoomWall? _wallOf(Room? room) {
    if (room == null) return null;
    for (final RoomWall wall in room.walls) {
      if (wall.id == widget.wallId) return wall;
    }
    return null;
  }

  String? _validateTurn(String? raw) {
    final double? value = MeasureInput.parse(raw);
    if (value == null || value.isNaN) return 'Escribe los grados';
    if (value <= -360 || value >= 360) return 'Entre -359 y 359';
    return null;
  }

  Future<void> _save(RoomWall wall) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final NavigatorState navigator = Navigator.of(context);
    setState(() => _saving = true);
    await ref
        .read(roomRepositoryProvider)
        .updateWall(
          wall.id,
          WallDraft(
            lengthMeters: MeasureInput.parse(_length.text)!,
            turnDegrees: wall.position == 0
                ? wall.turnDegrees
                : MeasureInput.parse(_turn.text)!,
          ),
        );
    navigator.pop();
  }

  Future<void> _deleteWall(RoomWall wall) async {
    final NavigatorState navigator = Navigator.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Eliminar ${wall.label.toLowerCase()}'),
        content: const Text(
          'Se borra la pared con sus puertas y ventanas, y el plano se vuelve '
          'a trazar con las que queden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _saving = true);
    await ref.read(roomRepositoryProvider).deleteWall(wall.id);
    navigator.pop();
  }
}
