import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:planova/core/measuring/sighting_math.dart';

const double _g = 9.81;

void main() {
  group('pitchRadians', () {
    test('el teléfono de pie mira a la horizontal', () {
      expect(SightingMath.pitchRadians(0, _g, 0), closeTo(0, 1e-6));
    });

    test('el teléfono tumbado mira al suelo, 90 grados', () {
      expect(
        SightingMath.pitchRadians(0, 0, _g),
        closeTo(math.pi / 2, 1e-6),
      );
    });

    test('a media inclinación da 45 grados', () {
      final double half = _g / math.sqrt2;
      expect(
        SightingMath.pitchRadians(0, half, half),
        closeTo(math.pi / 4, 1e-6),
      );
    });

    test('una lectura sin gravedad no vale', () {
      expect(SightingMath.pitchRadians(0, 0, 0), isNull);
      expect(SightingMath.pitchRadians(20, 20, 20), isNull);
    });
  });

  group('distanceToFloorPoint', () {
    test('a 45 grados la distancia es la altura del teléfono', () {
      expect(
        SightingMath.distanceToFloorPoint(
          pitchRadians: math.pi / 4,
          eyeHeightMeters: 1.5,
        ),
        closeTo(1.5, 1e-9),
      );
    });

    test('mirando a los pies la distancia es cero', () {
      expect(
        SightingMath.distanceToFloorPoint(
          pitchRadians: math.pi / 2,
          eyeHeightMeters: 1.5,
        ),
        closeTo(0, 1e-9),
      );
    });

    test('una esquina a 2,50 m sale de su inclinación', () {
      expect(
        SightingMath.distanceToFloorPoint(
          pitchRadians: math.atan(1.5 / 2.5),
          eyeHeightMeters: 1.5,
        ),
        closeTo(2.5, 1e-9),
      );
    });

    test('con el teléfono casi horizontal no se da medida', () {
      expect(
        SightingMath.distanceToFloorPoint(
          pitchRadians: 5 * math.pi / 180,
          eyeHeightMeters: 1.5,
        ),
        isNull,
      );
    });

    test('tampoco se dan distancias de otro mundo', () {
      expect(
        SightingMath.distanceToFloorPoint(
          pitchRadians: 8.1 * math.pi / 180,
          eyeHeightMeters: 5,
        ),
        isNull,
      );
    });
  });

  group('turnRateToTheRight', () {
    test('con el teléfono de pie, girar a la derecha da velocidad positiva', () {
      expect(
        SightingMath.turnRateToTheRight(
          gx: 0,
          gy: -1,
          gz: 0,
          ax: 0,
          ay: _g,
          az: 0,
        ),
        closeTo(1, 1e-9),
      );
    });

    test('con el teléfono inclinado se proyecta sobre la vertical', () {
      expect(
        SightingMath.turnRateToTheRight(
          gx: 0,
          gy: 0,
          gz: -1,
          ax: 0,
          ay: 0,
          az: _g,
        ),
        closeTo(1, 1e-9),
      );
    });

    test('inclinar el teléfono sin girar no cuenta como giro', () {
      expect(
        SightingMath.turnRateToTheRight(
          gx: 1,
          gy: 0,
          gz: 0,
          ax: 0,
          ay: _g,
          az: 0,
        ),
        closeTo(0, 1e-9),
      );
    });
  });

  group('floorPoint', () {
    test('sin giro, la esquina queda de frente', () {
      final point = SightingMath.floorPoint(
        distanceMeters: 2,
        turnRadians: 0,
      );
      expect(point.x, closeTo(2, 1e-9));
      expect(point.y, closeTo(0, 1e-9));
    });

    test('un cuarto de vuelta a la derecha la pone a un lado', () {
      final point = SightingMath.floorPoint(
        distanceMeters: 2,
        turnRadians: math.pi / 2,
      );
      expect(point.x, closeTo(0, 1e-9));
      expect(point.y, closeTo(2, 1e-9));
    });
  });
}
