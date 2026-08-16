import 'package:flutter/material.dart';

class AppTheme {
  static final AppTheme light = AppTheme._(
    themeData: ThemeData(
      platform: TargetPlatform.linux,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.amber,
      scaffoldBackgroundColor: Colors.grey[100],
    ),
    foregroundText: const Color(0xFF222222),
    cardColor: const Color(0xFFFFFFFF),
    barIconColor: const Color(0xFF454545),
    barColor: const Color(0xFFE0E0E0),
    barActiveColor: const Color(0xFFF59F00),
  );

  static final AppTheme dark = AppTheme._(
    themeData: ThemeData(
      platform: TargetPlatform.linux,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.amber,
      scaffoldBackgroundColor: Colors.grey[900],
    ),
    foregroundText: const Color(0xFFFFFFFF),
    cardColor: const Color(0xFF2C2C2C),
    barIconColor: const Color(0xFFFFFFFF),
    barColor: const Color(0xFF333333),
    barActiveColor: const Color(0xFFFFCA28),
  );

  static AppTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light ? light : dark;

  final ThemeData themeData;
  final Color foregroundText;
  final Color cardColor;
  final Color barIconColor;
  final Color barColor;
  final Color barActiveColor;

  AppTheme._({
    required this.themeData,
    required this.foregroundText,
    required this.cardColor,
    required this.barIconColor,
    required this.barColor,
    required this.barActiveColor,
  });
}
