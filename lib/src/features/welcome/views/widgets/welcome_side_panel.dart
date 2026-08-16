import 'package:flutter/material.dart';
import 'package:livre_doc/src/common/design/app_theme.dart';
import 'package:livre_doc/src/features/welcome/views/widgets/side_panel_button.dart';

class WelcomeSidePanel extends StatelessWidget {
  final AppTheme theme;
  final VoidCallback onNewDocument;
  final VoidCallback onOpenFile;
  final VoidCallback onSettings;

  const WelcomeSidePanel({
    super.key,
    required this.theme,
    required this.onNewDocument,
    required this.onOpenFile,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: theme.barColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.edit_document,
                    color: theme.barActiveColor,
                    size: 26,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Livre Doc',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.foregroundText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SidePanelButton(
              icon: Icons.add,
              label: 'New Document',
              theme: theme,
              isPrimary: true,
              onPressed: onNewDocument,
            ),
            const SizedBox(height: 8),
            SidePanelButton(
              icon: Icons.folder_open_outlined,
              label: 'Open File',
              theme: theme,
              onPressed: onOpenFile,
            ),
            const Spacer(),
            SidePanelButton(
              icon: Icons.settings_outlined,
              label: 'Settings',
              theme: theme,
              onPressed: onSettings,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
