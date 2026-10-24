import 'package:flutter/material.dart';

/// La imagen de la cámara llenando la pantalla, con el dibujo encima.
///
/// La imagen no se estira: si se deformara, el plano dejaría de caer donde
/// debe. Se agranda hasta cubrir la pantalla y lo que sobra por los lados se
/// recorta, así no quedan bandas negras y el dibujo sigue usando el ángulo
/// de la cámara, que es lo que coloca cada esquina.
class CameraStage extends StatelessWidget {
  const CameraStage({
    required this.aspectRatio,
    required this.builder,
    super.key,
  });

  /// Proporción de la imagen que entrega la cámara.
  final double aspectRatio;

  /// Lo que se pinta dentro del encuadre. Recibe el encuadre entero y el
  /// trozo que de verdad se ve, para no escribir fuera de la pantalla.
  final Widget Function(Size frame, Rect visible) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size screen = constraints.biggest;
        final bool widerThanScreen =
            aspectRatio > screen.width / screen.height;
        final Size frame = widerThanScreen
            ? Size(screen.height * aspectRatio, screen.height)
            : Size(screen.width, screen.width / aspectRatio);
        // El recorte es igual por los dos lados, así que el centro del
        // encuadre sigue siendo el centro de la pantalla: ahí va la mira.
        final Rect visible = Rect.fromLTWH(
          (frame.width - screen.width) / 2,
          (frame.height - screen.height) / 2,
          screen.width,
          screen.height,
        );

        return ClipRect(
          child: OverflowBox(
            maxWidth: frame.width,
            maxHeight: frame.height,
            child: SizedBox.fromSize(
              size: frame,
              child: builder(frame, visible),
            ),
          ),
        );
      },
    );
  }
}
