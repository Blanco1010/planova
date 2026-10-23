import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/geometry/point2d.dart';
import '../../../../core/measuring/sighting_math.dart';
import '../../../../core/measuring/view_projection.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/device_aim.dart';
import '../../domain/entities/sighting.dart';

/// Dibuja el plano encima de la imagen de la cámara.
///
/// Las esquinas marcadas se quedan pegadas al sitio donde están en la
/// habitación, y desde la última sale una línea viva que sigue a la mira
/// hasta que se marca la siguiente.
class ScanOverlay extends StatelessWidget {
  const ScanOverlay({
    required this.sightings,
    required this.aim,
    required this.phoneHeightMeters,
    required this.liveDistanceMeters,
    required this.snappedCorner,
    super.key,
  });

  final List<Sighting> sightings;
  final DeviceAim? aim;
  final double phoneHeightMeters;

  /// Distancia al punto al que se apunta ahora, si la hay.
  final double? liveDistanceMeters;

  /// Esquina a la que se ha enganchado la mira, si hay alguna.
  final int? snappedCorner;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ScanOverlayPainter(
        sightings: sightings,
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
    required this.sightings,
    required this.aim,
    required this.phoneHeightMeters,
    required this.liveDistanceMeters,
    required this.snappedCorner,
  });

  final List<Sighting> sightings;
  final DeviceAim? aim;
  final double phoneHeightMeters;
  final double? liveDistanceMeters;
  final int? snappedCorner;

  /// El trazo oscuro de debajo: sin él las líneas se pierden sobre la imagen.
  static const Color _halo = Color(0xCC0F172A);

  @override
  void paint(Canvas canvas, Size size) {
    final DeviceAim? aim = this.aim;
    if (aim == null || sightings.isEmpty) return;

    final ViewProjection projection = ViewProjection(
      widthPx: size.width,
      heightPx: size.height,
      aimTurnRadians: aim.turnRadians,
      aimPitchRadians: aim.pitchRadians,
      phoneHeightMeters: phoneHeightMeters,
    );

    final List<Offset?> corners = <Offset?>[
      for (final Sighting sighting in sightings)
        _toOffset(
          projection.project(
            distanceMeters: sighting.distanceMeters,
            turnRadians: sighting.turnRadians,
          ),
        ),
    ];

    for (int i = 0; i + 1 < corners.length; i++) {
      _wall(
        canvas,
        corners[i],
        corners[i + 1],
        meters: sightings[i].point.distanceTo(sightings[i + 1].point),
        color: AppColors.lightBlue,
      );
    }

    _paintLiveWall(canvas, size, corners);
    _paintCorners(canvas, corners);
  }

  /// La línea que va desde la última esquina hasta donde apunta la mira.
  void _paintLiveWall(Canvas canvas, Size size, List<Offset?> corners) {
    final double? distance = liveDistanceMeters;
    final Offset? from = corners.last;
    if (distance == null || from == null) return;

    final bool closing = snappedCorner == 0 && sightings.length >= 3;
    final Offset to = closing
        ? (corners.first ?? Offset(size.width / 2, size.height / 2))
        : Offset(size.width / 2, size.height / 2);

    final Point2D aimPoint = SightingMath.floorPoint(
      distanceMeters: distance,
      turnRadians: aim!.turnRadians,
    );
    final Point2D endPoint = closing ? sightings.first.point : aimPoint;

    _wall(
      canvas,
      from,
      to,
      meters: sightings.last.point.distanceTo(endPoint),
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

  Offset? _toOffset(Point2D? point) =>
      point == null ? null : Offset(point.x, point.y);

  @override
  bool shouldRepaint(_ScanOverlayPainter oldDelegate) => true;
}
