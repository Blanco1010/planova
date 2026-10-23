import 'dart:math' as math;

/// Un punto del plano, en metros.
///
/// Se usa el mismo sistema que el lienzo: la `x` crece a la derecha y la `y`
/// hacia abajo. Así un giro positivo es un giro a la derecha en el dibujo.
class Point2D {
  const Point2D(this.x, this.y);

  static const Point2D origin = Point2D(0, 0);

  final double x;
  final double y;

  double distanceTo(Point2D other) {
    final double dx = x - other.x;
    final double dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  Point2D operator +(Point2D other) => Point2D(x + other.x, y + other.y);

  Point2D operator -(Point2D other) => Point2D(x - other.x, y - other.y);

  Point2D operator *(double factor) => Point2D(x * factor, y * factor);

  @override
  bool operator ==(Object other) =>
      other is Point2D && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() =>
      'Point2D(${x.toStringAsFixed(3)}, ${y.toStringAsFixed(3)})';
}
