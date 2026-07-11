import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livre_doc/src/common/dependency_injectors/dependency_injector.dart';
import 'package:livre_doc/src/features/welcome/view_models/welcome_view_model.dart';
import 'package:livre_doc/src/features/welcome/views/welcome_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Welcome screen renders Livre Doc title', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    resetDependencies();
    dependencyInjector();
    await initDependencies();

    await tester.pumpWidget(
      MaterialApp(
        home: WelcomeView(welcomeViewModel: locator<WelcomeViewModel>()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Livre Doc'), findsOneWidget);
    expect(find.text('Recent Documents'), findsOneWidget);
  });
}
