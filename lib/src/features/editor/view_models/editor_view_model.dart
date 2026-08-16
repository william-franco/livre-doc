import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:livre_doc/src/common/patterns/app_state_pattern.dart';
import 'package:livre_doc/src/common/state_management/state_management.dart';
import 'package:livre_doc/src/features/editor/models/document_delta_codec.dart';
import 'package:livre_doc/src/features/editor/models/document_model.dart';
import 'package:livre_doc/src/features/editor/repositories/editor_repository.dart';

typedef EditorViewState = AppState<DocumentModel>;

typedef _EditorViewModel = StateManagement<EditorViewState>;

abstract interface class EditorViewModel extends _EditorViewModel {
  QuillController get quillController;
  FocusNode get editorFocusNode;
  bool get canUndo;
  bool get canRedo;
  Future<void> initDocument();
  void onDocumentChanged();
  void undo();
  void redo();
  void toggleBold();
  void toggleItalic();
  void toggleUnderline();
  void toggleStrikethrough();
  void toggleHeader(int level);
  void toggleBulletList();
  void toggleNumberedList();
  void toggleQuote();
  void toggleCodeBlock();
  Future<void> save();
  Future<void> share();
  Future<void> exportAsPdf();
  Future<void> exportAsDocx();
  Future<void> printDocument();
  void updateTitle(String newTitle);
  void showUnsupportedFeature();
}

class EditorViewModelImpl extends _EditorViewModel implements EditorViewModel {
  final EditorRepository editorRepository;
  final String? initialFilePath;

  late QuillController _quillController;
  late final FocusNode _editorFocusNode;
  StreamSubscription<dynamic>? _changesSubscription;
  bool _isControllerReady = false;

  EditorViewModelImpl({
    required this.editorRepository,
    this.initialFilePath,
  }) {
    _editorFocusNode = FocusNode();
    _quillController = QuillController.basic();
  }

  @override
  QuillController get quillController {
    if (!_isControllerReady) {
      return QuillController.basic();
    }
    return _quillController;
  }

  @override
  FocusNode get editorFocusNode => _editorFocusNode;

  @override
  bool get canUndo => _quillController.hasUndo;

  @override
  bool get canRedo => _quillController.hasRedo;

  @override
  EditorViewState build() => const InitialState();

  @override
  Future<void> initDocument() async {
    _emit(const LoadingState());

    final fontSize = await editorRepository.readFontSize();
    final fontFamily = await editorRepository.readFontFamily();

    final result = await editorRepository.openDocument(
      filePath: initialFilePath,
    );

    final nextState = result.fold<EditorViewState>(
      onSuccess: (doc) {
        final loaded = doc.copyWith(fontSize: fontSize, fontFamily: fontFamily);
        _loadDeltaIntoController(loaded.contentDelta);
        _listenToDocumentChanges();
        return SuccessState(data: loaded);
      },
      onError: (error) => ErrorState(message: '$error'),
    );

    _emit(nextState);
  }

  void _loadDeltaIntoController(String contentDelta) {
    final delta = DocumentDeltaCodec.decodeDelta(contentDelta);
    _quillController.document = Document.fromDelta(delta);
    _isControllerReady = true;
  }

  void _listenToDocumentChanges() {
    _changesSubscription?.cancel();
    _changesSubscription = _quillController.changes.listen((_) {
      onDocumentChanged();
    });
  }

  @override
  void onDocumentChanged() {
    final current = _currentDoc;
    if (current == null) return;

    final deltaJson = DocumentDeltaCodec.encodeDelta(
      _quillController.document.toDelta(),
    );

    _emit(
      SuccessState(
        data: current.copyWith(
          contentDelta: deltaJson,
          hasUnsavedChanges: true,
        ),
      ),
    );
  }

  @override
  void undo() => _quillController.undo();

  @override
  void redo() => _quillController.redo();

  @override
  void toggleBold() => _formatToggle(Attribute.bold);

  @override
  void toggleItalic() => _formatToggle(Attribute.italic);

  @override
  void toggleUnderline() => _formatToggle(Attribute.underline);

  @override
  void toggleStrikethrough() => _formatToggle(Attribute.strikeThrough);

  @override
  void toggleHeader(int level) {
    final attr = switch (level) {
      1 => Attribute.h1,
      2 => Attribute.h2,
      3 => Attribute.h3,
      4 => Attribute.h4,
      5 => Attribute.h5,
      _ => Attribute.h6,
    };
    _formatToggle(attr);
  }

  @override
  void toggleBulletList() => _formatToggle(Attribute.ul);

  @override
  void toggleNumberedList() => _formatToggle(Attribute.ol);

  @override
  void toggleQuote() => _formatToggle(Attribute.blockQuote);

  @override
  void toggleCodeBlock() => _formatToggle(Attribute.codeBlock);

  void _formatToggle(Attribute attribute) {
    _quillController.formatSelection(attribute);
    onDocumentChanged();
  }

  @override
  Future<void> save() async {
    final current = _currentDoc;
    if (current == null) return;

    final result = await editorRepository.saveDocument(current);

    result.fold(
      onSuccess: (savedPath) async {
        await editorRepository.persistRecentDocument(
          filePath: savedPath,
          title: current.title,
        );
        _emit(
          SuccessState(
            data: current.copyWith(
              filePath: savedPath,
              hasUnsavedChanges: false,
            ),
          ),
        );
        debugPrint('[EditorViewModel] Saved at: $savedPath');
      },
      onError: (error) {
        debugPrint('[EditorViewModel] Save error: $error');
      },
    );
  }

  @override
  Future<void> share() async {
    final current = _currentDoc;
    if (current == null) return;
    await editorRepository.shareDocument(current);
  }

  @override
  Future<void> exportAsPdf() async {
    final current = _currentDoc;
    if (current == null) return;
    await editorRepository.exportAsPdf(current);
  }

  @override
  Future<void> exportAsDocx() async {
    final current = _currentDoc;
    if (current == null) return;
    await editorRepository.exportAsDocx(current);
  }

  @override
  Future<void> printDocument() async {
    final current = _currentDoc;
    if (current == null) return;
    await editorRepository.printDocument(current);
  }

  @override
  void updateTitle(String newTitle) {
    if (newTitle.trim().isEmpty) return;
    _updateDoc(
      (d) => d.copyWith(title: newTitle.trim(), hasUnsavedChanges: true),
    );
  }

  @override
  void showUnsupportedFeature() {
    debugPrint('[EditorViewModel] Feature not yet implemented.');
  }

  DocumentModel? get _currentDoc => state is SuccessState<DocumentModel>
      ? (state as SuccessState<DocumentModel>).data
      : null;

  void _updateDoc(DocumentModel Function(DocumentModel) updater) {
    final current = _currentDoc;
    if (current == null) return;
    _emit(SuccessState(data: updater(current)));
  }

  void _emit(EditorViewState newState) {
    emitState(newState);
    debugPrint('EditorViewModel: $state');
  }

  @override
  void dispose() {
    _changesSubscription?.cancel();
    if (_isControllerReady) {
      _quillController.dispose();
    }
    _editorFocusNode.dispose();
    super.dispose();
  }
}
