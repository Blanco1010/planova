import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:planova/core/geometry/point2d.dart';
import 'package:planova/features/room_scan/domain/entities/scan_session.dart';

/// Cómo se ve el punto [target] desde [from]: lo que medirían los sensores.
({double distance, double turn}) _sightOf(Point2D from, Point2D target) {
  final double dx = target.x - from.x;
  final double dy = target.y - from.y;
  return (distance: math.sqrt(dx * dx + dy * dy), turn: math.atan2(dy, dx));
}

void main() {
  test('la esquina se guarda en coordenadas, no respecto a quien mide', () {
    const ScanSession session = ScanSession(
      observer: Point2D(2, 1),
      corners: <Point2D>[],
    );

    final ScanSession marked = session.mark(distanceMeters: 2, turnRadians: 0);

    expect(marked.corners.single.x, closeTo(4, 1e-9));
    expect(marked.corners.single.y, closeTo(1, 1e-9));
  });

  test('al reubicarse, las esquinas se quedan donde están', () {
    const Point2D a = Point2D(0.5, 1.5);
    const Point2D c1 = Point2D(0, 0);
    const Point2D c2 = Point2D(4, 0);

    ScanSession session = const ScanSession(observer: a, corners: <Point2D>[]);
    for (final Point2D corner in <Point2D>[c1, c2]) {
      final sight = _sightOf(a, corner);
      session = session.mark(
        distanceMeters: sight.distance,
        turnRadians: sight.turn,
      );
    }

    // Se camina al otro lado y se apunta a la esquina 2, ya marcada.
    const Point2D b = Point2D(3.5, 1.5);
    final sight = _sightOf(b, c2);
    final ScanSession moved = session.relocateFrom(
      1,
      distanceMeters: sight.distance,
      turnRadians: sight.turn,
    );

    expect(moved.observer.x, closeTo(b.x, 1e-9));
    expect(moved.observer.y, closeTo(b.y, 1e-9));
    expect(moved.corners.first.distanceTo(c1), closeTo(0, 1e-9));
    expect(moved.corners.last.distanceTo(c2), closeTo(0, 1e-9));
  });

  test('desde la posición nueva, la esquina siguiente cae en su sitio', () {
    const Point2D b = Point2D(3.5, 1.5);
    const Point2D c3 = Point2D(4, 3);

    const ScanSession session = ScanSession(
      observer: b,
      corners: <Point2D>[Point2D(0, 0), Point2D(4, 0)],
    );
    final sight = _sightOf(b, c3);
    final ScanSession marked = session.mark(
      distanceMeters: sight.distance,
      turnRadians: sight.turn,
    );

    expect(marked.corners.last.distanceTo(c3), closeTo(0, 1e-9));
  });

  test('viewOf dice a qué distancia y giro queda una esquina', () {
    const ScanSession session = ScanSession(
      observer: Point2D(1, 1),
      corners: <Point2D>[],
    );

    final view = session.viewOf(const Point2D(4, 1));

    expect(view.distance, closeTo(3, 1e-9));
    expect(view.turn, closeTo(0, 1e-9));
  });

  test('reubicarse en una esquina que no existe no cambia nada', () {
    const ScanSession session = ScanSession(
      observer: Point2D(1, 1),
      corners: <Point2D>[Point2D(0, 0)],
    );

    final ScanSession same = session.relocateFrom(
      5,
      distanceMeters: 2,
      turnRadians: 0,
    );

    expect(same.observer, const Point2D(1, 1));
  });

  test('quitar la última deja las demás intactas', () {
    const ScanSession session = ScanSession(
      observer: Point2D.origin,
      corners: <Point2D>[Point2D(0, 0), Point2D(4, 0)],
    );

    expect(session.withoutLast().corners, <Point2D>[const Point2D(0, 0)]);
    expect(ScanSession.empty.withoutLast().corners, isEmpty);
  });
}
