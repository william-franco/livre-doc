class SettingModel {
  final bool isDarkTheme;
  final double fontSize;
  final String fontFamily;

  SettingModel({
    this.isDarkTheme = false,
    this.fontSize = 15.0,
    this.fontFamily = 'Roboto',
  });

  SettingModel copyWith({
    bool? isDarkTheme,
    double? fontSize,
    String? fontFamily,
  }) =>
      SettingModel(
        isDarkTheme: isDarkTheme ?? this.isDarkTheme,
        fontSize: fontSize ?? this.fontSize,
        fontFamily: fontFamily ?? this.fontFamily,
      );
}
