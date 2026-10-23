import 'package:intl/intl.dart';

/// Formatos de texto compartidos por toda la app.
abstract final class Formatters {
  static final DateFormat _shortDate = DateFormat('d MMM y', 'es');
  static final NumberFormat _twoDecimals = NumberFormat('0.00', 'es');
  static final NumberFormat _upToTwoDecimals = NumberFormat('0.##', 'es');
  static final NumberFormat _threeDecimals = NumberFormat('0.000', 'es');
  static final NumberFormat _whole = NumberFormat('#,##0', 'es');

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

  /// Cantidad de piezas: `1.250`.
  static String units(int value) => _whole.format(value);

  /// Cantidad que puede o no llevar decimales: `425`, `2,35`.
  static String quantity(double value) => value == value.roundToDouble()
      ? _whole.format(value)
      : _twoDecimals.format(value);

  /// Dinero en pesos, sin centavos: `$ 1.250.000`.
  static String money(double value) => r'$ ' + _whole.format(value.round());

  /// Volumen: `0,135 m³`.
  static String cubicMeters(double value) =>
      '${_threeDecimals.format(value)} m³';

  /// Pintura: `7,06 L`.
  static String liters(double value) => '${_twoDecimals.format(value)} L';

  /// Peso: `66,00 kg`.
  static String kilograms(double value) => '${_twoDecimals.format(value)} kg';

  /// Ángulo: `90°`, `-45,5°`.
  static String degrees(double value) => '${_upToTwoDecimals.format(value)}°';
}
