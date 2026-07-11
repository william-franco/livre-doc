import 'package:go_router/go_router.dart';
import 'package:livre_doc/src/features/editor/routes/editor_routes.dart';
import 'package:livre_doc/src/features/settings/routes/setting_routes.dart';
import 'package:livre_doc/src/features/welcome/routes/welcome_routes.dart';

class Routes {
  static String get home => WelcomeRoutes.welcome;

  GoRouter get routes => _routes;

  final GoRouter _routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: home,
    routes: [
      ...WelcomeRoutes().routes,
      ...EditorRoutes().routes,
      ...SettingRoutes().routes,
    ],
  );
}
