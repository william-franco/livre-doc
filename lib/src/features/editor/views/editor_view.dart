import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:livre_doc/src/common/design/app_theme.dart';
import 'package:livre_doc/src/common/patterns/app_state_pattern.dart';
import 'package:livre_doc/src/common/state_management/state_management.dart';
import 'package:livre_doc/src/features/editor/models/document_model.dart';
import 'package:livre_doc/src/features/editor/view_models/editor_view_model.dart';
import 'package:livre_doc/src/features/editor/views/widgets/editor_toolbar.dart';
import 'package:livre_doc/src/features/settings/routes/setting_routes.dart';

class EditorView extends StatefulWidget {
  final String? initialFilePath;

  const EditorView({super.key, this.initialFilePath});

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  late final EditorViewModel _vm;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _vm = GetIt.instance.get<EditorViewModel>(
      param1: widget.initialFilePath,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _vm.initDocument();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _vm.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final ctrl = HardwareKeyboard.instance.isControlPressed;
    if (ctrl && event.logicalKey == LogicalKeyboardKey.keyS) {
      _save();
      return KeyEventResult.handled;
    }
    if (ctrl && event.logicalKey == LogicalKeyboardKey.keyZ) {
      _vm.undo();
      return KeyEventResult.handled;
    }
    if (ctrl && event.logicalKey == LogicalKeyboardKey.keyY) {
      _vm.redo();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> _save() async {
    await _vm.save();
    if (mounted) _showSnack('Document saved.');
  }

  void _showRenameDialog(String currentTitle) {
    final controller = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Document'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Document title'),
          onSubmitted: (v) {
            _vm.updateTitle(v);
            Navigator.pop(ctx);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              _vm.updateTitle(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Export As'),
        children: [
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _vm.exportAsDocx();
                if (mounted) {
                  _showSnack('Exported — folder opened in file manager.');
                }
              } catch (e) {
                if (mounted) _showSnack('Export failed: $e');
              }
            },
            child: const ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('Word Document (.docx)'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _vm.exportAsPdf();
                if (mounted) {
                  _showSnack('Exported — folder opened in file manager.');
                }
              } catch (e) {
                if (mounted) _showSnack('Export failed: $e');
              }
            },
            child: const ListTile(
              leading: Icon(Icons.picture_as_pdf_outlined),
              title: Text('PDF Document (.pdf)'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _share() async {
    try {
      await _vm.share();
      if (mounted) _showSnack('Shared — or copied to clipboard on Linux.');
    } catch (e) {
      if (mounted) _showSnack('Share failed: $e');
    }
  }

  Future<void> _print() async {
    try {
      await _vm.printDocument();
    } catch (e) {
      if (mounted) _showSnack('Print failed: $e');
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilderWidget<EditorViewModel, EditorViewState>(
      viewModel: _vm,
      builder: (context, editorState) {
        return switch (editorState) {
          InitialState() || LoadingState() => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          ErrorState(message: final msg) => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_outlined),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Text(
                'Error: $msg',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          SuccessState(data: final doc) => FocusScope(
            onKeyEvent: _handleKeyEvent,
            child: Scaffold(
              appBar: _buildAppBar(context, doc),
              body: Column(
                children: [
                  EditorToolbar(viewModel: _vm, doc: doc),
                  Expanded(child: _buildEditorBody(context, doc)),
                ],
              ),
            ),
          ),
        };
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, DocumentModel doc) {
    final theme = AppTheme.of(context);
    return AppBar(
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        tooltip: 'Back',
        onPressed: () => context.pop(),
      ),
      title: GestureDetector(
        onTap: () => _showRenameDialog(doc.title),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              doc.title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            if (doc.hasUnsavedChanges) ...[
              const SizedBox(width: 6),
              Tooltip(
                message: 'Unsaved changes',
                child: Icon(Icons.circle, size: 8, color: theme.barActiveColor),
              ),
            ],
          ],
        ),
      ),
      actions: [
        Tooltip(
          message: 'Save (Ctrl+S)',
          child: IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: _save,
          ),
        ),
        Tooltip(
          message: 'Share',
          child: IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: _share,
          ),
        ),
        Tooltip(
          message: 'Export',
          child: IconButton(
            icon: const Icon(Icons.upload_file_outlined),
            onPressed: _showExportDialog,
          ),
        ),
        Tooltip(
          message: 'Print',
          child: IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: _print,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Settings',
          onPressed: () => context.push(SettingRoutes.setting),
        ),
      ],
    );
  }

  Widget _buildEditorBody(BuildContext context, DocumentModel doc) {
    final theme = AppTheme.of(context);

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Card(
              color: theme.cardColor,
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 1100),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: doc.fontSize,
                      fontFamily: doc.fontFamily,
                      color: theme.foregroundText,
                    ),
                    child: QuillEditor.basic(
                      controller: _vm.quillController,
                      focusNode: _vm.editorFocusNode,
                      scrollController: _scrollController,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
