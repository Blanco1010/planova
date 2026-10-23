import 'dart:math' as math;

/// Cuánto abarca la cámara, en radianes.
///
/// Sale del sensor del aparato, así que no hay que estimarlo. Como el
/// teléfono se sostiene de pie, el lado largo de la imagen queda vertical:
/// por eso se guarda cuál es el ángulo ancho y cuál el estrecho, y se elige
/// según cómo quede el encuadre.
class CameraFieldOfView {
  const CameraFieldOfView({required this.wider, required this.narrower});

  /// Lo que se usa mientras no se sepa el del aparato: unos 62° por 48°.
  static const CameraFieldOfView estimated = CameraFieldOfView(
    wider: 62 * math.pi / 180,
    narrower: 48 * math.pi / 180,
  );

  final double wider;
  final double narrower;

  /// El ángulo que abarca el encuadre a lo ancho de la pantalla.
  double horizontalFor(double widthOverHeight) =>
      widthOverHeight >= 1 ? wider : narrower;
}
