import 'package:flutter/material.dart';
import 'package:livre_doc/src/common/design/app_theme.dart';
import 'package:livre_doc/src/features/welcome/models/recent_document.dart';

class WelcomeRecentList extends StatelessWidget {
  final List<RecentDocument> documents;
  final AppTheme theme;
  final void Function(String) onOpen;
  final void Function(String) onRemove;

  const WelcomeRecentList({
    super.key,
    required this.documents,
    required this.theme,
    required this.onOpen,
    required this.onRemove,
  });

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      itemCount: documents.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final doc = documents[index];
        return Card(
          color: theme.cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: theme.barIconColor.withValues(alpha: 0.1)),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            leading: Icon(
              Icons.description_outlined,
              color: theme.barActiveColor,
            ),
            title: Text(
              doc.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: theme.foregroundText,
              ),
            ),
            subtitle: Text(
              doc.filePath,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: theme.barIconColor.withValues(alpha: 0.7),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDate(doc.lastOpened),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.barIconColor.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  tooltip: 'Remove from list',
                  onPressed: () => onRemove(doc.filePath),
                ),
              ],
            ),
            onTap: () => onOpen(doc.filePath),
          ),
        );
      },
    );
  }
}
