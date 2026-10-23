import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:planova/core/geometry/point2d.dart';
import 'package:planova/core/measuring/view_projection.dart';

/// Una pantalla de 400 × 800 apuntando de frente y 30° hacia abajo.
ViewProjection _projection({double turn = 0, double? pitch}) {
  return ViewProjection(
    widthPx: 400,
    heightPx: 800,
    aimTurnRadians: turn,
    aimPitchRadians: pitch ?? math.atan(1.5 / 2.5),
    phoneHeightMeters: 1.5,
  );
}

void main() {
  test('el punto al que se apunta cae justo en el centro', () {
    final ViewProjection projection = _projection();

    final Point2D? point = projection.project(
      distanceMeters: 2.5,
      turnRadians: 0,
    );

    expect(point, isNotNull);
    expect(point!.x, closeTo(200, 0.001));
    expect(point.y, closeTo(400, 0.001));
  });

  test('una esquina a la derecha se dibuja a la derecha', () {
    final Point2D? point = _projection().project(
      distanceMeters: 2.5,
      turnRadians: 10 * math.pi / 180,
    );

    expect(point!.x, greaterThan(200));
    // 10° de los 31° que abarca media pantalla: menos de un tercio.
    expect(point.x, lessThan(280));
  });

  test('lo que queda más lejos se ve más arriba', () {
    final ViewProjection projection = _projection();

    final Point2D cerca = projection.project(
      distanceMeters: 2,
      turnRadians: 0,
    )!;
    final Point2D lejos = projection.project(
      distanceMeters: 6,
      turnRadians: 0,
    )!;

    expect(lejos.y, lessThan(cerca.y));
    expect(cerca.y, greaterThan(400));
  });

  test('lo que queda a la espalda no se dibuja', () {
    expect(
      _projection().project(distanceMeters: 3, turnRadians: math.pi),
      isNull,
    );
  });

  test('girar la cámara mueve el dibujo al otro lado', () {
    final Point2D derecha = _projection().project(
      distanceMeters: 3,
      turnRadians: 0.2,
    )!;
    final Point2D izquierda = _projection(turn: 0.4).project(
      distanceMeters: 3,
      turnRadians: 0.2,
    )!;

    expect(derecha.x, greaterThan(200));
    expect(izquierda.x, lessThan(200));
  });

  test('normalizeRadians deja el ángulo entre -π y π', () {
    expect(
      ViewProjection.normalizeRadians(3 * math.pi / 2),
      closeTo(-math.pi / 2, 1e-9),
    );
    expect(
      ViewProjection.normalizeRadians(-3 * math.pi / 2),
      closeTo(math.pi / 2, 1e-9),
    );
  });
}
