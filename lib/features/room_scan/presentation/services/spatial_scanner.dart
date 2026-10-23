import 'package:flutter/widgets.dart';

import '../../domain/entities/spatial_frame.dart';

/// La cámara con seguimiento espacial.
///
/// Es una vista (la pinta el sistema, no Flutter) que va avisando de lo que
/// tiene bajo la mira. Está detrás de un contrato porque ARCore no existe en
/// las pruebas ni en los emuladores.
abstract interface class SpatialScanner {
  /// La vista de cámara. Llama a [onFrame] con cada fotograma.
  Widget view({required ValueChanged<SpatialFrame?> onFrame});
}
