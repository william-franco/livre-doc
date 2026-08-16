import 'package:flutter/material.dart';
import 'package:livre_doc/src/common/design/app_theme.dart';

class EditorToolButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final AppTheme theme;
  final bool isActive;

  const EditorToolButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.theme,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = onPressed == null
        ? theme.barIconColor.withValues(alpha: 0.25)
        : isActive
        ? theme.barActiveColor
        : theme.barIconColor;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: isActive
              ? BoxDecoration(
                  color: theme.barActiveColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: Center(child: Icon(icon, size: 20, color: color)),
        ),
      ),
    );
  }
}

class EditorToolTextButton extends StatelessWidget {
  final String text;
  final String tooltip;
  final VoidCallback? onPressed;
  final AppTheme theme;
  final bool isActive;

  const EditorToolTextButton({
    super.key,
    required this.text,
    required this.tooltip,
    required this.theme,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? theme.barActiveColor : theme.barIconColor;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 34,
          height: 36,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: isActive
              ? BoxDecoration(
                  color: theme.barActiveColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.0,
                color: color,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
