import 'package:go_router/go_router.dart';
import 'package:livre_doc/src/common/dependency_injectors/dependency_injector.dart';
import 'package:livre_doc/src/features/welcome/view_models/welcome_view_model.dart';
import 'package:livre_doc/src/features/welcome/views/welcome_view.dart';

class WelcomeRoutes {
  static String get welcome => '/';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: welcome,
      builder: (context, state) =>
          WelcomeView(welcomeViewModel: locator<WelcomeViewModel>()),
    ),
  ];
}
