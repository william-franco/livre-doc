// ignore_for_file: experimental_member_use

import 'dart:io';

import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';
import 'package:livre_doc/src/features/editor/models/document_delta_codec.dart';
import 'package:livre_doc/src/features/editor/models/document_model.dart';
import 'package:livre_doc/src/features/editor/services/pdf_font_loader.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DocumentExportService {
  Future<pw.Document> _buildPdf(DocumentModel document) async {
    await PdfFontLoader.init();

    final delta = DocumentDeltaCodec.decodeDelta(document.contentDelta);
    final converter = PDFConverter(
      document: delta,
      pageFormat: PDFPageFormat.a4,
      fallbacks: PdfFontLoader.allFonts,
      customHeadingSizes: [32, 26, 22, 18, 16, 14],
      documentOptions: DocumentOptions(
        title: document.title,
        creator: 'Livre Doc',
      ),
      onRequestFontFamily: PdfFontLoader.resolve,
    );

    final doc = await converter.createDocument();
    if (doc == null) {
      throw Exception('DocumentExportService: failed to create PDF.');
    }
    return doc;
  }

  Future<File> exportPdf(DocumentModel document) async {
    final doc = await _buildPdf(document);
    final outFile = await _createExportFile(document.title, 'pdf');
    await outFile.writeAsBytes(await doc.save());
    return outFile;
  }

  Future<File> exportDocx(DocumentModel document) async {
    final outFile = await _createExportFile(document.title, 'docx');
    final escaped = _escapeXml(document.plainText);
    final documentXml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p><w:r><w:t xml:space="preserve">$escaped</w:t></w:r></w:p>
  </w:body>
</w:document>
''';

    await outFile.writeAsString(documentXml, flush: true);
    return outFile;
  }

  Future<void> printDocument(DocumentModel document) async {
    final doc = await _buildPdf(document);
    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  Future<File> _createExportFile(String title, String extension) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'TextEditor', 'exports'));
    if (!await dir.exists()) await dir.create(recursive: true);

    final safeName = title
        .replaceAll(RegExp(r'[^\w\s\-]'), '')
        .trim()
        .replaceAll(' ', '_');
    final name = safeName.isEmpty ? 'export' : safeName;
    return File(p.join(dir.path, '$name.$extension'));
  }

  String _escapeXml(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}
