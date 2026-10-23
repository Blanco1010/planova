import 'package:intl/intl.dart';

/// Formatos de texto compartidos por toda la app.
abstract final class Formatters {
  static final DateFormat _shortDate = DateFormat('d MMM y', 'es');
  static final NumberFormat _twoDecimals = NumberFormat('0.00', 'es');
  static final NumberFormat _upToTwoDecimals = NumberFormat('0.##', 'es');

  /// Fecha corta en español: `22 oct 2026`.
  static String shortDate(DateTime date) => _shortDate.format(date);

  /// Número con dos decimales y coma: `4,00`.
  static String decimal(double value) => _twoDecimals.format(value);

  /// Medida en metros: `4,00 m`.
  static String meters(double value) => '${_twoDecimals.format(value)} m';

  /// Superficie: `12,00 m²`.
  static String squareMeters(double value) =>
      '${_twoDecimals.format(value)} m²';

  /// Medida corta en centímetros, para desfases pequeños: `12 cm`.
  static String centimeters(double valueInMeters) =>
      '${(valueInMeters * 100).round()} cm';

  /// Ángulo: `90°`, `-45,5°`.
  static String degrees(double value) => '${_upToTwoDecimals.format(value)}°';
}
