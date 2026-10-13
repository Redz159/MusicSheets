import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_sheets/features/annotate/annotation_model.dart';
import 'package:music_sheets/services/export_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

Future<Uint8List> _blankPdf(int pages) async {
  final doc = sf.PdfDocument();
  for (var i = 0; i < pages; i++) {
    doc.pages.add().graphics.drawString('Page ${i + 1}', sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 20));
  }
  final bytes = Uint8List.fromList(await doc.save());
  doc.dispose();
  return bytes;
}

void main() {
  test('burnIn draws annotations into the PDF without changing page count', () async {
    final original = await _blankPdf(2);
    final out = await burnIn(original, {
      1: const PageAnnotations([
        InkItem(color: 0xFFD32F2F, width: 0.004, points: [0.1, 0.1, 0.5, 0.4, 0.3, 0.6, 0.6, 0.6, 0.5]),
        InkItem(color: 0x66FFEB3B, width: 0.02, highlighter: true, points: [0.2, 0.5, 0.5, 0.8, 0.5, 0.5]),
        ShapeItem(color: 0xFF1565C0, kind: ShapeKind.rect, width: 0.003, a: Offset(0.1, 0.7), b: Offset(0.4, 0.8)),
        TextItem(color: 0xFF111111, text: 'Capo 2\nÜbergang', pos: Offset(0.5, 0.1), size: 0.03),
        TextItem(color: 0xFF111111, text: 'mf', pos: Offset(0.5, 0.3), size: 0.04, stamp: true),
      ]),
    });
    expect(out.length, greaterThan(original.length));

    final reloaded = sf.PdfDocument(inputBytes: out);
    expect(reloaded.pages.count, 2);
    final text = sf.PdfTextExtractor(reloaded).extractText(startPageIndex: 1, endPageIndex: 1);
    expect(text, contains('Capo 2'));
    expect(text, contains('mf'));
    reloaded.dispose();
  });

  test('safeFileName strips characters not allowed in file names', () {
    expect(safeFileName('Konzert: 12/05 "Live"'), 'Konzert_ 12_05 _Live_');
    expect(safeFileName('   '), 'export');
  });
}
