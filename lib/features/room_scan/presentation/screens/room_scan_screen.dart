import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/geometry/plan_geometry.dart';
import '../../../../core/geometry/point2d.dart';
import '../../../../core/measuring/sighting_math.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/measure_input.dart';
import '../../../../core/widgets/number_prompt_dialog.dart';
import '../../../rooms/domain/entities/room_drafts.dart';
import '../../../rooms/presentation/widgets/room_form_sheet.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/device_aim.dart';
import '../../domain/entities/sighting.dart';
import '../../domain/services/scan_snap.dart';
import '../providers/scan_providers.dart';
import '../widgets/camera_viewfinder.dart';
import '../widgets/scan_overlay.dart';

/// Mide una habitación apuntando con la cámara al pie de cada esquina.
///
/// El plano se dibuja encima de la imagen: cada esquina marcada se queda
/// donde está, y desde la última sale una línea que sigue a la mira hasta
/// que se marca la siguiente. Al volver a la primera esquina, el recorrido
/// se engancha a ella y se cierra sin dejar hueco.
///
/// Las medidas son estimaciones: al terminar se abre el plano para
/// corregirlas con el flexómetro.
class RoomScanScreen extends ConsumerStatefulWidget {
  const RoomScanScreen({required this.projectId, super.key});

  final int projectId;

  @override
  ConsumerState<RoomScanScreen> createState() => _RoomScanScreenState();
}

class _RoomScanScreenState extends ConsumerState<RoomScanScreen> {
  static const double _defaultPhoneHeight = 1.50;

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

    final Point2D? aimPoint = (aim == null || distance == null)
        ? null
        : SightingMath.floorPoint(
            distanceMeters: distance,
            turnRadians: aim.turnRadians,
          );
    final List<Point2D> corners = <Point2D>[
      for (final Sighting sighting in _sightings) sighting.point,
    ];
    final int? snapped = aimPoint == null
        ? null
        : ScanSnap.cornerNear(corners, aimPoint);
    final bool closing =
        aimPoint != null && ScanSnap.closesRoom(corners, aimPoint);

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Medir con la cámara'),
        actions: [
          IconButton(
            onPressed: _showHelp,
            tooltip: 'Cómo se mide',
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const CameraViewfinder(),
          ScanOverlay(
            sightings: _sightings,
            aim: aim,
            phoneHeightMeters: phoneHeight,
            liveDistanceMeters: distance,
            snappedCorner: snapped,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _Readout(
              distance: distance,
              hasSensors: aim != null,
              closing: closing,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _ScanBar(
              sightings: _sightings,
              phoneHeight: phoneHeight,
              closing: closing,
              onCapture: distance == null || closing
                  ? null
                  : () => _capture(aim!, distance),
              onClose: closing ? _finish : null,
              onUndo: _sightings.isEmpty ? null : _undo,
              onEditHeight: () => _editHeight(phoneHeight),
              onFinish: _sightings.length < 3 || closing ? null : _finish,
            ),
          ),
        ],
      ),
    );
  }

  void _capture(DeviceAim aim, double distance) {
    setState(() {
      _sightings.add(
        Sighting(distanceMeters: distance, turnRadians: aim.turnRadians),
      );
    });
  }

  void _undo() => setState(_sightings.removeLast);

  Future<void> _editHeight(double current) async {
    final double? height = await NumberPromptDialog.show(
      context,
      title: 'Altura del teléfono',
      label: 'Metros desde el suelo',
      helperText: 'A la altura del pecho suele ser 1,40 o 1,50 m',
      initialText: Formatters.decimal(current),
      validator: (String? value) =>
          MeasureInput.validate(value, min: 0.3, max: 2.5),
      parse: MeasureInput.parse,
    );

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
            '3. Gira sobre ti mismo: desde la esquina marcada sale una '
            'línea que sigue a la mira. Marca la siguiente y la pared '
            'queda hecha.\n'
            '4. Al volver a la primera esquina, la línea se engancha a '
            'ella: ahí se cierra la habitación.\n\n'
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
  const _Readout({
    required this.distance,
    required this.hasSensors,
    required this.closing,
  });

  final double? distance;
  final bool hasSensors;
  final bool closing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool big = distance != null && !closing;
    final String text = switch ((hasSensors, closing, distance)) {
      (false, _, _) => 'Esperando a los sensores…',
      (_, true, _) => 'Estás en la esquina 1: cierra la habitación',
      (_, _, final double value?) => Formatters.meters(value),
      _ => 'Apunta más abajo, al pie de la pared',
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 64, 24, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: closing
                ? AppColors.primaryBlue
                : Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style:
                  (big
                          ? theme.textTheme.headlineSmall
                          : theme.textTheme.bodyMedium)
                      ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
            ),
          ),
        ),
      ),
    );
  }
}

/// La barra de abajo, flotando sobre la imagen.
class _ScanBar extends StatelessWidget {
  const _ScanBar({
    required this.sightings,
    required this.phoneHeight,
    required this.closing,
    required this.onCapture,
    required this.onClose,
    required this.onUndo,
    required this.onEditHeight,
    required this.onFinish,
  });

  final List<Sighting> sightings;
  final double phoneHeight;
  final bool closing;
  final VoidCallback? onCapture;
  final VoidCallback? onClose;
  final VoidCallback? onUndo;
  final VoidCallback onEditHeight;
  final VoidCallback? onFinish;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.transparent, Color(0xE60F172A)],
          stops: <double>[0, 0.45],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: ActionChip(
                      avatar: const Icon(Icons.height, size: 18),
                      backgroundColor: Colors.white24,
                      labelStyle: const TextStyle(color: Colors.white),
                      side: BorderSide.none,
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
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: onUndo,
                    tooltip: 'Quitar la última',
                    color: Colors.white,
                    disabledColor: Colors.white38,
                    icon: const Icon(Icons.undo),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (closing)
                FilledButton.icon(
                  onPressed: onClose,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Cerrar habitación'),
                )
              else
                FilledButton.icon(
                  onPressed: onCapture,
                  icon: const Icon(Icons.add_location_alt_outlined),
                  label: const Text('Marcar esquina'),
                ),
              if (onFinish != null)
                TextButton(
                  onPressed: onFinish,
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('Terminar sin cerrar'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
