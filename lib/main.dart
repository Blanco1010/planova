import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app/app.dart';

void main() {
  // Nombres de meses y días en español para los formatos de fecha.
  initializeDateFormatting();
  Intl.defaultLocale = 'es';

  runApp(const ProviderScope(child: PlanovaApp()));
}
