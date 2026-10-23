import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/geometry/plan_geometry.dart';
import '../../../../core/geometry/point2d.dart';
import '../../../../core/geometry/point3d.dart';
import '../../../../core/utils/formatters.dart';
import '../../../rooms/domain/entities/room_drafts.dart';
import '../../../rooms/presentation/widgets/room_form_sheet.dart';
import '../../domain/entities/spatial_frame.dart';
import '../../domain/services/scan_snap.dart';
import '../providers/scan_providers.dart';
import '../services/spatial_scanner.dart';
import '../widgets/camera_viewfinder.dart';
import '../widgets/scan_overlay.dart';

/// Mide una habitación con el seguimiento espacial del teléfono (ARCore).
///
/// Aquí la cámara mide de verdad: el aparato sabe a qué distancia está el
/// suelo que tiene delante y dónde está él mismo. Por eso no hay que decir a
/// qué altura se lleva el teléfono, ni calibrar, ni avisar de que uno se
/// mueve: se puede caminar y las esquinas se quedan donde están.
class SpatialScanScreen extends ConsumerStatefulWidget {
  const SpatialScanScreen({required this.projectId, super.key});

  final int projectId;

  @override
  ConsumerState<SpatialScanScreen> createState() => _SpatialScanScreenState();
}

class _SpatialScanScreenState extends ConsumerState<SpatialScanScreen> {
  final List<Point2D> _corners = <Point2D>[];

  /// Altura del suelo de esta habitación, la del primer punto marcado.
  double? _floorY;

  SpatialFrame? _frame;

  @override
  Widget build(BuildContext context) {
    final SpatialScanner scanner = ref.watch(spatialScannerProvider);
    final SpatialFrame? frame = _frame;
    final SpatialHit? hit = frame?.aim;
    final Point2D? aimPoint = hit?.point.onFloor;
    final int? snapped = aimPoint == null
        ? null
        : ScanSnap.cornerNear(_corners, aimPoint);
    final bool closing =
        aimPoint != null && ScanSnap.closesRoom(_corners, aimPoint);

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
          scanner.view(
            onFrame: (SpatialFrame? frame) {
              if (!mounted) return;
              setState(() => _frame = frame);
            },
          ),
          ScanOverlay(
            corners: _corners,
            project: _project,
            aimPoint: aimPoint,
            snappedCorner: snapped,
          ),
          const ScanReticle(),
          Align(
            alignment: Alignment.topCenter,
            child: _Readout(hit: hit, closing: closing),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _SpatialBar(
              corners: _corners.length,
              walls: _wallLengths,
              closing: closing,
              onMark: hit == null || closing ? null : () => _mark(hit),
              onClose: closing ? _finish : null,
              onUndo: _corners.isEmpty ? null : _undo,
              onFinish: _corners.length < 3 || closing ? null : _finish,
            ),
          ),
        ],
      ),
    );
  }

  /// Dónde cae en la pantalla un punto del suelo de la habitación.
  Offset? _project(Point2D floor, Size viewport) {
    final double? floorY = _floorY;
    final SpatialFrame? frame = _frame;
    if (floorY == null || frame == null) return null;

    final Point2D? screen = frame.project(Point3D(floor.x, floorY, floor.y));
    return screen == null ? null : Offset(screen.x, screen.y);
  }

  void _mark(SpatialHit hit) {
    setState(() {
      _floorY ??= hit.point.y;
      _corners.add(hit.point.onFloor);
    });
  }

  void _undo() => setState(_corners.removeLast);

  /// Lo que mide cada pared ya cerrada entre dos esquinas.
  List<double> get _wallLengths => <double>[
    for (int i = 0; i + 1 < _corners.length; i++)
      _corners[i].distanceTo(_corners[i + 1]),
  ];

  Future<void> _finish() async {
    final List<WallDraft> walls = PlanGeometry.chainFromVertices(_corners)
        .map(
          (WallStep step) => WallDraft(
            lengthMeters: step.lengthMeters,
            turnDegrees: step.turnDegrees,
          ),
        )
        .toList(growable: false);
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

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Cómo se mide'),
        content: const SingleChildScrollView(
          child: Text(
            '1. Mueve despacio el teléfono apuntando al suelo hasta que la '
            'app reconozca la superficie.\n'
            '2. Apunta con la mira al pie de una esquina y marca.\n'
            '3. Ve a la siguiente esquina y marca otra vez: la pared queda '
            'hecha con su medida. Puedes caminar, que el plano no se '
            'mueve.\n'
            '4. Al volver a la primera esquina, la línea se engancha a '
            'ella: ahí se cierra la habitación.\n\n'
            'Aquí la distancia la mide el aparato, no se estima. Aun así '
            'conviene revisar las paredes en el plano antes de comprar '
            'material.',
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
  const _Readout({required this.hit, required this.closing});

  final SpatialHit? hit;
  final bool closing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final SpatialHit? hit = this.hit;
    final String text = switch ((closing, hit)) {
      (true, _) => 'Estás en la esquina 1: cierra la habitación',
      (_, final SpatialHit hit) => Formatters.meters(hit.distanceMeters),
      _ => 'Mueve el teléfono despacio para reconocer el suelo',
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
                  (hit != null && !closing
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
class _SpatialBar extends StatelessWidget {
  const _SpatialBar({
    required this.corners,
    required this.walls,
    required this.closing,
    required this.onMark,
    required this.onClose,
    required this.onUndo,
    required this.onFinish,
  });

  final int corners;

  /// Lo que mide cada pared hecha hasta ahora.
  final List<double> walls;

  final bool closing;
  final VoidCallback? onMark;
  final VoidCallback? onClose;
  final VoidCallback? onUndo;
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
              if (walls.isNotEmpty)
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: walls.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (BuildContext context, int index) => Chip(
                      backgroundColor: Colors.white24,
                      side: BorderSide.none,
                      labelStyle: const TextStyle(color: Colors.white),
                      label: Text(
                        'Pared ${index + 1} · ${Formatters.meters(walls[index])}',
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      corners == 1 ? '1 esquina' : '$corners esquinas',
                      style: const TextStyle(color: Colors.white),
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
                  onPressed: onMark,
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
