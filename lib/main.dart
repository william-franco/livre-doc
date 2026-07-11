import 'package:flutter/material.dart';
import 'package:livre_doc/src/common/dependency_injectors/dependency_injector.dart';
import 'package:livre_doc/src/common/design/app_theme.dart';
import 'package:livre_doc/src/common/routes/routes.dart';
import 'package:livre_doc/src/common/state_management/state_management.dart';
import 'package:livre_doc/src/features/settings/models/setting_model.dart';
import 'package:livre_doc/src/features/settings/view_models/setting_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dependencyInjector();
  await initDependencies();
  final Routes appRoutes = Routes();
  runApp(
    MyApp(
      appRoutes: appRoutes,
      settingViewModel: locator<SettingViewModel>(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Routes appRoutes;
  final SettingViewModel settingViewModel;

  const MyApp({
    super.key,
    required this.appRoutes,
    required this.settingViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return StateBuilderWidget<SettingViewModel, SettingModel>(
      viewModel: settingViewModel,
      builder: (context, settingModel) {
        return MaterialApp.router(
          title: 'Livre Doc',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light.themeData,
          darkTheme: AppTheme.dark.themeData,
          themeMode: settingModel.isDarkTheme
              ? ThemeMode.dark
              : ThemeMode.light,
          routerConfig: appRoutes.routes,
        );
      },
    );
  }
}
