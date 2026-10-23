import 'package:intl/intl.dart';

/// Formatos de texto compartidos por toda la app.
abstract final class Formatters {
  static final DateFormat _shortDate = DateFormat('d MMM y', 'es');

  /// Fecha corta en español: `22 oct 2026`.
  static String shortDate(DateTime date) => _shortDate.format(date);
}
