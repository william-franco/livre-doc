import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livre_doc/src/common/state_management/state_management.dart';
import 'package:livre_doc/src/features/settings/models/setting_model.dart';
import 'package:livre_doc/src/features/settings/view_models/setting_view_model.dart';

class SettingView extends StatelessWidget {
  final SettingViewModel settingViewModel;

  const SettingView({super.key, required this.settingViewModel});

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationIcon: const FlutterLogo(),
      applicationName: 'Livre Doc',
      applicationVersion: 'Version 1.0.0',
      applicationLegalese: '\u{a9} 2026',
    );
  }

  @override
  Widget build(BuildContext context) {
    const fontFamilies = ['Roboto', 'Ubuntu', 'Liberation Serif', 'Courier'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Dark theme'),
            trailing: StateBuilderWidget<SettingViewModel, SettingModel>(
              viewModel: settingViewModel,
              builder: (context, settingModel) {
                return Switch(
                  value: settingModel.isDarkTheme,
                  onChanged: (bool isDarkTheme) {
                    settingViewModel.changeTheme(isDarkTheme: isDarkTheme);
                  },
                );
              },
            ),
          ),
          StateBuilderWidget<SettingViewModel, SettingModel>(
            viewModel: settingViewModel,
            builder: (context, settingModel) {
              return ListTile(
                leading: const Icon(Icons.format_size_outlined),
                title: Text('Font size (${settingModel.fontSize.round()})'),
                subtitle: Slider(
                  min: 12,
                  max: 28,
                  divisions: 16,
                  value: settingModel.fontSize,
                  onChanged: settingViewModel.changeFontSize,
                ),
              );
            },
          ),
          StateBuilderWidget<SettingViewModel, SettingModel>(
            viewModel: settingViewModel,
            builder: (context, settingModel) {
              return ListTile(
                leading: const Icon(Icons.font_download_outlined),
                title: const Text('Font family'),
                trailing: DropdownButton<String>(
                  value: fontFamilies.contains(settingModel.fontFamily)
                      ? settingModel.fontFamily
                      : fontFamilies.first,
                  items: fontFamilies
                      .map(
                        (family) => DropdownMenuItem(
                          value: family,
                          child: Text(family),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settingViewModel.changeFontFamily(value);
                    }
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }
}
