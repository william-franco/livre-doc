import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

class DocumentDeltaCodec {
  static const String emptyDeltaJson = '[{"insert":"\\n"}]';

  static String encodeDelta(Delta delta) => jsonEncode(delta.toJson());

  static Delta decodeDelta(String raw) {
    if (raw.trim().isEmpty) {
      return Delta.fromJson(jsonDecode(emptyDeltaJson) as List);
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return Delta.fromJson(decoded);
      }
      if (decoded is Map<String, dynamic> && decoded['ops'] is List) {
        return Delta.fromJson(decoded['ops'] as List);
      }
    } catch (_) {
      // Falls through to plain-text migration.
    }

    return plainTextToDelta(raw);
  }

  static Delta plainTextToDelta(String text) {
    final document = Document();
    if (text.isNotEmpty) {
      document.insert(0, text);
    }
    return document.toDelta();
  }

  static String deltaToPlainText(String raw) {
    final delta = decodeDelta(raw);
    final document = Document.fromDelta(delta);
    return document.toPlainText();
  }
}
