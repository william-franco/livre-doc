import 'package:flutter/services.dart';
import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfFontLoader {
  static pw.Font? _regular;
  static pw.Font? _bold;
  static pw.Font? _italic;
  static pw.Font? _boldItalic;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    _regular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );
    _bold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );
    _italic = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Italic.ttf'),
    );
    _boldItalic = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-BoldItalic.ttf'),
    );
    _initialized = true;
  }

  static pw.Font get regular {
    _assertInitialized();
    return _regular!;
  }

  static pw.Font get bold {
    _assertInitialized();
    return _bold!;
  }

  static pw.Font get italic {
    _assertInitialized();
    return _italic!;
  }

  static pw.Font get boldItalic {
    _assertInitialized();
    return _boldItalic!;
  }

  static List<pw.Font> get allFonts {
    _assertInitialized();
    return [regular, bold, italic, boldItalic];
  }

  static FontFamilyResponse resolve(FontFamilyRequest request) {
    return FontFamilyResponse(
      fontNormalV: regular,
      boldFontV: bold,
      italicFontV: italic,
      boldItalicFontV: boldItalic,
      fallbacks: allFonts,
    );
  }

  static void _assertInitialized() {
    if (!_initialized) {
      throw StateError('PdfFontLoader.init() must be called before use.');
    }
  }
}
