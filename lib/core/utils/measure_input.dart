/// Lectura y comprobación de las medidas que escribe el usuario.
///
/// Acepta coma o punto decimal: en el teclado del teléfono sale la coma.
abstract final class MeasureInput {
  static double? parse(String? raw) {
    if (raw == null) return null;
    final String cleaned = raw.trim().replaceAll(',', '.');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  /// Devuelve el aviso a mostrar, o `null` si la medida sirve.
  static String? validate(
    String? raw, {
    double min = 0.01,
    double? max,
    String? maxMessage,
  }) {
    final double? value = parse(raw);
    if (value == null || value.isNaN) return 'Escribe una medida';
    if (value < min) {
      return min <= 0.01
          ? 'Debe ser mayor que cero'
          : 'Debe ser al menos ${_short(min)} m';
    }
    if (max != null && value > max) {
      return maxMessage ?? 'No puede pasar de ${_short(max)} m';
    }
    return null;
  }

  static String _short(double value) =>
      value == value.roundToDouble() ? value.toStringAsFixed(0) : '$value';
}
