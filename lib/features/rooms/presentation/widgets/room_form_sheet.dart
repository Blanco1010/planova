import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/measure_input.dart';
import '../../../room_scan/domain/entities/scan_surface.dart';
import '../../../room_scan/presentation/providers/scan_providers.dart';
import '../../../room_scan/presentation/screens/measure_distance_screen.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_drafts.dart';
import '../providers/room_providers.dart';

/// Hoja para crear una habitación o cambiarle el nombre y la altura.
///
/// Al crearla a mano se piden ancho y largo y salen las cuatro paredes; si
/// viene de un escaneo, las paredes ya están hechas y aquí solo se bautiza.
/// A partir de ahí las medidas se cambian en el plano, pared por pared.
class RoomFormSheet extends ConsumerStatefulWidget {
  const RoomFormSheet._({
    required this.projectId,
    this.room,
    this.scannedWalls,
    this.wallHeightMeters,
    this.onCreated,
  });

  static Future<void> show(
    BuildContext context, {
    required int projectId,
    Room? room,
    List<WallDraft>? scannedWalls,
    double? wallHeightMeters,
    ValueChanged<int>? onCreated,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: RoomFormSheet._(
          projectId: projectId,
          room: room,
          scannedWalls: scannedWalls,
          wallHeightMeters: wallHeightMeters,
          onCreated: onCreated,
        ),
      ),
    );
  }

  final int projectId;
  final Room? room;

  /// Paredes que trae un escaneo; si vienen, no se piden ancho y largo.
  final List<WallDraft>? scannedWalls;

  /// Altura de las paredes ya medida, si se sabe.
  final double? wallHeightMeters;

  /// Avisa con el `id` de la habitación recién creada.
  final ValueChanged<int>? onCreated;

  @override
  ConsumerState<RoomFormSheet> createState() => _RoomFormSheetState();
}

class _RoomFormSheetState extends ConsumerState<RoomFormSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _width;
  late final TextEditingController _length;
  late final TextEditingController _height;
  bool _saving = false;

  bool get _isEditing => widget.room != null;

  /// Solo se piden ancho y largo al crear una habitación a mano.
  bool get _asksForSize => !_isEditing && widget.scannedWalls == null;

  @override
  void initState() {
    super.initState();
    final Room? room = widget.room;
    _name = TextEditingController(text: room?.name ?? '');
    _width = TextEditingController(text: Formatters.decimal(3));
    _length = TextEditingController(text: Formatters.decimal(4));
    _height = TextEditingController(
      text: Formatters.decimal(
        room?.wallHeightMeters ?? widget.wallHeightMeters ?? 2.4,
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _width.dispose();
    _length.dispose();
    _height.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(_title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
                autofocus: !_isEditing,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Sala, cocina, alcoba 1…',
                ),
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty)
                    ? 'Ponle un nombre a la habitación'
                    : null,
              ),
              if (_asksForSize) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _width,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Ancho (m)',
                        ),
                        validator: (String? value) =>
                            MeasureInput.validate(value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _length,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Largo (m)',
                        ),
                        validator: (String? value) =>
                            MeasureInput.validate(value),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _height,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Altura de las paredes (m)',
                ),
                validator: (String? value) => MeasureInput.validate(value),
              ),
              if (ref.watch(arCoreProvider).value ?? false)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _saving ? null : _measureHeight,
                    icon: const Icon(Icons.height),
                    label: const Text('Medir la altura con la cámara'),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(
                  _isEditing ? 'Guardar cambios' : 'Crear habitación',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _title {
    if (_isEditing) return 'Editar habitación';
    if (widget.scannedWalls != null) return 'Guardar lo escaneado';
    return 'Nueva habitación';
  }

  /// Mide del suelo al techo y lo deja escrito en el campo.
  Future<void> _measureHeight() async {
    final double? meters = await MeasureDistanceScreen.show(
      context,
      title: 'Medir la altura',
      surface: ScanSurface.wall,
    );
    if (meters == null || !mounted) return;

    setState(() => _height.text = Formatters.decimal(meters));
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final NavigatorState navigator = Navigator.of(context);
    final RoomDraft draft = RoomDraft(
      name: _name.text.trim(),
      wallHeightMeters: MeasureInput.parse(_height.text)!,
    );

    setState(() => _saving = true);
    final Room? room = widget.room;
    if (room != null) {
      await ref.read(roomRepositoryProvider).update(room.id, draft);
      navigator.pop();
      return;
    }

    final List<WallDraft> walls =
        widget.scannedWalls ??
        rectangleWalls(
          widthMeters: MeasureInput.parse(_width.text)!,
          lengthMeters: MeasureInput.parse(_length.text)!,
        );
    final int roomId = await ref
        .read(roomRepositoryProvider)
        .createFromWalls(widget.projectId, draft, walls);
    navigator.pop();
    widget.onCreated?.call(roomId);
  }
}
