import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livre_doc/src/common/design/app_theme.dart';
import 'package:livre_doc/src/common/patterns/app_state_pattern.dart';
import 'package:livre_doc/src/common/state_management/state_management.dart';
import 'package:livre_doc/src/features/editor/routes/editor_routes.dart';
import 'package:livre_doc/src/features/settings/routes/setting_routes.dart';
import 'package:livre_doc/src/features/welcome/models/recent_document.dart';
import 'package:livre_doc/src/features/welcome/view_models/welcome_view_model.dart';
import 'package:livre_doc/src/features/welcome/views/widgets/welcome_empty_widget.dart';
import 'package:livre_doc/src/features/welcome/views/widgets/welcome_recent_list.dart';
import 'package:livre_doc/src/features/welcome/views/widgets/welcome_side_panel.dart';

class WelcomeView extends StatefulWidget {
  final WelcomeViewModel welcomeViewModel;

  const WelcomeView({super.key, required this.welcomeViewModel});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.welcomeViewModel.loadRecent();
    });
  }

  void _openEditor({String? filePath}) {
    context.push(EditorRoutes.editor, extra: filePath).then((_) {
      if (mounted) widget.welcomeViewModel.loadRecent();
    });
  }

  Future<void> _openFilePicker() async {
    final path = await widget.welcomeViewModel.pickDocumentFile();
    if (path != null && mounted) {
      _openEditor(filePath: path);
    }
  }

  void _confirmClearRecent() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear recent documents?'),
        content: const Text('All entries will be removed from the list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              widget.welcomeViewModel.clearRecent();
              Navigator.pop(ctx);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      body: Row(
        children: [
          WelcomeSidePanel(
            theme: theme,
            onNewDocument: () => _openEditor(),
            onOpenFile: _openFilePicker,
            onSettings: () => context.push(SettingRoutes.setting),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
                  child: Row(
                    children: [
                      Text(
                        'Recent Documents',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      StateBuilderWidget<WelcomeViewModel, WelcomeState>(
                        viewModel: widget.welcomeViewModel,
                        builder: (context, welcomeState) {
                          final hasItems =
                              welcomeState
                                  is SuccessState<List<RecentDocument>> &&
                              welcomeState.data.isNotEmpty;
                          return hasItems
                              ? TextButton.icon(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 16,
                                  ),
                                  label: const Text('Clear all'),
                                  onPressed: _confirmClearRecent,
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: StateBuilderWidget<WelcomeViewModel, WelcomeState>(
                    viewModel: widget.welcomeViewModel,
                    builder: (context, welcomeState) {
                      return switch (welcomeState) {
                        InitialState() => const SizedBox.shrink(),
                        LoadingState() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        SuccessState(data: final docs) when docs.isEmpty =>
                          WelcomeEmptyWidget(
                            onNewDocument: () => _openEditor(),
                          ),
                        SuccessState(data: final docs) => WelcomeRecentList(
                          documents: docs,
                          theme: theme,
                          onOpen: (path) => _openEditor(filePath: path),
                          onRemove: widget.welcomeViewModel.removeRecent,
                        ),
                        ErrorState(message: final msg) => Center(
                          child: Text(
                            'Error: $msg',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      };
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
