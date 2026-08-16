import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:livre_doc/src/common/patterns/result_pattern.dart';
import 'package:livre_doc/src/common/services/file_service.dart';
import 'package:livre_doc/src/common/services/share_service.dart';
import 'package:livre_doc/src/features/editor/models/document_delta_codec.dart';
import 'package:livre_doc/src/features/editor/models/document_model.dart';
import 'package:livre_doc/src/features/editor/services/document_export_service.dart';

typedef DocumentResult = Result<DocumentModel, Exception>;

abstract interface class DocumentRepository {
  Future<DocumentResult> loadDocument({String? filePath});
  Future<Result<String, Exception>> saveDocument(DocumentModel document);
  Future<void> shareDocument(DocumentModel document);
  Future<void> exportAsPdf(DocumentModel document);
  Future<void> exportAsDocx(DocumentModel document);
  Future<void> printDocument(DocumentModel document);
}

class DocumentRepositoryImpl implements DocumentRepository {
  final FileService fileService;
  final ShareService shareService;
  final DocumentExportService exportService;

  DocumentRepositoryImpl({
    required this.fileService,
    required this.shareService,
    required this.exportService,
  });

  @override
  Future<DocumentResult> loadDocument({String? filePath}) async {
    try {
      if (filePath == null) return Success(value: const DocumentModel());

      final raw = await fileService.readFile(filePath);
      final title = fileService.titleFromPath(filePath);
      final contentDelta = fileService.isRichDocument(filePath)
          ? raw
          : DocumentDeltaCodec.encodeDelta(
              DocumentDeltaCodec.plainTextToDelta(raw),
            );

      return Success(
        value: DocumentModel(
          title: title,
          contentDelta: contentDelta,
          filePath: filePath,
        ),
      );
    } catch (error) {
      return Error(error: Exception('DocumentRepository: $error'));
    }
  }

  @override
  Future<Result<String, Exception>> saveDocument(DocumentModel document) async {
    try {
      final String path;
      if (document.filePath != null) {
        path = document.filePath!;
      } else {
        final file = await fileService.createNewFile(document.title);
        path = file.path;
      }

      await fileService.writeFile(
        filePath: path,
        content: document.contentDelta,
      );
      return Success(value: path);
    } catch (error) {
      return Error(error: Exception('DocumentRepository: $error'));
    }
  }

  @override
  Future<void> shareDocument(DocumentModel document) async {
    try {
      if (document.filePath != null) {
        await shareService.shareFile(filePath: document.filePath!);
      } else {
        await shareService.shareText(
          text: document.plainText,
          subject: document.title,
        );
      }
    } catch (error) {
      throw Exception('DocumentRepository: $error');
    }
  }

  @override
  Future<void> exportAsPdf(DocumentModel document) async {
    try {
      final exported = await exportService.exportPdf(document);
      await _openInFilesManager(exported.parent.path);
      debugPrint('[DocumentRepository] exportAsPdf: ${exported.path}');
    } catch (error) {
      throw Exception('DocumentRepository: $error');
    }
  }

  @override
  Future<void> exportAsDocx(DocumentModel document) async {
    try {
      final exported = await exportService.exportDocx(document);
      await _openInFilesManager(exported.parent.path);
      debugPrint('[DocumentRepository] exportAsDocx: ${exported.path}');
    } catch (error) {
      throw Exception('DocumentRepository: $error');
    }
  }

  @override
  Future<void> printDocument(DocumentModel document) async {
    try {
      await exportService.printDocument(document);
    } catch (error) {
      throw Exception('DocumentRepository: $error');
    }
  }

  Future<void> _openInFilesManager(String dirPath) async {
    try {
      await Process.run('xdg-open', [dirPath]);
    } catch (_) {
      debugPrint('[DocumentRepository] xdg-open not available.');
    }
  }
}
