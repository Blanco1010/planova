/// Lectura de los precios que escribe el usuario.
///
/// Acepta `1.800`, `1800` y `1.800,50`: el punto separa los miles y la coma
/// los decimales, que es como se escribe un precio en pesos.
abstract final class MoneyInput {
  static double? parse(String? raw) {
    if (raw == null) return null;

    final String cleaned = raw
        .replaceAll(RegExp(r'[^\d,.]'), '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  /// Devuelve el aviso a mostrar, o `null` si el precio sirve.
  static String? validate(String? raw, {bool allowZero = false}) {
    final double? value = parse(raw);
    if (value == null || value.isNaN) return 'Escribe un precio';
    if (value < 0) return 'No puede ser negativo';
    if (!allowZero && value == 0) return 'Escribe un precio';
    return null;
  }
}
