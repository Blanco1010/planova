import 'dart:typed_data';

import 'package:printing/printing.dart';

import '../../domain/services/budget_exporter.dart';

/// Abre la hoja de compartir del teléfono con el PDF ya hecho.
class PrintingBudgetExporter implements BudgetExporter {
  const PrintingBudgetExporter();

  @override
  Future<void> share({
    required Uint8List bytes,
    required String fileName,
  }) async {
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }
}
