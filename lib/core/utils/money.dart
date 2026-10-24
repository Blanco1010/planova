import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// La moneda en la que se escriben y se leen los precios.
///
/// El peso no lleva centavos y agrupa con punto; el dólar lleva dos y agrupa
/// con coma. De aquí salen tanto lo que se muestra como lo que se entiende
/// de lo que escribe el usuario, para que nunca se contradigan.
enum MoneyFormat {
  cop(symbol: r'$', decimals: 0, locale: 'es'),
  usd(symbol: r'US$', decimals: 2, locale: 'en');

  const MoneyFormat({
    required this.symbol,
    required this.decimals,
    required this.locale,
  });

  final String symbol;
  final int decimals;
  final String locale;

  /// Lee la moneda guardada; si falta o no se reconoce, pesos.
  static MoneyFormat fromStorage(String? value) {
    return MoneyFormat.values.firstWhere(
      (MoneyFormat money) => money.name == value,
      orElse: () => MoneyFormat.cop,
    );
  }

  static final Map<MoneyFormat, NumberFormat> _numbers =
      <MoneyFormat, NumberFormat>{};
  static final Map<MoneyFormat, NumberFormat> _groups =
      <MoneyFormat, NumberFormat>{};

  NumberFormat get _format => _numbers.putIfAbsent(
    this,
    () => NumberFormat(decimals == 0 ? '#,##0' : '#,##0.00', locale),
  );

  /// Solo la parte entera, para agrupar los miles mientras se escribe.
  NumberFormat get _group =>
      _groups.putIfAbsent(this, () => NumberFormat('#,##0', locale));

  String get groupSeparator => _format.symbols.GROUP_SEP;

  String get decimalSeparator => _format.symbols.DECIMAL_SEP;

  /// `$ 1.250.000` en pesos, `US$ 1,250.00` en dólares.
  String format(double value) => '$symbol ${_format.format(value)}';

  /// Lo mismo sin el símbolo, para los campos que ya lo llevan delante.
  String formatAmount(double value) => _format.format(value);

  /// Lee un precio escrito a mano, con separadores o sin ellos.
  double? parse(String? raw) {
    if (raw == null) return null;

    final String cleaned = raw
        .replaceAll(groupSeparator, '')
        .replaceAll(decimalSeparator, '.')
        .replaceAll(RegExp(r'[^\d.]'), '');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  /// Lo que se ve en el campo mientras se teclea: los miles ya separados.
  ///
  /// Se respeta lo que la persona lleva escrito —los ceros del final y la
  /// coma recién puesta incluidos—, así que no se pasa por un número.
  String formatWhileTyping(String raw) {
    final String digits = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return '';

    final bool hasDecimals = decimals > 0 && raw.contains(decimalSeparator);
    final int cut = hasDecimals
        ? raw.replaceAll(groupSeparator, '').indexOf(decimalSeparator)
        : digits.length;

    final String whole = digits.substring(0, cut.clamp(0, digits.length));
    final String rest = digits
        .substring(cut.clamp(0, digits.length))
        .substring(0, (digits.length - cut).clamp(0, decimals));

    // Una cifra absurdamente larga se deja como está antes que reventar.
    final int? amount = int.tryParse(whole);
    final String grouped = whole.isEmpty
        ? '0'
        : amount == null
        ? whole
        : _group.format(amount);
    return hasDecimals ? '$grouped$decimalSeparator$rest' : grouped;
  }
}

/// Separa los miles en un campo de precio mientras se escribe.
class MoneyInputFormatter extends TextInputFormatter {
  const MoneyInputFormatter(this.money);

  final MoneyFormat money;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue before,
    TextEditingValue after,
  ) {
    final String text = money.formatWhileTyping(after.text);
    // El cursor se va al final: son campos cortos y de una sola cifra.
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
