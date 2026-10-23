import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/geometry/plan_geometry.dart';
import '../../../../core/geometry/point2d.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/opening.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_plan.dart';
import '../../domain/entities/room_wall.dart';

/// Dibujo del plano de una habitación: paredes, medidas y vanos.
///
/// Al tocar una pared se avisa con [onWallTap], así el plano es la vía normal
/// para editarla.
class FloorPlanView extends StatelessWidget {
  const FloorPlanView({
    required this.room,
    required this.plan,
    this.selectedWallId,
    this.onWallTap,
    super.key,
  });

  final Room room;
  final RoomPlan plan;
  final int? selectedWallId;
  final ValueChanged<RoomWall>? onWallTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (plan.vertices.length < 2) {
      return Center(
        child: Text(
          'Añade al menos dos paredes para ver el plano',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);
        final _PlanTransform transform = _PlanTransform.fit(
          size: size,
          bounds: PlanGeometry.boundsOf(plan.vertices),
        );

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (TapUpDetails details) =>
              _handleTap(details.localPosition, transform),
          child: CustomPaint(
            size: size,
            painter: _FloorPlanPainter(
              room: room,
              plan: plan,
              transform: transform,
              selectedWallId: selectedWallId,
              wallColor: theme.brightness == Brightness.light
                  ? AppColors.deepBlue
                  : AppColors.onDark,
              selectedColor: AppColors.primaryBlue,
              fillColor: AppColors.primaryBlue.withValues(alpha: 0.08),
              guideColor: AppColors.lightBlue,
              labelColor: theme.colorScheme.onSurface,
              gapColor: theme.colorScheme.surface,
              labelStyle:
                  theme.textTheme.labelSmall ?? const TextStyle(fontSize: 11),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(Offset position, _PlanTransform transform) {
    final ValueChanged<RoomWall>? callback = onWallTap;
    if (callback == null || room.walls.isEmpty) return;

    final Point2D target = transform.toPlan(position);
    final double tolerance = transform.metersPerPixel * 28;

    RoomWall? closest;
    double closestDistance = double.infinity;
    for (int i = 0; i < room.walls.length && i < plan.vertices.length; i++) {
      final (Point2D start, Point2D end) = plan.segmentAt(i);
      final double distance = PlanGeometry.distanceToSegment(
        target,
        start,
        end,
      );
      if (distance < closestDistance) {
        closestDistance = distance;
        closest = room.walls[i];
      }
    }

    if (closest != null && closestDistance <= tolerance) callback(closest);
  }
}

/// Lleva metros del plano a píxeles del lienzo, y al revés.
class _PlanTransform {
  const _PlanTransform._(this._scale, this._offset, this._bounds);

  factory _PlanTransform.fit({
    required Size size,
    required PlanBounds bounds,
    double padding = 32,
  }) {
    final double availableWidth = math.max(size.width - padding * 2, 1);
    final double availableHeight = math.max(size.height - padding * 2, 1);
    final double horizontal = bounds.width > 0
        ? availableWidth / bounds.width
        : double.infinity;
    final double vertical = bounds.height > 0
        ? availableHeight / bounds.height
        : double.infinity;

    double scale = math.min(horizontal, vertical);
    if (!scale.isFinite || scale <= 0) scale = 40;

    final Offset offset = Offset(
      (size.width - bounds.width * scale) / 2,
      (size.height - bounds.height * scale) / 2,
    );
    return _PlanTransform._(scale, offset, bounds);
  }

  final double _scale;
  final Offset _offset;
  final PlanBounds _bounds;

  double get metersPerPixel => 1 / _scale;

  Offset toCanvas(Point2D point) => Offset(
    (point.x - _bounds.min.x) * _scale + _offset.dx,
    (point.y - _bounds.min.y) * _scale + _offset.dy,
  );

  Point2D toPlan(Offset position) => Point2D(
    (position.dx - _offset.dx) / _scale + _bounds.min.x,
    (position.dy - _offset.dy) / _scale + _bounds.min.y,
  );
}

class _FloorPlanPainter extends CustomPainter {
  _FloorPlanPainter({
    required this.room,
    required this.plan,
    required this.transform,
    required this.selectedWallId,
    required this.wallColor,
    required this.selectedColor,
    required this.fillColor,
    required this.guideColor,
    required this.labelColor,
    required this.gapColor,
    required this.labelStyle,
  });

  final Room room;
  final RoomPlan plan;
  final _PlanTransform transform;
  final int? selectedWallId;
  final Color wallColor;
  final Color selectedColor;
  final Color fillColor;
  final Color guideColor;
  final Color labelColor;
  final Color gapColor;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final List<Offset> points = plan.vertices
        .map(transform.toCanvas)
        .toList(growable: false);
    if (points.length < 2) return;

    _paintFloor(canvas, points);

    final Point2D centroid = PlanGeometry.centroidOf(plan.vertices);
    for (int i = 0; i < room.walls.length && i < plan.vertices.length; i++) {
      final RoomWall wall = room.walls[i];
      final (Point2D startPoint, Point2D endPoint) = plan.segmentAt(i);
      final Offset start = transform.toCanvas(startPoint);
      final Offset end = transform.toCanvas(endPoint);
      final bool selected = wall.id == selectedWallId;

      _paintWall(canvas, start, end, selected);
      _paintOpenings(canvas, wall, start, end, centroid);
      _paintDimension(canvas, wall, startPoint, endPoint, centroid, selected);
    }

    _paintVertices(canvas, points);
  }

  void _paintFloor(Canvas canvas, List<Offset> points) {
    final Path path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final Offset point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = fillColor);
  }

  void _paintWall(Canvas canvas, Offset start, Offset end, bool selected) {
    canvas.drawLine(
      start,
      end,
      Paint()
        ..color = selected ? selectedColor : wallColor
        ..strokeWidth = selected ? 6 : 4
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Abre el hueco del vano sobre la pared y lo marca: arco en las puertas,
  /// línea fina en las ventanas.
  void _paintOpenings(
    Canvas canvas,
    RoomWall wall,
    Offset start,
    Offset end,
    Point2D centroid,
  ) {
    if (wall.openings.isEmpty || wall.lengthMeters <= 0) return;

    final Offset direction = end - start;
    final double pixelLength = direction.distance;
    if (pixelLength == 0) return;
    final Offset unit = direction / pixelLength;
    final Offset inward = _inwardNormal(start, end, centroid);

    for (final Opening opening in wall.openings) {
      final double from = (opening.distanceFromStartMeters / wall.lengthMeters)
          .clamp(0.0, 1.0);
      final double to =
          ((opening.distanceFromStartMeters + opening.widthMeters) /
                  wall.lengthMeters)
              .clamp(0.0, 1.0);
      if (to <= from) continue;

      final Offset openingStart = start + unit * (pixelLength * from);
      final Offset openingEnd = start + unit * (pixelLength * to);

      // El hueco: tapa la pared en ese tramo.
      canvas.drawLine(
        openingStart,
        openingEnd,
        Paint()
          ..color = gapColor
          ..strokeWidth = 8,
      );

      final Paint markPaint = Paint()
        ..color = opening.kind == OpeningKind.door ? wallColor : guideColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      if (opening.kind == OpeningKind.window) {
        canvas.drawLine(openingStart, openingEnd, markPaint);
        continue;
      }

      final double radius = (openingEnd - openingStart).distance;
      final Offset leafEnd = openingStart + inward * radius;
      canvas.drawLine(openingStart, leafEnd, markPaint);
      canvas.drawArc(
        Rect.fromCircle(center: openingStart, radius: radius),
        math.atan2(unit.dy, unit.dx),
        _sweepTowards(unit, inward),
        false,
        markPaint,
      );
    }
  }

  void _paintDimension(
    Canvas canvas,
    RoomWall wall,
    Point2D startPoint,
    Point2D endPoint,
    Point2D centroid,
    bool selected,
  ) {
    final Offset start = transform.toCanvas(startPoint);
    final Offset end = transform.toCanvas(endPoint);
    final Offset outward = -_inwardNormal(start, end, centroid);
    final Offset middle = (start + end) / 2;

    // Guía corta por fuera de la pared.
    canvas.drawLine(
      start + outward * 10,
      end + outward * 10,
      Paint()
        ..color = guideColor
        ..strokeWidth = selected ? 2 : 1,
    );

    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: Formatters.meters(wall.lengthMeters),
        style: labelStyle.copyWith(
          color: selected ? selectedColor : labelColor,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final Offset labelCenter = middle + outward * 20;
    painter.paint(
      canvas,
      Offset(
        labelCenter.dx - painter.width / 2,
        labelCenter.dy - painter.height / 2,
      ),
    );
  }

  void _paintVertices(Canvas canvas, List<Offset> points) {
    final Paint paint = Paint()..color = wallColor;
    for (final Offset point in points) {
      canvas.drawCircle(point, 3.5, paint);
    }
  }

  /// Normal de la pared que apunta hacia dentro de la habitación.
  Offset _inwardNormal(Offset start, Offset end, Point2D centroid) {
    final Offset direction = end - start;
    final double length = direction.distance;
    if (length == 0) return Offset.zero;

    final Offset unit = direction / length;
    final Offset normal = Offset(-unit.dy, unit.dx);
    final Offset middle = (start + end) / 2;
    final Offset toCentroid = transform.toCanvas(centroid) - middle;
    final double dot = normal.dx * toCentroid.dx + normal.dy * toCentroid.dy;
    return dot >= 0 ? normal : -normal;
  }

  /// Barrido del arco de la puerta, hacia el lado de dentro.
  double _sweepTowards(Offset unit, Offset inward) {
    final double cross = unit.dx * inward.dy - unit.dy * inward.dx;
    return cross >= 0 ? math.pi / 2 : -math.pi / 2;
  }

  @override
  bool shouldRepaint(_FloorPlanPainter oldDelegate) {
    return oldDelegate.room != room ||
        oldDelegate.plan != plan ||
        oldDelegate.selectedWallId != selectedWallId ||
        oldDelegate.wallColor != wallColor;
  }
}
