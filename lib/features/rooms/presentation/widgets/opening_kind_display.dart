import 'package:flutter/material.dart';

import '../../../../l10n/app_l10n.dart';

import '../../domain/entities/opening.dart';

/// Cómo se enseña cada tipo de vano.
extension OpeningKindDisplay on OpeningKind {
  String label(AppL10n t) => switch (this) {
    OpeningKind.door => t.door,
    OpeningKind.window => t.window,
  };

  IconData get icon => switch (this) {
    OpeningKind.door => Icons.door_front_door_outlined,
    OpeningKind.window => Icons.window_outlined,
  };
}
