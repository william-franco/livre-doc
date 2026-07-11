import 'package:livre_doc/src/common/constants/value_constant.dart';
import 'package:livre_doc/src/common/services/storage_service.dart';
import 'package:livre_doc/src/features/settings/models/setting_model.dart';

abstract interface class SettingRepository {
  Future<SettingModel> readSettings();
  Future<void> updateTheme({required bool isDarkTheme});
  Future<void> updateFontSize({required double fontSize});
  Future<void> updateFontFamily({required String fontFamily});
}

class SettingRepositoryImpl implements SettingRepository {
  final StorageService storageService;

  SettingRepositoryImpl({required this.storageService});

  @override
  Future<SettingModel> readSettings() async {
    try {
      final isDarkMode = await storageService.getBoolValue(
        key: ValueConstant.darkMode,
      );
      final fontSizeRaw = await storageService.getStringValue(
        key: ValueConstant.editorFontSize,
      );
      final fontFamily = await storageService.getStringValue(
            key: ValueConstant.editorFontFamily,
          ) ??
          'Roboto';

      return SettingModel(
        isDarkTheme: isDarkMode ?? false,
        fontSize: double.tryParse(fontSizeRaw ?? '') ?? 15.0,
        fontFamily: fontFamily,
      );
    } catch (error) {
      throw Exception('SettingRepository: $error');
    }
  }

  @override
  Future<void> updateTheme({required bool isDarkTheme}) async {
    try {
      await storageService.setBoolValue(
        key: ValueConstant.darkMode,
        value: isDarkTheme,
      );
    } catch (error) {
      throw Exception('SettingRepository: $error');
    }
  }

  @override
  Future<void> updateFontSize({required double fontSize}) async {
    try {
      await storageService.setStringValue(
        key: ValueConstant.editorFontSize,
        value: fontSize.toString(),
      );
    } catch (error) {
      throw Exception('SettingRepository: $error');
    }
  }

  @override
  Future<void> updateFontFamily({required String fontFamily}) async {
    try {
      await storageService.setStringValue(
        key: ValueConstant.editorFontFamily,
        value: fontFamily,
      );
    } catch (error) {
      throw Exception('SettingRepository: $error');
    }
  }
}
