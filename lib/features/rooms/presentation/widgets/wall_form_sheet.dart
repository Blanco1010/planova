import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/measure_input.dart';
import '../../../../core/widgets/confirm_delete_dialog.dart';
import '../../../room_scan/presentation/providers/scan_providers.dart';
import '../../../room_scan/presentation/screens/measure_distance_screen.dart';
import '../../domain/entities/opening.dart';
import '../../../../l10n/app_l10n.dart';
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
    final AppL10n t = AppL10n.of(context);
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
              Text(wall.name(t), style: Theme.of(context).textTheme.titleLarge),
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
                      decoration: InputDecoration(labelText: t.wallLengthMeters),
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
                        decoration: InputDecoration(
                          labelText: t.wallTurnDegrees,
                          helperText: t.wallTurnHelp,
                        ),
                        validator: _validateTurn,
                      ),
                    ],
                    if (ref.watch(arCoreProvider).value ?? false)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _saving
                              ? null
                              : () => _measureWithCamera(wall),
                          icon: const Icon(Icons.straighten),
                          label: Text(t.measureAgainWithCamera),
                        ),
                      ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _saving ? null : () => _save(wall),
                      child: Text(t.saveWall),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.doorsAndWindows,
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
                    label: Text(t.add),
                  ),
                ],
              ),
              if (wall.openings.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    t.openingsEmptyBody,
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
                    t.openingSummary(
                      opening.kind.label(t),
                      Formatters.decimal(opening.widthMeters),
                      Formatters.meters(opening.heightMeters),
                    ),
                  ),
                  subtitle: Text(
                    t.openingFromStart(
                      Formatters.meters(opening.distanceFromStartMeters),
                    ),
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
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: Text(t.deleteThisWall),
              ),
            ],
          ),
        ),
      ),
    );
  }
  AppL10n get _t => AppL10n.of(context);


  RoomWall? _wallOf(Room? room) {
    if (room == null) return null;
    for (final RoomWall wall in room.walls) {
      if (wall.id == widget.wallId) return wall;
    }
    return null;
  }

  String? _validateTurn(String? raw) {
    final double? value = MeasureInput.parse(raw);
    if (value == null || value.isNaN) return _t.degreesRequired;
    if (value <= -360 || value >= 360) return _t.degreesRange;
    return null;
  }

  /// Mide la pared apuntando a sus dos extremos y trae el largo.
  Future<void> _measureWithCamera(RoomWall wall) async {
    final double? meters = await MeasureDistanceScreen.show(
      context,
      title: _t.measureThing(wall.name(_t).toLowerCase()),
    );
    if (meters == null || !mounted) return;

    setState(() => _length.text = Formatters.decimal(meters));
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
    final bool confirmed = await ConfirmDeleteDialog.show(
      context,
      title: _t.deleteThing(wall.name(_t).toLowerCase()),
      message: _t.deleteWallMessage,
    );

    if (!confirmed) return;

    setState(() => _saving = true);
    await ref.read(roomRepositoryProvider).deleteWall(wall.id);
    navigator.pop();
  }
}
