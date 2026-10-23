/// Qué superficie se va a medir.
///
/// ARCore busca mejor si se le dice qué mirar: el suelo para levantar el
/// plano, o las paredes para medir una pared suelta.
enum ScanSurface { floor, wall }

/// Cómo se nombra cada una.
extension ScanSurfaceDisplay on ScanSurface {
  String get label => switch (this) {
    ScanSurface.floor => 'El piso',
    ScanSurface.wall => 'Una pared',
  };
}
