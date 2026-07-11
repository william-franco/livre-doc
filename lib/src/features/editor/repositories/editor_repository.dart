import 'dart:convert';

import 'package:livre_doc/src/common/constants/value_constant.dart';
import 'package:livre_doc/src/common/patterns/result_pattern.dart';
import 'package:livre_doc/src/common/services/storage_service.dart';
import 'package:livre_doc/src/features/editor/models/document_model.dart';
import 'package:livre_doc/src/features/editor/repositories/document_repository.dart';
import 'package:livre_doc/src/features/welcome/models/recent_document.dart';

typedef DocumentResult = Result<DocumentModel, Exception>;

abstract interface class EditorRepository {
  Future<DocumentResult> openDocument({String? filePath});
  Future<Result<String, Exception>> saveDocument(DocumentModel document);
  Future<void> shareDocument(DocumentModel document);
  Future<void> exportAsPdf(DocumentModel document);
  Future<void> exportAsDocx(DocumentModel document);
  Future<void> printDocument(DocumentModel document);
  Future<double> readFontSize();
  Future<String> readFontFamily();
  Future<void> persistRecentDocument({
    required String filePath,
    required String title,
  });
}

class EditorRepositoryImpl implements EditorRepository {
  final DocumentRepository documentRepository;
  final StorageService storageService;

  EditorRepositoryImpl({
    required this.documentRepository,
    required this.storageService,
  });

  @override
  Future<DocumentResult> openDocument({String? filePath}) =>
      documentRepository.loadDocument(filePath: filePath);

  @override
  Future<Result<String, Exception>> saveDocument(DocumentModel document) =>
      documentRepository.saveDocument(document);

  @override
  Future<void> shareDocument(DocumentModel document) =>
      documentRepository.shareDocument(document);

  @override
  Future<void> exportAsPdf(DocumentModel document) =>
      documentRepository.exportAsPdf(document);

  @override
  Future<void> exportAsDocx(DocumentModel document) =>
      documentRepository.exportAsDocx(document);

  @override
  Future<void> printDocument(DocumentModel document) =>
      documentRepository.printDocument(document);

  @override
  Future<double> readFontSize() async {
    try {
      final raw = await storageService.getStringValue(
        key: ValueConstant.editorFontSize,
      );
      return double.tryParse(raw ?? '') ?? 15.0;
    } catch (error) {
      throw Exception('EditorRepository: $error');
    }
  }

  @override
  Future<String> readFontFamily() async {
    try {
      return await storageService.getStringValue(
            key: ValueConstant.editorFontFamily,
          ) ??
          'Roboto';
    } catch (error) {
      throw Exception('EditorRepository: $error');
    }
  }

  @override
  Future<void> persistRecentDocument({
    required String filePath,
    required String title,
  }) async {
    try {
      final raw =
          await storageService.getStringListValue(
            key: ValueConstant.recentDocuments,
          ) ??
          [];
      final list = raw
          .map(
            (e) =>
                RecentDocument.fromJson(jsonDecode(e) as Map<String, dynamic>),
          )
          .toList();
      list.removeWhere((d) => d.filePath == filePath);
      list.insert(
        0,
        RecentDocument(
          filePath: filePath,
          title: title,
          lastOpened: DateTime.now(),
        ),
      );
      await storageService.setStringListValue(
        key: ValueConstant.recentDocuments,
        value: list.take(20).map((d) => jsonEncode(d.toJson())).toList(),
      );
      await storageService.setStringValue(
        key: ValueConstant.lastOpenedPath,
        value: filePath,
      );
    } catch (error) {
      throw Exception('EditorRepository: $error');
    }
  }
}
