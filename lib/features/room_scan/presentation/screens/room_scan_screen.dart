import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/geometry/plan_geometry.dart';
import '../../../../core/geometry/point2d.dart';
import '../../../../core/measuring/sighting_math.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/measure_input.dart';
import '../../../rooms/domain/entities/room.dart';
import '../../../rooms/domain/entities/room_drafts.dart';
import '../../../rooms/domain/entities/room_plan.dart';
import '../../../rooms/domain/entities/room_wall.dart';
import '../../../rooms/presentation/widgets/floor_plan_view.dart';
import '../../../rooms/presentation/widgets/room_form_sheet.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/device_aim.dart';
import '../../domain/entities/sighting.dart';
import '../providers/scan_providers.dart';
import '../widgets/camera_viewfinder.dart';

/// Mide una habitación apuntando con la cámara al pie de cada esquina.
///
/// La distancia sale por trigonometría (altura del teléfono e inclinación) y
/// el giro, del giroscopio. Es una estimación: al terminar se abre el plano
/// para corregir las medidas con el flexómetro.
class RoomScanScreen extends ConsumerStatefulWidget {
  const RoomScanScreen({required this.projectId, super.key});

  final int projectId;

  @override
  ConsumerState<RoomScanScreen> createState() => _RoomScanScreenState();
}

class _RoomScanScreenState extends ConsumerState<RoomScanScreen> {
  final List<Sighting> _sightings = <Sighting>[];

