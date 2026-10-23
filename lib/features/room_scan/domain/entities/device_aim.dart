/// Hacia dónde apunta el teléfono en este instante.
class DeviceAim {
  const DeviceAim({required this.pitchRadians, required this.turnRadians});

  /// Inclinación de la cámara por debajo de la horizontal.
  final double pitchRadians;

  /// Giro acumulado hacia la derecha desde que empezó la medición.
  final double turnRadians;
}
