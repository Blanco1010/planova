import 'dart:typed_data';

/// Saca el presupuesto de la app: compartir, enviar o imprimir.
///
/// Está detrás de un contrato porque es lo único del PDF que necesita el
/// aparato; así la pantalla se puede probar sin él.
abstract interface class BudgetExporter {
  Future<void> share({required Uint8List bytes, required String fileName});
}
