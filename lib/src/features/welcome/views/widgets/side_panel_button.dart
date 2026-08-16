import 'package:flutter/material.dart';
import 'package:livre_doc/src/common/design/app_theme.dart';

class SidePanelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppTheme theme;
  final VoidCallback onPressed;
  final bool isPrimary;

  const SidePanelButton({
    super.key,
    required this.icon,
    required this.label,
    required this.theme,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 42),
          ),
        ),
      );
    }
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.barIconColor),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: theme.foregroundText, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
