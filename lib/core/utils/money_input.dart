import 'money.dart';

/// Lectura de los precios que escribe el usuario.
///
/// Los separadores son los de la moneda elegida: en pesos `1.800` y en
/// dólares `1,800.50`.
abstract final class MoneyInput {
  static double? parse(String? raw, MoneyFormat money) => money.parse(raw);

  /// Devuelve el aviso a mostrar, o `null` si el precio sirve.
  static String? validate(
    String? raw,
    MoneyFormat money, {
    bool allowZero = false,
  }) {
    final double? value = parse(raw, money);
    if (value == null || value.isNaN) return 'Escribe un precio';
    if (value < 0) return 'No puede ser negativo';
    if (!allowZero && value == 0) return 'Escribe un precio';
    return null;
  }
}
