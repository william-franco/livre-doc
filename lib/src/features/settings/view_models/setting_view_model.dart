import 'package:flutter/foundation.dart';
import 'package:livre_doc/src/common/state_management/state_management.dart';
import 'package:livre_doc/src/features/settings/models/setting_model.dart';
import 'package:livre_doc/src/features/settings/repositories/setting_repository.dart';

typedef _SettingViewModel = StateManagement<SettingModel>;

abstract interface class SettingViewModel extends _SettingViewModel {
  Future<void> loadSettings();
  Future<void> changeTheme({required bool isDarkTheme});
  Future<void> changeFontSize(double fontSize);
  Future<void> changeFontFamily(String fontFamily);
}

class SettingViewModelImpl extends _SettingViewModel implements SettingViewModel {
  final SettingRepository settingRepository;

  SettingViewModelImpl({required this.settingRepository});

  @override
  SettingModel build() => SettingModel();

  @override
  Future<void> loadSettings() async {
    final model = await settingRepository.readSettings();
    _emit(model);
  }

  @override
  Future<void> changeTheme({required bool isDarkTheme}) async {
    await settingRepository.updateTheme(isDarkTheme: isDarkTheme);
    _emit(state.copyWith(isDarkTheme: isDarkTheme));
  }

  @override
  Future<void> changeFontSize(double fontSize) async {
    await settingRepository.updateFontSize(fontSize: fontSize);
    _emit(state.copyWith(fontSize: fontSize));
  }

  @override
  Future<void> changeFontFamily(String fontFamily) async {
    await settingRepository.updateFontFamily(fontFamily: fontFamily);
    _emit(state.copyWith(fontFamily: fontFamily));
  }

  void _emit(SettingModel newState) {
    emitState(newState);
    debugPrint('SettingViewModel: $state');
  }
}
