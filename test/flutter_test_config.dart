import 'dart:async';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Las pruebas miran la app en español, que es el idioma en el que está
/// escrita; el inglés tiene las suyas aparte.
///
/// Sin esto los números saldrían con el formato del ordenador que corra las
/// pruebas, y `4,20 m` pasaría a ser `4.20 m` según dónde se ejecuten.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  initializeDateFormatting();
  Intl.defaultLocale = 'es';
  await testMain();
}
