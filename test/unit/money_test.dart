import 'package:flutter_test/flutter_test.dart';
import 'package:planova/core/utils/money.dart';

void main() {
  group('cómo se muestra', () {
    test('el peso va sin centavos y agrupa con punto', () {
      expect(MoneyFormat.cop.format(1250000), r'$ 1.250.000');
      expect(MoneyFormat.cop.format(1800.4), r'$ 1.800');
    });

    test('el dólar lleva dos decimales y agrupa con coma', () {
      expect(MoneyFormat.usd.format(1250.5), r'US$ 1,250.50');
      expect(MoneyFormat.usd.format(12), r'US$ 12.00');
    });
  });

  group('lo que se escribe', () {
    test('se agrupan los miles al teclear', () {
      expect(MoneyFormat.cop.formatWhileTyping('70000'), '70.000');
      expect(MoneyFormat.cop.formatWhileTyping('1250000'), '1.250.000');
      // Volver a pasarlo no lo rompe: el campo se reescribe en cada tecla.
      expect(MoneyFormat.cop.formatWhileTyping('70.000'), '70.000');
      expect(MoneyFormat.cop.formatWhileTyping(''), '');
    });

    test('el peso no admite centavos y el dólar sí', () {
      // En pesos la coma no separa nada: no hay centavos que escribir.
      expect(MoneyFormat.cop.formatWhileTyping('1500,75'), '150.075');
      expect(MoneyFormat.usd.formatWhileTyping('1234.5'), '1,234.5');
      expect(MoneyFormat.usd.formatWhileTyping('1,234.56'), '1,234.56');
      // Un tercer decimal ya no entra.
      expect(MoneyFormat.usd.formatWhileTyping('1234.567'), '1,234.56');
      // Y si se empieza por la coma, el cero aparece solo.
      expect(MoneyFormat.usd.formatWhileTyping('.5'), '0.5');
    });

    test('una cifra absurda no revienta', () {
      final String long = '9' * 40;
      expect(MoneyFormat.cop.formatWhileTyping(long), long);
    });
  });

  group('lo que se lee', () {
    test('se entiende con separadores y sin ellos', () {
      expect(MoneyFormat.cop.parse('1.800'), 1800);
      expect(MoneyFormat.cop.parse('1800'), 1800);
      expect(MoneyFormat.cop.parse(r'$ 1.250.000'), 1250000);
      expect(MoneyFormat.usd.parse('1,250.50'), 1250.5);
      expect(MoneyFormat.usd.parse(r'US$ 12.00'), 12);
    });

    test('lo que no es un precio da nulo', () {
      expect(MoneyFormat.cop.parse(''), isNull);
      expect(MoneyFormat.cop.parse(null), isNull);
      expect(MoneyFormat.cop.parse('abc'), isNull);
    });
  });

  test('la moneda guardada se recupera, y si falta son pesos', () {
    expect(MoneyFormat.fromStorage('usd'), MoneyFormat.usd);
    expect(MoneyFormat.fromStorage('cop'), MoneyFormat.cop);
    expect(MoneyFormat.fromStorage(null), MoneyFormat.cop);
    expect(MoneyFormat.fromStorage('yenes'), MoneyFormat.cop);
  });
}
