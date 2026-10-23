import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/geometry/plan_geometry.dart';
import '../../../../core/geometry/point2d.dart';
import '../../../../core/measuring/sighting_math.dart';
import '../../../../core/measuring/view_projection.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/measure_input.dart';
import '../../../../core/widgets/number_prompt_dialog.dart';
import '../../../rooms/domain/entities/room_drafts.dart';
import '../../../rooms/presentation/widgets/room_form_sheet.dart';
import '../../domain/entities/camera_field_of_view.dart';
import '../../domain/entities/device_aim.dart';
import '../../domain/entities/scan_session.dart';
import '../../domain/services/scan_snap.dart';
import '../providers/scan_providers.dart';
import '../widgets/camera_viewfinder.dart';
import '../widgets/scan_overlay.dart';

/// Paso de la calibración en el que se está.
enum _Calibration { idle, floor, ceiling }

/// Mide una habitación apuntando con la cámara al pie de cada esquina.
///
/// La distancia sale de la inclinación del teléfono, y para eso hace falta
/// saber a qué altura se lleva. En vez de preguntarlo, se calibra mirando el
/// pie y el techo de una pared: con la altura del techo, que sí se sabe,
/// salen la altura del teléfono y la distancia de una vez.
///
/// El plano se dibuja encima de la imagen y las esquinas van en coordenadas
/// de la habitación, así que se puede caminar: se apunta a una esquina ya
/// marcada y la app vuelve a situarse.
class RoomScanScreen extends ConsumerStatefulWidget {
  const RoomScanScreen({required this.projectId, super.key});

  final int projectId;

  @override
  ConsumerState<RoomScanScreen> createState() => _RoomScanScreenState();
}

class _RoomScanScreenState extends ConsumerState<RoomScanScreen> {
  ScanSession _session = ScanSession.empty;

  /// Esquina a la que se está apuntando para volver a situarse, si toca.
  int? _relocatingTo;

  _Calibration _calibration = _Calibration.idle;
  double _ceilingHeight = 2.4;
  double? _floorPitch;

  double _phoneHeight = SightingMath.assumedPhoneHeightMeters;
  bool _calibrated = false;

