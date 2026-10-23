import '../entities/device_aim.dart';

/// Lee la orientación del teléfono mientras se escanea.
///
/// Está detrás de un contrato para poder medir sin sensores en las pruebas.
abstract interface class OrientationTracker {
  /// Orientación en vivo. El giro empieza en cero al abrir el flujo.
  Stream<DeviceAim> watch();
}
