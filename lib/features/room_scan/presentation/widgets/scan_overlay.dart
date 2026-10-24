import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/geometry/point2d.dart';
import '../../../../core/utils/formatters.dart';

/// Mete el cuadro de una medida dentro de la pantalla.
///
/// Pegado al borde se leía a medias: se empuja hacia dentro lo justo para
/// que quepa entero. Si no cabe de ninguna manera, se centra.
@visibleForTesting
Offset labelCenterInside(
  Offset center,
  Size label,
  Rect visible, {
  double margin = 8,
}) {
  final double halfWidth = label.width / 2;
  final double halfHeight = label.height / 2;
  final double minX = visible.left + margin + halfWidth;
  final double maxX = visible.right - margin - halfWidth;
  final double minY = visible.top + margin + halfHeight;
  final double maxY = visible.bottom - margin - halfHeight;

  return Offset(
    minX > maxX ? visible.center.dx : center.dx.clamp(minX, maxX),
    minY > maxY ? visible.center.dy : center.dy.clamp(minY, maxY),
  );
}

/// Dibuja el plano encima de la imagen de la cámara.
///
/// No sabe de dónde salen las medidas: recibe las esquinas en planta y una
/// forma de llevarlas a la pantalla. Así sirve igual con los sensores del
/// teléfono que con el seguimiento espacial de ARCore.
class ScanOverlay extends StatelessWidget {
  const ScanOverlay({
    required this.corners,
    required this.project,
    required this.aimPoint,
    required this.snappedCorner,
    this.visible,
    super.key,
  });

  /// Esquinas marcadas, vistas desde arriba.
  final List<Point2D> corners;

  /// Dónde cae en la pantalla un punto de la planta, dentro de un lienzo de
  /// ese tamaño; `null` si no se ve.
  final Offset? Function(Point2D floorPoint, Size viewport) project;

  /// Dónde apunta la mira ahora, en planta; `null` si no hay medida.
  final Point2D? aimPoint;

  /// Esquina resaltada: la enganchada o la que se usa para situarse.
  final int? snappedCorner;

  /// El trozo del encuadre que se ve en la pantalla; si falta, se ve entero.
  /// Las medidas se escriben siempre dentro de él.
  final Rect? visible;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ScanOverlayPainter(
        corners: corners,
        project: project,
        aimPoint: aimPoint,
        snappedCorner: snappedCorner,
        visible: visible,
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  _ScanOverlayPainter({
    required this.corners,
    required this.project,
    required this.aimPoint,
    required this.snappedCorner,
    required this.visible,
  });

  final List<Point2D> corners;
  final Offset? Function(Point2D floorPoint, Size viewport) project;
  final Point2D? aimPoint;
  final int? snappedCorner;
  final Rect? visible;

  /// El trazo oscuro de debajo: sin él las líneas se pierden sobre la imagen.
  static const Color _halo = Color(0xCC0F172A);

  @override
  void paint(Canvas canvas, Size size) {
    if (corners.isEmpty) return;

    final Rect onScreen = visible ?? (Offset.zero & size);

    final List<Offset?> screen = <Offset?>[
      for (final Point2D corner in corners) project(corner, size),
    ];

    for (int i = 0; i + 1 < screen.length; i++) {
      _wall(
        canvas,
        onScreen,
        screen[i],
        screen[i + 1],
        meters: corners[i].distanceTo(corners[i + 1]),
        color: AppColors.lightBlue,
      );
    }

    _paintLiveWall(canvas, size, screen);
    _paintCorners(canvas, onScreen, screen);
  }

  /// La línea que va desde la última esquina hasta donde apunta la mira.
  void _paintLiveWall(Canvas canvas, Size size, List<Offset?> screen) {
    final Point2D? aim = aimPoint;
    final Offset? from = screen.last;
    if (aim == null || from == null) return;

    final bool closing = snappedCorner == 0 && corners.length >= 3;
    final Point2D endPoint = closing ? corners.first : aim;
    final Offset to = closing
        ? (screen.first ?? size.center(Offset.zero))
        : size.center(Offset.zero);

    _wall(
      canvas,
      visible ?? (Offset.zero & size),
      from,
      to,
      meters: corners.last.distanceTo(endPoint),
      color: closing ? Colors.white : AppColors.primaryBlue,
      dashed: !closing,
      // La mira ya tiene su cruz: la medida se aparta de ella.
      labelAt: 0.35,
    );
  }

  void _paintCorners(Canvas canvas, Rect onScreen, List<Offset?> screen) {
    for (int i = 0; i < screen.length; i++) {
      final Offset? corner = screen[i];
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
        onScreen,
        // El aro de enganche es más grande: el número se aparta de él.
        corner.translate(0, highlighted ? -34 : -24),
        '${i + 1}',
        background: AppColors.deepBlue,
        fontSize: 11,
        padding: 6,
      );
    }
  }

  void _wall(
    Canvas canvas,
    Rect onScreen,
    Offset? from,
    Offset? to, {
    required double meters,
    required Color color,
    bool dashed = false,
    double labelAt = 0.5,
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

    // En un tramo corto la etiqueta tapa más de lo que explica.
    final double drawn = (to - from).distance;
    if (meters > 0.05 && drawn > 56) {
      final Offset middle = from + (to - from) * labelAt;
      final Offset unit = (to - from) / drawn;
      // Apartada de la línea, para que el trazo no cruce los números.
      final Offset away = Offset(-unit.dy, unit.dx) * 22;
      _label(canvas, onScreen, middle + away, Formatters.meters(meters));
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
    Rect onScreen,
    Offset center,
    String text, {
    Color background = _halo,
    double fontSize = 17,
    double padding = 12,
  }) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final Size label = Size(
      painter.width + padding * 2,
      painter.height + padding,
    );
    final Offset inside = labelCenterInside(center, label, onScreen);
    final Rect box = Rect.fromCenter(
      center: inside,
      width: label.width,
      height: label.height,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(box, const Radius.circular(12)),
      Paint()..color = background,
    );
    painter.paint(
      canvas,
      Offset(inside.dx - painter.width / 2, inside.dy - painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_ScanOverlayPainter oldDelegate) => true;
}
