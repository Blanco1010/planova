import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';

void main() {
  // Nombres de meses y días de todos los idiomas; cuál se usa lo decide
  // el ajuste de idioma, en PlanovaApp.
  initializeDateFormatting();

  runApp(const ProviderScope(child: PlanovaApp()));
}
