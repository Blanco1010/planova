import 'package:flutter/material.dart';

import '../../domain/entities/opening.dart';

/// Cómo se enseña cada tipo de vano.
extension OpeningKindDisplay on OpeningKind {
  String get label => switch (this) {
    OpeningKind.door => 'Puerta',
    OpeningKind.window => 'Ventana',
  };

  IconData get icon => switch (this) {
    OpeningKind.door => Icons.door_front_door_outlined,
    OpeningKind.window => Icons.window_outlined,
  };
}
