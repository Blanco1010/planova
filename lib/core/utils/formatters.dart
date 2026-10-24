import 'package:intl/intl.dart';

/// Formatos de texto compartidos por toda la app.
abstract final class Formatters {
  /// Un formato por patrón y por idioma: al cambiar de idioma cambian la
  /// coma decimal y los nombres de los meses, sin reiniciar la app.
  static final Map<String, NumberFormat> _numbers = <String, NumberFormat>{};
  static final Map<String, DateFormat> _dates = <String, DateFormat>{};

  static NumberFormat _number(String pattern) => _numbers.putIfAbsent(
    '$pattern|${Intl.defaultLocale}',
    () => NumberFormat(pattern, Intl.defaultLocale),
  );

  static DateFormat _date(String pattern) => _dates.putIfAbsent(
    '$pattern|${Intl.defaultLocale}',
    () => DateFormat(pattern, Intl.defaultLocale),
  );

  static DateFormat get _shortDate => _date('d MMM y');
  static NumberFormat get _twoDecimals => _number('0.00');
  static NumberFormat get _upToTwoDecimals => _number('0.##');
  static NumberFormat get _threeDecimals => _number('0.000');
  static NumberFormat get _whole => _number('#,##0');

  /// Fecha corta en español: `22 oct 2026`.
  static String shortDate(DateTime date) => _shortDate.format(date);

  /// Número con dos decimales y coma: `4,00`.
  static String decimal(double value) => _twoDecimals.format(value);

  /// Medida en metros: `4,00 m`.
  static String meters(double value) => '${_twoDecimals.format(value)} m';

  /// Superficie: `12,00 m²`.
  static String squareMeters(double value) =>
      '${_twoDecimals.format(value)} m²';

  /// Medida corta en centímetros, para desfases pequeños: `12 cm`, `1,5 cm`.
  ///
  /// Lleva decimales solo si hacen falta: una junta de pega de 1,5 cm no
  /// puede salir redondeada a 2 cm, que es otra cantidad de bloques.
  static String centimeters(double valueInMeters) =>
      '${_upToTwoDecimals.format(valueInMeters * 100)} cm';

  /// Cantidad de piezas: `1.250`.
  static String units(int value) => _whole.format(value);

  /// Cantidad que puede o no llevar decimales: `425`, `2,35`.
  static String quantity(double value) => value == value.roundToDouble()
      ? _whole.format(value)
      : _twoDecimals.format(value);

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