  @override
  Widget build(BuildContext context) {
    // Sin sensor de giro no hay plano que levantar: se dice y punto.
    final bool canTurn = ref.watch(turnSensorProvider).value ?? true;
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

    final double? distance = aim == null
        ? null
        : SightingMath.distanceToFloorPoint(
            pitchRadians: aim.pitchRadians,
            eyeHeightMeters: _phoneHeight,
          );

    final bool calibrating = _calibration != _Calibration.idle;
    final Point2D? aimPoint = (aim == null || distance == null || calibrating)
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
      body: canTurn
          ? _buildScanner(
              context,
              aim: aim,
              previewAspect: previewAspect,
              fieldOfView: fieldOfView,
              distance: distance,
              calibrating: calibrating,
              relocating: relocating,
              snapped: snapped,
              closing: closing,
              aimPoint: aimPoint,
            )
          : const _NoTurnSensor(),
    );
  }

  Widget _buildScanner(
    BuildContext context, {
    required DeviceAim? aim,
    required double previewAspect,
    required CameraFieldOfView fieldOfView,
    required double? distance,
    required bool calibrating,
    required int? relocating,
    required int? snapped,
    required bool closing,
    required Point2D? aimPoint,
  }) {
    return Stack(
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
                    corners: _session.corners,
                    project: (Point2D floor, Size viewport) {
                      final ({double distance, double turn}) view = _session
                          .viewOf(floor);
                      final Point2D? screen =
                          ViewProjection(
                            widthPx: viewport.width,
                            heightPx: viewport.height,
                            aimTurnRadians: aim?.turnRadians ?? 0,
                            aimPitchRadians: aim?.pitchRadians ?? 0,
                            phoneHeightMeters: _phoneHeight,
                            horizontalFovRadians: fieldOfView.horizontalFor(
                              previewAspect,
                            ),
                          ).project(
                            distanceMeters: view.distance,
                            turnRadians: view.turn,
                          );
                      return screen == null ? null : Offset(screen.x, screen.y);
                    },
                    // Mientras se calibra o se vuelve a situar, la línea
                    // viva estorba.
                    aimPoint: relocating == null && !calibrating
                        ? aimPoint
                        : null,
                    snappedCorner: relocating ?? snapped,
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
            calibration: _calibration,
            // Con esquinas puestas, lo que estropea el plano es caminar.
            warnAboutWalking:
                _session.corners.isNotEmpty &&
                relocating == null &&
                !calibrating,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _ScanBar(
            corners: _session.corners.length,
            calibrated: _calibrated,
            phoneHeight: _phoneHeight,
            calibration: _calibration,
            closing: closing,
            relocatingTo: relocating,
            onCapture:
                distance == null || closing || relocating != null || calibrating
                ? null
                : () => _mark(aim!, distance),
            onClose: closing ? _finish : null,
            onRelocate: distance == null || relocating == null
                ? null
                : () => _relocate(aim!, distance, relocating),
            onCancelRelocate: () => setState(() => _relocatingTo = null),
            onStartRelocate:
                _session.isEmpty || relocating != null || calibrating
                ? null
                : _askWhereIAm,
            onStartCalibration: calibrating ? null : _startCalibration,
            onCalibrationStep: aim == null ? null : () => _calibrateStep(aim),
            onCancelCalibration: () =>
                setState(() => _calibration = _Calibration.idle),
            onUndo: _session.isEmpty || relocating != null || calibrating
                ? null
                : _undo,
            onFinish: _session.corners.length < 3 || closing || calibrating
                ? null
                : _finish,
          ),
        ),
      ],
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

  /// Pregunta la altura del techo y arranca la calibración.
  Future<void> _startCalibration() async {
    final double? ceiling = await NumberPromptDialog.show(
      context,
      title: 'Altura del techo',
      label: 'Metros del suelo al techo',
      helperText: 'Es lo único que hay que saber: con eso salen las demás',
      initialText: Formatters.decimal(_ceilingHeight),
      validator: (String? value) =>
          MeasureInput.validate(value, min: 1.5, max: 6),
      parse: MeasureInput.parse,
    );

    if (ceiling == null || !mounted) return;
    setState(() {
      _ceilingHeight = ceiling;
      _floorPitch = null;
      _calibration = _Calibration.floor;
    });
  }

  void _calibrateStep(DeviceAim aim) {
    if (_calibration == _Calibration.floor) {
      setState(() {
        _floorPitch = aim.pitchRadians;
        _calibration = _Calibration.ceiling;
      });
      return;
    }

    final double? floorPitch = _floorPitch;
    if (floorPitch == null) return;

    final ({double phoneHeight, double distance})? result =
        SightingMath.calibrateWithCeiling(
          ceilingHeightMeters: _ceilingHeight,
          floorAimPitchRadians: floorPitch,
          ceilingAimPitchRadians: aim.pitchRadians,
        );

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No cuadra: apunta al pie de una pared y luego al techo de esa '
            'misma pared.',
          ),
        ),
      );
      setState(() => _calibration = _Calibration.floor);
      return;
    }

    setState(() {
      _phoneHeight = result.phoneHeight;
      _calibrated = true;
      _calibration = _Calibration.idle;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Listo: llevas el teléfono a '
          '${Formatters.meters(result.phoneHeight)} del suelo y esa pared '
          'está a ${Formatters.meters(result.distance)}.',
        ),
      ),
    );
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

  Future<void> _finish() async {
    final List<WallDraft> walls = PlanGeometry.chainFromVertices(
      _session.corners,
    ).map(_toDraft).toList(growable: false);
    if (walls.isEmpty) return;

    await RoomFormSheet.show(
      context,
      projectId: widget.projectId,
      scannedWalls: walls,
      // Si se calibró, la altura del techo ya está medida de verdad.
      wallHeightMeters: _calibrated ? _ceilingHeight : null,
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
            '1. Toca «Sin calibrar» y escribe la altura del techo. Apunta al '
            'pie de una pared, fija, y luego al techo de esa misma pared. '
            'Con eso la app sabe a qué altura llevas el teléfono y mide '
            'bien.\n'
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
            'Todo esto es una estimación: después puedes corregir cada '
            'pared con el flexómetro en el editor del plano.',
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
    required this.calibration,
    required this.warnAboutWalking,
  });

  final double? distance;
  final bool hasSensors;
  final bool closing;
  final int? relocatingTo;
  final _Calibration calibration;

  /// Recuerda que hay que girar sobre uno mismo, no caminar.
  final bool warnAboutWalking;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int? relocating = relocatingTo;
    final bool highlighted =
        closing || relocating != null || calibration != _Calibration.idle;
    final bool big = distance != null && !highlighted;

    final String text = switch ((
      hasSensors,
      calibration,
      relocating,
      closing,
      distance,
    )) {
      (false, _, _, _, _) => 'Esperando a los sensores…',
      (_, _Calibration.floor, _, _, _) =>
        'Apunta al pie de una pared y fija el suelo',
      (_, _Calibration.ceiling, _, _, _) => 'Ahora al techo de esa misma pared',
      (_, _, final int corner?, _, _) =>
        'Apunta al pie de la esquina ${corner + 1} y fija tu posición',
      (_, _, _, true, _) => 'Estás en la esquina 1: cierra la habitación',
      (_, _, _, _, final double value?) => Formatters.meters(value),
      _ => 'Apunta más abajo, al pie de la pared',
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 64, 24, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: highlighted
                    ? AppColors.primaryBlue
                    : Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
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
            if (warnAboutWalking) ...[
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: Text(
                    'Gira sobre ti mismo, sin caminar. Si te mueves, usa '
                    '«Me moví».',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// La barra de abajo, flotando sobre la imagen.
class _ScanBar extends StatelessWidget {
  const _ScanBar({
    required this.corners,
    required this.calibrated,
    required this.phoneHeight,
    required this.calibration,
    required this.closing,
    required this.relocatingTo,
    required this.onCapture,
    required this.onClose,
    required this.onRelocate,
    required this.onCancelRelocate,
    required this.onStartRelocate,
    required this.onStartCalibration,
    required this.onCalibrationStep,
    required this.onCancelCalibration,
    required this.onUndo,
    required this.onFinish,
  });

  final int corners;
  final bool calibrated;
  final double phoneHeight;
  final _Calibration calibration;
  final bool closing;
  final int? relocatingTo;
  final VoidCallback? onCapture;
  final VoidCallback? onClose;
  final VoidCallback? onRelocate;
  final VoidCallback onCancelRelocate;
  final VoidCallback? onStartRelocate;
  final VoidCallback? onStartCalibration;
  final VoidCallback? onCalibrationStep;
  final VoidCallback onCancelCalibration;
  final VoidCallback? onUndo;
  final VoidCallback? onFinish;

  bool get _calibrating => calibration != _Calibration.idle;

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
                      avatar: Icon(
                        calibrated ? Icons.check_circle : Icons.straighten,
                        size: 18,
                        color: calibrated ? AppColors.lightBlue : null,
                      ),
                      backgroundColor: Colors.white24,
                      labelStyle: const TextStyle(color: Colors.white),
                      side: BorderSide.none,
                      label: Text(
                        calibrated
                            ? 'Calibrado · ${Formatters.meters(phoneHeight)}'
                            : 'Sin calibrar',
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: onStartCalibration,
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
              _primaryButton(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_calibrating || relocatingTo != null)
                    Flexible(
                      child: TextButton(
                        onPressed: _calibrating
                            ? onCancelCalibration
                            : onCancelRelocate,
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

  Widget _primaryButton() {
    return switch (calibration) {
      _Calibration.floor => FilledButton.icon(
        onPressed: onCalibrationStep,
        icon: const Icon(Icons.vertical_align_bottom),
        label: const Text('Fijar el suelo'),
      ),
      _Calibration.ceiling => FilledButton.icon(
        onPressed: onCalibrationStep,
        icon: const Icon(Icons.vertical_align_top),
        label: const Text('Fijar el techo'),
      ),
      _Calibration.idle when relocatingTo != null => FilledButton.icon(
        onPressed: onRelocate,
        icon: const Icon(Icons.my_location),
        label: const Text('Estoy aquí'),
      ),
      _Calibration.idle when closing => FilledButton.icon(
        onPressed: onClose,
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Cerrar habitación'),
      ),
      _Calibration.idle => FilledButton.icon(
        onPressed: onCapture,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Marcar esquina'),
      ),
    };
  }
}

/// Lo que se ve cuando el teléfono no tiene con qué medir el giro.
class _NoTurnSensor extends StatelessWidget {
  const _NoTurnSensor();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.screen_rotation_alt_outlined,
              size: 56,
              color: AppColors.lightBlue,
            ),
            const SizedBox(height: 16),
            Text(
              'Este teléfono no puede medir el giro',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Le falta el giroscopio, así que no hay forma de saber hacia '
              'dónde apuntas al girar sobre ti mismo y el plano saldría '
              'inventado.\n\n'
              'Puedes crear la habitación escribiendo el ancho y el largo, '
              'y ajustar cada pared en el plano.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.mutedDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
