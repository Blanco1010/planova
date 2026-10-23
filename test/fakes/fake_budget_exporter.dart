import 'dart:typed_data';

import 'package:planova/features/budget/domain/services/budget_exporter.dart';

/// Se queda con lo que se le entrega, en vez de abrir la hoja de compartir.
class FakeBudgetExporter implements BudgetExporter {
  Uint8List? lastBytes;
  String? lastFileName;

  @override
  Future<void> share({
    required Uint8List bytes,
    required String fileName,
  }) async {
    lastBytes = bytes;
    lastFileName = fileName;
  }
}