  @override
  Widget build(BuildContext context) {
    final DeviceAim? aim = ref.watch(deviceAimProvider).value;
    final double phoneHeight =
        ref.watch(phoneHeightProvider).value ?? _defaultPhoneHeight;
    final double? distance = aim == null
        ? null
        : SightingMath.distanceToFloorPoint(
            pitchRadians: aim.pitchRadians,
            eyeHeightMeters: phoneHeight,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medir con la cámara'),
        actions: [
          IconButton(
            onPressed: _showHelp,
            tooltip: 'Cómo se mide',
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                const CameraViewfinder(),
                Align(
                  alignment: Alignment.topCenter,
                  child: _Readout(distance: distance, hasSensors: aim != null),
                ),
              ],
            ),
          ),
          _ScanPanel(
            sightings: _sightings,
            phoneHeight: phoneHeight,
            distance: distance,
            onCapture: distance == null ? null : () => _capture(aim!, distance),
            onUndo: _sightings.isEmpty ? null : _undo,
            onEditHeight: () => _editHeight(phoneHeight),
            onFinish: _sightings.length < 3 ? null : _finish,
          ),
        ],
      ),
    );
  }

  static const double _defaultPhoneHeight = 1.50;

  void _capture(DeviceAim aim, double distance) {
    setState(() {
      _sightings.add(
        Sighting(distanceMeters: distance, turnRadians: aim.turnRadians),
      );
    });
  }

  void _undo() => setState(_sightings.removeLast);

  Future<void> _editHeight(double current) async {
    final TextEditingController controller = TextEditingController(
      text: Formatters.decimal(current),
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final double? height = await showDialog<double>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Altura del teléfono'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Metros desde el suelo',
              helperText: 'A la altura del pecho suele ser 1,40 o 1,50 m',
            ),
            validator: (String? value) =>
                MeasureInput.validate(value, min: 0.3, max: 2.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              Navigator.of(
                dialogContext,
              ).pop(MeasureInput.parse(controller.text));
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (height == null || !mounted) return;
    await ref.read(settingsRepositoryProvider).savePhoneHeight(height);
  }

  Future<void> _finish() async {
    final List<WallDraft> walls = _wallsFromSightings();
    if (walls.isEmpty) return;

    await RoomFormSheet.show(
      context,
      projectId: widget.projectId,
      scannedWalls: walls,
      onCreated: (int roomId) {
        if (!mounted) return;
        context.pushReplacement(
          AppRoutes.roomEditorPath(widget.projectId, roomId),
        );
      },
    );
  }

  List<WallDraft> _wallsFromSightings() {
    final List<Point2D> vertices = _sightings
        .map((Sighting sighting) => sighting.point)
        .toList(growable: false);
    return PlanGeometry.chainFromVertices(vertices)
        .map(
          (WallStep step) => WallDraft(
            lengthMeters: step.lengthMeters,
            turnDegrees: step.turnDegrees,
          ),
        )
        .toList(growable: false);
  }

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Cómo se mide'),
        content: const SingleChildScrollView(
          child: Text(
            'Ponte en un punto desde el que veas todas las esquinas de la '
            'habitación, sin moverte de ahí.\n\n'
            '1. Comprueba la altura a la que llevas el teléfono.\n'
            '2. Apunta con la mira al pie de una esquina, donde la pared '
            'toca el suelo, y marca.\n'
            '3. Gira sobre ti mismo y marca las demás, siempre en el mismo '
            'sentido.\n'
            '4. Al terminar se dibuja el plano.\n\n'
            'La medida sale de la inclinación del teléfono, así que es una '
            'estimación: después puedes corregir cada pared con el '
            'flexómetro en el editor del plano.',
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}

/// Lo que se lee en grande sobre el visor.
class _Readout extends StatelessWidget {
  const _Readout({required this.distance, required this.hasSensors});

  final double? distance;
  final bool hasSensors;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String text = switch ((hasSensors, distance)) {
      (false, _) => 'Esperando a los sensores…',
      (_, final double value?) => Formatters.meters(value),
      _ => 'Apunta más abajo, al pie de la pared',
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              text,
              style: (distance == null
                      ? theme.textTheme.bodyMedium
                      : theme.textTheme.headlineSmall)
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

/// El panel de abajo: altura, esquinas marcadas, plano en curso y botones.
class _ScanPanel extends StatelessWidget {
  const _ScanPanel({
    required this.sightings,
    required this.phoneHeight,
    required this.distance,
    required this.onCapture,
    required this.onUndo,
    required this.onEditHeight,
    required this.onFinish,
  });

  final List<Sighting> sightings;
  final double phoneHeight;
  final double? distance;
  final VoidCallback? onCapture;
  final VoidCallback? onUndo;
  final VoidCallback onEditHeight;
  final VoidCallback? onFinish;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: ActionChip(
                      avatar: const Icon(Icons.height, size: 18),
                      label: Text(
                        'Altura ${Formatters.meters(phoneHeight)}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: onEditHeight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      sightings.length == 1
                          ? '1 esquina'
                          : '${sightings.length} esquinas',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: onUndo,
                    tooltip: 'Quitar la última',
                    icon: const Icon(Icons.undo),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(height: 132, child: _Preview(sightings: sightings)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: onCapture,
                      icon: const Icon(Icons.add_location_alt_outlined),
                      label: const Text('Marcar esquina'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onFinish,
                      child: const Text('Terminar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Plano de lo marcado hasta ahora.
class _Preview extends StatelessWidget {
  const _Preview({required this.sightings});

  final List<Sighting> sightings;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (sightings.length < 3) {
      return Center(
        child: Text(
          'Marca al menos tres esquinas para tener un plano',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final DateTime now = DateTime.now();
    final List<WallStep> steps = PlanGeometry.chainFromVertices(
      sightings.map((Sighting sighting) => sighting.point).toList(),
    );
    final Room room = Room(
      id: 0,
      projectId: 0,
      name: '',
      wallHeightMeters: 2.4,
      walls: <RoomWall>[
        for (int i = 0; i < steps.length; i++)
          RoomWall(
            id: -(i + 1),
            position: i,
            lengthMeters: steps[i].lengthMeters,
            turnDegrees: steps[i].turnDegrees,
          ),
      ],
      createdAt: now,
      updatedAt: now,
    );

    return FloorPlanView(
      room: room,
      plan: RoomPlan.of(room),
      showDimensions: false,
    );
  }
}
