import 'package:camera/camera.dart';
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
import '../../domain/entities/camera_field_of_view.dart';
import '../../domain/entities/device_aim.dart';
import '../../domain/entities/scan_session.dart';
import '../../domain/services/scan_snap.dart';
import '../providers/scan_providers.dart';
import '../widgets/camera_viewfinder.dart';
import '../widgets/scan_overlay.dart';

/// Mide una habitación apuntando con la cámara al pie de cada esquina.
///
/// El plano se dibuja encima de la imagen y las esquinas van en coordenadas
/// de la habitación, así que se quedan en su sitio. Si hace falta caminar,
/// se apunta a una esquina ya marcada y la app vuelve a situarse.
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

  ScanSession _session = ScanSession.empty;

  /// Esquina a la que se está apuntando para volver a situarse, si toca.
  int? _relocatingTo;

  @override
  Widget build(BuildContext context) {
    final DeviceAim? aim = ref.watch(deviceAimProvider).value;
    final CameraController? camera = ref.watch(cameraControllerProvider).value;
    // De pie, la imagen es más alta que ancha: 3 de ancho por 4 de alto si
    // todavía no se sabe la de la cámara.
    final double previewAspect = camera == null
        ? 3 / 4
        : 1 / camera.value.aspectRatio;
    final CameraFieldOfView fieldOfView =
        ref.watch(cameraFieldOfViewProvider).value ??
        CameraFieldOfView.estimated;
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
        : _session.aimPoint(
            distanceMeters: distance,
            turnRadians: aim.turnRadians,
          );
    final int? relocating = _relocatingTo;
    final int? snapped = (aimPoint == null || relocating != null)
        ? null
        : ScanSnap.cornerNear(_session.corners, aimPoint);
    final bool closing =
        relocating == null &&
        aimPoint != null &&
        ScanSnap.closesRoom(_session.corners, aimPoint);

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
          // El dibujo va dentro del mismo encuadre que la imagen: así el
          // ángulo de la cámara vale para colocar cada esquina.
          Center(
            child: AspectRatio(
              aspectRatio: previewAspect,
              // Lo que se dibuje fuera de la imagen no se enseña: ahí ya no
              // hay nada que mirar.
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const CameraViewfinder(),
                    ScanOverlay(
                      session: _session,
                      aim: aim,
                      phoneHeightMeters: phoneHeight,
                      // Mientras se vuelve a situar, la línea viva estorba:
                      // todavía sale del sitio antiguo.
                      liveDistanceMeters: relocating == null ? distance : null,
                      snappedCorner: relocating ?? snapped,
                      horizontalFovRadians: fieldOfView.horizontalFor(
                        previewAspect,
                      ),
                    ),
                    const ScanReticle(),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _Readout(
              distance: distance,
              hasSensors: aim != null,
              closing: closing,
              relocatingTo: relocating,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _ScanBar(
              corners: _session.corners.length,
              phoneHeight: phoneHeight,
              closing: closing,
              relocatingTo: relocating,
              onCapture: distance == null || closing || relocating != null
                  ? null
                  : () => _mark(aim!, distance),
              onClose: closing ? _finish : null,
              onRelocate: distance == null || relocating == null
                  ? null
                  : () => _relocate(aim!, distance, relocating),
              onCancelRelocate: () => setState(() => _relocatingTo = null),
              onStartRelocate: _session.isEmpty || relocating != null
                  ? null
                  : _askWhereIAm,
              onUndo: _session.isEmpty || relocating != null ? null : _undo,
              onEditHeight: () => _editHeight(phoneHeight),
              onFinish: _session.corners.length < 3 || closing ? null : _finish,
            ),
          ),
        ],
      ),
    );
  }

  void _mark(DeviceAim aim, double distance) {
    setState(() {
      _session = _session.mark(
        distanceMeters: distance,
        turnRadians: aim.turnRadians,
      );
    });
  }

  void _undo() => setState(() => _session = _session.withoutLast());

  /// Vuelve a situar al que mide a partir de una esquina ya marcada.
  void _relocate(DeviceAim aim, double distance, int cornerIndex) {
    setState(() {
      _session = _session.relocateFrom(
        cornerIndex,
        distanceMeters: distance,
        turnRadians: aim.turnRadians,
      );
      _relocatingTo = null;
    });
  }

  /// Pregunta a qué esquina se está apuntando desde el sitio nuevo.
  Future<void> _askWhereIAm() async {
    final int count = _session.corners.length;
    if (count == 1) {
      setState(() => _relocatingTo = 0);
      return;
    }

    final int? corner = await showDialog<int>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('¿A qué esquina apuntas?'),
        content: const Text(
          'Desde donde estás ahora, apunta al pie de una esquina que ya '
          'hayas marcado. Con eso la app vuelve a saber dónde estás y el '
          'plano no se mueve.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          for (int i = 0; i < count; i++)
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(i),
              child: Text('${i + 1}'),
            ),
        ],
      ),
    );

    if (corner == null || !mounted) return;
    setState(() => _relocatingTo = corner);
  }

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
    final List<WallDraft> walls = PlanGeometry.chainFromVertices(
      _session.corners,
    ).map(_toDraft).toList(growable: false);
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

  WallDraft _toDraft(WallStep step) =>
      WallDraft(lengthMeters: step.lengthMeters, turnDegrees: step.turnDegrees);

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Cómo se mide'),
        content: const SingleChildScrollView(
          child: Text(
            '1. Comprueba la altura a la que llevas el teléfono.\n'
            '2. Apunta con la mira al pie de una esquina, donde la pared '
            'toca el suelo, y marca.\n'
            '3. Gira sobre ti mismo: desde la esquina marcada sale una '
            'línea que sigue a la mira. Marca la siguiente y la pared '
            'queda hecha.\n'
            '4. Al volver a la primera esquina, la línea se engancha a '
            'ella: ahí se cierra la habitación.\n\n'
            'Si tienes que caminar, toca «Me moví», apunta a una esquina '
            'que ya hayas marcado y fija tu posición: el plano se queda '
            'donde está.\n\n'
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
    required this.relocatingTo,
  });

  final double? distance;
  final bool hasSensors;
  final bool closing;
  final int? relocatingTo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int? relocating = relocatingTo;
    final bool big = distance != null && !closing && relocating == null;
    final String text = switch ((hasSensors, relocating, closing, distance)) {
      (false, _, _, _) => 'Esperando a los sensores…',
      (_, final int corner?, _, _) =>
        'Apunta al pie de la esquina ${corner + 1} y fija tu posición',
      (_, _, true, _) => 'Estás en la esquina 1: cierra la habitación',
      (_, _, _, final double value?) => Formatters.meters(value),
      _ => 'Apunta más abajo, al pie de la pared',
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 64, 24, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: closing || relocating != null
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
    required this.corners,
    required this.phoneHeight,
    required this.closing,
    required this.relocatingTo,
    required this.onCapture,
    required this.onClose,
    required this.onRelocate,
    required this.onCancelRelocate,
    required this.onStartRelocate,
    required this.onUndo,
    required this.onEditHeight,
    required this.onFinish,
  });

  final int corners;
  final double phoneHeight;
  final bool closing;
  final int? relocatingTo;
  final VoidCallback? onCapture;
  final VoidCallback? onClose;
  final VoidCallback? onRelocate;
  final VoidCallback onCancelRelocate;
  final VoidCallback? onStartRelocate;
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
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
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
                      corners == 1 ? '1 esquina' : '$corners esquinas',
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
              if (relocatingTo != null)
                FilledButton.icon(
                  onPressed: onRelocate,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Estoy aquí'),
                )
              else if (closing)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (relocatingTo != null)
                    Flexible(
                      child: TextButton(
                        onPressed: onCancelRelocate,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Cancelar',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: TextButton.icon(
                        onPressed: onStartRelocate,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white38,
                        ),
                        icon: const Icon(Icons.directions_walk, size: 18),
                        label: const Text(
                          'Me moví',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  if (onFinish != null)
                    Flexible(
                      child: TextButton(
                        onPressed: onFinish,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Terminar sin cerrar',
                          overflow: TextOverflow.ellipsis,
                        ),
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
