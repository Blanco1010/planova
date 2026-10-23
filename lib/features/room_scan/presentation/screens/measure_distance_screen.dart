import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/geometry/point2d.dart';
import '../../../../core/geometry/point3d.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/scan_surface.dart';
import '../../domain/entities/spatial_frame.dart';
import '../providers/scan_providers.dart';
import '../services/spatial_scanner.dart';
import '../widgets/camera_viewfinder.dart';

/// Mide una distancia con la cámara y la devuelve.
///
/// Sirve para rehacer una pared que salió mal sin escanear la habitación
/// entera: se marca un extremo, se apunta al otro y ya está.
class MeasureDistanceScreen extends ConsumerStatefulWidget {
  const MeasureDistanceScreen({
    required this.title,
    this.surface = ScanSurface.wall,
    super.key,
  });

  /// Abre la pantalla y devuelve los metros medidos, o `null` si se cancela.
  static Future<double?> show(
    BuildContext context, {
    required String title,
    ScanSurface surface = ScanSurface.wall,
  }) {
    return Navigator.of(context).push<double>(
      MaterialPageRoute<double>(
        builder: (BuildContext context) =>
            MeasureDistanceScreen(title: title, surface: surface),
      ),
    );
  }

  final String title;

  /// Qué mira la cámara mientras se mide.
  final ScanSurface surface;

  @override
  ConsumerState<MeasureDistanceScreen> createState() =>
      _MeasureDistanceScreenState();
}

class _MeasureDistanceScreenState extends ConsumerState<MeasureDistanceScreen> {
  SpatialFrame? _frame;
  Point3D? _from;

  @override
  Widget build(BuildContext context) {
    final SpatialScanner scanner = ref.watch(spatialScannerProvider);
    final SpatialHit? hit = _frame?.aim;
    final Point3D? from = _from;
    final double? measure = (from == null || hit == null)
        ? null
        : from.distanceTo(hit.point);

    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          scanner.view(
            surface: widget.surface,
            onFrame: (SpatialFrame? frame) {
              if (!mounted) return;
              setState(() => _frame = frame);
            },
          ),
          CustomPaint(
            size: Size.infinite,
            painter: _MeasurePainter(from: from, frame: _frame),
          ),
          const ScanReticle(),
          Align(
            alignment: Alignment.topCenter,
            child: _Readout(hit: hit, measure: measure),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _Bar(
              hasStart: from != null,
              onStart: hit == null ? null : () => _start(hit),
              onRestart: () => setState(() => _from = null),
              onUse: measure == null
                  ? null
                  : () => Navigator.of(context).pop(measure),
              measure: measure,
            ),
          ),
        ],
      ),
    );
  }

  void _start(SpatialHit hit) => setState(() => _from = hit.point);
}

class _MeasurePainter extends CustomPainter {
  _MeasurePainter({required this.from, required this.frame});

  final Point3D? from;
  final SpatialFrame? frame;

  @override
  void paint(Canvas canvas, Size size) {
    final Point3D? from = this.from;
    final SpatialFrame? frame = this.frame;
    if (from == null || frame == null) return;

    final Point2D? start = frame.project(from);
    if (start == null) return;

    final Offset a = Offset(start.x, start.y);
    final Offset b = size.center(Offset.zero);

    canvas.drawLine(
      a,
      b,
      Paint()
        ..color = const Color(0xCC0F172A)
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      a,
      b,
      Paint()
        ..color = AppColors.primaryBlue
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(a, 8, Paint()..color = Colors.white);
    canvas.drawCircle(a, 4, Paint()..color = AppColors.deepBlue);
  }

  @override
  bool shouldRepaint(_MeasurePainter oldDelegate) => true;
}

class _Readout extends StatelessWidget {
  const _Readout({required this.hit, required this.measure});

  final SpatialHit? hit;
  final double? measure;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String text = switch ((measure, hit)) {
      (final double value?, _) => Formatters.meters(value),
      (_, null) => 'Mueve el teléfono despacio para reconocer la superficie',
      _ => 'Apunta a un extremo y márcalo',
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 64, 24, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style:
                  (measure == null
                          ? theme.textTheme.bodyMedium
                          : theme.textTheme.headlineSmall)
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

class _Bar extends StatelessWidget {
  const _Bar({
    required this.hasStart,
    required this.onStart,
    required this.onRestart,
    required this.onUse,
    required this.measure,
  });

  final bool hasStart;
  final VoidCallback? onStart;
  final VoidCallback onRestart;
  final VoidCallback? onUse;
  final double? measure;

  @override
  Widget build(BuildContext context) {
    final double? measure = this.measure;

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
              if (!hasStart)
                FilledButton.icon(
                  onPressed: onStart,
                  icon: const Icon(Icons.adjust),
                  label: const Text('Marcar el principio'),
                )
              else
                FilledButton.icon(
                  onPressed: onUse,
                  icon: const Icon(Icons.check),
                  label: Text(
                    measure == null
                        ? 'Apunta al otro extremo'
                        : 'Usar ${Formatters.meters(measure)}',
                  ),
                ),
              if (hasStart)
                TextButton(
                  onPressed: onRestart,
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('Empezar de nuevo'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
