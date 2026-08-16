import 'package:go_router/go_router.dart';
import 'package:livre_doc/src/features/editor/views/editor_view.dart';

class EditorRoutes {
  static String get editor => '/editor';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: editor,
      builder: (context, state) {
        final filePath = state.extra as String?;
        return EditorView(initialFilePath: filePath);
      },
    ),
  ];
}
