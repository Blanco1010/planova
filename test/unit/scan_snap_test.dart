import 'package:flutter_test/flutter_test.dart';
import 'package:planova/core/geometry/point2d.dart';
import 'package:planova/features/room_scan/domain/services/scan_snap.dart';

/// Las cuatro esquinas de una habitación de 4 × 3.
const List<Point2D> _corners = <Point2D>[
  Point2D(0, 0),
  Point2D(4, 0),
  Point2D(4, 3),
  Point2D(0, 3),
];

void main() {
  group('cornerNear', () {
    test('engancha a la esquina que tiene debajo', () {
      expect(ScanSnap.cornerNear(_corners, const Point2D(4.2, 0.1)), 1);
    });

    test('si no hay ninguna cerca no engancha', () {
      expect(ScanSnap.cornerNear(_corners, const Point2D(2, 1.5)), isNull);
    });

    test('entre dos cercanas se queda con la más cerca', () {
      expect(
        ScanSnap.cornerNear(
          const <Point2D>[Point2D(0, 0), Point2D(0.5, 0)],
          const Point2D(0.45, 0),
          toleranceMeters: 1,
        ),
        1,
      );
    });
  });

  group('closesRoom', () {
    test('apuntar a la primera esquina cierra la habitación', () {
      expect(ScanSnap.closesRoom(_corners, const Point2D(0.2, 0.2)), isTrue);
    });

    test('apuntar a otra esquina no cierra', () {
      expect(ScanSnap.closesRoom(_corners, const Point2D(4, 3.1)), isFalse);
    });

    test('con menos de tres esquinas todavía no hay nada que cerrar', () {
      expect(
        ScanSnap.closesRoom(const <Point2D>[
          Point2D(0, 0),
          Point2D(4, 0),
        ], const Point2D(0, 0)),
        isFalse,
      );
    });
  });
}
