import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/geometry/point2d.dart';
import '../../../../core/measuring/view_projection.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/device_aim.dart';
import '../../domain/entities/scan_session.dart';

/// Dibuja el plano encima de la imagen de la cámara.
///
/// Las esquinas van en coordenadas de la habitación, así que se quedan
/// pegadas a su sitio aunque se camine: lo que cambia al moverse es desde
/// dónde se miran. Desde la última sale una línea viva que sigue a la mira
/// hasta que se marca la siguiente.
class ScanOverlay extends StatelessWidget {
  const ScanOverlay({
    required this.session,
    required this.aim,
    required this.phoneHeightMeters,
    required this.liveDistanceMeters,
    required this.snappedCorner,
    super.key,
  });

  final ScanSession session;
  final DeviceAim? aim;
  final double phoneHeightMeters;

  /// Distancia al punto al que se apunta ahora, si la hay.
  final double? liveDistanceMeters;

  /// Esquina resaltada: la enganchada o la que se está usando para
  /// volver a situarse.
  final int? snappedCorner;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ScanOverlayPainter(
        session: session,
        aim: aim,
        phoneHeightMeters: phoneHeightMeters,
        liveDistanceMeters: liveDistanceMeters,
        snappedCorner: snappedCorner,
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  _ScanOverlayPainter({
    required this.session,
    required this.aim,
    required this.phoneHeightMeters,
    required this.liveDistanceMeters,
    required this.snappedCorner,
  });

  final ScanSession session;
  final DeviceAim? aim;
  final double phoneHeightMeters;
  final double? liveDistanceMeters;
  final int? snappedCorner;

  /// El trazo oscuro de debajo: sin él las líneas se pierden sobre la imagen.
  static const Color _halo = Color(0xCC0F172A);

  @override
  void paint(Canvas canvas, Size size) {
    final DeviceAim? aim = this.aim;
    if (aim == null || session.isEmpty) return;

    final ViewProjection projection = ViewProjection(
      widthPx: size.width,
      heightPx: size.height,
      aimTurnRadians: aim.turnRadians,
      aimPitchRadians: aim.pitchRadians,
      phoneHeightMeters: phoneHeightMeters,
    );

    final List<Offset?> corners = <Offset?>[
      for (final Point2D corner in session.corners)
        _project(projection, corner),
    ];

    for (int i = 0; i + 1 < corners.length; i++) {
      _wall(
        canvas,
        corners[i],
        corners[i + 1],
        meters: session.corners[i].distanceTo(session.corners[i + 1]),
        color: AppColors.lightBlue,
      );
    }

    _paintLiveWall(canvas, size, corners, aim);
    _paintCorners(canvas, corners);
  }

  /// La línea que va desde la última esquina hasta donde apunta la mira.
  void _paintLiveWall(
    Canvas canvas,
    Size size,
    List<Offset?> corners,
    DeviceAim aim,
  ) {
    final double? distance = liveDistanceMeters;
    final Offset? from = corners.last;
    if (distance == null || from == null) return;

    final bool closing = snappedCorner == 0 && session.corners.length >= 3;
    final Point2D endPoint = closing
        ? session.corners.first
        : session.aimPoint(
            distanceMeters: distance,
            turnRadians: aim.turnRadians,
          );
    final Offset to = closing
        ? (corners.first ?? Offset(size.width / 2, size.height / 2))
        : Offset(size.width / 2, size.height / 2);

    _wall(
      canvas,
      from,
      to,
      meters: session.corners.last.distanceTo(endPoint),
      color: closing ? Colors.white : AppColors.primaryBlue,
      dashed: !closing,
    );
  }

  void _paintCorners(Canvas canvas, List<Offset?> corners) {
    for (int i = 0; i < corners.length; i++) {
      final Offset? corner = corners[i];
      if (corner == null) continue;

      final bool highlighted = i == snappedCorner;
      if (highlighted) {
        canvas.drawCircle(
          corner,
          18,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      }
      canvas.drawCircle(corner, 9, Paint()..color = _halo);
      canvas.drawCircle(corner, 6, Paint()..color = Colors.white);
      canvas.drawCircle(corner, 3, Paint()..color = AppColors.deepBlue);

      _label(
        canvas,
        // El aro de enganche es más grande: el número se aparta de él.
        corner.translate(0, highlighted ? -36 : -26),
        '${i + 1}',
        background: AppColors.deepBlue,
      );
    }
  }

  Offset? _project(ViewProjection projection, Point2D corner) {
    final ({double distance, double turn}) view = session.viewOf(corner);
    final Point2D? point = projection.project(
      distanceMeters: view.distance,
      turnRadians: view.turn,
    );
    return point == null ? null : Offset(point.x, point.y);
  }

  void _wall(
    Canvas canvas,
    Offset? from,
    Offset? to, {
    required double meters,
    required Color color,
    bool dashed = false,
  }) {
    if (from == null || to == null) return;

    final Paint halo = Paint()
      ..color = _halo
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    final Paint line = Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    if (dashed) {
      _dashedLine(canvas, from, to, halo);
      _dashedLine(canvas, from, to, line);
    } else {
      canvas.drawLine(from, to, halo);
      canvas.drawLine(from, to, line);
    }

    if (meters > 0.05) {
      _label(
        canvas,
        Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2),
        Formatters.meters(meters),
      );
    }
  }

  void _dashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
    const double dash = 14;
    const double gap = 9;
    final double total = (to - from).distance;
    if (total == 0) return;

    final Offset unit = (to - from) / total;
    double covered = 0;
    while (covered < total) {
      final double end = math.min(covered + dash, total);
      canvas.drawLine(from + unit * covered, from + unit * end, paint);
      covered = end + gap;
    }
  }

  void _label(
    Canvas canvas,
    Offset center,
    String text, {
    Color background = _halo,
  }) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final Rect box = Rect.fromCenter(
      center: center,
      width: painter.width + 14,
      height: painter.height + 8,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(box, const Radius.circular(10)),
      Paint()..color = background,
    );
    painter.paint(
      canvas,
      Offset(center.dx - painter.width / 2, center.dy - painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_ScanOverlayPainter oldDelegate) => true;
}
