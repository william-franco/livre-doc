import 'package:flutter/material.dart';
import 'package:livre_doc/src/common/design/app_theme.dart';
import 'package:livre_doc/src/features/editor/models/document_model.dart';
import 'package:livre_doc/src/features/editor/view_models/editor_view_model.dart';
import 'package:livre_doc/src/features/editor/views/widgets/editor_tool_button.dart';

class EditorToolbar extends StatelessWidget {
  final EditorViewModel viewModel;
  final DocumentModel doc;

  const EditorToolbar({
    super.key,
    required this.viewModel,
    required this.doc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      height: 40,
      width: double.infinity,
      color: theme.barColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            EditorToolButton(
              icon: Icons.undo,
              tooltip: 'Undo (Ctrl+Z)',
              theme: theme,
              onPressed: viewModel.canUndo ? viewModel.undo : null,
            ),
            EditorToolButton(
              icon: Icons.redo,
              tooltip: 'Redo (Ctrl+Y)',
              theme: theme,
              onPressed: viewModel.canRedo ? viewModel.redo : null,
            ),
            _divider(theme),
            EditorToolButton(
              icon: Icons.format_bold,
              tooltip: 'Bold',
              theme: theme,
              onPressed: viewModel.toggleBold,
            ),
            EditorToolButton(
              icon: Icons.format_italic,
              tooltip: 'Italic',
              theme: theme,
              onPressed: viewModel.toggleItalic,
            ),
            EditorToolButton(
              icon: Icons.format_underlined,
              tooltip: 'Underline',
              theme: theme,
              onPressed: viewModel.toggleUnderline,
            ),
            EditorToolButton(
              icon: Icons.strikethrough_s,
              tooltip: 'Strikethrough',
              theme: theme,
              onPressed: viewModel.toggleStrikethrough,
            ),
            EditorToolButton(
              icon: Icons.format_quote,
              tooltip: 'Quote',
              theme: theme,
              onPressed: viewModel.toggleQuote,
            ),
            EditorToolButton(
              icon: Icons.code,
              tooltip: 'Code',
              theme: theme,
              onPressed: viewModel.toggleCodeBlock,
            ),
            _divider(theme),
            for (int i = 1; i <= 6; i++)
              EditorToolTextButton(
                text: 'H$i',
                tooltip: 'Heading $i',
                theme: theme,
                onPressed: () => viewModel.toggleHeader(i),
              ),
            _divider(theme),
            EditorToolButton(
              icon: Icons.format_list_bulleted,
              tooltip: 'Bullet List',
              theme: theme,
              onPressed: viewModel.toggleBulletList,
            ),
            EditorToolButton(
              icon: Icons.format_list_numbered,
              tooltip: 'Number List',
              theme: theme,
              onPressed: viewModel.toggleNumberedList,
            ),
            _divider(theme),
            EditorToolButton(
              icon: Icons.link,
              tooltip: 'Link',
              theme: theme,
              onPressed: viewModel.showUnsupportedFeature,
            ),
            EditorToolButton(
              icon: Icons.image,
              tooltip: 'Image',
              theme: theme,
              onPressed: viewModel.showUnsupportedFeature,
            ),
            EditorToolButton(
              icon: Icons.table_chart,
              tooltip: 'Table',
              theme: theme,
              onPressed: viewModel.showUnsupportedFeature,
            ),
            EditorToolButton(
              icon: Icons.insert_emoticon,
              tooltip: 'Emoji',
              theme: theme,
              onPressed: viewModel.showUnsupportedFeature,
            ),
            EditorToolButton(
              icon: Icons.functions,
              tooltip: 'Formula',
              theme: theme,
              onPressed: viewModel.showUnsupportedFeature,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(AppTheme theme) => VerticalDivider(
    indent: 8,
    endIndent: 8,
    color: theme.barIconColor.withValues(alpha: 0.3),
  );
}
