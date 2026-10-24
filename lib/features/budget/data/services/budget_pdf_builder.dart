import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/utils/formatters.dart';
import '../../../projects/domain/entities/project.dart';
import '../../../rooms/domain/entities/room.dart';
import '../../../rooms/domain/entities/room_plan.dart';
import '../../domain/entities/budget_item.dart';
import '../../domain/entities/budget_summary.dart';
import '../../domain/services/finish_calculator.dart';
import '../../domain/entities/material_kind.dart';

/// Arma el PDF del presupuesto para enviárselo al cliente.
///
/// No sabe nada de compartir ni de imprimir: solo devuelve los bytes, así se
/// puede comprobar sin aparato de por medio.
abstract final class BudgetPdfBuilder {
  static const PdfColor _deepBlue = PdfColor.fromInt(0xFF1E3A8A);
  static const PdfColor _softGrey = PdfColor.fromInt(0xFFF1F5F9);
  static const PdfColor _muted = PdfColor.fromInt(0xFF64748B);
  static const PdfColor _white = PdfColor.fromInt(0xFFFFFFFF);

  static Future<Uint8List> build({
    required Project project,
    required String scopeLabel,
    required List<Room> rooms,

    /// Dibujo del plano de cada habitación, por `id`. Las que no estén salen
    /// solo con sus medidas.
    required Map<int, Uint8List> roomPlans,
    required List<MaterialLine> materialLines,
    required List<BudgetItem> items,
    required List<FinishEstimate> finishes,
    required BudgetSummary summary,
    required DateTime generatedAt,

    /// Sin comprimir, el texto del documento se puede leer en las pruebas.
    bool compress = true,
  }) {
    final pw.Document document = pw.Document(
      title: 'Presupuesto ${project.name}',
      author: 'Planova',
      compress: compress,
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 28),
        header: (pw.Context context) =>
            _header(project, scopeLabel, generatedAt, context),
        footer: _footer,
        build: (pw.Context context) => <pw.Widget>[
          if (rooms.isNotEmpty) ...<pw.Widget>[
            _title('Habitaciones'),
            for (final Room room in rooms) _roomBlock(room, roomPlans[room.id]),
            pw.SizedBox(height: 8),
          ],
          _title('Materiales calculados'),
          if (materialLines.isEmpty)
            _note('No hay habitaciones medidas todavía.')
          else
            _materialsTable(materialLines),
          pw.SizedBox(height: 18),
          if (finishes.isNotEmpty) ...<pw.Widget>[
            _title('Acabados'),
            _finishesTable(finishes),
            pw.SizedBox(height: 18),
          ],
          if (items.isNotEmpty) ...<pw.Widget>[
            _title('Otras partidas'),
            _itemsTable(items),
            pw.SizedBox(height: 18),
          ],
          _summary(summary),
        ],
      ),
    );

    return document.save();
  }

  /// Nombre del archivo a partir del proyecto: `presupuesto-casa-lopez.pdf`.
  static String fileNameFor(Project project) {
    final String slug = project.name
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]+'), '-')
        .replaceAll(RegExp('^-+|-+\$'), '');
    return 'presupuesto-${slug.isEmpty ? 'obra' : slug}.pdf';
  }

  static pw.Widget _header(
    Project project,
    String scopeLabel,
    DateTime generatedAt,
    pw.Context context,
  ) {
    if (context.pageNumber > 1) {
      return pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(bottom: 12),
        child: pw.Text(
          '${project.name} · Presupuesto',
          style: const pw.TextStyle(fontSize: 9, color: _muted),
        ),
      );
    }

    final List<String> details = <String?>[
      project.client,
      project.address,
    ].whereType<String>().toList();

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 18),
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _deepBlue, width: 2)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text(
                'Presupuesto de obra',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: _deepBlue,
                ),
              ),
              pw.Text(
                Formatters.shortDate(generatedAt),
                style: const pw.TextStyle(fontSize: 10, color: _muted),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            project.name,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          if (details.isNotEmpty)
            pw.Text(
              details.join(' · '),
              style: const pw.TextStyle(fontSize: 10, color: _muted),
            ),
          pw.SizedBox(height: 2),
          pw.Text(
            'Alcance: $scopeLabel',
            style: const pw.TextStyle(fontSize: 10, color: _muted),
          ),
        ],
      ),
    );
  }

  static pw.Widget _footer(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'Hecho con Planova · página ${context.pageNumber} de '
        '${context.pagesCount}',
        style: const pw.TextStyle(fontSize: 8, color: _muted),
      ),
    );
  }

  static pw.Widget _title(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: _deepBlue,
        ),
      ),
    );
  }

  static pw.Widget _note(String text) =>
      pw.Text(text, style: const pw.TextStyle(fontSize: 10, color: _muted));

  /// Una habitación: su plano a la izquierda y sus medidas a la derecha.
  static pw.Widget _roomBlock(Room room, Uint8List? planPng) {
    final RoomPlan plan = RoomPlan.of(room);

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: _softGrey,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          if (planPng != null) ...<pw.Widget>[
            pw.Container(
              width: 190,
              height: 135,
              decoration: pw.BoxDecoration(
                color: _white,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Image(pw.MemoryImage(planPng), fit: pw.BoxFit.contain),
            ),
            pw.SizedBox(width: 12),
          ],
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Text(
                  room.name,
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                _fact(
                  'Área de piso',
                  Formatters.squareMeters(plan.floorAreaM2),
                ),
                _fact('Perímetro', Formatters.meters(plan.perimeterMeters)),
                _fact('Altura', Formatters.meters(room.wallHeightMeters)),
                _fact(
                  'Muros sin vanos',
                  Formatters.squareMeters(plan.netWallAreaM2),
                ),
                _fact('Paredes', '${room.walls.length}'),
                if (!plan.isClosed) ...<pw.Widget>[
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'El plano no cierra por '
                    '${Formatters.centimeters(plan.closureGapMeters)}.',
                    style: const pw.TextStyle(fontSize: 8, color: _muted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _fact(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        children: <pw.Widget>[
          pw.Text(
            '$label: ',
            style: const pw.TextStyle(fontSize: 9, color: _muted),
          ),
          pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

  static pw.Widget _materialsTable(List<MaterialLine> lines) {
    return _table(
      headers: <String>[
        'Material',
        'De',
        'Cantidad',
        'Unidad',
        'Precio unitario',
        'Subtotal',
      ],
      rows: <List<String>>[
        for (final MaterialLine line in lines)
          <String>[
            line.kind.label,
            line.kind.surface.label,
            Formatters.quantity(line.quantity),
            line.kind.unit,
            line.hasPrice ? Formatters.money(line.unitPrice) : 'sin precio',
            // La fuente base del PDF no tiene guion largo: aquí va corto.
            line.hasPrice ? Formatters.money(line.subtotal) : '-',
          ],
      ],
      numericFrom: 2,
    );
  }

  /// Qué se le hace a cada grupo de superficies, y lo que cuesta.
  static pw.Widget _finishesTable(List<FinishEstimate> finishes) {
    return _table(
      headers: <String>[
        'Acabado',
        'Dónde',
        'Superficie',
        'Precio por m²',
        'Subtotal',
      ],
      rows: <List<String>>[
        for (final FinishEstimate estimate in finishes)
          <String>[
            estimate.finish.description,
            _whereOf(estimate),
            Formatters.squareMeters(estimate.areaM2),
            Formatters.money(estimate.finish.unitPrice),
            Formatters.money(estimate.total),
          ],
      ],
      numericFrom: 2,
    );
  }

  static String _whereOf(FinishEstimate estimate) {
    final List<String> parts = <String>[];
    if (estimate.walls > 0) {
      parts.add(estimate.walls == 1 ? '1 pared' : '${estimate.walls} paredes');
    }
    if (estimate.floors > 0) {
      parts.add(estimate.floors == 1 ? '1 piso' : '${estimate.floors} pisos');
    }
    return parts.isEmpty ? '-' : parts.join(' y ');
  }

  static pw.Widget _itemsTable(List<BudgetItem> items) {
    return _table(
      headers: <String>[
        'Descripción',
        'Capítulo',
        'Cantidad',
        'Unidad',
        'Precio unitario',
        'Subtotal',
      ],
      rows: <List<String>>[
        for (final BudgetItem item in items)
          <String>[
            item.description,
            item.category.label,
            Formatters.quantity(item.quantity),
            item.unit,
            Formatters.money(item.unitPrice),
            Formatters.money(item.subtotal),
          ],
      ],
      numericFrom: 2,
    );
  }

  static pw.Widget _table({
    required List<String> headers,
    required List<List<String>> rows,
    required int numericFrom,
  }) {
    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      border: null,
      headerStyle: pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: _deepBlue,
      ),
      headerDecoration: const pw.BoxDecoration(color: _softGrey),
      headerAlignment: pw.Alignment.centerLeft,
      headerAlignments: <int, pw.AlignmentGeometry>{
        for (int i = numericFrom; i < headers.length; i++)
          i: pw.Alignment.centerRight,
      },
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.centerLeft,
      cellAlignments: <int, pw.AlignmentGeometry>{
        for (int i = numericFrom; i < headers.length; i++)
          i: pw.Alignment.centerRight,
      },
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      oddRowDecoration: const pw.BoxDecoration(color: _softGrey),
    );
  }

  static pw.Widget _summary(BudgetSummary summary) {
    final double? perSquareMeter = summary.costPerSquareMeter;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: <pw.Widget>[
        pw.Container(
          width: 260,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: _softGrey,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            children: <pw.Widget>[
              _summaryLine('Materiales', summary.materialsTotal),
              _summaryLine('Acabados', summary.finishesTotal),
              _summaryLine('Mano de obra', summary.laborTotal),
              _summaryLine('Otros', summary.otherTotal),
              pw.Divider(color: _muted, height: 14),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text(
                    'Total',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    Formatters.money(summary.total),
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: _deepBlue,
                    ),
                  ),
                ],
              ),
              if (perSquareMeter != null) ...<pw.Widget>[
                pw.SizedBox(height: 4),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    '${Formatters.money(perSquareMeter)} por m² de piso',
                    style: const pw.TextStyle(fontSize: 9, color: _muted),
                  ),
                ),
              ],
            ],
          ),
        ),
        pw.SizedBox(height: 14),
        pw.Text(
          'Las cantidades de material se calculan a partir de las medidas del '
          'plano e incluyen desperdicio. Son una estimación.',
          style: const pw.TextStyle(fontSize: 8, color: _muted),
          textAlign: pw.TextAlign.right,
        ),
      ],
    );
  }

  static pw.Widget _summaryLine(String label, double value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: <pw.Widget>[
          pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
          pw.Text(
            Formatters.money(value),
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
