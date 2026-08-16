import 'package:livre_doc/src/features/editor/models/document_delta_codec.dart';

class DocumentModel {
  final String title;
  final String contentDelta;
  final String? filePath;
  final bool hasUnsavedChanges;
  final double fontSize;
  final String fontFamily;

  const DocumentModel({
    this.title = 'Untitled Document',
    this.contentDelta = DocumentDeltaCodec.emptyDeltaJson,
    this.filePath,
    this.hasUnsavedChanges = false,
    this.fontSize = 15.0,
    this.fontFamily = 'Roboto',
  });

  String get plainText => DocumentDeltaCodec.deltaToPlainText(contentDelta);

  DocumentModel copyWith({
    String? title,
    String? contentDelta,
    String? filePath,
    bool? hasUnsavedChanges,
    double? fontSize,
    String? fontFamily,
  }) =>
      DocumentModel(
        title: title ?? this.title,
        contentDelta: contentDelta ?? this.contentDelta,
        filePath: filePath ?? this.filePath,
        hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
        fontSize: fontSize ?? this.fontSize,
        fontFamily: fontFamily ?? this.fontFamily,
      );
}
