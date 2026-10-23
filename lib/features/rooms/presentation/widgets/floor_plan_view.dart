import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/geometry/plan_geometry.dart';
import '../../../../core/geometry/point2d.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/opening.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_plan.dart';
import '../../domain/entities/room_wall.dart';

/// Colores con los que se dibuja el plano.
///
/// Está aparte porque el mismo dibujo se pinta en pantalla, donde los colores
/// salen del tema, y en el PDF, donde el fondo siempre es papel blanco.
class FloorPlanPalette {
  const FloorPlanPalette({
    required this.wall,
    required this.selected,
    required this.fill,
    required this.guide,
    required this.label,
    required this.gap,
  });

  /// La del tema actual de la app.
  factory FloorPlanPalette.of(ThemeData theme) {
    return FloorPlanPalette(
      wall: theme.brightness == Brightness.light
          ? AppColors.deepBlue
          : AppColors.onDark,
      selected: AppColors.primaryBlue,
      fill: AppColors.primaryBlue.withValues(alpha: 0.08),
      guide: AppColors.lightBlue,
      label: theme.colorScheme.onSurface,
      gap: theme.colorScheme.surface,
    );
  }

  /// La del papel: tinta oscura sobre blanco.
  factory FloorPlanPalette.onPaper() {
    return FloorPlanPalette(
      wall: AppColors.deepBlue,
      selected: AppColors.primaryBlue,
      fill: AppColors.primaryBlue.withValues(alpha: 0.08),
      guide: AppColors.lightBlue,
      label: AppColors.darkNavy,
      gap: Colors.white,
    );
  }

  final Color wall;
  final Color selected;
  final Color fill;
  final Color guide;
  final Color label;

  /// El color del fondo: con él se abre el hueco de los vanos en la pared.
  final Color gap;

  @override
  bool operator ==(Object other) =>
      other is FloorPlanPalette &&
      other.wall == wall &&
      other.selected == selected &&
      other.fill == fill &&
      other.guide == guide &&
      other.label == label &&
      other.gap == gap;

  @override
  int get hashCode => Object.hash(wall, selected, fill, guide, label, gap);
}

/// Pinta el plano en una imagen PNG, con fondo blanco, para el PDF.
///
/// Usa el mismo pintor que la pantalla: lo que se envía al cliente es el
/// mismo dibujo que se ve en la app, no una segunda versión que se desfase.
Future<Uint8List?> renderFloorPlanPng({
  required Room room,
  required RoomPlan plan,
  Size size = const Size(420, 300),
  double pixelRatio = 3,
}) async {
  if (plan.vertices.length < 2) return null;

  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  canvas.scale(pixelRatio);
  canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);

  _FloorPlanPainter(
    room: room,
    plan: plan,
    transform: _PlanTransform.fit(
      size: size,
      bounds: PlanGeometry.boundsOf(plan.vertices),
      padding: _dimensionPadding,
    ),
    selectedWallId: null,
    showDimensions: true,
    palette: FloorPlanPalette.onPaper(),
    labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
  ).paint(canvas, size);

  final ui.Image image = await recorder.endRecording().toImage(
    (size.width * pixelRatio).round(),
    (size.height * pixelRatio).round(),
  );
  final ByteData? data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data?.buffer.asUint8List();
}

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
    this.showDimensions = true,
    super.key,
  });

  final Room room;
  final RoomPlan plan;
  final int? selectedWallId;
  final ValueChanged<RoomWall>? onWallTap;

  /// Las cotas sobran cuando el plano se enseña en pequeño.
  final bool showDimensions;

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
          // Las cotas se dibujan por fuera de las paredes: necesitan sitio.
          padding: showDimensions ? _dimensionPadding : 16,
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
              showDimensions: showDimensions,
              palette: FloorPlanPalette.of(theme),
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

/// Sitio que hay que dejar alrededor del plano para que quepan las cotas.
const double _dimensionPadding = 58;

/// Lleva metros del plano a píxeles del lienzo, y al revés.
class _PlanTransform {
  const _PlanTransform._(this._scale, this._offset, this._bounds);

  factory _PlanTransform.fit({
    required Size size,
    required PlanBounds bounds,
    double padding = _dimensionPadding,
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
    required this.showDimensions,
    required this.palette,
    required this.labelStyle,
  });

  final Room room;
  final RoomPlan plan;
  final _PlanTransform transform;
  final int? selectedWallId;
  final bool showDimensions;
  final FloorPlanPalette palette;
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
      if (showDimensions) {
        _paintDimension(canvas, wall, startPoint, endPoint, centroid, selected);
      }
    }

    _paintVertices(canvas, points);
  }

  void _paintFloor(Canvas canvas, List<Offset> points) {
    final Path path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final Offset point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = palette.fill);
  }

  void _paintWall(Canvas canvas, Offset start, Offset end, bool selected) {
    canvas.drawLine(
      start,
      end,
      Paint()
        ..color = selected ? palette.selected : palette.wall
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
          ..color = palette.gap
          ..strokeWidth = 8,
      );

      final Paint markPaint = Paint()
        ..color = opening.kind == OpeningKind.door
            ? palette.wall
            : palette.guide
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
        ..color = palette.guide
        ..strokeWidth = selected ? 2 : 1,
    );

    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: Formatters.meters(wall.lengthMeters),
        style: labelStyle.copyWith(
          color: selected ? palette.selected : palette.label,
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
    final Paint paint = Paint()..color = palette.wall;
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
        oldDelegate.showDimensions != showDimensions ||
        oldDelegate.selectedWallId != selectedWallId ||
        oldDelegate.palette != palette;
  }
}
