import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planova/features/room_scan/presentation/widgets/scan_overlay.dart';

void main() {
  const Size viewport = Size(400, 800);
  const Size label = Size(80, 36);

  test('en medio de la pantalla la medida se queda donde cae', () {
    expect(
      labelCenterInside(const Offset(200, 400), label, viewport),
      const Offset(200, 400),
    );
  });

  test('pegada a un borde, la medida entra entera', () {
    // Centrada en el borde derecho se salía media caja.
    expect(
      labelCenterInside(const Offset(395, 400), label, viewport).dx,
      400 - 8 - 40,
    );
    expect(
      labelCenterInside(const Offset(2, 400), label, viewport).dx,
      8 + 40,
    );
    expect(
      labelCenterInside(const Offset(200, -10), label, viewport).dy,
      8 + 18,
    );
    expect(
      labelCenterInside(const Offset(200, 900), label, viewport).dy,
      800 - 8 - 18,
    );
  });

  test('si no cabe de ninguna manera, se centra', () {
    expect(
      labelCenterInside(const Offset(0, 0), const Size(500, 36), viewport).dx,
      200,
    );
  });
}
