import 'package:flutter_test/flutter_test.dart';
import 'package:planova/core/geometry/plan_geometry.dart';
import 'package:planova/core/geometry/point2d.dart';

void main() {
  group('traceChain', () {
    test('un rectángulo de 4 × 3 cierra en el punto de partida', () {
      final List<Point2D> traced = PlanGeometry.traceChain(const <WallStep>[
        WallStep(lengthMeters: 4, turnDegrees: 0),
        WallStep(lengthMeters: 3, turnDegrees: 90),
        WallStep(lengthMeters: 4, turnDegrees: 90),
        WallStep(lengthMeters: 3, turnDegrees: 90),
      ]);

      expect(traced.length, 5);
      expect(traced.last.distanceTo(traced.first), closeTo(0, 1e-9));
      expect(PlanGeometry.polygonArea(traced.sublist(0, 4)), closeTo(12, 1e-9));
    });

    test('una habitación en L da el área de sus dos rectángulos', () {
      final List<Point2D> traced = PlanGeometry.traceChain(const <WallStep>[
        WallStep(lengthMeters: 4, turnDegrees: 0),
        WallStep(lengthMeters: 2, turnDegrees: 90),
        WallStep(lengthMeters: 2, turnDegrees: 90),
        WallStep(lengthMeters: 1, turnDegrees: -90),
        WallStep(lengthMeters: 2, turnDegrees: 90),
        WallStep(lengthMeters: 3, turnDegrees: 90),
      ]);

      expect(traced.last.distanceTo(traced.first), closeTo(0, 1e-9));
      // 4 × 2 más 2 × 1.
      expect(PlanGeometry.polygonArea(traced.sublist(0, 6)), closeTo(10, 1e-9));
    });

    test('si los largos no concuerdan, el recorrido queda abierto', () {
      final List<Point2D> traced = PlanGeometry.traceChain(const <WallStep>[
        WallStep(lengthMeters: 4, turnDegrees: 0),
        WallStep(lengthMeters: 3, turnDegrees: 90),
        WallStep(lengthMeters: 4, turnDegrees: 90),
        WallStep(lengthMeters: 2.5, turnDegrees: 90),
      ]);

      expect(traced.last.distanceTo(traced.first), closeTo(0.5, 1e-9));
    });
  });

  group('chainFromVertices', () {
    test('de los vértices de un rectángulo salen sus cuatro paredes', () {
      final List<WallStep> steps = PlanGeometry.chainFromVertices(
        const <Point2D>[
          Point2D(0, 0),
          Point2D(4, 0),
          Point2D(4, 3),
          Point2D(0, 3),
        ],
      );

      expect(steps.length, 4);
      expect(steps.map((WallStep step) => step.lengthMeters), [
        closeTo(4, 1e-9),
        closeTo(3, 1e-9),
        closeTo(4, 1e-9),
        closeTo(3, 1e-9),
      ]);
      // La primera no gira; las demás doblan a la derecha.
      expect(steps.map((WallStep step) => step.turnDegrees), [
        closeTo(0, 1e-9),
        closeTo(90, 1e-9),
        closeTo(90, 1e-9),
        closeTo(90, 1e-9),
      ]);
    });

    test('ida y vuelta: trazar la cadena devuelve los mismos vértices', () {
      const List<Point2D> original = <Point2D>[
        Point2D(0, 0),
        Point2D(4, 0),
        Point2D(4, 2),
        Point2D(2, 2),
        Point2D(2, 3),
        Point2D(0, 3),
      ];

      final List<Point2D> traced = PlanGeometry.traceChain(
        PlanGeometry.chainFromVertices(original),
      );

      for (int i = 0; i < original.length; i++) {
        expect(traced[i].distanceTo(original[i]), closeTo(0, 1e-9));
      }
      expect(traced.last.distanceTo(original.first), closeTo(0, 1e-9));
    });

    test('con menos de dos vértices no hay paredes', () {
      expect(
        PlanGeometry.chainFromVertices(const <Point2D>[Point2D(0, 0)]),
        isEmpty,
      );
    });
  });

  group('normalizeDegrees', () {
    test('deja los ángulos entre -180 y 180', () {
      expect(PlanGeometry.normalizeDegrees(270), closeTo(-90, 1e-9));
      expect(PlanGeometry.normalizeDegrees(-270), closeTo(90, 1e-9));
      expect(PlanGeometry.normalizeDegrees(45), closeTo(45, 1e-9));
    });
  });

  group('polygonArea', () {
    test('con menos de tres vértices no hay área', () {
      expect(
        PlanGeometry.polygonArea(const <Point2D>[Point2D(0, 0), Point2D(2, 0)]),
        0,
      );
    });
  });

  group('distanceToSegment', () {
    test('mide la perpendicular cuando el punto cae frente al segmento', () {
      expect(
        PlanGeometry.distanceToSegment(
          const Point2D(2, 1),
          const Point2D(0, 0),
          const Point2D(4, 0),
        ),
        closeTo(1, 1e-9),
      );
    });

    test('mide hasta el extremo cuando el punto se pasa del segmento', () {
      expect(
        PlanGeometry.distanceToSegment(
          const Point2D(6, 0),
          const Point2D(0, 0),
          const Point2D(4, 0),
        ),
        closeTo(2, 1e-9),
      );
    });
  });

  group('boundsOf', () {
    test('envuelve todos los vértices', () {
      final PlanBounds bounds = PlanGeometry.boundsOf(const <Point2D>[
        Point2D(0, 0),
        Point2D(4, 0),
        Point2D(4, 3),
        Point2D(0, 3),
      ]);

      expect(bounds.width, 4);
      expect(bounds.height, 3);
    });
  });
}
